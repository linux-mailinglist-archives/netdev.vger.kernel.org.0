Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77E96E3EE4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDQFdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDQFdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:33:46 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD351BC0;
        Sun, 16 Apr 2023 22:33:42 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-552ae3e2cbeso34244107b3.13;
        Sun, 16 Apr 2023 22:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681709621; x=1684301621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bd4dQc1FpkwZYZhwWOOHutAGKXr41UyMWvG9J+VrOtw=;
        b=W6jp2+VPSJ6XcDqc5ekEGiUOC2rSj1xTbO//rViw8zv+ifG0ENU6HRF1+inx9rfILD
         2QSMiGwHhuLnsMcw0LceQ2wC81mDW4AXJnOl0DeOUWVi7xI0ywt/76IOC+mzlW1SKUvn
         Zx7VCJJS0KWYkY0nmTZrlanGg0EFZiEq8ELmQtGm+BXLa85p7D16XKdPlfv1J5Hr30CJ
         MQ0P0HRjxd44UFXnyTbj1EqIa5XYFvyUeIWV6b9GyZ/U0ROnasJZ1Qij9SgMqjqgnpPk
         Qw6AdpgzidNWnE88iwwfG30Mp8unilJInkIjQf14rY++RrCtFyVkekbdcNDXTUFTsae7
         pOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681709621; x=1684301621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bd4dQc1FpkwZYZhwWOOHutAGKXr41UyMWvG9J+VrOtw=;
        b=VHx924Gjgu3jhyENULKp2WQ+O9FFpWzjYfBGAz78eSEKDtRuswiRFTbWAi7PQ9OpTc
         xrr0s4iscszWBvj5DFBvrgUbv/S5qdqnN8ne/cPj8zpZS9j1/juuIeXhkQVnkE0FLOxE
         SKlxNS3d1wgHEsVelgGspcIqpnlE9ukYxPgvO58xViqvwBvNxM4m23ps6PclI2sAqxmP
         JyVfeVPUmODBPpWAOIfcHdS0aBY+8zPQxEQOf8rbC4ZwFr5+kTVW1jI2YhuZFkllv3yK
         MWWAW/gf2xYt1Nzw3HLrqCihTYk3mP87/mFeK4GqKca8vgUSkt7nuGaH3k3ls3qQED6Y
         gPmw==
X-Gm-Message-State: AAQBX9dM6T3tFe+rxXj4gJHFK7xu2drbE8u8clPrzKiSWyY3hLd7Hmcr
        e0/wQCdaNEbQDZEqi5uemeu0Sox0742qMiuMDok=
X-Google-Smtp-Source: AKy350Yk9Tv6HCQzCayejAyB1Fw5PAEanr1+f9Eco4+j6qhmF0bsQjcV7x90pm8V8B42ayqutlvCzlq0RJupVaa8d8c=
X-Received: by 2002:a05:690c:706:b0:545:5f92:f7ee with SMTP id
 bs6-20020a05690c070600b005455f92f7eemr9153411ywb.2.1681709621205; Sun, 16 Apr
 2023 22:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230415150542.2368179-1-noltari@gmail.com> <87leitxj4k.fsf@toke.dk>
 <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com> <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com>
 <874jpgxfs7.fsf@toke.dk> <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com> <871qkjxztc.fsf@toke.dk>
In-Reply-To: <871qkjxztc.fsf@toke.dk>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Mon, 17 Apr 2023 07:33:30 +0200
Message-ID: <CAKR-sGdcaYTzzcG6yLkor20d0qWamMAv6g-fb8M5b4tsZHadRA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix calibration data endianness
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Christian Lamparter <chunkeey@gmail.com>, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, nbd@nbd.name, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

El dom, 16 abr 2023 a las 23:49, Toke H=C3=B8iland-J=C3=B8rgensen
(<toke@toke.dk>) escribi=C3=B3:
>
> Christian Lamparter <chunkeey@gmail.com> writes:
>
> > On 4/16/23 12:50, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Christian Lamparter <chunkeey@gmail.com> writes:
> >>
> >>> On 4/15/23 18:02, Christian Lamparter wrote:
> >>>> Hi,
> >>>>
> >>>> On 4/15/23 17:25, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>>> =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:
> >>>>>
> >>>>>> BCM63xx (Big Endian MIPS) devices store the calibration data in MT=
D
> >>>>>> partitions but it needs to be swapped in order to work, otherwise =
it fails:
> >>>>>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
> >>>>>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
> >>>>>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
> >>>>>> ath: phy0: Unable to initialize hardware; initialization status: -=
22
> >>>>>> ath9k 0000:00:01.0: Failed to initialize device
> >>>>>> ath9k: probe of 0000:00:01.0 failed with error -22
> >>>>>
> >>>>> How does this affect other platforms? Why was the NO_EEP_SWAP flag =
set
> >>>>> in the first place? Christian, care to comment on this?
> >>>>
> >>>> I knew this would come up. I've written what I know and remember in =
the
> >>>> pull-request/buglink.
> >>>>
> >>>> Maybe this can be added to the commit?
> >>>> Link: https://github.com/openwrt/openwrt/pull/12365
> >>>>
> >>>> | From what I remember, the ah->ah_flags |=3D AH_NO_EEP_SWAP; was co=
pied verbatim from ath9k_of_init's request_eeprom.
> >>>>
> >>>> Since the existing request_firmware eeprom fetcher code set the flag=
,
> >>>> the nvmem code had to do it too.
> >>>>
> >>>> In theory, I don't think that not setting the AH_NO_EEP_SWAP flag wi=
ll cause havoc.
> >>>> I don't know if there are devices out there, which have a swapped ma=
gic (which is
> >>>> used to detect the endianess), but the caldata is in the correct end=
iannes (or
> >>>> vice versa - Magic is correct, but data needs swapping).
> >>>>
> >>>> I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
> >>>> and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
> >>>> So I don't expect there to be a new issue there).
> >>>
> >>> Nope! This is a classic self-own!... Well at least, this now gets doc=
umented!
> >>>
> >>> Here are my findings. Please excuse the overlong lines.
> >>>
> >>> ## The good news / AVM FritzBox 7360v2 ##
> >>>
> >>> The good news: The AVM FritzBox 7360v2 worked the same as before.
> >>
> >> [...]
> >>
> >>> ## The not so good news / Netgear WNDR3700v2 ##
> >>>
> >>> But not the Netgar WNDR3700v2. One WiFi (The 2.4G, reported itself no=
w as the 5G @0000:00:11.0 -
> >>> doesn't really work now), and the real 5G WiFi (@0000:00:12.0) failed=
 with:
> >>> "phy1: Bad EEPROM VER 0x0001 or REV 0x06e0"
> >>
> >> [...]
> >>
> >> Alright, so IIUC, we have a situation where some devices only work
> >> *with* the flag, and some devices only work *without* the flag? So we'=
ll
> >> need some kind of platform-specific setting? Could we put this in the
> >> device trees, or is there a better solution?
> >
> > Depends. From what I gather, ath9k calls this "need_swap". Thing is,
> > the flag in the EEPROM is called "AR5416_EEPMISC_BIG_ENDIAN". In the
> > official documentation about the AR9170 Base EEPROM (has the same base
> > structure as AR5008 up to AR92xx) this is specified as:
> >
> > "Only bit 0 is defined as Big Endian. This bit should be written as 1
> > when the structure is interpreted in big Endian byte ordering. This bit
> > must be reviewed before any larger than byte parameters can be interpre=
ted."
> >
> > It makes sense that on a Big-Endian MIPS device (like the Netgear WNDR3=
700v2),
> > the  caldata should be in "Big-Endian" too... so no swapping is necessa=
ry.
> >
> > Looking in ath9k's eeprom.c function ath9k_hw_nvram_swap_data() that de=
als
> > with this eepmisc flag:
> >
> > |       if (ah->eep_ops->get_eepmisc(ah) & AR5416_EEPMISC_BIG_ENDIAN) {
> > |               *swap_needed =3D true;
> > |               ath_dbg(common, EEPROM,
> > |                       "Big Endian EEPROM detected according to EEPMIS=
C register.\n");
> > |       } else {
> > |               *swap_needed =3D false;
> > |       }
> >
> > This doesn't take into consideration that swapping is not needed if
> > the data is in big endian format on a big endian device. So, this
> > could be changed so that the *swap_needed is only true if the flag and
> > device endiannes disagrees?
> >
> > That said, Martin and Felix have written their reasons in the cover let=
ter
> > and patches for why the code is what it is:
> > <https://ath9k-devel.ath9k.narkive.com/2q5A6nu0/patch-0-5-ath9k-eeprom-=
swapping-improvements>
> >
> > Toke, What's your take on this? Having something similar like the
> > check_endian bool... but for OF? Or more logic that can somehow
> > figure out if it's big or little endian.
>
> Digging into that old thread, it seems we are re-hashing a lot of the
> old discussion when those patches went in. Basically, the code you
> quoted above is correct because the commit that introduced it sets all
> fields to be __le16 and __le32 types and reads them using the
> leXX_to_cpu() macros.
>
> The code *further up* in that function is what is enabled by Alvaro's
> patch. Which is a different type of swapping (where the whole eeprom is
> swab16()'ed, not just the actual multi-byte data fields in them).
> However, in OpenWrt the in-driver code to do this is not used; instead,
> a hotplug script applies the swapping before the device is seen by the
> driver, as described in this commit[0]. Martin indeed mentions that this
> is a device-specific thing, so the driver can't actually do the right
> thing without some outside feature flag[1]. The commit[0] also indicates
> that there used used to exist a device-tree binding in the out-of-tree
> device trees used in OpenWrt to do the unconditional swab16().
>
> The code in [0] still exists in OpenWrt today, albeit in a somewhat
> modified form[2]. I guess the question then boils down to, =C3=81lvaro, c=
an
> your issue be resolved by a pre-processing step similar to that which is
> done in [2]? Or do we need the device tree flag after all?

TBH, yes, it can be solved by a pre-processing step similar to what's
done in [2], but then having added nvmem support would make no sense
at all for those devices that need swapping, since it's unusable
without the flag.
So, in my opinion the flag should be added in order to be able to use
it without pre-processing the calibration data and to take advantage
of nvmem support.
I will send the v2 patch and even if it's not accepted I think I will
add it as a downstream patch on OpenWrt...

>
> -Toke
>
> [0] https://git.openwrt.org/?p=3Dopenwrt/openwrt.git;a=3Dcommitdiff;h=3Da=
fa37092663d00aa0abf8c61943d9a1b5558b144
> [1] https://narkive.com/2q5A6nu0.34
> [2] https://git.openwrt.org/?p=3Dopenwrt/openwrt.git;a=3Dblob;f=3Dtarget/=
linux/lantiq/xway/base-files/etc/hotplug.d/firmware/12-ath9k-eeprom;h=3D98b=
b9af6947a298775ff7fa26ac6501c57df8378;hb=3DHEAD

Best regards,
=C3=81lvaro.
