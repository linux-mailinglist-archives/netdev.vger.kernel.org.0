Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B182D3485
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgLHUuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgLHUuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:50:19 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D028C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 12:49:39 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c12so7974584pfo.10
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 12:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jr5TbI8HYFwbffKncqlY5UNCHEL5YE2Romm/MiB43E4=;
        b=Q4QOcUY/eEC8NQSJ3fiZ8z6vdeHab3UshCuplwY8grQMyFIJ26udVRKL9wsKz6nlWT
         mHvnAbvfUJB7D45nTBoVuh8ixurZs+6o5PG1EvC2KZd4GYxUREExASnyfJkcv/5DDN0a
         oVRFV3Pc9BGVyRwre4mLNaXQ/eXv7sZPFpOg5cICHrz6o0fW4JIgiymkm7eTHlaoYFld
         W+ZB2HI8NAUN6th3lmGNiTrsIkpba4DfPSdlLMMfnO+MtzT+7N5MZm5dHAdI6yWQsUbk
         jefYl79jU52Ux53E9Czy8mjXqIxJr4kAFhbuoVlIbsRPrCgwHyDgtCieaCkcN/EdmUTn
         nsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jr5TbI8HYFwbffKncqlY5UNCHEL5YE2Romm/MiB43E4=;
        b=bMTMdMFoFtLgzzGUeKZaBg0tbRkYHGTVW15gkPpEfjygJanDYE9kgC7LoJLVzKmeBP
         9m5KGOezGCX4feI1f4RUhBElJ2Qxk68LdZhffryoguCUpYcMH6ZhlEQ435VHGvC9iAOq
         yAYI+5a+5vRjMv28aNC94NCG8AjYaccxphpRHfSd717oNXU1YLX4+b2Kaifzg3X/CLFl
         U3wLZyYQFbLQs80hiBO+lYLiUpgsAmykeWkzpMZVhj9P2CncQulPeGo7m7BVkJ5rkRIy
         zMv1QvQ33Y10bfk/W5UeSTNgfsoESpieeJQPhz7quoK82V33JwEXbiSrz0FHyLxW2U7B
         iudA==
X-Gm-Message-State: AOAM532AvwfrtJCtrv02jbwww0Kk9/DkEgy8NFPId6Rgv+bdQwg5tsf6
        yCnWdHCdOVc5yBlh3IJ8Y2GPJ1c06RUoeXxjm4Mnx1nwJfb6bA==
X-Google-Smtp-Source: ABdhPJy1CWn96u4UKHcPL2QTNn5QYoHsculrvJ14fmUx65LDthnUc/UbC+NiZb6GRml8OvPeMmPC6Yu127KDYBRw91A=
X-Received: by 2002:a67:e43:: with SMTP id 64mr17753493vso.40.1607452937345;
 Tue, 08 Dec 2020 10:42:17 -0800 (PST)
MIME-Version: 1.0
References: <20201205152814.7867-1-TheSven73@gmail.com> <CAGngYiXdJ=oLe+A034wGL_rjtjSnEw7DhSJ3sE7M9PAAjkZMTQ@mail.gmail.com>
 <20201208085216.790ecdc3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208085216.790ecdc3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 13:42:06 -0500
Message-ID: <CAGngYiXAnoQaRpr0aZ=E51W=Os+N8-UyYM4rZXK9Pf7mC-ZeUQ@mail.gmail.com>
Subject: Re: [PATCH net v1 1/2] net: dsa: microchip: fix devicetree parsing of
 cpu node
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev <netdev@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 11:52 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> What I was talking about in the email yesterday was 0x8794 support
> in ksz8795.c. Is the cpu port configuration going to work there?
> Isn't the CPU port always port 5 (index 4)?

Understood. You expressed concern that .cpu_ports = 0x10 even on the 3-port
switch.

I noticed that .cpu_ports is never used in ksz8794.c, so I hoped the fix
would be fine. But digging a bit deeper, I see in ksz8795.c:

        dev->mib_port_cnt = TOTAL_PORT_NUM; /* = 5 */
        ...
        dev->cpu_port = dev->mib_port_cnt - 1; /* = 4 */

And that is unlikely to work on the 3-port switch.
So yeah, you are right, my patch won't fix the general issues here :(
