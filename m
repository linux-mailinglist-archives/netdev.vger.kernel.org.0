Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC6DF42DF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 10:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfKHJMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 04:12:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfKHJMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 04:12:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YIHYOpvUjexfzszN8OUhE0GgVLo5FF0K9taZHuF6CJY=; b=U+yYFmO6HnI5cXs5XTlph3lp8
        +KGjTaDx4sPVtGPQiFcC7wmgih7Mk8AGaZbUeiOgaiqRzC9Qr6skgw4mQ2UdHCUkznrolq7fGdtxa
        FRr6s8vVsUjQCyjLCVU3wEAKM5tO4TucOj5ImlWeSqL+QsKRNKqaGjCZ705jEGS4uDVh2Oa6HlE8z
        0xH7BiKMlIaGDfAqfHiJb0q8p4WCv/i2E+xdKFsI/tQYu74wShgFZKBL5NlqQIrMjEvnG/fpCN0Hh
        9bBjagmGc1GiGpkEEbkHen/4BpqFuu8iyzUPENO50srcutsHZhZaru1fkE+cVIFaKNk181ZQHPg6M
        MfpNrvo7w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iT0JD-0001P1-B3; Fri, 08 Nov 2019 09:11:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E788F301A79;
        Fri,  8 Nov 2019 10:10:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7668D20241336; Fri,  8 Nov 2019 10:11:56 +0100 (CET)
Date:   Fri, 8 Nov 2019 10:11:56 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Message-ID: <20191108091156.GG4114@hirez.programming.kicks-ass.net>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108064039.2041889-3-ast@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:40:23PM -0800, Alexei Starovoitov wrote:
> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> nops/calls in kernel text into calls into BPF trampoline and to patch
> calls/nops inside BPF programs too.

This thing assumes the text is unused, right? That isn't spelled out
anywhere. The implementation is very much unsafe vs concurrent execution
of the text.
