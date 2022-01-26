Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD6D49D5C0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiAZWyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiAZWyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:54:23 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784CEC06161C;
        Wed, 26 Jan 2022 14:54:22 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a13so1479428wrh.9;
        Wed, 26 Jan 2022 14:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PO1dIhcK60bQr+pge6rKhddGGc1Umwp4/+oDuyEDXSI=;
        b=ZFzTBZzbOAtfDtGH4MBTICabaIhl1FSZqzEAkUCFUnUvRzrP+/g5GdCqvKhh5QOBsb
         qOpyRjIoR6YKO2j19K4wzAeRnvncXocI3MUJo5esQpKhk/hYQE4XMLNOvAn1Bm8QQhbx
         rjc+5L/ZnwlRL/zT244lIyFOu4t88MVBENgDc1s1d22Ht3Rce9PwN784jEmrdORJHMRV
         UMwt1BEJkhLdh+40qFoYXesj21d2Bx+AYj/7cPz+npnjsLOHSs7psKiZVsJPW7lwHIrn
         o4tY9O2Nasr1gfaz0IxFybokJlEMaVPI8vdrt4QIVg6XfiunFEoMSwQNLEtqDg8h0T9c
         XoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PO1dIhcK60bQr+pge6rKhddGGc1Umwp4/+oDuyEDXSI=;
        b=jyrY/apob9sv214Hu3If1bApsEN5wBy/09nYoiJdxd0aGhv2plWpqZE2KOGRXMx5qi
         x02yu3LAvqWXo8QJIVj3VHbi9hMYaE00XeMqbfrEABwpT0cJppn9i78omm+YjToi8MAK
         gneU/ubcTG6XPxAkeq1x+btUkGc6gbNzdhXhg0y6Z+sChGOoYxQlVtVrqTp4RH3rTmg1
         K40bI0WjGXCEINDObpt/1SO1tzjVF9kXPjpIBebDdvL0ZuTJh0fs0b5HNhqETk4sCYwe
         p+s29NHl0euG018WtvOybLPjMNg1jAk0XvJTGspNl0E/3RpPDnpb/bNEK/sefx/0+skK
         B9Dg==
X-Gm-Message-State: AOAM530nWLYfjrj9/aB418SfhzCwj7GJUPzdhzFxBpX/KcrYPWDd6NOD
        0J0yqPdmWLUBJSLGTD717n2t+l3W4ER9ObjsV6tjInzYu50=
X-Google-Smtp-Source: ABdhPJyv0J32NQEuhg3Bnxr+Dsw0ak4P+L+cAPmuyZibn+/XjzX+cnEJrSWpd5sKtbI+vCeDtz5niG06i1jImqp1kHE=
X-Received: by 2002:adf:cc88:: with SMTP id p8mr590930wrj.207.1643237660944;
 Wed, 26 Jan 2022 14:54:20 -0800 (PST)
MIME-Version: 1.0
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
 <20220125121426.848337-2-miquel.raynal@bootlin.com> <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
 <20220125174849.31501317@xps13> <89726c29-bf7d-eaf1-2af0-da1914741bec@datenfreihafen.org>
In-Reply-To: <89726c29-bf7d-eaf1-2af0-da1914741bec@datenfreihafen.org>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 26 Jan 2022 17:54:09 -0500
Message-ID: <CAB_54W4TGvLeXdKLpxDwTrt4a19WPtSWDXq7kX4i-Ypd6euLnQ@mail.gmail.com>
Subject: Re: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jan 26, 2022 at 8:38 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
>
> Hello.
>
> On 25.01.22 17:48, Miquel Raynal wrote:
> > Hi Stefan,
> >
> > stefan@datenfreihafen.org wrote on Tue, 25 Jan 2022 15:28:11 +0100:
> >
> >> Hello.
> >>
> >> On 25.01.22 13:14, Miquel Raynal wrote:
> >>> Drivers are expected to set the PHY current_channel and current_page
> >>> according to their default state. The hwsim driver is advertising being
> >>> configured on channel 13 by default but that is not reflected in its own
> >>> internal pib structure. In order to ensure that this driver consider the
> >>> current channel as being 13 internally, we at least need to set the
> >>> pib->channel field to 13.
> >>>
> >>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> >>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> >>> ---
> >>>    drivers/net/ieee802154/mac802154_hwsim.c | 1 +
> >>>    1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> >>> index 8caa61ec718f..00ec188a3257 100644
> >>> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> >>> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> >>> @@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >>>             goto err_pib;
> >>>     }
> >>>    > +      pib->page = 13;
> >>
> >> You want to set channel not page here.
> >
> > Oh crap /o\ I've messed that update badly. Of course I meant
> > pib->channel here, as it is in the commit log.
> >
> > I'll wait for Alexander's feedback before re-spinning. Unless the rest
> > looks good for you both, I don't know if your policy allows you to fix
> > it when applying, anyhow I'll do what is necessary.
>
> If Alex has nothing else and there is no re-spin I fix this when
> applying, no worries.

Everything is fine.

Acked-by: Alexander Aring <aahringo@redhat.com>

On the whole series. Thanks.

- Alex
