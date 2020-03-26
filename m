Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF619351C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgCZAtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:49:04 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45504 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbgCZAtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 20:49:03 -0400
Received: by mail-ed1-f65.google.com with SMTP id u59so4923596edc.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 17:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vn1Sw/fzu6eNJMMGOtxWYx8rdQZG6RuWTyJImwOwjw=;
        b=gsg9KRFjiKn13z89wNraOd9yu6kSBQjeoW6zPP9NN/Nltc/mD0NmoiS7DVpqh6gyfg
         H3mbVFhSty/CU+ygTwuiD5uT6epMlqVRQ+UHtqqr0r73qhp6xFSm4FPAWC9NJ0732BNW
         j3l7bvL4Uo28QN1NQyh42iEuFnZ6j+QUQZlEI8NGeS5nWmxqAfe3xIOhgaM2eCfpWldq
         PPBtrSpQuWgvrMz0lmjIjXXYbtV8ZIc5Yh/glzXrRDnaUJzamTsHdB+ai7V7VNU3LvXP
         qAaaxFYmeYN7IlKbUmh+4oD9Vu1vG9Ec8HogKG3HdlBPRpZVw6vJWTjZhTVTXcu1GQt1
         QqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vn1Sw/fzu6eNJMMGOtxWYx8rdQZG6RuWTyJImwOwjw=;
        b=Z0QSvcipmGvBHpSOXUdINLzi/B9icrSYZKC3xszP1szleCjmDfVgokHy790M/PJCUi
         P7bjSywzeoi1IrkjlIFm++SNpLHt8iDU7FRD8DaAeKfhgNF41HL836GBeRG99sB2INeR
         DFvCctauYmBXSy87JnosvFDbAyVzZVSlQPXJZYLWMR0MuPvSNn7VGaJGOPSrk8KoTOlg
         gzotbVcfChe7xSTv2/SFpyYGUhzCdi6dTlA1TqtVDbj0qgsXNxSJiVffWIRHFR6G2oyT
         lJceDfy+LyWAJg2QkRs1p7DVC3CBIF0mpF4QMycIN5/eTOEphzcP3V+xQeK6dK64pd2i
         Fypw==
X-Gm-Message-State: ANhLgQ1urClh9CG4hBz1qvcIDRu3//+FBf7E9t6aOtL5x8Dc9alRwI64
        RV/wUWI0kZhG+80PY1CxCQxrdFf6i/Dx38pGRxA=
X-Google-Smtp-Source: ADFU+vvh/FsscPJsXT9hmcNZUpVqQypPljZtjN7yJ3pWQkDyx7feJ5kcnu4dohwgST6Xi5/Y67YPsfURJ/8FFKrvQ0w=
X-Received: by 2002:a50:9ea1:: with SMTP id a30mr6016866edf.318.1585183740073;
 Wed, 25 Mar 2020 17:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-7-olteanv@gmail.com>
 <2b5e3b75-bf51-3341-824f-f47feb556f67@gmail.com>
In-Reply-To: <2b5e3b75-bf51-3341-824f-f47feb556f67@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 02:48:49 +0200
Message-ID: <CA+h21hpDskX_KkCtJCM68=atwO_yJEtWh==DpKX-FnLp-sQczQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 06/10] net: dsa: b53: Add MTU configuration support
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 at 01:22, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 3/25/2020 8:22 AM, Vladimir Oltean wrote:
> > From: Murali Krishna Policharla <murali.policharla@broadcom.com>
> >
> > Add b53_change_mtu API to configure mtu settings in B53 switch. Enable
> > jumbo frame support if configured mtu size is for jumbo frame. Also
> > configure BCM583XX devices to send and receive jumbo frames when ports
> > are configured with 10/100 Mbps speed.
> >
> > Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> [snip]
>
> > @@ -658,6 +659,14 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
> >       b53_brcm_hdr_setup(dev->ds, port);
> >
> >       b53_br_egress_floods(dev->ds, port, true, true);
> > +
> > +     b53_read32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, &port_mask);
> > +
> > +     if (dev->chip_id == BCM583XX_DEVICE_ID)
> > +             port_mask |= JPM_10_100_JUMBO_EN;
> > +
> > +     port_mask |= BIT(port);
> > +     b53_write32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, port_mask);
>
> This should eventually be brought into b53_set_jumbo() where we already
> have existing logic to configure whether to accept jumbo frames and for
> 10/100M ports, too, not strictly necessary for now though:
>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

What do you mean should be done? This?

     if (!is5325(dev) && !is5365(dev))
-        b53_set_jumbo(dev, dev->enable_jumbo, false);
+        b53_set_jumbo(dev, dev->enable_jumbo, is58xx(dev));

Regards,
-Vladimir
