Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D33470061
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbhLJMBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 07:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237578AbhLJMBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 07:01:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02BCC0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:57:44 -0800 (PST)
Date:   Fri, 10 Dec 2021 12:57:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639137463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e1vgqxQf/HEi/380wsVHeIa9ywtiqHCGTo+cLrBRCS8=;
        b=M06WG2fjZg8Q7s/v74qppLMukNLwKMvoskcPaBE+u0RABP+0hnmX1ucoBrvIcdc2ONks3i
        xZE6b5nRkbka6yd8uj6I5EyaY6fh2d4xuSmoCGI9mBYeiyY1PmdQCOtu7EDJbZXiea2rrM
        vdcfjawEaBaRyLWeF/E7Hg/hlAoDZnyh304ebFxSlPKzlyQA1fIZZSol8a8Y1Y4BPxpPYm
        k6ulRdzVbUJgYaTenybJ5jI4LH7+NRH4/oJMFn7B9dCGilW8iPh6+u9K/Q7c4bng4Zz1C0
        VhIuhmuZGMqq2gMBAbDmoGtlhwtI+u2nF6dosyq4Nhqp8Uc3vrOWussg4eWwNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639137463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e1vgqxQf/HEi/380wsVHeIa9ywtiqHCGTo+cLrBRCS8=;
        b=rsc5nRk9sbKctQ/ZB7AeRdGtNr25bxJmH09axXoE00yDptL0jMq7ZL992/bFEo7MIiqUsc
        2ysWQSGF6MWYVgCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
Message-ID: <YbNAtugLvd83zP2W@linutronix.de>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-3-boon.leong.ong@intel.com>
 <87fsr0zs77.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87fsr0zs77.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-10 11:10:04 [+0100], Kurt Kanzenbach wrote:
> > +	if (match.mask->n_proto) {
> > +		__be16 etype = ntohs(match.key->n_proto);
> 
> n_proto is be16. The ntohs() call will produce an u16.

While at it, could we be please remove that __force in
ETHER_TYPE_FULL_MASK and use cpu_to_be16() macro?

> Thanks,
> Kurt

Sebastian
