Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EAB576819
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiGOU3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiGOU3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:29:06 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D13B13E18
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 13:29:04 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220715202901euoutp01998c9b93acce33deb37aa6126c897797~CGqyWu32j1054310543euoutp01W
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 20:29:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220715202901euoutp01998c9b93acce33deb37aa6126c897797~CGqyWu32j1054310543euoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657916941;
        bh=lVOp6I6bfKl0luyaOjOSYlf8wYGlnw7cQl6Oy5MK7HE=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=nkD/G7m1aHj0SKbtn600ifS4fBviWZSt1lT9KMNg2IOJsIqERPFPYzv3JU1JcKjl5
         slc85h0mDMM24hEYJ2wbDXxH50jpcZ9UUMCuIVHn5TNHiGKuIBbhWesdhxolSTC15V
         n7MksvntTROeNs3dDzQ+Hosj8XRqqHLKbNdGBwR8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220715202900eucas1p2667f85772dc79a2012e8e3e9d84014e8~CGqxRewyq1480614806eucas1p2L;
        Fri, 15 Jul 2022 20:29:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 9C.E0.09580.C0EC1D26; Fri, 15
        Jul 2022 21:29:00 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12~CGqwI_1to1703017030eucas1p10;
        Fri, 15 Jul 2022 20:28:59 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220715202859eusmtrp24d942479abf37774c31c31273e0a1d40~CGqwIO0wN2146221462eusmtrp24;
        Fri, 15 Jul 2022 20:28:59 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-6b-62d1ce0c6ade
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 4E.6E.09038.A0EC1D26; Fri, 15
        Jul 2022 21:28:58 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220715202858eusmtip21e9deec70b29bd77e135858064e1b283~CGqvf7NxP1129311293eusmtip2N;
        Fri, 15 Jul 2022 20:28:58 +0000 (GMT)
Message-ID: <46439555-644d-08a1-7d66-16f8f9a320f0@samsung.com>
Date:   Fri, 15 Jul 2022 22:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v3 for-next 2/3] net: copy from user before calling
 __get_compat_msghdr
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220714110258.1336200-3-dylany@fb.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djPc7o85y4mGaz9wGExZ9U2RovVd/vZ
        LOacb2GxmPrHw+LpsUfsFu9az7FYHOt7z2pxYVsfq8WxBWIW306/YXTg8tiy8iaTx8Tmd+we
        O2fdZfdYsKnU4/LZUo9NqzrZPN7vu8rm8XmTXABHFJdNSmpOZllqkb5dAlfG6wvXmQpabCqu
        vW5jbmDcqN/FyMkhIWAicefxF/YuRi4OIYEVjBKftkyHcr4wSmx/uJAFwvnMKDH5/hF2mJaN
        s1pYIRLLGSV+vXvMApIQEvjIKHFmgyuIzStgJ9E16xMbiM0ioCpx6u9RVoi4oMTJmU/A6kUF
        kiXOnb0KViMsECvROe8/2AJmAXGJW0/mM4HYIgJXGCUOvdeBiOtJrOh4DVbPJmAo0fW2C8zm
        FDCVuHt5DiNEjbxE89bZzBCHNnNKPFvACmG7SDz73AJlC0u8Or4F6hkZif87QXZxANn5En9n
        GEOEKySuvV4DNcZa4s65X2wgJcwCmhLrd0FDzlFi9c7zbBCdfBI33gpCHMAnMWnbdGaIMK9E
        R5sQRLWaxKzj6+B2HrxwiXkCo9IspCCZheT1WUhemYWwdwEjyypG8dTS4tz01GLjvNRyveLE
        3OLSvHS95PzcTYzAhHX63/GvOxhXvPqod4iRiYPxEKMEB7OSCG/3oXNJQrwpiZVVqUX58UWl
        OanFhxilOViUxHmTMzckCgmkJ5akZqemFqQWwWSZODilGph0ryiuPTVni8QlYf3OI0d6Inc2
        Cn5mNFE5LfXx22wr59W3rENM4jiM1943jTt378qdOT23L77aubj069mYGVki/1/O6pBctjTE
        5B9/3nrxJw57DBODY3YIejYeON3c98ndh1fiReSaCi/l0/JX1UVT8pLZNtwzNxSTTMvmW/vE
        70aj0ZSb/2IPvVxSxVtRcsUyfvd2eTXuD5YndBf2WlV8KuBf6yLxte6AdSNH8qzNJ1YsWFna
        Pn3Kzne33QzWcyQ6HLmiX9ltsLDz4dav54SjSpn3i03knX9pVXbRWzNR1fWL2kXOTtqp9vGj
        dRWzdFlpybr7iyf/6XWw4prtsnPpTNu32rY37Lz7REzlf71RYinOSDTUYi4qTgQA4hWnuscD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t/xe7pc5y4mGby+bWwxZ9U2RovVd/vZ
        LOacb2GxmPrHw+LpsUfsFu9az7FYHOt7z2pxYVsfq8WxBWIW306/YXTg8tiy8iaTx8Tmd+we
        O2fdZfdYsKnU4/LZUo9NqzrZPN7vu8rm8XmTXABHlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWe
        kYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7G6wvXmQpabCquvW5jbmDcqN/FyMkhIWAisXFW
        C2sXIxeHkMBSRomfb5YyQSRkJE5Oa2CFsIUl/lzrYoMoes8o8axpDRtIglfATqJr1icwm0VA
        VeLU36OsEHFBiZMzn7CA2KICyRLNWw6BDRUWiJXonPefHcRmFhCXuPVkPhPIUBGBa4wSN368
        YYFI6Ems6HgNNlRIIF7iWNN3RhCbTcBQouttF1icU8BU4u7lOYwQ9WYSXVu7oGx5ieats5kn
        MArNQnLHLCT7ZiFpmYWkZQEjyypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAWN127OeWHYwr
        X33UO8TIxMF4iFGCg1lJhLf70LkkId6UxMqq1KL8+KLSnNTiQ4ymwMCYyCwlmpwPTBZ5JfGG
        ZgamhiZmlgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9TBycUg1MxvH1q1cYcjkeFah/eqgh
        75pfS2vIMm33//nussFL771kU7+g73Av+ZzIlzl/7gSYnY966jeh0ZZb4IrcgnepF7fvbUm0
        ijj9b/nvnzc0kq/7NdvZS3nLeF+ZN2nx5NJVn94+fOLH7XBnm+W5jBMZNo1l2+/mrMtZ8P1g
        bU6L10ZDYUP+B6cuG327ufDsUbMbSTE/zsRHlU3/HfZnq4NFzQmHdM5tt/SPH5L2mL+2VuRA
        yeQVb7+LWC+V8b+XcnPajf2qnS9X7tZYUX5e1cAr0Wbn9V0hvVarFZbKyMSdkI32kGX6/HWJ
        7Zzc+znck17WrvcsfjJzxyn/mPzbkRPNVTc1Np2+85PlQ83CN2vbzZVYijMSDbWYi4oTAbbc
        BN9eAwAA
X-CMS-MailID: 20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12
References: <20220714110258.1336200-1-dylany@fb.com>
        <20220714110258.1336200-3-dylany@fb.com>
        <CGME20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 14.07.2022 13:02, Dylan Yudaken wrote:
> this is in preparation for multishot receive from io_uring, where it needs
> to have access to the original struct user_msghdr.
>
> functionally this should be a no-op.
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Dylan Yudaken <dylany@fb.com>

This patch landed in linux next-20220715 as commit 1a3e4e94a1b9 ("net: 
copy from user before calling __get_compat_msghdr"). Unfortunately it 
causes a serious regression on the ARM64 based Khadas VIM3l board:

Unable to handle kernel access to user memory outside uaccess routines 
at virtual address 00000000ffc4a5c8
Mem abort info:
   ESR = 0x000000009600000f
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x0f: level 3 permission fault
Data abort info:
   ISV = 0, ISS = 0x0000000f
   CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000001909000
[00000000ffc4a5c8] pgd=0800000001a7b003, p4d=0800000001a7b003, 
pud=0800000001a0e003, pmd=0800000001913003, pte=00e800000b9baf43
Internal error: Oops: 9600000f [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 247 Comm: systemd-udevd Not tainted 5.19.0-rc6+ #12437
Hardware name: Khadas VIM3L (DT)
pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : get_compat_msghdr+0xd0/0x1b0
lr : get_compat_msghdr+0xcc/0x1b0
...
Call trace:
  get_compat_msghdr+0xd0/0x1b0
  ___sys_sendmsg+0xd0/0xe0
  __sys_sendmsg+0x68/0xc4
  __arm64_compat_sys_sendmsg+0x28/0x3c
  invoke_syscall+0x48/0x114
  el0_svc_common.constprop.0+0x60/0x11c
  do_el0_svc_compat+0x1c/0x50
  el0_svc_compat+0x58/0x100
  el0t_32_sync_handler+0x90/0x140
  el0t_32_sync+0x190/0x194
Code: d2800382 9100f3e0 97d9be02 b5fffd60 (b9401a60)
---[ end trace 0000000000000000 ]---

This happens only on the mentioned board, other my ARM64 test boards 
boot fine with next-20220715. Reverting this commit, together with 
2b0b67d55f13 ("fix up for "io_uring: support multishot in recvmsg"") and 
a8b38c4ce724 ("io_uring: support multishot in recvmsg") due to compile 
dependencies on top of next-20220715 fixes the issue.

Let me know how I can help fixing this issue.

> ---
>   include/net/compat.h |  5 ++---
>   io_uring/net.c       | 17 +++++++++--------
>   net/compat.c         | 39 +++++++++++++++++----------------------
>   3 files changed, 28 insertions(+), 33 deletions(-)
>
> diff --git a/include/net/compat.h b/include/net/compat.h
> index 595fee069b82..84c163f40f38 100644
> --- a/include/net/compat.h
> +++ b/include/net/compat.h
> @@ -46,9 +46,8 @@ struct compat_rtentry {
>   	unsigned short  rt_irtt;        /* Initial RTT                  */
>   };
>   
> -int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg,
> -			struct sockaddr __user **save_addr, compat_uptr_t *ptr,
> -			compat_size_t *len);
> +int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr *msg,
> +			struct sockaddr __user **save_addr);
>   int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
>   		      struct sockaddr __user **, struct iovec **);
>   int put_cmsg_compat(struct msghdr*, int, int, int, void *);
> diff --git a/io_uring/net.c b/io_uring/net.c
> index da7667ed3610..5bc3440a8290 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -369,24 +369,25 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>   					struct io_async_msghdr *iomsg)
>   {
>   	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
> +	struct compat_msghdr msg;
>   	struct compat_iovec __user *uiov;
> -	compat_uptr_t ptr;
> -	compat_size_t len;
>   	int ret;
>   
> -	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr,
> -				  &ptr, &len);
> +	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
> +		return -EFAULT;
> +
> +	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr);
>   	if (ret)
>   		return ret;
>   
> -	uiov = compat_ptr(ptr);
> +	uiov = compat_ptr(msg.msg_iov);
>   	if (req->flags & REQ_F_BUFFER_SELECT) {
>   		compat_ssize_t clen;
>   
> -		if (len == 0) {
> +		if (msg.msg_iovlen == 0) {
>   			sr->len = 0;
>   			iomsg->free_iov = NULL;
> -		} else if (len > 1) {
> +		} else if (msg.msg_iovlen > 1) {
>   			return -EINVAL;
>   		} else {
>   			if (!access_ok(uiov, sizeof(*uiov)))
> @@ -400,7 +401,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>   		}
>   	} else {
>   		iomsg->free_iov = iomsg->fast_iov;
> -		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
> +		ret = __import_iovec(READ, (struct iovec __user *)uiov, msg.msg_iovlen,
>   				   UIO_FASTIOV, &iomsg->free_iov,
>   				   &iomsg->msg.msg_iter, true);
>   		if (ret < 0)
> diff --git a/net/compat.c b/net/compat.c
> index 210fc3b4d0d8..513aa9a3fc64 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -34,20 +34,15 @@
>   #include <net/compat.h>
>   
>   int __get_compat_msghdr(struct msghdr *kmsg,
> -			struct compat_msghdr __user *umsg,
> -			struct sockaddr __user **save_addr,
> -			compat_uptr_t *ptr, compat_size_t *len)
> +			struct compat_msghdr *msg,
> +			struct sockaddr __user **save_addr)
>   {
> -	struct compat_msghdr msg;
>   	ssize_t err;
>   
> -	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
> -		return -EFAULT;
> -
> -	kmsg->msg_flags = msg.msg_flags;
> -	kmsg->msg_namelen = msg.msg_namelen;
> +	kmsg->msg_flags = msg->msg_flags;
> +	kmsg->msg_namelen = msg->msg_namelen;
>   
> -	if (!msg.msg_name)
> +	if (!msg->msg_name)
>   		kmsg->msg_namelen = 0;
>   
>   	if (kmsg->msg_namelen < 0)
> @@ -57,15 +52,15 @@ int __get_compat_msghdr(struct msghdr *kmsg,
>   		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
>   
>   	kmsg->msg_control_is_user = true;
> -	kmsg->msg_control_user = compat_ptr(msg.msg_control);
> -	kmsg->msg_controllen = msg.msg_controllen;
> +	kmsg->msg_control_user = compat_ptr(msg->msg_control);
> +	kmsg->msg_controllen = msg->msg_controllen;
>   
>   	if (save_addr)
> -		*save_addr = compat_ptr(msg.msg_name);
> +		*save_addr = compat_ptr(msg->msg_name);
>   
> -	if (msg.msg_name && kmsg->msg_namelen) {
> +	if (msg->msg_name && kmsg->msg_namelen) {
>   		if (!save_addr) {
> -			err = move_addr_to_kernel(compat_ptr(msg.msg_name),
> +			err = move_addr_to_kernel(compat_ptr(msg->msg_name),
>   						  kmsg->msg_namelen,
>   						  kmsg->msg_name);
>   			if (err < 0)
> @@ -76,12 +71,10 @@ int __get_compat_msghdr(struct msghdr *kmsg,
>   		kmsg->msg_namelen = 0;
>   	}
>   
> -	if (msg.msg_iovlen > UIO_MAXIOV)
> +	if (msg->msg_iovlen > UIO_MAXIOV)
>   		return -EMSGSIZE;
>   
>   	kmsg->msg_iocb = NULL;
> -	*ptr = msg.msg_iov;
> -	*len = msg.msg_iovlen;
>   	return 0;
>   }
>   
> @@ -90,15 +83,17 @@ int get_compat_msghdr(struct msghdr *kmsg,
>   		      struct sockaddr __user **save_addr,
>   		      struct iovec **iov)
>   {
> -	compat_uptr_t ptr;
> -	compat_size_t len;
> +	struct compat_msghdr msg;
>   	ssize_t err;
>   
> -	err = __get_compat_msghdr(kmsg, umsg, save_addr, &ptr, &len);
> +	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
> +		return -EFAULT;
> +
> +	err = __get_compat_msghdr(kmsg, umsg, save_addr);
>   	if (err)
>   		return err;
>   
> -	err = import_iovec(save_addr ? READ : WRITE, compat_ptr(ptr), len,
> +	err = import_iovec(save_addr ? READ : WRITE, compat_ptr(msg.msg_iov), msg.msg_iovlen,
>   			   UIO_FASTIOV, iov, &kmsg->msg_iter);
>   	return err < 0 ? err : 0;
>   }

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

