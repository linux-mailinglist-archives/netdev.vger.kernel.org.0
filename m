Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF5668A3B6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjBCUo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjBCUo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:44:28 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBC21DB8D;
        Fri,  3 Feb 2023 12:44:27 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l37-20020a05600c1d2500b003dfe46a9801so3299593wms.0;
        Fri, 03 Feb 2023 12:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2i9kAduLyvWzDNPasV+KzeGgY8drvOps/KxoO5LHdEw=;
        b=Vh4yFSLP4dnir5alPOP/BdqGJ1iEQMpXhQ+vDTowlNH9vMovkkNBYPi8Uhk8C7itGw
         pWJPGbneNPZx8bgItqJXAuo9hewbHrvUsmkjhmhjo7iVzDaPKFrVlDjUisuzBbOPzaBk
         hoew3vOtR7JhNkpbPch0cih/aKZQY3wZX9AulnE0kyyhblR3bKcZnRU35XovU5/9VbYj
         lHi0Szbc9Ujf075Lgy9ykV7iQTSzJNKLodhKzj3evBAx2txbaKjEgLHvLZEo7Spemc80
         Fne13usGX0QFsuTnmHXtqiB94MQK2ebcXK5/Xito6NgmRWOGINev3LN1yORMLgTrA/pn
         3OHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2i9kAduLyvWzDNPasV+KzeGgY8drvOps/KxoO5LHdEw=;
        b=tQRDvalvBCu8Jr0AZDgMSa5WvOI9wSuQwQEWnyWUut5i0QdFndpJwXlscBnaTfLWKy
         wtfBT3bsid09OJLr0JFLMTZOsEbofvG0FLa6/DFRcmZhzvIIpKPzqAT6LlUzg3t9lT9Y
         U7k+l6UdCl/oa+KZjwvYiQaJCU6iOazXMbjhEcZgzt2178NBB/eSafKm2W99UUIXehOX
         8j2X8N91vhwSe9op3vIL+ymyHCLJhAV0cTWag1AkP1oxTtJKcGL+Iappt/w++t+ynbUi
         IuTX3RJVPSyZ9prJA25WeX7t3d9aFmv9cUGGBit+j07m9yz4/lyDu2YupULJ4J+NWaO/
         3iow==
X-Gm-Message-State: AO0yUKW/pCDgPFsqDHgXW+BeaDg4+0xEPxctLNO2zTuB+HrzI9Rv1lY6
        y43RkoVoT0+qTnf94gRQLdM=
X-Google-Smtp-Source: AK7set+E0bvJKJbO9QlN+pgygfVmSHBtgpwZ8dotHCW3HBDbg/640wbwRlbuPaDZ1oHGBTvA8Ms6OQ==
X-Received: by 2002:a05:600c:1994:b0:3d3:5709:68e8 with SMTP id t20-20020a05600c199400b003d3570968e8mr10077158wmq.36.1675457065628;
        Fri, 03 Feb 2023 12:44:25 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id r30-20020adfa15e000000b002bfafadb22asm2834308wrr.87.2023.02.03.12.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 12:44:25 -0800 (PST)
Date:   Fri, 3 Feb 2023 22:44:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
Message-ID: <20230203204422.4wrhyathxfhj6hdt@skbuf>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9zDxlwSn1EfCTba@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 09:20:22AM +0100, Simon Horman wrote:
> > else if (someflag)
> >         dosomething();
> > 
> > For now only one flag will actually be set and they are mutually exclusive,
> > as they will not make sense together with the potential flags I know, but
> > that can change at some time of course.
> 
> Yes, I see that is workable. I do feel that checking for other flags would
> be a bit more robust. But as you say, there are none. So whichever
> approach you prefer is fine by me.

The model we have for unsupported bits in the SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
and SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handlers is essentially this:

	if (flags & ~(supported_flag_mask))
		return -EOPNOTSUPP;

	if (flags & supported_flag_1)
		...

	if (flags & supported_flag_2)
		...

I suppose applying this model here would address Simon's extensibility concern.
