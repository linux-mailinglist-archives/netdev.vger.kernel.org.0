Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82013E3D01
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 00:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhHHWSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 18:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhHHWSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 18:18:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4674C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 15:18:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so14320063plr.12
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 15:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=workware-net-au.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=uXF/HlLy6BpvjjoddG1ldyRg+oHgXHYKMFkCEC267qM=;
        b=lSQuWfRJMP36Z+1SgFTtAsmXpGj7xwm57C8lGNF1AHEK+lsyzHsIG6a9KEWScp0yEy
         LQWvITelD7LcyPACTS3je333OKZ7guO23WpAdtTNtNvevgV3j9+9ndVthkq7a1GFLOEx
         rfU8z/DtRCOka3Gi3xz74QQmX/Zo0TJJQSrDMNiDv0p/6SbQhwMlgQGmmTXfx8e38Byu
         R7HVDauTa3v2R5dukvxaZHGFRy0SqBkMd7i3HhMdiNBDwgMFn28mpWZXMTgzzFTjOHcK
         nX5Wrx9ZfXf8vrrM/1eHHPT133FVdPQHX72qep+LsTSnCgCLWBm68xl7i7RfKVEdk+RQ
         tNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=uXF/HlLy6BpvjjoddG1ldyRg+oHgXHYKMFkCEC267qM=;
        b=dbB3BfPK1Rq+xQc2ewF//m12LW90X5JeMikdIW1exjb04Bd+WUSLduEA/Ab3H+3Qnh
         8n8xHdaP7it2aChIlwsp6QxTm0S8yMbpDe86E4NDy+CvujeNo75S9251hFASZFl0KCbh
         CFVeEKGGFumlNWt4yNsAPRiAH0ioH9yfyKLI9RtjOdhuGlcbMdtV1NwiJ143nmgmn5fd
         emy9q31JFl8l+54CD1RAusmMeJslxKLl1C56Ckw4hVS6Mgu46CNh2trtQaEwT4ic1sFc
         UNqeNQNGj2Xj6IKF7wNHxShMT2txGCAIizoa6Ue1tPixOnhfIihwHLxruRsBx5SZFWEh
         yAVQ==
X-Gm-Message-State: AOAM5327mi2JMi5fSM/67cH1rpWLjMPbYNLOWTzT9/HYNYxiVemoTN1r
        30uedipLehth8luxrqG0mlObvA==
X-Google-Smtp-Source: ABdhPJwFwToNws/BYXYez5Gjg39xHwk/nkOmruK/PM8hyEb6KOfDeX15Aozd943TeypmTcOQQhnJpw==
X-Received: by 2002:a63:f754:: with SMTP id f20mr186055pgk.385.1628461113677;
        Sun, 08 Aug 2021 15:18:33 -0700 (PDT)
Received: from smtpclient.apple (117-20-69-228.751445.bne.nbn.aussiebb.net. [117.20.69.228])
        by smtp.gmail.com with ESMTPSA id m18sm15968802pjq.32.2021.08.08.15.18.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Aug 2021 15:18:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] net: phy: micrel: Fix detection of ksz87xx switch
From:   Steve Bennett <steveb@workware.net.au>
In-Reply-To: <20210807000123.GA4898@cephalopod>
Date:   Mon, 9 Aug 2021 08:18:28 +1000
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Workware-Check: steveb@workware.net.au
Content-Transfer-Encoding: quoted-printable
Message-Id: <F8C5F7CD-343A-4C25-B04B-EEA5C086B693@workware.net.au>
References: <20210730105120.93743-1-steveb@workware.net.au>
 <20210730095936.1420b930@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <74BE3A85-61E2-45C9-BA77-242B1014A820@workware.net.au>
 <20210807000123.GA4898@cephalopod>
To:     Ben Hutchings <ben.hutchings@essensium.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 7 Aug 2021, at 10:01 am, Ben Hutchings =
<ben.hutchings@essensium.com> wrote:
>=20
> On Sat, Jul 31, 2021 at 08:19:17AM +1000, Steve Bennett wrote:
>>> On 31 Jul 2021, at 2:59 am, Jakub Kicinski <kuba@kernel.org> wrote:
>>>=20
>>> Please extend the CC list to the maintainers, and people who
>>> worked on this driver in the past, especially Marek.
>>=20
>> Sure, I can do that in a v2 of the patch along with the more detailed
>> explanation below.
>>=20
>>>=20
>>> On Fri, 30 Jul 2021 20:51:20 +1000 Steve Bennett wrote:
>>>> The previous logic was wrong such that the ksz87xx
>>>> switch was not identified correctly.
>>>=20
>>> Any more details of what is happening? Which extact device do you =
see
>>> this problem on?
>>=20
>> I have a ksz8795 switch.
>>=20
>> Without the patch:
>>=20
>> ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver =
[Generic PHY]
>> ksz8795-switch spi3.1 ade2 (uninitialized): PHY [dsa-0.1:04] driver =
[Generic PHY]
>>=20
>> With the patch:
>>=20
>> ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver =
[Micrel KSZ87XX Switch]
>> ksz8795-switch spi3.1 ade2 (uninitialized): PHY [dsa-0.1:04] driver =
[Micrel KSZ87XX Switch]
> [...]
>=20
> And do the external ports work for you after this?
>=20
> I have a development board with a KSZ8795.  All ports worked before
> this patch.  After this patch, when I bring up the external ports they
> are reported as having link up at 10M half duplex, when the link is
> actually down.
>=20
> The ksz8873mll_read_status() function is trying to read a non-standard
> MDIO register that is not handled by the ksz8795 driver's MDIO
> emulation (and is not documented as existing on the KSZ8873MLL,
> either!).  It also also reports link up, which is obviously not
> correct for an external port.
>=20
> I'll post a patch as a reply to this.
>=20
> Ben.

Thanks Ben,

That looks reasonable to me. My board is running the external ports at =
10HD so
I didn't pick this up, but your patch looks correct.

Cheers,
Steve=
