Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4548E320940
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 09:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBUIw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 03:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhBUIw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 03:52:57 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AA0C061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 00:52:16 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id u3so9955599ybk.6
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 00:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RJ6XRSj8Hw/drU0HiY0a4+qfk/t22NlQuyruL9Qv2Pg=;
        b=d8cVhGPGGtSbjlDBGWjoq5nPiYmi5R8C+W3xFIlzz9b4F1UBRk8V5IT22a3Wb+wSB/
         Cc4dUCIHvBJpWHWFMYYVBz7uZqDIeStw0kWO1exqxtiHQno9iduSGtyDeW9pIO86Q/hF
         NOY5FHe/mYGEhaAD1FQ3tGxg5K0F9ZWOZixyyYmGub1p/nBnYhJD/4FZEUxramNxmL5n
         WgPzqKPnKno412aejBg2AFG2XVig+FY1xIY+mf2aAAB7BaQRRWWJQrZqTGZYwCG12PbS
         oUou5rEA17GTwCJhx1TX4pla+L5rA8MnRS1QrkKDmxRV4U8VaHc7fKw4VQK1IgqHJgwY
         5wzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RJ6XRSj8Hw/drU0HiY0a4+qfk/t22NlQuyruL9Qv2Pg=;
        b=A0RmS5F2GOJpvfB95ghcWOt4EyTvLpFWWjWe5DVAxjaqsH+o4wTJIqZL/WPmM+exLb
         urQOLzAOm7BB5BgszaOC5HUDC/3drvGh7QXVSaQARJ5TIbtS2FDZ7JVthFaeo+3AR2EG
         oPSAIfrSU5IpXiHiuvq2GuZQHHqLx2KcVsOyzcmQOcXDP3Da8McbfVEGlcsGL56iDDBH
         64pjAKINWiF5raMShC900U+yVzFnDllMcgnEddMpmbQdppYyyBgWbuSn7NbQLUwiekaX
         LVIwgMR6Hes2heIzFTN5RC5tHzd/rVB1IQBTb+igYp17oE0+PFhRnOa4Oofvyf7imLex
         7FRA==
X-Gm-Message-State: AOAM533+iED5TR57XBk5dSiVGw2vDmg3mLq0jASNj/7O5mdpqEBylJdB
        34Ld5MyXvtBLV7TjYRAUGx48joGn76n4EQViXDE=
X-Google-Smtp-Source: ABdhPJwkQMy4evXLyTJkB9//pt/zv7UiKRUl5OGXx+PNsbEhzUVPdfxqAhNXR7ik/W0rKswgJrl6q+eFfexlAp6kW3k=
X-Received: by 2002:a25:50d8:: with SMTP id e207mr24663829ybb.56.1613897535704;
 Sun, 21 Feb 2021 00:52:15 -0800 (PST)
MIME-Version: 1.0
References: <20210211211044.32701-1-borisp@mellanox.com>
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 21 Feb 2021 10:52:04 +0200
Message-ID: <CAJ3xEMgazUM053U-nGycNPPT7bennXVcdFoPvMWRU3uZGdpXFg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/21] nvme-tcp receive offloads
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        yorayz@nvidia.com, Boris Pismenny <borisp@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:15 PM Boris Pismenny <borisp@mellanox.com> wrote:
> Changes since v3:
> =========================================
> * Use DDP_TCP ifdefs in iov_iter and skb iterators to minimize impact
> when compiled out (Christoph)
> * Simplify netdev references and reduce the use of
> get_netdev_for_sock (Sagi)
> * Avoid "static" in it's own line, move it one line down (Christoph)
> * Pass (queue, skb, *offset) and retrieve the pdu_seq in
> nvme_tcp_resync_response (Sagi)
> * Add missing assignment of offloading_netdev to null in offload_limits
> error case (Sagi)
> * Set req->offloaded = false once -- the lifetime rules are:
> set to false on cmd_setup / set to true when ddp setup succeeds (Sagi)
> * Replace pr_info_ratelimited with dev_info_ratelimited (Sagi)
> * Add nvme_tcp_complete_request and invoke it from two similar call
> sites (Sagi)
> * Introduce nvme_tcp_req_map_sg earlier in the series (Sagi)
> * Add nvme_tcp_consume_skb and put into it a hunk from
> nvme_tcp_recv_data to handle copy with and without offload

Sagi, Christoph,

Any further comments?

Or.





> Changes since v2:
> =========================================
> * Use skb->ddp_crc for copy offload to avoid skb_condense
> * Default mellanox driver support to no (experimental feature)
> * In iov_iter use non-ddp functions for kvec and iovec
> * Remove typecasting in nvme-tcp
>
> Changes since v1:
> =========================================
> * Rework iov_iter copy skip if src==dst to be less intrusive (David Ahern)
> * Add tcp-ddp documentation (David Ahern)
> * Refactor mellanox driver patches into more patches (Saeed Mahameed)
> * Avoid pointer casting (David Ahern)
> * Rename nvme-tcp offload flags (Shai Malin)
> * Update cover-letter according to the above
>
> Changes since RFC v1:
> =========================================
> * Split mlx5 driver patches to several commits
> * Fix nvme-tcp handling of recovery flows. In particular, move queue offlaod
>   init/teardown to the start/stop functions.
