Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A624721C4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 08:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhLMHbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 02:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhLMHbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 02:31:33 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93065C061748
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 23:31:33 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id b1-20020a4a8101000000b002c659ab1342so3982614oog.1
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 23:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ja0HWj5Gsp47ZRg+7SvX5BE8xP1Fjyd70WjG4w88Yr0=;
        b=gNctGPKesvpZMCr7thv7ODaTJqEid+48HsFA940xTiiPhCRj4hi1mJKbP//E/lmHi2
         FndPK+OzVXd+CN3ahIT+TLlK6dZPdK+cLnlCV8L5CQVcfCdvcy5t0WCJl6uidYcsav9l
         a1lUrr+pplxeSlMQLlDEHhQe/o3XlZbcncRelT3fCsu2dmZKCwxyyIA7M6vNbnHGHQED
         kjzQ4R9wFDAPFlzFMp0IZKwP7NmCBkP+ULkqpKTs3mWUnp40Xv0sgfrL/j5DHaPKpWA3
         xGFPyaWBW7aMpkrek14lCqkM+b/TACsiHOWxU7kyTNqdMyoDN2qzr2Yi3Ma/MC084UqZ
         IHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ja0HWj5Gsp47ZRg+7SvX5BE8xP1Fjyd70WjG4w88Yr0=;
        b=Xeob5tntbaReqjGXj1Vu2oUN8+l0FNxz7fsU1oCOjnXUmUku2JtralKPo3A//vGjEr
         gY3RMHVgjio78eKyUFkKEVplBl73zR91sTWtMpDkSspIBdSJFX4Xd5DexqkqGrFDGc9V
         eGRUHdr98MLrb9sP4shgd1dmgsiI/u5AivHeLBWG72QCd4B41pDUpZ4gqJjtxW/fMnj1
         8dXH3HDjxO/1pNkGoc777uf1XUCJUMRyT1BTlSh2PxBKaVVN/272+EFxUCplhUAKH3JC
         1EIBUzdsSkwZo5MJZ7IbWZSsSnT7N3A0FZ/SslYgTKaCCj4AHDVES8etooUO1UTlbpvs
         SA3g==
X-Gm-Message-State: AOAM532KIeUg/6yPIjJaFRFADzzrblZ1JKmKzHyznHeXHHwXF2avBDgR
        n01NRwyRJkgLtzBmAh7R3nPFcDjrGWYRSytdyEDwgA==
X-Google-Smtp-Source: ABdhPJxQmmt+yc5NhtgQ0NAMiwtBslV6TPGcnOnhsnge7dbaU7T3rFu3ysrvHoUrzTuOGooSDOHZE9XAds9dCnWlKPQ=
X-Received: by 2002:a4a:af02:: with SMTP id w2mr18822678oon.7.1639380692821;
 Sun, 12 Dec 2021 23:31:32 -0800 (PST)
MIME-Version: 1.0
References: <20211210081659.4621-1-jhp@endlessos.org> <6b0fcc8cf3bd4a77ad190dc6f72eb66f@realtek.com>
 <CAAd53p66HPH9v0_hzOaQAydberd8JA4HthNVwpQ86xb-dSuUEA@mail.gmail.com>
 <CAPpJ_efvmPWsCFsff35GHV8Q52YvQcFr_Hs=q3RtvbfVohY+4Q@mail.gmail.com> <617008e3be9c4b5aa37b26f97daf9354@realtek.com>
In-Reply-To: <617008e3be9c4b5aa37b26f97daf9354@realtek.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Mon, 13 Dec 2021 15:30:56 +0800
Message-ID: <CAPpJ_ecqf+LqkN-Wb+zNGHbtJ3rKD8_kU3W0c2gTQGQqK1sUwg@mail.gmail.com>
Subject: Re: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
To:     Pkshih <pkshih@realtek.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessos.org" <linux@endlessos.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> =E6=96=BC 2021=E5=B9=B412=E6=9C=8811=E6=97=A5 =
=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=882:31=E5=AF=AB=E9=81=93=EF=BC=9A
>
>
> > -----Original Message-----
> > From: Jian-Hong Pan <jhp@endlessos.org>
> > Sent: Friday, December 10, 2021 5:34 PM
> > To: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Cc: Pkshih <pkshih@realtek.com>; Yan-Hsuan Chuang <tony0620emma@gmail.c=
om>; Kalle Valo
> > <kvalo@codeaurora.org>; linux-wireless@vger.kernel.org; netdev@vger.ker=
nel.org;
> > linux-kernel@vger.kernel.org; linux@endlessos.org
> > Subject: Re: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
> >
> > Kai-Heng Feng <kai.heng.feng@canonical.com> =E6=96=BC 2021=E5=B9=B412=
=E6=9C=8810=E6=97=A5 =E9=80=B1=E4=BA=94 =E4=B8=8B=E5=8D=885:24=E5=AF=AB=E9=
=81=93=EF=BC=9A
> > >
> > > On Fri, Dec 10, 2021 at 5:00 PM Pkshih <pkshih@realtek.com> wrote:
> > > >
> > > > +Kai-Heng
> > > >
> > > > > -----Original Message-----
> > > > > From: Jian-Hong Pan <jhp@endlessos.org>
> > > > > Sent: Friday, December 10, 2021 4:17 PM
> > > > > To: Pkshih <pkshih@realtek.com>; Yan-Hsuan Chuang <tony0620emma@g=
mail.com>; Kalle Valo
> > > > > <kvalo@codeaurora.org>
> > > > > Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux=
-kernel@vger.kernel.org;
> > > > > linux@endlessos.org; Jian-Hong Pan <jhp@endlessos.org>
> > > > > Subject: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
> > > > >
> > > > > More and more laptops become frozen, due to the equipped RTL8821C=
E.
> > > > >
> > > > > This patch follows the idea mentioned in commits 956c6d4f20c5 ("r=
tw88:
> > > > > add quirks to disable pci capabilities") and 1d4dcaf3db9bd ("rtw8=
8: add
> > > > > quirk to disable pci caps on HP Pavilion 14-ce0xxx"), but disable=
s its
> > > > > PCI ASPM capability of RTL8821CE directly, instead of checking DM=
I.
> > > > >
> > > > > Buglink:https://bugzilla.kernel.org/show_bug.cgi?id=3D215239
> > > > > Fixes: 1d4dcaf3db9bd ("rtw88: add quirk to disable pci caps on HP=
 Pavilion 14-ce0xxx")
> > > > > Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
> > > >
> > > > We also discuss similar thing in this thread:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D215131
> > > >
> > > > Since we still want to turn on ASPM to save more power, I would lik=
e to
> > > > enumerate the blacklist. Does it work to you?
> > >
> > > Too many platforms are affected, the blacklist method won't scale.
> >
> > Exactly!
>
> Got it.
>
> >
> > > Right now it seems like only Intel platforms are affected, so can I
> > > propose a patch to disable ASPM when its upstream port is Intel?
> >
> > I only have laptops with Intel chip now.  So, I am not sure the status
> > with AMD platforms.
> > If this is true, then "disable ASPM when its upstream port is Intel"
> > might be a good idea.
> >
>
> Jian-Hong, could you try Kai-Heng's workaround that only turn off ASPM
> during NAPI poll function. If it also works to you, I think it is okay
> to apply this workaround to all Intel platform with RTL8821CE chipset.
> Because this workaround has little (almost no) impact of power consumptio=
n.

According to Kai-Heng's hack patch [1] and the comment [2] mentioning
checking "ref_cnt" by rtw_pci_link_ps(), I arrange the patch as
following.
This patch only disables ASPM (if the hardware has the capability)
when system gets into rtw_pci_napi_poll() and re-enables ASPM when it
leaves rtw_pci_napi_poll().  It is as Ping-Ke mentioned "only turn off
ASPM during NAPI poll function".
The WiFi & BT work, and system is still alive after I use the internet
awhile.  Besides, there is no more "pci bus timeout, check dma status"
error.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D215131#c11
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D215131#c15

Jian-Hong Pan

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203..a6fdddecd37d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1658,6 +1658,7 @@ static int rtw_pci_napi_poll(struct napi_struct
*napi, int budget)
                                              priv);
        int work_done =3D 0;

+       rtw_pci_link_ps(rtwdev, false);
        while (work_done < budget) {
                u32 work_done_once;

@@ -1681,6 +1682,7 @@ static int rtw_pci_napi_poll(struct napi_struct
*napi, int budget)
                if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
                        napi_schedule(napi);
        }
+       rtw_pci_link_ps(rtwdev, true);

        return work_done;
 }

> >
> > > > If so, please help to add one quirk entry of your platform.
> > > >
> > > > Another thing is that "attachment 299735" is another workaround for=
 certain
> > > > platform. And, we plan to add quirk to enable this workaround.
> > > > Could you try if it works to you?
> > >
> > > When the hardware is doing DMA, it should initiate leaving ASPM L1,
> > > correct? So in theory my workaround should be benign enough for most
> > > platforms.
>
> I don't see and know the detail of hardware waveform, but I think your
> understanding is correct.
>
> --
> Ping-Ke
>
