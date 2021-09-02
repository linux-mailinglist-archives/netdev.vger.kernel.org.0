Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281B83FE8CD
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 07:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhIBFhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 01:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhIBFh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 01:37:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B45C061575;
        Wed,  1 Sep 2021 22:36:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso639423pjb.3;
        Wed, 01 Sep 2021 22:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=AUQQWpdPusKziL81HjIpycnRSPGEY5GISL+U0MCMSmU=;
        b=JHDFf//yUkiuI37prdgWCjD9R3BX0MF++LeB2tn3JpuX+6C1q9/T+ceQvBcnpO3zhF
         KqFddP7LZ1WIza6iZtjHkx+HOkhqIrB/Jwe5jYzaAPmoO8PCY0dSbiG7rSs76H6LsE2G
         2xWEEIiFb0l4UJCSWFol0RNVwEHkXt8RseGH8qmrzmUOot+xJnb2QL7rTfy5sBb8XB83
         ReDLFc66swXyMR4O4FI20PtOmbYvqeniHo14wvYKBGZWlw7R4FxYc/IXvHakTLtRxjQu
         u3bn2PgY2puR6lUbYisAHUOxUJg+3sSrmjqmIz8NxNpRS7P0+kgm9SkUEvBdAwYdati8
         Mb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=AUQQWpdPusKziL81HjIpycnRSPGEY5GISL+U0MCMSmU=;
        b=EvlKHtNaNYRmxcgKIv4vpvvihDyjdGeE6PBLYXIq3IzhDdGj0rS8dNaN8nB1YV9KGt
         /CweHLAh10YsMJs6yZRWGlfN/TX4XrR7J7trxe87n+vWv4ZHsoM5LqQXBQ2PPqZNky3z
         Fn71jEeJ8Rv8yvzPoGgBU577dOo4jDZnbT7B38NC+ZAXiV7yxUOYxjliQNm4YtGLkiRL
         79WxaqZc/Mlu9GLK43gjYICN9GHdnZw+pzEwf+OxJwL10FzeImFcWcLucimZuNZ87tX5
         Bry+q+wYfKiFuXOvqb3PwmAmEiJz0Y+NZcdLqhaok4oF29McXcwO+2Tbiy9hyYPpmMGV
         9vbw==
X-Gm-Message-State: AOAM53091xGueyGrITHOxATb7GXp9iDl2zOdJsSCCDN8npskwJGjRYIc
        YBolGcjyBj/T5YX9/G0fVC8=
X-Google-Smtp-Source: ABdhPJxJF8LI4M1O2L1/GWavG28s+l1uKa4//ATjWdcEy8H3VklT/CtTQenaVUqvys4DN29witZiTw==
X-Received: by 2002:a17:902:7806:b0:138:1eee:c010 with SMTP id p6-20020a170902780600b001381eeec010mr1413056pll.20.1630560989012;
        Wed, 01 Sep 2021 22:36:29 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id f9sm739690pjq.36.2021.09.01.22.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 22:36:28 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone ports
Date:   Thu,  2 Sep 2021 13:36:19 +0800
Message-Id: <20210902053619.1824464-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YSi8Ky3GqBjnxbhC@kroah.com>
References: <20210824055509.1316124-1-dqfext@gmail.com> <YSUQV3jhfbhbf5Ct@sashalap> <CALW65ja3hYGmEqcWZzifP2-0WsJOnxcUXsey2ZH5vDbD0-nDeQ@mail.gmail.com> <YSi8Ky3GqBjnxbhC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 12:19:23PM +0200, Greg KH wrote:
> On Tue, Aug 24, 2021 at 11:57:53PM +0800, DENG Qingfang wrote:
> > Standalone ports should have address learning disabled, according to
> > the documentation:
> > https://www.kernel.org/doc/html/v5.14-rc7/networking/dsa/dsa.html#bridge-layer
> > dsa_switch_ops on 5.10 or earlier does not have .port_bridge_flags
> > function so it has to be done differently.
> > 
> > I've identified an issue related to this.
> 
> What issue is that?  Where was it reported?

See Florian's message here
https://lore.kernel.org/stable/20210317003549.3964522-2-f.fainelli@gmail.com/

> 
> > > 2. A partial backport of this patch?
> > 
> > The other part does not actually fix anything.
> 
> Then why is it not ok to just take the whole thing?
> 
> When backporting not-identical-patches, something almost always goes
> wrong, so we prefer to take the original commit when ever possible.

Okay. MDB and tag ops can be backported as is, and broadcast/multicast
flooding can be implemented in .port_egress_floods. 

> 
> thanks,
> 
> greg k-h
