Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF580229E06
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732076AbgGVRJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVRJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:09:55 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCACC0619DC;
        Wed, 22 Jul 2020 10:09:54 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so3257561ljg.13;
        Wed, 22 Jul 2020 10:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqelWpCqH7nOe0oSyngzrBNpGRC3PyDyz91JHpls3Xk=;
        b=QbFOpYWq197fvdaI4E7hogiJ5z6DhlnMwFbSAyObyOYxQk/ojAWvAxU5xeCwIzRoyp
         bGpv6okHRbaDCk3F5IJgGXS3Wesi1t0HKLxD0rWbntKFa+o4FEuZ/aNqddB2gT9rJhFi
         ekTLt46VwAAqYYSOS+Ti6gpiM2sULyDbPlDxrV2EC1wYfvYmkCiCMfUA2sia4+eUOZSm
         DpKqJKTrsnJtuquGnG9/42hXesw1S5DhQmqbpijEy6OLbaHF8RyBbV+paN+wC914K+DB
         Om2JyFGEZL8bVoXG7xFZFOn3b/hxnJAALpQKOVax/+9YzLSzmIzDLinAT6/sMjMDDXxC
         pBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqelWpCqH7nOe0oSyngzrBNpGRC3PyDyz91JHpls3Xk=;
        b=k3wIByikShOaLkMc1Od1tLGwmab7hG9iKbyDULD2uOU+twM7jxZwJn7IWxMKu4MHdb
         2Um8GRz1pnUx6Or1zrBKsXK1VsWCVoqGK+g00uoLdXwN0ZIjQs2SY1NcE1kAF8LDVTbU
         yec/VCQcloskNDtE/ZzYq3LleNJ4xRU3nJ3wI0s/geljdUP2TUb94FrsAN6b/v2V85qz
         Jc8CdA/0064dg3bpth9PgXEMbwg5daPhBpS5N9zJpR/T9aF3Yn/Utf8++olez5sBFyLk
         PhS8JcXdC8vjOKTUaUQOoc6YRUqpWtVVYj0gjyhYOFPmkN984ejeamHM/Bn02+cBPon8
         gMPw==
X-Gm-Message-State: AOAM531Eo1Acr/3nE2b3iA/QDxbQGbfSLq/pJjtA4rrQ+YuHqM+38kBs
        PxMKDcJqZcbVcOCj/Ts6eT4QBe1XJMs+YgpX9dqBNA==
X-Google-Smtp-Source: ABdhPJzXtI3YBeORsJYQmEu28fVJCUtGV7rd5sI5b8tsC3G9617tl0t2hP5zU+hEdegWolMtC+F/64n4emjrett5jt8=
X-Received: by 2002:a2e:90da:: with SMTP id o26mr95292ljg.91.1595437793253;
 Wed, 22 Jul 2020 10:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200720124737.118617-1-hch@lst.de> <20200720204756.iengwcguikj2yrxt@ast-mbp.dhcp.thefacebook.com>
 <20200722075657.GB26554@lst.de>
In-Reply-To: <20200722075657.GB26554@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jul 2020 10:09:41 -0700
Message-ID: <CAADnVQKy0+rsRftEzp4PvxQtj7uOwybz0Nd4_h0FR37p2Q=X4w@mail.gmail.com>
Subject: Re: get rid of the address_space override in setsockopt
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>, mptcp@lists.01.org,
        lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 12:56 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jul 20, 2020 at 01:47:56PM -0700, Alexei Starovoitov wrote:
> > > a kernel pointer.  This is something that works for most common sockopts
> > > (and is something that the ePBF support relies on), but unfortunately
> > > in various corner cases we either don't use the passed in length, or in
> > > one case actually copy data back from setsockopt, so we unfortunately
> > > can't just always do the copy in the highlevel code, which would have
> > > been much nicer.
> >
> > could you rebase on bpf-next tree and we can route it this way then?
> > we'll also test the whole thing before applying.
>
> The bpf-next tree is missing all my previous setsockopt cleanups, so
> there series won't apply.

Right. I've realized that after sending that email two days ago.
Now bpf-next->net-next PR is pending and as soon as it's merged
bpf-next will have all the recent bits.
