Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5506A140F84
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAQRAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:00:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50990 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgAQRAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:00:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so8158027wmb.0
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 09:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fltjnEVwo0kQEcyO6RTVSPdJKBa6lt4GakQHOqsiDbk=;
        b=vBMoUqBIXKuywfmw6Lw3aSTbNK6QtNuj37GSTtpOp+OAJ0gdNHJIzSuKUP5d0cRiot
         9Q4YMBz37Eowk6IRMILhS/a7RclgmLB/KWLwk/iJCKZeVjiqj/udQLDSpCc2NuDW25jr
         y/wRINVEu5TRiU054SliH0NR8t/qdDhOWvvrfDmOkQm9GuJCBnus/0Mvz6ySjbAdJbtw
         ZX6AVdEtQ5b7RPcLIgu6Y2unjLlOng7GP5x2yz1gmtYshMEfFLyA1sKSxlOqs442EyUB
         tEg+2RtYQ3+kYReIWOBU9GkBblOqs6DYv56FizKggsaeBiN4JIaNqQCeQrNkHVsIrKIF
         J1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fltjnEVwo0kQEcyO6RTVSPdJKBa6lt4GakQHOqsiDbk=;
        b=Aqe49i2J6qNJapDsXciz7Phb+hiQubV1le4rLbnjIa4fwPcdgygw7tXP3+EccKkA5/
         qmh1n5qF7VXOftoLvMaCDXWvVNgsxcg4Ia1WH8ZQs/SpQS1bZPZ8dfrpWBrkprfMxKfT
         DOK2W0XPX0kCHGvKLyzl6EvW+L4PtvxID6IXisokk/kqPfQdC0AISR+pGGEMtqv0ap43
         dI1bXCMbtsAcuzOl3ybNX33KIkZsM4FXE/APqyHQy0LYpTdvCs/woiWqOs2ORwWwFUcC
         JH1cZg2tY19haSiPurqwTC2Sj5fZqkFjXOQmA2g5ssOF0tCZtKKGLnhdTSLEwHz92Jmg
         CFuA==
X-Gm-Message-State: APjAAAXZK8dYt6Q3oslfcjIBHdLaOvJjRT8pc1V/K8QTdjHtgPRgcjWM
        RwKf+2I9NIweriyalWkud535I/FilvZIaK36E+0=
X-Google-Smtp-Source: APXvYqzm8bZ7al4uwF1KhIwyNQNuuR/LndtA6jMXXTPdlUhrbKYDWLbaNNbLwjaQCUTeltG8dUy45O9kKaVeY2wQdrI=
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr5824128wmk.50.1579280411257;
 Fri, 17 Jan 2020 09:00:11 -0800 (PST)
MIME-Version: 1.0
References: <20200117100921.31966-1-gautamramk@gmail.com> <20200117100921.31966-2-gautamramk@gmail.com>
 <87v9paoz4g.fsf@toke.dk>
In-Reply-To: <87v9paoz4g.fsf@toke.dk>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Fri, 17 Jan 2020 22:29:34 +0530
Message-ID: <CAHv+uoF82nKrFLRKdP+fCVkc9Kay2dBRZz3hXJoRQWy6c387Tg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: sched: pie: refactor code
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 9:26 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> gautamramk@gmail.com writes:
>
> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> >
> > This patch is a precursor for the addition of the Flow Queue Proportion=
al
> > Integral Controller Enhanced (FQ-PIE) qdisc. The patch removes structur=
es
> > and small inline functions common to both PIE and FQ-PIE and moves it t=
o
> > the header file include/net/pie.h. It also exports symbols from sch_pie=
.c
> > that are to be reused in sch_fq_pie.c.
>
> The way this is done means that sch_fq_pie.ko will end up with a module
> dependency on sch_pie.ko, right?

Yes, we did make sch_fq_pie.ko dependent on sch_pie.ko in this series.
We thought of doing this when we started out, but later on decided to
follow something similar to the codel - fq_codel implementation.

> I don't think we have any such
> dependencies already; not *necessarily* a blocker, but it does strike me
> as a bit odd.

Yes, no existing qdiscs have dependencies, except for sch_atm and
sch_ingress.

Leslie
