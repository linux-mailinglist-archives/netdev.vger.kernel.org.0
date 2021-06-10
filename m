Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07223A2CB4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhFJNTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 09:19:42 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:42680 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhFJNTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:19:41 -0400
Received: by mail-qk1-f175.google.com with SMTP id q16so1253644qkm.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 06:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i/aU52fr2Ejj7ORjSCkaydnx3ewIOqeFi8vx2uwavKQ=;
        b=Bw5mQiaFfXmUq9jU22+TiMfVl+xBLkGuufthvEsAyEecqkLobHPrXZ7pKLN5pQsHq2
         HM3gs0HzHGZ0HkyI9y2gkRP1fYfmwr+fQFSE0X4vUgZctPFdnZQmb9iv28UtAtyK5eP4
         uiSZCxykTOjkI2CcYU72Boj0d4q68iDLtuecqgQQnYFNy74SHsq22bwPoxW08CliglCK
         H+tg01xMqDkyZcpvAaZavlbevTRJLM7Kct+faR9Cum3PW1CtRiw6zbN6VGdFGjTFPVAF
         vSYLDxU6C/CmuxMqe3gh7JGrjXL1GKZDRXNUMifb0M9aKqql3++l/VbrJuOUwPXFgMne
         pr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i/aU52fr2Ejj7ORjSCkaydnx3ewIOqeFi8vx2uwavKQ=;
        b=UEBJWHIEMP72Xtc0jkf5+h7GaMIjdD/NRwmZ3OWUWsp6nE8a6RI9AG85WoQfO3iOb6
         /k7xEGX6QUKRmXbqiVySqYHaKqg+ORoaSDYWbp70XYFul1MaRhlToNaGrWVwpn7uy4ez
         w1g3loL64As1xdsHQEMWSt8RD8HQ9g0UxmPRabkdYOvmQ9gGLA9g1gJjFh8XhZaCJg0W
         pYg4axhPABTHnDVhF7sN6L21EOzdhvLkNJfTxeqlqewzLbkVEIq/j2dMhQMB5/LCO/lQ
         hi1XOgMtERFjFmJw5YBi8VSgio+KEjJoFJFsPN0DT05AERQ9FcEDWmfDMOUFSVQ8bnA6
         TZJw==
X-Gm-Message-State: AOAM532TS7bh7S/tQBlncy87AWJKc8Ti0+YCCE+wMKNoy1psYOiHUjbp
        PKE6JRPX5fQOXdWY7aZhrgZtTA==
X-Google-Smtp-Source: ABdhPJzKkiywmIVNUVEnJG6zvreg+tX/ksWHJxIMyQckqqasdW3sE0dWLuBtc4hKfFO0peVUfY2xbg==
X-Received: by 2002:a05:620a:39c:: with SMTP id q28mr4528574qkm.351.1623331004276;
        Thu, 10 Jun 2021 06:16:44 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id g5sm2125618qth.39.2021.06.10.06.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 06:16:43 -0700 (PDT)
Date:   Thu, 10 Jun 2021 17:16:35 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com
Subject: Re: [PATCH bpf-next v1 07/10] bpfilter: Add struct rule
Message-ID: <20210610131635.w5pshflih4che74s@amnesia>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <20210603101425.560384-8-me@ubique.spb.ru>
 <8040518a-572a-18d8-5a50-fd3e82f13f5c@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8040518a-572a-18d8-5a50-fd3e82f13f5c@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 05:30:56PM -0700, Yonghong Song wrote:
> 
> 
> On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
> > struct rule is an equivalent of struct ipt_entry. A rule consists of
> > zero or more matches and a target. A rule has a pointer to its ipt_entry
> > in entries blob.  struct rule should simplify iteration over a blob and
> > avoid blob's guts in code generation.
> > 
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > ---
> >   net/bpfilter/Makefile                         |   2 +-
> >   net/bpfilter/rule.c                           | 163 ++++++++++++++++++
> >   net/bpfilter/rule.h                           |  32 ++++
> >   .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
> >   tools/testing/selftests/bpf/bpfilter/Makefile |   5 +-
> >   .../selftests/bpf/bpfilter/bpfilter_util.h    |   8 +
> >   .../selftests/bpf/bpfilter/test_rule.c        |  55 ++++++
> >   7 files changed, 264 insertions(+), 2 deletions(-)
> >   create mode 100644 net/bpfilter/rule.c
> >   create mode 100644 net/bpfilter/rule.h
> >   create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c
> > 
> [...]
> > +
> > +bool rule_has_standard_target(const struct rule *rule);
> > +bool is_rule_unconditional(const struct rule *rule);
> > +int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry, struct rule *rule);
> > +void free_rule(struct rule *rule);
> > +
> > +#endif // NET_BPFILTER_RULE_H
> > diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
> > index 7e077f506af1..4d7c5083d980 100644
> > --- a/tools/testing/selftests/bpf/bpfilter/.gitignore
> > +++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
> > @@ -2,3 +2,4 @@
> >   test_map
> >   test_match
> >   test_target
> > +test_rule
> > diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
> > index a11775e8b5af..27a1ddcb6dc9 100644
> > --- a/tools/testing/selftests/bpf/bpfilter/Makefile
> > +++ b/tools/testing/selftests/bpf/bpfilter/Makefile
> > @@ -11,6 +11,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
> >   TEST_GEN_PROGS += test_map
> >   TEST_GEN_PROGS += test_match
> >   TEST_GEN_PROGS += test_target
> > +TEST_GEN_PROGS += test_rule
> >   KSFT_KHDR_INSTALL := 1
> > @@ -19,9 +20,11 @@ include ../../lib.mk
> >   BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
> >   BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
> > -BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c
> > +BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c \
> > +	$(BPFILTERSRCDIR)/rule.c
> >   BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
> >   $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
> >   $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
> >   $(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
> > +$(OUTPUT)/test_rule: test_rule.c $(BPFILTER_COMMON_SRCS)
> > diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> > index d82ff86f280e..55fb0e959fca 100644
> > --- a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> > +++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> > @@ -7,6 +7,7 @@
> >   #include <linux/netfilter/x_tables.h>
> >   #include <stdio.h>
> > +#include <string.h>
> >   static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
> >   					int verdict)
> > @@ -28,4 +29,11 @@ static inline void init_error_target(struct xt_error_target *ipt_target, int rev
> >   	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
> >   }
> > +static inline void init_standard_entry(struct ipt_entry *entry, __u16 matches_size)
> > +{
> > +	memset(entry, 0, sizeof(*entry));
> > +	entry->target_offset = sizeof(*entry) + matches_size;
> > +	entry->next_offset = sizeof(*entry) + matches_size + sizeof(struct xt_standard_target);
> > +}
> > +
> >   #endif // BPFILTER_UTIL_H
> > diff --git a/tools/testing/selftests/bpf/bpfilter/test_rule.c b/tools/testing/selftests/bpf/bpfilter/test_rule.c
> > new file mode 100644
> > index 000000000000..fe12adf32fe5
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/bpfilter/test_rule.c
> > @@ -0,0 +1,55 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include "rule.h"
> > +
> > +#include <linux/bpfilter.h>
> > +#include <linux/err.h>
> > +
> > +#include <linux/netfilter_ipv4/ip_tables.h>
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +
> > +#include "../../kselftest_harness.h"
> > +
> > +#include "context.h"
> > +#include "rule.h"
> > +
> > +#include "bpfilter_util.h"
> > +
> > +FIXTURE(test_standard_rule)
> > +{
> > +	struct context ctx;
> > +	struct {
> > +		struct ipt_entry entry;
> > +		struct xt_standard_target target;
> > +	} entry;
> > +	struct rule rule;
> > +};
> > +
> > +FIXTURE_SETUP(test_standard_rule)
> > +{
> > +	const int verdict = BPFILTER_NF_ACCEPT;
> > +
> > +	ASSERT_EQ(create_context(&self->ctx), 0);
> > +	self->ctx.log_file = stderr;
> > +
> > +	init_standard_entry(&self->entry.entry, 0);
> > +	init_standard_target(&self->entry.target, 0, -verdict - 1);
> > +}
> > +
> > +FIXTURE_TEARDOWN(test_standard_rule)
> > +{
> > +	free_rule(&self->rule);
> > +	free_context(&self->ctx);
> > +}
> > +
> > +TEST_F(test_standard_rule, init)
> > +{
> > +	ASSERT_EQ(0, init_rule(&self->ctx, (const struct bpfilter_ipt_entry *)&self->entry.entry,
> > +			       &self->rule));
> > +}
> > +
> > +TEST_HARNESS_MAIN
> 
> When compiling selftests/bpf/bpfilter, I got the following compilation
> warning:
> 
> gcc -Wall -g -pthread -I/home/yhs/work/bpf-next/tools/include
> -I/home/yhs/work/bpf-next/tools/include/uapi -I../../../../../net/bpfilter
> test_rule.c ../../../../../net/bpfilter/map-common.c
> ../../../../../net/bpfilter/context.c ../../../../../net/bpfilter/rule.c
> ../../../../../net/bpfilter/table.c ../../../../../net/bpfilter/match.c
> ../../../../../net/bpfilter/xt_udp.c ../../../../../net/bpfilter/target.c
> -o /home/yhs/work/bpf-next/tools/testing/selftests/bpf/bpfilter/test_rule
> In file included from test_rule.c:15:
> ../../kselftest_harness.h:674: warning: "ARRAY_SIZE" redefined
>  #define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
> 
> In file included from /usr/include/linux/netfilter/x_tables.h:4,
>                  from /usr/include/linux/netfilter_ipv4/ip_tables.h:24,
>                  from test_rule.c:10:
> /home/yhs/work/bpf-next/tools/include/linux/kernel.h:105: note: this is the
> location of the previous definition
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr))
> 

Hmm. I cannot reproduce it locally now though I saw this error and
fixed it by removing some of the includes from header files.
I will double check it.


-- 

Dmitrii Banshchikov
