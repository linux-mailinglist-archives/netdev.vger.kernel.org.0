Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7670494284
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345174AbiASVdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243932AbiASVdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 16:33:38 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8514FC061574;
        Wed, 19 Jan 2022 13:33:38 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z22so19330960edd.12;
        Wed, 19 Jan 2022 13:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G9TwtEmBwHsz7Hs+GPJU5J1gILmVa0fDogyNSi8Kw7o=;
        b=L2opvre8nZfR4V7OzJzr6ToNimzNHsWFeugrPvnJASBMerurTh2i6QOtKwoGrzrsM7
         Kf32W4AndAz567fW0Ttqgd2tVzWownmrBsoyxA/U/ep0DkOTUvGr05TYax/ISHaqL2XA
         fshXitXg58Sa48kvgIvCJ2bgGWxwUfwYwic9XG2dWuc7GJT96AIu52YXXuZsxECYhl0W
         mpdWAMSLiS2AA9LFqeOwKr7Iii+S9jhAqUQST7D2U2KGHlSVvRgFrU68ShBcwpblzBq2
         vK6/9NAsOH3LGGHjS28E/PAwejRr9Q557QU+geUs5H2vSjVSMfNZtWtBFeopmSF6qm3X
         1gww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G9TwtEmBwHsz7Hs+GPJU5J1gILmVa0fDogyNSi8Kw7o=;
        b=wCv7z3rVnQed1Px5GkTp8yI2mT5syxKrVFNGqR06VvLF4MA71dmJAwIU3fEg+y8lXs
         iXzKifv4WTnGT6443HL1f7UlX1j9FD8YcST4PTXcgr3gnk7G9a5uSi01Cv+eSENGP3ne
         q7PorLPcZfo/jiurKZjsy//w2RBC7mjzHn35cbxsI+cXJsZhmprBJnaweaSgLAlsUAoK
         lJ81UcMz1X6deTPFoTH2gNNXM5O+LYkw2masn/RuwM5BLXGBGJnmD7opNotPaShmMAH2
         Dl3E3jrV4E38p+Zd3qtD2p56bnHRMIpB0KJvynK5NHPj0zyYXyA69vyHDZXUyT3TcKMM
         17dg==
X-Gm-Message-State: AOAM5314JMkBvbsen/fYFg2DiuC4KGHM6pJdkjsTQLVoGK7Dt6CQuYPK
        BmsbnCsEJ/uCL6O+lTIgEIMUkEyK7x9A+G+jyes=
X-Google-Smtp-Source: ABdhPJyBUOm/xJV5ixGx9Dj16YeNB6n0mVbZ/LFOZw0ovBE5jIRO0sLjTE/dEjwHczFBYdbIEpCiJYi9NCzJbxZiOEY=
X-Received: by 2002:a17:906:5d0f:: with SMTP id g15mr7676628ejt.44.1642628015943;
 Wed, 19 Jan 2022 13:33:35 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-2-marcan@marcan.st>
 <CAHp75VfVuX-BG1MJcEoQrOW6jn=PSMZH0jTcwGj9PwWxocG_Gw@mail.gmail.com> <9a222199-6620-15b7-395f-e079b8e6e529@gmail.com>
In-Reply-To: <9a222199-6620-15b7-395f-e079b8e6e529@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 19 Jan 2022 23:31:53 +0200
Message-ID: <CAHp75VdY1gNzVFNneEexEivx1RL_MiX8HxgHoFFd9TN8vXgGLQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] brcmfmac: pcie: Release firmwares in the
 brcmf_pcie_setup error path
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 11:22 PM Dmitry Osipenko <digetx@gmail.com> wrote:
>
> 19.01.2022 20:49, Andy Shevchenko =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
> >>
> >> This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
> >> the CLM blob is released in the device remove path.
> >
> > ...
> >
> >>         if (ret) {
> >
> >>                 brcmf_err(bus, "Failed to get RAM info\n");
> >> +               release_firmware(fw);
> >> +               brcmf_fw_nvram_free(nvram);
> >
> > Can we first undo the things and only after print a message?
>
> Having message first usually is more preferred because at minimum you'll
> get the message if "undoing the things" crashes, i.e. will be more
> obvious what happened.

If "undo the things" crashes, I would rather like to see that crash
report, while serial UART at 9600 will continue flushing the message
and then hang without any pointers to what the heck happened. Not
here, but in general, messages are also good to be out of the locks.


--=20
With Best Regards,
Andy Shevchenko
