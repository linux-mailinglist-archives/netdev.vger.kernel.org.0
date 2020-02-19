Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90EB3164DCA
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgBSSi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:38:57 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43524 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgBSSi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:38:57 -0500
Received: by mail-qv1-f65.google.com with SMTP id p2so644011qvo.10;
        Wed, 19 Feb 2020 10:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9rFtbpEK/pv7MaVuCRPS0QnaNP+BWE7+SWRKkiX4Bc0=;
        b=ruvoWZhP4w3GP/DQ2XHfLqzoOGPI1EjC0rZp2A9jnitdHOD7/gaAKvEmiCSMr0nsvY
         1EPYQq41qknMI2uxrV/YYWGZYB66RQR5QM4wzPZ0YZRuGOQsUSh+SKF9dIkNJ/5LfqzR
         Rjk7ckhw+NB+qvaJ9c/yDzYF7PxmiRNGTD7dDU2qdSy+d7U+mvBqSAKHbyfuoxUN7bQa
         vvePBRTk2zyLNJdRghuA6e7IGMB3tMuFu4Y/IqGiytiM0G4hK7np7otgwlxk2qKNwxN7
         DrjArR6RMrU3MnahQ/uzmxhHwSrrxIWu/4vW3pu37RNB59D9swbxHBIH3GQH00tls7rZ
         pxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9rFtbpEK/pv7MaVuCRPS0QnaNP+BWE7+SWRKkiX4Bc0=;
        b=sGctTknFFMeSHVweeqZCG3fU1ge7ukpA1hMu0v+1UHzG+YSBMpl3cRejQ5Ndk614Rn
         FNGYN/InZ7mVYUnfK2v/f5la4ySPV48nktG7kbpJ/NOg4ggcCUzbIIoxzHXoDTtqyyat
         d1rIC9HreZ+hT025GKnjypKLdPOknGMrU8y15Nr25j2E67ifpBut0W7t5/AL8AGFwnTC
         lztwlDt1i8OjyvtRT2rf2pPpgFJoqHDjOm21AkJyY7wHlmgTPo8rFL/yluUUTpTNZ8Hc
         DYrkzZ+MvV2WJeWzsTs3o1mvKxddLpV8mfP0UBlke3fHo3zbD287d83mkYQmryfVIdb+
         RPkQ==
X-Gm-Message-State: APjAAAVyORNkavGqteosbuKzSFPcqW5G3cqUEuQ/eY4GPC/A5T2ZTuWX
        aHDSIM+sIh/L0gY4mTW35gtKkMOqtiRC2rn0Wj8=
X-Google-Smtp-Source: APXvYqys6t/plniHSIE7RFiTqfc7mBay5jRkWI5/A6qXBamlubuscaSkZpnMnZgJmzvWc7S+n+TH/oEC51E08nsLU6Y=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr22238350qvq.196.1582137536138;
 Wed, 19 Feb 2020 10:38:56 -0800 (PST)
MIME-Version: 1.0
References: <20200219133012.7cb6ac9e@carbon> <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
 <20200219180348.40393e28@carbon> <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon>
In-Reply-To: <20200219192854.6b05b807@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Feb 2020 10:38:45 -0800
Message-ID: <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 10:29 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 19 Feb 2020 09:38:50 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Wed, Feb 19, 2020 at 9:04 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > On Wed, 19 Feb 2020 08:41:27 -0800
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > On Wed, Feb 19, 2020 at 4:30 AM Jesper Dangaard Brouer
> > > > <brouer@redhat.com> wrote:
> > > > >
> > > > > I'm willing to help out, such that we can do either version or feature
> > > > > detection, to either skip compiling specific test programs or at least
> > > > > give users a proper warning of they are using a too "old" LLVM version.
> > > > ...
> > > > > progs/test_core_reloc_bitfields_probed.c:47:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
> > > > >         out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);
> > > >
> > > > imo this is proper warning message already.
> > >
> > > This is an error, not a warning.  The build breaks as the make process stops.
> > >
> >
> > Latest Clang was a requirement for building and running all selftests
> > for a long time now. There were few previous discussions on mailing
> > list about this and each time the conclusion was the same: latest
> > Clang is a requirement for BPF selftests.
>
> The latest Clang is 9.0.1, and it doesn't build with that.

Latest as in "latest built from sources".

>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
