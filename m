Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61F21894CF
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgCREQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:16:59 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43002 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgCREQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:16:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id q19so25362447ljp.9
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 21:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JuN42Jl34OqmuzRrt/KM0snV9jVeBWBUZ/2SFy1kcHg=;
        b=PRZm6CyVY/8MkGgsJXibdSjbhTYrHX+vCjcXYjXKxCLmdiAgk+HNiEq2RhXl1JA+SW
         xv/X1USezPp6gBG80Anw/o1z6FooXHGefq4TDCKSWKnen0KxvN2QpwxQ3In2WLVpbGMw
         shk2KiivML1w40+ALT6E/ZCY0v55ZENoaHlTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JuN42Jl34OqmuzRrt/KM0snV9jVeBWBUZ/2SFy1kcHg=;
        b=Ve7J8YDw2Iq5iHHLPSuRV43gENF6/2Hgg+xHBGT7SuvV+vFTnJC1hQ+JDVi1IyKdkT
         REXWSO3eeq0G6kih49QT3As3+sOU8bIwNyHYcCXLYZR3lOmUlLCcLlghd900Lp+v/ehF
         xlH3nyoP4xWbivBnzLBCqEAfFcgRPiMzhQJe1D76A/gHmlm1Og8+TIQIO/qwdyYngBEt
         /cU+M3gwINe8bn3C+GEFHaoYD5+HXLs7oR9EOGVJ1r54o1EGvdKpOkvdQ2iCP+EJUjH2
         p/KObi23ZzbERDBS0r/VMiUOGjz7LNspjt/4YWuofUQvPBlmSHjNI/J1TZsrsXEwAOPk
         K5ew==
X-Gm-Message-State: ANhLgQ3L68SOytxqGAxEvJbw8cD4N/aPyMGAKa1ktpL18w9mkdzfVYgp
        XDkxXLxyQ4aE5SXV1AZnAoRvYAhKGd6VexyjhXiGyg==
X-Google-Smtp-Source: ADFU+vto4MLVRXFExCejuWxdKi3IlyyQRDXE2/p35zPhX5ayz/443e3yl6uPlyOIxiKwIdQKLJgrKwBGaafo2opYyR8=
X-Received: by 2002:a2e:145d:: with SMTP id 29mr421088lju.281.1584505017706;
 Tue, 17 Mar 2020 21:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1584458082-29207-6-git-send-email-vasundhara-v.volam@broadcom.com> <20200317104745.41ad47d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317104745.41ad47d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 18 Mar 2020 09:46:46 +0530
Message-ID: <CAACQVJrSv+sB6=TT_6G6nzDA4F6xppQnSb2wMm-z=0k+wucA3w@mail.gmail.com>
Subject: Re: [PATCH net-next 05/11] bnxt_en: Add hw addr and multihost base hw
 addr to devlink info_get cb.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 11:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Mar 2020 20:44:42 +0530 Vasundhara Volam wrote:
> > In most of the scenarios, device serial number is not supported. So
> > MAC address is used for proper asset tracking by cloud customers. In
> > case of multihost NICs, base MAC address is unique for entire NIC and
> > this can be used for asset tracking. Add the multihost base MAC address
> > and interface MAC address information to info_get command.
> >
> > Also update bnxt.rst documentation file.
> >
> > Example display:
> >
> > $ devlink dev info pci/0000:3b:00.1
> > pci/0000:3b:00.1:
> >   driver bnxt_en
> >   serial_number B0-26-28-FF-FE-C8-85-20
> >   versions:
> >       fixed:
> >         asic.id 1750
> >         asic.rev 1
> >       running:
> >         drv.spec 1.10.1.12
> >         hw.addr b0:26:28:c8:85:21
> >         hw.mh_base_addr b0:26:28:c8:85:20
> >         fw 216.0.286.0
> >         fw.psid 0.0.6
> >         fw.app 216.0.251.0
> >
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>
> Nack.
>
> Make a proper serial number for the device, the point of common
> Linux interfaces is to abstract differences between vendors. You
> basically say "Broadcom is special, we will use our own identifier".
I thought only couple of vendors support multi-host NICs, so made this
macro as vendor specific. If it will be widely used, I will make it a generic
macro.

>
> Also how is this a running version if it's supposed to be used for
> asset management.
My mistake, will fix it to fixed version.

Thanks,
Vasundhara
