Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC789167F93
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgBUOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:05:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58564 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbgBUOFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Aazh1RhyvXOGHb09Cwj8jGdosZoKwm2UiHbqdSBwAKU=; b=fd40N3pzJ32R/3wJ8wHUq3Y7EM
        KQ6wR5fs2s/OA2v9a9kNtotfVWhmqzTk+67KJ/h3z+Ukt8DpONxv2WYuE6oAFdYak/IUrF8MFp6/1
        YBCSHbvW1n0Jk7of9hgA7CJ5twxkEo7J37RWBRg0CmubObOcAhIH85ia+DFeVXywQE3exP/k2ziil
        SCAXMgRVYFzeP7jWnyhAtC9IqN9zdkkHY76rDhLgp+PKgblbKX0FD18DQL6SfTKdap1hnlPgplMYM
        mHJQtystu0p5dieKYBbg0z6hv13kOk5kp7olmhjNAaQPD08+GkvKWIu/vhmtGDjFjVnHhZ93KeuGl
        vjY3ABcw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j58vb-0006qW-3a; Fri, 21 Feb 2020 14:05:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5CCE430220B;
        Fri, 21 Feb 2020 15:03:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 821E329B59038; Fri, 21 Feb 2020 15:05:12 +0100 (CET)
Date:   Fri, 21 Feb 2020 15:05:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Will Drewry <wad@chromium.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC patch 09/19] bpf: Use BPF_PROG_RUN_PIN_ON_CPU() at simple
 call sites.
Message-ID: <20200221140512.GG18400@hirez.programming.kicks-ass.net>
References: <20200214133917.304937432@linutronix.de>
 <20200214161503.804093748@linutronix.de>
 <87a75ftkwu.fsf@linux.intel.com>
 <875zg3q7cn.fsf@nanos.tec.linutronix.de>
 <202002201616.21FA55E@keescook>
 <87lfownip5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfownip5.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 03:00:54PM +0100, Thomas Gleixner wrote:
> Of course not. If we'd run the same thread on multiple CPUs in parallel
> the ordering of your BPF programs would be the least of your worries.

Been there, done that. It goes sideways *REALLY* fast :-)
