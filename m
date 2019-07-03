Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131DD5DCD7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 05:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfGCDZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 23:25:24 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41058 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfGCDZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 23:25:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id v22so768393qkj.8
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 20:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJsosknFSMZqJio20riiWMLc4/tQoWtv3tru77r3tTA=;
        b=FWM+RRyxyzu8W+QS8juDSU5bmX9P7C113BNP6FOv/ShOeGz6jH+oLijFv2qHlcoPEh
         0uNnlRJPD1HICYWFfgrkBqgyYiaM0ix34Ed85bYE0ETi5Yf2OTtCLWmEN1JmfBorDCQ+
         gBYsx2cunyHNgXf3CW6nFykqWWDUi6C2kW1U5TGMBstmHC7ZRWlZ7PqYE+wA8msyn80X
         V6Nd5jEbWYKcLEXnJBZDauBhGXspHCC0kqENicar5+vH/qujt4GlNCbqt0hcNcFULxfJ
         9cx/W6zcBkFBTc++dqD7TNGKdJEpbYFzRMcHlD5SfBiJ+ppNRXivhbbt9baIpLioc7V/
         ZCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJsosknFSMZqJio20riiWMLc4/tQoWtv3tru77r3tTA=;
        b=qEipIC8kKeasDAc1bLcU6MJ3cBZk6WyHEm33iO3b6m9JaRcbVtQYFuv78FaQWr8pfK
         H/gQSHenRUEZYFjExl3VhyfXNkgjy4o+/DgTxuKlydE2a9etTXIrZW3t0CTdLndiOO8F
         a5SBv/zX5hBoQxWWVT7oGVHSGIl3CaWcmWMzxfWBfu5PWjGBqTYjsVw0oyIjlkoL/Ek+
         NzhzX58EcZ6WuuGRK1A0WTAdPwPlNomn7pZJ0MI8tr7ypctYkZb6Padu/aKts+FZ6/2J
         s8nUnDE02PFJeLm0hF//wWju0QEtqxNM+Po6PYuwLVxxALJsQBhf9eZHr4LjMCO+FAfy
         BbyA==
X-Gm-Message-State: APjAAAWIQa+EoB4mLGbJyZqqqFAdYg7TLEbsR3YgPaRvgZ/gBkpFW6ej
        8YnWl+uZ9KeIexqgmjAAAOFR5PYC7ffJ5WRHnAVQhw==
X-Google-Smtp-Source: APXvYqynhs3N20tz4EeRWUTKfzSM1e2Oi0HEF0ofk6gfdWiN2oBM1EZrbIrCFhjo8NMaXAJ/1/KyFHIpwqWU6t0nOQc=
X-Received: by 2002:a37:9e4b:: with SMTP id h72mr28861404qke.297.1562124322973;
 Tue, 02 Jul 2019 20:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190627095247.8792-1-chiu@endlessm.com> <31f59db2-0e04-447b-48f8-66ea53ebfa7d@gmail.com>
In-Reply-To: <31f59db2-0e04-447b-48f8-66ea53ebfa7d@gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Wed, 3 Jul 2019 11:25:11 +0800
Message-ID: <CAB4CAwcEdcg91Bgb+JoCdk_zQKsWT-K+cb07-5mrrx+__X2RMA@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:44 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>
> On 6/27/19 5:52 AM, Chris Chiu wrote:
> > The WiFi tx power of RTL8723BU is extremely low after booting. So
> > the WiFi scan gives very limited AP list and it always fails to
> > connect to the selected AP. This module only supports 1x1 antenna
> > and the antenna is switched to bluetooth due to some incorrect
> > register settings.
> >
> > This commit hand over the antenna control to PTA, the wifi signal
> > will be back to normal and the bluetooth scan can also work at the
> > same time. However, the btcoexist still needs to be handled under
> > different circumstances. If there's a BT connection established,
> > the wifi still fails to connect until disconneting the BT.
> >
> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
> > ---
> >  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 9 ++++++---
> >  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 3 ++-
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > index 3adb1d3d47ac..6c3c70d93ac1 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
> >       /*
> >        * WLAN action by PTA
> >        */
> > -     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
> > +     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
> >
> >       /*
> >        * BT select S0/S1 controlled by WiFi
> > @@ -1568,9 +1568,12 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
> >       rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
> >
> >       /*
> > -      * 0x280, 0x00, 0x200, 0x80 - not clear
> > +      * Different settings per different antenna position.
> > +      * Antenna switch to BT: 0x280, 0x00 (inverse)
> > +      * Antenna switch to WiFi: 0x0, 0x280 (inverse)
> > +      * Antenna controlled by PTA: 0x200, 0x80 (inverse)
> >        */
> > -     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> > +     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
> >
> >       /*
> >        * Software control, antenna at WiFi side
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > index 8136e268b4e6..87b2179a769e 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > @@ -3891,12 +3891,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
> >
> >       /* Check if MAC is already powered on */
> >       val8 = rtl8xxxu_read8(priv, REG_CR);
> > +     val16 = rtl8xxxu_read16(priv, REG_SYS_CLKR);
> >
> >       /*
> >        * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
> >        * initialized. First MAC returns 0xea, second MAC returns 0x00
> >        */
> > -     if (val8 == 0xea)
> > +     if (val8 == 0xea || !(val16 & BIT(11)))
> >               macpower = false;
> >       else
> >               macpower = true;
>
> This part I would like to ask you take a good look at the other chips to
> make sure you don't break support for 8192cu, 8723au, 8188eu with this.
>
> Cheers,
> Jes

I checked the vendor code of 8192cu and 8188eu, they don't have this part
of code to check the REG_CR before power on sequence. I can only find
similar code in rtl8723be.
if (tmp_u1b != 0 && tmp_u1b !=0xea)
    rtlhal->mac_func_enable = true;

By definition, the BIT(11) of REG_SYS_CLKR in rtl8xxxu_regs.h is
SYS_CLK_MAC_CLK_ENABLE. It seems to make sense to check this value
for macpower no matter what chip it is. I think I can make it more
self-expressive
as down below.

 if (val8 == 0xea || !(val16 & SYS_CLK_MAC_CLK_ENABLE))

And per the comment, this code is for 92DU-VC S3 hang problem and I think an
OR check for SYS_CLK_MAC_CLK_ENABLE is still safe for this.

Chris
