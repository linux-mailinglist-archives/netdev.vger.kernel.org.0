Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348341A7779
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437697AbgDNJiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbgDNJiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:38:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CD7C0A3BD0
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 02:38:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i7so16222198edq.3
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 02:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l0sElnDfI+ZyVqRL2zYk64+Rr5oxxTVwp3ecCT2n+44=;
        b=fRoNYYXgsYeuzWQ+HuHIHEIb0CJmAFKpi8LpRXp1aRZ3t4CwZ24F+lFJyRSChsga8d
         0RL1mAR8XVHFIB51ZXSaNECRtUUYmf4RKAIenb5FnVjVueDd55pqoTxU7UHPqYPK/PIz
         xxfKSFuNIacBncU7uq5dbgtnwyVHeNwOg0kjCZNetmo+SvXbQ2TsRhjygeJ6lb4UVI+m
         LyEVcQQRReWzT715iLOCp11oxeUhwatvshzXJHqr0W4dzPqMwYwaz1ov9+QjCkzlBcGi
         gw3ByE0ULyOq1SmwFREy8iYjSiBo1n+uFPXbSLTg4h9Ew2ZTJ/rrgPUC7pUQjc/UuF3m
         9tvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l0sElnDfI+ZyVqRL2zYk64+Rr5oxxTVwp3ecCT2n+44=;
        b=Iba5aEAIvStuDLsETusD1EYKlqaPSaebAldh5+/cAlXbZ52YVOo0MZVHAutxzFxcud
         Bh7blgb3bh/zU7uD282yvroETGlJWdYRh9fM3yzExobpnL8C4RQyEIzuyGb2Y8aVE94C
         JtQEaXK70vVYsT39ZGNYDGtcb/a1lx1n7AyB2ErL/4bqGmInMs0yX9lDAXXDTq8R1RLq
         ZLTPyf+GtfqZd+FDzv6x98rKtVFBzA08LVhVvVtmdVSVyh4Pd7Bv0GqvgJzDPpqNGlpq
         YCQzjGI5WIV+fuQw+oOperoszsnIZxUDdxHIXtSo1A1fcf7eaLfbTJiA4b7oqUqfXqhS
         QevA==
X-Gm-Message-State: AGi0PuYg4xOFRzAwa4EsengxKjGoadhiN2gkD/KMEBlmAHRFk2Sn5Ke+
        lafyRjyei/9QcEpEPw4zYMPA6EfAL34wSFGr3lHtvQ==
X-Google-Smtp-Source: APiQypLOFsfGeYYJBkzEXQ8z9r10aKGeqkfdbpSDChp49Ujn1YdohXhW0v0idRXsv053tn2H2ERXDjBmTnw/hdtIFdA=
X-Received: by 2002:a17:906:78c:: with SMTP id l12mr2415056ejc.189.1586857097322;
 Tue, 14 Apr 2020 02:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200409155409.12043-1-dqfext@gmail.com> <20200409.102035.13094168508101122.davem@davemloft.net>
 <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com>
 <c7da2de5-5e25-6284-0b35-fd2dbceb9c4f@gmail.com> <CALW65jZAdFFNfGioAFWPwYN+F4baL0Z-+FX_pAte97uxNK3T6g@mail.gmail.com>
 <CA+h21hp8LueSfh+Z8f0-Y7dTPB50d+3E3K9n6R5MwNzA3Dh1Lw@mail.gmail.com> <CALW65jYodd=GoWrGTcAWEO6wNQdvSQjgO=4tmNYNnmbCh7n8sg@mail.gmail.com>
In-Reply-To: <CALW65jYodd=GoWrGTcAWEO6wNQdvSQjgO=4tmNYNnmbCh7n8sg@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 14 Apr 2020 12:38:06 +0300
Message-ID: <CA+h21hrR-vs=iMHYTzYTHrXJaEQqONdSzGt5mOgTq6G=VhK=GA@mail.gmail.com>
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

On Tue, 14 Apr 2020 at 06:03, DENG Qingfang <dqfext@gmail.com> wrote:
>
> On Fri, Apr 10, 2020 at 6:46 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi Qingfang,
> >
> > On Fri, 10 Apr 2020 at 05:51, DENG Qingfang <dqfext@gmail.com> wrote:
> > >
> > > On Fri, Apr 10, 2020 at 10:27 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > > >
> > > >
> > > >
> > > > On 4/9/2020 7:19 PM, DENG Qingfang wrote:
> > > > > So, since nothing else uses the mt7530_set_jumbo function, should I
> > > > > remove the function and just add a single rmw to mt7530_setup?
> > > >
> > > > (please do not top-post on netdev)
> > > >
> > > > There is a proper way to support the MTU configuration for DSA switch
> > > > drivers which is:
> > > >
> > > >         /*
> > > >          * MTU change functionality. Switches can also adjust their MRU
> > > > through
> > > >          * this method. By MTU, one understands the SDU (L2 payload) length.
> > > >          * If the switch needs to account for the DSA tag on the CPU
> > > > port, this
> > > >          * method needs to to do so privately.
> > > >          */
> > > >         int     (*port_change_mtu)(struct dsa_switch *ds, int port,
> > > >                                    int new_mtu);
> > > >         int     (*port_max_mtu)(struct dsa_switch *ds, int port);
> > >
> > > MT7530 does not support configuring jumbo frame per-port
> > > The register affects globally
> > >
> > > >
> > > > --
> > > > Florian
> >
> > This is a bit more tricky, but I think you can still deal with it
> > using the port_change_mtu functionality. Basically it is only a
> > problem when the other ports are standalone - otherwise the
> > dsa_bridge_mtu_normalization function should kick in.
> > So if you implement port_change_mtu, you should do something along the lines of:
> >
> > for (i = 0; i < MT7530_NUM_PORTS; i++) {
> >     struct net_device *slave;
> >
> >     if (!dsa_is_user_port(ds, i))
> >         continue;
> >
> >     slave = ds->ports[i].slave;
> >
> >     slave->mtu = new_mtu;
> > }
> >
> > to update the MTU known by the stack for all net devices.
> Should we warn users that all ports will be affected?
> >
> > Hope this helps,
> > -Vladimir

Unless I'm missing something, all ports are affected anyway, so
changing the MTU _is_ informing users that all switch ports are
affected.

Thanks,
-Vladimir
