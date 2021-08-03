Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF93DEB90
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhHCLIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:08:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57854 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhHCLIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:08:16 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210803110804euoutp0263ccbbfa7b4d03ac78e2f6fac0dd8c3d~Xx0PWfiX_1141511415euoutp02r
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 11:08:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210803110804euoutp0263ccbbfa7b4d03ac78e2f6fac0dd8c3d~Xx0PWfiX_1141511415euoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627988884;
        bh=jjRXzXx+E6YBE/FJwc1jA6f97seFUP3hkBl1p6Z1AF8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=sbRzxrHoWk7dUvsT5BA7SBXvhnp0LVDBUVzJ6OvoQQ8oDDRaP9mF9iEx/TZrXoEg4
         BzII0sOtBZBbvnnT3DTEjeJFtH3xYvP8XOjh6X1Ze0OmIMyvqJ7zTpVovbc1tIwe9u
         qj05qNtYOs2rihsvlFlsKKuDupmwj34MmL2mdBwA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210803110804eucas1p173d793685023a4e00c7dd6d49a4ce54f~Xx0O9vV6G2365923659eucas1p1I;
        Tue,  3 Aug 2021 11:08:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 9D.E9.45756.39329016; Tue,  3
        Aug 2021 12:08:03 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210803110803eucas1p276a0010caad8fc21a7ea5ca5543294f8~Xx0OiwCql3065330653eucas1p2R;
        Tue,  3 Aug 2021 11:08:03 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210803110803eusmtrp29144918212bfc6d811f23ba401b32281~Xx0OiBfWu0575805758eusmtrp2k;
        Tue,  3 Aug 2021 11:08:03 +0000 (GMT)
X-AuditID: cbfec7f2-7d5ff7000002b2bc-62-610923932a33
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 8D.13.20981.39329016; Tue,  3
        Aug 2021 12:08:03 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210803110802eusmtip16f511e196ad0b769983d5ca464a94c6b~Xx0N7t06z0187201872eusmtip1H;
        Tue,  3 Aug 2021 11:08:02 +0000 (GMT)
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <14e0ec1c-0345-d5d4-769a-44ded33821e8@samsung.com>
Date:   Tue, 3 Aug 2021 13:08:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729071350.28919-1-yajun.deng@linux.dev>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7djP87qTlTkTDVbusLbYOGM9q8Wc8y0s
        Fut2tTJZXNjWx2rx8uc8RovLu+awWRxbIGbxfc96Jouve7tYHDg9tqy8yeSxaVUnm0fbtVVM
        HgsbpjJ77F7wmcmjb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Ml59v8la8Ne8Yun1b2wNjK36
        XYycHBICJhJXrj5h72Lk4hASWMEosWdiLyOE84VR4vuKD1CZz4wSExZvYoZpWXfzDDNEYjmj
        xNMvr9ggnI+MEuf+zAOrEhZwkfh14CUrSEJEYBOjxJ8lf4AGc3AwCyRL7FqqCFLDJmAo0fW2
        iw3E5hWwk/h8tp8FpIRFQEXi4DMzkLAoUPWd0++hSgQlTs58wgJicwpYSXw60s8KYjMLyEs0
        b53NDGGLS9x6Mp8JZK2EwA8OiQ1nj0Bd7SJxqPsCG4QtLPHq+BZ2CFtG4v9OmIZmRomH59ay
        Qzg9jBKXm2YwQlRZS9w594sN4gFNifW7oKHnKPH0/xR2kLCEAJ/EjbeCEEfwSUzaNp0ZIswr
        0dEmBFGtJjHr+Dq4tQcvXGKewKg0C8lrs5C8MwvJO7MQ9i5gZFnFKJ5aWpybnlpsmJdarlec
        mFtcmpeul5yfu4kRmKpO/zv+aQfj3Fcf9Q4xMnEwHmKU4GBWEuENvcGRKMSbklhZlVqUH19U
        mpNafIhRmoNFSZx31ew18UIC6YklqdmpqQWpRTBZJg5OqQamcI3jM1VOz5u6uKufZc/MqDLG
        162hjleLhGqVZubxsAYGalpv+hLNu/eKzIzQKxfPV/BN/B9mVKX8tDbwQHu0Z19HbsqZ3YGl
        DgoVK15kfC+4v1u+ck/VjiP2GaXPxUpWX57AspjbNtE0S/f+mnnXDKtWuzw93rWydcLbm4sW
        ak+YeuHLj1NiHa5LZnzYHO/36kdFhozKGjFGo2lOX4o/3heOuVXP+DDmYtHmyr/LN/T5WS/7
        Y2B0cuaFzVbpzX/vWy3WE1/ZWHpKUGjCEvdDnRUrQ18lulYpnU36phOqF1rb0ZdjWx8bM+Ot
        U4PR04Dretfutvv9ErZ5/KCUpV37493NF2c9CFf50ZjqcdFFiaU4I9FQi7moOBEAR0D6H8QD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/xu7qTlTkTDZ6ekLfYOGM9q8Wc8y0s
        Fut2tTJZXNjWx2rx8uc8RovLu+awWRxbIGbxfc96Jouve7tYHDg9tqy8yeSxaVUnm0fbtVVM
        HgsbpjJ77F7wmcmjb8sqRo/Pm+QC2KP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1j
        rYxMlfTtbFJSczLLUov07RL0Ml59v8la8Ne8Yun1b2wNjK36XYycHBICJhLrbp5hBrGFBJYy
        SjzakgkRl5E4Oa2BFcIWlvhzrYuti5ELqOY9o8S8JSfYQBLCAi4Svw68ZAVJiAhsYpQ4/XsZ
        WIJZIFni1uSfQAkOoA5LifXPgkDCbAKGEl1vu8BKeAXsJD6f7WcBKWERUJE4+MwMJCwK1Nn3
        ZQIjRImgxMmZT1hAbE4BK4lPR/pZIaabSczb/JAZwpaXaN46G8oWl7j1ZD7TBEahWUjaZyFp
        mYWkZRaSlgWMLKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzEC43LbsZ9bdjCufPVR7xAjEwfj
        IUYJDmYlEd7QGxyJQrwpiZVVqUX58UWlOanFhxhNgd6ZyCwlmpwPTAx5JfGGZgamhiZmlgam
        lmbGSuK8JkfWxAsJpCeWpGanphakFsH0MXFwSjUwZSaybl9fIeuymV96ev9pBo35DPPXvfrv
        vOy76eHzH47firmz7eu9aj8+/YdL1L5KrjTtPNBXzKt9u23ClH3/aqbej/1S43Ot/2ZM6A03
        hcg4o3uXlgYkNGfyhCxj2/3g1o/l8izl7VWBz1IkGzcY65w/sZN5pv78U5r7+Rd7vltrEPko
        XmAOzxH/485vjIT7J74K6l0nOuOzrqkfr6TG3idat728swymCJyytFB6sav9m+uE4y/Xpu64
        tFnp9OKtEwqFv6oy/V5+Xu2E2m4FlxK+GdnM7zebbNToY3bZuqlpMuutHIbF6c/EpsdKXpq9
        9OejdQvjy0ruT+jWjIvd+37zs/jLarOPTPQ8ds/j5g8lluKMREMt5qLiRAAV0Av6VAMAAA==
X-CMS-MailID: 20210803110803eucas1p276a0010caad8fc21a7ea5ca5543294f8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210803110803eucas1p276a0010caad8fc21a7ea5ca5543294f8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210803110803eucas1p276a0010caad8fc21a7ea5ca5543294f8
References: <20210729071350.28919-1-yajun.deng@linux.dev>
        <CGME20210803110803eucas1p276a0010caad8fc21a7ea5ca5543294f8@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 29.07.2021 09:13, Yajun Deng wrote:
> refcount_t type should be used instead of int when fib_treeref is used as
> a reference counter,and avoid use-after-free risks.
>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

This patch landed in linux-next 20210802 as commit 79976892f7ea ("net: 
convert fib_treeref from int to refcount_t"). It triggers the following 
warning on all my test systems (ARM32bit and ARM64bit based):

------------[ cut here ]------------
WARNING: CPU: 3 PID: 858 at lib/refcount.c:25 fib_create_info+0xbd8/0xc18
refcount_t: addition on 0; use-after-free.
Modules linked in: s5p_csis s5p_mfc s5p_fimc exynos4_is_common s5p_jpeg 
v4l2_fwnode v4l2_async v4l2_mem2mem videobuf2_dma_contig 
videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc s5p_cec
CPU: 3 PID: 858 Comm: ip Not tainted 5.14.0-rc2-00636-g79976892f7ea #10620
Hardware name: Samsung Exynos (Flattened Device Tree)
[<c0111900>] (unwind_backtrace) from [<c010d0b8>] (show_stack+0x10/0x14)
[<c010d0b8>] (show_stack) from [<c0b827b0>] (dump_stack_lvl+0x58/0x70)
[<c0b827b0>] (dump_stack_lvl) from [<c0127938>] (__warn+0x118/0x11c)
[<c0127938>] (__warn) from [<c01279b4>] (warn_slowpath_fmt+0x78/0xbc)
[<c01279b4>] (warn_slowpath_fmt) from [<c0a5b600>] 
(fib_create_info+0xbd8/0xc18)
[<c0a5b600>] (fib_create_info) from [<c0a5fe20>] 
(fib_table_insert+0x90/0x650)
[<c0a5fe20>] (fib_table_insert) from [<c0a54ea0>] (fib_magic+0x164/0x16c)
[<c0a54ea0>] (fib_magic) from [<c0a580d0>] (fib_add_ifaddr+0x60/0x158)
[<c0a580d0>] (fib_add_ifaddr) from [<c0a58e6c>] 
(fib_inetaddr_event+0x7c/0xc0)
[<c0a58e6c>] (fib_inetaddr_event) from [<c0154ef0>] 
(blocking_notifier_call_chain+0x6c/0x94)
[<c0154ef0>] (blocking_notifier_call_chain) from [<c0a448ec>] 
(__inet_insert_ifa+0x29c/0x3b8)
[<c0a448ec>] (__inet_insert_ifa) from [<c0a4882c>] 
(inetdev_event+0x204/0x79c)
[<c0a4882c>] (inetdev_event) from [<c0154c0c>] 
(raw_notifier_call_chain+0x34/0x6c)
[<c0154c0c>] (raw_notifier_call_chain) from [<c0988900>] 
(__dev_notify_flags+0x5c/0xcc)
[<c0988900>] (__dev_notify_flags) from [<c09890b0>] 
(dev_change_flags+0x3c/0x44)
[<c09890b0>] (dev_change_flags) from [<c09993f8>] (do_setlink+0x338/0x9f0)
[<c09993f8>] (do_setlink) from [<c099fc70>] (__rtnl_newlink+0x51c/0x804)
[<c099fc70>] (__rtnl_newlink) from [<c099ff9c>] (rtnl_newlink+0x44/0x60)
[<c099ff9c>] (rtnl_newlink) from [<c099ba74>] 
(rtnetlink_rcv_msg+0x154/0x4f4)
[<c099ba74>] (rtnetlink_rcv_msg) from [<c09d44a4>] 
(netlink_rcv_skb+0xe4/0x118)
[<c09d44a4>] (netlink_rcv_skb) from [<c09d3c0c>] 
(netlink_unicast+0x1ac/0x240)
[<c09d3c0c>] (netlink_unicast) from [<c09d3f70>] 
(netlink_sendmsg+0x2d0/0x418)
[<c09d3f70>] (netlink_sendmsg) from [<c0955a30>] 
(____sys_sendmsg+0x1d4/0x230)
[<c0955a30>] (____sys_sendmsg) from [<c095755c>] (___sys_sendmsg+0x70/0x9c)
[<c095755c>] (___sys_sendmsg) from [<c0957964>] (__sys_sendmsg+0x54/0x90)
[<c0957964>] (__sys_sendmsg) from [<c0100060>] (ret_fast_syscall+0x0/0x2c)
Exception stack(0xc346dfa8 to 0xc346dff0)
dfa0:                   becb275c becaa6a4 00000003 becaa6b0 00000000 
00000000
dfc0: becb275c becaa6a4 00000000 00000128 0050e304 61091e59 0050e000 
becaa6b0
dfe0: 0000006c becaa660 004d7f80 b6e7fab8
irq event stamp: 5457
hardirqs last  enabled at (5465): [<c01a53d0>] console_unlock+0x50c/0x650
hardirqs last disabled at (5484): [<c01a53b4>] console_unlock+0x4f0/0x650
softirqs last  enabled at (5544): [<c0101768>] __do_softirq+0x500/0x63c
softirqs last disabled at (5493): [<c0131578>] irq_exit+0x214/0x220
---[ end trace dc2378f379f97dd0 ]---

This issue should be possible to trigger also with qemu. If you need any 
help in reproducing it, let me know.

> ---
>   include/net/dn_fib.h     | 2 +-
>   include/net/ip_fib.h     | 2 +-
>   net/decnet/dn_fib.c      | 6 +++---
>   net/ipv4/fib_semantics.c | 8 ++++----
>   4 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/dn_fib.h b/include/net/dn_fib.h
> index ccc6e9df178b..ddd6565957b3 100644
> --- a/include/net/dn_fib.h
> +++ b/include/net/dn_fib.h
> @@ -29,7 +29,7 @@ struct dn_fib_nh {
>   struct dn_fib_info {
>   	struct dn_fib_info	*fib_next;
>   	struct dn_fib_info	*fib_prev;
> -	int 			fib_treeref;
> +	refcount_t		fib_treeref;
>   	refcount_t		fib_clntref;
>   	int			fib_dead;
>   	unsigned int		fib_flags;
> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 3ab2563b1a23..21c5386d4a6d 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -133,7 +133,7 @@ struct fib_info {
>   	struct hlist_node	fib_lhash;
>   	struct list_head	nh_list;
>   	struct net		*fib_net;
> -	int			fib_treeref;
> +	refcount_t		fib_treeref;
>   	refcount_t		fib_clntref;
>   	unsigned int		fib_flags;
>   	unsigned char		fib_dead;
> diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
> index 77fbf8e9df4b..387a7e81dd00 100644
> --- a/net/decnet/dn_fib.c
> +++ b/net/decnet/dn_fib.c
> @@ -102,7 +102,7 @@ void dn_fib_free_info(struct dn_fib_info *fi)
>   void dn_fib_release_info(struct dn_fib_info *fi)
>   {
>   	spin_lock(&dn_fib_info_lock);
> -	if (fi && --fi->fib_treeref == 0) {
> +	if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
>   		if (fi->fib_next)
>   			fi->fib_next->fib_prev = fi->fib_prev;
>   		if (fi->fib_prev)
> @@ -385,11 +385,11 @@ struct dn_fib_info *dn_fib_create_info(const struct rtmsg *r, struct nlattr *att
>   	if ((ofi = dn_fib_find_info(fi)) != NULL) {
>   		fi->fib_dead = 1;
>   		dn_fib_free_info(fi);
> -		ofi->fib_treeref++;
> +		refcount_inc(&ofi->fib_treeref);
>   		return ofi;
>   	}
>   
> -	fi->fib_treeref++;
> +	refcount_inc(&fi->fib_treeref);
>   	refcount_set(&fi->fib_clntref, 1);
>   	spin_lock(&dn_fib_info_lock);
>   	fi->fib_next = dn_fib_info_list;
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 4c0c33e4710d..fa19f4cdf3a4 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -260,7 +260,7 @@ EXPORT_SYMBOL_GPL(free_fib_info);
>   void fib_release_info(struct fib_info *fi)
>   {
>   	spin_lock_bh(&fib_info_lock);
> -	if (fi && --fi->fib_treeref == 0) {
> +	if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
>   		hlist_del(&fi->fib_hash);
>   		if (fi->fib_prefsrc)
>   			hlist_del(&fi->fib_lhash);
> @@ -1373,7 +1373,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>   		if (!cfg->fc_mx) {
>   			fi = fib_find_info_nh(net, cfg);
>   			if (fi) {
> -				fi->fib_treeref++;
> +				refcount_inc(&fi->fib_treeref);
>   				return fi;
>   			}
>   		}
> @@ -1547,11 +1547,11 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>   	if (ofi) {
>   		fi->fib_dead = 1;
>   		free_fib_info(fi);
> -		ofi->fib_treeref++;
> +		refcount_inc(&ofi->fib_treeref);
>   		return ofi;
>   	}
>   
> -	fi->fib_treeref++;
> +	refcount_inc(&fi->fib_treeref);
>   	refcount_set(&fi->fib_clntref, 1);
>   	spin_lock_bh(&fib_info_lock);
>   	hlist_add_head(&fi->fib_hash,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

