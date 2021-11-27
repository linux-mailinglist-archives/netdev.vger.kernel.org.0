Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCAC45FD2D
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 07:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352616AbhK0G6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 01:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242506AbhK0G4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 01:56:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E968FC061574;
        Fri, 26 Nov 2021 22:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EC48B82946;
        Sat, 27 Nov 2021 06:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1341BC53FCF;
        Sat, 27 Nov 2021 06:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637995965;
        bh=y7aX4tHEmX6N8Dy67/o2wd9PsYy7YOln7tIjSFuwnA8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YwG6wPht4H6UL7uymTH4yO+N3eMj2ToFL4ReYpYAJzxDqtBSegL5l2QyJ0vAeENtJ
         qxlnIfN3xGV3nyHcrkCakohKUDl2fugGmUopbIwgj0vKQOm54jwS5pi9yNl8trCAob
         mTr+sDvvX3Gq5pTi3lQulkJ7N30jfcPz8uz1uW+3HNjhGwJBl6ekxpZ1QdzXKAHtEg
         ZnUQnuk6BBQutElkuKNY/10DEQgn9lThN+VQJV5q+qQod9Mj0g2YsLKifz8Z+JPx8m
         pezrr9pSUX6q78KrLpsH3lr/PQLM13BHQXqaZy43bteIplzRwN+45gLZNmfwMrcITm
         elUrQLsG5Vkuw==
Received: by mail-yb1-f176.google.com with SMTP id y68so25948316ybe.1;
        Fri, 26 Nov 2021 22:52:45 -0800 (PST)
X-Gm-Message-State: AOAM530tWo1GIgJloKDf4Iyc17TBNdei94T7DMWxjTNjiE/9XyvTXk2Q
        1rxGtjSAex/LztTVYiia+GLjULdS7BrP5lnKENc=
X-Google-Smtp-Source: ABdhPJzjc8bXddgUTRmjOKmq7eP5/ZbtbEYlQabdmSZzBBeSWUNIyWBdDcx2CkOCPlrcaBXWc4t/b92tKl9X9F9mY+Y=
X-Received: by 2002:a25:bd45:: with SMTP id p5mr22584448ybm.213.1637995964167;
 Fri, 26 Nov 2021 22:52:44 -0800 (PST)
MIME-Version: 1.0
References: <20211124091821.3916046-1-boon.leong.ong@intel.com> <20211124091821.3916046-4-boon.leong.ong@intel.com>
In-Reply-To: <20211124091821.3916046-4-boon.leong.ong@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 22:52:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7TCdQa0Piim4n_fZgbpJ0XHyT0B7gNe+sjj+KmrhdTEw@mail.gmail.com>
Message-ID: <CAPhsuW7TCdQa0Piim4n_fZgbpJ0XHyT0B7gNe+sjj+KmrhdTEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] samples/bpf: xdpsock: add period cycle time
 to Tx operation
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 1:22 AM Ong Boon Leong <boon.leong.ong@intel.com> wrote:
>
> Tx cycle time is in micro-seconds unit. By combining the batch size (-b M)
> and Tx cycle time (-T|--tx-cycle N), xdpsock now can transmit batch-size of
> packets every N-us periodically.
>
> For example to transmit 1 packet each 1ms cycle time for total of 2000000
> packets:
>
>  $ xdpsock -i eth0 -T -N -z -T 1000 -b 1 -C 2000000
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 1000           1996872
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 1000           1997872
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 1000           1998872
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 1000           1999872
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 128            2000000
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           0.00
> rx                 0              0
> tx                 0              2000000
>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
