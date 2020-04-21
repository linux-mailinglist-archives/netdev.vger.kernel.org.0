Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD931B283C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgDUNmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728337AbgDUNmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:42:52 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A09C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:42:52 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id w2so10255906edx.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YsASCIS8S3T2wPmCafkJcaiF5p7SzhXhSHfhiSWpoP4=;
        b=CtdIHa3CsBHNMgrdSkPv+1KLu2TITwESYddlAhj/S4kl3hkamyGcxvtPq6tdtF1myr
         uBIxpSIbegMtDgxai7FUrJlzUFo5qqrYvvsh44FOfqbl7K5Al3YlCjjIsd1/aB3Er6vi
         TyLHxhdeqD5ZN7hjJlolcmQJWr2b4R4LzfjzFzdjsJkvDfaRR4IgH6igewMPcN4BKMRT
         ED4gWIV9lB65GafFxETiBXby9xudrNUcbwvWxXUCFTcj73yyD28dFpogJDe8m1iFlxWa
         nDgSi7SzKk6EMmU8RJfUUBhG6Gv45JR8JjGvd1BiRk1MZk2nIiGkk4T0wuOBynmhW167
         nl0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YsASCIS8S3T2wPmCafkJcaiF5p7SzhXhSHfhiSWpoP4=;
        b=Ev2/CbzFfqH1hflGtO5Clr0AcWGhqFoh0pVNwOpE4XVuNkGwEQRHNukkioC+5duu2j
         +qZW7Ph5WyOeIr3HqmrlE3n2VZ++mc2190fhlnvZyUd4s4g90OfoNJFeD84GWah6PMej
         F5TRNcIMKqyYwg/doXppiPlSsUC56Pg2fJGVweDUmpGX5f2kqb1K2yDfg0IrY02A0U0b
         BsieocEvLTIE/fE+HUVRdisxGaNY+XHKjE5QvoU7uJKPTuSOqqp7YP3M/V9nO+cpIBue
         7YiZlZ0CW6QWrXqsWTP16iYwBd1MMJYpdW/GYnrnffk1OWfKse3WfhpRV5SI0rOYTb8/
         CHiQ==
X-Gm-Message-State: AGi0Pubokz7ki2O3mPI94VLwnb0UCR3qKKpRJekpWKQzjP+Ct1kD3mmd
        uDjUSNcM3pD3AB1eNsqgMvS2LkCEZYeY8pzZYv4=
X-Google-Smtp-Source: APiQypITDjlS27netwpinsRDIinsWee1YYxSmDNsmoWrqoBwsttHyNmhxTyY+vEeitFEAsgp46pGTj16EVmScbK+YJM=
X-Received: by 2002:a50:f288:: with SMTP id f8mr14124169edm.337.1587476570889;
 Tue, 21 Apr 2020 06:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200421123110.13733-1-olteanv@gmail.com> <20200421123110.13733-2-olteanv@gmail.com>
 <20200421133321.GD937199@lunn.ch>
In-Reply-To: <20200421133321.GD937199@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 21 Apr 2020 16:42:41 +0300
Message-ID: <CA+h21hrXJf1vm-5b3O7zQciznKF-jGSTpe_v6Mgtv8dXNOCt7g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: be compatible with DSA masters with
 max_mtu of 1500 or less
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 21 Apr 2020 at 16:33, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Apr 21, 2020 at 03:31:09PM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > It would be ideal if the DSA switch ports would support an MTU of 1500
> > bytes by default, same as any other net device. But there are 2 cases of
> > issues with trying to do that:
> >
> > - Drivers that are legitimately MTU-challenged and don't support
> >   anything larger than ETH_DATA_LEN. A very quick search shows that
> >   sungem.c is one such example - there may be many others.
> >
> > - Drivers that simply don't populate netdev->max_mtu. In that case, it
> >   seems that the ether_setup function sets dev->max_mtu to a default
> >   value of ETH_DATA_LEN. And due to the above cases which really are
> >   MTU-challenged, we can't really make any guesses.
> >
> > So for these cases, if the max_mtu of the master net_device is lower
> > than 1500, use that (minus the tagger overhead) as the max MTU of the
> > switch ports.
>
> I don't like this. I suspect this will also break in subtle ways.
>
> Please go back to the original behaviour. Make the call to request the
> minimum needed for DSA.

In what sense "minimum needed"? It is minimum needed. If
master->max_mtu is 1500, the MTU will be set to 1496.

> And don't care at all if it fails. For jumbo
> frames then you can error out.

Yes, that is patch 2/2.

>
>        Andrew

Thanks,
-Vladimir
