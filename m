Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C611C522D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEEJtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEJtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 05:49:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65442C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 02:49:03 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u127so1594370wmg.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 02:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eH3hQJmEm9UuA4QFHYjZCWYej9mUfXlB6TbzIXAYWQs=;
        b=IBc0A3wBFR2FhOvJKvRYc5r0YN6K1j8n68nwQelpqnFbFmITgxC8nDbRI1spHuvKi1
         1NocL3X/9lWbrq6sm5ehk+CRPX3DZaaH9jfJ+ek4J0MRxc2Gpza3rrvAabF9v6OiEnCJ
         lxv5OES7nP8G3ntNpszioSZD46WlPRal4hZozQZ5kUlGDXRRCUXPWUnfTYoDzjAv0p2f
         rYocz6uqaYYI5rQAIGRCjYOxpKQpR2mtPbiJZIorLOGvFQIwi201QZ634GEa5bns78AI
         dXR5BAM/h2L+o1L6g03U9AnvApk+mozEMCXvlFStaziSSxh2YUUaudLMiLT2RRnlASEw
         tJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eH3hQJmEm9UuA4QFHYjZCWYej9mUfXlB6TbzIXAYWQs=;
        b=obC0hEDyoherkqmpSYb4kGCDfFKiMTRhohoyBpSQxf3M4g5ZGvxaZVKFijHqPQQXse
         b4wNLaSPEa0dbAMH/nkoPoUSD+sJeGF0wxwAG+MHXbrk7DxjdHahiw/kcBLrifZeoHEI
         BIy4u4Gpr0eUUKNFZMvuql4mafwg4buGlksTTybPOKXRThFBe4OCiQgsnehTmyE+ZSjG
         7007ixL04Hgb2JetA5Wd5+UjhtXZkz/4gbYjsP/2/H/vptfNBBmAzIX2z5PMHETiFGo5
         cMlVGYRjpNMeaYGx9zW3jnS3WNUDbV8+Q1wEiS5n/XEbkZMor02lZgEUZ5V0IqlRfAvP
         ddgw==
X-Gm-Message-State: AGi0PuZu/5X0kTRnBVJ+I1lYe9JyfwD4TfxTYv2SXvpkXmNJRUk5vSRI
        usXzyue73KPnyRllAbdSpUTeqg==
X-Google-Smtp-Source: APiQypIQbLVODLZnBgyDSBbY4e5IUpImVDiPg9/Y4R+yqyqdnMZwGJnr2Vt1IVAVrwgjJMdVULADjw==
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr2318811wmc.142.1588672142088;
        Tue, 05 May 2020 02:49:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 32sm2479960wrg.19.2020.05.05.02.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:49:01 -0700 (PDT)
Date:   Tue, 5 May 2020 11:49:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, ecree@solarflare.com
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505094900.GF14398@nanopsycho.orion>
References: <20200505092159.27269-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505092159.27269-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 05, 2020 at 11:21:59AM CEST, pablo@netfilter.org wrote:
>This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
>that the frontend does not need counters, this hw stats type request
>never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
>the driver to disable the stats, however, if the driver cannot disable
>counters, it bails out.
>
>Remove BUILD_BUG_ON since TCA_ACT_HW_STATS_* don't map 1:1 with
>FLOW_ACTION_HW_STATS_* anymore. Add tc_act_hw_stats() to perform the
>mapping between TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*
>
>Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>This is a follow up after "net: flow_offload: skip hw stats check for
>FLOW_ACTION_HW_STATS_DISABLED". This patch restores the netfilter hardware
>offloads.
>
> include/net/flow_offload.h |  9 ++++++++-
> net/sched/cls_api.c        | 23 +++++++++++++++++------
> 2 files changed, 25 insertions(+), 7 deletions(-)
>
>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index 3619c6acf60f..0c75163699f0 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -164,12 +164,15 @@ enum flow_action_mangle_base {
> };
> 
> enum flow_action_hw_stats_bit {
>+	FLOW_ACTION_HW_STATS_DISABLED_BIT,
> 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> };
> 
> enum flow_action_hw_stats {
>-	FLOW_ACTION_HW_STATS_DISABLED = 0,
>+	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
>+	FLOW_ACTION_HW_STATS_DISABLED =
>+		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
> 	FLOW_ACTION_HW_STATS_IMMEDIATE =
> 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
> 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
>@@ -325,7 +328,11 @@ __flow_action_hw_stats_check(const struct flow_action *action,
> 		return true;
> 	if (!flow_action_mixed_hw_stats_check(action, extack))
> 		return false;
>+
> 	action_entry = flow_action_first_entry_get(action);
>+	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
>+		return true;
>+
> 	if (!check_allow_bit &&
> 	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
> 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index 55bd1429678f..8ddc16a1ca68 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -3523,16 +3523,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
> #endif
> }
> 
>+static enum flow_action_hw_stats tc_act_hw_stats_array[] = {
>+	[0]				= FLOW_ACTION_HW_STATS_DISABLED,
>+	[TCA_ACT_HW_STATS_IMMEDIATE]	= FLOW_ACTION_HW_STATS_IMMEDIATE,
>+	[TCA_ACT_HW_STATS_DELAYED]	= FLOW_ACTION_HW_STATS_DELAYED,
>+	[TCA_ACT_HW_STATS_ANY]		= FLOW_ACTION_HW_STATS_ANY,

TCA_ACT_HW_* are bits. There can be a combination of those according
to the user request. For 2 bits, it is not problem, but I have a
patchset in pipes adding another type.
Then you need to have 1:1 mapping in this array for all bit
combinations. That is not right.

How about putting DISABLED to the at the end of enum
flow_action_hw_stats? They you can just map 0 here to FLOW_ACTION_HW_STATS_DISABLED
as an exception, but the bits you can take 1:1.



>+};
>+
>+static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
>+{
>+	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
>+		return FLOW_ACTION_HW_STATS_DONT_CARE;
>+
>+	return tc_act_hw_stats_array[hw_stats];
>+}
>+
> int tc_setup_flow_action(struct flow_action *flow_action,
> 			 const struct tcf_exts *exts)
> {
> 	struct tc_action *act;
> 	int i, j, k, err = 0;
> 
>-	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
>-	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>-	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>-
> 	if (!exts)
> 		return 0;
> 
>@@ -3546,7 +3557,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
> 		if (err)
> 			goto err_out_locked;
> 
>-		entry->hw_stats = act->hw_stats;
>+		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
> 
> 		if (is_tcf_gact_ok(act)) {
> 			entry->id = FLOW_ACTION_ACCEPT;
>@@ -3614,7 +3625,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
> 				entry->mangle.mask = tcf_pedit_mask(act, k);
> 				entry->mangle.val = tcf_pedit_val(act, k);
> 				entry->mangle.offset = tcf_pedit_offset(act, k);
>-				entry->hw_stats = act->hw_stats;
>+				entry->hw_stats = tc_act_hw_stats(act->hw_stats);
> 				entry = &flow_action->entries[++j];
> 			}
> 		} else if (is_tcf_csum(act)) {
>-- 
>2.20.1
>
