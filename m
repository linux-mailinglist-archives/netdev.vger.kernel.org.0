Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF006459E3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLGMgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLGMgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:36:09 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2115.outbound.protection.outlook.com [40.107.249.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452994F195;
        Wed,  7 Dec 2022 04:36:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gT+kCEXTbgPc6PQcpZCtYpDNnRlv/dexVDg1wzF8Z4RLkaZlZtGBuhG9Ci+glRI6CLZBGXO2Krp6BqMrnnnHyDBzToqKh8fAJYHWpEUznAJagswEzhoE2lPDzN5jK5lsqaHEtm/lhTi2jZHOUObfXZQKtUXHRHQ0JIZ6/IptVpwUFH0NhweL2X5Lth8I86GhWGTsQ2i8vllgINjxDhPQNfOmQL/yiVd62TTmCDtxfa7hyy6hC4AvaSXhcr9qMqtp7FRv3Izvfn1D57asisVL2VFd6cojktdxCQ6uh+onkZ0nXnImCX5ovCyd8tZWJIZtEUKS4JnjMr3Q02D5pdpQXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kJg1BTl6x4PvxIBhAr6o+afjaIESH5WQgL0UZVZLMg=;
 b=EA9L1o2/y3zevY/Wr6hA5alECBDqyl0adQubkeHNOfjR1vRZs99I2EPRl7+WOh9yD/1rYD0hWoeyhFR+EonZlEO1dLUCSlXkItx+r6TO/r7aVmJllGmUdt07KUeCcicSLHnG6zj4iA+nM8A5QB0BwrNG8naLCu8P6IuoMsoc2gwIPFm8NYypJbbxWrf7xTKMJU1V90tx7NXjSKLQD/2N2de9FrJYLcvblsIG4+EutDO7h1Oe0om0zYV2t/UtdyHgQyjvCj/pQYUmOr2RBBhVLZ28wpUtPftKKJuQLr1LCofbbWt84CRkNDYIjH+7xRSlvwgsaza2H+3KLnxrjE7oNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kJg1BTl6x4PvxIBhAr6o+afjaIESH5WQgL0UZVZLMg=;
 b=vakGC1mqfg5JOnIa5NPCrJGIgeJZv/juOwUDKxfz3y+XYetlQg6XKY4bp1Jo7qf+mURt6uU/0FdzYhaC8oNzFOfuEsYMC+jLwg0lVSoRYuKo0ieHq0HOUhwBwKTiSFcLifWHw0u59pE7I7j8DZglXVYzXfdIrkpTpjmsniFuqD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GVXP190MB1990.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:4::7) by
 PAXP190MB1840.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:28c::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 12:36:04 +0000
Received: from GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
 ([fe80::bf31:7027:5543:3e42]) by GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
 ([fe80::bf31:7027:5543:3e42%8]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 12:36:04 +0000
Message-ID: <dc9fb975-6258-0473-3ed9-58d3a74e501a@plvision.eu>
Date:   Wed, 7 Dec 2022 14:36:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
References: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
 <20221129211405.7d6de0d5@kernel.org>
 <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
 <20221201131744.6e94c5f7@kernel.org>
From:   Taras Chornyi <taras.chornyi@plvision.eu>
In-Reply-To: <20221201131744.6e94c5f7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::16) To GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:4::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXP190MB1990:EE_|PAXP190MB1840:EE_
X-MS-Office365-Filtering-Correlation-Id: 558d1b16-8f1e-4e9a-aa11-08dad84f9b28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKt5R+6mP5XV5DKiVcN8qSn9X2tgZmZe29lpTjgtA2BbwGePk3C13wHBJGL6KJv2hAp39hfdAioGRvICncTkgtwdblmxZJlOgMS+T6QpaMY51rhTBXTkcvr9G6xEKeR1DqfqC9gCGrACeEKQ2J/qnDTvgCt6FxMA09vXozGC4f8dmPnjCH2ugGg9tsP59crvpCU7Dfp794eM7MlaXDZuifR8RLBNVIHjsTCLSg9KPPfIwDA8e9nuva+BWSmtStxSsKK7toLcAerzG83u4HJ0FfY5YAB0K0ZAyto0M4oCHRgh1zWYQ7dCLVa7PwSGZOpfN0XNyMJ78KSCesu1hKRnlDU6x/33CN6J5BspQaUPWg/I5vn5TXuQZmqz9i9olydTs/19hqHn18uU8N+AlNmHNp7x6cUBFTuTnxxC//bllVmpCRu6hS8IVp/XnrRCnTnJ+lPUq0amEivjEsHJnBR6GITG5VTLQSDtFIOpATxrFrI/mFZK/DvXe2xuCzyb3wBMJ+a185Wxp0fsVqIMUn1nourmO4xQlIQKuP39On1+7sw1qF5o67DMSrNYrO8XBvNB5SRNIWd3fMGVQCPQ5Lt738N3HYEd/qIWbDTvnvRlivO7Y15lInUi2o60hx2AJbLGoOxJqxFbof3ppdpQqPRRy+sH2aTtTbfDFEBke8q2JlHNtXA3t6XVh0w8MyN9SqajShISImX+AbB34p9S3Cw5DB2Tt0uftvOlKuRZ3hWFIJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXP190MB1990.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39830400003)(376002)(346002)(396003)(451199015)(66899015)(36756003)(8936002)(31696002)(86362001)(44832011)(4326008)(41300700001)(66574015)(15650500001)(2906002)(5660300002)(83380400001)(6486002)(66476007)(54906003)(316002)(8676002)(66946007)(2616005)(6916009)(66556008)(31686004)(38100700002)(186003)(6512007)(6506007)(26005)(53546011)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk9tMTkwS211eG41NTB5NmRkK2JDRE9OOFYrREw0ZmlBNGxwNzdSajlhRU5z?=
 =?utf-8?B?V0NZcE5Nam4rRWFoMkxhMFpObTlrVy90ZitDbEZ0WTc2cHhWaXdQaHVLY3F1?=
 =?utf-8?B?TjRFVDAvM3FzWmprbTNpUEJPL3dnUGxjUkNRREkyNFowbncvTGlnbnMzQWxC?=
 =?utf-8?B?VGhMN3JlNGM5K1p6KzMwRFRIc0ZSZlJNT3BEdTdRL0hHZ0VTMG1YcTBwanY5?=
 =?utf-8?B?Z2d2WlZaUmwzQWF4VWUwRk5wbHNYSys3aFB6K3NIeEFsVVpQNUZRc2ZMa2Vi?=
 =?utf-8?B?SStnNU1MWkRhUmFqdGFySVlheHVFdDZETTdIUzFsZXJtcFJhZjg2MTRVek5o?=
 =?utf-8?B?NUNWeGNDMFVJVW5VVldwRFdwbXhwc1pBY1ZsdEl0aGovTkxCa0t1VlI4Ti9h?=
 =?utf-8?B?c0MrZ2RSTXpQQ1UyVEJmZDNBRlBaalJ6SEZlU1I1RDRNQmdBaHI2QVhPQ2N6?=
 =?utf-8?B?YURrY05qS3c2WTZZK3ZlZ1FQNXdHRXlSRGtCVTBZeUtBVVhKSkNtSnowSHlt?=
 =?utf-8?B?aGdtM2JsczhBaTVnZFdCeWJuVHErQmdVYm01Mmp2Y2dibE5la281cjYyVVI0?=
 =?utf-8?B?SEZWUGdsWllOU2F4OG5nMjVDdWI2WUxGeVVhQklEVmZoc2JWYThkZFk0QmdC?=
 =?utf-8?B?N3VOSHRUWWJsanBwcU12aU9HZmhJRHowYmRIbUZpVTVEZ0dmc1pScGFRdHJB?=
 =?utf-8?B?a0NIQTI0QUcwRW5kZ25BSVV3aDVYdXlMek5seWdlWGdVTVhKSTQyY3VXdU5q?=
 =?utf-8?B?U0wzb3dEUG9wUXJ6Smt6NjNOc1FiajFsemFHR3dPVE0zNWMvVXZtWUUvcUtX?=
 =?utf-8?B?Zyt6akMzVHlSbDJUQzIwVlVLZ3ordlQ1Yk4vdWxSSnhvWHFhYThwVEZ6VmhM?=
 =?utf-8?B?aUtWTDdLTjFtcmRIV1FQRVJibDBieEhnZlBIQU9rRk9xL2tJVTVGRXFUWUt3?=
 =?utf-8?B?MHdobHhwTXo0dUxsK3FXMTRuNTd1T0VBdytqYUhzY0x3REJqdEdpZmZXNFp2?=
 =?utf-8?B?VEhhazZ0SDlXdGVyb1dNSG1jN0NEbU1meHlPTitCUENoTnppNDc1UitVd3hO?=
 =?utf-8?B?U1Zscy84b3E1b0R1ZS8zL0prOWZHUlpSdHZ5ZEZSSnFxQzRFVTJtM2ZTUzVL?=
 =?utf-8?B?clo5NnA1am0zalZRREMrM2MvNmR3WmRxZ2dmMHUzOEM0RkM4b09FN2hIOFBm?=
 =?utf-8?B?dXZ3RVQ1MzVzODkyUHIweGk0NE5iMkRYNUlLZEFBSXZTanQvak5ENFVPaW8x?=
 =?utf-8?B?UlVnOGZrMXNZUTBjL2YzRjBqakNrTE5HREFrOWZMNWdRUlNXUHNWaFUxZlpl?=
 =?utf-8?B?am8yRGg2T3NhOWUzL2wwYWl1WjBkYWdLZTJndkswSVhQTVUvUkF0bURnZDlu?=
 =?utf-8?B?QTQveDczb3AxWXdmdlBSZTdyNS9ETkRUV3ZYaUMrVStQY0VZVzNnV2RBK2ZI?=
 =?utf-8?B?SDhxcmIzN2FFdldNNTNMNkt3SVBKdGcydStINHZROU5Uc0prcVFwZVJZSUVN?=
 =?utf-8?B?dG1sOEVPdjRNVnUzRFc1U2hIQ2hiWnB5M0h5S0lvdnVhM05kODQ2MHVjTWFU?=
 =?utf-8?B?Zms3UzlJSnJzcUIvSXE1Zml4MXBhbjBhZXB0UTNVTkg0TzAvdzBkb0V0MFJM?=
 =?utf-8?B?QytERkhoVGM0MmVXaXdQUUFSRGc2TWxzT2xwbXRTR3gzYlk2RHY0WGN5bm41?=
 =?utf-8?B?dTg3d0tWdjU1UDhuQ2F2OTdKV2ljZ3ZvSUV5dktIOTh6WjMyWDJsNWc3eFZB?=
 =?utf-8?B?dTZNaFpwOHFPb2liQUNIRnM4UGZhemNaNFhMTUpkd3RuK3VaQWV4YnNJNzJm?=
 =?utf-8?B?SDJZVHgzSjdsUk5OaHZkTzlsZUtFNzByaEVpSkp1dHhSMWpqaEVmV0NJMm9Q?=
 =?utf-8?B?ejRZWnR5TGFoY3BmZFZsMVBuMTZnL051dEFvN1d4TS9FR0tMTTBqN0tJT3Mz?=
 =?utf-8?B?emU1NDZrakczd3MzNlRxMHZjQVdnemJ3SmU5NFN0Z3ZldDFPZGI5QzRhZ09K?=
 =?utf-8?B?M0tZeTFEWGZ4TmhicDJ5OCtaQ1M0NzJhNjFBRTVIaU9FSldlejBlUjRVRjR6?=
 =?utf-8?B?b0s5bm1HK1lJZkNoK3BsMENxT0RWVEVpK2JmN3NYbEs5WTJlU1RYVjI5QXpC?=
 =?utf-8?B?MWtVNFJiNUhRU2ZrRjZrVmVUUTh5SmxZbnB6eDZvT0JIU0ZKQThHZmdTbCsy?=
 =?utf-8?B?WUE9PQ==?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 558d1b16-8f1e-4e9a-aa11-08dad84f9b28
X-MS-Exchange-CrossTenant-AuthSource: GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:36:04.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtaxmTNelsVOj/qOnSqI5ucx5l4AxC43CZOLpB1kkupbtQYIG3Zu+xcmejcge8KO0e2NKlFuUKzl6UuE75Usqn0sDDG08LOX/aoJziSvges=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP190MB1840
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.12.22 23:17, Jakub Kicinski wrote:
> On Thu, 1 Dec 2022 10:39:07 +0200 Taras Chornyi wrote:
>> On 30.11.22 07:14, Jakub Kicinski wrote:
>>> On Mon, 28 Nov 2022 11:39:34 +0200 Vadym Kochan wrote:
>>>> Add Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.
>>>>
>>>> Change Taras Chornyi mailbox to plvision.
>>> This is a patch, so the description needs to explain why...
>>> and who these people are. It would seem more natural if you,
>>> Oleksandr and Yevhen were the maintainers.
>>>
>>> Seriously, this is a community project please act the part.
>> The Marvell Prestera Switchdev Kernel Driver's focus and maintenance are
>> shifted from PLVision (Marvell Contractors) to the Marvell team in Israel.
>> In the last 12 months, the driver's development efforts have been shared
>> between the PLVision team and Elad Nachman from the Marvell Israel group.
> 
> Ah, damn, I was worried that's what you'd say :(
> 
>> Elad Nachman is a veteran with over ten years of experience in Linux
>> kernel development.
>> He has made many Linux kernel contributions to several community
>> projects, including the Linux kernel, DPDK (KNI Linux Kernel driver) and
>> the DENT project.
>> Elad has done reviews and technical code contributions on Armada 3700,
>> Helping Pali Rohár, who is the maintainer of the Armada 3700 PCI
>> sub-system, as well as others in the Armada 3700 cpufreq sub-system.
>> In the last year and a half, Elad has internally dealt extensively with
>> the Marvell Prestera sub-system and has led various upstreaming
>> sub-projects related to the Prestera sub-system, Including Prestera
>> sub-system efforts related to the Marvell AC5/X SOC drivers upstreaming.
>> This included technical review and guidance on the technical aspects and
>> code content of the patches sent for review.
>> In addition, Elad is a member of the internal review group of code
>> before it applies as a PR.
> 
> I see 4 mentions of Elad Nachman in the entire git history.
> 
> The distinction between the kernel community and the corporate Linux
> involvement is something I don't quite know how to verbalize.
> And I don't know whether my perspective is shared by others.
> 
> Linux has taken over the world (at least the technical world) so having
> Linux kernel exposure is common. But building a product based on Linux
> which is then packaged and shipped to customers, in the usual corp
> product development methodology, translates very poorly to developing
> upstream. This is more true in networking that other parts of the
> kernel, to my knowledge, because we attempt to build vendor-independent
> abstractions.
> 
> While I do not mean to question Elad's expertise and capability as an
> engineer/lead/manager, and very much appreciate Marvell's investment
> in the upstream drivers for Prestera and in DENT -- I think the
> community involvement is lacking. Short to medium term we should try to
> find a way of improving this situation, we can clarify what we expect
> from you and if you have ideas on how we can make the involvement**
> easier - we'd love to hear them.
> 
> ** community involvement ideas, less interested in how we can make the
>     "ship products" part easier, but you can share those too
> 
>> Finally, do note the fact that I will continue to maintain/support this
>> driver, but I would like to have someone that I can share the effort with.
> 
> Understandable. I hope PLVision does not disappear form the picture.
> We are really allergic to the "push the driver upstream and disengage"
> or "throw it over the wall open source" model, if you will.
> 
> Unfortunately we only have one nuclear button for discouraging such
> arrangements (git-rm), which will hopefully never be used.
> 
> To conclude, I think we should have a call first, and then decide
> who the best choice for a maintainer is.

So we will drop this patch and create a new one with changing my email 
to PLVision one.
