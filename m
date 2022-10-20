Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BB2606266
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJTOEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJTOEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:04:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2B11D5850;
        Thu, 20 Oct 2022 07:04:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bj12so47591559ejb.13;
        Thu, 20 Oct 2022 07:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VcnoQx3qI7fpXJUKM0CZbdSa56iEX07NlfTNetUmqRw=;
        b=l5bu8brHSu0lV8jpdsslwekKWTitm3jcIzunKjSvYW6ZHEoyPulraEujek+0GP/Hvd
         VGynsaEV431/P0R4Up0JmdjgrLdZCAEXuS4thXeD1IkB0tL1c1TYwuHI0t7KEYQ28Ngi
         OjfuEUQIW5cD1w1T5Wl38wkB5vFtRrmJ1I+460JqsxkhwjNxe2MY/MZLUVaLfNXb9rxB
         mvWyTgjjiRaVTJ1C2POs4n/gmyaptI+zmwL5wEC99pA8loysp0dqVPy7tyoy7eWkwaRH
         0PWHvnaY1M5vrwXfwri59mlcpsoC38vvExyhtVa9UiFedcueAmfgCoofwGx7+yQve6jp
         dbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VcnoQx3qI7fpXJUKM0CZbdSa56iEX07NlfTNetUmqRw=;
        b=MGTpiQJDH0M8YHrF40zLf6Tnlo5FCi+KomiQDetLNZ5sb9pJyaEUvHg6vY9OW9LN1x
         WS6paqtC6HbqWCVJQXdZSwdlmdez9xlnr9ryRt8l9qoPbfaxoNVWAg5OOeFQ075lGlh+
         LJFGeChVyMhtAZ2TPlF5XqBX8nHsO5QBjBJ3PzaHdSWE5PJLyPqwmrvFcDxOUXPvyF0/
         PqoFnYn2Ww1ZCTQquhHslfDeNR3DpRCdGNXg9sfeQKmOlJbTy00urFUYoXzCvVHU18rd
         8gCh9Rh83lcck4PN9guVZYqQczNN/T8HXq5g7CTwzkQgtulBGm7xLZC5gKMnnJxqVKNg
         gNzg==
X-Gm-Message-State: ACrzQf2uNIf5YEutIhOPHsPEMpsCo0Vc7458GpleWLPySMKiGBpDrrYd
        sBfjcyjWka+XIDUUzuymt7SjqDgol6VZuw==
X-Google-Smtp-Source: AMsMyM4SZEZSqVPTVYvWzQRYrzgh/kATVwZIqEmKTRuF0c5R/E5+UHJTLTdHcYlKatrB4zrmQDmY/g==
X-Received: by 2002:a17:906:cc0b:b0:78e:1d51:36ea with SMTP id ml11-20020a170906cc0b00b0078e1d5136eamr11264073ejb.408.1666274645060;
        Thu, 20 Oct 2022 07:04:05 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id nb36-20020a1709071ca400b0073ddb2eff27sm10450359ejc.167.2022.10.20.07.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 07:04:04 -0700 (PDT)
Date:   Thu, 20 Oct 2022 17:04:00 +0300
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
Message-ID: <20221020140400.h4czo4wwv7erncy7@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
 <Y1FTzyPdTbAF+ODT@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1FTzyPdTbAF+ODT@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 04:57:35PM +0300, Ido Schimmel wrote:
> On Thu, Oct 20, 2022 at 04:35:06PM +0300, Vladimir Oltean wrote:
> > On Thu, Oct 20, 2022 at 04:24:16PM +0300, Ido Schimmel wrote:
> > > On Thu, Oct 20, 2022 at 04:02:24PM +0300, Vladimir Oltean wrote:
> > > > On Tue, Oct 18, 2022 at 06:56:12PM +0200, Hans J. Schultz wrote:
> > > > > @@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > > > >  	struct dsa_port *dp = dsa_slave_to_port(dev);
> > > > >  	bool host_addr = fdb_info->is_local;
> > > > >  	struct dsa_switch *ds = dp->ds;
> > > > > +	u16 fdb_flags = 0;
> > > > >  
> > > > >  	if (ctx && ctx != dp)
> > > > >  		return 0;
> > > > > @@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > > > >  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
> > > > >  		   host_addr ? " as host address" : "");
> > > > >  
> > > > > +	if (fdb_info->locked)
> > > > > +		fdb_flags |= DSA_FDB_FLAG_LOCKED;
> > > > 
> > > > This is the bridge->driver direction. In which of the changes up until
> > > > now/through which mechanism will the bridge emit a
> > > > SWITCHDEV_FDB_ADD_TO_DEVICE with fdb_info->locked = true?
> > > 
> > > I believe it can happen in the following call chain:
> > > 
> > > br_handle_frame_finish
> > >    br_fdb_update // p->flags & BR_PORT_MAB
> > >        fdb_notify
> > >            br_switchdev_fdb_notify
> > > 
> > > This can happen with Spectrum when a packet ingresses via a locked port
> > > and incurs an FDB miss in hardware. The packet will be trapped and
> > > injected to the Rx path where it should invoke the above call chain.
> > 
> > Ah, so this is the case which in mv88e6xxx would generate an ATU
> > violation interrupt; in the Spectrum case it generates a special packet.
> 
> Not sure what you mean by "special" :) It's simply the packet that
> incurred the FDB miss on the SMAC.
> 
> > Right now this packet isn't generated, right?
> 
> Right. We don't support BR_PORT_LOCKED so these checks are not currently
> enabled in hardware. To be clear, only packets received via locked ports
> are able to trigger the check.
> 
> > 
> > I think we have the same thing in ocelot, a port can be configured to
> > send "learn frames" to the CPU.
> > 
> > Should these packets be injected into the bridge RX path in the first
> > place? They reach the CPU because of an FDB miss, not because the CPU
> > was the intended destination.
> 
> The reason to inject them to the Rx path is so that they will trigger
> the creation of the "locked" entry in the bridge driver (when MAB is
> on), thereby notifying user space about the presence of a new MAC behind
> the locked port. We can try to parse them in the driver and notify the
> bridge driver via SWITCHDEV_FDB_ADD_TO_BRIDGE, but it's quite ugly...

"ugly" => your words, not mine... But abstracting things a bit, doing
what you just said (SWITCHDEV_FDB_ADD_TO_BRIDGE) for learn frames would
be exactly the same thing as what mv88e6xxx is doing (so your "ugly"
comment equally applies to Marvell). The learn frames are "special" in
the sense that they don't belong to the data path of the software
bridge*, they are just hardware specific information which the driver
must deal with, using a channel that happens to be Ethernet and not an
IRQ/MDIO.

*in other words, a bridge with proper RX filtering should not even
receive these frames, or would need special casing for BR_PORT_MAB to
not drop them in the first place.

I would incline towards an unified approach for CPU assisted learning,
regardless of this (minor, IMO) difference between Marvell and other
vendors.
