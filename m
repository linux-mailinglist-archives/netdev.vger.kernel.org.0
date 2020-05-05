Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6466C1C5F17
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgEERnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728804AbgEERnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:43:04 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C05EC061A0F;
        Tue,  5 May 2020 10:43:04 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x15so1226469pfa.1;
        Tue, 05 May 2020 10:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kvERfMRg9N5gTCAlwuPKs93EBGmnYI4iJipCtIeq2gs=;
        b=Qph4APLFoI2+hzETZ4MmK6/ia7rSIkOf+Q0tNR6/Yo671rXycMeMqjEDN4wuCsWKoi
         eP5p3DBCR7byLb7+zZxVURtTEsaF6lQs4JpX5tNHKBLL5HbqdqaW2hu8nCH6uiXeO1Mt
         TG357redEoBK4eVC5aKYVa1hUpHM6dTk7QwMRxdYeF3Wc5je3F24D9KNDZF1sNBA+EOX
         kPkwmufXTAne9zliUtdZQGQA+pjzumbZDQsrPuyv80c3uivMX+42kn6gQgDwli//Ofc0
         eD3MCUbBaHAq4nvhYYiFgk1cPvqNBDrTEL8+bkx+TofdZxjcP/M+9GgwDVJZ6WlaQLIG
         33UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kvERfMRg9N5gTCAlwuPKs93EBGmnYI4iJipCtIeq2gs=;
        b=gsKJUGZRMUcq2txq1EsN4HH6uk3gwPxhDT/v8GsLyqzyiseANGQ0uNFktfYvdE36T4
         kDbJ8SAK8oUF/QZJLoKogbCFQlkVKJW7R6xBoVB7M/7liER10utGJBktOE4h7OXqkpb3
         u3UvluSdFA1uYcyOxc6iiwwJWDAljSUE9x1FocW5TU3xW2axnaeECG75BddoTUe7ptMQ
         8qD06IHrmskZSVdiOxIYgMzoNqAFgiiMYu2xkGWgEhGWTDcSroI25Zg11FTzI3UqKMGD
         mDzpVp/cPMOk7uP/707/BhgsZvsonAs3YFnUKOBgZR74CaipAQyiX+AwLohagrJcERLm
         r5sQ==
X-Gm-Message-State: AGi0Puars1VP+Q7ypvLsFblrkO7g8Hfn+1oZUeEHn0/QQ7DksPe9HY7A
        uR8fS1VPniL4mZ/uXyfLE2o=
X-Google-Smtp-Source: APiQypJsKH+LeTVhCiBz3tctOiyz1jq7J90tXBhNupoM92x5fxgvFC/LDvDfddsbxltiQK36joF2hA==
X-Received: by 2002:aa7:951c:: with SMTP id b28mr3849168pfp.242.1588700583810;
        Tue, 05 May 2020 10:43:03 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6a9])
        by smtp.gmail.com with ESMTPSA id a16sm1881501pgg.23.2020.05.05.10.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 10:43:02 -0700 (PDT)
Date:   Tue, 5 May 2020 10:43:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502192105.xp2osi5z354rh4sm@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 02, 2020 at 02:21:05PM -0500, Josh Poimboeuf wrote:
> 
> Ideally we would get rid of that label and just change all the 'goto
> select_insn' to 'goto *jumptable[insn->code]'.  That allows objtool to
> follow the code in both retpoline and non-retpoline cases.  It also
> simplifies the code flow and (IMO) makes it easier for GCC to find
> optimizations.

No. It's the opposite. It's not simplifying the code. It pessimizes
compilers.

> 
> However, for the RETPOLINE=y case, that simplification actually would
> cause GCC to grow the function text size by 40%.  

It pessimizes and causes text increase, since the version of gcc
you're testing with cannot combine indirect gotos back into direct.

> I thought we were in
> agreement that significant text growth would be universally bad,
> presumably because of i-cache locality/pressure issues.  

No. As I explained before the extra code could give performance
increase depending on how branch predictor is designed in HW.

> Or, if you want to minimize the patch's impact on other arches, and keep
> the current patch the way it is (with bug fixed and changed patch
> description), that's fine too.  I can change the patch description
> accordingly.
> 
> Or if you want me to measure the performance impact of the +40% code
> growth, and *then* decide what to do, that's also fine.  But you'd need
> to tell me what tests to run.

I'd like to minimize the risk and avoid code churn,
so how about we step back and debug it first?
Which version of gcc are you using and what .config?
I've tried:
Linux version 5.7.0-rc2 (gcc version 10.0.1 20200505 (prerelease) (GCC)
CONFIG_UNWINDER_ORC=y
# CONFIG_RETPOLINE is not set

and objtool didn't complain.
I would like to reproduce it first before making any changes.

Also since objtool cannot follow the optimizations compiler is doing
how about admit the design failure and teach objtool to build ORC
(and whatever else it needs to build) based on dwarf for the functions where
it cannot understand the assembly code ?
Otherwise objtool will forever be playing whackamole with compilers.
