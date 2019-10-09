Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2DAD177A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJISVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 14:21:18 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39916 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfJISVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 14:21:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id a15so2944178edt.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHkBccBcnNHpwY488jaSLlc6fd4IiAVQm1KLgC1eDwU=;
        b=JCk2r4lLdEAtEB4tPPfCe4gQXtDKOAj/uTZqZjswgMEGnPOS15TmojLgEWg9okNphe
         AeJnUULN6KjIa4KZEVZaBHInQ1eDypGuDBuuyCdSKoyR8ZJPKDBhIppH6HpDS4jkxN3n
         kcMVYBHYnDz8YP8O4Zob+eAVkuCmR6JaDum4JOPgVXcl9MnHTqhIHFafpcVv4abD2wWR
         XhjBxJiSQ7LAYLN62EhUspq0sCkoYw6oz4VleeqTj9068qJZxY9Q6sgL/WOP8KzdYWgv
         C6zpWOY2j/ctW270naKNeT19e7aMwPErIi8lSgRqOyd1wljb37pqea7d/hBhHPsXd0FJ
         Gusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHkBccBcnNHpwY488jaSLlc6fd4IiAVQm1KLgC1eDwU=;
        b=jO8WZIRdi88dOD4wEf8rPg2kaWgKVilV/5tAS/A/vnoE0XJYDhRy4jBJKxAyqSe5Rf
         gYHOyDHAvgsq+z1TycDXVQIGc/LNLmxTAZOI2X65lzkd5mKy6yz9z/76dcC7aaItrUb8
         kEld2Q48cOkQD5IMSE4NGpeFqW9+KNx9B4BRF8jOxy1f+/LaeJEVFxyo4OdWeB4ixaik
         Wu5e1RxOSc1iRrJVTBpmqblJJWj0UR1nEOciPFHesUAsVABQJ5c8UPx3NEoIt0qxKO4y
         UJjJtA7vSrMKy6ysAldH8Npn/bAfQVB4OqASOPko8iakXSHEmwS2d8kDsaSVCLOvWueX
         n+uw==
X-Gm-Message-State: APjAAAXyBgmnWr212Yhp6H8e2IMqqupDAnAqqk32ebqxHvhjg0Xf7bi/
        nqB+7pvk0bdRA0zDaHXovMCkCpbpcr0FgP5jKjycuw==
X-Google-Smtp-Source: APXvYqyzM1iml8cc0UJCa2V8V1tcCpmvzYZc9tBdwMkMDxZm3liqXHTP04Gsb9J6GSLo1BKLFmmGm3WCshLGV92hV3Y=
X-Received: by 2002:aa7:d04c:: with SMTP id n12mr4125274edo.52.1570645276110;
 Wed, 09 Oct 2019 11:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190910213734.3112330-1-vijaykhemka@fb.com> <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com> <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
In-Reply-To: <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
From:   Oskar Senft <osk@google.com>
Date:   Wed, 9 Oct 2019 14:20:59 -0400
Message-ID: <CABoTLcQ=N4ugYeo5jxbGtBR0nbu_Ri-OV4pE0PP-yvwXX7W+uw@mail.gmail.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Joel Stanley <joel@jms.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        netdev@vger.kernel.org,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vijay Khemka <vijaykhemka@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does HW in the AST2500 actually perform the HW checksum calculation,
or would that be the responsibility of the NIC that it's talking to
via NC-SI?

(Sorry for the double posting! I had HTML mode enabled by default
which causes the e-mail to be dropped in some places)


On Wed, Oct 9, 2019 at 12:38 AM Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> On Wed, 2019-09-11 at 14:48 +0000, Joel Stanley wrote:
> > Hi Ben,
> >
> > On Tue, 10 Sep 2019 at 22:05, Florian Fainelli <f.fainelli@gmail.com>
> > wrote:
> > >
> > > On 9/10/19 2:37 PM, Vijay Khemka wrote:
> > > > HW checksum generation is not working for AST2500, specially with
> > > > IPV6
> > > > over NCSI. All TCP packets with IPv6 get dropped. By disabling
> > > > this
> > > > it works perfectly fine with IPV6.
> > > >
> > > > Verified with IPV6 enabled and can do ssh.
> > >
> > > How about IPv4, do these packets have problem? If not, can you
> > > continue
> > > advertising NETIF_F_IP_CSUM but take out NETIF_F_IPV6_CSUM?
> > >
> > > >
> > > > Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
> > > > ---
> > > >  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > > > b/drivers/net/ethernet/faraday/ftgmac100.c
> > > > index 030fed65393e..591c9725002b 100644
> > > > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > > > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > > > @@ -1839,8 +1839,9 @@ static int ftgmac100_probe(struct
> > > > platform_device *pdev)
> > > >       if (priv->use_ncsi)
> > > >               netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> > > >
> > > > -     /* AST2400  doesn't have working HW checksum generation */
> > > > -     if (np && (of_device_is_compatible(np, "aspeed,ast2400-
> > > > mac")))
> > > > +     /* AST2400  and AST2500 doesn't have working HW checksum
> > > > generation */
> > > > +     if (np && (of_device_is_compatible(np, "aspeed,ast2400-
> > > > mac") ||
> > > > +                of_device_is_compatible(np, "aspeed,ast2500-
> > > > mac")))
> >
> > Do you recall under what circumstances we need to disable hardware
> > checksumming?
>
> Any news on this ? AST2400 has no HW checksum logic in HW, AST2500
> should work for IPV4 fine, we should only selectively disable it for
> IPV6.
>
> Can you do an updated patch ?
>
> Cheers,
> Ben.
>
