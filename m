Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15A63E5ACD
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbhHJNPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhHJNPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:15:20 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E79FC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:14:58 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b7so30225489edu.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k8KPa8wUqbHL2sNHrpvn5Glgkqp7NU8IRQvthgqc8ns=;
        b=OBBEycdekfcK3BAK/ys/s8dRKYLizy6kHHCrwK3rAMSuVUtVwVY2gnHuydeeNSm4EV
         W44EKwJy1rDlNlDC5Li+3zxo1T/B5utCo1P1MiGAZ7W+pkNQBEi3RkELIqQMmR8yFcHg
         GEgDertmZsm82cDyUjIlB4wXcoSOM0DJHgPn4XaMCXjfYSZ+tuFyLnsmRndtl7c1SZDy
         IUQcHnJjLR5gGBJucajuoblWz+3qVYJNQwYpFYa9NFcnQumQ0Rg508KyyucRlNmEUYUK
         LQxuKf+Z1rfYBGvXVx1dPgkKmkrxCvlk5UC/t7BjUwFOSrAFg4XgP0sgwFiqgvFGn0Ss
         mIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k8KPa8wUqbHL2sNHrpvn5Glgkqp7NU8IRQvthgqc8ns=;
        b=r2EIfoJJIGjRJwc307GJrNawHm7eiz+kyOWZMrKevsn9p3ntgfWYaKeaWDnTbzA+HC
         qPCSkjOuDEFmdGG57YAwWIocElpQXIwDGKkxLB89+jPMcxznHxdIpdAXqLXBKJCDsNPy
         Hb6dp6LwNGOU59MV/5IEtV3dhwU8YBPUhlcPzCZakzEpGjdXsJ+QFYGLH9Vy0o2BhaLW
         Pt8jzUE9f+wMOSyTIGpCvvRk9SCjjogIiQPfCdQcYXBSsbn5pvaBRuNASLU7ZC0k3s6+
         ODJL/+UzQYvw8wAGQNEu55NDbQuZAP7QrBPuiBoDOI+PtHnxXHFdpIHVfUAdPyk1E1Xl
         Nxhw==
X-Gm-Message-State: AOAM5326wvYgPVIBzxmmcO5Xz98MNLI0OmcqulyRjl7k0+4RrT8Waktu
        tcfA1FROmLkeS7C1x0k5snA=
X-Google-Smtp-Source: ABdhPJxqt7VOYKQwWlUQy52vaQ+KeYURQzlC3zq5CEkPfRMYFPMdxE7m8BWZR/XbgYmhfaSUjlB6ZA==
X-Received: by 2002:a05:6402:26c6:: with SMTP id x6mr5060572edd.175.1628601297061;
        Tue, 10 Aug 2021 06:14:57 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id g26sm3214293ejr.48.2021.08.10.06.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 06:14:56 -0700 (PDT)
Date:   Tue, 10 Aug 2021 16:14:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: dsa: b53: express
 b53_for_each_port in terms of dsa_switch_for_each_port
Message-ID: <20210810131454.ytfcepfenttc357n@skbuf>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-5-vladimir.oltean@nxp.com>
 <f7de1977-d13e-d6cd-f25e-17eeea294b96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7de1977-d13e-d6cd-f25e-17eeea294b96@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:39:08AM -0700, Florian Fainelli wrote:
> On 8/9/2021 12:03 PM, Vladimir Oltean wrote:
> > Merging the two allows us to remove the open-coded
> > "dev->enabled_ports & BIT(i)" check from b53_br_join and b53_br_leave,
> > while still avoiding a quadratic iteration through the switch's ports.
> > 
> > Sadly I don't know if it's possible to completely get rid of
> > b53_for_each_port and replace it with dsa_switch_for_each_available_port,
> > especially for the platforms that use pdata and not OF bindings.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We should really be able to eliminate b53_for_each_port() entirely, let me
> try to submit a patch doing that when I come back from vacation or you can
> do it, and if there are bugs, I will address them.

I will let you do it when you come back, until then I believe the
existing conversion has a fairly low risk of introducing any bugs.
