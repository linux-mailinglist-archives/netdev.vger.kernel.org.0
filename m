Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9AE222258
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgGPM1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgGPM1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 08:27:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B86C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:27:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q5so6854864wru.6
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E5mKoH+WtXzfWR5Xhxnh1G5NKbjF/Rhn/M2OwOM4u6g=;
        b=qYuEXloj8mv7XsWkclCibA/LjsaBR0V8oZlBX31f3dBDrJIAxD7mOu25QTdstjsGG/
         GWzo6dqAXeJndHYsEj/7Ln/MxGK0PTVlplCgcsO3wLFkk0qi+HHCryNsopELX3cwepIo
         ocLA96wA8IWG1OxejGiin2gUVkYiixwEzl8GqXR6/QiAXQrva4Nr4QI+2HCulNPcDE7w
         E9L8Zm2oSxIdGhHC+E84WSd1Ixt8GtXsdDoMxGqJY7YDhL0xeLw5EE1AFD17rd2UMIhU
         f0bjKouNg2c0L26EptPlBvbB/6a03YgBEXsthWgsW2CqdHd2MOlj4UkBJuD6Z/SEZgi9
         mtfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E5mKoH+WtXzfWR5Xhxnh1G5NKbjF/Rhn/M2OwOM4u6g=;
        b=MXOiccEhOh+pY5ElRLSGrgMc3e2vtEgGck/KIt4T4hJNKKWE2KKrszPsz9m8eq0xI0
         QS5X9qOhszhOvbOk4lwdsctm6ZzofVRqYEEHsxURv1Alp6DGWBy99QCgtqGnkuscSIDP
         N170G3GmHXMQB7t/sJR0qw+7E6WvMApygg9BanniBZaZjlB3HSIamt3XYEwWKoL87O+I
         GQhDl475uSfEOlQ3H1gHYS/wjyKmo5f9xvvnuRQDhnlwNArPHh5XJWLCbCFZyirsuoBe
         oPIF4V3hF7O0rOklrBaK1TcOnTKDnELjfpUNsdETpyDvUeuN4u9aN1O62iH29ScxRTt3
         IGEg==
X-Gm-Message-State: AOAM531zDP59+k5QFEHqlILs394cg7JNgUrgDX5IXkSYqGvIam/omyNv
        hFhPv2Ox89eaJJQuOJG5xT/i8Q==
X-Google-Smtp-Source: ABdhPJw6efLULXoG3ylWTlvPqXpdDukClcbMGUEaZTtCIIIwEuuysXdRpfsguLnHCxfPsIJQ567kUg==
X-Received: by 2002:a5d:42c8:: with SMTP id t8mr4668419wrr.23.1594902439823;
        Thu, 16 Jul 2020 05:27:19 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 51sm9116238wrc.44.2020.07.16.05.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 05:27:19 -0700 (PDT)
Date:   Thu, 16 Jul 2020 14:27:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next 1/2] tc: Look for blocks in qevents
Message-ID: <20200716122718.GA23663@nanopsycho.orion>
References: <cover.1594896187.git.petrm@mellanox.com>
 <bcc2005258f2453a788af112eb574d40c58890ab.1594896187.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcc2005258f2453a788af112eb574d40c58890ab.1594896187.git.petrm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 16, 2020 at 12:47:59PM CEST, petrm@mellanox.com wrote:
>When a list of filters at a given block is requested, tc first validates
>that the block exists before doing the filter query. Currently the
>validation routine checks ingress and egress blocks. But now that blocks
>can be bound to qevents as well, qevent blocks should be looked for as
>well.
>
>In order to support that, extend struct qdisc_util with a new callback,
>has_block. That should report whether, give the attributes in TCA_OPTIONS,
>a blocks with a given number is bound to a qevent. In
>tc_qdisc_block_exists_cb(), invoke that callback when set.
>
>Add a helper to the tc_qevent module that walks the list of qevents and
>looks for a given block. This is meant to be used by the individual qdiscs.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>---
> tc/tc_qdisc.c  | 10 ++++++++++
> tc/tc_qevent.c | 15 +++++++++++++++
> tc/tc_qevent.h |  2 ++
> tc/tc_util.h   |  2 ++
> 4 files changed, 29 insertions(+)
>
>diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
>index 8eb08c34..bea8d3c0 100644
>--- a/tc/tc_qdisc.c
>+++ b/tc/tc_qdisc.c
>@@ -477,7 +477,9 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
> 	struct tc_qdisc_block_exists_ctx *ctx = arg;
> 	struct tcmsg *t = NLMSG_DATA(n);
> 	struct rtattr *tb[TCA_MAX+1];
>+	struct qdisc_util *q = NULL;

Pointless initialization.


> 	int len = n->nlmsg_len;
>+	const char *kind;
> 
> 	if (n->nlmsg_type != RTM_NEWQDISC)
> 		return 0;
>@@ -506,6 +508,14 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
> 		if (block == ctx->block_index)
> 			ctx->found = true;
> 	}
>+
>+	kind = rta_getattr_str(tb[TCA_KIND]);
>+	q = get_qdisc_kind(kind);
>+	if (!q)
>+		return -1;
>+	if (q->has_block)
>+		q->has_block(q, tb[TCA_OPTIONS], ctx->block_index, &ctx->found);

Op returns int yet you don't use it. Perhaps it can directly return
bool?


>+
> 	return 0;
> }
> 
>diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
>index 1f8e6506..2c010fcf 100644
>--- a/tc/tc_qevent.c
>+++ b/tc/tc_qevent.c
>@@ -92,6 +92,21 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
> 		close_json_array(PRINT_ANY, "");
> }
> 
>+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx)
>+{
>+	if (!qevents)
>+		return false;
>+
>+	for (; qevents->id; qevents++) {
>+		struct qevent_base *qeb = qevents->data;
>+
>+		if (qeb->block_idx == block_idx)
>+			return true;
>+	}
>+
>+	return false;
>+}
>+
> int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n)
> {
> 	int err;
>diff --git a/tc/tc_qevent.h b/tc/tc_qevent.h
>index 574e7cff..d60c3f75 100644
>--- a/tc/tc_qevent.h
>+++ b/tc/tc_qevent.h
>@@ -2,6 +2,7 @@
> #ifndef _TC_QEVENT_H_
> #define _TC_QEVENT_H_
> 
>+#include <stdbool.h>
> #include <linux/types.h>
> #include <libnetlink.h>
> 
>@@ -37,6 +38,7 @@ int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv);
> int qevents_read(struct qevent_util *qevents, struct rtattr **tb);
> int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n);
> void qevents_print(struct qevent_util *qevents, FILE *f);
>+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx);
> 
> struct qevent_plain {
> 	struct qevent_base base;
>diff --git a/tc/tc_util.h b/tc/tc_util.h
>index edc39138..c8af4e95 100644
>--- a/tc/tc_util.h
>+++ b/tc/tc_util.h
>@@ -5,6 +5,7 @@
> #define MAX_MSG 16384
> #include <limits.h>
> #include <linux/if.h>
>+#include <stdbool.h>
> 
> #include <linux/pkt_sched.h>
> #include <linux/pkt_cls.h>
>@@ -40,6 +41,7 @@ struct qdisc_util {
> 	int (*parse_copt)(struct qdisc_util *qu, int argc,
> 			  char **argv, struct nlmsghdr *n, const char *dev);
> 	int (*print_copt)(struct qdisc_util *qu, FILE *f, struct rtattr *opt);
>+	int (*has_block)(struct qdisc_util *qu, struct rtattr *opt, __u32 block_idx, bool *p_has);
> };
> 
> extern __u16 f_proto;
>-- 
>2.20.1
>
