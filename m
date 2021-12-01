Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC1C4647E4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347233AbhLAH0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347217AbhLAH0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:26:48 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDCBC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 23:23:26 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so33857680otv.9
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 23:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SG8XA2avZm/GA955rI4GIMcPdWXfXkaTHUNAB6yceTY=;
        b=bxKKPcUCPFS06e3fHkZEYFBCTinkxd6oCy4onccwDdFEPNHW3VYasLOMyvdiR+57nz
         CsiS4kfrZH43ceUcSuRNEMqjQzR5QiOHN+vjxWN1z75qNR/vHz1WzzCY4JgM+YQGRU92
         PY9JYKe6LH/BsMaL7mnVslUl5jRSYpiNPQRGi4A0xWkG6zfRdhW2QbL0l7dR2v34cOS2
         B2X19whVeXzKt7bqK3b46hAshYN46gMDf+USRpQPu5KFSHvTAsWfYq03NeXQYh0JZk5f
         jMKg0YuNRJYMobvG0TsL/WVCnpnKXMXRGw+qJ+Ldaqs8RSEHMQuN+Guh6CnNfpP5WWpR
         0Zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SG8XA2avZm/GA955rI4GIMcPdWXfXkaTHUNAB6yceTY=;
        b=AjfB5St7Eyx/KpCpCESkz0YzDSVoXgnocXoBesfH8pHMqmIaAjqNl5QztiGjuDIQkE
         jR4GMdFj9Qi83LArdMYOmUBA610XZtNOiuAqVRR/nvq4eFa1x5OU6Vhp93YY1RWF496g
         1a0Xlm81T7HxQNYTO1GIOhec6y4LTv6Fk4AbdqBFiZlPvTDUq00xU2E1gQs7tidOtYdD
         2K5YMRx6Sio43cuvt4byAho5ubnVcGcK0LfsxemXci4pQ9tX3ZXD6WgRqAEfjhTcZyEJ
         kPcpnq3748rIkvtrfHVL4WFrnsInZM9HdNy5dTQSNd9MEdByYaX3+a5jWBnIlPw1APTc
         gghA==
X-Gm-Message-State: AOAM5325wUqd8Rm5+fIycOHBdXk0fX39XHy7q5nVeyDx2wGOvDgnL7gl
        rPItVUmppctF8eyiDJecVYiJsgaJ7E3/Nf5lgfpkwmYP6J4=
X-Google-Smtp-Source: ABdhPJzauz3q76jxBJZQtIh2uaeIrI7AWNEVHSXCm9Cb1UzuUnpqWfwEJxcIj2e0BoNXNFhVs6Jv82JV/A9Exw2z6pk=
X-Received: by 2002:a05:6830:1356:: with SMTP id r22mr4153595otq.196.1638343405454;
 Tue, 30 Nov 2021 23:23:25 -0800 (PST)
MIME-Version: 1.0
References: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
 <20211130090952.4089393-1-dvyukov@google.com> <CANn89iLnk+cfKcBk-6oQhiKDYg=mYaYrp-S=k0M5WJCkgHm+bw@mail.gmail.com>
In-Reply-To: <CANn89iLnk+cfKcBk-6oQhiKDYg=mYaYrp-S=k0M5WJCkgHm+bw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 1 Dec 2021 08:23:14 +0100
Message-ID: <CACT4Y+Z21Z8wXgMd=DhyL6TViSVVA4mbSXeAsR1qbKLY9HrfcQ@mail.gmail.com>
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
To:     Eric Dumazet <edumazet@google.com>
Cc:     eric.dumazet@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 at 16:08, Eric Dumazet <edumazet@google.com> wrote:
> > Hi Eric, Jakub,
> >
> > How strongly do you want to make this work w/o KASAN?
> > I am asking because KASAN will already memorize alloc/free stacks for every
> > heap object (+ pids + 2 aux stacks with kasan_record_aux_stack()).
> > So basically we just need to alloc struct list_head and won't need
> > quarantine/quarantine_avail in ref_tracker_dir.
> > If there are some refcount bugs, it may be due to a previous use-after-free,
> > so debugging a refcount bug w/o KASAN may be waste of time.
> >
>
> No strong opinion, we could have the quarantine stuff enabled only if
> KASAN is not compiled in.
> I was trying to make something that could be used even in a production
> environment, for seldom modified refcounts.
> As this tracking is optional, we do not have to use it in very small
> sections of code, where the inc/dec are happening in obviously correct
> and not long living pairs.

If it won't be used on very frequent paths, then it probably does not
matter much for syzbot as well. And additional ifdefs are not worth
it. Then try to go with your current version.
