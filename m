Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10737ECC0A
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfKAXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:51:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35665 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAXvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:51:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id d13so8076580pfq.2
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 16:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BsKjEtMnmq6by4TFwLAU6qxNqp5eTX4GxFJxZD0moV8=;
        b=pScjkFVoiPme60pJx4mAVUsWuiaMXy04oWejEcmTT+awgA/fBHFC5lkkgorUZsomz3
         JocFxGNppmJmlO3kZq4oAZoVIx4uENe61YJgJ2vA5z4qcb7hvYpI/mw25Huq/N4IJCdl
         ugmoNMCvsm2BI+AZRsFrLn6lQhRP2t3IFLg64/Op+AT64nQHjkZUnroawseFKSSnQK+o
         +6jqvyzphvDRjzWYbgVOG3AKHurDCAdgdCEueFvTAaNG7BHLN6cP5f1lXPBtMgvZMpZw
         ClKoJS1Yr1XoLTrIiOMampDz8Za+kvmJ6tMtSDIxi+j/m347JYMthvSmNKpv5J7/krao
         iaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BsKjEtMnmq6by4TFwLAU6qxNqp5eTX4GxFJxZD0moV8=;
        b=FsDXMknck04JsBflUd2Y/WrtBrZZ7poHK2kMuBDSjAv2bDNDO/8Jwey+mugdizka6q
         ZGVdwmRbkTeBxM3FYXTBEu7ITx0T5rpOOWGWC50ddR3vyDnX0uDPkPjNKtxXuc+fuGvo
         irxp49DImIHkE429pP5jeeT/+GqnVnnc0FKmQqTwETSSz4nCWYB/g8FrsE84srVz3KGs
         Ov03l72GnoEjlopyCQxo210ron07c27fYiimwYRVbKamt8rdiV9K1AkuxCei1JzIeqdK
         boaIX1dXYRxSH0loqulO985wtL7PvL6YXUMlAA5Y5Ft7uFziCkO+EAJ5iig7F550+aeJ
         j2hQ==
X-Gm-Message-State: APjAAAXVaYaibd285oO6ayQoU39TReMcuLQhyjCY/RSspw485Lgjg4Bc
        hlev7HbJzCUIwLEjcEck+ecXqQVeWPmWS0ZUo1JEDKMx
X-Google-Smtp-Source: APXvYqwrYu1fLTJn/jVyHfEq2Et/ilBE20+tijXhnt8IQcLGGfQal+KWaexdrYayNiZ0JXv4ir+PiALins+ZSDNDyEM=
X-Received: by 2002:a17:90a:326b:: with SMTP id k98mr18656029pjb.50.1572652274835;
 Fri, 01 Nov 2019 16:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191101221605.32210-1-xiyou.wangcong@gmail.com>
 <CANn89iKS6fas9O74U5w1wb+8DN==fXRKQ8nzq0tkT_VOXRtYBQ@mail.gmail.com>
 <CAM_iQpUGAaV9hsP4Z7YoHD6rQuJDSP_WNk_-d97Uxyed2SsgrA@mail.gmail.com> <CANn89iLhmbhaJDhPtThh2Nt8BMp1tnAZjBwwMdsk0V=SmkMJmQ@mail.gmail.com>
In-Reply-To: <CANn89iLhmbhaJDhPtThh2Nt8BMp1tnAZjBwwMdsk0V=SmkMJmQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 1 Nov 2019 16:51:03 -0700
Message-ID: <CAM_iQpUs-qjs_X4iCGENb89hXNjnxK1-Bb+KWUzgYcmuqeGbPw@mail.gmail.com>
Subject: Re: [RFC Patch] tcp: make icsk_retransmit_timer pinned
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 4:44 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Nov 1, 2019 at 3:43 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> > So let's make the sysctl timer_migration disabled by default? It is
> > always how we want to trade off CPU power saving with latency.
>
> At least timer_migration sysctl deserves a proper documentation.
> I do not see any.
>
> And maybe automatically disable it for hosts with more than 64
> possible cpus would make sense,
> but that  is only a suggestion. I won't fight this battle.
>
> (All sysctls can be set by admins, we do not need to change the default)

Make people rely on the default value, as obviously not everyone
is able to revise all of the sysctl's.

Anyway, I read it as the patch makes TCP retransmit timer pinned
not interesting, therefore let's discard it. We can at least carry it
by ourselves, so not a big deal.

Thanks!
