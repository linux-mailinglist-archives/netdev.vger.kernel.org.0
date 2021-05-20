Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49846389F13
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 09:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhETHqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 03:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhETHqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 03:46:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB15C06175F
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:44:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d11so16523167wrw.8
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 00:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KW+8roUTdVOmsY9RcAiqqIiSxLAs6A0dbj/y6tBWrlw=;
        b=zKAC7B/fnA9h/SxqWiTrgZAhs7oJUwif/YwoHg6dmPQ5jpo8p6psrI8lytgvBcmDuZ
         fwGXp+UDLeHRis2xTwGY6lR0d6ZO821/h34aQjAm08jFgfAgYqIW0i1CGtZ58jyqpJCf
         JDO/uOITu+/JP4drwb7bIi3ToV6wCrGDFVFn0ix9GSCTpS31t9B74OVkGMIp626VTcRd
         5Kry5NCthBXx4vYTsVJirVD4ldNcfMTaMQEVbqc/1s2JAZhqR5HqqAhRZbXSZXLhAZOS
         E6RqoG9OwQOPPP0ECljtg6MThuudcq0Ra4uqCjcQGQdAzkjnT367JKVyZAXMxQpmluP2
         qsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KW+8roUTdVOmsY9RcAiqqIiSxLAs6A0dbj/y6tBWrlw=;
        b=j6hOfv9Fic24LlR+H4bwILyOtYERH9VQQ7aDBFkVtqMgoYsrF7bas5akA8Yn5eSp+p
         4HnICbioTmPJYY2zUX2tp86JTgfQ/UU5NaaRxrushbStVHAc4Rz+lSYiGKPtFPwMAkHN
         ga6qvhxvkNT22DqcmG8nUW/NXJ4bF9lsTy+UTG4s34TKaNWs9WEKpqcg8ZJB4ghtu8Wm
         fHMCh+4BH9NmbrojGHCL5s+d5jgKLfcayG7AazDmq4rJjaFII+rd54+pC2fwNXjLCKLo
         DtP3oWZ7jJ6s0ILgvxDe/wVszEDmAEB+1wqvIYF5bllaq3KuWjGiZi6poIFGW5Ge6wPl
         7zVA==
X-Gm-Message-State: AOAM530bo59Ctk8PvDGKO9QeFuD2lLYFVaSAh90JvLvS9FGqmvizrWKj
        aL5nUURa+2BWdqnMEu7eCbdz1A==
X-Google-Smtp-Source: ABdhPJwEty17jQXvpib2J3iXwokpkYZu8grNXSCEyCZqjBxlhM9jmQAa0HrL8D3paYQUyB/HNS6KgQ==
X-Received: by 2002:a5d:40cd:: with SMTP id b13mr2840612wrq.356.1621496683283;
        Thu, 20 May 2021 00:44:43 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id z9sm1734793wmi.17.2021.05.20.00.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 00:44:42 -0700 (PDT)
Date:   Thu, 20 May 2021 11:44:36 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Song Liu <songliubraving@fb.com>
Cc:     "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 07/11] bpfilter: Add struct target
Message-ID: <20210520074436.pxbqvwkvw4gihizj@amnesia>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-8-me@ubique.spb.ru>
 <1B747351-8336-45FB-918D-5FC3DA18B47D@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1B747351-8336-45FB-918D-5FC3DA18B47D@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 04:36:46AM +0000, Song Liu wrote:
> 
> 
> > On May 17, 2021, at 3:53 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> > 
> > struct target_ops defines polymorphic interface for targets. A target
> > consists of pointers to struct target_ops and struct xt_entry_target
> > which contains a payload for the target's type.
> > 
> > All target_ops are kept in map target_ops_map by their name.
> > 
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > 
> 
> [...]
> 
> > index 000000000000..6b65241328da
> > --- /dev/null
> > +++ b/net/bpfilter/target-ops-map.h
> > @@ -0,0 +1,49 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#ifndef NET_BPFILTER_TARGET_OPS_MAP_H
> > +#define NET_BPFILTER_TARGET_OPS_MAP_H
> > +
> > +#include "map-common.h"
> > +
> > +#include <linux/err.h>
> > +
> > +#include <errno.h>
> > +#include <string.h>
> > +
> > +#include "target.h"
> > +
> > +struct target_ops_map {
> > +	struct hsearch_data index;
> > +};
> 
> Similar to 06/11, target_ops_map seems unnecessary. Also, do we need to 
> support non-xt targets? 

As with nft matches - probably eventually but not now.

> 
> > +
> > +static inline int create_target_ops_map(struct target_ops_map *map, size_t nelem)
> > +{
> > +	return create_map(&map->index, nelem);
> > +}
> > +
> > +static inline const struct target_ops *target_ops_map_find(struct target_ops_map *map,
> > +							   const char *name)
> > +{
> > +	const size_t namelen = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
> > +
> > +	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
> > +		return map_find(&map->index, name);
> > +
> > +	return ERR_PTR(-EINVAL);
> > +}
> > +
> > +static inline int target_ops_map_insert(struct target_ops_map *map,
> > +					const struct target_ops *target_ops)
> > +{
> > +	return map_insert(&map->index, target_ops->name, (void *)target_ops);
> > +}
> > +
> > +static inline void free_target_ops_map(struct target_ops_map *map)
> > +{
> > +	free_map(&map->index);
> > +}
> > +
> > +#endif // NET_BPFILTER_TARGET_OPS_MAP_H
> > diff --git a/net/bpfilter/target.c b/net/bpfilter/target.c
> > new file mode 100644
> > index 000000000000..a18fe477f93c
> > --- /dev/null
> > +++ b/net/bpfilter/target.c
> > @@ -0,0 +1,112 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include "target.h"
> > +
> > +#include <linux/err.h>
> > +#include <linux/netfilter/x_tables.h>
> > +
> > +#include <errno.h>
> > +#include <string.h>
> > +
> > +#include "bflog.h"
> > +#include "context.h"
> > +#include "target-ops-map.h"
> > +
> 
> Please add some comments about convert_verdict. 
> 
> 
> > +static int convert_verdict(int verdict)
> > +{
> > +	return -verdict - 1;
> > +}
> > +
> > +static int standard_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
> > +{
> > +	const struct bpfilter_ipt_standard_target *standard_target;
> > +
> > +	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
> > +
> > +	if (standard_target->verdict > 0)
> > +		return 0;
> > +
> > +	if (standard_target->verdict < 0) {
> > +		if (standard_target->verdict == BPFILTER_RETURN)
> > +			return 0;
> > +
> > +		switch (convert_verdict(standard_target->verdict)) {
> > +		case BPFILTER_NF_ACCEPT:
> > +		case BPFILTER_NF_DROP:
> > +		case BPFILTER_NF_QUEUE:
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	BFLOG_DEBUG(ctx, "invalid verdict: %d\n", standard_target->verdict);
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +const struct target_ops standard_target_ops = {
> > +	.name = "",
> > +	.revision = 0,
> > +	.size = sizeof(struct xt_standard_target),
> > +	.check = standard_target_check,
> > +};
> > +
> > +static int error_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
> > +{
> > +	const struct bpfilter_ipt_error_target *error_target;
> > +	size_t maxlen;
> > +
> > +	error_target = (const struct bpfilter_ipt_error_target *)&ipt_target;
> > +	maxlen = sizeof(error_target->error_name);
> > +	if (strnlen(error_target->error_name, maxlen) == maxlen) {
> > +		BFLOG_DEBUG(ctx, "cannot check error target: too long errorname\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +const struct target_ops error_target_ops = {
> > +	.name = "ERROR",
> > +	.revision = 0,
> > +	.size = sizeof(struct xt_error_target),
> > +	.check = error_target_check,
> > +};
> > +
> > +int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
> > +		struct target *target)
> > +{
> > +	const size_t maxlen = sizeof(ipt_target->u.user.name);
> > +	const struct target_ops *found;
> > +	int err;
> > +
> > +	if (strnlen(ipt_target->u.user.name, maxlen) == maxlen) {
> > +		BFLOG_DEBUG(ctx, "cannot init target: too long target name\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	found = target_ops_map_find(&ctx->target_ops_map, ipt_target->u.user.name);
> > +	if (IS_ERR(found)) {
> > +		BFLOG_DEBUG(ctx, "cannot find target by name: '%s'\n", ipt_target->u.user.name);
> > +		return PTR_ERR(found);
> > +	}
> > +
> > +	if (found->size != ipt_target->u.target_size ||
> > +	    found->revision != ipt_target->u.user.revision) {
> > +		BFLOG_DEBUG(ctx, "invalid target: '%s'\n", ipt_target->u.user.name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	err = found->check(ctx, ipt_target);
> > +	if (err)
> > +		return err;
> > +
> > +	target->target_ops = found;
> > +	target->ipt_target = ipt_target;
> > +
> > +	return 0;
> > +}
> > diff --git a/net/bpfilter/target.h b/net/bpfilter/target.h
> > new file mode 100644
> > index 000000000000..5d9c4c459c05
> > --- /dev/null
> > +++ b/net/bpfilter/target.h
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2021 Telegram FZ-LLC
> > + */
> > +
> > +#ifndef NET_BPFILTER_TARGET_H
> > +#define NET_BPFILTER_TARGET_H
> > +
> > +#include "../../include/uapi/linux/bpfilter.h"
> > +
> > +#include <stdint.h>
> > +
> > +struct context;
> > +struct target_ops_map;
> > +
> > +struct target_ops {
> > +	char name[BPFILTER_EXTENSION_MAXNAMELEN];
> > +	uint16_t size;
> 
> Mis-aligned "size". 
> 
> > +	uint8_t revision;
> > +	int (*check)(struct context *ctx, const struct bpfilter_ipt_target *ipt_target);
> > +};
> > +
> > +struct target {
> > +	const struct target_ops *target_ops;
> > +	const struct bpfilter_ipt_target *ipt_target;
> > +};
> > +
> > +extern const struct target_ops standard_target_ops;
> > +extern const struct target_ops error_target_ops;
> > +
> > +int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
> > +		struct target *target);
> > +
> > +#endif // NET_BPFILTER_TARGET_H
> > diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
> > index e5073231f811..1856d0515f49 100644
> > --- a/tools/testing/selftests/bpf/bpfilter/.gitignore
> > +++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
> > @@ -2,3 +2,4 @@
> > test_io
> > test_map
> > test_match
> > +test_target
> > diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
> > index 362c9a28b88d..78da74b9ee68 100644
> > --- a/tools/testing/selftests/bpf/bpfilter/Makefile
> > +++ b/tools/testing/selftests/bpf/bpfilter/Makefile
> > @@ -11,6 +11,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
> > TEST_GEN_PROGS += test_io
> > TEST_GEN_PROGS += test_map
> > TEST_GEN_PROGS += test_match
> > +TEST_GEN_PROGS += test_target
> > 
> > KSFT_KHDR_INSTALL := 1
> > 
> > @@ -19,4 +20,6 @@ include ../../lib.mk
> > $(OUTPUT)/test_io: test_io.c $(BPFILTERSRCDIR)/io.c
> > $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
> > $(OUTPUT)/test_match: test_match.c $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/map-common.c \
> > -	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c
> > +	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/target.c
> > +$(OUTPUT)/test_target: test_target.c $(BPFILTERSRCDIR)/target.c $(BPFILTERSRCDIR)/map-common.c \
> > +	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/match.c
> > diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> > new file mode 100644
> > index 000000000000..d82ff86f280e
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef BPFILTER_UTIL_H
> > +#define BPFILTER_UTIL_H
> > +
> > +#include <linux/bpfilter.h>
> > +#include <linux/netfilter/x_tables.h>
> > +
> > +#include <stdio.h>
> > +
> > +static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
> > +					int verdict)
> > +{
> > +	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
> > +		 BPFILTER_STANDARD_TARGET);
> > +	ipt_target->target.u.user.revision = revision;
> > +	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
> > +	ipt_target->verdict = verdict;
> > +}
> > +
> > +static inline void init_error_target(struct xt_error_target *ipt_target, int revision,
> > +				     const char *error_name)
> > +{
> > +	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
> > +		 BPFILTER_ERROR_TARGET);
> > +	ipt_target->target.u.user.revision = revision;
> > +	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
> > +	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
> > +}
> > +
> > +#endif // BPFILTER_UTIL_H
> > 
> [...]
> > 
> 

-- 

Dmitrii Banshchikov
