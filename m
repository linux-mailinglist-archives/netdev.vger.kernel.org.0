Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B591CF327
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 13:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgELLOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 07:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728990AbgELLOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 07:14:02 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941B6C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 04:14:02 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id m12so16369376wmc.0
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 04:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J53A2b/1yUWW32nHPsmB6WD0J2SPCqm5lWFvLDbE1h8=;
        b=wgYOLpRaW4Jgx0y5aKDAVrT4nujie0CI15geYyrNEyiJiT36aN9RSbFpmBIzAJU55G
         IpjipHZZs5pMfdOvJ44oGlgkSWXIhSVHPeMRnfllDxWjGAIZejqZgGQdQNMiabC62dD7
         taBuzCCKhAtPIAq3cfykmUDdLfd9XpC6G37XmG9v+nIM+N8nzeUlmbkXFCvDhWgXnb6H
         uVMeReJvZUYVPAgF5M/XtaxMJwALV3pfknajlUcRHeAp80MpVQxSgTjio9IsjgiS2xbk
         ys3OXFDPp34yyinEkCUJEPjiYSXVUu5I4kv22Ayh+TrFBXbUS6aQqS3JMZct6NPgAtUc
         G4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J53A2b/1yUWW32nHPsmB6WD0J2SPCqm5lWFvLDbE1h8=;
        b=CXRdNXSTjyaleb/Lz+ngqALzzo24iAz+xBHDUihUWB8hmGsHflTEtIWoVdwBqlFhlL
         MPdp2yT4xYiyiyC7QMFQclaExmeXhuVZ4B0h1fB3R6vZWk3J8FeU03h7AD2Hhwt4T18k
         xkzRsCUZGlCu+d9kafi1La64GjKMDilCbsfVuN8QPgWF3+Al0s9FKGU/W/dWYUbgZ6l4
         Yf0v8+luKWO48daHPdMQEFwglJUmLpsiuREuT3iUdSkuSdIwfYEgsXZQiO6QTymz3pLP
         Y92nGFMzsoxLM6t31GqtMay6pWHRzw9kTPOvpojx0vobRFbuM9pk35sB2NOw4fZ4zi2B
         2AxQ==
X-Gm-Message-State: AOAM533ThWFCnN7O6ymWiO4YbxyBJ0KJYyrmaCeB7e3sBNsOu8lKRuHE
        0+PN4IMluQ9c4/YItm937T8dPJriZLg=
X-Google-Smtp-Source: ABdhPJyLYnkuMOvsj6jCZTjMy1q/N9lPW9RvMXe/HqoK9DH4qlMVaplyT/+ku+Clabemj8FPzMMwJg==
X-Received: by 2002:a05:600c:2153:: with SMTP id v19mr611524wml.13.1589282041344;
        Tue, 12 May 2020 04:14:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f123sm17974431wmf.44.2020.05.12.04.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 04:14:00 -0700 (PDT)
Date:   Tue, 12 May 2020 13:13:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200512111359.GN2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511125723.GI2245@nanopsycho>
 <20200511192422.GH25096@plvision.eu>
 <20200512055536.GM2245@nanopsycho>
 <20200512071552.GA17235@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512071552.GA17235@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 12, 2020 at 09:15:52AM CEST, vadym.kochan@plvision.eu wrote:
>On Tue, May 12, 2020 at 07:55:36AM +0200, Jiri Pirko wrote:
>> Mon, May 11, 2020 at 09:24:22PM CEST, vadym.kochan@plvision.eu wrote:
>> >On Mon, May 11, 2020 at 02:57:23PM +0200, Jiri Pirko wrote:
>> >> [...]
>> >> 
>> >> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
>[...]
>> >> >+netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct sk_buff *skb)
>> >> >+{
>> >> >+	struct device *dma_dev = sdma->sw->dev->dev;
>> >> >+	struct prestera_tx_ring *tx_ring;
>> >> >+	struct net_device *dev = skb->dev;
>> >> >+	struct prestera_sdma_buf *buf;
>> >> >+	int err;
>> >> >+
>> >> >+	tx_ring = &sdma->tx_ring;
>> >> >+
>> >> >+	buf = &tx_ring->bufs[tx_ring->next_tx];
>> >> >+	if (buf->is_used) {
>> >> >+		schedule_work(&sdma->tx_work);
>> >> >+		goto drop_skb;
>> >> >+	}
>> >> 
>> >> What is preventing 2 CPUs to get here and work with the same buf?
>> >
>> >I assume you mean serialization between the recycling work and xmit
>> >context ? Actually they are just updating 'is_used' field which
>> 
>> No.
>> 
>> >allows to use or free, what I can see is that may be I need to use
>> >something like READ_ONCE/WRITE_ONCE, but the rest looks safe for me:
>> >
>> >1) recycler updates is_used=false only after fully freeing the buffer,
>> >and only if it was set to true.
>> >
>> >2) xmit context gets next buffer to use only if it is freed
>> >(is_used=false), and sets it to true after buffer is ready to be sent.
>> >
>> >So, yes these contexts both update this field but in strict sequence.
>> >
>> >If you mean of protecting of xmit on several CPUS so, the xmit should be
>> >serialized on kernel, and the driver uses one queue which (as I
>> >underand) is bound to particular CPU.
>> 
>> How is it serialized? You get here (to prestera_sdma_xmit()) on 2 CPUs
>> with the same sdma pointer and 2 skbs.
>> 
>
>My understanding is:
>
>dev_hard_start_xmit is the entry function which is called by the
>networking layer to send skb via device (qos scheduler, pktgen, xfrm,
>core - dev_direct_xmit(), etc).
>
>All they acquire the HARD_TX_LOCK which locks particular tx queue. And
>since the driver uses one tx queue there should be no concurrent access
>inside ndo_start_xmit, right ?

Ah, correct. I didn't realize you have 1:1 mapping. Thanks for
explanation!
