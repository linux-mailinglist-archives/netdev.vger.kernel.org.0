Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3F4A7597
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbiBBQOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiBBQOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:14:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F31C061714;
        Wed,  2 Feb 2022 08:14:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01721B8311D;
        Wed,  2 Feb 2022 16:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C821C004E1;
        Wed,  2 Feb 2022 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643818488;
        bh=rpDNn5PP1EW37e80KojAMS0/AhW13rer0G1wgDxcZ4M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rijs+bJNQ0crU27z3nBT2y/9pWQywHFm9uIGkbrVLescriaeTi/YMRfMZdTLi6IAt
         WyrsCQuRkNZPwcqbNvAbNkZmw84WHNvoTHQx+vlfKdSJB1L5TRwjM2yekTDgOlRGoN
         bB7LsOBIlA/fnCEQ8TT60n8lw0V/1m45Q74l7qsBgcqkLXq+e5i6SBhm0Ojray5gV2
         XStUFoywms9UY0L1gmRpSt/IfQPXTvDnPqhlG4eaJIDGLF57LivAVl6I2lumRmwaqM
         D12OGuRU56rZPtrROgj9JK2OLjslaThVgFTRSQkJadgs72v62JSf//5nzKUIwKh6Ou
         DJa1bBcfGK/CQ==
Date:   Wed, 2 Feb 2022 08:14:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>
Subject: Re: [PATCH net-next 0/4] net: dev: PREEMPT_RT fixups.
Message-ID: <20220202081447.29f4fe2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220202122848.647635-1-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Feb 2022 13:28:44 +0100 Sebastian Andrzej Siewior wrote:
> Hi,
> 
> this series removes or replaces preempt_disable() and local_irq_save()
> sections which are problematic on PREEMPT_RT.
> Patch 3 makes netif_rx() work from any context after I found suggestions
> for it in an old thread. Should that work, then the context-specific
> variants could be removed.

Let's CC Toke, lest it escapes his attention.
