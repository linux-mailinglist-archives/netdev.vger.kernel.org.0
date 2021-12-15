Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3274754D2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhLOJGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhLOJGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:06:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED7FC061574;
        Wed, 15 Dec 2021 01:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/gnLOx5MckqsqXcaJGTFGvaCSrtiaNjF1HqSIA4z/lw=; b=V9yE5LKY35qxfGLLbo36mQaETj
        dlECIASz0KjEEKwuEJ4xZnEOLfEhwtmedhIhCanS6gGNkjHmGi1ocK0T7wNqLGharrNG9fUyDhT56
        SjMffbv5XExgOgYJdjKTaVHmDx4Oebdk2HLkNmIddeJVxey5oMgEU1XfFjOoNGKsuS5+PmOpIBNTr
        95UT9gudfUmxWuUbMEH5AnFYl3CRAoo379rcpnCCJij8CuxGPDfU4Ick2i7F5Ib6il2ISEVXrrYHl
        NaatNDDzVWRMkDiZRFoArU+hcqh2ArAGyzKSmidVNViy+abpWzIgSktQHfT6tsH5BF5v25hnHSXPJ
        Np2HT4pA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxQEz-00EUvr-Aa; Wed, 15 Dec 2021 09:06:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4E3F5300252;
        Wed, 15 Dec 2021 10:06:25 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 362532B3206D2; Wed, 15 Dec 2021 10:06:25 +0100 (CET)
Date:   Wed, 15 Dec 2021 10:06:25 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, x86@kernel.org
Subject: Re: [PATCH v2 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Message-ID: <YbmwEZub47vxlFT/@hirez.programming.kicks-ass.net>
References: <20211215060102.3793196-1-song@kernel.org>
 <20211215060102.3793196-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215060102.3793196-6-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 10:01:00PM -0800, Song Liu wrote:
> This will be used by BPF jit compiler to dump JITed binary to a RWX huge

RWX *must* not happen, ever. If you still rely on that full NAK.
