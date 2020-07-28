Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607D723026F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgG1GNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgG1GNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:13:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D31C0619D2;
        Mon, 27 Jul 2020 23:13:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k8so6612155wma.2;
        Mon, 27 Jul 2020 23:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2LOYqENCC/eIrr+vps1mwgcYedxxXRrO5H846Z3NgUo=;
        b=mbl+AJvVCtxBnMFq8DuuLlqHTL4gHyTbIOttBv3k953y68Z+1ntGiEJRFlYBKXDUxq
         at3beMmZ4nYgwETfxeHttu1lrrMnXw0cW8mc5UZO/1PcdRAhE7gdK6GdySWKB4TKOJxU
         9q9X9YSryZesE2SCSJhjQXwims5fwEE5U5FGQeR8kMT28xrUEy70mSktfOGDPA9BvZVN
         yZR3DqusSGWjbi/CwYdY8K4YbMJm1Od95W/nts2/h/sbinAi1cFhnkpDhiL5lsJZtyU5
         ILD5h9KIxEIMzfohPLpXsk69jBNUJsrgRx+VaRWT1O8A7dc42EcIMrP9QRJ6aLns3yH2
         Z7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2LOYqENCC/eIrr+vps1mwgcYedxxXRrO5H846Z3NgUo=;
        b=HKzM7HcTey2Dr56NJkhtooWZtHBFVF6BFu6uRmdxjPdsvMOeNANOJHDlrm/vry+ujx
         GdFl5hq+W5uXSQU8OK5KWoYgnKTbn/1BHujUccdP98R2JBgjvI2/gb90MwFOgJ2+yM5s
         73sBbr8H8FkEvWaq8GJcJXwMwaC0d6Pn0QlEEoAZOdOmV316AzmrIUh+SnAfa5SxzrWA
         /Al46VM+wXS9JOdjYqO/mPv+2aYagWHhX7wmO2ULaT+Qy8oBC3iWvQHsdtfIODUHXViX
         xjLdpwBj2JhWkuOiFkSbd4MgZQOX/MH43jFdBaoMsjLEBR0VmCqa2n8C5WxCpGD/gXXa
         cJFQ==
X-Gm-Message-State: AOAM5325uoe0nKCV5kVyjNFtemZ2uWpoxNFH7J2XUlDNHaGUDM0tzhFb
        ibhIoubV7X9xD+lAB63iE+Zql8TpyusZrNr2ikY=
X-Google-Smtp-Source: ABdhPJwKUkxs+d357LpYlMASpcmzCNyn5RrFCm2qRWLTxjhfXBdb6r0YA/TsXS8zNQXf6lOL5ngxxwj75vxOnsyr8V0=
X-Received: by 2002:a7b:c857:: with SMTP id c23mr2586762wml.155.1595916794109;
 Mon, 27 Jul 2020 23:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200728022859.381819-1-yepeilin.cs@gmail.com> <20200728053604.404631-1-yepeilin.cs@gmail.com>
In-Reply-To: <20200728053604.404631-1-yepeilin.cs@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 28 Jul 2020 08:13:05 +0200
Message-ID: <CAJ+HfNhvM8+nfvEC2h+hjR5SGHU7_qyFkNxtiM1yjod6yVB0vQ@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] xdp: Prevent
 kernel-infoleak in xsk_getsockopt()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 at 07:37, Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> xsk_getsockopt() is copying uninitialized stack memory to userspace when
> `extra_stats` is `false`. Fix it.
>
> Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Doing `=3D {};` is sufficient since currently `struct xdp_statistics` is
> defined as follows:
>
> struct xdp_statistics {
>         __u64 rx_dropped;
>         __u64 rx_invalid_descs;
>         __u64 tx_invalid_descs;
>         __u64 rx_ring_full;
>         __u64 rx_fill_ring_empty_descs;
>         __u64 tx_ring_empty_descs;
> };
>
> When being copied to the userspace, `stats` will not contain any
> uninitialized "holes" between struct fields.
>
> Changes in v2:
>     - Remove the "Cc: stable@vger.kernel.org" tag. (Suggested by Song Liu
>       <songliubraving@fb.com>)
>     - Initialize `stats` by assignment instead of using memset().
>       (Suggested by Song Liu <songliubraving@fb.com>)
>
>  net/xdp/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 26e3bba8c204..b2b533eddebf 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -840,7 +840,7 @@ static int xsk_getsockopt(struct socket *sock, int le=
vel, int optname,
>         switch (optname) {
>         case XDP_STATISTICS:
>         {
> -               struct xdp_statistics stats;
> +               struct xdp_statistics stats =3D {};
>                 bool extra_stats =3D true;
>                 size_t stats_size;
>
> --
> 2.25.1
>
