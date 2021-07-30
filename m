Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169E03DBE5C
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhG3S3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhG3S2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:28:10 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D43C061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 11:28:05 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id a5-20020a05683012c5b029036edcf8f9a6so10507821otq.3
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 11:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y9TywsCPTkQ01Aqth2yeOqnyofLdA25ZI+98/Vypw6I=;
        b=qNMIkqKD1bjsRrkxyRJe4zI/03JXHuA4mcluLEP2d1kw+6jKM7sdTlYKDui7fL2Ndu
         wDEXoo3Mv4RONKBVwRNoTmIJ/XvJpoKJL78/VQ1UwloLsTxh8h6zoEKNuh/gpEmhP+nT
         cP2lCUTzfsfkl25AJ+grlQlCSLtK9jZuihBEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y9TywsCPTkQ01Aqth2yeOqnyofLdA25ZI+98/Vypw6I=;
        b=l3qho298OVO0pNhfa68JagpA46NVOgrmAnmm13Yt2LnPyaeVg7/SuTH63FAsjc3F5T
         cYIoV8XsNdSzAqSnDtOk1KHaxRqO+GtB+3/+I90/23eGCmY1RRle5dEspjRcqLexCMHD
         Yx1hqm/8jHCdw89n3CWWcoMI6RqAdJangtnAKadex1N99Mf4bqo6eeIE+3xOvhZrmZDT
         TXy/KJGY9iv588sHvRx0SdQCnlRNeuFUig3QaELDhCBQTMeYfqCC7VtQLsbgbg221hR9
         myzmN6CWt8TGfWsklDIMz5fL0fo3dmyUR1x3aOkMBTLxgO8meFNLcd9FU3+SfMI9S3MY
         wEDg==
X-Gm-Message-State: AOAM532bpoNBg29DrIWnank0StdP4KXuzHXS0C86NIXDn89sRSODLL99
        GKVpaj6BnJN1Nr1okLG4axNokw==
X-Google-Smtp-Source: ABdhPJwrPasDFY8VkuQFDjE1ErkRicWyG/xCwyn9fMZ2NM1ygqIJTH7ZH/Ucz2Fgep23M9R1T/Alfg==
X-Received: by 2002:a9d:7010:: with SMTP id k16mr2968262otj.298.1627669684382;
        Fri, 30 Jul 2021 11:28:04 -0700 (PDT)
Received: from C02XR1NRJGH8 (65-36-81-87.static.grandenetworks.net. [65.36.81.87])
        by smtp.gmail.com with ESMTPSA id n202sm412934oig.10.2021.07.30.11.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 11:28:03 -0700 (PDT)
Date:   Fri, 30 Jul 2021 13:27:49 -0500
From:   Kyle Bowman <kbowman@cloudflare.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQREpVNFRUKtBliI@C02XR1NRJGH8>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728014347.GM3673@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

On Wed, Jul 28, 2021 at 03:43:47AM +0200, Phil Sutter wrote:
> You might want to check iptables commit ccf154d7420c0 ("xtables: Don't
> use native nftables comments") for reference, it does the opposite of
> what you want to do.

I went ahead and looked through this commit and also found found the
code that initially added this functionality; commit d64ef34a9961
("iptables-compat: use nft built-in comments support ").

Additionally I found some other commits that moved code to nft native
implementations of the xtables counterpart so that proved helpful.

After a couple days of research I did end up figuring out what to do
and have added a (mostly complete) native nft log support in
iptables-nft. It all seems to work without any kernel changes
required. The only problem I'm now faced with is that since we want to
take the string passed into the iptables-nft command and add it to the
nftnl expression (`NFTNL_EXPR_LOG_PREFIX`) I'm not entirely sure where
to get the original sized string from aside from `argv` in the `struct
iptables_command_state`. I would get it from the `struct
xt_nflog_info`, but that's going to store the truncated version and we
would like to be able to store 128 characters of the string as opposed
to 64.

Any recommendations about how I might do this safely?

An example of the program running with my patch:

kyle@debian:~/netfilter/iptables$ sudo /usr/local/sbin/iptables-nft -S

-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N test-chain

kyle@debian:~/netfilter/iptables$ sudo /usr/local/sbin/iptables-nft -A
test-chain -j NFLOG --nflog-prefix "this string is hard coded for
testing so what I put here doesn't end up in the prefix"

kyle@debian:~/netfilter/iptables$ sudo /usr/local/sbin/iptables-nft -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N test-chain
-A test-chain -j NFLOG --nflog-prefix  "iff the value at the end is 12
then this string is truncated 12"

kyle@debian:~/netfilter/iptables$ sudo nft list ruleset
table ip filter {
	chain test-chain {
    counter packets 0 bytes 0 log prefix "iff the value at the end is
    12 then this string is truncated 123"
}

	[...]
}

See below for the patch:

From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
From: Kbowman <kbowman@cloudflare.com>
Date: Thu, 29 Jul 2021 15:12:28 -0500
Subject: [PATCH] iptables-nft: use nft built-in logging instead of xt_NFLOG

Replaces the use of xt_NFLOG with the nft built-in log statement.

This additionally adds support for using longer log prefixes of 128
characters in size. A caveat to this is that the string will be
truncated when the rule is printed via iptables-nft but will remain
untruncated in nftables.

Some changes have also been made to nft_is_expr_compatible() since
xt_NFLOG does not support log level or log flags. With the new changes
this means that when a log is used and sets either NFTNL_EXPR_LOG_LEVEL
or NFTNL_LOG_FLAGS to a value aside from their default (log level
defaults to 4, log flags will not be set) this will produce a
compatibility error.
---
 iptables/nft-shared.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.c        | 38 ++++++++++++++++++++++++++++++++++++
 iptables/nft.h        |  1 +
 3 files changed, 84 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 4253b081..b5259db0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -22,6 +22,7 @@
 
 #include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
+#include <linux/netfilter/xt_NFLOG.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
@@ -595,6 +596,48 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
+static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
+{
+    __u16 group =  nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP);
+    __u16 qthreshold = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD);
+    __u32 snaplen = nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
+    const char *prefix = nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX);
+    struct xtables_target *target;
+    struct xt_entry_target *t;
+    size_t target_size;
+
+    void *data = ctx->cs;
+
+    target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
+    if (target == NULL)
+        return;
+
+    target_size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
+
+    t = xtables_calloc(1, target_size);
+    t->u.target_size = target_size;
+    strcpy(t->u.user.name, target->name);
+    t->u.user.revision = target->revision;
+
+    target->t = t;
+
+    struct xt_nflog_info *info = xtables_malloc(sizeof(struct xt_nflog_info));
+    info->group = group;
+    info->len = snaplen;
+    info->threshold = qthreshold;
+
+    /* Here, because we allow 128 characters in nftables but only 64
+     * characters in xtables (in xt_nflog_info specifically), we may
+     * end up truncating the string when parsing it.
+     */
+    strncpy(info->prefix, prefix, sizeof(info->prefix));
+    info->prefix[sizeof(info->prefix) - 1] = '\0';
+
+    memcpy(&target->t->data, info, target->size);
+
+    ctx->h->ops->parse_target(target, data);
+}
+
 static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 			     struct nftnl_expr *e)
 {
@@ -644,6 +687,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_limit(&ctx, expr);
 		else if (strcmp(name, "lookup") == 0)
 			nft_parse_lookup(&ctx, h, expr);
+		else if (strcmp(name, "log") == 0)
+		    nft_parse_log(&ctx, expr);
 
 		expr = nftnl_expr_iter_next(iter);
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index f1deb82f..dce8fe0b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -39,6 +39,7 @@
 #include <linux/netfilter/nf_tables_compat.h>
 
 #include <linux/netfilter/xt_limit.h>
+#include <linux/netfilter/xt_NFLOG.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
@@ -1340,6 +1341,8 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 		       ret = add_verdict(r, NF_DROP);
 	       else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 		       ret = add_verdict(r, NFT_RETURN);
+	       else if (strcmp(cs->jumpto, "NFLOG") == 0)
+	           ret = add_log(r, cs);
 	       else
 		       ret = add_target(r, cs->target->t);
        } else if (strlen(cs->jumpto) > 0) {
@@ -1352,6 +1355,36 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
        return ret;
 }
 
+int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
+{
+    struct nftnl_expr *expr;
+    struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;
+
+    expr = nftnl_expr_alloc("log");
+    if (!expr)
+        return -ENOMEM;
+
+    if (info->prefix != NULL) {
+        //char prefix[NF_LOG_PREFIXLEN] = {};
+
+        // get prefix here from somewhere...
+        // maybe in cs->argv?
+        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at the end is 12 then this string is truncated 123");
+    }
+    if (info->group) {
+        nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
+        if (info->flags & XT_NFLOG_F_COPY_LEN)
+            nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
+                               info->len);
+        if (info->threshold)
+            nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_QTHRESHOLD,
+                               info->threshold);
+    }
+
+    nftnl_rule_add_expr(r, expr);
+    return 0;
+}
+
 static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
 {
 #ifdef NLDEBUG
@@ -3487,6 +3520,11 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
 	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_FLAGS) == 0)
 		return 0;
 
+	if (!strcmp(name, "log") &&
+	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LOG_LEVEL) == 4 &&
+	    !nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_FLAGS))
+	    return 0;
+
 	return -1;
 }
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 4ac7e009..28dc81b7 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -193,6 +193,7 @@ int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
 enum nft_rule_print {
-- 
2.32.0

