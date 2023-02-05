Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3174868AFC4
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBEMox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 07:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBEMow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 07:44:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0761E9D5;
        Sun,  5 Feb 2023 04:44:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d2so5539566pjd.5;
        Sun, 05 Feb 2023 04:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNQbvjXs76kLrTrP6/48/orXXpYZ4utP3YcercTcmdk=;
        b=Lpx4AWSJ8kngfGosDiPF8Vgea1uNwxHRu6WcyK6iPWbYT1vuwOsAnDbShODviTp+ak
         McODKL+2lWtpjVEpUn09Ag1GnwoN3HEb3DsRi98OemWbvkcf/fwm51RBVLpd0ge26F7g
         WJFhJbb1R5S79+kABVOLUw7gHH11uJYJ5Bfgz3vjbW5U3vhj2YCxVHtwdagC4dNtB5xw
         rn8oT9prtnhcrNfmIhbty19xyiccEC2uv05w/p+JHbr9iyTm67jeT1X3grWJg2lZwV1M
         +uDZrczApAGh5ZTkWGk53XENtarR9TCzWPPhU7bK98czIia0S2eFzulZ6IF2B6gexhYF
         ACpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNQbvjXs76kLrTrP6/48/orXXpYZ4utP3YcercTcmdk=;
        b=qKD12Qs3wYvmCP8xNSwp2A1VYPWZTyn0WbKZopiPnoofnB51bXJkLTLIErsGYRNbLB
         1rWF7f/xfyNn3Xy0iuurCh77BD7TrmFltPXWQ4USBB8upkI3Uv54JbwjLhTH9mZVNf5I
         /xlARaK7MIRiEJ1uIMGAuCuW3uERvyWTJ1w2sd3s5+iOgwfPNBh3d3PcBhzrW3DWl09J
         WexaqGtQwbCBfTnPjgIyhkM6adQlrgN4twSK+1zlIX6gaofZcYgJ2YIx40FhgwnUlNst
         1rvXrsU5Fs7PYnpc4kdzlyhyZZZVKpKaSnZTnkcTU4SfS/Pef07sjt573fsdit15ou3a
         jc0w==
X-Gm-Message-State: AO0yUKXSPFpR/rP/rdpmoF8BKm21GEUhZcJVcMPvHamKq25lFOJhPWVd
        F8COTxCq0r5OonSY9wXXc9ruhWMYq56Btffd1ow=
X-Google-Smtp-Source: AK7set9yNcGN3mqqmzAvPCGFoQsrkAjQUiciGz4UiGp/VX5ImbZ+Sc7PhQxRtperCrBYE3Y8HpteZ5TyRbxgF4HkVLE=
X-Received: by 2002:a17:902:e846:b0:195:f26d:b82c with SMTP id
 t6-20020a170902e84600b00195f26db82cmr3644645plg.15.1675601090577; Sun, 05 Feb
 2023 04:44:50 -0800 (PST)
MIME-Version: 1.0
References: <20230131112840.14017-1-marcan@marcan.st> <20230131112840.14017-2-marcan@marcan.st>
 <CAOiHx=mYxFx0kr5s=4X_qywZBpPqCbrNjLnTXfigPOnqZSxjag@mail.gmail.com>
 <4fb4af22-d115-de62-3bda-c1ae02e097ee@marcan.st> <1861323f100.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <28ed8713-4243-7c67-b792-92d0dde82256@marcan.st> <186205e1c60.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <186205e1c60.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Sun, 5 Feb 2023 13:44:39 +0100
Message-ID: <CAOiHx=m2NFo2hbS4a3j67B4iFrkM7dGKGhwLkXuwOZAR=+C63Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] brcmfmac: Drop all the RAW device IDs
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Hector Martin <marcan@marcan.st>,
        "'Hector Martin' via BRCM80211-DEV-LIST,PDL" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org, SHA-cyfmac-dev-list@infineon.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Feb 2023 at 07:58, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> - stale Cypress emails
>
> On February 5, 2023 3:50:41 AM Hector Martin <marcan@marcan.st> wrote:
>
> > On 03/02/2023 02.19, Arend Van Spriel wrote:
> >> On February 2, 2023 6:25:28 AM "'Hector Martin' via BRCM80211-DEV-LIST=
,PDL"
> >> <brcm80211-dev-list.pdl@broadcom.com> wrote:
> >>
> >>> On 31/01/2023 23.17, Jonas Gorski wrote:
> >>>> On Tue, 31 Jan 2023 at 12:36, Hector Martin <marcan@marcan.st> wrote=
:
> >>>>>
> >>>>> These device IDs are only supposed to be visible internally, in dev=
ices
> >>>>> without a proper OTP. They should never be seen in devices in the w=
ild,
> >>>>> so drop them to avoid confusion.
> >>>>
> >>>> I think these can still show up in embedded platforms where the
> >>>> OTP/SPROM is provided on-flash.
> >>>>
> >>>> E.g. https://forum.archive.openwrt.org/viewtopic.php?id=3D55367&p=3D=
4
> >>>> shows this bootlog on an BCM4709A0 router with two BCM43602 wifis:
> >>>>
> >>>> [    3.237132] pci 0000:01:00.0: [14e4:aa52] type 00 class 0x028000
> >>>> [    3.237174] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x00007ff=
f 64bit]
> >>>> [    3.237199] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x003ffff=
f 64bit]
> >>>> [    3.237302] pci 0000:01:00.0: supports D1 D2
> >>>> ...
> >>>> [    3.782384] pci 0001:03:00.0: [14e4:aa52] type 00 class 0x028000
> >>>> [    3.782440] pci 0001:03:00.0: reg 0x10: [mem 0x00000000-0x00007ff=
f 64bit]
> >>>> [    3.782474] pci 0001:03:00.0: reg 0x18: [mem 0x00000000-0x003ffff=
f 64bit]
> >>>> [    3.782649] pci 0001:03:00.0: supports D1 D2
> >>>>
> >>>> 0xaa52 =3D=3D 43602 (BRCM_PCIE_43602_RAW_DEVICE_ID)
> >>>>
> >>>> Rafa=C5=82 can probably provide more info there.
> >>>>
> >>>> Regards
> >>>> Jonas
> >>>
> >>> Arend, any comments on these platforms?
> >>
> >> Huh? I already replied to that couple of days ago or did I only imagin=
e
> >> doing that.
> >
> > I don't see any replies from you on the lists (or my inbox) to Jonas' e=
mail.
>
> Accidentally sent that reply to internal mailing list. So quoting myself =
here:
>
> """
> Shaking the tree helps ;-) What is meant by "OTP/SPROM is provided
> on-flash"? I assume you mean that it is on the host side and the wifi PCI=
e
> device can not access it when it gets powered up. Maybe for this scenario
> we should have a devicetree compatible to configure the device id, but th=
at
> does not help any current users of these platforms. Thanks for providing
> this info.

That's what I meant, the wifi chip itself does not have any (valid)
OTP/SPROM attached/populated, and requires the driver to setup the
values at runtime based on the host SoC's flash contents (most likely
NVRAM contents).

This was the case in about 99% of embedded systems based on MIPS
bcm47xx/bcm63xx, where the wifi chips then always identified
themselves with their raw chip IDs as PCI device IDs (even leading to
one or two ID conflicts ...).

I have to admit I don't know how much this is still an issue on
current (ARM) systems, but at least that one BCM4709A one suggests
this is still happening in "recent" designs. Probably because it saves
half a cent per board or so ;-)

Regards
Jonas
