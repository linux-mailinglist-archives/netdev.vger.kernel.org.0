Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A8F2F3AAD
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392731AbhALThB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392184AbhALThB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:37:01 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B8C061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:36:14 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id b24so3437284otj.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z0xpHqnhEg4+GaMGBLt3Oo+1ZadZ40ta8pdaA4tFiUo=;
        b=a/sVyzneRgmAV1M2KwWbIZ73omiabGOW6065TqCmJrCgTILnfs9MFu9D14d8tkHvev
         juoeMXcZVKmlR4ESX9vlCed/5uwmlccPhel/jiF9REY+tIqh19vrW0MEuCHVlUgZmiln
         J0cScNrajqbpSkVVKFTQR9JtyIw8/JZp6J2k0fdcbi7fcnl60cemYEkXz5cRe92Jk76M
         r2TcRF5UmVzM4K63lsJ2g1R8f9UoehY3q+sIiz49U6H7bgXbTUN4CZYpmaTagsQA78h9
         ok2xoT/Nx4nK6CvDf6nvNjM0MrfFOaJS6LEYbEnl5I5Z5v49HnI2czb2fQOnAIapT+3y
         UeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z0xpHqnhEg4+GaMGBLt3Oo+1ZadZ40ta8pdaA4tFiUo=;
        b=pVwV7C+bLu39nKx1LcGhy54ZquOzKA4Y1UTIEzB5nMGTWinCdWpr5odcK9RXJHwG7S
         bjjV2NmrQ2EOKltiCogwaTxd/KHpoDiC0qV4Vf8LqmmSXz2xdhNO/UkUFncsVYGTy6v1
         bOYuNtQ1YdabuzmprAiQCWmXMUnN8Frs6sKrTu3uIh0aBUM3U0bFY0wKt5uKPt5xEaYP
         QsIJF5UFzfpO4xsLgz7k6LXZOBxM1sHfx96PafU2cTcZiyTMlMx2U56BG5cFKIhnBObk
         ACTBWpIp/JU2yv/8cBg1nme4PX7Ujkclimy002Y1QT2M0PzSX37BCRo9wBGnMlgUsUuf
         uRbQ==
X-Gm-Message-State: AOAM5314EoOPOIGKAgUJdz/HoPkGOks+JYl1rOZ3ddltdC2p+5v8Xhf+
        67G1JGo1TIRefqedZwJO7ft/gkQj+BJFIWDFCbld5w==
X-Google-Smtp-Source: ABdhPJxdrbp5CYOMrURmc69IIi0QZspNQ2j7CjN4OgYatwRFJ894/gHPjAu+etM3hJlFfOZLsWq2c9PsxRvC0IpzkgI=
X-Received: by 2002:a9d:67c7:: with SMTP id c7mr680770otn.27.1610480174169;
 Tue, 12 Jan 2021 11:36:14 -0800 (PST)
MIME-Version: 1.0
References: <20210105122416.16492-1-yuri.benditovich@daynix.com> <CAF=yD-+UwgObscAq96Rc3zO=Ky8iquQrcx33StXPMkMw1ukSSw@mail.gmail.com>
In-Reply-To: <CAF=yD-+UwgObscAq96Rc3zO=Ky8iquQrcx33StXPMkMw1ukSSw@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 12 Jan 2021 21:36:01 +0200
Message-ID: <CAOEp5OcUr-STagfgXMYYgpbZo5C8wsc4oKiRb3rd0KFLjJVXjw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Yan Vugenfirer <yan@daynix.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for misunderstanding, I'll resend _all_ the patches to all the
maintainers and copy existing comments for further discussion

On Tue, Jan 5, 2021 at 7:21 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jan 5, 2021 at 8:12 AM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
> >
> > Existing TUN module is able to use provided "steering eBPF" to
> > calculate per-packet hash and derive the destination queue to
> > place the packet to. The eBPF uses mapped configuration data
> > containing a key for hash calculation and indirection table
> > with array of queues' indices.
> >
> > This series of patches adds support for virtio-net hash reporting
> > feature as defined in virtio specification. It extends the TUN module
> > and the "steering eBPF" as follows:
> >
> > Extended steering eBPF calculates the hash value and hash type, keeps
> > hash value in the skb->hash and returns index of destination virtqueue
> > and the type of the hash. TUN module keeps returned hash type in
> > (currently unused) field of the skb.
> > skb->__unused renamed to 'hash_report_type'.
> >
> > When TUN module is called later to allocate and fill the virtio-net
> > header and push it to destination virtqueue it populates the hash
> > and the hash type into virtio-net header.
> >
> > VHOST driver is made aware of respective virtio-net feature that
> > extends the virtio-net header to report the hash value and hash report
> > type.
> >
> > Yuri Benditovich (7):
> >   skbuff: define field for hash report type
> >   vhost: support for hash report virtio-net feature
> >   tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
> >   tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
> >   tun: add ioctl code TUNSETHASHPOPULATION
> >   tun: populate hash in virtio-net header when needed
> >   tun: report new tun feature IFF_HASH
>
> Patch 1/7 is missing.
>
> Skbuff fields are in short supply. I don't think we need to add one
> just for this narrow path entirely internal to the tun device.
>
> Instead, you could just run the flow_dissector in tun_put_user if the
> feature is negotiated. Indeed, the flow dissector seems more apt to me
> than BPF here. Note that the flow dissector internally can be
> overridden by a BPF program if the admin so chooses.
>
> This also hits on a deeper point with the choice of hash values, that
> I also noticed in my RFC patchset to implement the inverse [1][2]. It
> is much more detailed than skb->hash + skb->l4_hash currently offers,
> and that can be gotten for free from most hardware. In most practical
> cases, that information suffices. I added less specific fields
> VIRTIO_NET_HASH_REPORT_L4, VIRTIO_NET_HASH_REPORT_OTHER that work
> without explicit flow dissection. I understand that the existing
> fields are part of the standard. Just curious, what is their purpose
> beyond 4-tuple based flow hashing?
>
> [1] https://patchwork.kernel.org/project/netdevbpf/list/?series=406859&state=*
> [2] https://github.com/wdebruij/linux/commit/0f77febf22cd6ffc242a575807fa8382a26e511e
