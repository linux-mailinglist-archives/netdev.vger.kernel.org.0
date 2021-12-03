Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C868F4672B1
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350882AbhLCHnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 02:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350852AbhLCHnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 02:43:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5AEC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 23:39:48 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v11so3765139wrw.10
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 23:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eaevo7pi2ak/CI9ILvZnxO/c89nGvOIVsZxXThgQ/hU=;
        b=RZrJjgNJF2WcSycg6tM84V6fNwdCkf7KDEi08wtYiUmMAuy1M+uLgvkgrRtuXXQFGt
         QsCn4iAu9Sm0h5fMFJ7GHRa8e5XhybAw0sAHjtqDCEnrnS++O48yG4GJtmbgUDMBDou0
         eToI3g6KyEt0W0E9XPsYL0M1Ks/N92e7Py0HVCn0QtkIZi76oT74bDER2WHApzydrtdP
         pnLiaUkW11L0h80cdXV+WQJIOMDbLb9j4K7N5rUXO7NnVPvBBxyAc0bNuprAcpnTzBVq
         VaEbtSye8POlakf3GsIgon84MFn8uUxBVV2HgJsE3HxhU2l3KC0P+Al0BtY4GxhZ6wNn
         PJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eaevo7pi2ak/CI9ILvZnxO/c89nGvOIVsZxXThgQ/hU=;
        b=ZL4R0MJK0+x59ygFyjrQiea9Wbh+i9KhPdn3kaybnGYYiPAvZDvmwiVtgs/5UQ2qRE
         GjOtFTprd9yeDsnnQXKyk+BC0j8/ANHs8TocEHaVaOJCd5n67Zpgs7qXgeOiwa/XC3fa
         B7i1KyF83nCaCEqk7qwJKOVX3H4QDBO1jOQ4L20xQIGEG99OGiw/FjrTtLToYHOdjXb3
         r3FI7wFHcVcZv4PdgjmXe1Rsxz/7yFk0euQJXztlzduRhO4Cak8xpVCVZl4/uz69UlZl
         54Fz05ezS4hmAYZ1OCtcX4czwcnMUzh3JJb01YmRnYb8CGSQKRrwNg11bdX7y287fBx5
         xOhA==
X-Gm-Message-State: AOAM531bqS6JSepJUWKNBgY2OZvWhHyukTxwBEnQMmk7+F6iOr5SMGJx
        /PhhCi6hi6QHNKdCtcCzePMh2Bibx5xHa4B8nY0kbFnh
X-Google-Smtp-Source: ABdhPJxgirRZFhwWr7EXzlEJXB9qslwfd1FK2oavhrAU1fvekz/Ooe8hDbXfGCuEIjbqrNDzjbVTgJecLQuVd4WR2oc=
X-Received: by 2002:adf:8bd9:: with SMTP id w25mr19089154wra.519.1638517187296;
 Thu, 02 Dec 2021 23:39:47 -0800 (PST)
MIME-Version: 1.0
References: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
 <3DEFF398-F151-487E-A2F8-5AB593E4A21B@massar.ch> <CACS3ZpDLpxNStsS61MV_yadERP=PDLJovp44M7e7YSBkadyC8g@mail.gmail.com>
In-Reply-To: <CACS3ZpDLpxNStsS61MV_yadERP=PDLJovp44M7e7YSBkadyC8g@mail.gmail.com>
From:   Juhamatti Kuusisaari <juhamatk@gmail.com>
Date:   Fri, 3 Dec 2021 09:39:26 +0200
Message-ID: <CACS3ZpDi-=H9J=vVoqxqd7J=ftBCmKNpetzTyMOkH-N2L7C7hg@mail.gmail.com>
Subject: Re: IPv6 Router Advertisement Router Preference (RFC 4191) behavior issue
To:     Jeroen Massar <jeroen@massar.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 18 Nov 2021 at 15:12, Juhamatti Kuusisaari <juhamatk@gmail.com> wrote:
>
> On Thu, 18 Nov 2021 at 12:49, Jeroen Massar <jeroen@massar.ch> wrote:
> >
> >
> >
> > > On 20211118, at 11:35, Juhamatti Kuusisaari <juhamatk@gmail.com> wrote:
> > >
> > > Hello,
> > >
> > > I have been testing IPv6 Router Advertisement Default Router
> > > Preference on 5.1X and it seems it is not honoured by the Linux
> > > networking stack. Whenever a new default router preference with a
> > > higher or lower preference value is received, a new default gateway is
> > > added as an ECMP route in the routing table with equal weight. This is
> > > a bit surprising as RFC 4191 Sec. 3.2 mentions that the higher
> > > preference value should be preferred. This part seems to be missing
> > > from the Linux implementation.
> >
> > Do watch out that there are a couple of user space tools (yes, that thing) that think that they have to handle RAs.... and thus one might get conflicts about reasoning between the kernel doing it or that user space daemon thing.
>
> Thanks for the heads-up. AFAIK, I am not running anything extra in the
> user space of the receiving node.
>
> Here are some more details:
>
> 1) RA with pref medium is received over enp0s8 from router X at
> fe80::a00:27ff:fe90:5a8a:
> ::1 dev lo proto kernel metric 256 pref medium
> fe80::/64 dev enp0s8 proto kernel metric 256 pref medium
> fe80::/64 dev enp0s3 proto kernel metric 256 pref medium
> default via fe80::a00:27ff:fe90:5a8a dev enp0s8 proto ra metric 1024
> expires 273sec pref medium
>
> 2) RA with pref high is received over enp0s8 from router Y at
> fe80::ffff:a00:275e:85ca:
> ::1 dev lo proto kernel metric 256 pref medium
> fe80::/64 dev enp0s8 proto kernel metric 256 pref medium
> fe80::/64 dev enp0s3 proto kernel metric 256 pref medium
> default proto ra metric 1024 expires 276sec pref medium
>         nexthop via fe80::a00:27ff:fe90:5a8a dev enp0s8 weight 1
>         nexthop via fe80::ffff:a00:275e:85ca dev enp0s8 weight 1
>
> i.e. the default ends up as an ECMP configuration. I would have
> expected it to change to a high preference route via
> fe80::ffff:a00:275e:85ca only.

The above behaviour does not quite match the code - and indeed, a
userspace tool did take over RAs by default. I disabled it and the
kernel behaviour looks like this:

::1 dev lo proto kernel metric 256 pref medium
fe80::/64 dev enp0s8 proto kernel metric 256 pref medium
fe80::/64 dev enp0s3 proto kernel metric 256 pref medium
default via fe80::a00:27ff:fe5e:85ca dev enp0s8 proto ra metric 1024
expires 261sec pref medium
default via fe80::ffff:a00:275e:85ca dev enp0s8 proto ra metric 1024
expires 261sec pref high

To be sure, I verified from ND-kernel logs that this really goes to the kernel.

It still does not look quite right to me. I would have expected, based
on the RFC 4191, that only high pref default is there or that it has
priority by other means. AFAICT, now the routing takes the default
that happens to match the lookup first. Without router preference this
is fine.

Thanks,
--
 Juhamatti
