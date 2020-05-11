Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFD1CE1BC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbgEKRbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbgEKRbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:31:21 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22910C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:31:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id w7so12017988wre.13
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YsuFJhtSrJ1y5b4db9UFLFWpJ7Htm3EnF9uKj6yAR7o=;
        b=pkU+/39s+NtqQOeXP4Z+MPMmXyqFmiELiAAHbmEz8KXnz0QIc1ipsT9Bo8bo84+cql
         OizXFO+uRo5wPTik5GRGOxeWcoOie+iQsDOhEaJOoHYuhDpqa2AJ4gU8yLQL88F4jvm6
         dmrzn5HtMAm7MoVnUgHlXhvLffzxzI2MtUpHIVGhAIrV2TqtFO0IhqyI3KslYJSR5CMh
         YlXaEVik9zcipX0lqfvUfM9+Z7CZ0ltQu0RRMGkXCvmdIdPl20gDVYrsKko9WzWTV4H8
         /0Ol6ijXsXwq/1jCoFJgauIFiXgOlYHsY+KUQ2HRN07siK6rbbOweZMkBbcdkaMO8LUg
         yU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YsuFJhtSrJ1y5b4db9UFLFWpJ7Htm3EnF9uKj6yAR7o=;
        b=QUwuPwhBiz3Ojb5dzXDsyDI1QE48Yo/hyq1YXZGPZLihoWp3M8MAYRCO1KENyGQ5hb
         BH3yVXOhRHXANWmAfpm0sQp/4DLZ0+ijOQ1F/aFVun4iqcttjw/wKT5Z5EM7C0c1PxW+
         Q+FR7JIBI4hcX3MbtjCEZtD4CjLNK9nzz8wt8BsmlU9HZ5kyAUHMPjbJYlNqP9OAIQJ4
         WK+THi3gN/HJ0C3pzRD6bvjf713jBMI87GYd9WqCCJ22aQU7dvnCDBxiFmu1/esPVckq
         EjXRXGZ/ynrswP2jsK9WTKDSYj+KHT+2c4qQH7FV+Dtdkq2TV0kIWaVXikj5Ygf/WwzJ
         Lenw==
X-Gm-Message-State: AGi0Pub9VJ6XvcDhmttHWZiYDuOJd/Zd6j5S88Ce9gQl3PVvHzHWLOSU
        ARL0RFgmuBeuYaD1Rkg21FjoqQ==
X-Google-Smtp-Source: APiQypJtvLeGxAa87KTc9HUrH1Qk+4wFwzBmDKjUcQRW4CIcl5IE9xroZdjeqDG0dCoLfrscUV80Hw==
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr11886550wru.83.1589218279908;
        Mon, 11 May 2020 10:31:19 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 2sm18415523wre.25.2020.05.11.10.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 10:31:19 -0700 (PDT)
Date:   Mon, 11 May 2020 19:31:18 +0200
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
Subject: Re: [RFC next-next v2 3/5] net: marvell: prestera: Add ethtool
 interface support
Message-ID: <20200511173118.GL2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-4-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430232052.9016-4-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 01, 2020 at 01:20:50AM CEST, vadym.kochan@plvision.eu wrote:
>The ethtool API provides support for the configuration of the following
>features: speed and duplex, auto-negotiation, MDI-x, forward error
>correction, port media type. The API also provides information about the
>port status, hardware and software statistic.  The following limitation

No double space.


>exists:
>
>    - port media type should be configured before speed setting
>    - ethtool –m option is not supported
>    - ethtool –p option is not supported

Those are some odd dashes...


>    - ethtool -r option is supported for RJ45 port only
>    - the following combination of parameters is not supported:
>
>          ethtool -s sw1pX port XX autoneg on
>
>    - forward error correction feature is supported only on SFP ports, 10G
>      speed
>
>    - auto-negotiation and MDI-x features are not supported on
>      Copper-to-Fiber SFP module
>

[...]


>+static const struct ethtool_ops ethtool_ops = {
>+	.get_drvinfo = prestera_port_get_drvinfo,
>+	.get_link_ksettings = prestera_port_get_link_ksettings,
>+	.set_link_ksettings = prestera_port_set_link_ksettings,
>+	.get_fecparam = prestera_port_get_fecparam,
>+	.set_fecparam = prestera_port_set_fecparam,
>+	.get_sset_count = prestera_port_get_sset_count,
>+	.get_strings = prestera_port_get_strings,
>+	.get_ethtool_stats = prestera_port_get_ethtool_stats,
>+	.get_link = ethtool_op_get_link,
>+	.nway_reset = prestera_port_nway_reset
>+};

I wonder, wouldn't it be better to put the ethtool bits into a separate
.c file. You have a separate .c file for less :)


>+
> static int prestera_port_create(struct prestera_switch *sw, u32 id)
> {
> 	struct prestera_port *port;
>@@ -264,6 +1023,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
> 
> 	dev->features |= NETIF_F_NETNS_LOCAL;
> 	dev->netdev_ops = &netdev_ops;
>+	dev->ethtool_ops = &ethtool_ops;
> 
> 	netif_carrier_off(dev);
> 

[...]
