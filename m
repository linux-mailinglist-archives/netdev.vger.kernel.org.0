Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03133230520
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgG1IRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:17:48 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36909 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgG1IRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 04:17:46 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1f508000;
        Tue, 28 Jul 2020 07:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=K4YAt33ilBR3hd1+7JojCPxtvSA=; b=nEjdWp
        cUQVj0KWRd87puFx0fk1HADPVt/5ckkL0vcSiVAoyePGSTncp+KafcroE0itJJAR
        hvCKOHIgNqwby+4I13HG5z9ibnxBmqHfVx+jKtrPfvHTnJrmPNg1WsagEKVyYT8s
        0wLLBcv/NIyWIJ2xwHqa/F7Ekuot/H5qUld6hDSAXP06OIRI6q+V7cdk8Ye2E95N
        oE2iYHJELOZGqN2H10I58K4qjsUNSGzPFklfgHdPIOfnKUBe2eF7SiuhT2DW4gmx
        Zlh/4Lwi80eH4MYYZz1R0kvQtczs/XnszWGNGZW6geww/y9D6tsJ0FqJg7QkrUqh
        r9lHeJJo9aIu1+DA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d27e76da (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 28 Jul 2020 07:54:16 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id a5so4613572ioa.13;
        Tue, 28 Jul 2020 01:17:41 -0700 (PDT)
X-Gm-Message-State: AOAM5326njdztPe3VkZjU3njFuLXGQOjJ86c1ItnwgBvIww26i5yBNmp
        mf7+bJPIr4+tDgdochtGaglyFVJWyqL1zhmrfeY=
X-Google-Smtp-Source: ABdhPJwruWEMSl6lI3SS18Iq/8cGmq7nVWSaRamLRaM9jzUJiajMF+UBN6XkUtAb0UlYhZIkk+zlhZ92oa7Pvf4Iz8s=
X-Received: by 2002:a05:6638:250f:: with SMTP id v15mr8210865jat.75.1595924260418;
 Tue, 28 Jul 2020 01:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-13-hch@lst.de>
 <20200727150310.GA1632472@zx2c4.com> <20200727150601.GA3447@lst.de>
 <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
 <20200727162357.GA8022@lst.de> <908ed73081cc42d58a5b01e0c97dbe47@AcuMS.aculab.com>
In-Reply-To: <908ed73081cc42d58a5b01e0c97dbe47@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 28 Jul 2020 10:17:28 +0200
X-Gmail-Original-Message-ID: <CAHmME9pUbRmJq1Qcj10eENt15cuQHkiXJNKrUDmmC18n2mLKDA@mail.gmail.com>
Message-ID: <CAHmME9pUbRmJq1Qcj10eENt15cuQHkiXJNKrUDmmC18n2mLKDA@mail.gmail.com>
Subject: Re: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
To:     David Laight <David.Laight@aculab.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 10:07 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Christoph Hellwig
> > Sent: 27 July 2020 17:24
> >
> > On Mon, Jul 27, 2020 at 06:16:32PM +0200, Jason A. Donenfeld wrote:
> > > Maybe sockptr_advance should have some safety checks and sometimes
> > > return -EFAULT? Or you should always use the implementation where
> > > being a kernel address is an explicit bit of sockptr_t, rather than
> > > being implicit?
> >
> > I already have a patch to use access_ok to check the whole range in
> > init_user_sockptr.
>
> That doesn't make (much) difference to the code paths that ignore
> the user-supplied length.
> OTOH doing the user/kernel check on the base address (not an
> incremented one) means that the correct copy function is always
> selected.

Right, I had the same reaction in reading this, but actually, his code
gets rid of the sockptr_advance stuff entirely and never mutates, so
even though my point about attacking those pointers was missed, the
code does the better thing now -- checking the base address and never
mutating the pointer. So I think we're good.

>
> Perhaps the functions should all be passed a 'const sockptr_t'.
> The typedef could be made 'const' - requiring non-const items
> explicitly use the union/struct itself.

I was thinking the same, but just by making the pointers inside the
struct const. However, making the whole struct const via the typedef
is a much better idea. That'd probably require changing the signature
of init_user_sockptr a bit, which would be fine, but indeed I think
this would be a very positive change.

Jason
