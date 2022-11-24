Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFAA637E0D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiKXRHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKXRHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:07:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150024AF1D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:07:46 -0800 (PST)
Date:   Thu, 24 Nov 2022 18:07:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669309664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JltpVUin2CI9V/o/ommsB+fQ4wSuF6SpC8DnHQFEX1M=;
        b=1AYCUCLtdmIpNq/tJC5Chby4RU5rlpYj6DNlODtotcMpL4Eydx/sl2xqqdvQjzCq2ZemUh
        VfC0QDpgs7guyX9aH4A5PoQgaHPBYFG8bQdmMHDS34uTyskZIIL6ly/IV8ij6IWucawg/g
        0Nc5BlEBfyoOz9sRU9lBxD8c6mvvkMuPKuCCCH5NOoJiNvocAMtWqUKe5bhiF0tNhQoCQc
        qtOvvUoP5sjZyS+yhbzPFqQFOtgQYGPPjlBTomrY3sPtxx2+1rVWmCXEd28GT+Dskah4lH
        OlzbaPh0HZs9fT8Gif9ysHA1Q2Zus5Em+ZUZteVknQO/CKGcSWEEtmGXcv+zfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669309664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JltpVUin2CI9V/o/ommsB+fQ4wSuF6SpC8DnHQFEX1M=;
        b=20SCRBM3Nxsot3Mtbqn33BpoJlMHnTUV8Fu/gKZDIxNQ2FuJ3NxHgtnRTQZex94Ue3ZYqP
        /cLzPyDFxu139rBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v3 net 0/6] hsr: HSR send/recv fixes
Message-ID: <Y3+k38K5C2GWXAWQ@linutronix.de>
References: <20221123095638.2838922-1-bigeasy@linutronix.de>
 <3e8a822d1e9f0dad7256763cb7d2fdaf1115c0f5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e8a822d1e9f0dad7256763cb7d2fdaf1115c0f5.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-24 16:06:15 [+0100], Paolo Abeni wrote:
> Hello,
Hi,

> I think this series is too invasive for -net at this late point of the
> release cycle. Independently from that, even if contains only fixes, is
> a so relevant refactor that I personally see it more suited for net-
> next.

As you wish. The huge patch is the first one basically reverting the
initial change plus its fixup back to pre v5.18 time.
Right now it is not usable here due to the double delete under RCU
which happens randomly but usually within 30min. But it appears I'm the
only one complaining so far ;)

If you want to merge it via next, be my guest. Can you apply it as-it
or do I need to repost it again?

> In any case it looks like you have some testing setup handy, could you
> please use it as starting point to add some basic selftests?

This task might be within my capabilities. I guess you ask for something
that spins a few virtual interfaces and then creates a HSR ring on top
of it.

> Thanks!
> 
> Paolo

Sebastian
