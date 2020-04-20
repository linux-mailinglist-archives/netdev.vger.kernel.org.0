Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C971B03A9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgDTICF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 04:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgDTICE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 04:02:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2004C061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 01:02:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so10871043wrs.9
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 01:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ygbCyVoytSgnmJXW9Krfav2y/rVb2VywGCGHg1z93qk=;
        b=XjYnB6pFEFhOEO7j0nRKsMTiRKSRyPuB/HPhrmD2QHJ9UFASNBnSEcak0hwST/+p7c
         aH4kqa7dFdQSFfw5rjm1LxRzSLlJ1euWDPxdS0QSQT/yy5cPjWmjiIkS5HRmSHzPSckS
         ik1HCI+fUaoHaI/5fLUEmzX7Eocrotit97zlr7QCLbyYK4xn3J+YarH7VoWm5gqcqXij
         6KrUBDh3FbN4efpd1NTgir4rAxiPbbM5Ati/94KhCrNMiReok43MbqsB9Zujn14aBPN/
         hCscrp314mkGkJdqNgbIzeUsQzD1jpk/8naIP80osGO7Itz4XpIGAKbltfPOwskoUHbt
         9OtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ygbCyVoytSgnmJXW9Krfav2y/rVb2VywGCGHg1z93qk=;
        b=jjXlfTTkzFU7mNQruXLIFEgL7LJ4aD6O3TvfwlK+CdHGrOwvBjNm8L6GMH4r0vUdfD
         eV8KUTmem5Rw5RNbEhpdvlirbdK3IeYIy7NK5JaJti5HT+2vhIaXicfiTdrqF2jEZdDN
         qtL3ta0pv1AXyyY9JUOJUKYDKOAhgj/WbvvZ4aqYdWMJnJpjB43m6cz8KqNwMfGkqNFT
         PCA9fcAQLfX3hukeIBJAdtiuttbuSoxb53+OjOC0C9e345TsEqgqJi+JTY9HbfEWq/Sa
         Z1Jzu+tIiFaZhHzv638tUvmIruy/Kytif5PlYqZObW0cL1Zys3mWr580mACa0mf9cNUI
         5aWg==
X-Gm-Message-State: AGi0PuZvBFSk3E9qthcw9AhJCLQHcKztcLS8ELQggsz3UIab5AMXTHz3
        dKRlPfheOTEe63Uesfl1i1+iFQ==
X-Google-Smtp-Source: APiQypIt6hTp7iKATW5mNY6Er8yy5YRvZ9tYavF5BELgeh3/hUZ9xlU6k34oUA7OJ5YYczXss22PGw==
X-Received: by 2002:a5d:6584:: with SMTP id q4mr18841101wru.403.1587369722366;
        Mon, 20 Apr 2020 01:02:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m15sm266620wmc.35.2020.04.20.01.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 01:02:01 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:02:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420080200.GA6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419115338.659487-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Apr 19, 2020 at 01:53:38PM CEST, pablo@netfilter.org wrote:
>If the frontend requests no stats through FLOW_ACTION_HW_STATS_DISABLED,
>drivers that are checking for the hw stats configuration bail out with
>EOPNOTSUPP.

Wait, that was a point. Driver has to support stats disabling.


>
>Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
> include/net/flow_offload.h | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index 3619c6acf60f..c2519a25d0bd 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -326,6 +326,9 @@ __flow_action_hw_stats_check(const struct flow_action *action,
> 	if (!flow_action_mixed_hw_stats_check(action, extack))
> 		return false;
> 	action_entry = flow_action_first_entry_get(action);
>+	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DISABLED)
>+		return true;
>+
> 	if (!check_allow_bit &&
> 	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
> 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
>-- 
>2.11.0
>
