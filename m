Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2674D27E293
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 09:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgI3H1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 03:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgI3H1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 03:27:13 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AD8C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 00:27:12 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c2so478599qkf.10
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 00:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tkcbfirt6lOr/xu+zEVH3EdEDPye2U06vImmpvkSJlo=;
        b=HPKZDL7cCxBF3pQBzZdSbz8LtnkTdMbU5yewGA9iEGkrzWERgIjXOCOLAQP89nwBSl
         EAkL/J+coYtbKyUqsCuVST+Vs7WXdsuCr4zV500KB+6vqrc6g6VVhrp0zmU9VAGlycKX
         GvobJY+/B0XVFatvaCbJp9JYgOIb+1/PiZDDKSV4QboOliUrgsICy7QRhpZQYe8EBooc
         NYKnuuGSSi1/IG/0uZNvj8CG0NtGeOo+su87NSBbRs/df4OEXvfJqW7fHCfBNMioNdVN
         QPY3cnhR4bx89r62C/7P5kkRJLljQGCCm4cWbQBoQv/YAcNXYVQdbIdgLGykpyQM+bat
         GrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tkcbfirt6lOr/xu+zEVH3EdEDPye2U06vImmpvkSJlo=;
        b=t/c0Rg8Lq4iqYbzawyOoxm35VlZIWnFAx8R/bIZiHs09oLcVpTyeSjYNkbF6kzuGO7
         UhQZAx1Kprm6LxYAU7iFY867DAKGlUoj/zPfopA98BhRio0oJix0+OwugMgMezKL+faA
         +wh243eHctvroi1q8ofWP1PiLQExIPNBEFWP1EbbmQ0HAdMsEemkJQcApUW5Ipx3s9sl
         RwgdJGmbwIXJP/X5pzi3oTLL2xTGrAqYQSVm/KJm4XILCWiB+9zSLj/Y0edHfSwmx4n8
         pc0a7Qksc9EYDUxLzVHhZ99Llmfgv1Z3WYspU8RgvKHg4/70udRksxyrTY3jTkvaYRWE
         AXew==
X-Gm-Message-State: AOAM530hbE7hNblMx0DWHtTwM7sRzNTgMhalUnaT/ADwFXzQhULtnuwr
        w107OWnFi+iFv+2iKwz+bhwg4Fg44GZmap+hGCdctA==
X-Google-Smtp-Source: ABdhPJyokJozgeex+KombyrHqLIWdBjNiz+o9gEvlB8/83Yp0XDsBIuKRBju6TshVVpZXyEfp4dM8k5BiHXcSBNgCPk=
X-Received: by 2002:a37:a4c5:: with SMTP id n188mr1330469qke.8.1601450831240;
 Wed, 30 Sep 2020 00:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007d5ec805b04c5fc8@google.com> <20200928171137.16804-1-hdanton@sina.com>
 <87mu19kaup.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87mu19kaup.fsf@nanos.tec.linutronix.de>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 30 Sep 2020 09:26:59 +0200
Message-ID: <CACT4Y+YMTiR5bKKEV2vfSfrqSjoGjjsfWfhreBsNdxQ+yDpS2g@mail.gmail.com>
Subject: Re: WARNING in hrtimer_forward
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, hchunhui@mail.ustc.edu.cn,
        Julian Anastasov <ja@ssi.bg>, James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 8:36 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, Sep 29 2020 at 01:11, Hillf Danton wrote:
> > On Mon, 28 Sep 2020 18:13:42 +0200 Thomas Gleixner wrote:
> >> So the timer was armed at some point and then the expiry which does the
> >> forward races with the ioctl which starts the timer. Lack of
> >> serialization or such ...
> >
> > To make syzbot happy, s/hrtimer_is_queued/hrtimer_active/ can close
> > that race but this warning looks benign.
>
> Why only make sysbot happy? It's clearly an issue and the warning is not
> benign simply because forwarding a queued timer is an absolute NONO.
> timers (both timer_list and hrtimer) need external synchronization.

Oh, Thomas, it's so nice to hear this interpretation of things among
all the cases where people only fixing tools and making them happy :)
Don't make my tools happy! They don't need that! :)
