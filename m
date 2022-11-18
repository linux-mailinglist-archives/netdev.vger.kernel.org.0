Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229B462F9C6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiKRP53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiKRP52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:57:28 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150070.outbound.protection.outlook.com [40.107.15.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3207D517
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:57:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZU+BfOP5zq1NXlJjxqskep4lcyhkxnMm56yyNlZQiYISkEMojbMG9vfEgXFAEl1Av+9WuGQ9YY8wit7QApvZNrnw2kCr7/qiOnwB0goAEsdFqI1ofLO6xiG8tf1SXKVeKW39JCvSrLWSWU+iFFX7PzynoHWXlFHmgCybzmUw+GjPVDhL5EasRySHwm8uCo58gJvLj9Foyl28sz+qmD+9uY0TxdwyB6hwtvDX43Cexj74HIcLKt5Mf6mjWn1JjQq9FrKR1dmUeQQ/yt9jDcexp3/+J/nza/g80NjXMEgv0r0Ybdm0/BICYwYBA0lGxj7blczonXQQM0WtDQrCHdgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5k0cDrKSgqvAQgznfqHyT1VBhAWisdDlT2InWYUvOg=;
 b=eO4fixsiu5ficyQ7n5yNoZ8ytCdrvA0N0dJLBa+zr6AiDzzjVcXTYnO60WLDrtvVHol1HndxbGaygyYNmlg9eUSe6oqzRGDvUR41hqB3Vmkd6qSF9yRzElDJrX5jvcN28XqnSPjdGiwWVUmpKX2aN70hgVB5nByU9OBHHrxpFoR7uXMHdtCQ6zUA7Gg/56rahUPer70TlPAxFEoClgD2kgQcl3s89BU4E1suyec9F1wZcQuiZl4z5IVEp2yWEZyqISlwHgcok23AbG9557coUgXPLzQJmyk6r4KNLzIHS/f75IiH9xaID5Rt4po8wUHx13rPuB2O07NKWWZc0a2axQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5k0cDrKSgqvAQgznfqHyT1VBhAWisdDlT2InWYUvOg=;
 b=OojnqDKPOo/nZpb4FEs16YKVYYXPRiusiCjifHPfvZExhs3N8JN92jX4lpTh2yvPNyrOKsxbRc1ZDzatY758IgvX2yOxdkaxlg1NiQK3pCkSc58aRgzS4xOelpKHLRtqcViGZFFePEhT0WMvrnCaOo5OzbM+lqqe0x9Cb4/9wUydqEM+7krQL9lK8hLO36VBHutqhLNRZ9Qibd/6nqdlAqELYN7QXaAgq4CN3i/rZBlaTrnzlak+sNYaO/vWK3pRZYzNdU+ejABGPtZCzMEiTMFk/taRHeuGqPAROFfqlilpwbCETY3G18eMejcvIcAdp4BP4U54BJyqeSFfWY6e8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB6144.eurprd03.prod.outlook.com (2603:10a6:800:141::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Fri, 18 Nov
 2022 15:57:25 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 15:57:25 +0000
Message-ID: <495daec3-8bda-cbb3-3cf2-7c07256dd14a@seco.com>
Date:   Fri, 18 Nov 2022 10:57:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method to
 query PHY in-band autoneg capability
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
 <20221118154241.w52x6dhg6tydqlfm@skbuf>
 <0e921aaa-6e71-ba16-faf7-70a4bac5be23@seco.com>
 <20221118155614.uswrmo65ap4i3hih@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221118155614.uswrmo65ap4i3hih@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::10) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|VI1PR03MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: 04b85081-5f3a-47de-14a7-08dac97d95ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ysQsDBILYyhQrkDewDB24B2hLokWsZVtrlkB5Jx5d9eAl3FJpxj5g6m1eaV5ra3r0EXawpT8w9EYDflbeMcpCNUJYYHXBeNdqD2gLAwKpPma3HC20zmqsj8FkVvHpyqfAPfVqJVHKOZT5swtJq05Pw3GmQ+v+Y8qi484msUVIBufqh6FtGw+5XCuJ7JyNv24UI3qDiNTqwcJuwNHEA62/GhCJweg35OmHu9SOT98XMWyYoQLxgBVDfRA6XHdVQYCv/7zJtXsmt65xXp4g4YWYQhv0rPcINg3CR2z1526g4anarKydfC5ERTpP9NUJkHS2nMZgBOVbgP/XA2t8J58QvmMKiFgFV2nyQos31fNe57yOVaNfDOR6hotszV4MT09r0JM6TIj33KY9NiCQDcyWVh3T6k4ohpgeGl7rKJulVwo8bTjV7TEm5g2TAAwP+a3/QVXpL0TqObJw3+9judsw3VXaog5bv+VrAtDyvn9/M4f0SrjP+Ib0F/q0IG2ULDaigmlb5XqBcZT5En1/bXDHs7Kvm1zE8ispRUeP5hoZ4dCQe6iFz4wXeU64KAJggaRoiH8YjYL8LV4KB5Cnjgm7zeJqeiYZsm8O9ASMTJs9YUT3L8HwZp3bOA2j7696sPXb1lI/xIhwTS4qsaThb1LeybGIQJS7PPJAsaWY35h93FMO1hY0s4tECvZ+FcdHWUhAdl8fN96w5BUWbeqDRo8Vy5JZwlKTcNcbe0AcO4/HPKOKj90d/YvVZ4YISsUONcNv9vIgrfjnIZniy4FckKbKg/epIPSsjKGCw37Haq9EEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39840400004)(376002)(451199015)(6666004)(6506007)(2906002)(6916009)(54906003)(6512007)(26005)(53546011)(31686004)(52116002)(66476007)(66946007)(41300700001)(8676002)(2616005)(4326008)(5660300002)(8936002)(186003)(6486002)(7416002)(478600001)(44832011)(4744005)(83380400001)(66556008)(86362001)(31696002)(316002)(36756003)(38100700002)(38350700002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGNCamRZa1NXNW5CM0hlS2wzTFBJcmlEMGJyUERvNlpvY1lSdWlWVGN0cVI4?=
 =?utf-8?B?c2REZWR2d2hITlUzd1N4ZE1sK0c0bU9rU2U4V0Evekl4SEhsajdUaU5NVGhX?=
 =?utf-8?B?ZVlGdVNtNlRqQTdzbWFLa0kyZWtid2FiQTh5WTh4eUhqbXJ1eE9NMThmcVMx?=
 =?utf-8?B?aEFibEFreFpkdW80MnBzM0lYQnRBYmg4RW5CZGc5dHZyWFlxNFVQcVM0QWdF?=
 =?utf-8?B?MldNZUtCVWdxbmYvcHZaZW5PL2dHMkQ1ZnFmOEtzZUNRQ1NXMjk0elltVlhJ?=
 =?utf-8?B?ekQzZzh0T3JteHloaC91ZUgrZXN4c1RiNWszdHNsbXNCVm9hVE9seWxnTFcz?=
 =?utf-8?B?aFhkMUl0eEtDVmZxVklRN0dHSTE3VjJBbEVWOTVmMXFQVW02ckl6cmJwakV2?=
 =?utf-8?B?Z1BaRjVZQzIxWWYxWWtNZ2VrTmdjSGpkNnZyc3V4UVIzakZIQ0E4cW8rYTVj?=
 =?utf-8?B?bTd0ZXlDa2F0dXlLczdVdDB4cllneDQ5eUI2RWQrbE5GQnV0cWVjTFVJZWJh?=
 =?utf-8?B?MXNFcFRwMk5CbjdlUlByZkFIZENhNksyK3MzeTVNcWdka0x5UFNDQ25lUmtJ?=
 =?utf-8?B?eUYwT1k1bTNXeUJiaElPeFBTSE5EamlqSHdSU0lMS09jWG8ybWJRM0VRbEFu?=
 =?utf-8?B?dmhBeTVOU285a1o3N0JtbE9XckhqZFB4Z2tBdnNnVmIrdEdNckVVNnpucE8w?=
 =?utf-8?B?OFNYT3o1WGNXa3luaVBwUzYvU3JkMjJhMU4xVytoNkM4WkFJdTZkcGlRUXhr?=
 =?utf-8?B?SWZZRWtTU0VZSmcreDAvUndqTkVYZEJtaitJMi9jQkdIdlNGZ1d2YmliOGpj?=
 =?utf-8?B?K09iaTJ6bVNKUXVyUnF0SXM3R05zVzhaSWMrS1ZuK2RhV1lKQW1qSDFJSW55?=
 =?utf-8?B?YUg2UXNuR3I5UmN2NHZnNTVTMzBObzlNM3Z1bWlVTkhwbE8ybUN0MExjd3dH?=
 =?utf-8?B?eWo5RHpDSS9YUnlIbGhUT0tIdkhQOXFJbWpkZ3FnRjhQRXRiak5qd0tzY1dN?=
 =?utf-8?B?WHc5Wlp3NHFobTQ3Ykp5YStwa1lnYXo2RkFkTXZYaXowLzlacWsyTHZiYXpO?=
 =?utf-8?B?TW9Mem1aQlNkT3BNMTdlVE5QMm5IYTlHMkhCRHRPNG9ieFRYek5ZWFF4U1JR?=
 =?utf-8?B?eVBGNjNnaE1TVHR1UUdOSXQ4ZEVkYTcxSnczSHQwVXN1d1EzWE14c1RDeXN4?=
 =?utf-8?B?MFVBNWdnMnhMTGgxeUdLdFp3cTlMbERsYVEycmEzTWZRVnNFeDFDK0Z1RXpX?=
 =?utf-8?B?VXdacy9kZFpRSHVFQjk4Z1UvdmhUaTJCaFU4cERCb3h3UE1LY3VvT3RCWGUy?=
 =?utf-8?B?VFMwbDZHc0N3WmFHMXk0SDhLc3NMOUdQTldQM3U3dFZBdmhzSVY4dk1WL3BN?=
 =?utf-8?B?QXNlTllGMG80QVh6ZXYxQitNaVc3Und4Y3pIc2YvNDE5M0tUV1c1dk5vam9o?=
 =?utf-8?B?Ukt3VG1NbEVWWjJLNTk2OERIMzJvVDlZQjlxcWViQWxqUzF1T2Z1RHBCNmlN?=
 =?utf-8?B?eGhNTzM2OVJZeUxXN2pXc1hldnlOVzZoYzZlV1ZKL3piaGU3L3ZkZEI4NHlP?=
 =?utf-8?B?KzdLUHUxRlhGeFJNQlRoUkpneUN4ZElDNzBZQ3UyeEE3bytwaDVsTjRyOWRo?=
 =?utf-8?B?U2lLQjJCQTM1MzdiWjNrY09abXNkeDNKM0JxaEVPc1pGSlIzeFpxeG1RaUhK?=
 =?utf-8?B?dE9pUFBaZ3BodWtPaFBPUk03MWZLVEZrQ2tDUUVxY3prYjdJdThWdDNrL0t0?=
 =?utf-8?B?bGFDVlFWM1BFdUhQOWRwT0srTmV5UXpHeDhuaW5JaE1hRCtRdHpCMjh2UEJu?=
 =?utf-8?B?Lzh2cmI1Z2tVbnpsSFFlek1MTlg1WWZab1VOa0xSS0xzYWY0ektTWnRTa3Iz?=
 =?utf-8?B?MXJ5NHZLRkxuMmFHS1laWHdPTWY3bnk5QXc3R2IrZGJBOWZtWWQwL0lDZ2k2?=
 =?utf-8?B?N3UwclRVMmFWb21EY0R3ajB0Qy8wRStPNXMxMFdqWCtUK0h6Z01JaldkUmJq?=
 =?utf-8?B?YjZaTHBRZ2NPemYxT05RQWI5MUVWQWNXSjdKK2t2WE1sRTQ4cDRPOUNFNmlQ?=
 =?utf-8?B?ZXowWndnUEtBS3NXMzVNbXdJVEVrdkdYOXBGeHhxZ3FWUWxTbmtLOStTNkk3?=
 =?utf-8?B?ampKcHVmUTdQc0dHNmVSWERzOUVVL2xqcmM0YU9TaW12bGlwMGdhYS93YmZr?=
 =?utf-8?B?VHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04b85081-5f3a-47de-14a7-08dac97d95ed
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 15:57:25.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7Y5iG7QYRDotYitDntbU2mMuhiW1zMn7qQ9ln/OCj/N0NTsH551Ze0MTw5JDu3+bhm5nan9j/7datYg5MhsDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/22 10:56, Vladimir Oltean wrote:
> On Fri, Nov 18, 2022 at 10:49:30AM -0500, Sean Anderson wrote:
>> If we have the opportunity, we should try to make invalid return codes
>> inexpressible. If we remove the extra bit, then all the combinations we
>> would like to have:
>> 
>> - I don't know what I support
>> - In-band must be enabled
>> - In-band must be disabled
>> - I can support either
>> 
>> are exactly the combinations supported by the underlying data.
> 
> So the change request is to make the enum look like this?
> 
> enum phy_an_inband {
> 	PHY_AN_INBAND_UNKNOWN		= 0,
> 	PHY_AN_INBAND_OFF		= BIT(0),
> 	PHY_AN_INBAND_ON		= BIT(1),
> };

Yes.

--Sean
