Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7BB67410A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjASSdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjASSdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:33:09 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26999032;
        Thu, 19 Jan 2023 10:33:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sd6TgjY8GQncFiLsdrZleUGPfjunBbWkDPEPiseMbAqsh6SEIoX/CCYxZEtmDZE1dMW24eNIdq0xiy1wQOTFir/UBNcsW+ex4sfBZfWntEaMKm/sEOwTCE8E87v3CUVtHEs1fGG7oo/Bz3YUWWC8DwtvisFAWtD+IU1+wDr2puPQU3y8ETlAwbX04Y7TpdekoxyiM/hrlPRDQDhwD5/+tkH4EdtoaYeGy7MvTgKuJs55LOpjl2z8FS6lgcGnr94sfGiGKJGVOPob/Zyt84d8lidxK+v+637FuT3rKpe9AD5+HStMKIF7K6VEI78KdzhfA0ugNrLv3UoCisjNCjn0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KR3a7ahaWjgZ0ivbJD5TzD2dleLEh+hKL4GlTrr0CUI=;
 b=n5LGR1Ftv7ud+7EmKLGSlRufSp1IZiubMWF2YBsiBraQcL3koAC47FmoUzj01hoBpQR5kcMz4+1U3bFlreAP/vdzVuPn+vWgkmRt8ckPVZxnfNTKHNhE4IOguELbKyDvovdhXmlgBUVeOLIpQRizHZcfu10uzLYP7xzfvIYIEUGNMPJzAeBTB3BXcgcAuXxXghiXTnDxEbYO+jZj8HS55fRC8HuPP3SjfTpGlHPi7yEBQLAh6yXeEaf6BM7rk9kz3XsEvKdkTR+3g7g0/pwZwE6FeQJgq7QCHGkVFHuSGz76Mg9YIoSggxbohVz7GHTJQweYS8Gc/krTot57T8vsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR3a7ahaWjgZ0ivbJD5TzD2dleLEh+hKL4GlTrr0CUI=;
 b=ltn7GG97o3HgpXzK76wQquhlerZFEbBsI3FSgDVgKgQdq4wuPVu/7+lJLVsBKfwewTpmSi51Ye/CNzOxnkyjbNABlk5NY0KNeqYmyqj+tj690QXZXvz8P/afu7WiC4tG4jnL6KmXmRPm0FyaNw5TZJRC62FoBxe4+dV2UIUV2Grjqcjg64Pq0LGmQwgfxOewqc+Vw2YErqguaa7Fu1WCXA9ew4MKC92UbTN0xfguYQs/GUCsSELhfF2I3jNIe1xhtiAI+4GeEk98VdMd26WLK+9xPgz+lRLTYCNzIwFG3pxAf0wryT3auW4y5pFzlfy/lPNSfU50ca1VSEAeaKSSPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DB9PR03MB7225.eurprd03.prod.outlook.com (2603:10a6:10:227::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 18:33:04 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166%2]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 18:33:04 +0000
Message-ID: <535a0566-5c96-3477-9b94-332d54bf724e@seco.com>
Date:   Thu, 19 Jan 2023 13:32:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk>
 <20230106230343.2noq2hxr4quqbtk4@skbuf>
 <3ede0be8-4da5-4f64-6c67-4c9e7853ea50@seco.com>
 <20230106232905.ievmjro2asx3dv3s@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230106232905.ievmjro2asx3dv3s@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:208:234::13) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DB9PR03MB7225:EE_
X-MS-Office365-Filtering-Correlation-Id: e09347ba-9faa-4743-1eec-08dafa4b9a06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xzbeq8f/8N6QP69HguXtwQH7uIff6czxtMcMGiLx7ij7fAR3dolVHIEtsgmXoyxmlhVtJSReJyxtaOpP5ZMXYzHd7uHyapEzrHwq35qQRHATaxFL0P1MjBHOQfcB1Zc5VLXeeOtGxjjQb/xaPg65jPpk7jFMsW32pRU/hThzYX8bpqNyAHGp3PIVrOCbsrBEPAjJSjOd7VKFSsGaXTu4BOQ1vSf3DJ/3SretG98Vc1FInQMNigV/YWCd0k0b0JxjeZD19HH6+PEHhdLkBX4EbJ4u+zCShC5nVDKir708Gt5aEm1ONeiMjweSvH+82pWYbnGGbomoJCgBaXlVDkfbyHV2/XtARgsHekkb+lUUcRvZ0OSc1FZbHLGuNp1Zk1cF7MXQBhddNFmlE8JxDHCwXRPcVzYKkkyTPOYH9zrUjKeD80BZLkTNM/bv3xtZra0WARu3Bony7HydjR29wvrfE1h1cC55aMkKxa+7CZ+k+YqJ6lhxL6HR2EJCN5EzBx6gOkZGi/puE0O/KS4GWSxIRf0zMWB/NsLCYtkyEMnCH6EuZXgbenmOlFfqFbDM92Nr11uPqKMLjd8X8bPZR2X/rwbH3kU4SOhYTpHA/IwVvkVUbei1jcO9KUIWHMKdnMlqx/yMNgTh0fOxnzpIWrM7ZPXZ5QeXlyEw0DqtnFw9P3L9tfD359a4cnawMiwmyR2xKy0ElK6u1kI6AyWXzx1F51jnxH7wD2U3/LFe91kuLDwBqzmimKXzmDru9BO95NzQI31DL51mrgzUiaIQikJPkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39850400004)(396003)(376002)(136003)(451199015)(53546011)(31686004)(316002)(38350700002)(6506007)(38100700002)(54906003)(2906002)(2616005)(6666004)(66946007)(66476007)(66556008)(4326008)(26005)(6512007)(478600001)(6916009)(8676002)(31696002)(8936002)(7416002)(186003)(52116002)(5660300002)(83380400001)(41300700001)(86362001)(36756003)(6486002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDQ0MGUwdmdOZTlGUjlMZTM3RmgyR3p1czlRdnpyYWw0WUlzZDF4MHFvTmRQ?=
 =?utf-8?B?VXZPOHd1aTNXY3hlcURjejJEaHQ3OW0yUWo2bjJmaUVJY3R2MnRTS2M2YXIv?=
 =?utf-8?B?cTZDSkhGNmdVUXozK0tsdmdNYWh5K2dkTUlueFlsU2E5SGV1WkFsTHRGalkv?=
 =?utf-8?B?ekFSR2NDWXh4U3FvdjVJS0xHS2VEVXRUc2ZaTG84Q0w0NG5GaURicW81VHJN?=
 =?utf-8?B?aFFvaU1QWCtLVUZzazVtcW0zNStWWVV3eERzbG1saWJuc21mOTVJeDdNS1U1?=
 =?utf-8?B?STM1T0FsbmxUQzZNVFZhVkpyN21yeTZUWDJTWmtycForVHYvMmxzczVubEZv?=
 =?utf-8?B?QytwNjlPTDRYNHJJSGF5MFM0QXE0eFFqcyszd09NQ2FYUHVkREJiZnZ5VFlt?=
 =?utf-8?B?UllTRnMxOXJyb0VEcUwyeGtKb1ByeFl6dVB6UzE0bEZvQ0hQSEtBNTFOeVF2?=
 =?utf-8?B?TnVFUFRZVGtMZlFFUkc3Qlkza1RORHhHOEFGWS94RXR6QkZkeTdQUnRUUkpu?=
 =?utf-8?B?R1RIYW44akdTQUdpZE0wSTFqSklPTVMwZldkTjBqU0tXU21mRkRFUGVMN3Jx?=
 =?utf-8?B?YkR2RVd4cjdMUUwvTjFBZ3RFd3Mwam93alB4T2tVbGFXalBPdnVSeWtnNkNo?=
 =?utf-8?B?V0ZqcklVRWQxZkdraWhKTk5yMUI5ZGNXcXRYbkxTelpuMU92THIzQ0NkbTdW?=
 =?utf-8?B?LytPZlJEeGJaZHRtSnRyOXd5dHA4YUJQVm1yUWJrTkFaRzdWbGdSSXA2Qm0x?=
 =?utf-8?B?bTlxb0RBSUJsY3JaZmEvbm5YUUZpektaVUJiM0tKVnVWWkZRK2l3NmZyWGc4?=
 =?utf-8?B?azBLN1VoTFB1TTNjUjA1MWF6Nk1XcVM0UTZrL09Kanp6Q0tmK0ZaYVhoeVJ6?=
 =?utf-8?B?Tjh0OWpNM3FsWUdRQ0pWYklBNlNnd1Q3eTFSSlRLR0F3d3dCUWt0alQwOG1Q?=
 =?utf-8?B?Ly9LckRVL1BqVmd0Q2lMSWVZbC9QcnlrSW1DSi9BbkE1cGxRTW43TUlBdUND?=
 =?utf-8?B?ajNaMjltMkIwZHRVR1JJZmtReHpYQnppclVyQ2JvZzFUK28zQnExVncwZlRh?=
 =?utf-8?B?SDBPMEVhSXNkSEJta0w4SGR3RGZ5R1ZxMy9FSkNmMk45MGJYeE1Pb0NGUTEz?=
 =?utf-8?B?T0xkYVljcUo4emlkSTY2ajM3cU0wbEMzbTNma2FmeERpdDBlV0V5L3V1Rllk?=
 =?utf-8?B?WkZsNlZhNFQrR0hvTEJGQXJ2eDhwb0R3eGRvTmNOaWdlcCsrSUxmZXZTdzI1?=
 =?utf-8?B?M1hmcE9pdU5wRCs3RVk5bWcxL3BTRTBrZVExUVlLdXEwU0plV2JDZnFTWVdP?=
 =?utf-8?B?VEtISjhkQlFoaXA1R0dFWFpoQkpVMnlSM21Cbk9uYTluaTZOd2MvSm5od0lC?=
 =?utf-8?B?YUZSQ1NFa01oSTBHYVFvY2x2TmptdzEwSlZYUnZyN1dIZnNGOW1henpZS2dq?=
 =?utf-8?B?SVcyclRSU3JQc2pxeGI5aE9vcENRVGNxWWZ0WktWWjdPYkxGL0RqVGpkdlhX?=
 =?utf-8?B?SVRYUmRaVkhNdUJQNUZuV1Ird0hkMExtZjhFQ0tCUmMxd3Z6WEpDaWl4Wktj?=
 =?utf-8?B?eExaUlhqMVF3ZmZ1djVDN1Vya3JYeURzbXU5WWVTQ2JqL21mUDNhUDlXVkMw?=
 =?utf-8?B?T0lhdUJ3a0VyK0NDNDQ0UjR1ZUM1SlgrQ3o5QkJkME52MnZUcUcwdWd3UmNk?=
 =?utf-8?B?RmV6bTd6S1p4S1gzelRqRHk4SURkUldKeHJJM0JEeDM3ZXlLdVgvWEJFSkhU?=
 =?utf-8?B?ZEllY3VJWUdESEtYOHVNbDdPNnFTaVkwWE85U0tCNGw2T3cxM0pKSnF0K28v?=
 =?utf-8?B?WVp5QzlVa1dBcjFybmVhRFpZc2hQbWNnTmlKZDIrWTRNZGM2RDNyNElFNzRW?=
 =?utf-8?B?VmhiOTdEWElaaDZubys1R2s1Nng5TEhMTFYwRSs3QUJZYnkxK0VRdVdLQzlN?=
 =?utf-8?B?V29VamtBRnloYkJLOTQvUTJGNlFCbWJnbUdRblo4OFh3ekQzUWNiUW1YQmpt?=
 =?utf-8?B?UTdoKysxM1JYaUl6Z0hvTXVGUy9TZVlUUGU0SVFzOFp1SmdxczRnRHNjeHdi?=
 =?utf-8?B?dncvbTZITFc1NzNCT0ZSLzhEMmdxbU1BSElQMWxUWFB4M1ZkQ3JzTGlIaUJW?=
 =?utf-8?B?azFtSVpWT2FJQy9FNWd3eVJrb1hzbUwxRkk1dWxjaUxjYkIvZ3o2bkJ5WWQ5?=
 =?utf-8?B?bXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09347ba-9faa-4743-1eec-08dafa4b9a06
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:33:04.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGZBV/MT3Ep5mTxQZ74sywlOvYlJZ45IwOGlkrlaqnQaHJ5docM067C9xnihNmZKYUm39jc7rzlllEksDi9nXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7225
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/23 18:29, Vladimir Oltean wrote:
> On Fri, Jan 06, 2023 at 06:21:26PM -0500, Sean Anderson wrote:
>> On 1/6/23 18:03, Vladimir Oltean wrote:
>> > On Thu, Jan 05, 2023 at 05:46:48PM +0000, Russell King (Oracle) wrote:
>> >> On Thu, Jan 05, 2023 at 07:34:45PM +0200, Vladimir Oltean wrote:
>> >> > So we lose the advertisement of 5G and 2.5G, even if the firmware is
>> >> > provisioned for them via 10GBASE-R rate adaptation, right? Because when
>> >> > asked "What kind of rate matching is supported for 10GBASE-R?", the
>> >> > Aquantia driver will respond "None".
>> >> 
>> >> The code doesn't have the ability to do any better right now - since
>> >> we don't know what sets of interface modes _could_ be used by the PHY
>> >> and whether each interface mode may result in rate adaption.
>> >> 
>> >> To achieve that would mean reworking yet again all the phylink
>> >> validation from scratch, and probably reworking phylib and most of
>> >> the PHY drivers too so that they provide a lot more information
>> >> about their host interface behaviour.
>> >> 
>> >> I don't think there is an easy way to have a "perfect" solution
>> >> immediately - it's going to take a while to evolve - and probably
>> >> painfully evolve due to the slowness involved in updating all the
>> >> drivers that make use of phylink in some way.
>> > 
>> > Serious question. What do we gain in practical terms with this patch set
>> > applied? With certain firmware provisioning, some unsupported link modes
>> > won't be advertised anymore. But also, with other firmware, some supported
>> > link modes won't be advertised anymore.
>> 
>> Well, before the rate adaptation series, none of this would be
>> advertised. I would rather add advertisement only for what we can
>> actually support. We can always come back later and add additional
>> support.
> 
> Well, yes. But practically, does it matter that we are negotiating a
> link speed that we don't support, when the effect is the same (link
> doesn't come up)? The only practical case I see is where advertising
> e.g. an unsupported 2.5G would cause the link to not establish at a
> supported 1G. But as you say, I don't think this will be the case with
> the firmware provisioning that Tim gave as an example?

I suppose.

I still think we should try to prevent bad firmware from tripping us up.
At the very least, I think we could detect bad configurations and warn
about them, so the user knows it's the firmware and not us.

--Sean

>> > IIUC, Tim Harvey's firmware ultimately had incorrect provisioning, it's
>> > not like the existing code prevents his use case from working.
>> 
>> The existing code isn't great as-is, since all the user sees is that we
>> e.g. negotiated for 1G, but the link never came up.
>> 
>> --Sean
