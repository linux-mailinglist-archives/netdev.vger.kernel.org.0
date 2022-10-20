Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB51B6061BB
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJTNfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiJTNfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:35:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8487EEA9A;
        Thu, 20 Oct 2022 06:35:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r17so47410661eja.7;
        Thu, 20 Oct 2022 06:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6W8i9o8o3JEGbLuSjyxc6XgXvQsYfIY429ZrCGIGH7A=;
        b=LT6l9n3GBTcSQvOt/Zkq2tCDu4edixzNqa/k2gkqkki+ohFuVM0AsUxiNrQDPuQ9dp
         B8LzUHG6JrjRQj4yo+Fwtsf2X3kIvJkaCeWMmiC9fn/wkKNB9HLSlhiilFT9xxo2Q0Ih
         HVR2Qu+RkqbyPNfTZMGYM8QuIDe2OXDl1NiUSgEQw4kpsBwGGTf7cdDbkST3rJPXldCJ
         jyEqdtUxCuylTDY808GKyiUgzYWXGtEZgj/ZGKEFBlt5lPjfOcKiZQzgZ3JhNwwsKskM
         g5Jte+zUA232UjbG0/dLOu5ZfzViovNPhkJSQ9NdfP82wKAyVo5fcwzQMVmg/eq3Labc
         enPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6W8i9o8o3JEGbLuSjyxc6XgXvQsYfIY429ZrCGIGH7A=;
        b=FAoUcQavQYWUGfAv0gXIQ8l9X2LEWB2PDlXVIl0Q10DO/w1IpxTYuBVkhgaZCCdcZE
         mVUT3an9q77I/DJxWWBFs5jI4Nzxo133lYmgXxF1e7tePoS70Cpcm3QzgAwQmnTPxAzv
         tIuZW7cXQHfr0kBC2JzWxCZkcR1SgeSUZM5pUm6evVodYha39H89wiShLgSaf2WqHxcH
         zCgCm8UfEl2NS8r0OHbQ7e5O8rTYd74utXmHv8odKbF1k/93ixOkIO8NYGxtuXulhCZX
         CEZpe5eU0up6K+MM6LLRX+oJnMUmVVXBIKA5LD5GjdvLjfRZJ6//N4XJfKagw/1jcIYj
         EeSQ==
X-Gm-Message-State: ACrzQf3o5PVuEPPD6kbrXIwwLWuB0T4brUJcz0Wg+ebZTjInC0Tjfu4c
        u2AGSsVKCIqSoASS4Jsml3U=
X-Google-Smtp-Source: AMsMyM6f3BkbQSlnxpGOl1q4sqOax51EJCundMlge5h6nlzLLygpGchZIAl/FmUda0BaXUPlLWUgAg==
X-Received: by 2002:a17:907:b0b:b0:78d:8877:9f9e with SMTP id h11-20020a1709070b0b00b0078d88779f9emr10889846ejl.693.1666272910757;
        Thu, 20 Oct 2022 06:35:10 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id rp7-20020a170906d96700b00730bfe6adc4sm10390698ejb.37.2022.10.20.06.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 06:35:09 -0700 (PDT)
Date:   Thu, 20 Oct 2022 16:35:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <20221020133506.76wroc7owpwjzrkg@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1FMAI9BzDRUPi5Y@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 04:24:16PM +0300, Ido Schimmel wrote:
> On Thu, Oct 20, 2022 at 04:02:24PM +0300, Vladimir Oltean wrote:
> > On Tue, Oct 18, 2022 at 06:56:12PM +0200, Hans J. Schultz wrote:
> > > @@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > >  	struct dsa_port *dp = dsa_slave_to_port(dev);
> > >  	bool host_addr = fdb_info->is_local;
> > >  	struct dsa_switch *ds = dp->ds;
> > > +	u16 fdb_flags = 0;
> > >  
> > >  	if (ctx && ctx != dp)
> > >  		return 0;
> > > @@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > >  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
> > >  		   host_addr ? " as host address" : "");
> > >  
> > > +	if (fdb_info->locked)
> > > +		fdb_flags |= DSA_FDB_FLAG_LOCKED;
> > 
> > This is the bridge->driver direction. In which of the changes up until
> > now/through which mechanism will the bridge emit a
> > SWITCHDEV_FDB_ADD_TO_DEVICE with fdb_info->locked = true?
> 
> I believe it can happen in the following call chain:
> 
> br_handle_frame_finish
>    br_fdb_update // p->flags & BR_PORT_MAB
>        fdb_notify
>            br_switchdev_fdb_notify
> 
> This can happen with Spectrum when a packet ingresses via a locked port
> and incurs an FDB miss in hardware. The packet will be trapped and
> injected to the Rx path where it should invoke the above call chain.

Ah, so this is the case which in mv88e6xxx would generate an ATU
violation interrupt; in the Spectrum case it generates a special packet.
Right now this packet isn't generated, right?

I think we have the same thing in ocelot, a port can be configured to
send "learn frames" to the CPU.

Should these packets be injected into the bridge RX path in the first
place? They reach the CPU because of an FDB miss, not because the CPU
was the intended destination.
