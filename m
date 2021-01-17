Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134592F9544
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 21:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbhAQU4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 15:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbhAQU4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 15:56:37 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC0AC061574
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 12:55:56 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id h1so6628619qvy.12
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 12:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZSg0GhfcuabgGcYekJuSH33gLk5HSnvLg8cbpP7Pdo=;
        b=X3uJ+sHaPl4Wdx8DlR+KFoR+KgehxkTYqS7mrwC/sVvC0ugm9FAFsHXHUj1iRGC91p
         gSkXXTa5xmY/2H612p6WSv+iiKA1mSF/mTMg0ESdUJ+0fK796E2Xdd6JlJaO1ZMYOrwc
         OIlhSfLhMFVbbaneJaWE5VPLcWPBvqspEKhzlHnhx4s6eNxzUNAomLaO/SAFWHGenMV0
         rpGNhmNXtbRD8kZAgpiMSnJOdHiKZ8fpuLYSG0mV660PHyD5zaH+PmOYiI6y9VwNJEOV
         3eXQRDsEaRAvxqiFUcB9RrqLFz9mlfi2rFWzOKezABCeyo5Kk+bHyTFkfFZ7QG687U/g
         xlaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZSg0GhfcuabgGcYekJuSH33gLk5HSnvLg8cbpP7Pdo=;
        b=UmxestyGpzmje/pi/K6Y7jR0ACa+zDraEDdcei/k3SLkyOUkUTQjVgzUfzZr3PPQQr
         HH7tPKgoaP3HEhdtZLSIcCaXQK1PZyHr/RbruyJxJdIBkIUw9zeG1xOHaqdbwFUbTkui
         IyT7JA8mhzZxZtZwAZKSv1RDuwpCEceaXqKfz+eFoSTeKTutkc/Y5vvR8oZBdrKjPDc6
         zS5Nszx06mZGwcLJ7ooyoudF0tZFLmyr7/cdtT3yoM4J0UoLdEdWIALGeG9JnMooHWfG
         NhCMqN474F3zdG5N3mgFW4BSV8niNnh++Vw/R+1i9SQvC6IJ8TdRJcMoKhXSYE2K6lOz
         +o7g==
X-Gm-Message-State: AOAM532baiAI4ZNVSLGEU48tXSzMngaw3/dJYOKAu38X+qutrh8C6VqU
        ECLfki0lx/QVu1B5s9p3O5GM/9MTnxaaQhYnN7U=
X-Google-Smtp-Source: ABdhPJwJtxQHs0fpBheB92qrE58/ckNzaEPjjgYGqAV/TcisLhKxuveyzAiCqIJdVwweDA6rWvhXKE/1V/taorqQQq8=
X-Received: by 2002:a0c:bf12:: with SMTP id m18mr21288684qvi.40.1610916956176;
 Sun, 17 Jan 2021 12:55:56 -0800 (PST)
MIME-Version: 1.0
References: <20210110070021.26822-1-pbshelar@fb.com> <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se> <YARW4DN9qxOZ7b25@nataraja>
In-Reply-To: <YARW4DN9qxOZ7b25@nataraja>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 17 Jan 2021 12:55:45 -0800
Message-ID: <CAOrHB_BQ1e5eV6qCNmHcQ7UPcrOuBwJC+hLpQ6sxa6+FUO9=Kw@mail.gmail.com>
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Jonas Bonn <jonas@norrbonn.se>, Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 7:31 AM Harald Welte <laforge@gnumonks.org> wrote:
>
> Hi Jonas, Jakub and others,
>
> On Sun, Jan 17, 2021 at 02:23:52PM +0100, Jonas Bonn wrote:
> > This patch hasn't received any ACK's from either the maintainers or anyone
> > else providing review.  The following issues remain unaddressed after
> > review:
>
> [...]
>
> Full ACK from my point of view.  The patch is so massive that I
> as the original co-author and co-maintainer of the GTP kernel module
> have problems understanding what it is doing at all.  Furthermore,
> I am actually wondering if there is any commonality between the existing
> use cases and whatever the modified gtp.ko is trying to achieve.  Up to
> the point on whether or not it makes sense to have both functionalities
> in the same driver/module at all
>

This is not modifying existing functionality. This patch is adding LWT
tunneling API. Existing functionality remains the same. Let me know if
you find any regression. I can fix it.
LWT is a well known method to implement scalable tunneling which most
of the tunneling modules (GENEVE, GRE, VxLAN etc..) in linux kernel
already supports.

If we separate out gtp.ko. from its LWT implementation, we will need
to duplicate a bunch of existing code as well as code that Jonas is
adding to improve performance using UDP tunnel offloading APIs. I
don't think that is the right approach. Existing tunneling modules
also use the unified module approach to implement traditional and LWT
based tunnel devices.


> > I'm not sure what the hurry is to get this patch into mainline.  Large and
> > complicated patches like this take time to review; please revert this and
> > allow that process to happen.
>
> Also acknowledged and supported from my side.
>
> --
> - Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
> ============================================================================
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. A6)
