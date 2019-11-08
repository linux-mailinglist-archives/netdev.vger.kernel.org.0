Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC39FF5343
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfKHSJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:09:41 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40510 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfKHSJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:09:41 -0500
Received: by mail-oi1-f193.google.com with SMTP id 22so6036137oip.7;
        Fri, 08 Nov 2019 10:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRCVyyl/YnI1yfjpVYJBvX64WaEBRDLl4gl0UviBlJ0=;
        b=PHNBDlcdlf4kTBH6jGPgnrs0BChmOlR4TL/vbG01xnN1UcBsA6smHWEujTioj2AV+r
         PnNKYvzPsBdIbE5dfi6NcYDJnHQQ7VuhYrO9LvI5hQRlm9UdfjUZIAs7UZ+dlWmGgsNP
         xRy+BZFbLjMW2dQP0J6vyS3UyWlO8y6hwEp52yfKhnxu4qD9GsKZDtS8FOJBWJGF1sQ9
         lE/i5NE2Ichik0No1SdhBL5O8zQgYWLLDu3S2d1nrvjGFFB8t/DTrJOqYq8oFmVqqriO
         xcRSp1KgmfK8lmkMgdRN4pN+UFoqB8seDX44fULG0rBnWTDidIAA6H4mUSCJtpfdASfA
         hZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRCVyyl/YnI1yfjpVYJBvX64WaEBRDLl4gl0UviBlJ0=;
        b=NL7dY8Qi0eWC004yeO6fD7Fb7BX81o5CUI+PnwVseVC06cL0Q6kANUGSKEdNkBOZqO
         iRar7XVB0nVvTtpL0iZCqn6C15LRBlPruCXK2VZoQZE7mZUtGkR8q5WbA4UwVHEyry+x
         xAuuTNruwXXghJLWEqlbaeQn6kN1UxxbV+tevm1Zazi+tGA18yG9D47GTBazR3xZyPsR
         nFktfkjK5rbrFarFJi3FTgYwyKi6ENSWk9Ep69typZdEYHgXsYnE7dC9gMSjU44TE6GS
         5WSvSYeLx4Yd8Url03ImeVucxuyQVHdux4YI4jaKTzJsluMzEp8FEzLefLngBNPMeZO0
         xLDA==
X-Gm-Message-State: APjAAAXK84VPLWsM4anfeO5NbuMcAjC9JNyn8KtbvkqNK/iRdb8m2apx
        JEBQjkrNKsC6uFEOl4n+LhK1+GTN87idMzWkiMW3Lqa3
X-Google-Smtp-Source: APXvYqyjW9//dwO1wrlaGFSUDCBgp2bYwFRPMrrOmcWYCVG5KtkxNqQ8Asxw4v2yfgXz5q8kFVZKb+XDzGlyjNk8NHA=
X-Received: by 2002:aca:c753:: with SMTP id x80mr10262051oif.115.1573236578319;
 Fri, 08 Nov 2019 10:09:38 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com> <20191108145738.GC36440@gmail.com>
In-Reply-To: <20191108145738.GC36440@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 8 Nov 2019 19:09:27 +0100
Message-ID: <CAJ8uoz2oNHtyBaHtKJv-37oKRZykAtC3Q_ok8CmvO7RmdJoTNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] Extend libbpf to support shared umems and
 Rx|Tx-only sockets
To:     William Tu <u9012063@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 3:58 PM William Tu <u9012063@gmail.com> wrote:
>
> On Thu, Nov 07, 2019 at 06:47:35PM +0100, Magnus Karlsson wrote:
> > This patch set extends libbpf and the xdpsock sample program to
> > demonstrate the shared umem mode (XDP_SHARED_UMEM) as well as Rx-only
> > and Tx-only sockets. This in order for users to have an example to use
> > as a blue print and also so that these modes will be exercised more
> > frequently.
> >
> > Note that the user needs to supply an XDP program with the
> > XDP_SHARED_UMEM mode that distributes the packets over the sockets
> > according to some policy. There is an example supplied with the
> > xdpsock program, but there is no default one in libbpf similarly to
> > when XDP_SHARED_UMEM is not used. The reason for this is that I felt
> > that supplying one that would work for all users in this mode is
> > futile. There are just tons of ways to distribute packets, so whatever
> > I come up with and build into libbpf would be wrong in most cases.
> >
> Hi Magnus,
>
> Thanks for the patch.
> I look at the sample code and it's sharing a umem among multiple queues in
> the same netdev. Is it possible to shared one umem across multiple netdevs?

It should be possible to register the same umem area multiple times
(wasting memory in the current implementation though). I have not
tried this though, so I might be surprised. You really have to make
sure that you only give a buffer (through the Tx or fill rings) to a
single device. If you do not, your packets will be garbled. But this
needs some testing first and some extension to libbpf to make it
simple. I can try it out, but this will be another patch set.

/Magnus

> For example in OVS, one might create multiple tap/veth devices (using skb-mode
> or native-mode). And I want to save memory by having just one shared umem for
> these devices.
>
> Thanks
> --William
>
> > This patch has been applied against commit 30ee348c1267 ("Merge branch 'bpf-libbpf-fixes'")
> >
> > Structure of the patch set:
> >
> > Patch 1: Adds shared umem support to libbpf
> > Patch 2: Shared umem support and example XPD program added to xdpsock sample
> > Patch 3: Adds Rx-only and Tx-only support to libbpf
> > Patch 4: Uses Rx-only sockets for rxdrop and Tx-only sockets for txpush in
> >          the xdpsock sample
> > Patch 5: Add documentation entries for these two features
> >
> > Thanks: Magnus
> >
> > Magnus Karlsson (5):
> >   libbpf: support XDP_SHARED_UMEM with external XDP program
> >   samples/bpf: add XDP_SHARED_UMEM support to xdpsock
> >   libbpf: allow for creating Rx or Tx only AF_XDP sockets
> >   samples/bpf: use Rx-only and Tx-only sockets in xdpsock
> >   xsk: extend documentation for Rx|Tx-only sockets and shared umems
> >
> >  Documentation/networking/af_xdp.rst |  28 +++++--
> >  samples/bpf/Makefile                |   1 +
> >  samples/bpf/xdpsock.h               |  11 +++
> >  samples/bpf/xdpsock_kern.c          |  24 ++++++
> >  samples/bpf/xdpsock_user.c          | 158 ++++++++++++++++++++++++++----------
> >  tools/lib/bpf/xsk.c                 |  32 +++++---
> >  6 files changed, 195 insertions(+), 59 deletions(-)
> >  create mode 100644 samples/bpf/xdpsock.h
> >  create mode 100644 samples/bpf/xdpsock_kern.c
> >
> > --
> > 2.7.4
