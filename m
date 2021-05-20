Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F98389EF0
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 09:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhETHdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 03:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhETHdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 03:33:08 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F88C061574
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:31:47 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g8so4590207qtp.4
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F5a9PIwJ6/SOxSd9jumI2LYg7K1A7JkU485pAj4J60o=;
        b=U84k4LsgXt2JIDV40abt4rCN4gavM4D634P1RWFpVG8zDw+LB0Lb24wvQMk8UvMIG+
         q19XN8/Wkodo7dQ0zyV40/IF1eO26v7aDQyKBeG1i1BrMyVf7jS1rhKyFMv4uGRk4s0h
         BgOMUISxhiDGxlLPvr+Pinib9bjSyZ6sKTNzIKVDkfLHA8fWIiWCRITG5t9PIlEUXAnf
         kKuxUEur8mcCm7+9iAKz75WwQrRm3SRdjZGFe7eUk2g7vhfms039bCEHMtsoZIsCGKS4
         5+wPWFNPCPDTExTQiDZ7pD2pFxLYcqHR3SGpTr0P0F7vjB22kdAe2Nf15OC1Z/e+2UHR
         Kj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F5a9PIwJ6/SOxSd9jumI2LYg7K1A7JkU485pAj4J60o=;
        b=GWHYgxvT05X55eo/EIcDQMdRjzdxj45OBn9K0cRZHAp6PFgFw/38aslv+/dxcb+bzK
         clblvwuaTBxOTYlaP64gSLSD/qEu2sjW+m3sdr0rCVODtwMhV+xjGW4wIsoMWJ/jhOdM
         DrbgPqwLHBMmwPBpd2GrQnBGRwY9xR/5rwEP2zk4InJpIuyWRKDKGkxt6a7Fpvsjh2xn
         wrWr3Z3uKvhUvy8f40R9vKK/xOEPWvXIjYOHjoCxp/6nRFqSPdO0N3T5+XIjDOxVsJcX
         yLxnKEutKZFaP4s9FcVa9mlOwgoYb47dmsBw+C8O4nViDmpE66UnJI7dEKR6FyQhRil6
         9qnw==
X-Gm-Message-State: AOAM533vKQSI5GmI/GDkj8//OX8epmZaL4N7DFv3Kc0KvDSDmhBqDmen
        4jf/vne9ibTsD1XiB9cvlDWhBg==
X-Google-Smtp-Source: ABdhPJytbO97Rz1rvmGBKJ+8skiPWcrltBFUcHH1m9p8kk5rB+FdZW5iMHjJqDGV3STIfJTz3vsjPQ==
X-Received: by 2002:ac8:7d02:: with SMTP id g2mr3732716qtb.208.1621495906246;
        Thu, 20 May 2021 00:31:46 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id u186sm1525689qkd.30.2021.05.20.00.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 00:31:45 -0700 (PDT)
Date:   Thu, 20 May 2021 11:31:35 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Song Liu <songliubraving@fb.com>
Cc:     "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 06/11] bpfilter: Add struct match
Message-ID: <20210520073135.bpdtlbryvbp2olkf@amnesia>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-7-me@ubique.spb.ru>
 <F674F162-FBC0-4F2C-B8A1-BCDD015FFA3F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F674F162-FBC0-4F2C-B8A1-BCDD015FFA3F@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 04:26:28AM +0000, Song Liu wrote:
> 
> 
> > On May 17, 2021, at 3:53 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> > 
> > struct match_ops defines polymorphic interface for matches. A match
> > consists of pointers to struct match_ops and struct xt_entry_match which
> > contains a payload for the match's type.
> > 
> > All match_ops are kept in map match_ops_map by their name.
> > 
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > 
> [...]
> 
> > diff --git a/net/bpfilter/match-ops-map.h b/net/bpfilter/match-ops-map.h
> > new file mode 100644
> > index 000000000000..0ff57f2d8da8
> > --- /dev/null
> > +++ b/net/bpfilter/match-ops-map.h
> > @@ -0,0 +1,48 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#ifndef NET_BPFILTER_MATCH_OPS_MAP_H
> > +#define NET_BPFILTER_MATCH_OPS_MAP_H
> > +
> > +#include "map-common.h"
> > +
> > +#include <linux/err.h>
> > +
> > +#include <errno.h>
> > +#include <string.h>
> > +
> > +#include "match.h"
> > +
> > +struct match_ops_map {
> > +	struct hsearch_data index;
> > +};
> 
> Do we plan to extend match_ops_map? Otherwise, we can just use 
> hsearch_data in struct context. 

Agreed.

> 
> > +
> > +static inline int create_match_ops_map(struct match_ops_map *map, size_t nelem)
> > +{
> > +	return create_map(&map->index, nelem);
> > +}
> > +
> > +static inline const struct match_ops *match_ops_map_find(struct match_ops_map *map,
> > +							 const char *name)
> > +{
> > +	const size_t namelen = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
> > +
> > +	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
> > +		return map_find(&map->index, name);
> > +
> > +	return ERR_PTR(-EINVAL);
> > +}
> > +
> > +static inline int match_ops_map_insert(struct match_ops_map *map, const struct match_ops *match_ops)
> > +{
> > +	return map_insert(&map->index, match_ops->name, (void *)match_ops);
> > +}
> > +
> > +static inline void free_match_ops_map(struct match_ops_map *map)
> > +{
> > +	free_map(&map->index);
> > +}
> > +
> > +#endif // NET_BPFILTER_MATCT_OPS_MAP_H
> > diff --git a/net/bpfilter/match.c b/net/bpfilter/match.c
> > new file mode 100644
> > index 000000000000..aeca1b93cd2d
> > --- /dev/null
> > +++ b/net/bpfilter/match.c
> > @@ -0,0 +1,73 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include "match.h"
> > +
> > +#include <linux/err.h>
> > +#include <linux/netfilter/xt_tcpudp.h>
> 
> Besides xt_ filters, do we plan to support others? If so, we probably 
> want separate files for each of them. 

Do you mean nft filters?
They use nfilter API and currently we cannot hook into it - so
probably eventually.


> 
> > +
> > +#include <errno.h>
> > +#include <string.h>
> > +
> > +#include "bflog.h"
> > +#include "context.h"
> > +#include "match-ops-map.h"
> > +
> > +#define BPFILTER_ALIGN(__X) __ALIGN_KERNEL(__X, __alignof__(__u64))
> > +#define MATCH_SIZE(type) (sizeof(struct bpfilter_ipt_match) + BPFILTER_ALIGN(sizeof(type)))
> > +
> > +static int udp_match_check(struct context *ctx, const struct bpfilter_ipt_match *ipt_match)
> > +{
> > +	const struct xt_udp *udp;
> > +
> > +	udp = (const struct xt_udp *)&ipt_match->data;
> > +
> > +	if (udp->invflags & XT_UDP_INV_MASK) {
> > +		BFLOG_DEBUG(ctx, "cannot check match 'udp': invalid flags\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +const struct match_ops udp_match_ops = { .name = "udp",
> 
> And maybe we should name this one "xt_udp"? 

Agreed.


> 
> > +					 .size = MATCH_SIZE(struct xt_udp),
> > +					 .revision = 0,
> > +					 .check = udp_match_check };
> > +
> > +int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt_match, struct match *match)
> > +{
> > +	const size_t maxlen = sizeof(ipt_match->u.user.name);
> > +	const struct match_ops *found;
> > +	int err;
> > +
> > +	if (strnlen(ipt_match->u.user.name, maxlen) == maxlen) {
> > +		BFLOG_DEBUG(ctx, "cannot init match: too long match name\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	found = match_ops_map_find(&ctx->match_ops_map, ipt_match->u.user.name);
> > +	if (IS_ERR(found)) {
> > +		BFLOG_DEBUG(ctx, "cannot find match by name: '%s'\n", ipt_match->u.user.name);
> > +		return PTR_ERR(found);
> > +	}
> > +
> > +	if (found->size != ipt_match->u.match_size ||
> > +	    found->revision != ipt_match->u.user.revision) {
> > +		BFLOG_DEBUG(ctx, "invalid match: '%s'\n", ipt_match->u.user.name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	err = found->check(ctx, ipt_match);
> > +	if (err)
> > +		return err;
> > +
> > +	match->match_ops = found;
> > +	match->ipt_match = ipt_match;
> > +
> > +	return 0;
> > +}
> > diff --git a/net/bpfilter/match.h b/net/bpfilter/match.h
> > new file mode 100644
> > index 000000000000..79b7c87016d4
> > --- /dev/null
> > +++ b/net/bpfilter/match.h
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#ifndef NET_BPFILTER_MATCH_H
> > +#define NET_BPFILTER_MATCH_H
> > +
> > +#include "../../include/uapi/linux/bpfilter.h"
> > +
> > +#include <stdint.h>
> > +
> > +struct bpfilter_ipt_match;
> > +struct context;
> > +struct match_ops_map;
> > +
> > +struct match_ops {
> > +	char name[BPFILTER_EXTENSION_MAXNAMELEN];
> 
> BPFILTER_EXTENSION_MAXNAMELEN is 29, so "size" below is mis-aligned. I guess
> we can swap size and revision. 

Agreed.

> 
> > +	uint16_t size;
> > +	uint8_t revision;
> > +	int (*check)(struct context *ctx, const struct bpfilter_ipt_match *ipt_match);
> > +};
> > +
> > +extern const struct match_ops udp_match_ops;
> > +
> > +struct match {
> > +	const struct match_ops *match_ops;
> > +	const struct bpfilter_ipt_match *ipt_match;
> > +};
> 
> [...]
> 

-- 

Dmitrii Banshchikov
