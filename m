Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E8045E72B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 06:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345310AbhKZF0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 00:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358520AbhKZFYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 00:24:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EC0C0613E0
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 21:21:36 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u1so15994637wru.13
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 21:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Atv/3U1+8IQAfgHxI5YrZUWfArDjINQMM2qPepOrPno=;
        b=q2kE7o3Xb5eaq74BbjD6Qbn/bh99ZBPriuETC7fTcnciQEnPtNcsxInG58wiVfenbp
         fhMdeBa2lYb43/ew6N5Pcyo/L6XMcPa3abapeVLr2Yj1tFYkpT4hRrqYVo9peD04749J
         u0WG73xRIQBZH69Eq2hk3ITsHJQGW4VxKYuvxeeCRy5O5z6+Do76MUyNfg+zKm5aQD4+
         RbQ7D0usafuFaToTFVuFzjOo2WNnsopFrmEV/vN+fzMLJStHGs6zvlB/pX35TGHUydfV
         Ncv9+KkeNyX0usKiXcg6BYLK939hu8t8JczUzurmJKg7bE7ocTWzbxOzt8q/FOcuYjnW
         z2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Atv/3U1+8IQAfgHxI5YrZUWfArDjINQMM2qPepOrPno=;
        b=yKVOjMYwwBTKdKkxEf0oy0BKfGxG3s4aFECATcp9VUhvlKoNvDRFMKu1+U/DBavnN3
         16Qrr5ydBuLYdI5bC5o1CbJEijvG957mNus5sV560yt4DxTQ9OCpMUs3QXI7FSJZiduo
         Cd+M4EW+s1fwRq0sX6H8fq3OF1ycPRWe0zEBRWau4dZfQI79D4goHb6SU3iW1LukJdh1
         TA3pr4NVydDGxl/pllVZn/qyjyKkGhro/KZDUDkAIQgXinyG27/dGpfEJmxatcAXeNz3
         TpLfVXVrt9ql0lxHqGwuB/tSIigh+I8KZtjr1KnpdoP/Be5nzZfsbPZb4Ou4W5elsH+P
         au/w==
X-Gm-Message-State: AOAM532Yu9pvwalNZsDiHK67Ilmb2Mx6PvE5OtyizlmcO/aXsqApZFuc
        HqEUE4D6Gpmbo+LgQ50/ZM/pUPK16B1kENYKq5wZbJ2nYuE=
X-Google-Smtp-Source: ABdhPJw8SzrTcthqBKPlNDfqDAwa0uh95Uo7kkOg1vJT5NDDDlKXO1H3qeq0z5EucMvE8hHVwgQ+XRK00ZI41isH8tg=
X-Received: by 2002:a5d:6691:: with SMTP id l17mr11489539wru.227.1637904095339;
 Thu, 25 Nov 2021 21:21:35 -0800 (PST)
MIME-Version: 1.0
References: <20211125021822.6236-1-radhac@marvell.com> <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
 <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
 <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY3PR18MB47374C791CA6CA0E3CB4C528C6639@BY3PR18MB4737.namprd18.prod.outlook.com>
 <CA+sq2CdrO-Zsf5zAj9UbAqVpKdbxeP+QoDAJ6dK2hwDmmuQQ8A@mail.gmail.com> <20211125205800.74e1b07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125205800.74e1b07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 26 Nov 2021 10:51:24 +0530
Message-ID: <CA+sq2Cc9E+vSusMd+zZtkN0UOE_vtL5jT7XjE5t9gyCRn0sA_Q@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP VF devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 10:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Nov 2021 09:44:10 +0530 Sunil Kovvuri wrote:
> > > Nope, I have not accepted that. I was just too lazy to send a revert
> > > after it was merged.
> >
> > What is the objection here ?
> > Is kernel netdev not supposed to be used with-in end-point ?
>
> Yes.

If you don't mind can you please write these rules somewhere and push
to kernel documentation.
So that we are clear on what restrictions kernel netdev imposes.

>
> > If customers want to use upstream kernel with-in endpoint and not
> > proprietary SDK, why to impose restrictions.
>
> Because our APIs and interfaces have associated semantics. That's
> the primary thing we care about upstream. You need to use or create
> standard interfaces, not come up with your own thing and retrofit it
> into one of the APIs. Not jam PTP configuration thru devlink params,
> or use netdevs to talk to your FW because its convenient. Trust me,
> you're not the first one to come up with this idea.
>

I see that you are just assuming how it's used and making comments.
In scenarios where OcteonTx2 is used as a offload card (DPU) or VRAN,
some of the pkts
will be sent to host for processing. This path is used to forward such
pkts to host and viceversa.
It's not for internal communication between host and firmware.

It's using the standard netdev interfaces, APIs and network stack
packet forwarding.
I don't understand what's wrong with this.

The devlink params are being used across drivers to do proprietary HW settings.
There is no PTP protocol or pkt related configuration that's being
jammed through in the other patch.

> Frankly if the octeontx2 team continues on its current path I think
> the driver should be removed. You bring no benefit to the community
> I don't see why we'd give you the time of day.

That's an unnecessary comment crossing the lines.

Thanks,
Sunil.
