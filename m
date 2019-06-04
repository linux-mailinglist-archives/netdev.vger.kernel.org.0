Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8020834ED8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfFDRb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:31:56 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37287 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFDRbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:31:55 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so14747319qtk.4;
        Tue, 04 Jun 2019 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zJnxPdRpWzmfxe+qO01hEsUxQR7B5VRieYI9l4HL0hw=;
        b=hbMub1XJvDBbCsoaH5KGDyqmUp0NR3GUNFvjfKmiimwldwmhrwoVtUqLQORruNrCmj
         w7JQKn7W7ixQNXN24entIwk5XtPP7mgzd5t844lJlydgzaHER7Unhzgw2gUWBO2Xomca
         pxyRb1tyWBbBYfYr1aTYYTJEa+wi1Fc1pMHrcX72HVDJ4fiUvEuEgD5WYJfli5UGIRlT
         xbZkPEqd3bGe1gyHaMUcqr6R4rouKnNHbNDyTeDS6HvqDkmwkypdc+D6IusNkORAn4vH
         OximtY/+EWz+n0hFoopcx1bkYasUbBI3unnemUTJrrdTRNppU5etYGg4B6BZTn91V3uA
         MKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zJnxPdRpWzmfxe+qO01hEsUxQR7B5VRieYI9l4HL0hw=;
        b=PZGD1t++o4DItoFsOG9J3IcGfBC6pHAZcN0YA1V9wsvBbtVhp48H9iohDM7bkjsdjJ
         VrKq/1MKtzzmdG+OnkqGChln8sZtW4qzAaSqEPE53AKSXfAhmrVtMp+UYHGCg02HEtcd
         rNUnudWPLXrY/RVrQzPjRdsITdzS6ORjVvl1707Mv8bJhdwU4ovdtr99iQkhPcUrzpgj
         +8ib3PHcKMhAWVfjyzErdXcufIno5Bd7Sbhj0cLzHJFZWoXBuC4by0UthBiyKfrLMcgX
         BKDczU4PF2CQsFTTmZ21eaG7XRQdJ9NIRFjgMmP24N0C6QrMnJKEVTU2NlN8i4PXZdZF
         MwYw==
X-Gm-Message-State: APjAAAUOVqb0V2vrc01/z9pQanTQBy/Z4Fv0zSrCeoh9fczuVDAMqXwd
        CUuegnlRXUpkntyDjM3Y/kVJlB2fp5saVIWfrfg=
X-Google-Smtp-Source: APXvYqziBQFDSNppDpSZ8bhQsWAypHLSo8gVVWnQaey1o3FGVoP6XxBi/WCBV0JdNcpTyToP+rrVd+CFD1MCAxWuO78=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr12395203qty.59.1559669514650;
 Tue, 04 Jun 2019 10:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch> <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch> <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch> <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
In-Reply-To: <20190604134538.GB2014@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Jun 2019 10:31:43 -0700
Message-ID: <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 6:45 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/03, Stanislav Fomichev wrote:
> > > BTF is mandatory for _any_ new feature.
> > If something is easy to support without asking everyone to upgrade to
> > a bleeding edge llvm, why not do it?
> > So much for backwards compatibility and flexibility.
> >
> > > It's for introspection and debuggability in the first place.
> > > Good debugging is not optional.
> > Once llvm 8+ is everywhere, sure, but we are not there yet (I'm talking
> > about upstream LTS distros like ubuntu/redhat).
> But putting this aside, one thing that I didn't see addressed in the
> cover letter is: what is the main motivation for the series?
> Is it to support iproute2 map definitions (so cilium can switch to libbpf)?

In general, the motivation is to arrive at a way to support
declaratively defining maps in such a way, that:
- captures type information (for debuggability/introspection) in
coherent and hard-to-screw-up way;
- allows to support missing useful features w/ good syntax (e.g.,
natural map-in-map case vs current completely manual non-declarative
way for libbpf);
- ultimately allow iproute2 to use libbpf as unified loader (and thus
the need to support its existing features, like
BPF_MAP_TYPE_PROG_ARRAY initialization, pinning, map-in-map);

The only missing feature that can be supported reasonably with
bpf_map_def is pinning (as it's just another int field), but all the
other use cases requires awkward approach of matching arbitrary IDs,
which feels like a bad way forward.


> If that's the case, maybe explicitly focus on that? Once we have
> proof-of-concept working for iproute2 mode, we can extend it to everything.
