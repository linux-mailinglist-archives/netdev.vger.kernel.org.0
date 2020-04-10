Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB161A455A
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 12:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDJKq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 06:46:57 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32875 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgDJKq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 06:46:57 -0400
Received: by mail-ed1-f65.google.com with SMTP id z65so2026912ede.0
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 03:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5flDUCc5onn9My7LelOLYfg2sqbcsix70bfOQElCCY=;
        b=LK6H2vBs6EQoG8NxAHZXSN3WdX62sel9kYe6pWy8NYbKrN1wiwHV9n+fjzvFa2EVZC
         dKbcgiPgKifg/BOlyN/6G7Jqsdn3vCsorcbrjgyyYnyCVD0hDygDReY7BLMzhxWNQheV
         uYgpVnPxlUt38uU7itLT9TjuZLrJLfru6aJW2+r7mmfUexxsfFJAWDoKYF8agmqq1McO
         867t+FCK+ReI5oR8HEA0VwC3dfkdIXdq++toJj3LOWKeqx08BLwj/6yk1/0uJ3vaKR6s
         t4+i06Mp1jQj9bQurc4I2/9jPBsYw4iOBeLw7mrzjZH24jOAaXYaH//Oo7Wu+vrHGVMr
         B/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5flDUCc5onn9My7LelOLYfg2sqbcsix70bfOQElCCY=;
        b=GyrpL4joHyLmbcz9LIaKwYMxWwevJZNZHSBgBGUrzqSPs+hrs5a1mkLUQdzl+OQf8N
         r45koEbWUfr6JZ2vy0NP4f5rjS7xSZe+W6Vx6syV5CRQ1QMIXmuRChE35Fgfr+PGlUvK
         VFUr4m6A55Phw8z98i416SO0iOflzOcgSKI2/biqR6jSr/fcdEeCCRPc2xE6iJg2YSya
         OrLJBLAVoTDFTSdzPWuMF9wRPRkL8M/0/08kgQgCzQ9TsIFrCexcTdvqWNKHOuPR9tFC
         o2XrNls5JYuzLecEEopaEanU8RbPZrx05YEdViHfeQKLr79MoobWzZAH2C8oU7so28/s
         ER7Q==
X-Gm-Message-State: AGi0PuaW+/JamBk45xzP71mxopetag2CVWAGU+ZvpuPOVVTR+5gL8WxO
        fGzAkcFHEJbfb67cGBcyX+/+DtiPtVcVqqttxBI=
X-Google-Smtp-Source: APiQypLWDup2ZAK1S2IcOH0WTMLGSA4ZLAFWbXTDZbsNxTCSZqYmA8hnd16Tb6LpFY9BEm/k8vKrPTA2QvI3BAsREUA=
X-Received: by 2002:a50:9ea1:: with SMTP id a30mr4246217edf.318.1586515616603;
 Fri, 10 Apr 2020 03:46:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200409155409.12043-1-dqfext@gmail.com> <20200409.102035.13094168508101122.davem@davemloft.net>
 <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com>
 <c7da2de5-5e25-6284-0b35-fd2dbceb9c4f@gmail.com> <CALW65jZAdFFNfGioAFWPwYN+F4baL0Z-+FX_pAte97uxNK3T6g@mail.gmail.com>
In-Reply-To: <CALW65jZAdFFNfGioAFWPwYN+F4baL0Z-+FX_pAte97uxNK3T6g@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 10 Apr 2020 13:46:45 +0300
Message-ID: <CA+h21hp8LueSfh+Z8f0-Y7dTPB50d+3E3K9n6R5MwNzA3Dh1Lw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Wang <sean.wang@mediatek.com>,
        Weijie Gao <weijie.gao@mediatek.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

On Fri, 10 Apr 2020 at 05:51, DENG Qingfang <dqfext@gmail.com> wrote:
>
> On Fri, Apr 10, 2020 at 10:27 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> >
> >
> > On 4/9/2020 7:19 PM, DENG Qingfang wrote:
> > > So, since nothing else uses the mt7530_set_jumbo function, should I
> > > remove the function and just add a single rmw to mt7530_setup?
> >
> > (please do not top-post on netdev)
> >
> > There is a proper way to support the MTU configuration for DSA switch
> > drivers which is:
> >
> >         /*
> >          * MTU change functionality. Switches can also adjust their MRU
> > through
> >          * this method. By MTU, one understands the SDU (L2 payload) length.
> >          * If the switch needs to account for the DSA tag on the CPU
> > port, this
> >          * method needs to to do so privately.
> >          */
> >         int     (*port_change_mtu)(struct dsa_switch *ds, int port,
> >                                    int new_mtu);
> >         int     (*port_max_mtu)(struct dsa_switch *ds, int port);
>
> MT7530 does not support configuring jumbo frame per-port
> The register affects globally
>
> >
> > --
> > Florian

This is a bit more tricky, but I think you can still deal with it
using the port_change_mtu functionality. Basically it is only a
problem when the other ports are standalone - otherwise the
dsa_bridge_mtu_normalization function should kick in.
So if you implement port_change_mtu, you should do something along the lines of:

for (i = 0; i < MT7530_NUM_PORTS; i++) {
    struct net_device *slave;

    if (!dsa_is_user_port(ds, i))
        continue;

    slave = ds->ports[i].slave;

    slave->mtu = new_mtu;
}

to update the MTU known by the stack for all net devices.

Hope this helps,
-Vladimir
