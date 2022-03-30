Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472AA4ED073
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiC3X4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 19:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiC3X4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 19:56:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C9E4BFDE;
        Wed, 30 Mar 2022 16:54:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648684497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F7H0Whtjpqs59w2OpfQeqBlIIs/NhVNiIQQ169K/rKc=;
        b=bOxbIsLJsbGICa31gQoiX8QfSkeywkPPgjllv0ZLYj2Bzbt61R5dohRn9w/a/+TQThT4zb
        KKmIOrwA603a1fcDQCAjavl0ry87UH5BAOxu4j2JGTHIftNdB39b5gmbmNHzkyOcxNqyb+
        GeFmR6duu8tC1MAgMaWAa7yA0r16aHADYnJnB97QfmmzjC5Sj65GWWssbe/4/E3VOOW65L
        ltFX+k+300lobnnVsEbeTV8ScEevB0oABFKgc15KUM2Nv/O5j29l/EO3XciTzH6GV5h5TG
        OWGuR9QZx+6m8AlzfFdgaIUxiGb0xIV5g3C2gJ74u9T3dT9BBITM6ThCjfk00g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648684497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F7H0Whtjpqs59w2OpfQeqBlIIs/NhVNiIQQ169K/rKc=;
        b=FuUAB4fiuYWzcVcT1OIVi9p//D/d/z33rwhq0gQp+o+4KFg/VXi9SA8hEcuUh/8nzCTVUV
        T2D+SE3/xd+RztAQ==
To:     Song Liu <song@kernel.org>, linux-mm@kvack.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, x86@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, akpm@linux-foundation.org,
        pmenzel@molgen.mpg.de, rick.p.edgecombe@intel.com,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf 3/4] x86: select HAVE_ARCH_HUGE_VMALLOC_FLAG for X86_64
In-Reply-To: <20220330225642.1163897-4-song@kernel.org>
References: <20220330225642.1163897-1-song@kernel.org>
 <20220330225642.1163897-4-song@kernel.org>
Date:   Thu, 31 Mar 2022 01:54:56 +0200
Message-ID: <87tubfm1wv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30 2022 at 15:56, Song Liu wrote:
> As HAVE_ARCH_HUGE_VMALLOC is not ready for X86_64, enable
> HAVE_ARCH_HUGE_VMALLOC_FLAG to allow bpf_prog_pack to allocate huge
> pages.

Despite HAVE_ARCH_HUGE_VMALLOC being not ready for X86_64 enable it
nevertheless?

I assume you wanted to say something like this:

  The shortcomings of huge vmalloc allocations have been fixed in the
  memory management core code, so reenable HAVE_ARCH_HUGE_VMALLOC.

Thanks,

        tglx
