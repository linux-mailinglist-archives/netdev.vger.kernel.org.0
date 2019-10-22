Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEEBE0956
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfJVQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:41:34 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39610 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfJVQle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:41:34 -0400
Received: by mail-qt1-f193.google.com with SMTP id t8so10174598qtc.6;
        Tue, 22 Oct 2019 09:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IzIrEy1As8hGof03hT3Mm3wTy5Y1rVBUbf32dfxPpkU=;
        b=nVimFTvJV2pwY9qquInI6L28RcykzVPIewHfUjtxu0MA4MRVpHrz23SpIpENJGu0ty
         NcVIxLPcCHI86LmFMjcr5C+iNSa37u6MBD0xsaGeU6Zh4ZtLzuLAVD92SFbN7WaAJ4N4
         G1bdhJo9teypqazr8RiP6blT+Y/M+PzvzJA7fD8e5bukuNtcmiY+rDt9SAAN6/wTEggY
         qSkt1xljGckEdZjkvErM8pj8OKQTVxSR3goT1x59oI+b8iPORZdk1zOdSwNH2rWE1ThH
         j0HEjTpg89wvgROF2TVbak2N5ugDWLXGjG5cP95ZHO4ZeLleOPHK+dEsZvu9ykT2FHfj
         N3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IzIrEy1As8hGof03hT3Mm3wTy5Y1rVBUbf32dfxPpkU=;
        b=BM8qc5s+BiDh0VI5PG1+pMQngADpTw0wsn9+k0WAim3EDuI2IUdeTJj7plIy8yUszn
         FobQGDbNjXr4PNATP1zDpEB0C08tmm1uwUekEznhz4aLoCVsdfHqObsyaHkbyaxBFg/n
         J9TPRlITBe/FCHDeawvW3C8IdMS3fe54b7zo14hTPLuaWC/T+VzpIn4hUshnjQ+3S6AN
         McE40j5Ldl7fW1ntp/jG1FyPZpDu3cumy1X647Hzz0nb7akrINlTivYRGPgxIaZoyKjL
         NfxbTIS9mGVhDJzfqvH1Z7GPYS8HaN+IwmPmuxC2vqVyJav/BTRu572T9pU+keYVJ0bx
         zkTQ==
X-Gm-Message-State: APjAAAX3g+ioDuGNOvwMJESVISm9tTrilw3uuEdmeyhJ5tq1HvU0bdNQ
        Dy0O/H5ZwKhMrNHqCUvUgIr9PdWNH3AB0GKjDb2Pkx6S
X-Google-Smtp-Source: APXvYqwGq7jy90yGnxqYkMJ+hGzDcEIXF02J+z4tz6xJ/C0f0bSMl4LxiYA9CffbADDdLComf12wCdUtxun0reBzY8w=
X-Received: by 2002:a0c:c28d:: with SMTP id b13mr3993782qvi.228.1571762492600;
 Tue, 22 Oct 2019 09:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
 <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch> <20191022072023.GA31343@pc-66.home>
In-Reply-To: <20191022072023.GA31343@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 09:41:21 -0700
Message-ID: <CAEf4BzbBoE=mVyxS9OHNn6eSvfEMgbcqiBh2b=nVmhWiLGEBNQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 12:20 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Oct 21, 2019 at 10:07:59PM -0700, John Fastabend wrote:
> > Andrii Nakryiko wrote:
> > > On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > > > kprobes programs on older kernels.
> > >
> > > My main concern with this is that this code is born bit-rotten,
> > > because selftests are never testing the legacy code path. How did you
> > > think about testing this and ensuring that this keeps working going
> > > forward?
> >
> > Well we use it, but I see your point and actually I even broke the retprobe
> > piece hastily fixing merge conflicts in this patch. When I ran tests on it
> > I missed running retprobe tests on the set of kernels that would hit that
> > code.
>
> If it also gets explicitly exposed as bpf_program__attach_legacy_kprobe() or
> such, it should be easy to add BPF selftests for that API to address the test
> coverage concern. Generally more selftests for exposed libbpf APIs is good to
> have anyway.
>

Agree about tests. Disagree about more APIs, especially that the only
difference will be which underlying kernel machinery they are using to
set everything up. We should ideally avoid exposing that to users.

> Cheers,
> Daniel
