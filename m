Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84B64C79B6
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiB1UIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiB1UH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:07:59 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0424F9C6;
        Mon, 28 Feb 2022 12:07:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL9OvQXRZlLdS0nWu38zKJUPGpd8Lw1yhpw0d+9zMnw5veNcCSl+j10Lj2ZBjoB5CfikiNko3OGYPd5ME3Vpnpr6n3gUYUUXyI/nkCpK1pboNWydXnK5jyRh9RlwUC2J4LqkRcYIcUEdvbcAPOtxCPnt41mkj7xD+m15Kvaf2q7v/g8rWPGCeIDynZ/oNm9fnv9Ju75vK4G9aE6aBcPLDtlUp1ST1JK7/NKF82SiZ4n1XSg+J4DKH5YpYNZ2xk39/JLPCrAzvhJAKKUntlEf2q3g2Pj1J5/dfEOPCBMx04zbq/GH674VvLGDrCGvs5qux8fGUlsbgRV2o3e8r2NFDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cP3BgbbNuGDusjcZMNEuDHV1LUQdbelhp6M0fWPy5M=;
 b=jdvC0+wMuIjUshRFXNDwX32c2zskPNpWzUT0ktJHw/5EiOrhAsU94pzDNGLqksNFWg+blmisV1k0kohfJdS4O05gRW7IHqVrOqq+Mv5c+HjZN3GrTnkeTf8cvr5w9XQlSh1NpbpQV9SfTtNox7n0FzrCxGIn2Y97pJ0Ozwd2zkUTZZwzZzxBKK4GvrZ+BR8TCxc8QZ0nYFwhOXfRlKMAnTFtySBUzXq/5mIt6py7gbpk+GQ1GQytDDsZI5lf5E8qHWfr02zFw9K3Qsuz9W3QSbnWtzK3Tll4VEq5yh73hCY4N6sQ7OaGkztdVoBWliieGcToSd9yyiqDpPsytzNReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cP3BgbbNuGDusjcZMNEuDHV1LUQdbelhp6M0fWPy5M=;
 b=yR2JVvc5BtwSjUOODC9WmjehMXRGxzHYe8ljFxqZPlt6ZskvnNvnIoLUWVTSqL4Nvnz3mlJ6Vj4yuzWXjUdfSbDpZboDHZVxGObnXC8gvFtZZmR10HmqPv3h4fJHh1C2OVQ9oxctvZyNbcFFjGdzd7Nu0zIl+DqaxiZBFvhDfEY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 20:07:16 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 20:07:16 +0000
Message-ID: <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com>
Date:   Mon, 28 Feb 2022 21:07:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
 <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P195CA0084.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::25) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4780f435-f0f8-4e6e-4169-08d9faf5eaa6
X-MS-TrafficTypeDiagnostic: CY4PR12MB1352:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1352374DF851D24C14A1673183019@CY4PR12MB1352.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfwKM4Ph3ffnU0p23PH6MmiWNssrAz4krll5evTSfx5ow0w1waswCyvqds83nXv/vKDqYeZ4nJPcE+5c6efbm9H+KF/V2vkIMjot7L3c4MJ2NUhhEHsU61Ft6hDBrl1jcnh9EapZmPmwTsw6ESVHpQs83QWblnrflHE+8n0pBPJGvO3BeOdLsq6sLykuPS1jfG+7mtvc1cC2b1biubmL14GLB/Sibk/qCZsfJd+KpT79kHhBzhYli4e6xf6Wf1XCotcM5PIbpVyqjZVKnKalewT7P85o/5nImHgkRdBqjmpldKbagBWNo3eLeex+hQocJ+uVVSXcSY7JFayKRxGcjUSrsgMDZrXESXUUKqA2mcVUrfGKkMgocWawoVlaIc8zSfyMrNNe3nWuqcEl1nUJv4F1V5m9d4aOTKdWVZb54C0D9BwOD0vvihgr/d8C1eTPDO8I+2XuopCbxIp48N14+nqKgxqddT9BQavA6sWNymzE8JSwtOP120c3NQbuDtR+2v/o2/9Bmx4GJDnVOim+gwVs91eOOaI51wF7Cfho1hyg5C8uiYQPM6RQIxlrMbnSX2DiyJmm7nOua0x6ZP0Vf9uP9VSnVikg0lwLJsx/nXxnp4VUactFuFQvm+o20VuEseTDTm8ixZYbdKCR2VF37spoXVt05gbXrIjEYGT1QRdZxRJAOxMWU/f0TemCgmhtJDDJ8n2ceV4KZQ7pwCR8VpLyLtZo05+32aCrevz7uZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7406005)(86362001)(7366002)(7416002)(5660300002)(31696002)(2616005)(8936002)(316002)(6512007)(8676002)(66556008)(66476007)(66946007)(4326008)(2906002)(186003)(6506007)(53546011)(36756003)(66574015)(6486002)(6666004)(6916009)(83380400001)(508600001)(54906003)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVk3ZlI0aHd3U2MzRTQ0QkwvaWlpT1JkYWNicURJVHg1U3BkTWNEbjhxamVK?=
 =?utf-8?B?QWRpaER3c01nNWcwcXBWTjRqeDQyYVJjR01sZFUrd0FKbCswZXRYc2luTWRr?=
 =?utf-8?B?M3BRcmp2MmtvUEVxUEdJSU1YbXUvY3l2T0VlbW04TFVkM3ZVU0NacEJvOFMx?=
 =?utf-8?B?UjkxWGRjNVgxcENNZFFFTFJUbHA1Mzg1WStJMzRDb21zcUNmMitra3lES1Nj?=
 =?utf-8?B?dWxXV25UQW1NTHhKRnpweCsxZldJWGRmc3NwSU1ldFlmZnhaY3ZLbmNNSktv?=
 =?utf-8?B?a3RpQ2VhQUZDbTkyQTdRVkd6K09STzZTQ040TFU1NDZ6c3NBamFnQ3JWN3JR?=
 =?utf-8?B?R0taZkgwQzc0Q3VKRDJ5d21lNmdNRWtCNmlEVS9HRko3RXFNdzNReE4rVUVM?=
 =?utf-8?B?ZllFWDNjK3B5Wml4N0twOVNqOURNSXpNMVVra1hibUw0S2o5dnlIQzQzL2xh?=
 =?utf-8?B?QUY5WGZhODlMQXcxUTBDMGtBTjdsUHp1UFBlQVJBQUV2NklCMi92TEMzaS9O?=
 =?utf-8?B?Mmgra1dvQVh4SUoybk9IUzVSTWVlUTJaUnM1UmlhRE0vM0J5TWIrRldsNjhO?=
 =?utf-8?B?T0EvbFZlTHNWUnIxRkVIVllMTFRjTWhXTFNEQXJLZnNtSVcvaWthRHRLN3RJ?=
 =?utf-8?B?dTZtNzhuTSs4YXJhNDJLTHhnUThLSWE0VS9VSGlzQTFoN3AwSGR5RTNLWklk?=
 =?utf-8?B?aklyWXZyQ21pWFIwaGNJQW1wc2R4RGx2UDczeDJqcXh1S253WFhqVm9DeGt0?=
 =?utf-8?B?cUZncHozM0VOYllMWXdnaWRSNDhFczlIKzZVd1Fia1Q4b1M4T0hyQVIxTVdp?=
 =?utf-8?B?a0tFZzBzY1ZEemlqM2JmR1UrSlhoeDdLSUQ4c0VnaDMxZDJRS3hVM0I0dXlP?=
 =?utf-8?B?MGVzeVhzTlU1U0VSN0tBOC9CcUVkQjk5bm53STJsVFRBKzVoQVdUSUVmTDZm?=
 =?utf-8?B?UjBMYmIzR3VTWWszR2JtN0padGQyNitIbTlONXdPbUlsa1J4ckpEYnlRYlEv?=
 =?utf-8?B?WStUT2VxTHRWQmpVTDdlZ3pPWktOT1djUkU1QkhyK1lzeFJqOEJsWEFDcXpE?=
 =?utf-8?B?ZndXZE9saWpOMXBrUEtFbW0vZWpNNzY0ME1JNkp2NUZtNUtYMnY0eDlOWmFM?=
 =?utf-8?B?RlhQQzA1WXgrOG0yUUE4K0FOVkpIalp0RVF5WDYzbzlkcHNkb3ZNck5ZelpZ?=
 =?utf-8?B?bFBqeHVWekdheTRrL25YVG14OXdoNldjQkpkSTJIZ3l2aE05RDRaUThHNU1F?=
 =?utf-8?B?TGxBU1hIaHJIL3l5dVZsYVZNYTRyVDNJektucmlndUw0bFpVYkxTdGVCZURt?=
 =?utf-8?B?R082dmllRUlwYWY1SFlXYWVlSUErc3h2TkVSWXFYbWFMa1p4bFJLeUQvbUlB?=
 =?utf-8?B?Tm9WWjNWck9Nc2czQjJJajRDM2VvWG5BVWkyVGdxN1Y1YW51T2VFbjB4TmJK?=
 =?utf-8?B?V3BzNkpPaWpWemNRMlo0Zmpzdkt1MkJPQ1ZjOTRhTUZuSU9vQ0VlZkc0SHRy?=
 =?utf-8?B?VllCelFZSExvNEU5eW42SkoyOWZoc2RwLzFvaFZrVk5TYlZpeWllYi9DVDdF?=
 =?utf-8?B?VWJUZW02SU9hUjNud0RGdFhHS2VCVndtem1ycWtEVzFWY1dJT1JQb2lSRG9K?=
 =?utf-8?B?YTdOYVVINmNwOUVqZHREdTJyTnVWQ0p2Q2hPcEVyVHp1TzdXU2lPQ2NIWFcz?=
 =?utf-8?B?Z0xsNEo5VkVnSjlHb1c3Y3lvVGVtbjduOVJqRWlMRU02ZXBzZkdodkQ5Qjgw?=
 =?utf-8?B?SWRwZWlGckFDaG1zeEdoOHoramREZElwY1gwTW94V0daOGJDMUVDb1RocVVZ?=
 =?utf-8?B?T3daenQwci9BS08vUkhMR2tyaldua2dHUDNwV3IyaU90SC94eEp6a0h5a2hi?=
 =?utf-8?B?cGwvdkMySkY1Y3RZcEZzWkZQVGZEK280TnhaeTFMODlLdWNPUW9SVGZYNDZP?=
 =?utf-8?B?M3o4eHMxMWxlck13OHdWTEpMRnBuVDhMTUJkM244S2YrS3RPZ1RFR0NxNjA0?=
 =?utf-8?B?WFYxM1psMUpEWmpUYVVZdzk2alNEN3V5RmJaUzdGelcxVVp3TFlLVjFlWklJ?=
 =?utf-8?B?eFJIbHcwRjdRZ2pRK0lkbStvQ3I5MVNJWlUzM0g4N0lWTktxTDRySmZDZ1Yv?=
 =?utf-8?B?Yit3VlkwT0NvQ0RqODM0SjlyNVk1cTRrYjRUUDRROFBlZXkzdkh0Umk1V09L?=
 =?utf-8?Q?8uoT/2QhUUvglQjhlKjPyEE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4780f435-f0f8-4e6e-4169-08d9faf5eaa6
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 20:07:16.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9i/3JKdvHOc+ANDAjhzus2inu3JjqQ65q85KPxov4Nf4LQL0qSpalNxmpuhhtHy3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1352
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 28.02.22 um 20:56 schrieb Linus Torvalds:
> On Mon, Feb 28, 2022 at 4:19 AM Christian König
> <christian.koenig@amd.com> wrote:
>> I don't think that using the extra variable makes the code in any way
>> more reliable or easier to read.
> So I think the next step is to do the attached patch (which requires
> that "-std=gnu11" that was discussed in the original thread).
>
> That will guarantee that the 'pos' parameter of list_for_each_entry()
> is only updated INSIDE the for_each_list_entry() loop, and can never
> point to the (wrongly typed) head entry.
>
> And I would actually hope that it should actually cause compiler
> warnings about possibly uninitialized variables if people then use the
> 'pos' pointer outside the loop. Except
>
>   (a) that code in sgx/encl.c currently initializes 'tmp' to NULL for
> inexplicable reasons - possibly because it already expected this
> behavior
>
>   (b) when I remove that NULL initializer, I still don't get a warning,
> because we've disabled -Wno-maybe-uninitialized since it results in so
> many false positives.
>
> Oh well.
>
> Anyway, give this patch a look, and at least if it's expanded to do
> "(pos) = NULL" in the entry statement for the for-loop, it will avoid
> the HEAD type confusion that Jakob is working on. And I think in a
> cleaner way than the horrid games he plays.
>
> (But it won't avoid possible CPU speculation of such type confusion.
> That, in my opinion, is a completely different issue)

Yes, completely agree.

> I do wish we could actually poison the 'pos' value after the loop
> somehow - but clearly the "might be uninitialized" I was hoping for
> isn't the way to do it.
>
> Anybody have any ideas?

I think we should look at the use cases why code is touching (pos) after 
the loop.

Just from skimming over the patches to change this and experience with 
the drivers/subsystems I help to maintain I think the primary pattern 
looks something like this:

list_for_each_entry(entry, head, member) {
     if (some_condition_checking(entry))
         break;
}
do_something_with(entry);

So the solution should probably not be to change all those use cases to 
use more temporary variables, but rather to add a list_find_entry(..., 
condition) macro and consistently use that one instead.

Regards,
Christian.

>
>                  Linus

