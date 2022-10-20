Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C51460627C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJTOJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJTOJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:09:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F74F357FF
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 07:09:49 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ot12so47785733ejb.1
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 07:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3gY5O7nKoCue4aUObD2Ry9zxDVljyutT9lJm/4wu1g=;
        b=RCtBERtGUuobnAig7pYIgKtjL97Ydq440F1TN34SgOXAeHIXDgKO8YhCEKzzMKOKSY
         63TAFHK+MXjtmWzbMroow/OlgioAP62vgFECpS4BNXpJPQmGfLJGW7o7+Jqjm3P+Ck1F
         MxDtNLVl5EUCeS/qvElRbrPGx6q/rI+rGzrYh+QCIF9qneeMQ/G6+VQ3kO8GsI8oQqGv
         IOX4gDgACU24WSU7ljxEG1j+R4UgwCAY/LxnHkT3qy22D38B+qnPCfAyNxmh4Gzj11OU
         Wz/hcsraIcxuHotP5h50Xu3GGhz6DArbCZ5AnuEBnbTh5C/LopZgiCSgm1rtHgvIvQ+c
         IYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3gY5O7nKoCue4aUObD2Ry9zxDVljyutT9lJm/4wu1g=;
        b=SCTQmnxemEFS9bXApZBEO3AHVQW/5bfoEQRx/WeQFxhPoV/UX47CSgglfhxH/uRrRT
         k/kHgabtrZ1aNABI3+gtfqRioXUgR0S/XvFD6gzwZNxIUY79a/tuaXwcoIVyXOBKBhhh
         0lmt0tDdoYyb/8Oqf2y+N9Ud0ZjoVYD9O4H6Gs56D9izOV3+nDxw55Xl8anO37MvzOVo
         oYmH4iLBzXIL8Pzo1d0XohIe2l6XvZZqkQEGdAyGDc49vacyc/+pgcP/Nhx72E7xyTqp
         /NjUOHXPdahPVxzARTwXcTfgw2q6bGzd5a5QJRHsarXa89czxyQEBiSb1NMl3XkFheQK
         iMrg==
X-Gm-Message-State: ACrzQf1K5rtcCvJqccpUAtOYsNomlOZ/HmFiAVLyXHuH+eQFisHEZsFs
        /CnbvF76Ojv7hLIn+cQhEkLkrzEinnq+vrqP+fVZkQ==
X-Google-Smtp-Source: AMsMyM7SGZ0XTtcSaYBLs9xPt4lvZ0m0MEYlP1BnZUi2dNpFH7IdPCCnnPLUKv4K6bQ9BC2uET83RJAVoSdiDcgHB90=
X-Received: by 2002:a17:907:16aa:b0:6fe:91d5:18d2 with SMTP id
 hc42-20020a17090716aa00b006fe91d518d2mr11464143ejc.190.1666274987831; Thu, 20
 Oct 2022 07:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st> <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st> <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <CACRpkdYwJLO18t08zqu_Y1gaSpZJMc+3MFxRUtQzLkJF2MqmqQ@mail.gmail.com>
 <87wn9q35tp.fsf_-_@kernel.org>
In-Reply-To: <87wn9q35tp.fsf_-_@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 20 Oct 2022 16:09:36 +0200
Message-ID: <CACRpkdYmXDCADH6-5KvdTZFFgTLRsw5U7zO2EtK-cN4E2BgOYw@mail.gmail.com>
Subject: Re: Stockholm syndrome with Linux wireless?
To:     Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:20 AM Kalle Valo <kvalo@kernel.org> wrote:
> Linus Walleij <linus.walleij@linaro.org> writes:
> > On Thu, Sep 22, 2022 at 3:31 PM Alvin =C5=A0ipraga <ALSI@bang-olufsen.d=
k> wrote:
> >
> >> I would also point out that the BCM4359 is equivalent to the
> >> CYW88359/CYW89359 chipset, which we are using in some of our
> >> products. Note that this is a Cypress chipset (identifiable by the
> >> Version: ... (... CY) tag in the version string). But the FW Konrad is
> >> linking appears to be for a Broadcom chipset.
> >
> > This just makes me think about Peter Robinsons seminar at
> > LPC last week...
> > "All types of wireless in Linux are terrible and why the vendors
> > should feel bad"
> > https://lpc.events/event/16/contributions/1278/attachments/1120/2153/wi=
reless-issues.pdf
>
> Thanks, this was a good read! I'm always interested about user and
> downstream feedback, both good and bad :) But I didn't get the Stockholm
> syndrome comment in the end, what does he mean with that?
>
> BTW we have a wireless workshop in netdevconf 0x16, it would be great to
> have there a this kind of session discussing user pain points:

I can't go to Lisbon, but my personal pain points are all this:
https://openwrt.org/meta/infobox/broadcom_wifi
and I think I'm not alone, but I can't speak for OpenWrt.

The lack of support in b43 for modern phys such as AC, i.e. the gap
between b43 and brcmfmac, is extremely annoying and turning perfectly
fine aftermarket devices into paperweights because there isn't even
a way to make Broadcoms old proprietary blob work with contemporary
kernels.

If Broadcom could be convinced to either add support for the late b43
variants or at least release documentation for the aftermarket that
would be great.

I suppose they might be coming to the conference so give them my best
regards with a "please fix" tag attached.

Yours,
Linus Walleij
