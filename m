Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF834C6C07
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiB1MUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiB1MUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:20:12 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACBB70849;
        Mon, 28 Feb 2022 04:19:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gak+0VG7f2cK1qGBIYboMz3Rmo1e2+a3Qadt70yr+SXalhPkhKa3w30ibrppZy7J9X0U+bYR1DEsjxK7vkl+BudKRh2xhxnGWokUrtqa9Ya7IfUQlH57vxKDpZGaToSEDW9l7aFNG3sxll4z7Cw3o6ihXkNwnjdKSc8q1j7cNYGZijzB+GOgJtLQlm3hrumQbSSOfCPjerllCYNa+Y6byoisv/EQrCAg39Paj09WWowL67ZuiWACgQOClzLerq7E1FeC0W9wdN7gFQiQmga03SsKY43ILsXZUa9Mucd961jBDV7QKl9s8tl1ErdLe8FWGo3uTdaFMixnDJB0vZmePQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFAhmo3JBYJdhOBKzHNL9AJtIawE+V/fgYNxajT2ljI=;
 b=SzZWjd1fmgSJStHirEOCRnkAmcu3OmudpoaEyqknhomm8RjYXkMjnw1ABFAQ2dq8DbNrpQGxXY9ZQCiz+GnKJJqoOOTTXEuSJttXUAE7tqLVwj72QyYBoUE01Ym1R2ysVx8qf1JEPCuK12Olclw0Hna1trvdCt7Ic2GSai4vecGnv3uFeBp1cenwkYIGQD/CdiTDXQhMTXAYac+GdgHxinfvyCaI+nKqXhAaeYMEQJpqURd4/Dsaya54VHucuv6Zoch9wWHfqV2fB2v0eT2viWGd7XTwAYkc5qGDRx9T7ETYzGx6t8awxL24AQJ31xn8GI8ufl45Byu3EOXIQm4IMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFAhmo3JBYJdhOBKzHNL9AJtIawE+V/fgYNxajT2ljI=;
 b=AlIDg5tMzU18Zc+t9R+CoEaHA+AOb1jz/Nyu5OM7D+/2O/6lpB0dewE1ku3pJKeEoY8BydetUnPZUqFvCh2ilwJroT6ut+CA2XOTHnKRtbmsCQfR7AAIyWnBiCUAjqsHtIoqImAU9HMv8ZrZaEvOJGpDXNmlwxNnn4UlV4i6ZuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by MWHPR12MB1295.namprd12.prod.outlook.com (2603:10b6:300:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 12:19:30 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 12:19:30 +0000
Message-ID: <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
Date:   Mon, 28 Feb 2022 13:19:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel@lists.freedesktop.org,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx@lists.freedesktop.org, samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-cifs@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>, linux-pm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-sgx@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20220228110822.491923-3-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P193CA0051.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::28) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 927c171a-822c-407a-0fdb-08d9fab491db
X-MS-TrafficTypeDiagnostic: MWHPR12MB1295:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1295A5EA7DAABF83602189E383019@MWHPR12MB1295.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxyezJsmPy26yjbJiE7nsfiUmF0CrlIboTAwmgzX+NACMNF0P25qUQTowXZYFwLnL07ApfYLgfmlTTlbgnXiRNw3HipcQ8YR9n20WGUM4qVXClwvgS2U+5fbxmfiL1YJ3b4dKP58UnnBLEPlJ59UilT4fZs46PS1fW/z09P1pFxsFPxnfyjzXR4SKtzdPjD8pdLQ8Kuy+2l0dAgEnArYv3uj5znNa1rQ1Hoq/K9GX8bP7u3bYhwZ3G7tvOtwzFR8Ta2MGzOk18aOUbCOKf9+NPI1BAokmmASt6vuYyQl9d6diYO5nnGHvlTt8B97TsJduPfAWtmOXc4pGnhEnGvVkJzJ9Q5UoXw6MGsLnQFAvjCFOS5HUttb3W5KQYRHVWSwfogIFAGfvtFO+lDHC+zygYhcr4vKIF5NwmlrjZe/eYf8EP+TvHA9+tl3ASpRWWdauBP0CwG4cAkCxjiJR/bBkhVEPuvZl3gldzU8eZLh6J409seJbpIj1B3mXQakZi/ADxm0gFDuRFrSFkrLksAlJNLnP2ba8pyWbR8sZiD7/xv+btdb9URSvZP51q7+HLGr+O6HkKjfWrXmkHOpnHpQ0HDh1kufULkKjdiTyUbvjlsAcLox6Kv+USztKXk8wsuMfL7cp8xrU8lMEmEm4ojd6a9DhZsM9Wdu+UjIl4m5D/tT+6dGUe98wGH7LMWEEawZ3jSOjYoFYkV7E4/D5zrhIvYMsvhiVWs/D7ffpMq0AfurcvoBBzJjFVjkZdegPoSo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7406005)(6512007)(5660300002)(7366002)(7416002)(6506007)(31686004)(36756003)(6486002)(2906002)(83380400001)(2616005)(54906003)(508600001)(110136005)(31696002)(8936002)(86362001)(186003)(38100700002)(6666004)(316002)(4326008)(66476007)(66946007)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnVEZUhHVmdLQlRDREtha0hYNEd6bWZuNDJmWmFJc2I4MHI3amtWSVdaSTNv?=
 =?utf-8?B?VkxUUUMxWU5QSzNpSHU3QzdicVZ0RWFpcTc2NHk5aVJLaUF6S2EreTNldTd2?=
 =?utf-8?B?Y1ZDZEcwakpzV0VORi9yNmt5YktCVWVlaWVSTmlQWjNUZDAyQ0NBOFlKV1R0?=
 =?utf-8?B?K3VIQnZ3N1k2ajl6WURIOTVYRmdkbzFBUlFQY1ZIVDl5ZVVNZE04WWY3RzdI?=
 =?utf-8?B?NFBENGxZMVh3KzdYSmVKYzB2MlY1YytOZ3pQdjZ1NHdiRmtNSlQwYjYrSGJS?=
 =?utf-8?B?S0lmS3RRUVU1TGh2Ym0yQkdmWWFzN1VwSmNzQW1IR0RmMmU4SjZ5Mm0ydXVP?=
 =?utf-8?B?UEN6a3N0aGJVQkQrTG5nWTVYTzVDQkI1dGxlMURwN0N2Rk1FN0g1VnNKZWVW?=
 =?utf-8?B?S1VoamV3L1BKLzBnaEdCWUhEN2I3ZERSM21LVXBEcVo1M011QmVuQXZMS05Z?=
 =?utf-8?B?NFNEV2tydTR2VlFkMlNESjdzVGhaNW1PNjlBNDA0bEthUnBJc3F3UkhvaE9o?=
 =?utf-8?B?M2ZyVVcvMTNvSU13ZTl0UTRUTXZFY3IzZmxlcnlnZ2FudWM3dXZOZ3IvNEVD?=
 =?utf-8?B?cS96alNTbmFWNzZrcUVJdUgzeGM5MCs0c2JKWUZMRnkzR3E2TVUycTB2RVFy?=
 =?utf-8?B?MzE4QUtkUmQ4bCtqcmI0QktyYVVmd3k5eXZ0Z1R4ejZwekhIUFYyUjRYVkQ0?=
 =?utf-8?B?Z1JiUWpWbzRITWtSc1FTV2lIY0ZlTzhKampXVVhwbk1qbTE4NXNobDNUdWdo?=
 =?utf-8?B?dngxTjRLTGlpYmVtYzBaZWJPNEs0Nkg0Q05ERDY1RjBzZVlZMks1UVhlYTNT?=
 =?utf-8?B?LytTbGxaV29uWFpiYmRlVjc4QUh1OEYwT3FUbHpXZDNkbnNZVkJWZHArZ0Zx?=
 =?utf-8?B?bFFMV2FTUHhtZ3BJSTNzeEd1QnpZS21nWiszbEpxWXNSOU4wb3FWUEd6WUN6?=
 =?utf-8?B?bmc4OEZ4RGY3N2tsdFdhRVZhR1E5YU1QUFJFSnAxb2s1SjI0YkRYeW1ybDI5?=
 =?utf-8?B?YzQ2c0lJZ3ZSQXVZNVVYWHFMTENXclNua3lORlhuM3Bac2pLUVQ1aFdQYldQ?=
 =?utf-8?B?Qm5iVnM2RTBoYVV6eWlVWDdFTG1NaGdZeDVVeG5HdmxGOW9oVkIxMk5GanRC?=
 =?utf-8?B?L1RxOVNMOHduYUNLM0VYbzg3TTd1TmxPQjZOV2ZzZjRScjRoejlaTURnVHJj?=
 =?utf-8?B?V3E5MHZyS0FNc0VRSmg2aGM1MVhUeFppdnBjbWtSQjUxY3hjTW9sVytKY0tl?=
 =?utf-8?B?bXI2MjJNMFZRTzZSajQyMEpHMnBqZThxK2ljY0pIN2NkemdCazdMYWZTZXhO?=
 =?utf-8?B?THpWZE9iVG16UkZvNENTUkpzdkI4eFNvMGxTWi96Q214R20xeWQ2Q3ZhZEN4?=
 =?utf-8?B?ZmZJb1N2WXc0NUsreUM5ekFOc1dlQTJQVkN5TW1QSy82WmZLTkorNE1aNzNE?=
 =?utf-8?B?dFhzdnk2dys4RmtUVytnZk9Zdlhrb1ptMFk3SWlCYmpUS1JxcGRLdWNkZTV5?=
 =?utf-8?B?K3h1SFcrOFliSWhzZWt5eGFINWpaWEFXL0FpNWRRelJOd0JMS3lpdDFEMUdP?=
 =?utf-8?B?eDhPQjhjVm9MS2xoYTgvdTlGbFd5WnZ4cW9uNjRHWWdueXlwZUJRWVBGN1Bm?=
 =?utf-8?B?b2tlcmh3Tm5pU0drcVBTVVltN2w2OXpPZS9tSjd6YTY1dTJMY1MzQnB5eUQ1?=
 =?utf-8?B?c2VHME0zd3N4dVIrUVlKeE4xcVJ0QWI2dW9vaEpkelNsVXM3cWZqRGlEZTJP?=
 =?utf-8?B?MUY2RHR3MWZ0Yk82NSthdy9FTG1CQ3J4YnFMakU5UUtlZWJlN1NXazR5a1NZ?=
 =?utf-8?B?d09rUmV5QXpwTjMzK2F6SVRZNFNMTGtlUCtTNS9qc3Byc3ZaRUJFQUtJTW5y?=
 =?utf-8?B?NUNYck1SckJLTnpOR1d4L3Rpb21OSHlSR1JkVDdZZlVGUjVXWGxlRTA2bmg5?=
 =?utf-8?B?U1JDZXdQUjd0WkVjajE4dFY0QWpYNkN1cGVxdFR1OVkxUFlGUjRaUzhEQWlp?=
 =?utf-8?B?cjYwaWc1L2Y0NTVzd3lrMlBodGMybWZLb2VUWWx2US9EclJjR29OaEZ1ZjZ4?=
 =?utf-8?B?UFdYck5CMlA2UytrZUdob1Z6YjdnTEh6cElLT0lLMjByVGJJOTBZRWE1Um5h?=
 =?utf-8?B?QmZ2OFNhNXBNU1lwVGI5YkNoRnRSdFdqeGRSbmFkL1I2anJyRXZ0bW5IeVI4?=
 =?utf-8?Q?R6iIn8pdIonNpLAFjDShZ1w=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927c171a-822c-407a-0fdb-08d9fab491db
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 12:19:30.0401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yz+/jU3IY5U41ZTP4nxROOoIIb/zKsZboh12RZsNA0NdemZ8rLgm5wIEvLhrWIBd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1295
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 28.02.22 um 12:08 schrieb Jakob Koschel:
> If the list does not contain the expected element, the value of
> list_for_each_entry() iterator will not point to a valid structure.
> To avoid type confusion in such case, the list iterator
> scope will be limited to list_for_each_entry() loop.

We explicitly have the list_entry_is_head() macro to test after a loop 
if the element pointer points to the head of the list instead of a valid 
list entry.

So at least from my side I absolutely don't think that this is a good idea.

> In preparation to limiting scope of a list iterator to the list traversal
> loop, use a dedicated pointer to point to the found element.
> Determining if an element was found is then simply checking if
> the pointer is != NULL.

Since when do we actually want to do this?

Take this code here as an example:
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 48afe96ae0f0..6c916416decc 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -450,7 +450,8 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
>   				     struct mm_struct *mm)
>   {
>   	struct sgx_encl_mm *encl_mm = container_of(mn, struct sgx_encl_mm, mmu_notifier);
> -	struct sgx_encl_mm *tmp = NULL;
> +	struct sgx_encl_mm *found_encl_mm = NULL;
> +	struct sgx_encl_mm *tmp;
>
>   	/*
>   	 * The enclave itself can remove encl_mm.  Note, objects can't be moved
> @@ -460,12 +461,13 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
>   	list_for_each_entry(tmp, &encl_mm->encl->mm_list, list) {
>   		if (tmp == encl_mm) {
>   			list_del_rcu(&encl_mm->list);
> +			found_encl_mm = tmp;
>   			break;
>   		}
>   	}
>   	spin_unlock(&encl_mm->encl->mm_lock);
>
> -	if (tmp == encl_mm) {
> +	if (found_encl_mm) {
>   		synchronize_srcu(&encl_mm->encl->srcu);
>   		mmu_notifier_put(mn);
>   	}

I don't think that using the extra variable makes the code in any way 
more reliable or easier to read.

Regards,
Christian.
