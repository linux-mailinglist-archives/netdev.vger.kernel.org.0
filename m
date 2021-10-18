Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634614323E2
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhJRQdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhJRQdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:33:04 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC504C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:30:52 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso384796pjw.2
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=aNklGbMj5Y6WgOfozwDtGtU0+dKIw8juqOePwQhi/xI=;
        b=N+1aI+Qi/kz63yBLI2Lnf4m7Ak5aaDH4SdZeYti5EDwPK25MSRIahQvPd1tEPdkQtI
         U9CYtkY1kuPd3TLQskS4IW57hl2iPnlQ1MFekKsrecfe0uKoLp/ykkKjw7idbjvaVJhO
         ZTts1Jbc8oyoeE++DoUOJ8rlzTrP7ShRJwfplpCuS3Uq7EnFWodbVDiGn1jhBJJaDR5d
         bm7muUcfkKOAMlBZtSyuBbxkxFXazQXhQAsmEbKniumOy1TNak/Ows9phTUPgikprghb
         P4zN8k+8HmmxHXP//a0MTAznW+j0voZduBdpcIs0gVr9Ln7+n23oSt4UmWlBYLeAM1bc
         O9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aNklGbMj5Y6WgOfozwDtGtU0+dKIw8juqOePwQhi/xI=;
        b=cHbTo0jGMpv7o5yLMuMxUnLPV1URhc5OCGwNY4O2DFHGJHxhFMlF0ntCUi3PzCSTZa
         PBKM0ZmRZsHlePIHfcmweymXW+EN/Hjan3rdMMgxcPLsfvzLjuB54ItLCp6kfCDL8o4c
         U19VKJ81PfySDr6aZoU/lmGGiFvFVidB0xHvtuzeMJHZFwIVuznliKVVMQmiDXgi9PGr
         Zuwx47o0MvaCDkMyptFWCHqNCfGB5tOqRdVcLFWD7tFqZLN6lfYZpFzaepo7VN91qa3i
         La2a/Zj59A+LiPuCFP3TT1VOdtyV1de+PqpLDkC7ld1bBQV4gfN0CPe++CN/f+IB8eoX
         Cc/w==
X-Gm-Message-State: AOAM533bk1+hr5xpy4ivPYkzFi0FPtXSh/JivyOyNxokxWAjlbopbW/N
        G0PJ5aTTkvDNi5QjtQgnLyM=
X-Google-Smtp-Source: ABdhPJxJvu5j9G4GdMHK1KlqOKvzYWQ1tC934dAAJ7ZMtlgAgFpcP/GxBwtgB7jtj8xBybALmeGFjA==
X-Received: by 2002:a17:90a:df91:: with SMTP id p17mr48644077pjv.185.1634574652355;
        Mon, 18 Oct 2021 09:30:52 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id 139sm13595744pfz.35.2021.10.18.09.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 09:30:52 -0700 (PDT)
Message-ID: <a9fc0e074fb10a2df7a75cd7381cd8e4db7ce924.camel@gmail.com>
Subject: Re: [PATCH v3] net: neighbour: introduce EVICT_NOCARRIER table
 option
From:   James Prestwood <prestwoj@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Date:   Mon, 18 Oct 2021 09:27:31 -0700
In-Reply-To: <fc84cc7e-142f-48cb-2638-6cbc5b625782@nvidia.com>
References: <20211015200648.297373-1-prestwoj@gmail.com>
         <20211015200648.297373-2-prestwoj@gmail.com>
         <fc84cc7e-142f-48cb-2638-6cbc5b625782@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-10-16 at 14:12 +0300, Nikolay Aleksandrov wrote:
> On 15/10/2021 23:06, James Prestwood wrote:
> > This adds an option to ARP/NDISC tables that clears the table on
> > NOCARRIER events. The default option (1) maintains existing
> > behavior.
> > 
> > Clearing the ARP cache on NOCARRIER is relatively new, introduced
> > by:
> [snip]
> > Signed-off-by: James Prestwood <prestwoj@gmail.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst |  9 +++++++++
> >  include/net/neighbour.h                |  3 ++-
> >  include/uapi/linux/neighbour.h         |  1 +
> >  net/core/neighbour.c                   | 18 +++++++++++++-----
> >  net/ipv4/arp.c                         |  1 +
> >  net/ipv6/ndisc.c                       |  1 +
> >  6 files changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/networking/ip-sysctl.rst
> > b/Documentation/networking/ip-sysctl.rst
> > index 16b8bf72feaf..e2aced01905a 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -200,6 +200,15 @@ neigh/default/unres_qlen - INTEGER
> >  
> >         Default: 101
> >  
> > +neigh/default/evict_nocarrier - BOOLEAN
> > +       Clears the neighbor cache on NOCARRIER events. This option
> > is important
> > +       for wireless devices where the cache should not be cleared
> > when roaming
> > +       between access points on the same network. In most cases
> > this should
> > +       remain as the default (1).
> > +
> > +       - 1 - (default): Clear the neighbor cache on NOCARRIER
> > events
> > +       - 0 - Do not clear neighbor cache on NOCARRIER events
> > +
> >  mtu_expires - INTEGER
> >         Time, in seconds, that cached PMTU information is kept.
> >  
> > diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> > index e8e48be66755..71b28f83c3d3 100644
> > --- a/include/net/neighbour.h
> > +++ b/include/net/neighbour.h
> > @@ -54,7 +54,8 @@ enum {
> >         NEIGH_VAR_ANYCAST_DELAY,
> >         NEIGH_VAR_PROXY_DELAY,
> >         NEIGH_VAR_LOCKTIME,
> > -#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_LOCKTIME + 1)
> > +       NEIGH_VAR_EVICT_NOCARRIER,
> > +#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_EVICT_NOCARRIER + 1)
> >         /* Following are used as a second way to access one of the
> > above */
> >         NEIGH_VAR_QUEUE_LEN, /* same data as
> > NEIGH_VAR_QUEUE_LEN_BYTES */
> >         NEIGH_VAR_RETRANS_TIME_MS, /* same data as
> > NEIGH_VAR_RETRANS_TIME */
> > diff --git a/include/uapi/linux/neighbour.h
> > b/include/uapi/linux/neighbour.h
> > index db05fb55055e..4322e5f42646 100644
> > --- a/include/uapi/linux/neighbour.h
> > +++ b/include/uapi/linux/neighbour.h
> > @@ -151,6 +151,7 @@ enum {
> >         NDTPA_LOCKTIME,                 /* u64, msecs */
> >         NDTPA_QUEUE_LENBYTES,           /* u32 */
> >         NDTPA_MCAST_REPROBES,           /* u32 */
> > +       NDTPA_EVICT_NOCARRIER,          /* u8 */
> >         NDTPA_PAD,
> >         __NDTPA_MAX
> >  };
> 
> I think this should be the last attribute (after PAD).

Sure.

> 
> Since this is a single patch you don't really need a cover letter,
> you can add the version
> changes below ---. Also your cover letter says v2 and the patch says
> v3.

Ok, I'll move it into the patch itself.

Thanks,
James
> 
> Cheers,
>  Nik
> 


