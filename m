Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D271360636D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJTOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiJTOoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:44:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533C82722;
        Thu, 20 Oct 2022 07:44:23 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id c7-20020a05600c0ac700b003c6cad86f38so2533729wmr.2;
        Thu, 20 Oct 2022 07:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2aGTNVe1qeic4UHRXjmYB1c+NLXbE7qDaWKF7l796o=;
        b=eOeKfm8jDAnYe115ZExdtX0xVMbgIu/+zJRFN4KvZEBokogWjM8Qkq2tBf+H4l/Gh0
         Bnlv78rbaQ8OH0qxTJiSV0iZH7dIDAJSeP2b7fPZGS2+2sOixWVH+8e3DqM4ocWSdKnW
         cRMkVuJ8macQxLJP//ZLzMp/9E0TrT06TBV9SNUNJ1RCRWUjVN6zSKVK2q/OxNB/Ec2P
         9GohpcMb/vkm7niCe3mJ3X2Z6i33p1JQuw6iWKrsbBYarHwxqVHGp7c1XCPyYcYRsNWi
         3bzKwsnEilwMy+EV1Qt1vIcgMRqPU7CRRyafsbz9IEu/bbm/870udhgyGCB2oEvufhg1
         XytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2aGTNVe1qeic4UHRXjmYB1c+NLXbE7qDaWKF7l796o=;
        b=DbNeOIuhvkaQD1/52mOkYiGu3L02bsG/3r0Zdn5Pi+m9T1Rr4GwNwb29MNtGBZ78A2
         xZaG/ZecHqM115EjlrBGSit5d9FSMnNQ5tvdlKF45lAkyoiR1gdwvLA0pJk2baFI7sWy
         +yA5dM3emHppIdswUtai2wCf1bzFK2E2abSpt1soxgKd40JGKwALIT1TmpZ/qalYIt/O
         7VpgjBDdFAXWeXx2k9VMDtSn7feoL70PkAYCm6pNiTc4B2QYtaGuQ393xrRhvNdcVP3k
         Kn84mDJiE7bWJKL07kqOzDILyJdN41iXGTLCkMHEahQ9bNntxxlesGgGFdABoFtXoNh0
         RWDQ==
X-Gm-Message-State: ACrzQf3PMOfUTBseQdNIzIGDVrJLH2zpCvrcBSqmnosQLBLZC7RCIG5Y
        FKE9RAQxT4Z/ppc4b4jUj9cykzbtwg7tUFhZztV+m/te
X-Google-Smtp-Source: AMsMyM7tR2b5yivaNKJO3l2Li3CyzRJpaXg3AroQfwSEWWlB1bHo4dnRufA0llhvfs/LEs0jt9h8+t1voF+9PnwfaDs=
X-Received: by 2002:a05:600c:1906:b0:3c6:f83e:d15f with SMTP id
 j6-20020a05600c190600b003c6f83ed15fmr14320246wmq.205.1666277062387; Thu, 20
 Oct 2022 07:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st> <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st> <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <CACRpkdYwJLO18t08zqu_Y1gaSpZJMc+3MFxRUtQzLkJF2MqmqQ@mail.gmail.com>
 <87wn9q35tp.fsf_-_@kernel.org> <CACRpkdYmXDCADH6-5KvdTZFFgTLRsw5U7zO2EtK-cN4E2BgOYw@mail.gmail.com>
In-Reply-To: <CACRpkdYmXDCADH6-5KvdTZFFgTLRsw5U7zO2EtK-cN4E2BgOYw@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 20 Oct 2022 07:44:10 -0700
Message-ID: <CAA93jw5ntj-V075Gwm=UzML5VcQo9Tb2T+9jtV69=Grf9hieHw@mail.gmail.com>
Subject: Re: Stockholm syndrome with Linux wireless?
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 7:34 AM Linus Walleij <linus.walleij@linaro.org> wr=
ote:
>
> On Mon, Sep 26, 2022 at 10:20 AM Kalle Valo <kvalo@kernel.org> wrote:
> > Linus Walleij <linus.walleij@linaro.org> writes:
> > > On Thu, Sep 22, 2022 at 3:31 PM Alvin =C5=A0ipraga <ALSI@bang-olufsen=
.dk> wrote:
> > >
> > >> I would also point out that the BCM4359 is equivalent to the
> > >> CYW88359/CYW89359 chipset, which we are using in some of our
> > >> products. Note that this is a Cypress chipset (identifiable by the
> > >> Version: ... (... CY) tag in the version string). But the FW Konrad =
is
> > >> linking appears to be for a Broadcom chipset.
> > >
> > > This just makes me think about Peter Robinsons seminar at
> > > LPC last week...
> > > "All types of wireless in Linux are terrible and why the vendors
> > > should feel bad"
> > > https://lpc.events/event/16/contributions/1278/attachments/1120/2153/=
wireless-issues.pdf
> >
> > Thanks, this was a good read! I'm always interested about user and
> > downstream feedback, both good and bad :) But I didn't get the Stockhol=
m
> > syndrome comment in the end, what does he mean with that?
> >
> > BTW we have a wireless workshop in netdevconf 0x16, it would be great t=
o
> > have there a this kind of session discussing user pain points:
>
> I can't go to Lisbon, but my personal pain points are all this:
> https://openwrt.org/meta/infobox/broadcom_wifi
> and I think I'm not alone, but I can't speak for OpenWrt.
>
> The lack of support in b43 for modern phys such as AC, i.e. the gap
> between b43 and brcmfmac, is extremely annoying and turning perfectly
> fine aftermarket devices into paperweights because there isn't even
> a way to make Broadcoms old proprietary blob work with contemporary
> kernels.

+10. I'm a big believer in coping with the present day supply problems with
modern software on perfectly good old routers. To heck with planned
obsolescence.

There are 5.2 billion cellphones turning into e-waste this year, also. The =
wifi
situation there is also a mess.

>
> If Broadcom could be convinced to either add support for the late b43
> variants or at least release documentation for the aftermarket that
> would be great.
>
> I suppose they might be coming to the conference so give them my best
> regards with a "please fix" tag attached.

Please! A symbol of a rotting raspberry, on their badges, or some
other gentle poke, might work wonders.

I too cannot make it to lisbon. I just burned 9 months of my life
(unpaid, mostly, but a huge thanks to NLNET for covering
half my costs) on helping fix a ton of regressions in the ath10k,
mt76, and ath9k, instead of making forward progress with new stuff.

I can call out the ax210 chips as being especially terrible still.
It's hard to test APs when the client chips
are as bad as that.

I'm very tempted to just buy a one-way ticket to lisbon, join this
wireless emotional support group there, and then find a beach to
retire on, and never think about this part of our field again.

It seems far saner to quit working on wifi and seek out something more
rewarding. Maybe there's some bright light on the horizon for less
binary blobs in wifi7?

>
> Yours,
> Linus Walleij



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
