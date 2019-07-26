Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9160776ADE
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfGZOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:01:47 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40796 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZOBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:01:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so39087591qke.7
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 07:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cNSqQLC1LK7YLHqpFhV9lHoyc6PsC8glzU3dj2eN2KM=;
        b=OpopPXi7qGELPP8gLORhGcWtAfs1Od0DnHMgIt4+P7/9eGrvmohvxe0dvBvU0FMvjx
         m7z0xPpXBXPXwGByvWn2TstiEr1ZLkt5PhBt3mN2l+mSdFhtQ9LumTZONiJbwxIzIO/p
         B9FUbVeG6yUNZBksefUZ8DwK+bUcOTqzmUDTQXCPUu0WPvDFM0q1FXPWtyGt69Zw3SlG
         a0GgF/OevPI7XkqkoY2C2cAjMLZ7EJ2qtpWWPZpSF7lPZkbL7lRLEEOikZTkvEi9+2Hy
         c9CheMLqi9QZLG4FnVme21YCjvVOTXYje1mjXIXkxUQVW0binarEBH9RwNQHfmB2doD7
         pj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cNSqQLC1LK7YLHqpFhV9lHoyc6PsC8glzU3dj2eN2KM=;
        b=rdewLd8B00EI0eUFCrAmQ4GpTx6SnGXDwEWUNdy3HpeTpbZaEt6kH5cihTUTYiBimy
         HneFMGmUcGKpJfA0MvrjPtyD1b4elpybbUEdQyKmUy6IPibCaU6OgN5p3iqwwRrKkDbM
         X2DivkdI3aOZh5NqWCS3XSIZvGQB252hPS00sLABFfGKjuDN2yeQRtWxLBzfRkVEBrRp
         w9W8lnT9xWAn2MHo7gAvy+jjZOraRvjg4lJb3nCWPTSzROcSA5pDoo0yBdn110A2CNIR
         eBF4wSMGCWZ8cP4cLfzZTSj02Dg/uCua8aTnJ5IhHP+Wjulsw2anI1uLCRbu7ZgkrTlv
         fmqA==
X-Gm-Message-State: APjAAAWc+BeGXTZ0MgWsxkUxgSFd+X24BaRvSesJgfEUKIFGLehxQFn/
        zEZh1LjGsw0/RQ7RFQAAFxM=
X-Google-Smtp-Source: APXvYqwYgSyd5ngIjaMjYp/UHQTthwlGEmNu1aPm3JO+OZfKyciV1EYq1aUTfEwtU6l7VnMGuvc76w==
X-Received: by 2002:a05:620a:11b2:: with SMTP id c18mr63191425qkk.174.1564149706290;
        Fri, 26 Jul 2019 07:01:46 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.45])
        by smtp.gmail.com with ESMTPSA id e1sm26075594qtb.52.2019.07.26.07.01.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 07:01:45 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7713BC0AAD; Fri, 26 Jul 2019 11:01:42 -0300 (-03)
Date:   Fri, 26 Jul 2019 11:01:42 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>, pablo@netfilter.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix zero table prio set by user.
Message-ID: <20190726140142.GC4063@localhost.localdomain>
References: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn>
 <7b03d1fdda172ce99c3693d8403cbdaf5a31bb6c.camel@mellanox.com>
 <CAJ3xEMi65JcF97nHeE482xgkps0GLLso+b6hp=34uX+wF=BjiQ@mail.gmail.com>
 <692b090f-c19e-aa8b-796e-17999ac79df1@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <692b090f-c19e-aa8b-796e-17999ac79df1@ucloud.cn>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 08:39:43PM +0800, wenxu wrote:
> 
> 在 2019/7/26 20:19, Or Gerlitz 写道:
> > On Fri, Jul 26, 2019 at 12:24 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> >> On Thu, 2019-07-25 at 19:24 +0800, wenxu@ucloud.cn wrote:
> >>> From: wenxu <wenxu@ucloud.cn>
> >>>
> >>> The flow_cls_common_offload prio is zero
> >>>
> >>> It leads the invalid table prio in hw.
> >>>
> >>> Error: Could not process rule: Invalid argument
> >>>
> >>> kernel log:
> >>> mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22
> >>> (table prio: 65535, level: 0, size: 4194304)
> >>>
> >>> table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
> >>> should check (chain * FDB_MAX_PRIO) + prio is not 0
> >>>
> >>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> >>> ---
> >>>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
> >>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git
> >>> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >>> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >>> index 089ae4d..64ca90f 100644
> >>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >>> @@ -970,7 +970,9 @@ static int esw_add_fdb_miss_rule(struct
> >> this piece of code isn't in this function, weird how it got to the
> >> diff, patch applies correctly though !
> >>
> >>> mlx5_eswitch *esw)
> >>>               flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
> >>>                         MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
> >>>
> >>> -     table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
> >>> +     table_prio = (chain * FDB_MAX_PRIO) + prio;
> >>> +     if (table_prio)
> >>> +             table_prio = table_prio - 1;
> >>>
> >> This is black magic, even before this fix.
> >> this -1 seems to be needed in order to call
> >> create_next_size_table(table_prio) with the previous "table prio" ?
> >> (table_prio - 1)  ?
> >>
> >> The whole thing looks wrong to me since when prio is 0 and chain is 0,
> >> there is not such thing table_prio - 1.
> >>
> >> mlnx eswitch guys in the cc, please advise.
> > basically, prio 0 is not something we ever get in the driver, since if
> > user space
> > specifies 0, the kernel generates some random non-zero prio, and we support
> > only prios 1-16 -- Wenxu -- what do you run to get this error?
> >
> >
> I run offload with nfatbles(but not tc), there is no prio for each rule.
> 
> prio of flow_cls_common_offload init as 0.
> 
> static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
> 
>                      __be16 proto,
>                     struct netlink_ext_ack *extack)
> {
>     common->protocol = proto;
>     common->extack = extack;
> }
> 
> 
> flow_cls_common_offload

Note that on
[PATCH net-next] netfilter: nf_table_offload: Fix zero prio of flow_cls_common_offload
I asked Pablo on how nftables should behave on this situation.

It's the same issue as in the patch above but being fixed at a
different level.
