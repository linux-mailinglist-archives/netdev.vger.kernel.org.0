Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4822E10C0FF
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 01:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfK1Ab4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 19:31:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39192 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfK1Ab4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 19:31:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id e10so17291166ljj.6;
        Wed, 27 Nov 2019 16:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brQGdUxSSCA2qoufKtwecSuCiVuN/4tEwRhfBe6lmOo=;
        b=E6pj5RYGJzxqrgP8rezjlVU5GiydmUWCItzBfy3b7wB/D79TsyKS+0pavZ1yLhuYeA
         hbUEgAekrVAE+NfU8dnO/4GthJClqM8kgUCJOnwGuuDbtEE2BTbfPTzbNRFOX0X2q1ci
         9TpYYk5jZB4f+G/jgrUNgVH9wZrBNicCD5HD2KMG+QwskQkhrezLEvHCjkwRZtCEMsFj
         bnGBBsvb7nfXqV+p/Z3s5+R/VFfcxTy2tSMQWCgl50nzFADzOMZVS3yVBmsd9bAuzVXf
         zWtxTO54GEW/tVOfPfzB22ugL4PS6+maFL6rl0dESNSLKJmWRF9ExoEtUKfid7DiN/aw
         hF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brQGdUxSSCA2qoufKtwecSuCiVuN/4tEwRhfBe6lmOo=;
        b=Waf1U27IRt7dv/RumKtCTVIt2JR2ixbsAiyo+O6EZNZW/FRYdU3/6T7UKSKl3mQIWD
         QQ1l6bwZjJc1/9xOfgdEB+8o9deE+Qevuy1nPsXMsJ2MbLKVE1dt8GRjcrzKLqJeK57m
         MlU3GaZWEU969j6CmoOonLbSTNBEggc71NjdrXZfncvbxTrkbqKcM3V0bXXLS7X5JmQh
         4DYckWRJ3aJqLuLT/B00bEUr16cnXem/D9Nh8Gt7LnB1rzE89Zot66RyMpF4vU6endak
         GQpdXW9E44hqzB0llZLD0epJwEfuvOqCDOLobKAd5taZ3jhDM8+zfKm23keRUk4yW9a/
         ibQg==
X-Gm-Message-State: APjAAAU4cBBEeb5VAapHs6AC0UeY9ppV9dqhNpla4HHwiixsmTydn98x
        FWOduWyqqwuRXx4APuNOd1N8wjSc7qora/zs6dM=
X-Google-Smtp-Source: APXvYqx5pjwO5jJzjfHPldQzZUKqIMyttQRfIJgn4Efx8cM5CC+kH93tbguHf8bU5sNE6wsUZe29GWiy9WguTVnf8jQ=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr31738677ljn.188.1574901113946;
 Wed, 27 Nov 2019 16:31:53 -0800 (PST)
MIME-Version: 1.0
References: <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org>
In-Reply-To: <20191127013901.GE29071@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 16:31:41 -0800
Message-ID: <CAADnVQJCMpke49NNzy33EKdwpW+SY1orTm+0f0b-JuW8+uA7Yw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 5:39 PM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Tue, Nov 26, 2019 at 03:52:28PM -0800, Jakub Kicinski escreveu:
> > On Tue, 26 Nov 2019 15:10:30 -0800, Stanislav Fomichev wrote:
> > > We are using this script with python2.7, works just fine :-)
> > > So maybe doing s/python3/python/ is the way to go, whatever
> > > default python is installed, it should work with that.
>
> > That increases the risk someone will make a python2-only change
> > and break Python 3.
>
> > Python 2 is dead, I'm honestly surprised this needs to be said :)
>
> It shouldn't have to be said, and probably it is old school to try and
> keep things portable when there is no need to use new stuff for simple
> tasks like this.
>
> Anyway, it seems its just a matter of adding the python3 package to the
> old container images and then most of them will work with what is in
> that script, what doesn't work is really old and then NO_LIBBPF=1 is the
> way to go.
>
> In the end, kinda nothing to see here, go back to adding cool new stuff,
> lets not hold eBPF from progressing ;-P

Absolutely. I think if some distro is still using 32-bit userland it's likely
so much behind anything modern that its kernel is equally old too
and appeal of new features (bpf or anything else) is probably low.
So if I were you I would keep 32-bit builds of perf supported, but with
minimal effort.

Re: patch itself.
I can take it as-is into bpf tree and it will be in Linus's tree in few days.
Or I can take only tools/lib/bpf/Makefile hunk and you can take
tools/perf/MANIFEST via perf tree?
Whichever way is fine.
