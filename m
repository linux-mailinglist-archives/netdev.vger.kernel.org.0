Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033A060CA9C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJYLIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJYLIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:08:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D0CC34C0;
        Tue, 25 Oct 2022 04:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kFUIxH5cQ1U5HxjGKxL4+qmhsXHOIKoljOk3nViH64E=; b=RiS4tXJLkRtXK5nDW2eOKvZAll
        FJP1bX+r5N3GtCZJMtMLLyTkPLRuTzklX3vfJIzmEPbUlDjaYGQVr4WxuvqQd+99ONwkzGvPndVHF
        lY0ZD12yCrGTeHJBRGdgTPzXf991xxxx5+W+PipiIgVylevDaI3B3YoIVyx9kfwUzpXnZShBo+hTK
        oLIP9xVKbyoCLoYKHPhs372gzWUoNjcbrnawgNNw9ZWMzYtBSBiPRZQRvR3/Xspan49Kaf6FK73EK
        9T77zgFp4wU1f66D8TPt3qEZLhTqDw2CSuV1RFcvKniDHy+qPO7Muk9oZiXYT3Ya1irqj/gK4LbGQ
        V6JWZ5yw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onHmk-006ITC-2c; Tue, 25 Oct 2022 11:07:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6DD3430008D;
        Tue, 25 Oct 2022 13:07:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1D67C2C431FAA; Tue, 25 Oct 2022 13:07:52 +0200 (CEST)
Date:   Tue, 25 Oct 2022 13:07:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>, dave.hansen@intel.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Message-ID: <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 03:57:45PM -0700, Pawan Gupta wrote:

> The other goal of this series is to start a discussion on whether such
> hard to exploit, but theoretical possible attacks deems to be mitigated.
> 
> In general Branch Target Injection class of attacks involves an adversary
> controlling an indirect branch target to misspeculate to a disclosure gadget.
> For a successful attack an adversary also needs to control the register
> contents used by the disclosure gadget.

I'm thinking this is going about it wrong. You're going to be randomly
sprinking LFENCEs around forever if you go down this path making stuff
slower and slower.

Not to mention that it's going to bitrot; the function might change but
the LFENCE will stay, protecting nothing but still being slow.

I think the focus should be on finding the source sites, not protecting
the target sites. Where can an attacker control the register content and
have an indirect jump/call.

Also, things like FineIBT will severely limit the viability of all this.

And how is sprinking random LFENCEs around better than running with
spectre_v2=eibrs,retpoline which is the current recommended mitigation
against all this IIRC (or even eibrs,lfence for lesser values of
paranoia).
