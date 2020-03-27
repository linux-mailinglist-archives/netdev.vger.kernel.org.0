Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30B0195AAA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC0QI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:08:58 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40487 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbgC0QI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 12:08:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id 19so10753347ljj.7;
        Fri, 27 Mar 2020 09:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spnkQutFB18IjJxiXOUjvoPj/dKwleF9bt8ULMfxB1Y=;
        b=pQzJlif3MiB+xaxOktX9paLasGpqWzapgfk2xIE9kLJ3a0ybeI+m2EPYtXR9phWgK1
         j+UNr5MmCNpz757pMUKQcgtV4to2BuJA4l/M1KkcBOlTeIfFQ3wUNuxJR4a7hvBdDmsF
         SCtA5K6zihic2AlVuPCYB3IHEoqy2NmbbwpCtU0XzLMQgk+9S3AtQnZqK+cOC6UcJ/G+
         PdqrwEjrC5w69PR5eFMp6oQsNnnVMzV7+eVgfdlPvCuj7pVsbpMl0feQNXTQy27Ec2/X
         1CxKoO/HUgJPVlykF4QIlx+MBpmG18fSGWsBnqR09AjPSPVoD1SFKF39cCIu4SqhynS7
         e9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spnkQutFB18IjJxiXOUjvoPj/dKwleF9bt8ULMfxB1Y=;
        b=uSO4b5Sw649qHw0YBKKXFz4PcRRVQ+iXlEE8gK9Vxoez7noEiLTnDtZN27osAHwth3
         iz+2rq7WoiUhUT+bRtTm0q7Oq6n15WfG/Za+C2Lyrr/iOKVeHnc30aXsMvxrJAkJSFIy
         hzsm27DDQtAf+MZTkXozNYbA/VZY7GeKLcfhYgDFIZvNWsrSVB/M21QaJQvnGaBcq6Xk
         vL5wGc0Nv6PuiC+hGNdQgWaRBM50pjCj7z7pFwahYNcWCvRUOr45sn2kqnTV2+oEfnor
         iAu3Nqvz/NcfTiDqvuyLjua9C0xsec3YO35kNTA9fMgcs//M87U1ZioivqN6Bw6jwvzR
         OAPA==
X-Gm-Message-State: AGi0PuYguJ88VWhTu4sgZekm051Cg5U/o06nYAsEw9VgYzKAkkAJCXNQ
        N01POg/XmxmN24Nki8ojz7b35TlE9Q2C0rymU7cMxw==
X-Google-Smtp-Source: APiQypJga1+Zdr53axMFLQR1J8gqplOP1NeXfwltFHQ8tw9f7bjl0DsITKxwAfVTuQxdMofD3tEfOPhyDMqqKtLZGBQ=
X-Received: by 2002:a2e:988c:: with SMTP id b12mr8986610ljj.138.1585325334923;
 Fri, 27 Mar 2020 09:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com> <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
 <20200326210719.den5isqxntnoqhmv@ast-mbp> <CACAyw9_jv3eJz8eRRBOvWEc4=BM0_tRuQCz_fLKsVLTid7tCDA@mail.gmail.com>
In-Reply-To: <CACAyw9_jv3eJz8eRRBOvWEc4=BM0_tRuQCz_fLKsVLTid7tCDA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 27 Mar 2020 09:08:43 -0700
Message-ID: <CAADnVQKoO18HSTEkUdw9M4_YawdSw_FsDbLjK6jGiPRfiy6K2w@mail.gmail.com>
Subject: Re: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf:
 add test for sk_assign
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Yonghong Song <yhs@fb.com>, Joe Stringer <joe@wand.net.nz>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 3:03 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Thanks for bringing this up.
> > Yonghong, please correct me if I'm wrong.
> > I think you've experimented with tracking spilled constants. The first issue
> > came with spilling of 4 byte constant. The verifier tracks 8 byte slots and
> > lots of places assume that slot granularity. It's not clear yet how to refactor
> > the verifier. Ideas, help are greatly appreciated.
> > The second concern was pruning, but iirc the experiments were inconclusive.
> > selftests/bpf only has old fb progs. Hence, I think, the step zero is for
> > everyone to contribute their bpf programs written in C. If we have both
> > cilium and cloudflare progs as selftests it will help a lot to guide such long
> > lasting verifier decisions.
>
> Ok, I'll try to get something sorted out. We have a TC classifier that
> would be suitable,
> and I've been meaning to get it open sourced. Does the integration into the
> test suite have to involve running packets through it, or is compile
> and load enough?

It would be great if you can add it as part of test_progs and run it
with one or two packets via prog_test_run like all the tests do.
Thanks!
