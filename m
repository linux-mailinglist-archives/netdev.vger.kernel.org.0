Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB86E4FB6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjDQRyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjDQRyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:54:38 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE266E97;
        Mon, 17 Apr 2023 10:54:36 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r184so10901553ybc.1;
        Mon, 17 Apr 2023 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681754075; x=1684346075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oyR8W7v3COTYLNobCuykJJtDSCMEC7xmskW6emUW3jY=;
        b=BvJ3B4oBQxTmyVZLNr0yv6+R9zNTpbS4Q+bz8Up5LfmkIHQTvNxDu+WLqlKqaMBR9d
         2lQsUZjBM7phenPFqMqU6lDVX/6rb3ix6cVg7TM0HQzYm50ay0uklXvxww1yz24klY9Z
         G1SKy6xVM32F9mgaesrv9rmgMBJ/T1Zh5AH5dXccZ9LBnRFojKjrvoOzHsEicQUJguy1
         7LcPPNUSUIIhI15fqkOXlqkeQpZHL9t7qVFHpFt/RWf+O7KQMpmLyydyRbjMcAqUCsRu
         69rAZwrxZprnC/g6Kx1IFBUDA+jGvPlnJ2L6DYZBdj5Zd3dPoWl7RcmaLRsCc3Jsstv8
         HJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681754075; x=1684346075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oyR8W7v3COTYLNobCuykJJtDSCMEC7xmskW6emUW3jY=;
        b=XCFUlbKik6reNn3VKGWyXzpap3kw/nStomBTrFqzin8n6u85XgNxU8dO2tEKepS6SA
         A8pvZBVZXN1AegmAoCMJBBTpTRWnQVGkVg55iAsJ9fySJMbI9kKlN693PqhImvEBDf7D
         Mg2oy3Oetpif2U6RISg/SC4BwkKfAMttFEcIAS9oID83RAv/GpjxSpKMgDAP9acAvz32
         irEu9RjP80Fr/GZkMFLQwT/0IdzMFjS00sAJxRAImIG0nFa1cQ/FKIUAaoGi9IEFRcVO
         Z54fh0S/nyPpzpTY+SOyFbAKanQn5vbkxmFJp8Ia9811qo8F04NbJlUtPUxg8LxPKKb2
         EMQw==
X-Gm-Message-State: AAQBX9cl9v0ESmHSeRHlvjaFJA5k4VvSydzErA26aCZAh3Pjp8iYqmlY
        WYMUqTVon2oZM9QB/63HK/yO+sBs851XLsARTqQ=
X-Google-Smtp-Source: AKy350aVcCPZirKE4e29h+YR180S7kRdUycNhPLL1rAIzCXyCib+3TlzUD9p5cdFIFr0nJmeRynje/8Rtgczf6uHy+s=
X-Received: by 2002:a25:cb97:0:b0:b8b:f597:f3e5 with SMTP id
 b145-20020a25cb97000000b00b8bf597f3e5mr10181400ybg.9.1681754075318; Mon, 17
 Apr 2023 10:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230417053509.4808-1-noltari@gmail.com> <20230417053509.4808-3-noltari@gmail.com>
 <87wn2ax3sq.fsf@toke.dk>
In-Reply-To: <87wn2ax3sq.fsf@toke.dk>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Mon, 17 Apr 2023 19:54:24 +0200
Message-ID: <CAKR-sGftiGWf86uE2QwbpjJ+H7oyM6=AsFpHaxFBviJBrdueBg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ath9k: of_init: add endian check
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, chunkeey@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

El lun, 17 abr 2023 a las 11:21, Toke H=C3=B8iland-J=C3=B8rgensen
(<toke@toke.dk>) escribi=C3=B3:
>
> =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:
>
> > BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
> > partitions but it needs to be swapped in order to work, otherwise it fa=
ils:
> > ath9k 0000:00:01.0: enabling device (0000 -> 0002)
> > ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
> > ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
> > ath: phy0: Unable to initialize hardware; initialization status: -22
> > ath9k 0000:00:01.0: Failed to initialize device
> > ath9k: probe of 0000:00:01.0 failed with error -22
> >
> > For compatibility with current devices the AH_NO_EEP_SWAP flag will be
> > activated only when qca,endian-check isn't present in the device tree.
> > This is because some devices have the magic values swapped but not the =
actual
> > EEPROM data, so activating the flag for those devices will break them.
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/init.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wirele=
ss/ath/ath9k/init.c
> > index 4f00400c7ffb..abde953aec61 100644
> > --- a/drivers/net/wireless/ath/ath9k/init.c
> > +++ b/drivers/net/wireless/ath/ath9k/init.c
> > @@ -615,7 +615,6 @@ static int ath9k_nvmem_request_eeprom(struct ath_so=
ftc *sc)
> >
> >       ah->nvmem_blob_len =3D len;
> >       ah->ah_flags &=3D ~AH_USE_EEPROM;
> > -     ah->ah_flags |=3D AH_NO_EEP_SWAP;
> >
> >       return 0;
> >  }
> > @@ -688,9 +687,11 @@ static int ath9k_of_init(struct ath_softc *sc)
> >                       return ret;
> >
> >               ah->ah_flags &=3D ~AH_USE_EEPROM;
> > -             ah->ah_flags |=3D AH_NO_EEP_SWAP;
> >       }
> >
> > +     if (!of_property_read_bool(np, "qca,endian-check"))
> > +             ah->ah_flags |=3D AH_NO_EEP_SWAP;
> > +
>
> So I'm not sure just setting (or not) this flag actually leads to
> consistent behaviour. The code in ath9k_hw_nvram_swap_data() that reacts
> to this flag does an endianness check before swapping, and the behaviour
> of this check depends on the CPU endianness. However, the byte swapping
> you're after here also swaps u8 members of the eeprom, so it's not
> really a data endianness swap, and I don't think it should depend on the
> endianness of the CPU?
>
> So at least conceptually, the magic byte check in
> ath9k_hw_nvram_swap_data() is wrong; instead the byteswap check should
> just be checking against the little-endian version of the firmware
> (i.e., 0xa55a; I think that's what your device has, right?). However,
> since we're setting an explicit per-device property anyway (in the
> device tree), maybe it's better to just have that be an "eeprom needs
> swapping" flag and do the swap unconditionally if it's set? I think that
> would address Krzysztof's comment as well ("needs swapping" is a
> hardware property, "do the check" is not).

Yes, you're right, it's probably better to introduce a new and more
clear flag that swaps the content inconditionally.

>
> Now, the question becomes whether the "check" code path is actually used
> for anything today? The old mail thread I quoted in the other thread
> seems to indicate it's not, but it's not quite clear from the code
> whether there's currently any way to call into
> ath9k_hw_nvram_swap_data() without the NO_EEP_SWAP flag being set?

It's only used when endian_check is enabled in ath9k_platform_data:
https://github.com/torvalds/linux/blob/6a8f57ae2eb07ab39a6f0ccad60c76074305=
1026/drivers/net/wireless/ath/ath9k/init.c#L645
We're currently using it on OpenWrt for bmips:
https://github.com/Noltari/openwrt/blob/457549665fcb93667453ef48c50bf43eddd=
776ef/target/linux/bmips/files/arch/mips/bmips/ath9k-fixup.c#L198-L199

>
> WDYT?
>
> -Toke
