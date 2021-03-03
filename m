Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07E232C3F2
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354509AbhCDAJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842689AbhCCIJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 03:09:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5A8C061793;
        Wed,  3 Mar 2021 00:09:11 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l12so22603398wry.2;
        Wed, 03 Mar 2021 00:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DnIVLFqu+VwqwHPGnlO5sV/RQqOYO/AWeTL793zqEr8=;
        b=PjEgRQ1mu8v8tCdEAFoMIBr/IlExGxq/VPkEhFFJd6l40hQijsPbFKU3J/VfDpg6xI
         bxUiCKwbouagbp14RQnpIuIedmAtyiYvvS2eRqMlfkvwG65xVVCOqBQZyVL4wfpbBXWm
         8fD4uoZY6a8y+EPfEyuylPNVFb1nOZPTRIAODeMWG2hyVwDZSj/NzS0P4ZfiW7rCcbQZ
         vAvsIGsS45lpXCt84BgAxkMcj8PuYsgyJUZvjZNOVAX4pW6iHxagZQ9PNmFkk/HS18bz
         G800XXGim5C6FdIg0orf1CnygWAG8C2PKuNzG30QN0mtXl2gZd8Sfqpu6W2k134NwLn+
         QgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DnIVLFqu+VwqwHPGnlO5sV/RQqOYO/AWeTL793zqEr8=;
        b=Sp4va+hfgj3LbwQQvob3j3U4WJySXiGazXZGTzxH3ts7esNEogSXop75HMQxWgtX32
         eT7oFv8XLeapAiet2Cufs2slfW/XsyTQPKakJcqPkxy+BuwKtep+AgGwpMrjq2IiFw91
         pTPfX5QxFZJkGaUQU3nf8evcj+b9EkZeoYJfPBENgjhex9dgEnW7gDvm0q1UUC5wzMJN
         YWeNQwNDv193TzAkWSAALyelvkcLN/t3KAygj5EwEVuJpvRExtVUoPsy/4WlJuquw22B
         Z59MXGmorwosVCUItASkiLE+l/PsmrYnzObUMbl2O0hGGMr7jlcth6UQpRJOm3TY4mV0
         VAkA==
X-Gm-Message-State: AOAM531xY6x/1Hq4WEDdf4nhhLpqfjdfArzg5Yyuj3P42nJyrGTciEwg
        eDe3zwlbhp3JJ1M/Rq/B+AKypHYVDgotwkKuxJI=
X-Google-Smtp-Source: ABdhPJykMQ94hRqiqc/JZgBD0wAY4bA21nkxhhZaZm6J0r0akz6WCIJCcGAoRrcR4Aphgnfg4vODwIe2AZOS4e6DQtE=
X-Received: by 2002:a5d:4141:: with SMTP id c1mr26897224wrq.248.1614758950368;
 Wed, 03 Mar 2021 00:09:10 -0800 (PST)
MIME-Version: 1.0
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <87k0qqx3be.fsf@toke.dk>
 <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com> <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
 <0121ca03-d806-8e50-aaac-0f97795d0fbe@intel.com> <cb975a27-ade5-a638-af6e-2e4e1024649c@iogearbox.net>
In-Reply-To: <cb975a27-ade5-a638-af6e-2e4e1024649c@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 3 Mar 2021 09:08:58 +0100
Message-ID: <CAJ+HfNjTFOB1JB9gcHfe9r5xkjoSFCqdLZvFBrfkh4GGH322iQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Will Deacon <will@kernel.org>, paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 at 10:25, Daniel Borkmann <daniel@iogearbox.net> wrote:
>

[...]

> > I wonder if it's possible to cook a LKMM litmus test for this...?
>
> That would be amazing! :-)
>

With the help of Paul and Alan [1] (Thanks!) I've cooked 8 litmus
tests for this [2].

The litmus tests is based on a one entry ring-buffer, and there are
two scenarios. The ring is full, i.e. the producer has written an
entry, so the consumer has to go first. The ring is empty, i.e. the
producer has to go first. There is one test for each permutation:
barrier only, acqrel only, acqrel+barrier, barrier+acqrel.

According to these tests the code in this series is correct. Now, for
the v2 some more wording/explanations are needed. Do you think I
should include the litmus tests in the patch, or just refer to them?
Paste parts of them into the cover?

> (Another option which can be done independently could be to update [0] wi=
th outlining a
>   pairing scenario as we have here describing the forward/backward compat=
ibility on the
>   barriers used, I think that would be quite useful as well.)
>
>    [0] Documentation/memory-barriers.txt
>

Yeah, I agree. There is some information on it though in the "SMP
BARRIER PAIRING" section:
--8<--
General barriers pair with each other, though they also pair with most
other types of barriers, albeit without multicopy atomicity.  An acquire
barrier pairs with a release barrier, but both may also pair with other
barriers, including of course general barriers.  A write barrier pairs
with a data dependency barrier, a control dependency, an acquire barrier,
a release barrier, a read barrier, or a general barrier.  Similarly a
read barrier, control dependency, or a data dependency barrier pairs
with a write barrier, an acquire barrier, a release barrier, or a
general barrier:
-->8--

And there's the tools/memory-model/Documentation/cheatsheet.txt.

That being said; In this case more is more. :-D


Bj=C3=B6rn

[1] https://lore.kernel.org/lkml/CAJ+HfNhxWFeKnn1aZw-YJmzpBuCaoeGkXXKn058Gh=
Y-6ZBDtZA@mail.gmail.com/
[2] https://github.com/bjoto/litmus-xsk/commit/0db0dc426a7e1248f83e21f10f9e=
840f970f4cb7

> >> Would also be great to get Will's ACK on that when you have a v2. :)
> >
> > Yup! :-)
> >
> >
> > Bj=C3=B6rn
> >
> >
> >> Thanks,
> >> Daniel
> >>
> >>> [1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-tru=
ck/
>
