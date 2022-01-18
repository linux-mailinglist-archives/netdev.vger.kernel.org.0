Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E21491F9D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 07:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbiARG6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 01:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiARG6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 01:58:49 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485FFC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 22:58:49 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id kl12so20517785qvb.5
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 22:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=springboard-inc-jp.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ovyjk6kLkhKjQRhTwpyh4aXPNdLUNnaUdXTChCM6Hr8=;
        b=MiV5LiQTDujmSOg2fBUE0Buget4dGlIudSjhyGgMfC7umbPimdNQyGJO7REr09J74q
         lHcCObg/UyxXPnSdhwxp8+KSC8J7GzcB8zaQZtIhqCnaIpoUw1L7AevuHSNZRpSaOI6q
         sXKppInqh0r3YRqP0zTzTLmzAZFBOG0ceMUFkHYoWEsCOHNiUZ6/hOxOckJM/A1J19oS
         qnX42RbQrWrlTnaHZMiABFuWsclNO1ORv/c+xyCs3AyOBiLRt6JbnzFJe8PniuffO3Nz
         ptCf7bzZ/lFdDU5IUUUaFxzX8PCHxXg06dSMcmw9U7jSSQd6MD7K3caiPpbso0WVEhXe
         r5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ovyjk6kLkhKjQRhTwpyh4aXPNdLUNnaUdXTChCM6Hr8=;
        b=aStoX601uYHNilVgLM3HOVepGci2bpK3+HZcKw+3l7Y0DjkiBgoL7mF+qjK0xw8pAZ
         EP/g3oFfJ0fRmkN7aDM3eozz7jS74XiiLRKJH5N6UB2q/01bnufFpVry00YyRMlcQwXn
         765Oczu9zV8/2Rog3S7+6YnmWeApJed7aQ8YddBeQXNU8QI4HKTXtVUZz5rVk8kf3rMJ
         Dxd+xB4ohRA/pWbZK5+9m1wCIUUVnC6mXOwfRbNZP/Us0Uk8jTMAmxLJxKKxgS8ufNA+
         hxL7ph6nSaKe934frDR24kD6UlHoQlUYkVScwULe1/mCucqeRNnz4Q9Mor8iv7opvzKZ
         dtmg==
X-Gm-Message-State: AOAM531zb/Ym3sMzFWyEPLCpwcNnBmpuQX46i3pejJXOY7MLx/WtEmSu
        LyA5+Cz4b10r+D7ZIPKEDoTvO7927K3AGQEu88ZVNsYibmiC
X-Google-Smtp-Source: ABdhPJzGAded00e0D3R37vOIALUyJuaRuqCfkZWEe3RmarIVzA8qDBB5ICoB6GK6xXscG5FM/NPupYncT9ZoFlhGbio=
X-Received: by 2002:ad4:5aa5:: with SMTP id u5mr21770152qvg.88.1642489128367;
 Mon, 17 Jan 2022 22:58:48 -0800 (PST)
MIME-Version: 1.0
References: <20211130073929.376942-1-bjorn@mork.no> <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk> <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
 <d4533eb7-97c1-5eb1-011d-60b59ff7ccbb@gmail.com> <YeV8BwzyXuuvxvBN@shell.armlinux.org.uk>
 <d027e5cc-f6a4-4a1b-066d-10c298472c3a@gmail.com>
In-Reply-To: <d027e5cc-f6a4-4a1b-066d-10c298472c3a@gmail.com>
From:   =?UTF-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Date:   Tue, 18 Jan 2022 15:58:37 +0900
Message-ID: <CAOZT0pWv_bt8EKhHjHt7dz5H5gdD4XrFaN3UF9jkzaM5+ebyqA@mail.gmail.com>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag mode
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To whom it may concern

Thank you for summarizing the process.
I am sorry for the inconvenience caused by my poor English.

My patch was incomplete, and Russell made it better.
I have checked Russell's fix on real hardware and it works correctly.
I was also aware that Bj=C3=B8rn had taken over the rest of the merging
work, leaving me as the reporter.

If there is anything else I should be doing, please let me know.

Thanks

2022=E5=B9=B41=E6=9C=8817=E6=97=A5(=E6=9C=88) 23:49 Christian Lamparter <ch=
unkeey@gmail.com>:
>
> On 17/01/2022 15:24, Russell King (Oracle) wrote:
> > On Sat, Jan 15, 2022 at 05:58:43PM +0100, Christian Lamparter wrote:
> >> On 03/12/2021 13:58, Russell King (Oracle) wrote:
> >>> On Fri, Dec 03, 2021 at 11:54:57AM +0000, Russell King (Oracle) wrote=
:
> >>> [...]
> >>> Thinking a little more, how about this:
> >>>
> >>>    drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
> >>>    1 file changed, 21 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> >>> index 51a1da50c608..4c900d063b19 100644
> >>> --- a/drivers/net/phy/sfp.c
> >>> +++ b/drivers/net/phy/sfp.c
> >>> @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *s=
fp)
> >>>    static int sfp_module_parse_power(struct sfp *sfp)
> >>>    {
> >>>     u32 power_mW =3D 1000;
> >>> +   bool supports_a2;
> >>>     if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
> >>>             power_mW =3D 1500;
> >>>     if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVE=
L))
> >>>             power_mW =3D 2000;
> >>> +   supports_a2 =3D sfp->id.ext.sff8472_compliance !=3D
> >>> +                           SFP_SFF8472_COMPLIANCE_NONE ||
> >>> +                 sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> >>> +
> >>>     if (power_mW > sfp->max_power_mW) {
> >>>             /* Module power specification exceeds the allowed maximum=
. */
> >>> -           if (sfp->id.ext.sff8472_compliance =3D=3D
> >>> -                   SFP_SFF8472_COMPLIANCE_NONE &&
> >>> -               !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> >>> +           if (!supports_a2) {
> >>>                     /* The module appears not to implement bus addres=
s
> >>>                      * 0xa2, so assume that the module powers up in t=
he
> >>>                      * indicated mode.
> >>> @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp =
*sfp)
> >>>             }
> >>>     }
> >>> +   if (power_mW <=3D 1000) {
> >>> +           /* Modules below 1W do not require a power change sequenc=
e */
> >>> +           return 0;
> >>> +   }
> >>> +
> >>> +   if (!supports_a2) {
> >>> +           /* The module power level is below the host maximum and t=
he
> >>> +            * module appears not to implement bus address 0xa2, so a=
ssume
> >>> +            * that the module powers up in the indicated mode.
> >>> +            */
> >>> +           return 0;
> >>> +   }
> >>> +
> >>>     /* If the module requires a higher power mode, but also requires
> >>>      * an address change sequence, warn the user that the module may
> >>>      * not be functional.
> >>>      */
> >>> -   if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000=
) {
> >>> +   if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
> >>>             dev_warn(sfp->dev,
> >>>                      "Address Change Sequence not supported but modul=
e requires %u.%uW, module may not be functional\n",
> >>>                      power_mW / 1000, (power_mW / 100) % 10);
> >>>
> >>
> >> The reporter has problems reaching you. But from what I can tell in hi=
s reply to his
> >> OpenWrt Github PR:
> >> <https://github.com/openwrt/openwrt/pull/4802#issuecomment-1013439827>
> >>
> >> your approach is working perfectly. Could you spin this up as a fully-=
fledged patch (backports?)
> >
> > There seems to be no problem - I received an email on the 30 December
> > complete with the test logs. However, that was during the holiday perio=
d
> > and has been buried, so thanks for the reminder.
> >
> > However, I'm confused about who the reporter and testers actually are,
> > so I'm not sure who to put in the Reported-by and Tested-by fields.
> >  From what I can see, Bj=C3=B8rn Mork <bjorn@mork.no> reported it (at l=
east
> > to mainline devs), and the fix was tested by =E7=85=A7=E5=B1=B1=E5=91=
=A8=E4=B8=80=E9=83=8E
> > <teruyama@springboard-inc.jp>.
> >
> > Is that correct? Thanks.
> >
>
>  From what I know, you are correct there. =E7=85=A7=E5=B1=B1=E5=91=A8=E4=
=B8=80=E9=83=8E posted a patch
> "skip hpower setting for the module which has no revs" to fix his
> issue to the OpenWrt-Devel Mailinglist on the 28th November 2021:
> <https://www.mail-archive.com/openwrt-devel@lists.openwrt.org/msg60669.ht=
ml>
>
> |
> |@@ -0,0 +1,12 @@
> |@@ -0,0 +1,11 @@
> |--- a/drivers/net/phy/sfp.c
> |+++ b/drivers/net/phy/sfp.c
> |@@ -1590,6 +1590,8 @@ static int sfp_module_parse_power(struct
> |
> | static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
> | {
> |+      if (sfp->id.ext.sff8472_compliance =3D=3D SFP_SFF8472_COMPLIANCE_=
NONE)
> |+              return 0;
> |       u8 val;
> |       int err;
>
> Bj=C3=B8rn Mork picked this up and noted:
> |This looks like a workaround for a specific buggy module.  Is that
> |correct?   Why not update sfp_module_parse_power() instead so you can
> |skip the HPOWER state completely?  And add an appropriate warning about
> |this unexpected combination of options and sff8472_compliance..."
>
> and the thread went from there, with Bj=C3=B8rn Mork notifying you/upstre=
am
> about the problem because of the language barrier.
>
> <https://www.mail-archive.com/openwrt-devel@lists.openwrt.org/msg60697.ht=
ml>
>
> | =E7=85=A7=E5=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E <teruy...@springboard-inc=
.jp> writes:
> |
> |> Thank you for your quick response.
> |> It worked without any problems.
> |
> |Thanks for testing! I submitted this to netdev with a stable hint now.
> |So it should end up in Linux v5.10.x, and therefore also OpenWrt, in a
> |few weeks unless there are objections.
>
> So, one could argue that both reported this in a way and =E7=85=A7=E5=B1=
=B1=E5=91=A8=E4=B8=80=E9=83=8E tested
> it on his hardware.
>
> Cheers,
> Christian (got to catch a train)



--=20
=E6=A0=AA=E5=BC=8F=E4=BC=9A=E7=A4=BE=E3=82=B9=E3=83=97=E3=83=AA=E3=83=B3=E3=
=82=B0=E3=83=9C=E3=83=BC=E3=83=89
=E7=85=A7=E5=B1=B1=E3=80=80=E5=91=A8=E4=B8=80=E9=83=8E
teruyama@springboard-inc.jp
http://www.springboard-inc.jp/
=E3=80=92110-0005
=E6=9D=B1=E4=BA=AC=E9=83=BD=E5=8F=B0=E6=9D=B1=E5=8C=BA=E4=B8=8A=E9=87=8E3=
=E4=B8=81=E7=9B=AE2=E7=95=AA2=E5=8F=B7
=E3=82=A2=E3=82=A4=E3=82=AA=E3=82=B9=E7=A7=8B=E8=91=89=E5=8E=9F505=E5=8F=B7=
=E5=AE=A4
