Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9F2EAAB3
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbhAEM0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:26:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729831AbhAEM0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:26:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609849519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C6qUNvQUkXdw/sySXAScAycZjE4SmiBEPqohhGFSYUA=;
        b=hj2RiKF9sAIdfTVEIp9aaAiXskUbJDTNcqE4x/UQ8B5klDk5kDJ/qL/faBMHr9diA2u4rT
        6+CFlABWq+L6RygMKh99TVk0ZdjI/PEZGCJaPC+1A/CFhmkR1OhMmNYbynBmZO1xGh3rsl
        gem87WIJDq6mc2ZGykohBEHD2hhH7Lw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-YWDQ12KWP5m8wQ5D6ljcHw-1; Tue, 05 Jan 2021 07:25:18 -0500
X-MC-Unique: YWDQ12KWP5m8wQ5D6ljcHw-1
Received: by mail-wr1-f70.google.com with SMTP id b8so14715764wrv.14
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:25:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C6qUNvQUkXdw/sySXAScAycZjE4SmiBEPqohhGFSYUA=;
        b=BZxMS0VHeq5r79sonJ4AaVUC+fAVqUHPW/8h5VKZiE+DXS39lqPrfnxMdH/I779sYr
         eT+yCNQMMp1RDrd9h6nW/YtCkg0mBIoi080hVYXSO8+BxvuMqgHMsTTxsqv8MFjAscHV
         7McBowG1c/ZzAcjIzec3XQPQjjG/SArOMZ/bGFO713tuKMKqBqF5/Y9SPO/17C37xEw7
         NmNw6BESVohwKgXg7Eu+dYWT1t6rYqSwK+AHHg62dRTrXmMWAn9qMD/ynBBdXh+kci9X
         46CTiGOJgPXYYWkMxev76wWzQFhbLivr61ypCLRfgiP7qRYrVvOlvv4NoG5cmT416ghx
         mI/A==
X-Gm-Message-State: AOAM53303f8g0I61dX+ho9h5mOCvTC1m5dprRHvGfP2QOI44G7J33HDD
        44fuAPITgTIZ/rTAbbpjzoN/enr1lTXQD890gxZex/qMNpSM+1WnBz3RCp6z8i7/4bJ1kN4GVqO
        yCdAPTcdRJV6RELbt
X-Received: by 2002:a7b:c052:: with SMTP id u18mr3219906wmc.139.1609849517012;
        Tue, 05 Jan 2021 04:25:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2goxvm/vsk8E0XbHSlB3QZqCWkZVDQXKjwx5I6g+NamkUIWMgQNyLV5/lPhj5fdUxvUxiqQ==
X-Received: by 2002:a7b:c052:: with SMTP id u18mr3219882wmc.139.1609849516880;
        Tue, 05 Jan 2021 04:25:16 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id o83sm4030933wme.21.2021.01.05.04.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:25:16 -0800 (PST)
Date:   Tue, 5 Jan 2021 07:25:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>
Subject: Re: [PATCH netdev 0/5] virtio-net support xdp socket zero copy xmit
Message-ID: <20210105072316-mutt-send-email-mst@kernel.org>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 05:11:38PM +0800, Xuan Zhuo wrote:
> The first patch made some adjustments to xsk.
> 
> The second patch itself can be used as an independent patch to solve the problem
> that XDP may fail to load when the number of queues is insufficient.
> 
> The third to last patch implements support for xsk in virtio-net.
> 
> A practical problem with virtio is that tx interrupts are not very reliable.
> There will always be some missing or delayed tx interrupts.

Would appreciate a bit more data on this one. Is this a host bug? Device bug?
Can we limit the work around somehow?

> So I specially added
> a point timer to solve this problem. Of course, considering performance issues,
> The timer only triggers when the ring of the network card is full.
> 
> Regarding the issue of virtio-net supporting xsk's zero copy rx, I am also
> developing it, but I found that the modification may be relatively large, so I
> consider this patch set to be separated from the code related to xsk zero copy
> rx.
> 
> Xuan Zhuo (5):
>   xsk: support get page for drv
>   virtio-net: support XDP_TX when not more queues
>   virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
>   xsk, virtio-net: prepare for support xsk
>   virtio-net, xsk: virtio-net support xsk zero copy tx
> 
>  drivers/net/virtio_net.c    | 643 +++++++++++++++++++++++++++++++++++++++-----
>  include/linux/netdevice.h   |   1 +
>  include/net/xdp_sock_drv.h  |  10 +
>  include/net/xsk_buff_pool.h |   1 +
>  net/xdp/xsk_buff_pool.c     |  10 +-
>  5 files changed, 597 insertions(+), 68 deletions(-)
> 
> --
> 1.8.3.1

