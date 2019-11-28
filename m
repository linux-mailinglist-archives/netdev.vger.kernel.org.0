Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAD210C130
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 01:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfK1A73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 19:59:29 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:47033 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK1A73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 19:59:29 -0500
Received: by mail-lj1-f196.google.com with SMTP id e9so26497546ljp.13;
        Wed, 27 Nov 2019 16:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GlDsn7TqBs4w48Ao28vIPY+vTJ4FRLpQy82LHAO9FtM=;
        b=dct7JSOOxj7fmLcV6CatAbFkMkk+UoveZkp97Ar7akOPlhi8ZWJjP/o4CXp431UR+N
         luuDF+9IQPZooAfD62gbrYgCgQCevKJD9tE0gZ44JMcdYXWEXrGT7wzkva7n+koICphB
         5bv2C8OHfCi4xq3Ru4/NPktJc/rNzrZeU8j5SR5e39AciMEWkXHN728967uZm+NFLpWF
         0Gch3jGmwIfMcWCWrjr8B3jEWbu2PENANkdrtMV87F4xKFXztqbc1uES+Em/0KkU9cNk
         4XIV5uwTpMr2wodZeqXhwzkw1jdu7hBok2fBoFU0g5Rww+7tzz4H5lX3bRdnroAIKDzs
         vFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GlDsn7TqBs4w48Ao28vIPY+vTJ4FRLpQy82LHAO9FtM=;
        b=D6M3Nvv1oD3Kfwyne+z5SHtCJ5FXvyHy4RU8dUSGoYwZLF7R/QXdQrJ3xQvI1OlBVX
         SJBZBaRtA159rOe7TRFiYet6613nn5uuK0/YvLbunb54QqWb3iM/E7vjWyJFD0t6QL3G
         w1YeXd/ljDdYb7NShVSz785qAcspJEXOmH5oz1eh/mlkF8adJFnTMgEIWdRXgbKh4odd
         oAyZtmULMmihzA59/EfOQuD47xpd0rmRoi+5uMjhKOKGnXHmN/ahZLIwd53/vRoY1ZlV
         glFbi6SVyk1pjQZJUDtgxkPgDoiajZhxr0gruv541chjosjsmpP6NL7K0ubNun1yjm8S
         vS9w==
X-Gm-Message-State: APjAAAWO7JfukhxsQzAmSEI9Y0n4YTmpyWDC57XDP4P8wvyqhpz+fko9
        +QmRrbcxJSQ8XuZZMEVyQ7aXhf9phS/4IpADCKU=
X-Google-Smtp-Source: APXvYqxVO2dwVk/p7oC6P4ANvvZYmBGLPU6Bnady0f0cJ8kbFRAMU3/QWKWq4fr0Qbz/MbrXG5uh3N+OTfw63e9A9Uk=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr32148600lji.136.1574902766702;
 Wed, 27 Nov 2019 16:59:26 -0800 (PST)
MIME-Version: 1.0
References: <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org> <CAADnVQJCMpke49NNzy33EKdwpW+SY1orTm+0f0b-JuW8+uA7Yw@mail.gmail.com>
 <2993CDB0-8D4D-4A0C-9DB2-8FDD1A0538AB@kernel.org>
In-Reply-To: <2993CDB0-8D4D-4A0C-9DB2-8FDD1A0538AB@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 16:59:15 -0800
Message-ID: <CAADnVQJc2cBU2jWmtbe5mNjWsE67DvunhubqJWWG_gaQc3p=Aw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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

On Wed, Nov 27, 2019 at 4:50 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Take it as one, I think it's what should have been in the cset it is fixing, that way no breakage would have happened.

Ok. I trimmed commit log and applied here:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=1fd450f99272791df8ea8e1b0f5657678e118e90

What about your other fix and my suggestion there?
(__u64) cast instead of PRI ?
We do this already in two places:
libbpf.c:                shdr_idx, (__u64)sym->st_value);
libbpf.c:             (__u64)sym.st_value, GELF_ST_TYPE(sym.st_info),
