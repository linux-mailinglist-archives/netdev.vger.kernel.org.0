Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6458922B14A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgGWO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGWO0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:26:36 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D3C0619DC;
        Thu, 23 Jul 2020 07:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wwAZ4+QkYVfMEHOVd3BXrZYoQyQVya/EkyI6lTMJuEc=; b=PMLkNsZxkfipkQdx59Ts5gbSgy
        ODJbDs/oG8tcz8/eohMUTIz+JBG8PYDPFQKWJMwDegGQl83DK2H4STe5I0pz7ZqX8KdZzt/EiC9Os
        dzdb+OE63JAGbPDhIco+b5j1Yy3qEnFWRiNqz1O3tImnIJ3Pkcar23kbnxKbQKOS+OPuXYKMniIGR
        pP5J4QQFMcVKpENacLV0k/slNjU1uyWx4kIShROCXfnBpF6JKLJ+mScEmbPN9YtO6oDhGnSmeAuVr
        91tN4f4u0hpzoB0inLOFLV0Na6vJeadwIpqLOlss8qCFFij3lla63yca6jWqOzYWlPEGrdBDYYnlN
        rQouaYzw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jycAz-0006IN-CG; Thu, 23 Jul 2020 14:26:25 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5BE1A983422; Thu, 23 Jul 2020 16:26:23 +0200 (CEST)
Date:   Thu, 23 Jul 2020 16:26:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alex Belits <abelits@marvell.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
Message-ID: <20200723142623.GS5523@worktop.programming.kicks-ass.net>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <87imeextf3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imeextf3.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:17:04PM +0200, Thomas Gleixner wrote:

>   2) Instruction synchronization
> 
>      Trying to do instruction synchronization delayed is a clear recipe
>      for hard to diagnose failures. Just because it blew not up in your
>      face does not make it correct in any way. It's broken by design and
>      violates _all_ rules of safe instruction patching and introduces a
>      complete trainwreck in x86 NMI processing.
> 
>      If you really think that this is correct, then please have at least
>      the courtesy to come up with a detailed and precise argumentation
>      why this is a valid approach.
> 
>      While writing that up you surely will find out why it is not.

So delaying the sync_core() IPIs for kernel text patching _might_ be
possible, but it very much wants to be a separate patchset and not
something hidden inside a 'gem' like this.

