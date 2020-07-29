Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549EC2320BC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgG2OiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2OiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:38:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05B1C061794;
        Wed, 29 Jul 2020 07:38:22 -0700 (PDT)
Date:   Wed, 29 Jul 2020 16:38:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596033501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bAHTxzN0gWTh+MkrXmdjO8wWMvKGi2+w2dVS7q7UmIA=;
        b=1itXZ31SArjIuGoL4PExFbXtkgMxC5azgL0xmChhJY2ltok7CIABL0I95OeeX7hf4lS4tO
        fLqTuB3wdXRf+kmvufiFnB88T3Ma3QB+7MOlEySedh2bbO5AFbgI8HztI32nR3FPpZrbxj
        PbkpmnIQLjcNMRvdcxQbr6GdDAUC0tQJBFh/Cu2hdh/CYCbT6XKQorZd8Vj0M7iKAlWdpA
        /O0XIxVnJceKWji8CrErxqz03BB87sOCHs49z31kDA+21pPLQDZ+GFpM2y30RMXbgp1Tlz
        qHCw6Kf8SE3BZhLbe+3GSLxbnKjdRNONGjUE2gYJCGnMoyN6z4abuLPtLOoJZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596033501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bAHTxzN0gWTh+MkrXmdjO8wWMvKGi2+w2dVS7q7UmIA=;
        b=PywhQY25QMA1AQd1RSwETL1HDSundZ9b/3rlD+pBu8J+i61dUjNB0QWpc3YHodqdVbgqBJ
        VqexUS48xwXk5RBA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, tglx@linutronix.de,
        paulmck@kernel.org, bigeasy@linutronix.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, davem@davemloft.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] seqlock: Fold seqcount_LOCKNAME_t definition
Message-ID: <20200729143819.GA1413842@debian-buster-darwi.lab.linutronix.de>
References: <20200729135249.567415950@infradead.org>
 <20200729140142.347671778@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729140142.347671778@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 03:52:51PM +0200, Peter Zijlstra wrote:
> Manual repetition is boring and error prone.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---

...

> +/**
> + * typedef seqcount_LOCKNAME_t - sequence counter with spinlock associated

                                                        ^ associated lock

> + * @seqcount:	The real sequence counter
> + * @lock:	Pointer to the associated spinlock
> + *

              ^ Pointer to the associated write serialization lock

> + * A plain sequence counter with external writer synchronization by a
> + * spinlock. The spinlock is associated to the sequence count in the
> + * static initializer or init function. This enables lockdep to validate
> + * that the write side critical section is properly serialized.

ditto, you forgot to change the associated spinlock language to generic
locks ;-)

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
