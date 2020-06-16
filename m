Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1221FB5A7
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgFPPI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbgFPPI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:08:28 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E244C061573;
        Tue, 16 Jun 2020 08:08:28 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id m21so14504948eds.13;
        Tue, 16 Jun 2020 08:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ieFif6Dp7VmWzl4Uvdt66GqbDo7zg9G/ZmQz9moNnNk=;
        b=sXimB0WujoHh0iKvel/2kjQh4euBLYsaraYQMeN81sdM94prxm06OI0LH7alaMS8w0
         zorQ3PAK0c+/AuUHoa5Xk7Ly+eF3kDdr0dEuHUF02rR+ohu0T9Roy2KZEyzmBrXgRT7L
         66y+y0KyFAq0/nelHOV1leV8YFodeaxOw5jSXltFUU2LThDpiZ/2INO7wLrWFF9UoMpG
         z/l8/+c2pGVVqjhEg5RVMBTzspOJmp7K1w3rEp0YROkBibS8UQj3y0ZxXePg3mv0QSm2
         vjwPS00D4z7thPIkWlpisjoF/u9S8BbJK1vOhUhTdG8x0wZZqv/mTSHwE/Ymfjt0Gop8
         m6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ieFif6Dp7VmWzl4Uvdt66GqbDo7zg9G/ZmQz9moNnNk=;
        b=c5Z4sFi9JLbl4DQIPsmmaNooOPmac8PNvbS81MXNEuXTTQs1SbDkHDOrcDJV/JjYeF
         14yFih4i1n6jCiV4E4wEAJb6zXJ0eWBPjo0Buo225EtOmikjpzEaL9HGj+Ns5O2tTfI9
         cjAaEQ+jG6oBJtYw8TqZOmK5LcxoX3RIQ+C/BIZM+6SQdlwAUDhTls5ZR6TbA2tacsrD
         QhzKe/JItodwqO2hCAuQTsy8gTdwehBd8Avsk/DGerpDmSZI7zlNtcHuOjQ6yw8i9fgt
         nPNlBz4bu9r9dChNJ1jiSDZsR7v8Hd3SgFowelFfeBsI5c2uHMlyoTjNpFOYvFT4bhgp
         esrw==
X-Gm-Message-State: AOAM5316kj/iOhejpDBE7aoGLFOB2G2lh4cbuyoFvFEgnPq0cjoeGKmJ
        iZB8wyGg2VgOlqapfVKuDcdVvRR4R4Fu38v0rrQ=
X-Google-Smtp-Source: ABdhPJz7d/9EurY/RJVF6J327iySQLAu+gCD/whozJ5ANqq67+P17HM5kW5NPp0QF37QphDc+mmIIByFhyBDyXq6O3I=
X-Received: by 2002:a50:fb0b:: with SMTP id d11mr3097145edq.118.1592320106749;
 Tue, 16 Jun 2020 08:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200616144118.3902244-1-olteanv@gmail.com> <20200616144118.3902244-3-olteanv@gmail.com>
 <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
 <CA+h21hoz_LJgvCiVeuPTUVHN2Nu9wWAVnzz9GS2bo=y+Y1hLJA@mail.gmail.com> <d02301e1e7fa9bee3486ea8b9e3d445863bf49c8.camel@infinera.com>
In-Reply-To: <d02301e1e7fa9bee3486ea8b9e3d445863bf49c8.camel@infinera.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 18:08:15 +0300
Message-ID: <CA+h21hqyV5RMip8etVvSWpQU0scPpXDNbMJgP9piXrn1maSMbw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "madalin.bucur@oss.nxp.com" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 18:04, Joakim Tjernlund
<Joakim.Tjernlund@infinera.com> wrote:
>
> On Tue, 2020-06-16 at 17:56 +0300, Vladimir Oltean wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> >
> >
> > Hi Joakim,
> >
> > On Tue, 16 Jun 2020 at 17:51, Joakim Tjernlund
> > <Joakim.Tjernlund@infinera.com> wrote:
> > > On Tue, 2020-06-16 at 17:41 +0300, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > The dpaa-eth driver probes on compatible string for the MAC node, and
> > > > the fman/mac.c driver allocates a dpaa-ethernet platform device that
> > > > triggers the probing of the dpaa-eth net device driver.
> > > >
> > > > All of this is fine, but the problem is that the struct device of the
> > > > dpaa_eth net_device is 2 parents away from the MAC which can be
> > > > referenced via of_node. So of_find_net_device_by_node can't find it, and
> > > > DSA switches won't be able to probe on top of FMan ports.
> > > >
> > > > It would be a bit silly to modify a core function
> > > > (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> > > > just for one driver. We're just 1 step away from implementing full
> > > > recursion.
> > > >
> > > > On T1040, the /sys/class/net/eth0 symlink currently points to:
> > > >
> > > > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> > >
> > > Just want to point out that on 4.19.x, the above patch still exists:
> > > cd /sys
> > > find -name eth0
> > > ./devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> > > ./class/net/eth
> > >
> >
> > By 'current' I mean 'the net tree just before this patch is applied',
> > i.e. a v5.7 tree with "dpaa_eth: fix usage as DSA master, try 3"
> > reverted.
>
> Confused, with patch reverted(and DSA working) in 4.19, I have
>   ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> Is that the wanted path? Because I figured you wanted to change it to the path further down in this email?
>
>  Jocke
> >

Yes, this is the wanted path.
The path is fine for anything below commit 060ad66f9795 ("dpaa_eth:
change DMA device"), including your v4.19.y, that's the point. By
specifying that commit in the Fixes: tag, people who deal with
backporting to stable trees know to not backport it below that commit.
So your stable tree will only get the revert patch.

-Vladimir
