Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B91E2750
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392816AbfJXAKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:10:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44910 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392153AbfJXAKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:10:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id e10so13080808pgd.11;
        Wed, 23 Oct 2019 17:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=tSWb4QttAdCeMSDg05JKLAWlJHpDAqSxHnHlE7DDoXo=;
        b=LgEOAh58uUqJt4fd3DS8E1vx9+3epBJi9Fcqe4kurYGj50ivvmfy+KVly6Q1N/9rkB
         77GdchtPn8Iu8QnSnxOjjnMLTW6tZrl1m+lOClL6ySXJ6AVYrffJzKjRCkktKmX+oMDI
         WbCIgNs8XoDg+Xp471d5oe8c2zLVfkjQ5ezx5TLrr2MziDlMdqqe3C+aa9plNF34ypIt
         LqDI3zaPt+leXCeNgLMWUgHXXAsYm+PLN43a16GAdHMv15aQjct0zxgQHe5Ym73ne2dE
         N60VUjPwblbTyJlQGVqXZHi26T71USA5pZC7tBebJZ873ipVlba87zntyD1MafZBbC5g
         N73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=tSWb4QttAdCeMSDg05JKLAWlJHpDAqSxHnHlE7DDoXo=;
        b=N/KKjJeqIIvVyjSZxLUNZp7HdWqyT9h62s0ddfGQXfohVdBXUrlSqJziJayiUDoJ4O
         O9DQCSN+Rk5P16x+UsgEmau/mjwiEUNe8Jx73Jq1QAFkhDTvKhS2N6UYs6Z2cMzmlqyt
         PjaMCZPR3QTl9AxF5yZGTz1xts9DAh6aM0L1bP/UCzFTYH4g38HKjOlxZZT98Yl0LlJd
         Q/UoW1A56xHuDZT5n1enSYIpKarXovC7TI1/LARbRYugQh/PExCNHUeBYMpVNJUsngmB
         Ljk+sKB139VVorY8IFosVcYqCWsVXQ+UGXqDZMfw1Jf4lI87bB1WBhcB2PDDS6+mviwp
         WUEg==
X-Gm-Message-State: APjAAAUch9VmWB5sedkImbFkKU6tZX/x5LvViBKPGObAuT4voYWUAbpH
        t0bWSEFD7jNbr4CXK5b5rtM=
X-Google-Smtp-Source: APXvYqwbXktZGWaLczTHuTda4z2K8PmqiDeNvNMhbco45ESWNsMicgmTf2gAVMatYvIQufqDQ/eUsg==
X-Received: by 2002:a17:90a:8d06:: with SMTP id c6mr3174671pjo.141.1571875835945;
        Wed, 23 Oct 2019 17:10:35 -0700 (PDT)
Received: from [172.26.117.3] ([2620:10d:c090:180::cbd8])
        by smtp.gmail.com with ESMTPSA id f185sm27392836pfb.183.2019.10.23.17.10.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:10:34 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, degeneloy@gmail.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH bpf-next v2] libbpf: fix compatibility for kernels without
 need_wakeup
Date:   Wed, 23 Oct 2019 17:10:33 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <E216E06A-0BE4-4221-BBF6-03017AB7D720@gmail.com>
In-Reply-To: <1571732756-20692-1-git-send-email-magnus.karlsson@intel.com>
References: <1571732756-20692-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Oct 2019, at 1:25, Magnus Karlsson wrote:

> When the need_wakeup flag was added to AF_XDP, the format of the
> XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> kernel to take care of compatibility issues arrising from running
> applications using any of the two formats. However, libbpf was
> not extended to take care of the case when the application/libbpf
> uses the new format but the kernel only supports the old
> format. This patch adds support in libbpf for parsing the old
> format, before the need_wakeup flag was added, and emulating a
> set of static need_wakeup flags that will always work for the
> application.
>
> v1 -> v2:
> * Rebased to bpf-next
> * Rewrote the code as the previous version made you blind
>
> Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in 
> AF_XDP part")
> Reported-by: Eloy Degen <degeneloy@gmail.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 79 
> +++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 12 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 7866500..aa16458 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -73,6 +73,21 @@ struct xsk_nl_info {
>  	int fd;
>  };
>
> +/* Up until and including Linux 5.3 */
> +struct xdp_ring_offset_no_flags {
> +	__u64 producer;
> +	__u64 consumer;
> +	__u64 desc;
> +};
> +
> +/* Up until and including Linux 5.3 */
> +struct xdp_mmap_offsets_no_flags {
> +	struct xdp_ring_offset_no_flags rx;
> +	struct xdp_ring_offset_no_flags tx;
> +	struct xdp_ring_offset_no_flags fr;
> +	struct xdp_ring_offset_no_flags cr;
> +};

Why not name these with "_v1" instead of "_no_flags" in order to match
the same definitions in net/xdp/xsk.h?  I'd rather not have two 
identical
structures different names if it can be avoided.


> +
>  int xsk_umem__fd(const struct xsk_umem *umem)
>  {
>  	return umem ? umem->fd : -EINVAL;
> @@ -133,6 +148,54 @@ static int xsk_set_xdp_socket_config(struct 
> xsk_socket_config *cfg,
>  	return 0;
>  }
>
> +static bool xsk_mmap_offsets_has_flags(socklen_t optlen)
> +{
> +	return (optlen == sizeof(struct xdp_mmap_offsets)) ? true : false;
> +}
> +
> +static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
> +{
> +	struct xdp_mmap_offsets_no_flags off_no_flag;
> +	socklen_t optlen;
> +	int err;
> +
> +	optlen = sizeof(*off);
> +	err = getsockopt(fd, SOL_XDP, XDP_MMAP_OFFSETS, off, &optlen);
> +	if (err)
> +		return err;
> +
> +	if (xsk_mmap_offsets_has_flags(optlen))

I'd just use "if (optlen == sizeof(*off))" here.


> +		return 0;
> +
> +	/* getsockopt on a kernel <= 5.3 has no flags fields.
> +	 * Copy over the offsets to the correct places in the >=5.4 format
> +	 * and put the flags where they would have been on that kernel.
> +	 */

Would it be worthwhile adding a length check here?
Something like:

     if (optlen == sizeof(struct xdp_mmap_offsets_v1)
         return xsk_mmap_offset_v1(off);

     return -EINVAL;

Which makes it easy to revisit this later if the same
problem crops up again.

> +	memcpy(&off_no_flag, off, sizeof(off_no_flag));
> +
> +	off->rx.producer = off_no_flag.rx.producer;
> +	off->rx.consumer = off_no_flag.rx.consumer;
> +	off->rx.desc = off_no_flag.rx.desc;
> +	off->rx.flags = off_no_flag.rx.consumer + sizeof(u32);
> +
> +	off->tx.producer = off_no_flag.tx.producer;
> +	off->tx.consumer = off_no_flag.tx.consumer;
> +	off->tx.desc = off_no_flag.tx.desc;
> +	off->tx.flags = off_no_flag.tx.consumer + sizeof(u32);
> +
> +	off->fr.producer = off_no_flag.fr.producer;
> +	off->fr.consumer = off_no_flag.fr.consumer;
> +	off->fr.desc = off_no_flag.fr.desc;
> +	off->fr.flags = off_no_flag.fr.consumer + sizeof(u32);
> +
> +	off->cr.producer = off_no_flag.cr.producer;
> +	off->cr.consumer = off_no_flag.cr.consumer;
> +	off->cr.desc = off_no_flag.cr.desc;
> +	off->cr.flags = off_no_flag.cr.consumer + sizeof(u32);


Then all this moves into a xsk_mmap_offset_v1() helper.

-- 
Jonathan

> +
> +	return 0;
> +}
> +
>  int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void 
> *umem_area,
>  			    __u64 size, struct xsk_ring_prod *fill,
>  			    struct xsk_ring_cons *comp,
> @@ -141,7 +204,6 @@ int xsk_umem__create_v0_0_4(struct xsk_umem 
> **umem_ptr, void *umem_area,
>  	struct xdp_mmap_offsets off;
>  	struct xdp_umem_reg mr;
>  	struct xsk_umem *umem;
> -	socklen_t optlen;
>  	void *map;
>  	int err;
>
> @@ -190,8 +252,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem 
> **umem_ptr, void *umem_area,
>  		goto out_socket;
>  	}
>
> -	optlen = sizeof(off);
> -	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, 
> &optlen);
> +	err = xsk_get_mmap_offsets(umem->fd, &off);
>  	if (err) {
>  		err = -errno;
>  		goto out_socket;
> @@ -492,7 +553,6 @@ int xsk_socket__create(struct xsk_socket 
> **xsk_ptr, const char *ifname,
>  	struct sockaddr_xdp sxdp = {};
>  	struct xdp_mmap_offsets off;
>  	struct xsk_socket *xsk;
> -	socklen_t optlen;
>  	int err;
>
>  	if (!umem || !xsk_ptr || !rx || !tx)
> @@ -551,8 +611,7 @@ int xsk_socket__create(struct xsk_socket 
> **xsk_ptr, const char *ifname,
>  		}
>  	}
>
> -	optlen = sizeof(off);
> -	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
> +	err = xsk_get_mmap_offsets(xsk->fd, &off);
>  	if (err) {
>  		err = -errno;
>  		goto out_socket;
> @@ -638,7 +697,6 @@ int xsk_socket__create(struct xsk_socket 
> **xsk_ptr, const char *ifname,
>  int xsk_umem__delete(struct xsk_umem *umem)
>  {
>  	struct xdp_mmap_offsets off;
> -	socklen_t optlen;
>  	int err;
>
>  	if (!umem)
> @@ -647,8 +705,7 @@ int xsk_umem__delete(struct xsk_umem *umem)
>  	if (umem->refcount)
>  		return -EBUSY;
>
> -	optlen = sizeof(off);
> -	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, 
> &optlen);
> +	err = xsk_get_mmap_offsets(umem->fd, &off);
>  	if (!err) {
>  		munmap(umem->fill->ring - off.fr.desc,
>  		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
> @@ -666,7 +723,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>  {
>  	size_t desc_sz = sizeof(struct xdp_desc);
>  	struct xdp_mmap_offsets off;
> -	socklen_t optlen;
>  	int err;
>
>  	if (!xsk)
> @@ -677,8 +733,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>  		close(xsk->prog_fd);
>  	}
>
> -	optlen = sizeof(off);
> -	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
> +	err = xsk_get_mmap_offsets(xsk->fd, &off);
>  	if (!err) {
>  		if (xsk->rx) {
>  			munmap(xsk->rx->ring - off.rx.desc,
> -- 
> 2.7.4
