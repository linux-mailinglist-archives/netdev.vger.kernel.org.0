Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6648E0DE
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 00:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiAMX1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 18:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238190AbiAMX1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 18:27:43 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E53C061574;
        Thu, 13 Jan 2022 15:27:43 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id e9so12883897wra.2;
        Thu, 13 Jan 2022 15:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tlvap2oP+61e2yvExfPH4KET6jHA0Dk431YlmavXzqU=;
        b=mChYZ47QoBnVwuZ7TUmew2YmY2k2Fd9VJLUa4ZMdlJdaqxdwknfdf1vlF2T5ujpIcI
         Y3o1patT8QbNgv5TJFzAGE37mkGq9Nbd/yE7fQpatI3fEkVnnIU5zQMS3aY9TFqJ5v8z
         jdkgN0BAqj19Ocv+KUzaOyPgj+iR99b5Phow8WkjrvA6e2CzPv/80h08goiFN2FFLgVR
         /eZ5qNzI/YHnRI6HCItTSYVQiiR4KRHQl7vyJcbOfEsPMuMQuCN6+m+n2V7JAIJKZrB+
         TSzWf7j5BiM9fTibrsmV4bwqiFE8ZQcnNyKd1yF1rIyjSoQ4aIAC0hQeyjLOyDN1GLxh
         akHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tlvap2oP+61e2yvExfPH4KET6jHA0Dk431YlmavXzqU=;
        b=oHwxaENCSDOI7gDvF3GGkNiNqvMt4ET/5Lf7JpbVbRcFIS+T9O960mSI7UxWqZhmOy
         WjPIM9/XMcNoD5ElmpDRGGS7YVm/SHfuy0OdM2h75tKHBY2hVYX4gcvFRlizL61rWgYe
         lUzfD9dthkCx181cS99V5ACPgSpcHciCXGbTV8aVeWKhGAe/NNBiBR0TlbsCaiWUYP0B
         8gzWc2yocV7y05ndaXcwITg2cHm8NVXPqhZJ3+6xEC/DkqFLox0flM0Gx3SZkG6jGndI
         dDCoWOrn3iYiOdZ+nC/7IArWRZhLivS94SfypX7Q8uzrpkt9WD0meAJjaA/d88kmpn5j
         Lntg==
X-Gm-Message-State: AOAM531p5Xp5/1f9Y5JSy9P3fSirQQUjHRmWb0NDQJXUhF/LHJI8jTDZ
        UPdZP1sbd1ZT2pORbTHZO/n2NWGmvUEDGTuvFyI=
X-Google-Smtp-Source: ABdhPJwWs42SDt5la+BM9YL/9s7okRdULRG1K9KKVQsUWVHlUOyOv6cxOtl71XJSPfS1TLNQsEt69tIAUvZreJic54E=
X-Received: by 2002:a5d:4a02:: with SMTP id m2mr5913487wrq.154.1642116461572;
 Thu, 13 Jan 2022 15:27:41 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-2-miquel.raynal@bootlin.com> <CAB_54W7uEQ5RJZxKT2qimoT=pbu8NsUhbZWZRWg+QjXDoTPFuQ@mail.gmail.com>
 <20220113103229.64612657@xps13>
In-Reply-To: <20220113103229.64612657@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 13 Jan 2022 18:27:30 -0500
Message-ID: <CAB_54W4LCS++_BCzPu1kbSKWPC4uLzWwCSEj4CNi7-h8KOVc4w@mail.gmail.com>
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

On Thu, 13 Jan 2022 at 04:32, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:30:35 -0500:
>
> > Hi,
> >
> > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > As it is currently designed, the set_channel() cfg802154 hook
> > > implemented in the softMAC is doing a couple of checks before actually
> > > performing the channel change. However, as we enhance the support for
> > > automatically setting the symbol duration during channel changes, it
> > > will also be needed to ensure that the corresponding channel as properly
> > > be selected at probe time. In order to verify this, we will need to
> >
> > no, we don't set channels at probe time. We set the
> > current_page/channel whatever the default is according to the hardware
> > datasheet. I think this channel should be dropped and all drivers set
> > the defaults before registering hw as what we do at e.g. at86rf230,
> > see [0].
>
> Is there a reason for refusing to call ->set_channel() at probe time?
>

because the current drivers work the way to not set the channel/page
during probe time. Also the 802.15.4 spec states that this default
value is hardware specific and this goes back whatever the vendor
decides. Also you drop the check that if the same channel is already
set don't set it which works like a shadow register for registers.
Is there a reason why to set a channel during probe time? Are you
setting the value which is the default one again? If the driver has a
random default value it should choose some and stick to one, the
others do whatever the datasheet has after resetting the hardware.

I really don't see the sense here why every driver should introduce on
driver level a set channel call. At probing time the transceiver
registers are already in a state which we should reflect.

> Anyway, I'll put the symbol duration setting in the registration helper
> and I will fix hwsim aside.
>

ok, thanks.

- Alex
