Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B41571EA6
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiGLPOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiGLPOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:14:09 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2060.outbound.protection.outlook.com [40.107.20.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D59D13BB;
        Tue, 12 Jul 2022 08:06:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzYTt9moI8eWFEtwzNjytWlZuAQvsxxORf6kpfujHVWqXpVbux0QU6/KKwAwfEWIPLonqKBacuJQHlkTcQXZUYuJCZKx0oI+2BH7BoXf8AypKk2NUDYgNtyOmf1ft91+TaeQbDQB+rEg6+o8bH32zg43QRpY+/Im9WHV69QYMBKp0rkAPc77qoXi7gl6nJn+b+lMpusEUbtlc1Ui+CyNjhO6ltahObsJVUVrx9X/gq+LizhbsMC6rqmr06fkLsG8MC71YWVt0l/Gsqq3P1mDLd5kExdf2uthXXET9ghuUXceHzyHbRMTaWe4k/QGOUYwSNnFDvt8gV2EnIJz7lOnOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAJs1kmKljPLcF1VnhvA0z86k/cBtBvSPl5TBiKOVPY=;
 b=gxSxVduKgzaEcDb/CPRjHUZHkIkpAVOuBeznE7njJ4BUUcG2TxLM1Fg0+oCAsMmquyBkOJMxIuiuKbK1uKF6mKjCojibzMrGLK+Q/tD4/rgzpBzPowU++/b0Z7ZhzRybVwssTd7dAmDjGlf+t7K0umc7BPEdCjqWZODL6A6E6dZ8iNPVo8xk5ZQWF7/4No/cacnQ+GREHtCxjoFxRLnZ/wmBaQT3qSr81uF7MyqJ3CitT4vbrCMUDpN5JM3auA2cKdiQRqVxZWp1ucHpBu0dvcSAeFauqFyqKNE7xLBq4Ry2+kPnFY1Cy8T9GWOaXMXaeHHTt9YrlE6wEp+/dA1S0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAJs1kmKljPLcF1VnhvA0z86k/cBtBvSPl5TBiKOVPY=;
 b=NoMv8Bp9Sqnx8eEpGN6wnLTzQ2T5taqgVzu25WLigU4Vpk+CwA7Ce/fo+HkyjJsVulM2ZAZOYZ8TlFeyTgmIYU2hBhNFZe6cIeysTGqOh/CMe7TgtF7giy+fbq9EOnShR4VpYXUp8KmU3q3JkTh2UxMUJRT7b/JQU0SXm2YHVHnYnXnQcTzz6fFzJ4cQLew1NcKzs6fF9xWE44qVlfpXevkNq9c+dMoTciV8O4tI/Pct2dOvfpXeFni6uoMQmqxGTa7HQpFoXpLdJJhD/QG9YK5fTVopbN+4YcFwA1kNBCRQ+LWhqaUWXMhNSZItLufjK3dZgBGcFhHRTG70O6huyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB6961.eurprd03.prod.outlook.com (2603:10a6:20b:280::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 15:06:55 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:06:55 +0000
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: Add lynx PCS
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-2-sean.anderson@seco.com>
 <4584120c-8e6f-6943-1bd3-aa6942525eda@linaro.org>
 <a6b2d031-8356-492b-8eef-a7cdfacaba51@seco.com>
 <b46f49e4-355d-7a59-4a4a-f5c77b6835df@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <73415f21-7c48-b9b0-e02f-c83d0a185718@seco.com>
Date:   Tue, 12 Jul 2022 11:06:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b46f49e4-355d-7a59-4a4a-f5c77b6835df@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0011.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5513e4f8-e97a-4f27-36c8-08da641828e0
X-MS-TrafficTypeDiagnostic: AM9PR03MB6961:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFAi5MyC1wBTH44sIAORF8aoGKpL00GN+alMXEtQbhc3ZjpzOSubQFslqcKbrEUe5/toS6rz7DZeEVUU9eVXwf+eM6JW6KhDEv3mNDhHHPbUfgZQ8M0NPSW3y2vAe03eIa2XvYf4OSY0XuUyRSwTPAp7L2Ne/2o3xAVcUDbYjDs+hA9wfzH7/vpg0hgiXt/YhS/Ah1P0ItMRew8OhJ1N/UWzMQajCJoYuq6VT0mfO2mFeXN+p6Gl6LE1rpjjgs2XdfYJVGfOOKb5K5gkSxNNuqbZMzp7DSxxQakFqywJTE9eUT2rQIW/eOkX0kRkOUSYbP4bSQibfIkpN774RDTP1HlfuAA0shCBxs6AH341CQq966cc6LxhDXt1GymbFEgkpjogsN040BZKppL/EKUMVyrZKSCLwj1ZfBUgGt3yLrWRiGhIZY0i4WbTKSrpWRKc6piuWHC8YWm8PeeCeJ36CwZ7MEHzHGi6Q3/PbEeT5MRCizdZ6Ay/vHoiE2GBerQPhfqBSK8FhSKbRIIsFANzIT3tcyKlfBKWGZijWfQsvb2/qJZwPM9yk9IAG46Wzi8NGHL3AX95ZrTT5bvjW99zUUF2hycHGVpu9hkzFDCT2Hq5ffAi65SRUiX/Jo0qQOTZqvGvs7yDnYBr6nc7+z/EBVU+MgjuCToPy7aJx4At72enaxZCdSAh0aBzh5Kbk3lSTMDUJHOa3BJqweDC2NlXeIwLFlACe8eCg9x9yHVRjAbhqMKVF7dmX81D+5QZ4FwrfPt8A8AxjhdDVcwEzSZ2XkQVA9L11YpXOCeAbcRgXTBYKLvlrd1GrILv6rjswPGsDHSiyr1oSMhd1O1yoHXG+5ZZcwWQFeo0gjTjQEa4wTyzS4bHGcQLMy/h5zGAAQJE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39850400004)(366004)(136003)(376002)(396003)(186003)(2616005)(53546011)(26005)(52116002)(6512007)(6506007)(2906002)(38350700002)(86362001)(31696002)(110136005)(8676002)(4326008)(66476007)(54906003)(6666004)(41300700001)(5660300002)(38100700002)(6486002)(316002)(66556008)(44832011)(31686004)(7416002)(478600001)(36756003)(66946007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVdDZXRhVlBwSVRONWdBQmQvS3k4R1BTZGFjOVFIbUppd2dIQTJJZ3J4Ym5K?=
 =?utf-8?B?a1hndU9GdGhSRnN6TlVZbjlYTWwxM0hOeHVTeTB6UmtHUzZ6MnN5cTJrdDZh?=
 =?utf-8?B?L0FZSW5OdVRKV1g1UmFFWXVHRlVpb0xnWnpJZ3dYM0djcnRkcm95elVYNUlP?=
 =?utf-8?B?Qk5lendkQjBPS1NjV1BoUVk3dkQwVWh0dC9XTEhqR3RXOTA2bzBpajJxN08v?=
 =?utf-8?B?NU1tM0hYbFlpaXI4cWwrNlRUKzRCY3Q4RjFFUXkycmxRQXJZY1RpSzBNZEJP?=
 =?utf-8?B?NHRUMXpuS2xIQlB4dFBmdFBaMmoyWVBDRW9GZW4vTzFENC9pQVZScHZVeGJD?=
 =?utf-8?B?bnZnMVJGOGVSZi8rajhyejc0UkVVYzBhaXZhTW1jbnlDNE5IbTR4RE05aTJY?=
 =?utf-8?B?NlZtSjVDV3RoNUEwM0c3YWFYRkp1M1N2Y0NVT2kyVXZjWFBKRTVaamtLWlBL?=
 =?utf-8?B?QUtsaitycXBMMWRrc1AwQlNwMkhCNkJDZnFOL2JiY1FiNC8yMTdTamNCNU5V?=
 =?utf-8?B?N2RZNEdxSFhzRWJXY2hqd2REQ256RG81VU9iZVBIMW5wZGF4dHlLV0duY2dC?=
 =?utf-8?B?cThMY0JEUnBURUozbk04ektWN2RpUEpVeXB1b3JRRzB4QWgxaXlzUHIvOUpD?=
 =?utf-8?B?NFB2dWxjcGNxYm5sZWozbFowTlNwTzZ3NmpTMjgyUEg1UmtIQkFxa3dlUGE0?=
 =?utf-8?B?bGdqNi9OQVRaR1Q5SWQ3OGpqUllQNEJ0YU0yV2ZIeUw0cncvbDNodHRqYld1?=
 =?utf-8?B?VGp4VDVTeU5yNDN6MW0wRFhDcXlMVkdPTHBqQ2QyUFhMaVZBQUhIUGhoMVRX?=
 =?utf-8?B?M1FKOERhRXVYY1c0MkhJbElMQ0FXTFlZQzNZWkFyU1lGT2p3TkxtUjUzYTJk?=
 =?utf-8?B?WUZ2SmpRLzdzQWgrK3YxeGg0RUt1L29jajJlUUpydDEyU3F6SDVzTlk2ek1K?=
 =?utf-8?B?dDVSV29QcytDTVljOGM2OUY2Z2p5Sk9oQzlXM2NucmlBRGxVaklKWTJmUlpN?=
 =?utf-8?B?S2ljYXdQcVY2eFZySXdEalE3OW95eFZNb0RxTzVIanhaTFEyOXU0WW1ZVVZR?=
 =?utf-8?B?VUp0UVBwQkREc0gwSkhzd01WVmhXazkyTmtSc3RuUjVneWMvL1B4V1B6REtL?=
 =?utf-8?B?aEs2UDlERG9VbkV0QVZjSTQ0eUJCTGllVitRWk9RVEk5NlZMQXlaMWxrb0d3?=
 =?utf-8?B?Qi9EQWN6ZE05ZE9VU0J2cS9MZmxJdEgxNTV0ZkdGUzdLUlJTVnhNdGFiZ3V1?=
 =?utf-8?B?bzlwTXdzWnRQRUUwbDcvOFhRNnA2ZHRRZC9uNmJYS0lId0duU1MySWFseFRD?=
 =?utf-8?B?dmFBNS8ya3pZa0lGWWdwNkJNUCtUS29oaHdjSUkwQTV4U2gyUzkvYXdHUG9l?=
 =?utf-8?B?K2dDcXRIOFpHaTJXNVlnRWh5QVJocmhkZHhGWlZ0eXV3QU1rNmFBb0lid3Bw?=
 =?utf-8?B?T3JUTEhPUUR4NmxFTU1RTk4rQllMY0NkK2doa0VGekZNRldTU1JzZUdJcXJk?=
 =?utf-8?B?cGxlMm9CL3I4MWFjRkNYdzc3UWhiZCsyZUNSY0pvU0FzOUpQMFJKdDB3dzhL?=
 =?utf-8?B?MFBET2M4SmRNQm5ZNEhpYUVDK00vemQ5ZDNGQ1pRNk5GRThTODJsZFRvK09E?=
 =?utf-8?B?RDFqdkhpNk83d2EyUlJzaG5mVEFQZ0NUZW85aUtjb1VXR2svL2FXRUxxVXRO?=
 =?utf-8?B?eE9STGpmc3ZoWnNsMXV6S3d0T0JYNWYzSmxld3lUQS9wdC9uSXhwODFCVFJt?=
 =?utf-8?B?MU5SMFdWL1UzT1lJRThGQlczUkhqcUhyTWxINGhCZWpUcU1aR0xhcmZoUW84?=
 =?utf-8?B?R1BlbWROS0RzZEwzVW13TWJlc24zT0Q3VEE2TmxqV29HY25UeTF2dllHcjVW?=
 =?utf-8?B?VkhqMC9vbS96Qm1OZTVtQ2c0NW5oYllzOXkxSmxHM1JEZGRBbEdIWUVEaFQ0?=
 =?utf-8?B?dFlQbGkvY0xuTVAzdk1HSTMwRitJei9KR1lDZk9xZ3EzUlpoRUU3MG5aYk1M?=
 =?utf-8?B?ZlVZNUpWWVNsNnFwQ3dFMC82VE1LcGxidGFBdTM4OU05RlNaRW43STBwUnR2?=
 =?utf-8?B?cVpNcG50U0FFTFlSWDlRS1NBRzByRXhmb1lPNmVXZDV5WElTdmM0bStOYUpq?=
 =?utf-8?B?WDBTYVVDdFNWQWxaRTRIZVpXa01HOUQrbFBLbExBTGEyQWI2MDN1SExiSHhv?=
 =?utf-8?B?VWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5513e4f8-e97a-4f27-36c8-08da641828e0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 15:06:55.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfrmUTqW0TKtPqNxV8mrMC4pJyxRMHB2le4+aMNcKmRUkaQMPRN5Yd6sjFlaNhhO4heWosZmdY8Byx1UieXxsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6961
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 11:00 AM, Krzysztof Kozlowski wrote:
> On 12/07/2022 16:57, Sean Anderson wrote:
>> Hi Krzysztof,
>> 
>> On 7/12/22 4:47 AM, Krzysztof Kozlowski wrote:
>>> On 11/07/2022 18:05, Sean Anderson wrote:
>>>> This adds bindings for the PCS half of the Lynx 10g/28g SerDes drivers.
>>>>
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> ---
>>>>
>>>>  .../devicetree/bindings/net/fsl,lynx-pcs.yaml | 47 +++++++++++++++++++
>>>>  1 file changed, 47 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
>>>> new file mode 100644
>>>> index 000000000000..49dee66ab679
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
>>>
>>> Shouldn't this be under net/pcs?
>> 
>> There's no net/pcs, since this is the first of its kind. 
> 
> There is, coming via Renesas tree.

Ah, I will move this then.

--Sean
