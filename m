Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B854871BF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiAGEV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiAGEV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:21:58 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C619C061245;
        Thu,  6 Jan 2022 20:21:58 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e9so7161341wra.2;
        Thu, 06 Jan 2022 20:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9u+7b7Y8JEzmUJuxanRH3UmSulxRrobTg+ag4bjnWQ=;
        b=S9AjBDtiMJBKSy2Uy9lo85nOPo3XxXmZt2xcCGAChsLMVsFaimDH0GfJuNFi2e8eH3
         pt8yGgEh2hyj+hFaBCEoM/R80/vxdpPANc/ijkVzxHj+7vrDIhZo5rLnP9SP0g4i7m0c
         EuhNOqoWR000tvcbGnTAEaIgT2VpyKqtix3iYvbSM8emBl1MzEW8HBpihosUfHmeenaz
         Rcx2OtVSWMXv98BJQ0R7vJiUN47GeTKSXRZl301u2CN8qsBiFu/cwKH4LCAVoYCON6b7
         5M8mkeG1SwlxVkksma+I/wzfndohUJuql/Mt3fOF0o4iEOkvXI13pZER8J6TETJsox7n
         0wjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9u+7b7Y8JEzmUJuxanRH3UmSulxRrobTg+ag4bjnWQ=;
        b=o2EKxFiWUveu613Ej/F1a+6Ziat87jZPABLAHlXJTiN5u8ukNsd/nl1OyJHqk3HpQX
         jbIKUbjYv9ORQ58iW6vTqrspQqRE+K++FZ+5vC3YuWnafZtURMgR72UcNgfKdjToysXF
         sc78UXCMXDLb96adislGl7BM88TulPh2GL2cEfubFUY2GXrK+AR1fHMSVmWMJKLNDGC3
         KdCR1msjHQ8d20EbfhDs+Fvgid8H8MDYvssQ9L/wrN/K1MjiKXMDSlx1t21GXQMmCoyT
         9eVNW0i984FWu+TZHyCMudkuChR3YPlncTWSp+gel0QYp9tCAUhWhnG23x6EnvNxonFY
         ZxPA==
X-Gm-Message-State: AOAM533bwOQ72vXlxIgDKnA9ZIfBUMrFtVPEnUwWPIUOk9GOAbE9iYqW
        G6aAJWQp8hQaCBKOhMWXEK76f8MdvRIsQfs5n4g31bTkePk=
X-Google-Smtp-Source: ABdhPJyGlN9KZOIWTPTJEUZW91PfVhVCpomk78Rt4q5CkxF4y461hk30Lh6K5Sd64jeb7CbHuqA2WsqfXFIjC8+Vkh8=
X-Received: by 2002:adf:e190:: with SMTP id az16mr7884177wrb.207.1641529317043;
 Thu, 06 Jan 2022 20:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-18-miquel.raynal@bootlin.com> <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
 <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
 <CAB_54W6ikdGe=ZYqOsMgBdb9KBtfAphkBeu4LLp6S4R47ZDHgA@mail.gmail.com>
 <20220105094849.0c7e9b65@xps13> <CAB_54W4Z1KgT+Cx0SXptvkwYK76wDOFTueFUFF4e7G_ABP7kkA@mail.gmail.com>
 <20220106201526.7e513f2f@xps13>
In-Reply-To: <20220106201526.7e513f2f@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 6 Jan 2022 23:21:45 -0500
Message-ID: <CAB_54W7=YJu7qJPcGX0O6nkBhmg7EmX2iTy+Q+EgffqE5+0NCQ@mail.gmail.com>
Subject: Re: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     David Girault <David.Girault@qorvo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Frederic Blain <Frederic.Blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 6 Jan 2022 at 14:15, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 5 Jan 2022 19:23:04 -0500:
>
...
> >
> > A HardMAC driver does not use this driver interface... but there
> > exists a SoftMAC driver for a HardMAC transceiver. This driver
> > currently works because we use dataframes only... It will not support
> > scanning currently and somehow we should make iit not available for
> > drivers like that and for drivers which don't set symbol duration.
> > They need to be fixed.
>
> My bad. I did not look at it correctly. I made a mistake when talking
> about a hardMAC.
>
> Instead, it is a "custom" low level MAC layer. I believe we can compare
> the current mac802154 layer mostly to the MLME that is mentioned in the
> spec. Well here the additional layer that needs these hooks would be
> the MCPS. I don't know if this will be upstreamed or not, but the need
> for these hooks is real if such an intermediate low level MAC layer
> gets introduced.
>
> In v2 I will get rid of the two patches adding "driver access" to scans
> and beacons in order to facilitate the merge of the big part. Then we
> will have plenty of time to discuss how we can create such an interface.
> Perhaps I'll be able to propose more code as well to make use of these
> hooks, we will see.
>

That the we have a standardised interface between Ieee802154 and
(HardMAC or SoftMAC(mac802154)) (see cfg802154_ops) which is defined
according the spec would make it more "stable" that it will work with
different HardMAC transceivers (which follows that interface) and
mac802154 stack (which also follows that interface). If I understood
you correctly.
I think this is one reason why we are not having any HardMAC
transceivers driver supported in a proper way yet.

I can also imagine about a hwsim HardMAC transceiver which redirects
cfg802154 to mac802154 SoftMAC instance again (something like that),
to have a virtual HardMAC transceiver for testing purpose, etc. In
theory that should work...

- Alex
