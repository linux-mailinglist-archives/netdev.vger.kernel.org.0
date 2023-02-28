Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5EA6A527A
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjB1E4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjB1E4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:56:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E59241E8;
        Mon, 27 Feb 2023 20:56:51 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o12so34875061edb.9;
        Mon, 27 Feb 2023 20:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okmRvyXBxZ0o8pbO3WLuRK922SzNzOQvPgzOOLIl67E=;
        b=gSacQg7cDaOiW6jQCpRlFI10wyEfBq78p4/bhMVdXjdiA5bYHn09KjKUY19IaRQOoK
         Jk1re5nnDSOX3VfSfCUc37yo5MN+r9aWfQm63pKXchcSx0e2REhyK6fjF/hfdE9bXz3D
         6VHS+E43e8+nCP9ptO2xzW0pWUZ42q01IxMw1QygL5DSzN/nLt5Nx0LO7+m9bphhw6zO
         o5hE47+gdT/Oxrdz5V8JhRtD6mRrO933W8q1CLh8v+zT5V/vS59Di8xXOn9QRMREe+MY
         J0r2dGzq5O74iGvOdme5MZzbhbhieJaofrNJZlo0mNrgco1+cPZyvrcvWnEDzLVzsiM/
         FRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=okmRvyXBxZ0o8pbO3WLuRK922SzNzOQvPgzOOLIl67E=;
        b=zQSWuPlVNRY7A7K1OMV26LOA+v3P4oK72wnbYUk/v7wRgXszCly5q4QECvWmcVZNUQ
         nWWVrcijWYuet0drEbXiXkE4hpCicDs4ISl5v1BgZqaah6mwRxpmqT+MkzswJ0iLOhGf
         Nq6BFKNcXjThslJFTUQ79/tXuUh23S5c7EToC7zXj+Ek7jRTPJzIOoMJJw3y86JD2qH+
         vEEXCK1AE13dOX+R/3egArAQW7tdreUUVbZd8pP3D8ZgDiZSepNFlh2LNwlTsWOJjMoQ
         kU7Kpk2I4VbRWUHJIRJXsAYqPqDM33Fw7EfEFpPm7DCdzXFZfXbc5RQzsry4fnJOQPjF
         07+w==
X-Gm-Message-State: AO0yUKXWfKIQNC038xETu7kMb/Z1NMQ+v7wMxOkSgtJGUCpPk8h/cx0R
        qXcVyUURiIok9usoHAKjBWnEtu6aqGv35bIJz8Vs1q/1b5M=
X-Google-Smtp-Source: AK7set8gKY0GodjAmaFttAkUsYsfQgC1w7nWfqds+hu0p1TYhtkpsjEvbYRSk15cuQj4d3XVGPZqlZhuAjW5SFAtD1Y=
X-Received: by 2002:a17:906:a46:b0:895:58be:963 with SMTP id
 x6-20020a1709060a4600b0089558be0963mr576673ejf.3.1677560209655; Mon, 27 Feb
 2023 20:56:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1677526810.git.dxu@dxuuu.xyz> <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain>
In-Reply-To: <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 27 Feb 2023 20:56:38 -0800
Message-ID: <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in BPF
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 5:57=E2=80=AFPM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Hi Alexei,
>
> On Mon, Feb 27, 2023 at 03:03:38PM -0800, Alexei Starovoitov wrote:
> > On Mon, Feb 27, 2023 at 12:51:02PM -0700, Daniel Xu wrote:
> > > =3D=3D=3D Context =3D=3D=3D
> > >
> > > In the context of a middlebox, fragmented packets are tricky to handl=
e.
> > > The full 5-tuple of a packet is often only available in the first
> > > fragment which makes enforcing consistent policy difficult. There are
> > > really only two stateless options, neither of which are very nice:
> > >
> > > 1. Enforce policy on first fragment and accept all subsequent fragmen=
ts.
> > >    This works but may let in certain attacks or allow data exfiltrati=
on.
> > >
> > > 2. Enforce policy on first fragment and drop all subsequent fragments=
.
> > >    This does not really work b/c some protocols may rely on
> > >    fragmentation. For example, DNS may rely on oversized UDP packets =
for
> > >    large responses.
> > >
> > > So stateful tracking is the only sane option. RFC 8900 [0] calls this
> > > out as well in section 6.3:
> > >
> > >     Middleboxes [...] should process IP fragments in a manner that is
> > >     consistent with [RFC0791] and [RFC8200]. In many cases, middlebox=
es
> > >     must maintain state in order to achieve this goal.
> > >
> > > =3D=3D=3D BPF related bits =3D=3D=3D
> > >
> > > However, when policy is enforced through BPF, the prog is run before =
the
> > > kernel reassembles fragmented packets. This leaves BPF developers in =
a
> > > awkward place: implement reassembly (possibly poorly) or use a statel=
ess
> > > method as described above.
> > >
> > > Fortunately, the kernel has robust support for fragmented IP packets.
> > > This patchset wraps the existing defragmentation facilities in kfuncs=
 so
> > > that BPF progs running on middleboxes can reassemble fragmented packe=
ts
> > > before applying policy.
> > >
> > > =3D=3D=3D Patchset details =3D=3D=3D
> > >
> > > This patchset is (hopefully) relatively straightforward from BPF pers=
pective.
> > > One thing I'd like to call out is the skb_copy()ing of the prog skb. =
I
> > > did this to maintain the invariant that the ctx remains valid after p=
rog
> > > has run. This is relevant b/c ip_defrag() and ip_check_defrag() may
> > > consume the skb if the skb is a fragment.
> >
> > Instead of doing all that with extra skb copy can you hook bpf prog aft=
er
> > the networking stack already handled ip defrag?
> > What kind of middle box are you doing? Why does it have to run at TC la=
yer?
>
> Unless I'm missing something, the only other relevant hooks would be
> socket hooks, right?
>
> Unfortunately I don't think my use case can do that. We are running the
> kernel as a router, so no sockets are involved.

Are you using bpf_fib_lookup and populating kernel routing
table and doing everything on your own including neigh ?

Have you considered to skb redirect to another netdev that does ip defrag?
Like macvlan does it under some conditions. This can be generalized.

Recently Florian proposed to allow calling bpf progs from all existing
netfilter hooks.
You can pretend to local deliver and hook in NF_INET_LOCAL_IN ?
I feel it would be so much cleaner if stack does ip_defrag normally.
The general issue of skb ownership between bpf prog and defrag logic
isn't really solved with skb_copy. It's still an issue.
