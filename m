Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A982F165392
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgBTA1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:27:55 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41570 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgBTA1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:27:54 -0500
Received: by mail-pg1-f195.google.com with SMTP id 70so968447pgf.8;
        Wed, 19 Feb 2020 16:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Y+lXZvcOBfBAhi74vXh+F5MDPoNXIEah7v92Mu4iLv4=;
        b=djeVkI8Mai6nfa082dqb/fYwZCL7HWd5VYrzdS1cxd58ALdhbyLWaRAB0707cgL1Hs
         B6/UTUB+GY/GlKqIp503aOSoQR9ONtYioOa0HJhyWk67MtJoAYz1zTprMAh65ySJW81l
         NzAVE5xNPteoIrpJ2NxNivspcg4a3pLokzdaKr8p5B0HrIaLT/3iO10x2oVINFXdhhkG
         j1qTbSd/TgMl4u/886LfZojKT+rL5MCqVPnA42B1Rx5B97HhHLDYVJLDQ4YETgY8zmSJ
         pCbuP/Qn5V6475nqBiS8Jhgmk8KMAm+Za9iEgCKfzOjGHoF1HAykm+dY9+5v2V/VijYC
         JbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Y+lXZvcOBfBAhi74vXh+F5MDPoNXIEah7v92Mu4iLv4=;
        b=lPK6ZJYCRX29GtncwnlL/VBFlDSfq4XPkfb8nrDmZwtW7Ke/uQCEoYeB6S2zLY3aD/
         FKrhJQhsT/l46Edp3UEjS6B4f2XAqE64U3YZXmdFz49kYYp1VpQBqfZC9Oam33G68nDf
         17zatzdNub3kvfQjtqg/LD4GthJw4J9eQybBHg3whQD3pNwqlKC/yfkuboE7YOwoCg0w
         NieIToRUb6s9byr4PdwIHl863/LVeTBh+0/bA1JOLHCktEWjVqQgGE0yaUjoveaBVaCU
         ySAETVRlmTrE6zDp1McG4r14dVzpTUJYGESuVsULwVIHK/P1q+K0m6eOAZ2N8D0U+CEe
         lcbQ==
X-Gm-Message-State: APjAAAXugThqb7g/TWIQQVB8XzCNmns8XO9UCA+zosd/e2/xSkiRvyj/
        iABUYh/w5QLuX5iFvhdcbVCBB0DY
X-Google-Smtp-Source: APXvYqwFqz7SUwcM9bgG8aoIsxEkp+bsFoly9zubTnlVMMQ09hDOGOX95YXiuCbAGxVxPK96NTvIPQ==
X-Received: by 2002:a63:ba43:: with SMTP id l3mr31749817pgu.120.1582158473742;
        Wed, 19 Feb 2020 16:27:53 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:1b18])
        by smtp.gmail.com with ESMTPSA id s13sm648733pjp.1.2020.02.19.16.27.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Feb 2020 16:27:52 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:27:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
References: <20200219133012.7cb6ac9e@carbon>
 <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
 <20200219180348.40393e28@carbon>
 <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon>
 <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon>
 <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 03:59:41PM -0600, Daniel Díaz wrote:
> >
> > When I download a specific kernel release, how can I know what LLVM
> > git-hash or version I need (to use BPF-selftests)?

as discussed we're going to add documentation-like file that will
list required commits in tools.
This will be enforced for future llvm/pahole commits.

> > Do you think it is reasonable to require end-users to compile their own
> > bleeding edge version of LLVM, to use BPF-selftests?

absolutely.
If a developer wants to send a patch they must run all selftests and
all of them must pass in their environment.
"but I'm adding a tracing feature and don't care about networking tests
failing"... is not acceptable.

> > I do hope that some end-users of BPF-selftests will be CI-systems.
> > That also implies that CI-system maintainers need to constantly do
> > "latest built from sources" of LLVM git-tree to keep up.  Is that a
> > reasonable requirement when buying a CI-system in the cloud?

"buying CI-system in the cloud" ?
If I could buy such system I would pay for it out of my own pocket to save
maintainer's and developer's time.

> We [1] are end users of kselftests and many other test suites [2]. We
> run all of our testing on every git-push on linux-stable-rc, mainline,
> and linux-next -- approximately 1 million tests per week. We have a
> dedicated engineering team looking after this CI infrastructure and
> test results, and as such, I can wholeheartedly echo Jesper's
> sentiment here: We would really like to help kernel maintainers and
> developers by automatically testing their code in real hardware, but
> the BPF kselftests are difficult to work with from a CI perspective.
> We have caught and reported [3] many [4] build [5] failures [6] in the
> past for libbpf/Perf, but building is just one of the pieces. We are
> unable to run the entire BPF kselftests because only a part of the
> code builds, so our testing is very limited there.
> 
> We hope that this situation can be improved and that our and everyone
> else's automated testing can help you guys too. For this to work out,
> we need some help.

I don't understand what kind of help you need. Just install the latest tools.
Both the latest llvm and the latest pahole are required.
If by 'help' you mean to tweak selftests to skip tests then it's a nack.
We have human driven CI. Every developer must run selftests/bpf before
emailing the patches. Myself and Daniel run them as well before applying.
These manual runs is the only thing that keeps bpf tree going.
If selftests get to skip tests humans will miss those errors.
When I don't see '0 SKIPPED, 0 FAILED' I go and investigate.
Anything but zero is a path to broken kernels.

Imagine the tests would get skipped when pahole is too old.
That would mean all of the kernel features from year 2019
would get skipped. Is there a point of running such selftests?
I think the value is not just zero. The value is negative.
Such selftests that run old stuff would give false believe
that they do something meaningful.
"but CI can do build only tests"... If 'helping' such CI means hurting the
key developer/maintainer workflow such CI is on its own.
