Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2834148CE6C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiALWat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiALWas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:30:48 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1ADC06173F;
        Wed, 12 Jan 2022 14:30:48 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v6so6773226wra.8;
        Wed, 12 Jan 2022 14:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/s4QKinYtExGYxFtnd9lWeVWELrcAaCnOnegDCRXnk=;
        b=Fkc6+BrY7rwnvKAGdwDs9WVGmAPj5SHMpZgljeQ3vlQrQY+lmwlCWrI1GupQdXG1HV
         2DjDSeBsR1XIoF44yWBjTaG7TgruHtx+0YMMO3wWAqiYnqc/sBUqMpZeljw92Sd87NWv
         mQfu8OdJvCGCIDInNeGuKf0uhIsnb4DrXsACxPp7ExEDIru4/BxqozjeVLLBMb29aoYm
         bB06DXPmOM5wYdbQjlYgptNKjySBmtVvDABDWsYRp4i9I8cbJjulCmvFXjUpS8sLIacP
         34OE2MonPdLbNChqbNb17fVt43QnFzzRY81dtCoUc69zLQPahtl0J9sx3x89xLVdVuf8
         HERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/s4QKinYtExGYxFtnd9lWeVWELrcAaCnOnegDCRXnk=;
        b=zufNz2opjjVKt2Zr7WxddjwkqR3Pc4jLFxQZpu474vH9svnh/nGB6BO95JPvuiRQMo
         BpV1NCVdbQklZvBthP/Oh5roLOf4pbQTw+SNm8gV+rqjAreVskK88Zz13TDlYdouW5kk
         ih07YII8ChZ4OGMYwVpxE4uVeLY8f9GJT2b7c3eg0YrYG2mjoRPova30w07PqmVCkk6w
         VGvlBQ0/9LCQj3vNPB3CJXxA7orrWYjW34DrDdqPlzXLSaqGaMFa7FuwuBnMfxHE3yRj
         PCO0dTWwo/GsTn5Y9EApfwEOa6250t8cCJN+7IsIHJQVNIAbAJdAMRy34lp59/vSnEMU
         vx6Q==
X-Gm-Message-State: AOAM533VK0vFLbyeoYiC1QHXnGLw6yku00H9vg3E948GDc5dhO/99ZV+
        o75TdX8c60QB56JaugaJHVkqP9RKBgtGBZc/eCE=
X-Google-Smtp-Source: ABdhPJw42g0isBoHU177i38pV7cCL1ZHRMYn8ArPyFuq7CIvqxKj9MLPIQCmtyyNt75xZfYfEQIx3MxhuT3mnGLN2p4=
X-Received: by 2002:adf:e190:: with SMTP id az16mr1530408wrb.207.1642026646731;
 Wed, 12 Jan 2022 14:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com> <20220112173312.764660-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220112173312.764660-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 12 Jan 2022 17:30:35 -0500
Message-ID: <CAB_54W7uEQ5RJZxKT2qimoT=pbu8NsUhbZWZRWg+QjXDoTPFuQ@mail.gmail.com>
Subject: Re: [wpan-next v2 01/27] net: mac802154: Split the set channel hook implementation
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> As it is currently designed, the set_channel() cfg802154 hook
> implemented in the softMAC is doing a couple of checks before actually
> performing the channel change. However, as we enhance the support for
> automatically setting the symbol duration during channel changes, it
> will also be needed to ensure that the corresponding channel as properly
> be selected at probe time. In order to verify this, we will need to

no, we don't set channels at probe time. We set the
current_page/channel whatever the default is according to the hardware
datasheet. I think this channel should be dropped and all drivers set
the defaults before registering hw as what we do at e.g. at86rf230,
see [0].

- Alex

[0] https://elixir.bootlin.com/linux/v5.16/source/drivers/net/ieee802154/at86rf230.c#L1553
