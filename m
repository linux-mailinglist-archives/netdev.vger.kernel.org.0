Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E731D2876
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 09:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgENHEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 03:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgENHET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 03:04:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7748FC061A0C;
        Thu, 14 May 2020 00:04:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so875133pgv.8;
        Thu, 14 May 2020 00:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hl1HPzb7dFtDLSR9rDmWF+8gIgfdqQC3u8YiNpHMJl0=;
        b=CtP+bBcSjhGDsnkt8n84+x3WSL1FNSfcdsZ6vPxLKDK3zn9+rUCTxkJr7wUQ4YK2JJ
         SMS08S3Koj2QBf6eGyWenIyBzBwv4mtMMEmS5oqXGXC1M4GfJG0kpjKXfvKBEHvhT7p+
         xqp1REo/VOz2c3KwjiA1kXfzPTkSF9SrpU+C29/k/Oj3hfc14Pyhmegc5eQXuGxVXyAI
         hD+O51R6MAH4PxgrP0RaSJniy/S96KWNN0Y3XKijTRuqewgLAcldvsiLleyS3iYyz1II
         +QXw9VRwFsBtE88ryWZwx1/S1KJJ7IAT5Up8zq3VcOsWlsC+2+P90fnIk3nK+9uHCINO
         G3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hl1HPzb7dFtDLSR9rDmWF+8gIgfdqQC3u8YiNpHMJl0=;
        b=GNJ6vbHtCYc0/W0n1tnuyV8EIwCPtFgqLTtG21NmJutLoOF6+VpRwnYDUpsd3pnfRF
         YuD4IKkAegEQTjFk+X6Y7UEGW9K+luAVovC6j9Mq3M8H+5nSRuXa1HQ2fMamq2aUNPFr
         9A+cqqOFVcGJ8Su1yMLsgsBFQOvPaKI2tZlKdUvWxV4wRuY1upFdyus1zFylvvmoKw1c
         4+oulfQxKxceuV7CO4WwPXdAetais93tNBOrx8cge/EGF/+c4GALPNNlZtVAFhn3LaU3
         tm4CHgLSRLV6M8YDT1JAC+EbZr3gD0s+dc0+jB2dH3oVRp+jIR11NuhcBn8dy21DjY4c
         RDZw==
X-Gm-Message-State: AOAM530nWMmBhm+K2qaUjEjTeqrXY+taXtzn6U/FyL2POsjYlrpl55ze
        IZHCSJIr7T7QiPEZVKsLYg==
X-Google-Smtp-Source: ABdhPJxAp+3G8cqLmj/q9C3zR40xnwzfs4zf1FH/qUYzUa4+nIL+ilNSJL92YBiNLvm5S8C5JALS1A==
X-Received: by 2002:a63:e90e:: with SMTP id i14mr2789778pgh.173.1589439859068;
        Thu, 14 May 2020 00:04:19 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2409:4071:5b5:d53:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id 28sm17439149pjh.43.2020.05.14.00.04.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 May 2020 00:04:18 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Thu, 14 May 2020 12:34:09 +0530
To:     David Miller <davem@davemloft.net>
Cc:     madhuparnabhowmik10@gmail.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        frextrite@gmail.com, joel@joelfernandes.org, paulmck@kernel.org,
        cai@lca.pw
Subject: Re: [PATCH] Fix suspicious RCU usage warning
Message-ID: <20200514070409.GA3174@madhuparna-HP-Notebook>
References: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
 <20200513.120010.124458176293400943.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513.120010.124458176293400943.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:00:10PM -0700, David Miller wrote:
> From: madhuparnabhowmik10@gmail.com
> Date: Wed, 13 May 2020 11:46:10 +0530
> 
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > This patch fixes the following warning:
> > 
> > =============================
> > WARNING: suspicious RCU usage
> > 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> > -----------------------------
> > net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> > 
> > ipmr_new_table() returns an existing table, but there is no table at
> > init. Therefore the condition: either holding rtnl or the list is empty
> > is used.
> > 
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> Please only provide one signoff line.
> 
> Please provide a proper Fixes: tag for this bug fix.
> 
> And finally, please make your Subject line more appropriate.  It must
> first state the target tree inside of the "[PATCH]" area, the two choices
> are "[PATCH net]" and "[PATCH net-next]" and it depends upon which tree
> this patch is targetting.
> 
> Then your Subject line should also be more descriptive about exactly the
> subsystem and area the change is being made to, for this change for
> example you could use something like:
> 
> 	ipv6: Fix suspicious RCU usage warning in ip6mr.
> 
> Also, obviously, there are also syzkaller tags you can add to the
> commit message as well.
Sorry for this malformed patch, I have sent a patch with all these
corrections.

Thank you,
Madhuparna
