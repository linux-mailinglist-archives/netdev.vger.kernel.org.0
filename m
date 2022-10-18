Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A276031AB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 19:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJRRho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 13:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJRRhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 13:37:42 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2080.outbound.protection.outlook.com [40.107.20.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B45DAC51;
        Tue, 18 Oct 2022 10:37:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvSGl4Baf8N2IiTT71LbSrzQVDpBlOEXmLap2qln2abUq9/VXuCinzsqRj6Zu/220rj9BiAaF8emHyWgrmC3TKdu1cJVpHfYxiyRym55CqgTh/j3NYF9ZLJgKxghRM+kIFpUrz4r20zcjHZjN039JvEeExUx5jLvkEtOiGcl/p8ZNIOrnKTKXmJfJxrQ5D1/a9zB7bCHRaR0xZhwL92BrQ/68XN7xGOYBnq6URAvaTUcKU+fZHZZEzsvpllHzSPUKbcS/3DyE+z9JCDkPI6z9JadhvDkYqvKWk4l7OLfmnG1vVhaD8m4fHAEY3BWoqVjhGzoz3gCNR/wBUWbQVGqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MC1KQ+Iu79kmxHWVpV79aVcqPVuCbqdKjmDYgAYJ4uM=;
 b=BGwrCHE/+q6/vcnNf4aqmVUXC4bVl4PXUTzrO2rbPGO9a8t3ELvxyU78e0ttWtLPCtEYkvbmv+GXaRVspEpYeqOF2tNKPgUuUt6uMktVlJ56aqE8EME7ot9gK4xjs63lbLB9OqzvW4g4oe3cTDO+B2e5ucnOtelS0v1iC9kyp1l5/Q8xTr7i8KbFe7T2JpG02bdFm4YenQDmrVj7uQmMwcyuPzLExrva8vNZ5IivjqnADP4/5kfVeALqb4kaeqMfTgymhESSJ9u+tVxrypMxKLF6X6LnafJDpmf+IigM9kcy4br7if5YMDU1O2lSQ3IQZ2Vg1s3sHT/HYPOPBSuVXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MC1KQ+Iu79kmxHWVpV79aVcqPVuCbqdKjmDYgAYJ4uM=;
 b=PyW/jFrs52Gj7x3AATgw/tvO4pcCio1iOUjuHXl39GQXfey/pXeiNsWBmzTGKl+3xy1AjeWrPkaiAJ9nRxh321tpq43m0tXDBYch+8JTLm1msE8+JRREVytyLUde9Qkcy4G2QqfAvJWIjQE+tr2CFYoob30uk45Yrvw9env3dnabp4/OtgtVhhOs/62VC6Mvjv67nzrapdi3B8Oe6+8e06WifwROChryX7G1IuS8Q0P+OjTU5IU3unVz2xBkYWGkLp0tSIxoql57SEsHYxZO329iR+jgWeKimgR8H7dxkr2j55uSKpcjKrPM69Fb+Y2rxyGRdJVw+StptEy59tbWDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7030.eurprd03.prod.outlook.com (2603:10a6:20b:295::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 17:37:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 17:37:38 +0000
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
Date:   Tue, 18 Oct 2022 13:37:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Y07guYuGySM6F/us@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::31) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: bedd5ceb-4bfa-4e9e-ac4b-08dab12f7344
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IlVFlKtViABmoCAL/H7EOm4+dJl47414MOFy0A7DxEjBjGURFO8hI7zfD/Fs15I3zQQm06q8c8hORph/micnOuLZEfAzB63FC1gXCuEAwj0UFsxbhhABhHUGXbhaavBFfautM42DZmD8OSoId62DBOKszl3vPWF7zcGAby62OSsWRAdqvUz5SNhkU/irVN/Pzz8eyJ2l5Pj1L4m6Z37c8m+Lk6bIDH8mZJSh9Dgq1YrzHkwThWQ84Y2g8c1fUIsOoJjtloTJcSfxurPvl145PUB7tWv3uSYPMVA2B/cZcgSOvU14PI41HddOgKMw95ZJShhc9fIhF6gvrpcfOXV38UIeLms4pgvHn9POoyQY88+AXD443PzPPcDJoEElv3vDfIG+qBEnQ795Occ3iiS/4gNFd5My3cW0HHbFxdMbV1krIGE9WpgCp7oMAQvuVsYhNMaV3Rsn6uHERK4DVTU1PqOk2SJgGuDHxX15XLcEELiVPAJwWNvWLf48PkOEXhuh3KaSKGT/udCgA3UPyYlvhUdGGR96UzF0jSaPMs5ax2LaGRPVqgdTDf1EYmCT7D/MNu+bh2kkc5apCKoXHFv/ShEMDskM5lx9vkqEHOFFicoYU2NF9A9Qvjb5GgEyVDFfTAKmYV9sFduWMnlr7X9DozUWNLKzWvKZJCKROnTdXL6gwy9HZVBMq/01defSzX6znGu1yJdz4XfZwosj5NiSlQKvFwpDe6Vy+Ie3IANWT7i5upCmiMc4D4fN3CX6RkoZ85xebPV+Y/Iu3QQPSiln5Bik5ZklzRLZ40XRzwtcX5MoRG4yPjcDAf/7AL7dL80cWsmBVnCReffcHHbZ2VyTeMno2KAKUfuQcH4WOeI482U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39850400004)(376002)(396003)(366004)(346002)(451199015)(186003)(31686004)(2616005)(2906002)(6506007)(26005)(54906003)(5660300002)(52116002)(53546011)(316002)(6916009)(6512007)(86362001)(38100700002)(38350700002)(41300700001)(6666004)(8676002)(66476007)(66556008)(66946007)(7416002)(4326008)(966005)(8936002)(31696002)(44832011)(478600001)(36756003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjRlTUdzSnhwTDYzdEFTRG5xT3BHZzBZaWZJbVVkalVyNTJJSFdxeWkvdzBw?=
 =?utf-8?B?QnVlV1VlRXpUMUswS0thMXJtbGY3TEpMbjV2VTRlRVRhVzVoLzJYb3E1VUtv?=
 =?utf-8?B?ejR1YVZPMkx0andTL0h2akd5OVZUOTJEVk9DbnN2QmhyM1BsOHU4UHF1Szk3?=
 =?utf-8?B?Rjc1aFQxNHVCcXo0eFFEUUlmeVYybXNQaUh3Qi9pRDczNXcyK1JzcFZXT01Z?=
 =?utf-8?B?QjJaelZpdFd2dGFkcTFJcC9QMEdXdzRoNFBsQmwxejJKNDNtRll3K3Rza0sx?=
 =?utf-8?B?eERRVFphVjB4c2FwMG9hUFM3WEttTUNVa1BQZ1FuQVJOTm10a3NJWFFza0Yw?=
 =?utf-8?B?Ym5xamViWnBKQlJnYSsvVlRDRmRTYUZLV3dRR0dSRXgrb2E4Y3dtM2dqendF?=
 =?utf-8?B?SEJCVVZhTldkbGxNdkZJbTFFRThVN0NneVhCQ2I2emQ3aStDS3RqYlBRcUJF?=
 =?utf-8?B?R1A0b3FXWWluZThoQWN0SnVYWkQ0Z1Z3QlNxaWR5dnU4cEFWa0R3ZlFIbGlp?=
 =?utf-8?B?OWRrMVkrbUx5Wkk1VkVYSkd0MWFTaUtpNWk2cVJWSDFEZ21oSEtMclZVenc5?=
 =?utf-8?B?SERhKy9LNW0xQUVHQnozZDI1SW9LVG96NWN5ekhOTmtZbDJDNjBiZHRNSUFQ?=
 =?utf-8?B?VTVyYkUyUDdiUFNoQVJLcjhmT3ZSYmJ3VklEZCtNbWJPOVdveDh1SW9BekFF?=
 =?utf-8?B?TllkeVZjVEZ5V2ZId2Y1OTZjc085bTBRL3dsS3pqRjJVY2VDVUpBMVJCRXRV?=
 =?utf-8?B?c3dNNU5xMkkyYUw0aEVLZ3RDY3Q2dHdGei9od3NQcS9YWEIxQzVhSVJ3SS9Z?=
 =?utf-8?B?Umw1ZFJGc1R6T1ZaaUczTGZVdW8rRmpxbVlNVGx4RU9aYjVoc3E4a1RWK3Bo?=
 =?utf-8?B?UW9RTTJlRVlhOHhsVEFtVVpPNnRSeUV4Z0NENkZyYzRxcEk3RzlwU1ZSSnpR?=
 =?utf-8?B?QmlybTFEblFaWHdLNjlkemxjczFMUzE4MmYycmo0bDI2d2xqSmpPWEorVjh5?=
 =?utf-8?B?c1ZIbURjYm4zcElGeUpTTmxwS2QyWUJhSnVLOHBUUzd0c1lCdDlvNHUzL3BU?=
 =?utf-8?B?YzAya05TMEJTZWtSMHhrcEp5Vm5GQ2FoYXVJY2ppcVVxRmVDU3FSbHRZRnhJ?=
 =?utf-8?B?a0RxViswdDUrbnZDd0ttaG9iVnc2NUZIVEI3azViR0VmbG92QlJyMjNKaUcx?=
 =?utf-8?B?ZytDNlZkcDVBc210cXIwQ2dJUzU2a20vdDFCVFBTR3pYYnRvZmU5KzNVQzVK?=
 =?utf-8?B?NE54WGoyYmFVWGp5dUZIREMrZGFtS1VxZG10NVNlUFFlRkp5a2hiUTloMlRj?=
 =?utf-8?B?dCtjbndqS2wwamZKWG02U1lqbE5ha0thQm5rV0t3ZlgwQ21HWHFwUDc5YVFE?=
 =?utf-8?B?d1FOSklGelRwbUtnSHZHTDhlV214TnQ3QmxxY09jU3hydytnOS9EMjJUYUtF?=
 =?utf-8?B?SUxLSDVhQWY4TTVmdzZwV1BJUmpzdThoT2x3Q2VRSlhQbGdzamh6VHBkc1Jx?=
 =?utf-8?B?QzJlSzJScitEeHJ1M2RvZytWZy8vRk5lTk1xZWV1d2NyZkNsWk5DWCtFS1A3?=
 =?utf-8?B?OUNhQ2hXaENQZFZEUmRoaEVEYjkyaUxkYmJsRmkyeisraWoxY1phcU51T3JQ?=
 =?utf-8?B?enlSWjJ2WGJXRkMrb1dUQjd5Uzl0a2hFK0dOVk1NdFBUT2pKaEJtbnhTNnhs?=
 =?utf-8?B?dWYxRjdmWnFOSXUxTWtINFo2THY2WWQ1NDJlZmFMTlNTdytZYkdVS1M2UVZL?=
 =?utf-8?B?VDRuekNXNUhZZlRGY2lkYTBOZ1plak5yV1BvdjlBU0JMMEpOQXY0SElpMll4?=
 =?utf-8?B?MTZxdXpRbCtNMnUrNXFReGxDcXk2dVExWktwY0xmQ0dtY0xCenh1UHhvaXh4?=
 =?utf-8?B?L1dJOFBKdnNhcnUvMjdxK0R0UzNTNEJ1TldUdkJUV2FoOVVrb1Jsc0lyaEx2?=
 =?utf-8?B?TTRaNmZHWFlUc213YytpTW1aRGlwblhhZmdvY2xuaEYwL0JOeVFKRzZ3WUlG?=
 =?utf-8?B?c0syaThLbXk3WGJIZ1lxZlJCTEpUUzQwMGRQZWk0bGtBcGdmcTQ2c0dNUVIx?=
 =?utf-8?B?VEY4N0hCaHJwWW9ubGpuOEozYnNlN1BPbjdKSE1QWFM4bWszbGh0d214a0lE?=
 =?utf-8?B?cTlza2xzYlhISnJ4ZHlxa2pKdVJHY1pRaCsxcnJGdTZvUlFpTXpsYXB6bmJj?=
 =?utf-8?B?Ymc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bedd5ceb-4bfa-4e9e-ac4b-08dab12f7344
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 17:37:38.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t44Rkpn7/l37DaEroVT6c4WDst6rJLs6QqmoGNXEkljqDcpv01l0cixgoxN5KLRSyN69PxpUD6zVG0w/DnvqwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7030
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 10/18/22 1:22 PM, Andrew Lunn wrote:
> On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
>> For whatever reason, the address of the MAC is exposed to userspace in
>> several places. We need to use the physical address for this purpose to
>> avoid leaking information about the kernel's memory layout, and to keep
>> backwards compatibility.
> 
> How does this keep backwards compatibility? Whatever is in user space
> using this virtual address expects a virtual address. If it now gets a
> physical address it will probably do the wrong thing. Unless there is
> a one to one mapping, and you are exposing virtual addresses anyway.
> 
> If you are going to break backwards compatibility Maybe it would be
> better to return 0xdeadbeef? Or 0?
> 
>        Andrew
> 

The fixed commit was added in v6.1-rc1 and switched from physical to
virtual. So this is effectively a partial revert to the previous
behavior (but keeping the other changes). See [1] for discussion.

--Sean

[1] https://lore.kernel.org/netdev/20220902215737.981341-1-sean.anderson@seco.com/T/#md5c6b66bc229c09062d205352a7d127c02b8d262
