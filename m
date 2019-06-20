Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0798B4C674
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 07:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfFTFEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 01:04:20 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38579 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTFET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 01:04:19 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so25407ioa.5;
        Wed, 19 Jun 2019 22:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XJopMC6Rv6u1E7+6BykshXCvF47B9L6+sT4w8Ns8DQI=;
        b=Sf4XiY+/o0kBVnVFtGVGCFlIZI9kfCKPo8X2enFgR2Uw3beH6IamQWTzoSYg0QIetj
         CNZQjUA9OI2BiKa9AKJQu8Eye8kHOGsPzzN6fONA3f9uYQGK9DumLFGaS0P2OH5wmLAk
         jxuFQ7spcajRhLIkZYGTcpOYd9nVhpnC3w4COz/pCtEczkf01dJdLFfSKMHy7haoa7DC
         zsrj91Knwc06Ha3FLjSOEs+FvrEhUhl5nUb3oQ5afrtAbglZRMGpbn8QYzyqqkwWWRdc
         HRkTNDafUQ1GfSr1PpbtoJYh2i672xw04ZgjsSUpY7WKCBx7GHrtZbLcgp/1JcgI3aCt
         TOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XJopMC6Rv6u1E7+6BykshXCvF47B9L6+sT4w8Ns8DQI=;
        b=NZ9oplW3kA3PU4d7091Wv0o8DfVaBpQyWmBYb5af4HiIzQZiynphIO7cmRCTAHE3PD
         YTEa33Os6MNB1vm4qRdzSOfsnXpSoRYwknMqN0ftIQKWtl1KP8z+D+B/pG549cs2v/dQ
         4EUuDdMPAaJKIo5ByJFZJ2cg+IIEC+eGQIg55eQBkIoSQx+/xFQtSfcLjF5UrqoYF4zg
         HxB2h51RgKFwhms5coomnGQ7VXIrrPOjaODek6UovRQ9aEB4DFi3Fh2lonU/3hJy0rOx
         oo9aPjTb9SFMZ1v6Zy0ogq65hKy0V1bewdkYRMMr5musgn9wq8XHxUxX334G//AmApr/
         yDWA==
X-Gm-Message-State: APjAAAU7SxHnRDE7Nmb2zN3OXrRQhH5s9TZ2ihR2ItkH9HJJN9iBOE+D
        qpHSytoYE+f77hX2yC0rq7k=
X-Google-Smtp-Source: APXvYqweBiQagR1wAJXwCmJNwKax4ApVKg5h7bmMyoKasx9O8ayl2DcP4HblhQLy0/BwgqJt6nyvyg==
X-Received: by 2002:a5e:c70c:: with SMTP id f12mr16831315iop.293.1561007058624;
        Wed, 19 Jun 2019 22:04:18 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f4sm21102608iok.56.2019.06.19.22.04.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 22:04:17 -0700 (PDT)
Date:   Wed, 19 Jun 2019 22:04:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5d0b13c990eaa_21bb2acd7a54c5b4a0@john-XPS-13-9370.notmuch>
In-Reply-To: <20190620033538.4oou4mbck6xs64mj@ast-mbp.dhcp.thefacebook.com>
References: <20190615191225.2409862-1-ast@kernel.org>
 <20190615191225.2409862-2-ast@kernel.org>
 <5d0ad24027106_8822adea29a05b47c@john-XPS-13-9370.notmuch>
 <20190620033538.4oou4mbck6xs64mj@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH v3 bpf-next 1/9] bpf: track spill/fill of constants
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Jun 19, 2019 at 05:24:32PM -0700, John Fastabend wrote:
> > Alexei Starovoitov wrote:
> > > Compilers often spill induction variables into the stack,
> > > hence it is necessary for the verifier to track scalar values
> > > of the registers through stack slots.
> > > 
> > > Also few bpf programs were incorrectly rejected in the past,
> > > since the verifier was not able to track such constants while
> > > they were used to compute offsets into packet headers.
> > > 
> > > Tracking constants through the stack significantly decreases
> > > the chances of state pruning, since two different constants
> > > are considered to be different by state equivalency.
> > > End result that cilium tests suffer serious degradation in the number
> > > of states processed and corresponding verification time increase.
> > > 
> > >                      before  after
> > > bpf_lb-DLB_L3.o      1838    6441
> > > bpf_lb-DLB_L4.o      3218    5908
> > > bpf_lb-DUNKNOWN.o    1064    1064
> > > bpf_lxc-DDROP_ALL.o  26935   93790
> > > bpf_lxc-DUNKNOWN.o   34439   123886
> > > bpf_netdev.o         9721    31413
> > > bpf_overlay.o        6184    18561
> > > bpf_lxc_jit.o        39389   359445
> > > 
> > > After further debugging turned out that cillium progs are
> > > getting hurt by clang due to the same constant tracking issue.
> > > Newer clang generates better code by spilling less to the stack.
> > > Instead it keeps more constants in the registers which
> > > hurts state pruning since the verifier already tracks constants
> > > in the registers:
> > >                   old clang  new clang
> > >                          (no spill/fill tracking introduced by this patch)
> > > bpf_lb-DLB_L3.o      1838    1923
> > > bpf_lb-DLB_L4.o      3218    3077
> > > bpf_lb-DUNKNOWN.o    1064    1062
> > > bpf_lxc-DDROP_ALL.o  26935   166729
> > > bpf_lxc-DUNKNOWN.o   34439   174607
> >                        ^^^^^^^^^^^^^^
> > Any idea what happened here? Going from 34439 -> 174607 on the new clang?
> 
> As I was alluding in commit log newer clang is smarter and generates
> less spill/fill of constants.
> In particular older clang loads two constants into r8 and r9
> and immediately spills them into stack. Then fills later,
> does a bunch of unrelated code and calls into helper that
> has ARG_ANYTHING for that position. Then doing a bit more math
> on filled constants, spills them again and so on.
> Before this patch (that tracks spill/fill of constants into stack)
> pruning points were equivalent, but with the patch it sees the difference
> in registers and declares states not equivalent, though any constant
> is fine from safety standpoint.
> With new clang only r9 has this pattern of spill/fill.
> New clang manages to keep constant in r8 to be around without spill/fill.
> Existing verifier tracks constants so even without this patch
> the same pathalogical behavior is observed.
> The verifier need to walk a lot more instructions only because
> r8 has different constants.
> 

Got it I'll try out latest clang.

> > > bpf_netdev.o         9721    8407
> > > bpf_overlay.o        6184    5420
> > > bpf_lcx_jit.o        39389   39389
> > > 
> > > The final table is depressing:
> > >                   old clang  old clang    new clang  new clang
> > >                            const spill/fill        const spill/fill
> > > bpf_lb-DLB_L3.o      1838    6441          1923      8128
> > > bpf_lb-DLB_L4.o      3218    5908          3077      6707
> > > bpf_lb-DUNKNOWN.o    1064    1064          1062      1062
> > > bpf_lxc-DDROP_ALL.o  26935   93790         166729    380712
> > > bpf_lxc-DUNKNOWN.o   34439   123886        174607    440652
> > > bpf_netdev.o         9721    31413         8407      31904
> > > bpf_overlay.o        6184    18561         5420      23569
> > > bpf_lxc_jit.o        39389   359445        39389     359445
> > > 
> > > Tracking constants in the registers hurts state pruning already.
> > > Adding tracking of constants through stack hurts pruning even more.
> > > The later patch address this general constant tracking issue
> > > with coarse/precise logic.
> > > 
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  kernel/bpf/verifier.c | 90 +++++++++++++++++++++++++++++++------------
> > >  1 file changed, 65 insertions(+), 25 deletions(-)
> > 
> > I know these are already in bpf-next sorry it took me awhile to get
> > time to review, but looks good to me. Thanks! We had something similar
> > in the earlier loop test branch from last year.
> 
> It's not in bpf-next yet :)

oops was looking at the wrong branch on my side.

> Code reviews are appreciated at any time.
> Looks like we were just lucky with older clang.
> I haven't tracked which clang version became smarter.
> If you haven't seen this issue and haven't changed cilium C source
> to workaround that then there is chance you'll hit it as well.
> By "new clang" I meant version 9.0

I'll take a look at Cilium sources with version 9.0

> "old clang" is unknown. I just had cilium elf .o around that
> I kept using for testing without recompiling them.
> Just by chance I recompiled them to see annotated verifier line info
> messages with BTF and hit this interesting issue.
> See patch 9 backtracking logic that resolves this 'precision of scalar'
> issue for progs compiled with both new and old clangs.
> 

working my way through the series now, but for this patch

Acked-by: John Fastabend <john.fastabend@gmail.com>
