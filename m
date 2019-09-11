Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8D2AFF1E
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfIKOtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:49:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35675 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfIKOtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:49:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so25604375qth.2;
        Wed, 11 Sep 2019 07:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A5XOn0vC4GPgnCNAb2xJhPh7fm7Qsc3YVcoeu66V0ow=;
        b=JhSfdGDLWHQchSsKTTbaYL2d3lanGWh1bU6snzqMqlYUsbTmgquu741IO2y4CzLnnn
         xFF9+5sLDaKVVLzlMzpM5GNJHAe0EdZjfADYanypoGJBIcqS7xQozfjP/J0VtWg1MKnl
         T/6lk/ytL2NJX3N6br94MvUgja326wcjG36kI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A5XOn0vC4GPgnCNAb2xJhPh7fm7Qsc3YVcoeu66V0ow=;
        b=ff6sIchsU4uoVZRWEn9qoCOcItZquiEFzjLbiiLqY1L1A1ajNuOuxEULRzvAU92zxW
         FctkfGNuiTLZDpHbsmFAMGHeuk/BqYs00SOhJQwKuj1g9yie0oIA4PIIgdE5yWH78br4
         4xQgepGnAnoRyA4SlFOuMu5WmsLYy+Qyk9aezBlsoeY5vExg9lcDCQZCFEGcSQf25OsB
         8HPRqqO6aD6dB4iuQMUX/UCGMUNw1hIPpxz1HckScm7Kr9xt6JrrtYpTZGnLnL39S5Rh
         dfFqKlGP0wrLv+MXkeZKWNdcqilAaJDtKy0SmGyemzlkNvHA5/H0x5HcIWcQ+KauG1Ey
         DP2w==
X-Gm-Message-State: APjAAAV8OQ0bYPbvnzFdW6yWoMmhY5kANGBpuPvuDRv57vgb+we1fAbm
        FitCrox00novGB6HqTr+Llw2vl7zeYwVy6dv/Bc=
X-Google-Smtp-Source: APXvYqwWsmekgnVOZyP3ztRXLVkJUawqY8waZNluPJpoBtGqhHcgvfBOQH1tISxUZoQoAh6xx+1tOYTyMaOU7g5POGA=
X-Received: by 2002:ac8:2e94:: with SMTP id h20mr36118219qta.234.1568213346860;
 Wed, 11 Sep 2019 07:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190910213734.3112330-1-vijaykhemka@fb.com> <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
In-Reply-To: <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 11 Sep 2019 14:48:54 +0000
Message-ID: <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ben,

On Tue, 10 Sep 2019 at 22:05, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 9/10/19 2:37 PM, Vijay Khemka wrote:
> > HW checksum generation is not working for AST2500, specially with IPV6
> > over NCSI. All TCP packets with IPv6 get dropped. By disabling this
> > it works perfectly fine with IPV6.
> >
> > Verified with IPV6 enabled and can do ssh.
>
> How about IPv4, do these packets have problem? If not, can you continue
> advertising NETIF_F_IP_CSUM but take out NETIF_F_IPV6_CSUM?
>
> >
> > Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
> > ---
> >  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 030fed65393e..591c9725002b 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -1839,8 +1839,9 @@ static int ftgmac100_probe(struct platform_device *pdev)
> >       if (priv->use_ncsi)
> >               netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> >
> > -     /* AST2400  doesn't have working HW checksum generation */
> > -     if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
> > +     /* AST2400  and AST2500 doesn't have working HW checksum generation */
> > +     if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
> > +                of_device_is_compatible(np, "aspeed,ast2500-mac")))

Do you recall under what circumstances we need to disable hardware checksumming?

Cheers,

Joel

> >               netdev->hw_features &= ~NETIF_F_HW_CSUM;
> >       if (np && of_get_property(np, "no-hw-checksum", NULL))
> >               netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
> >
>
>
> --
> Florian
