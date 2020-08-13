Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C49243F47
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgHMTUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 15:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgHMTUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 15:20:49 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD7BC061757;
        Thu, 13 Aug 2020 12:20:49 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so3296453pgi.9;
        Thu, 13 Aug 2020 12:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Eu04kgJeLeMPTSIDNmL4XAEMIaEJ5W8Pj+0XbxuHnWw=;
        b=TCBgamhEmpY5CsXYmnz2KguGRGqFo1NU1+B663f1SFpjp/nBviCcXJYTHrS+mHgCra
         NGv9yf7ZtYIi2ZgVXU4O4VYHHYknHWhHbca2dRN9cRf0/yoLkbuxOodkYhsHpo/ZcLvt
         HDIiCT1ugIxghvulBMLmWEIfTdExOjUp1d0fJKX5AMFhmFmlpYw54Sjc5vcNz3fc0ccs
         SfwyZtcBeGCps9gDX3vttKSX6D+YirE8k5rCJkIASodey6XUliLA4gWpGzFST3ybHX+0
         6CRhdxkb8363JX4Nbozru6uMXb411IR2OLSEq2olQ5GlWiOD33j2lPvTXKwTD90vofFR
         VRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Eu04kgJeLeMPTSIDNmL4XAEMIaEJ5W8Pj+0XbxuHnWw=;
        b=VnLyd/d8flfGRpBzzizdoguAg/dP3/pqvQSg4H1Xz9IGWVLP+POoZeCLYyCDkrLpZZ
         +/5/fhMoSLNkOXRetFexI68tydL6AJpZkDfOKoJrT1zs7srj2pPPAqxIrAQQASZERZEg
         snSYBAePegNx+QxYC4flURsnw0542a9bEfir4TlyhIqpq3ir11lMK2C1YtcJJG0f2Jsd
         hnVnx1HtYI4d8td8HNSq5M3iGiubtLuDqfC0qAUHYFMZttpeYz29H0KagOcTW6wfPj0P
         7bhhl9bmZCyP/h/TUpu5qJ16dC09+lmqrCMu9KexSBuOMTzdScmA4Z+ZBcZ7WW9GhRhd
         aA1w==
X-Gm-Message-State: AOAM531vI16hUfogvng67lnZZkZ+5KO0IPkFXYLdz8kAG9ROnlnVnmmL
        grUZ8DZM7iauUy9DuDXQPV826zKa
X-Google-Smtp-Source: ABdhPJwRjT1WUfNb2iqH23cnQZTuCXtqKskLMw7oFNxOkGOj+T8I9HSTC+JcSkZp+iYv+jsBH1ZJ/w==
X-Received: by 2002:a05:6a00:81:: with SMTP id c1mr5981705pfj.189.1597346445300;
        Thu, 13 Aug 2020 12:20:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:affd])
        by smtp.gmail.com with ESMTPSA id x127sm6680655pfd.86.2020.08.13.12.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 12:20:44 -0700 (PDT)
Date:   Thu, 13 Aug 2020 12:20:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf 0/9] Fix various issues with 32-bit libbpf
Message-ID: <20200813192042.ntv6ybry6ck2s6jg@ast-mbp.dhcp.thefacebook.com>
References: <20200813071722.2213397-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813071722.2213397-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 12:17:13AM -0700, Andrii Nakryiko wrote:
> This patch set contains fixes to libbpf, bpftool, and selftests that were
> found while testing libbpf and selftests built in 32-bit mode. 64-bit nature
> of BPF target and 32-bit host environment don't always mix together well
> without extra care, so there were a bunch of problems discovered and fixed.
> 
> Each individual patch contains additional explanations, where necessary.
> 
> This series is really a mix of bpf tree fixes and patches that are better
> landed into bpf-next, once it opens. This is due to a bit riskier changes and
> new APIs added to allow solving this 32/64-bit mix problem. It would be great
> to apply patches #1 through #3 to bpf tree right now, and the rest into
> bpf-next, but I would appreciate reviewing all of them, of course.

why first three only?
I think btf__set_pointer_size() and friends are necessary in bpf tree.
The only thing I would suggest is to rename guess_ptr_size() into
determine_ptr_size() or something.
It's not guessing it. Looking for 'long' in BTF is precise.
We can teach pahole and llvm to always emit 'long' type and libbpf can
fail parsing BTF if 'long' is not found.
