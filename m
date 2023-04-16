Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E0C6E3938
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 16:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjDPO2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 10:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjDPO2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 10:28:40 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51962D79;
        Sun, 16 Apr 2023 07:28:36 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54fe3cd445aso89055567b3.5;
        Sun, 16 Apr 2023 07:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681655316; x=1684247316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wA16LhUeIrcFoOy5LTvp57u9Zr2CYyp/g5yKsZDpZJk=;
        b=fm2pMwyv5Nsa0BCr0Q7BAdu7CfPDTT+CHcabDdrgt/YUsSbqdv8NWFTYAOu82tTgxm
         LkKNGWJMtvwEFusPWHDj5u6DmfvJOUEYwVQf4Caq8fZu9uoUbT886q9KL+/nMs6osZmq
         FC3L/bqa0wnNvUM7KfVzO+DUNW32E+AjZTmxXYO1Y98lmwfOg+7dH8En0vcKR/EV0ptH
         iGce4CI4I8gNlalWFZYLIk9qXQlFak66zKe6r4u1odI6RvFgCBQ5PJotdx7/DQNudxNL
         9+9g+qDwFG+/pSyUAkyeQI+Mpi1uiiy8S4sbNeyu1Ho4+BISP+BcLWsX3rdbgedeKiLl
         ob+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681655316; x=1684247316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wA16LhUeIrcFoOy5LTvp57u9Zr2CYyp/g5yKsZDpZJk=;
        b=dbvz9/5xCYToSZmiwwZfwKm5n34HkTT7qPyBV0K5YRa+mW+aerHoWDNh6S3qMSPO2+
         4QRJx+roRuO5uJzwp5PrrToHD11q5ZHDe7jkIMGL/tREgKPboFIrDWq0mG1ilZ3vzQpb
         Xc1UVogLysABUyLtqyUSUQvp+Th9W+MhC23ur96dIaW7k9echDHEPpl/cjz5kgFBG65b
         66EUEtZyOHPQJLI48ezMVjARqHEKksyKRpaaCLZLYOVc8UlMXXZ3eq9RBelhaiI/b39M
         F1qAUH1HTLPY3a5dKwB6KrfMiOEoGHhRjMugLdu/HzpLDKzKFxvXKGOUSll004XPXFkx
         8ITA==
X-Gm-Message-State: AAQBX9fGf7M5jSXNN+uh3g09hfShewjSC/kClrFPUfZPmhcZoJt+FPZd
        6HWHxaVe3xtjUyo5tB/UnzGwWeK77ZvA4Epy2C8=
X-Google-Smtp-Source: AKy350YqtJNRykVWsTLm7a9mZD/OOTVworM3IkQoMZfgRrk49yBLTz2EDLGH6MxOCzP83iJsnkrSAMixhh9VmGScScQ=
X-Received: by 2002:a81:d006:0:b0:54f:ae82:3f92 with SMTP id
 v6-20020a81d006000000b0054fae823f92mr7131787ywi.2.1681655315515; Sun, 16 Apr
 2023 07:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230415150542.2368179-1-noltari@gmail.com> <87leitxj4k.fsf@toke.dk>
 <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com> <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com>
 <874jpgxfs7.fsf@toke.dk> <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
In-Reply-To: <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Sun, 16 Apr 2023 16:28:24 +0200
Message-ID: <CAKR-sGcA_Vk9prvmF858vh6RzyUTXUmo1hQU4QUXJA7gCqy5Qg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix calibration data endianness
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El dom, 16 abr 2023 a las 15:37, Christian Lamparter
(<chunkeey@gmail.com>) escribi=C3=B3:
>
> On 4/16/23 12:50, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Christian Lamparter <chunkeey@gmail.com> writes:
> >
> >> On 4/15/23 18:02, Christian Lamparter wrote:
> >>> Hi,
> >>>
> >>> On 4/15/23 17:25, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>> =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:
> >>>>
> >>>>> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
> >>>>> partitions but it needs to be swapped in order to work, otherwise i=
t fails:
> >>>>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
> >>>>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
> >>>>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
> >>>>> ath: phy0: Unable to initialize hardware; initialization status: -2=
2
> >>>>> ath9k 0000:00:01.0: Failed to initialize device
> >>>>> ath9k: probe of 0000:00:01.0 failed with error -22
> >>>>
> >>>> How does this affect other platforms? Why was the NO_EEP_SWAP flag s=
et
> >>>> in the first place? Christian, care to comment on this?
> >>>
> >>> I knew this would come up. I've written what I know and remember in t=
he
> >>> pull-request/buglink.
> >>>
> >>> Maybe this can be added to the commit?
> >>> Link: https://github.com/openwrt/openwrt/pull/12365
> >>>
> >>> | From what I remember, the ah->ah_flags |=3D AH_NO_EEP_SWAP; was cop=
ied verbatim from ath9k_of_init's request_eeprom.
> >>>
> >>> Since the existing request_firmware eeprom fetcher code set the flag,
> >>> the nvmem code had to do it too.
> >>>
> >>> In theory, I don't think that not setting the AH_NO_EEP_SWAP flag wil=
l cause havoc.
> >>> I don't know if there are devices out there, which have a swapped mag=
ic (which is
> >>> used to detect the endianess), but the caldata is in the correct endi=
annes (or
> >>> vice versa - Magic is correct, but data needs swapping).
> >>>
> >>> I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
> >>> and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
> >>> So I don't expect there to be a new issue there).
> >>
> >> Nope! This is a classic self-own!... Well at least, this now gets docu=
mented!
> >>
> >> Here are my findings. Please excuse the overlong lines.
> >>
> >> ## The good news / AVM FritzBox 7360v2 ##
> >>
> >> The good news: The AVM FritzBox 7360v2 worked the same as before.
> >
> > [...]
> >
> >> ## The not so good news / Netgear WNDR3700v2 ##
> >>
> >> But not the Netgar WNDR3700v2. One WiFi (The 2.4G, reported itself now=
 as the 5G @0000:00:11.0 -
> >> doesn't really work now), and the real 5G WiFi (@0000:00:12.0) failed =
with:
> >> "phy1: Bad EEPROM VER 0x0001 or REV 0x06e0"
> >
> > [...]
> >
> > Alright, so IIUC, we have a situation where some devices only work
> > *with* the flag, and some devices only work *without* the flag? So we'l=
l
> > need some kind of platform-specific setting? Could we put this in the
> > device trees, or is there a better solution?
>
> Depends. From what I gather, ath9k calls this "need_swap". Thing is,
> the flag in the EEPROM is called "AR5416_EEPMISC_BIG_ENDIAN". In the
> official documentation about the AR9170 Base EEPROM (has the same base
> structure as AR5008 up to AR92xx) this is specified as:
>
> "Only bit 0 is defined as Big Endian. This bit should be written as 1
> when the structure is interpreted in big Endian byte ordering. This bit
> must be reviewed before any larger than byte parameters can be interprete=
d."
>
> It makes sense that on a Big-Endian MIPS device (like the Netgear WNDR370=
0v2),
> the  caldata should be in "Big-Endian" too... so no swapping is necessary=
.
>
> Looking in ath9k's eeprom.c function ath9k_hw_nvram_swap_data() that deal=
s
> with this eepmisc flag:
>
> |       if (ah->eep_ops->get_eepmisc(ah) & AR5416_EEPMISC_BIG_ENDIAN) {
> |               *swap_needed =3D true;
> |               ath_dbg(common, EEPROM,
> |                       "Big Endian EEPROM detected according to EEPMISC =
register.\n");
> |       } else {
> |               *swap_needed =3D false;
> |       }
>
> This doesn't take into consideration that swapping is not needed if
> the data is in big endian format on a big endian device. So, this
> could be changed so that the *swap_needed is only true if the flag and
> device endiannes disagrees?
>
> That said, Martin and Felix have written their reasons in the cover lette=
r
> and patches for why the code is what it is:
> <https://ath9k-devel.ath9k.narkive.com/2q5A6nu0/patch-0-5-ath9k-eeprom-sw=
apping-improvements>
>
> Toke, What's your take on this? Having something similar like the
> check_endian bool... but for OF? Or more logic that can somehow
> figure out if it's big or little endian.

I already have v2 patches adding a new device tree flag, but I'll wait
for Toke's answer before sending them.
In my patches I added a new DT flag "qca,endian-check", which follows
the one from ath9k_platform_data (endian_check).

>
> Cheers,
> Christian

Best regards,
=C3=81lvaro.
