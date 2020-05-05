Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72CB1C551A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgEEMLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728603AbgEEMLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 08:11:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7327C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 05:11:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so2052091wma.4
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 05:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GfkKDN3U0Fak2+2qGbh9J5E/oCVrfybMFbff5lvFh4M=;
        b=yjAGwpIHpA5KtqMUw5+hpDZOCW58jIDAwPV9D0zt+e6URxhjYmoJrm2IjgM98JJHTo
         CrLYxALxvOhp5OvWrockQmOE2NZf30RVqTXmFMkafO+MeOPRnOkWGq/WrYlAe1J08p1n
         7JBrYY/6R6bdgdUC3rel9a8RejJJSR2CcHJIeUx3/zmFQjJgd6YbN46qThP8Wmrsqe8x
         8LI8Nr/x4iIl98zNOAf56Ot812faA+mpVF3F28kDwnrniYg3pfk2Z8Suhy6lhvOj8jy9
         lGF6ulE6dUwEkaDFWHd/xeM9eTBTHx/a55E5tV9+/yLoxdXOcnCge1umC/Nl6pF3GSab
         igww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GfkKDN3U0Fak2+2qGbh9J5E/oCVrfybMFbff5lvFh4M=;
        b=ePipWzqlwLl/rb0/YZNYK3nk5p0xQTxmXTLgaBg2GMh118vbxizxhVHhdNAjip+qWl
         YSuO8oExfjEGkOFn+YbKl8effuworScPVy36Z65PtSJ7RT/LUC1oNWQkcGMJDQ94k76B
         9c2mKRPsGUBVwYl7rwN6BEGJICemqWJiHoOwaKLeRFfecFETHbdKE6/iJo1h4zEWI6vQ
         YA3w4uMJNlH4xNKhsqBDDhYcEDcS4IPRg5CcFfvtCasOJUrr5WpuOwmY7XdGsyzp8FlG
         +jBmTeUOyzjU1iEerMqFAGU50/GTlTfXnv0sGpap8Mdcq6vdFBt/VM3VYn0PkRNwnMCK
         IabQ==
X-Gm-Message-State: AGi0PuZK/P0XklBZt2HGgY+fQW3Otx1x0zYtA3e7RHSIbGHxCY7o/Rf8
        1rjLEbd3gpfx3Z3sE6ZL+YhBYQ==
X-Google-Smtp-Source: APiQypIDO7s4Ggqimk/sDrN5143nXwFIxQntiZ4q34Ow2v6ExztohehSTwyLFshYUzwY7vynqYzilw==
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr2975910wmh.11.1588680677409;
        Tue, 05 May 2020 05:11:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z22sm3461384wma.20.2020.05.05.05.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 05:11:16 -0700 (PDT)
Date:   Tue, 5 May 2020 14:11:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, ecree@solarflare.com
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505121115.GH14398@nanopsycho.orion>
References: <20200505092159.27269-1-pablo@netfilter.org>
 <20200505094900.GF14398@nanopsycho.orion>
 <20200505100814.GA29299@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505100814.GA29299@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 05, 2020 at 12:08:14PM CEST, pablo@netfilter.org wrote:
>On Tue, May 05, 2020 at 11:49:00AM +0200, Jiri Pirko wrote:
>> Tue, May 05, 2020 at 11:21:59AM CEST, pablo@netfilter.org wrote:
>> >This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
>> >that the frontend does not need counters, this hw stats type request
>> >never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
>> >the driver to disable the stats, however, if the driver cannot disable
>> >counters, it bails out.
>> >
>> >Remove BUILD_BUG_ON since TCA_ACT_HW_STATS_* don't map 1:1 with
>> >FLOW_ACTION_HW_STATS_* anymore. Add tc_act_hw_stats() to perform the
>> >mapping between TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*
>> >
>> >Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
>> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> >---
>> >This is a follow up after "net: flow_offload: skip hw stats check for
>> >FLOW_ACTION_HW_STATS_DISABLED". This patch restores the netfilter hardware
>> >offloads.
>> >
>> > include/net/flow_offload.h |  9 ++++++++-
>> > net/sched/cls_api.c        | 23 +++++++++++++++++------
>> > 2 files changed, 25 insertions(+), 7 deletions(-)
>> >
>> >diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> >index 3619c6acf60f..0c75163699f0 100644
>> >--- a/include/net/flow_offload.h
>> >+++ b/include/net/flow_offload.h
>> >@@ -164,12 +164,15 @@ enum flow_action_mangle_base {
>> > };
>> > 
>> > enum flow_action_hw_stats_bit {
>> >+	FLOW_ACTION_HW_STATS_DISABLED_BIT,
>> > 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
>> > 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
>> > };
>> > 
>> > enum flow_action_hw_stats {
>> >-	FLOW_ACTION_HW_STATS_DISABLED = 0,
>> >+	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
>> >+	FLOW_ACTION_HW_STATS_DISABLED =
>> >+		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
>> > 	FLOW_ACTION_HW_STATS_IMMEDIATE =
>> > 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
>> > 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
>> >@@ -325,7 +328,11 @@ __flow_action_hw_stats_check(const struct flow_action *action,
>> > 		return true;
>> > 	if (!flow_action_mixed_hw_stats_check(action, extack))
>> > 		return false;
>> >+
>> > 	action_entry = flow_action_first_entry_get(action);
>> >+	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
>> >+		return true;
>> >+
>> > 	if (!check_allow_bit &&
>> > 	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
>> > 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
>> >diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> >index 55bd1429678f..8ddc16a1ca68 100644
>> >--- a/net/sched/cls_api.c
>> >+++ b/net/sched/cls_api.c
>> >@@ -3523,16 +3523,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
>> > #endif
>> > }
>> > 
>> >+static enum flow_action_hw_stats tc_act_hw_stats_array[] = {
>> >+	[0]				= FLOW_ACTION_HW_STATS_DISABLED,
>> >+	[TCA_ACT_HW_STATS_IMMEDIATE]	= FLOW_ACTION_HW_STATS_IMMEDIATE,
>> >+	[TCA_ACT_HW_STATS_DELAYED]	= FLOW_ACTION_HW_STATS_DELAYED,
>> >+	[TCA_ACT_HW_STATS_ANY]		= FLOW_ACTION_HW_STATS_ANY,
>> 
>> TCA_ACT_HW_* are bits. There can be a combination of those according
>> to the user request. For 2 bits, it is not problem, but I have a
>> patchset in pipes adding another type.
>> Then you need to have 1:1 mapping in this array for all bit
>> combinations. That is not right.
>> 
>> How about putting DISABLED to the at the end of enum
>> flow_action_hw_stats? They you can just map 0 here to FLOW_ACTION_HW_STATS_DISABLED
>> as an exception, but the bits you can take 1:1.
>
>Another possibility is to remove this mapping code is to update tc
>UAPI to get it aligned with this update.
>
>This UAPI is only available in the few 5.7.0-rc kernel releases,
>I think only developers are using this at this stage?

Hmm, I think that TC-wise, the UAPI as is makes perfect sense. There is
no don't care. Each bit allows to indicate user what he is interested
in.

I would prefer to convert to flow_offload (as we do anyway) in a format
that is comfortable for flow_offload (given the fact it is used not only
for TC).

Did you check the solution I suggested? Above. Seems to be quite
straightforward.
