Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEBB30DA4B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 13:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhBCMz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 07:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhBCMvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 07:51:52 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80846C061788;
        Wed,  3 Feb 2021 04:51:11 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q72so2923501pjq.2;
        Wed, 03 Feb 2021 04:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S9+BN5vtBtRNRklrmhD8i8s/HAewqFBC4xIWzBNnZpA=;
        b=PzAfJHsUytagm16pcRgqIuQOi6kw/XpJ40siwz3Da+5F32b9Zq+VIsqgRGIr4KByoM
         fCB5EkY5YkEMZNOiCJ1GRJDnfmligi6/4u/VhtFXCwt1WwWZE4mzGY759jQY70+bOTFp
         r14ratgNNiGJaLU5UOpYqrBlHKwHRNEVjkgpap12hwV493SvabT8hae1zpF+eqIGmhGn
         gcwD4moDUT3xTRq2Fg16yY5rIBZk2/d/JYWhDNgXqAZCGo1hPWlRyRwssVHbbkfE4rz+
         bPt6gS/Nq14zB720K1BpLg+PuCi59m8ChkjKSTIsrf+bRJq0imJpwi7qRkZyeU7vCdWP
         TbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S9+BN5vtBtRNRklrmhD8i8s/HAewqFBC4xIWzBNnZpA=;
        b=jL7gkzhcXRIiBho9ePITYWL+pgHJD8jT7+vPUN4Ji1BpV/EYHls6gEK2N9DH7c54OP
         FDz0KAay57iD1QAp2krX1LNNDPKOCAoqg5xfBBGKsXXSgcpzU4vaskSVU5J6Vxn8sirk
         eERlVrMl1w3C5GbNXqhZRoZkQDlUZGZV0r/3UE8h2rzMbO9tRoEMGR//4dkQhK5SwkiI
         y8ctvfqf6/KOS97LHCMUJ/r1UIGjfqf0h0V8/coChYlMJZkLwTCGNK9AkeMEo8j5f49E
         OFsP9vgX2vjNc6ACGqgGQKtVMaoVO8zBiUflCh9k61tFljeTTf3OKTuKh2/biPsb68ZQ
         l5HQ==
X-Gm-Message-State: AOAM533/NK6tt8kNxqIYlx+ptFuXTwSdV8yY6kLUIbbLiPwVv3WgT8Bi
        mZj/e3OHGUwzr5pVhTMdM7W7AsA43uoAJFTayUiIum7KrUvHrQ==
X-Google-Smtp-Source: ABdhPJy085hGLdV3fX0r3q7Ieui6cZUtfqMubqv4wtMjc1VtnqAw/dhTCQ9i05Il/R03Nu2GKJ3R0JicMHJuDZLoGOg=
X-Received: by 2002:a17:902:760f:b029:df:e6bf:7e53 with SMTP id
 k15-20020a170902760fb02900dfe6bf7e53mr2945946pll.80.1612356671051; Wed, 03
 Feb 2021 04:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk> <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net> <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch> <20201207230755.GB27205@ranger.igk.intel.com>
 <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch> <20201209095454.GA36812@ranger.igk.intel.com>
 <20201209125223.49096d50@carbon> <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
 <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
 <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com> <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
 <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com> <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
 <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com>
 <87h7mvsr0e.fsf@toke.dk> <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
 <87bld2smi9.fsf@toke.dk> <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marek Majtyka <alardam@gmail.com>
Date:   Wed, 3 Feb 2021 13:50:59 +0100
Message-ID: <CAAOQfrGqcsn3wu5oxzHYxtE8iK3=gFdTka5HSh5Fe9Hc6HWRWA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        jeffrey.t.kirsher@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 02 Feb 2021 13:05:34 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> > Marek Majtyka <alardam@gmail.com> writes:
> >
> > > Thanks Toke,
> > >
> > > In fact, I was waiting for a single confirmation, disagreement or
> > > comment. I have it now. As there are no more comments, I am getting
> > > down to work right away.
> >
> > Awesome! And sorry for not replying straight away - I hate it when I
> > send out something myself and receive no replies, so I suppose I should
> > get better at not doing that myself :)
> >
> > As for the inclusion of the XDP_BASE / XDP_LIMITED_BASE sets (which I
> > just realised I didn't reply to), I am fine with defining XDP_BASE as a
> > shortcut for TX/ABORTED/PASS/DROP, but think we should skip
> > XDP_LIMITED_BASE and instead require all new drivers to implement the
> > full XDP_BASE set straight away. As long as we're talking about
> > features *implemented* by the driver, at least; i.e., it should still b=
e
> > possible to *deactivate* XDP_TX if you don't want to use the HW
> > resources, but I don't think there's much benefit from defining the
> > LIMITED_BASE set as a shortcut for this mode...
>
> I still have mixed feelings about these flags. The first step IMO
> should be adding validation tests. I bet^W pray every vendor has
> validation tests but since they are not unified we don't know what
> level of interoperability we're achieving in practice. That doesn't
> matter for trivial feature like base actions, but we'll inevitably
> move on to defining more advanced capabilities and the question of
> "what supporting X actually mean" will come up (3 years later, when
> we don't remember ourselves).

I am a bit confused now. Did you mean validation tests of those XDP
flags, which I am working on or some other validation tests?
What should these tests verify? Can you please elaborate more on the
topic, please - just a few sentences how are you see it?
