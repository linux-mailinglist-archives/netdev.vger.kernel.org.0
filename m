Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F73822D4FA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 06:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgGYEle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 00:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGYEle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 00:41:34 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB5CC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:41:34 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id s21so8898327ilk.5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+KaSAnmFAVflTjG4KCw6AusO/76jZrhJ7w9w32dL6g=;
        b=FJgDIAsbRwejDtpRqfvcvDB89fqkDw5L37b3Hlo/hyCimj4Aa7TqkKmGBlXTNZCfis
         DsJ8PxPigVsScRkrcV71ZEnqMAjBlD/VFC2VAcRLV6fa7efxkou+q7jeAI25iAFwlppg
         pEsEGCgg/NjOZ8tLJOzFAk1TCfhBc54iGVJGW+txA1qGio13QJrcv73NKHuVeohPKiGY
         FSh/SlQ9gEiHbXuVwzE1s637Zgd7ADTudPn7owdOHGAp3kUNxzE2aDb8CypnOnnSTErd
         SL1gQ63yRxsfKsr7A8vwDrndHEciszevDUagiwMKK5MlXogO0i5OFGp2im3wz4WPLVf+
         VNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+KaSAnmFAVflTjG4KCw6AusO/76jZrhJ7w9w32dL6g=;
        b=AdAjynK/DdBTDDofSp/XhGnLrpXVdESskNHBLa2un4iTfO92IZFdym9YYjek+nfHaK
         ug/nadFZrlA4Qo8Tf+d4//LTn1hUn5UKInSE9BZbrts+ASnyM4nNI3VGw3Ff4DzZcGnx
         UM7YP32PFdVxAdm6iGjvZ4LtTS0V3Z6xmzqw6Ml74pN3RGLC/Ck/g2ySnw6OIQPLyojs
         +0rOpseKDg2VGdxLkTKFXxpe8Cgnc0tbStBsvqlcj8oCqAVXbRugYjE4zQd0l3wWHSEC
         ZVuDj92dVNt3GXnkTPNpwgipdNa2chgrQHuyymtAnDMN/DxcAzIhjD0d6VYHtj9aMS/D
         gPXw==
X-Gm-Message-State: AOAM532mubj1GD+toajzIgQryCRDkIcf0Qd2wFF33/tAHGWkAEFUDnx0
        V7nTV7L6MRraXhrdRbs9AfvUZU529PL4m/ywCA0=
X-Google-Smtp-Source: ABdhPJwO+6DppEV/bJW5i0rA3Eq2+D+jli1vtW0T+GDu/1xrpmTm1IHS39JTA2Sta3p46/1VDM5EOiclHLnNh9TbdfI=
X-Received: by 2002:a92:bb84:: with SMTP id x4mr13816976ilk.177.1595652093564;
 Fri, 24 Jul 2020 21:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <CALHRZupy+YDXjK6VsAJhat0d8+0Wv+SB2p4dFRPVA69+ypC1=Q@mail.gmail.com>
 <20200723.121345.1943051054532406842.davem@davemloft.net> <CALHRZupBXQqOzWhNH=qDH7w1cNLYrEWLTwt368sBJt4FiJTBWQ@mail.gmail.com>
 <20200724.201037.91669607453014965.davem@davemloft.net>
In-Reply-To: <20200724.201037.91669607453014965.davem@davemloft.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sat, 25 Jul 2020 10:11:22 +0530
Message-ID: <CALHRZuq1fqrGfuyoEuXhddeJ_u07mgBnUTmjixkW_2btrtZGHQ@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Sat, Jul 25, 2020 at 8:40 AM David Miller <davem@davemloft.net> wrote:
>
> From: sundeep subbaraya <sundeep.lkml@gmail.com>
> Date: Fri, 24 Jul 2020 08:40:44 +0530
>
> > On Fri, Jul 24, 2020 at 12:43 AM David Miller <davem@davemloft.net> wrote:
> >>
> >> If you leave interrupts on then an interrupt can arrive after the software
> >> state has been released by unregister_netdev.
> >>
> >> Sounds like you need to resolve this some other way.
> >
> > Only mailbox interrupts can arrive after unregister_netdev since
> > otx2_stop disables
> > the packet I/O and its interrupts as the first step.
> > And mbox interrupts are turned off after unregister_neetdev.
> > unregister_netdev(netdev);
> > otx2vf_disable_mbox_intr(vf);
>
> Please explain this in your commit message.
>
> Thank you.
Sure will change the commit message.

Thanks,
Sundeep
