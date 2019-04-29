Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0846DE43F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfD2OGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:06:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43809 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfD2OGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:06:19 -0400
Received: by mail-io1-f68.google.com with SMTP id v9so9007374iol.10
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 07:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nmacleod-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pew+aNhXViEFyPPNr3LSU1ExpTAZBUHs/ZPzmKyCLpU=;
        b=lV24N7cuxDJ5BfnoLsR5n1crb1+NaxF4+rhxpSYl7WQNhWvcyM8cdUzYoofa+MWR5+
         2u/jhTbaVY2fCS3I5qlJ9vHqBfCQKEShthSBwlwJboZ1IGFY/G7Uz4OxIW8ygeiM2GFG
         H6vOxswovSEaVspKqMmBw8NcTeW3PZdjt3KtfoZ+smL/LkLbDicooKbtwI62u8iSdo1B
         Yl1mhCTiNE5Pqet7IFtrc2TeKKiDxmQc/ZeuHoYx5CAR4GJbjZ5FpkNuwTJraBq8/Rsa
         9TaLp/Mt1OBT6Iu4pt7Yrj+UAHgW2Vn03pnd1ArCqThj4QnEhirCEMLk3SJgolr8HhjJ
         iBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pew+aNhXViEFyPPNr3LSU1ExpTAZBUHs/ZPzmKyCLpU=;
        b=jhRw3LGS6NZDW5CkK69U0oFnDoZLhNcBr6/Dx+BmSHhFkFy0XAnTikE2Mq2KCwFV0Z
         vOV+fRLO+Iw1kTpab93Y4b3EeyQWJu7tF0js9++S4Sn+TSTje/6uJC3uKStAUIrlPMwN
         X0ooAch0fyptXmqTdbCe06GmnSObkhyo0QFHF86rUFvt8e2AOBDpBx4z98iNxOOKT9xA
         dTagAUlGSVbaUyS/zGwpEIpj3RKs+hTsIWaibFAKMQVxVNfJM+jcL3bHVI2Gcv8osUpX
         C+21VtXRqiQ54e1kWq8cx+d5O5d1W28d94YcX9cz2y0i8kZi55lxlrWJub6ez8MZslhE
         EtAw==
X-Gm-Message-State: APjAAAWx1vR6aFbqOkPNOh+/SFdKcUrUcj+6rs9vMdgUWkkukOCem4tG
        g5ZQbKGuSLg6GGJF/ulM0mNQwzA5kQcS7IE49cXksg==
X-Google-Smtp-Source: APXvYqxuETewN5tOi0BTVlXpLpuUYkJUGeHYNAz49L0wSi8SZxrs2wyoH75o3VbDf8p/QGUPV7EXq2bDVvHk5Nkz6Fg=
X-Received: by 2002:a6b:ea0e:: with SMTP id m14mr29217781ioc.86.1556546778008;
 Mon, 29 Apr 2019 07:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <d2f64f21-6a1d-00bd-ec30-51c31acdb177@gmail.com>
 <CAFbqK8kk8UqLXC=FPHjjYawHRozCmsKuV3WcD8x1y5HvYw_2rA@mail.gmail.com>
 <a7d1f3fc-2ab3-33dc-b0f8-146fdfb46a1d@gmail.com> <CAFbqK8n3vVuTfX+ZAi-TN70HtY75u3fBiM-h0USqPuk9K3=FZg@mail.gmail.com>
 <7dfaf793-1cb1-faef-d700-aa24ff4d50d9@gmail.com> <CAFbqK8m1kH-+KQG_ozWjSwM1Ti-UgpBys6sAo4j4k+PVPKnrAg@mail.gmail.com>
 <e8b12136-3dc2-17e4-ccdf-f2fd2040ff7b@electromag.com.au> <CAFbqK8=yOnhNRJH0sdXK4i5TGev5yZcFc+W_6K1VY3kQZ64Eww@mail.gmail.com>
In-Reply-To: <CAFbqK8=yOnhNRJH0sdXK4i5TGev5yZcFc+W_6K1VY3kQZ64Eww@mail.gmail.com>
From:   Neil MacLeod <neil@nmacleod.com>
Date:   Mon, 29 Apr 2019 15:06:03 +0100
Message-ID: <CAFbqK8k_n3iVuTg6EwDATNbpzpn29KdTHx6VwKm+PKJXDhr6cw@mail.gmail.com>
Subject: Re: Testing of r8169 workaround removal
To:     Phil Reid <preid@electromag.com.au>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, just re-sending this email as it doesn't appear to have arrived at
the mailing list.

Phil

Many thanks - you've nailed it!

Reverting the workaround from Heiner, and also
fc8f36de77111bf925d19f347c2113, resulted in 5.0.6 syncing at 10Mbps
after resuming from S3 instead of the 1000Mbps it syncs at boot.

Hopefully this is helpful in understanding why the workaround is no
longer required.

Thanks all
Neil

On Mon, 29 Apr 2019 at 04:55, Neil MacLeod <neil@nmacleod.com> wrote:
>
> Phil
>
> Many thanks - you've nailed it!
>
> Reverting the workaround from Heiner, and also
> fc8f36de77111bf925d19f347c2113, resulted in 5.0.6 syncing at 10Mbps
> after resuming from S3 instead of the 1000Mbps it syncs at boot.
>
> Hopefully this is helpful in understanding why the workaround is no
> longer required.
>
> Thanks all
> Neil
>
> On Mon, 29 Apr 2019 at 04:20, Phil Reid <preid@electromag.com.au> wrote:
> >
> > On 29/04/2019 6:05 am, Neil MacLeod wrote:
> > > Hi Heiner
> > >
> > > 5.0.6 is the first kernel that does NOT require the workaround.
> > >
> > > In 5.0.6 the only obvious r8169 change (to my untrained eyes) is:
> > >
> > > https://github.com/torvalds/linux/commit/4951fc65d9153deded3d066ab371a61977c96e8a
> > >
> > > but reverting this change in addition to the workaround makes no
> > > difference, the resulting kernel still resumes at 1000Mbps so I'm not
> > > sure what other change in .5.0.6 might be responsible for this changed
> > > behaviour. If you can think of anything I'll give it a try!
> > >
> > > Regards
> > > Neil
> >
> > The symptom sounds very similar to a problem I had with 1G link only linking at 10M.
> >
> > Perhaps have a look at:
> > net: phy: don't clear BMCR in genphy_soft_reset
> >
> > https://www.spinics.net/lists/netdev/msg559627.html
> >
> > Which looks to have been added in 5.0.6
> > commit  fc8f36de77111bf925d19f347c21134542941a3c
> >
> >
> > >
> > > PS. A while ago (5 Dec 2018 to be precise!) I emailed you about the
> > > ASPM issue which it looks like you may have fixed in 5.1-rc5[1].
> > > Unfortunately I don't have this issue myself, and I've been trying to
> > > get feedback from the bug reporter[2,3] "Matt Devo" without much
> > > success but will confirm to you if/when he replies.
> > >
> > > 1, https://bugzilla.kernel.org/show_bug.cgi?id=202945
> > > 2. https://forum.kodi.tv/showthread.php?tid=298462&pid=2845944#pid2845944
> > > 3. https://forum.kodi.tv/showthread.php?tid=343069&pid=2850123#pid2850123
> > >
> > > On Sun, 28 Apr 2019 at 19:43, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > >>
> > >> Interesting, thanks for your efforts! I submitted the patch removing
> > >> the workaround because it seems now (at least since 5.1-rc1) we're fine.
> > >>
> > >> Heiner
> > >>
> > >> On 28.04.2019 20:40, Neil MacLeod wrote:
> > >>> Hi Heiner
> > >>>
> > >>> I'd already kicked off a 5.0.2 build without the workaround and I've
> > >>> tested that now, and it resumes at 10Mbps, so it may still be worth
> > >>> identifying the exact 5.0.y version when it was fixed just in case
> > >>> that provides some understanding of how it was fixed... I'll test the
> > >>> remaining kernels between 5.0.3 and 5.0.10 as that's not much extra
> > >>> work and let you know what I find!
> > >>>
> > >>> Regards
> > >>> Neil
> > >>>
> > >>> On Sun, 28 Apr 2019 at 18:39, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > >>>>
> > >>>> Hi Neil,
> > >>>>
> > >>>> thanks for reporting back. Interesting, then the root cause of the
> > >>>> issue seems to have been in a different corner. On my hardware
> > >>>> I'm not able to reproduce the issue. It's not that relevant with which
> > >>>> exact version the issue vanished. Based on your results I'll just
> > >>>> remove the workaround on net-next (adding your Tested-by).
> > >>>>
> > >>>> Heiner
> > >>>>
> > >>>>
> > >>>> On 28.04.2019 19:30, Neil MacLeod wrote:
> > >>>>> Hi Heiner
> > >>>>>
> > >>>>> Do you know if this is already fixed in 5.1-rc6 (Linus Torvalds tree),
> > >>>>> as in order to test your request I thought I would reproduce the issue
> > >>>>> with plain 5.1-rc6 with the workaround removed, however without the
> > >>>>> workaround 5.1-rc6 is resuming correctly at 1000Mbps.
> > >>>>>
> > >>>>> I went back to 4.19-rc4 (which we know is brroken) and I can reproduce
> > >>>>> the issue with the PC (Revo 3700) resuming at 10Mbps, but with 5.1-rc6
> > >>>>> I can no longer reproduce the issue when the workaround is removed.
> > >>>>>
> > >>>>> I also tested 5.0.10 without the workaround, and again 5.0.10 is
> > >>>>> resuming correctly at 1000Mbps.
> > >>>>>
> > >>>>> I finally tested 4.19.23 without the workaround (the last iteration of
> > >>>>> this kernel I published) and this does NOT resume correctly at
> > >>>>> 1000Mbps (it resumes at 10Mbps).
> > >>>>>
> > >>>>> I'll test a few more iterations of 5.0.y to see if I can identify when
> > >>>>> it was "fixed" but if you have any suggestions when it might have been
> > >>>>> fixed I can try to confirm this that - currently it's somewhere
> > >>>>> between 4.19.24 and 5.0.10!
> > >>>>>
> > >>>>> Regards
> > >>>>> Neil
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>> On Sun, 28 Apr 2019 at 14:33, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > >>>>>>
> > >>>>>> Hi Neil,
> > >>>>>>
> > >>>>>> you once reported the original issue resulting in this workaround.
> > >>>>>> This workaround shouldn't be needed any longer, but I have no affected HW
> > >>>>>> to test on. Do you have the option to apply the patch below to latest
> > >>>>>> net-next and test link speed after resume from suspend?
> > >>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> > >>>>>> That would be much appreciated.
> > >>>>>>
> > >>>>>> Heiner
> > >>>>>>
> > >>>>>> ----------------------------------------------------------------
> > >>>>>>
> > >>>>>> After 8c90b795e90f ("net: phy: improve genphy_soft_reset") this
> > >>>>>> workaround shouldn't be needed any longer. However I don't have
> > >>>>>> affected hardware so I can't test it.
> > >>>>>>
> > >>>>>> This was the bug report leading to the workaround:
> > >>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=201081
> > >>>>>>
> > >>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > >>>>>> ---
> > >>>>>>   drivers/net/ethernet/realtek/r8169.c | 8 --------
> > >>>>>>   1 file changed, 8 deletions(-)
> > >>>>>>
> > >>>>>> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> > >>>>>> index 383242df0..d4ec08e37 100644
> > >>>>>> --- a/drivers/net/ethernet/realtek/r8169.c
> > >>>>>> +++ b/drivers/net/ethernet/realtek/r8169.c
> > >>>>>> @@ -4083,14 +4083,6 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
> > >>>>>>          phy_speed_up(tp->phydev);
> > >>>>>>
> > >>>>>>          genphy_soft_reset(tp->phydev);
> > >>>>>> -
> > >>>>>> -       /* It was reported that several chips end up with 10MBit/Half on a
> > >>>>>> -        * 1GBit link after resuming from S3. For whatever reason the PHY on
> > >>>>>> -        * these chips doesn't properly start a renegotiation when soft-reset.
> > >>>>>> -        * Explicitly requesting a renegotiation fixes this.
> > >>>>>> -        */
> > >>>>>> -       if (tp->phydev->autoneg == AUTONEG_ENABLE)
> > >>>>>> -               phy_restart_aneg(tp->phydev);
> > >>>>>>   }
> > >>>>>>
> > >>>>>>   static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
> > >>>>>> --
> > >>>>>> 2.21.0
> > >>>>>
> > >>>>
> > >>>
> > >>
> > >
> > >
> >
> >
> > --
> > Regards
> > Phil Reid
> >
> > ElectroMagnetic Imaging Technology Pty Ltd
> > Development of Geophysical Instrumentation & Software
> > www.electromag.com.au
> >
> > 3 The Avenue, Midland WA 6056, AUSTRALIA
> > Ph: +61 8 9250 8100
> > Fax: +61 8 9250 7100
> > Email: preid@electromag.com.au
