Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD0A323BC
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 17:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFBPsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 11:48:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39284 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfFBPsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 11:48:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so6799374qta.6
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5Vd3QgYbMnZDq0qs1LIhXZomAfSEjJrxGQTGnAXEVEc=;
        b=pKMD1f4ivZnrRpVcKlqfuSml89GTDgW3O7/X88vOl2HaeHDPZZ9oFXwTOJCnVta77z
         PS4zOWNUK/BtXqfnVRYSdAg4fMIbavvSC2uZzLvviE3BxCIAvEbusOGRZXI9F6Em8In5
         Tx8VvO3NlSp4RAjxPgEkzNYTHPlD8k+vCrxnAB/3i/E0/7ImlHv6hXgUWDmeGj6jvaz0
         arx8oTf/aDHTLgjFjbXodRzSugIrUsqvxAQJY5rmXqCPcwqSarjG3EHYaRLw9pD3w2N1
         SZMGNIyioEkXlZ6NSasnROqq2zwYZ7hpvipI/V/xUtylqfy3uo6pzAorzlFB5ucD8g0R
         dO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5Vd3QgYbMnZDq0qs1LIhXZomAfSEjJrxGQTGnAXEVEc=;
        b=FrVNYqyV7Bc9w5uCn6plrgd4WfKVeLErAuuFh2NFUM/yDdqX253QHROqNufrbPwyqZ
         SPm1NC4EbzmpS/miYzc4fYy9AfqYhRklk7BY9ie/C8WC/hvgBa3buMVXld/brPeqHW5C
         ZMN8kE8Pgx3ZAziypPklw/Pf9Vb6J92pUnOzyaDr7/isqujRWUZqSpzKTItWTLlzVuut
         yyx05gjuGobFUwCy9OctQV/Vljm8Ptprunj8s9Vpmmeju3xUQH01IXBneFmQlg73YZR9
         rCnCnO3rnUyNuR74tIFSna63yCVO5JFGxHTgQSNOC3j4GaVVf62Z/nI8XDzKOb/LvT8k
         G6fg==
X-Gm-Message-State: APjAAAVCplpQ5/YRHiSzP0fxWpbVSv0VV42lmIB9PlOPQjA1qmItao0X
        YpuaP2o+Dgl8yB9i3tRblT5lq6zEdbRADIiv0vWupA==
X-Google-Smtp-Source: APXvYqzuipIsIEbL99F0DO9HCjyvndDZYejBxVb4ikdchkuICKwenJIqWlXoZGLxXcsGhAzxK/zXNPJFSKS0Qo6YTSg=
X-Received: by 2002:aed:3e99:: with SMTP id n25mr19507624qtf.277.1559490502449;
 Sun, 02 Jun 2019 08:48:22 -0700 (PDT)
MIME-Version: 1.0
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
 <1559321320-9444-7-git-send-email-tom@quantonium.net> <20190531190704.07285053cb9a1d193f7b061d@gmail.com>
 <CALx6S34m31vQQoy6-Esf9N3nYBUhQPMubPC3tXqT6RQbKzkhCQ@mail.gmail.com> <20190602115430.a726f7dd2a2f5b873d4a0537@gmail.com>
In-Reply-To: <20190602115430.a726f7dd2a2f5b873d4a0537@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sun, 2 Jun 2019 08:48:11 -0700
Message-ID: <CALx6S377W7g=hE1SO1Q72FNhKc7VyqA9+d5ExW2xh1iKhXtNvw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] seg6: Add support to rearrange SRH for AH ICV calculation
To:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dlebrun@google.com, Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 2, 2019 at 2:54 AM Ahmed Abdelsalam <ahabdels.dev@gmail.com> wr=
ote:
>
> On Fri, 31 May 2019 10:34:03 -0700
> Tom Herbert <tom@herbertland.com> wrote:
>
> > On Fri, May 31, 2019 at 10:07 AM Ahmed Abdelsalam
> > <ahabdels.dev@gmail.com> wrote:
> > >
> > > On Fri, 31 May 2019 09:48:40 -0700
> > > Tom Herbert <tom@herbertland.com> wrote:
> > >
> > > > Mutable fields related to segment routing are: destination address,
> > > > segments left, and modifiable TLVs (those whose high order bit is s=
et).
> > > >
> > > > Add support to rearrange a segment routing (type 4) routing header =
to
> > > > handle these mutability requirements. This is described in
> > > > draft-herbert-ipv6-srh-ah-00.
> > >
> > > Hi Tom,
> > > Assuming that IETF process needs to be fixed, then, IMO, should not b=
e on the cost of breaking the kernel process here.
> >
> > Ahmed,
> >
> > I do not see how this is any way breaking the kernel process. The
> > kernel is beholden to the needs of users provide a robust and secure
> > implementations, not to some baroque IETF or other SDO processes. When
> > those are in conflict, the needs of our users should prevail.
> >
> > > Let us add to the kernel things that have been reviewed and reached s=
ome consensus.
> >
> > By that argument, segment routing should never have been added to the
> > kernel since consensus has not be reached on it yet or at least
> > portions of it. In fact, if you look at this patch set, most of the
> > changes are actually bug fixes to bring the implementation into
> > conformance with a later version of the draft. For instance, there was
> > never consensus reached on the HMAC flag; now it's gone and we need to
> > remove it from the implementation.
> >
> > > For new features that still need to be reviewed we can have them outs=
ide the kernel tree for community to use.
> > > This way the community does not get blocked by IETF process but also =
keep the kernel tree stable.
> >
> > In any case, that does not address the issue of a user using both
> > segment routing and authentication which leads to adverse behaviors.
> > AFAICT, the kernel does not prevent this today. So I ask again: what
> > is your alternative to address this?
> >
> > Thanks,
> > Tom
>
> Tom,
> Yes, the needs for users should prevail. But it=E2=80=99s not Tom or Ahme=
d alone who should define users needs.
> The comparison between "draft-herbert-ipv6-srh-ah-00" and "draft-ietf-6ma=
n-segment-routing-header" is
> missing some facts. The first patch of the SRH implementation was submitt=
ed to the kernel two years after
> releasing the SRH draft. By this time, the draft was a working group adop=
ted and co-authored by several
> vendors, operators and academia. Please refer to the first SRH patch subm=
itted to the kernel
> (https://patchwork.ozlabs.org/patch/663176/). I still don=E2=80=99t see t=
he point of rushing to upstream something
> that has been defined couple of days ago. Plus there is nothing that prev=
ents anyone to "innovate" in his
> own private kernel tree.

Ahmed,

While you seem to think that was just defined and came out the blue a
few days ago, in fact this has been in discussion for many months. The
simultaneous use of segment routing and authentication header was not
defined-- but it is defined for other routing types and extension
headers. The primary drivers of segment routing (the academics,
operators, and vendors you refer to) were reluctant to do this. For
the most part, these are mostly routing vendors who don't care about
preserving end-to-end host functionality like AH. In order to define
an interoperable protocol, the mutability of fields needs to be
defined. They were unwilling to commit to defining what is mutable in
their protocol, and it took an intervening action of the working group
chairs to force them to clarify the requirements so now we have
something.

IMO, this is straightforward bug fix. If you want to say that we need
to wait for IETF to take action, okay, but then I strongly suggest
that you actively participate in the process (i.e. send to 6man list
what you think about the draft), as opposed to just passively
deferring to it and assuming others will do the right thing.

Tom

>
> --
> Ahmed Abdelsalam <ahabdels.dev@gmail.com>
