Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408F32CDD29
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgLCSPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgLCSPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:15:15 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BBAC061A4F;
        Thu,  3 Dec 2020 10:14:34 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id e5so1544524pjt.0;
        Thu, 03 Dec 2020 10:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TQMsGw5TYSt3nJ1A5aken7ygzu0wjxlcoNGw9kKmue0=;
        b=iejdTNAB2XX7rYGGnSp0K+7wWy7I18mWggkvrs1FpBvqrP1bROgzyh7jBNiUSsDctV
         uVK8iPbSLIjJDCPDOQwlQ26MoSQco7J/w3ifrTdRykYZriG8QrFBcsBcWIeY/kTb51lZ
         lE6ROdv0tlMR0NWWUIiFOh6j2vGUoxqJvFV83goJBv9dJ14cFiYKOv0ChJLm3NY+k4P+
         DPd8smKFc1pyJmOhpDsIxIKMPcAxnMpwzGpyxGxwEqoFSZll2A/4/1R+VdLPyAObNQ8v
         ypFwy8vex1EkFa8iz+p/dmBC7Qn+rVAcWYtnj3kjr56gfSS3GP6sStpFG6K7YUAZrSUY
         By2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TQMsGw5TYSt3nJ1A5aken7ygzu0wjxlcoNGw9kKmue0=;
        b=SrTUzABe/aWKJAGP2Hzki5yzolkRhbPjPnsfc+mkCUk9XWA9b0gtFu1vzuVi4nZ/Iz
         MusvcBONPBUMY133Q5MPHXhhgy9ugno4iIflJtrvKVGGkTT012VwD/VGvN29FrOAmpN8
         ZYMtUKHLOoFtQAtMNrbjgFli5sGZdd+7Y4uTOlcSD1Chz/ePGazRb8rLieNe6YHoicAs
         r1MAWKmqnwnIfgFKou43UE/nyt/DonW2FpfRwPomgXUHYXaBdNvVvi5t1U02SfKqLwlK
         nRx4aYQFo4+IjZPPEMvxY0Q1clJ6PEs/veebdpW6X4yzG3naiVt45iOOhcwUy7Hx8mX5
         PEJw==
X-Gm-Message-State: AOAM5328nm2XanizGeYHa6P266iMSWSPqgj+MeUwqWKywIPOjQQQ3l5t
        UA8dWF2U79r7VP+LTqRl6OI=
X-Google-Smtp-Source: ABdhPJzHsjuHf7s63jZQr10HWp/cMbWEsj7ImPOHDdh2Sqv0oWuhaFVBKA8A49ZD/5npl9N/qfTjaA==
X-Received: by 2002:a17:902:9a90:b029:da:ba07:efdc with SMTP id w16-20020a1709029a90b02900daba07efdcmr388590plp.1.1607019274431;
        Thu, 03 Dec 2020 10:14:34 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a629])
        by smtp.gmail.com with ESMTPSA id h6sm256161pgc.15.2020.12.03.10.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:14:33 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:14:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Gary Lin <glin@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf, x64: bump the number of passes to 64
Message-ID: <20201203181431.t2l63nifzprxqc26@ast-mbp>
References: <20201203091252.27604-1-glin@suse.com>
 <8fbcb23d-d140-48fb-819d-61f49672d9bd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fbcb23d-d140-48fb-819d-61f49672d9bd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 12:20:38PM +0100, Eric Dumazet wrote:
> 
> 
> On 12/3/20 10:12 AM, Gary Lin wrote:
> > The x64 bpf jit expects bpf images converge within the given passes, but
> > it could fail to do so with some corner cases. For example:
> > 
> >       l0:     ldh [4]
> >       l1:     jeq #0x537d, l2, l40
> >       l2:     ld [0]
> >       l3:     jeq #0xfa163e0d, l4, l40
> >       l4:     ldh [12]
> >       l5:     ldx #0xe
> >       l6:     jeq #0x86dd, l41, l7
> >       l8:     ld [x+16]
> >       l9:     ja 41
> > 
> >         [... repeated ja 41 ]
> > 
> >       l40:    ja 41
> >       l41:    ret #0
> >       l42:    ld #len
> >       l43:    ret a
> > 
> > This bpf program contains 32 "ja 41" instructions which are effectively
> > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > bpf jit should optimize those "ja 41" instructions out when translating
> > the bpf instructions into x86_64 machine code. However, do_jit() can
> > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > is set even though it's legit as a classic socket filter.
> > 
> > Since this kind of programs are usually handcrafted rather than
> > generated by LLVM, those programs tend to be small. To avoid increasing
> > the complexity of BPF JIT, this commit just bumps the number of passes
> > to 64 as suggested by Daniel to make it less likely to fail on such cases.
> > 
> 
> Another idea would be to stop trying to reduce size of generated
> code after a given number of passes have been attempted.
> 
> Because even a limit of 64 wont ensure all 'valid' programs can be JITed.

+1.
Bumping the limit is not solving anything.
It only allows bad actors force kernel to spend more time in JIT.
If we're holding locks the longer looping may cause issues.
I think JIT is parallel enough, but still it's a concern.

I wonder how assemblers deal with it?
They probably face the same issue.

Instead of going back to 32-bit jumps and suddenly increase image size
I think we can do nop padding instead.
After few loops every insn is more or less optimal.
I think the fix could be something like:
  if (is_imm8(jmp_offset)) {
       EMIT2(jmp_cond, jmp_offset);
       if (loop_cnt > 5) {
          EMIT N nops
          where N = addrs[i] - addrs[i - 1]; // not sure about this math.
          N can be 0 or 4 here.
          // or may be NOPs should be emitted before EMIT2.
          // need to think it through
       }
  }
Will something like this work?
I think that's what you're suggesting, right?
