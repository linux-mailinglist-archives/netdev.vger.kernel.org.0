Return-Path: <netdev+bounces-4004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E27870A0A0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1876C1C211BF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356EF17AC9;
	Fri, 19 May 2023 20:34:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E4817AC1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 20:34:56 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEFC107;
	Fri, 19 May 2023 13:34:54 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-966400ee79aso701925266b.0;
        Fri, 19 May 2023 13:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684528493; x=1687120493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3DYhz4q6r+8hJyhMZr5fo0ENEYzNVGjwRINrf0k6BeU=;
        b=JczEPQDDUgRxxpDO1Nz8Fqsptg0WMWssCyuRQ+JFFnVmiSt3CZYudNw5WRw85QIN9T
         r9KbRxt4jT9b9lGagerzf6vDJf+C10HYyIKN83F9o+9rpRi/UBYCcZ4jOqwXdHICFJnc
         XTrDDxJWxexpVhv52sqzX8yX/WbcBkTFryieiXAwt7M/MvwIpUCZqsm5jGT8/2b91qeS
         IGMJLIMAJULoBMN/rQbEwqE1KtZ67IbilgUmfNM5R+YcPH016fT0MtpcYTAsW6un3BIK
         3xiCdx5yTwMwSQRx0SHEf7okS7vGrZr+ZZUfuglVJcUaqbvHLWegH5E6Jj8erRbDN5i6
         6n3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684528493; x=1687120493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DYhz4q6r+8hJyhMZr5fo0ENEYzNVGjwRINrf0k6BeU=;
        b=ItXGrKcLkf6zEOj94mdORWjTDBugID9QovMg8ao5ZI736K8SdjIaY8eqKDyBdNQl0r
         +wBkj44LrQ3hBBb7X4QKjI4qGYcC4vKh0lQGYPWL/Aez7M7VmkjXNvCjUMgaJAWBcNQk
         1WA4wrLFYR7o6mBI+mge30Puuet9UgfZib+Tfj48rwIxPYUDGPBr7L/vsHO0pDPYqTIO
         /KWMqAS0FtVMTyAvMJXKR9NH4bmjcWzY3mQsYI7OxBM97uIjWyJEq1onjE5bjpdWKA5U
         y/9mrOJXRYByfqCQFx1CHgQ+XBewMLcMr6qV2Aq2z/xxLx+Xezjgsv6ajXG8eLbcnQPV
         yQvA==
X-Gm-Message-State: AC+VfDx6rzTN7sQBPVjSFWaQnqLAfMsVvRXJmVXXy6hwWb6+Nlgzpbtr
	oaEKwnYCfhX0uzHUC8VhVEg=
X-Google-Smtp-Source: ACHHUZ6VIdrbAorwWnn6B35+W1E85vZRDOL6WuFFOWALu7jFm51+UEiQQkQfHTagO8Qz/9Z0HF6TIA==
X-Received: by 2002:a17:907:3da0:b0:95e:d448:477 with SMTP id he32-20020a1709073da000b0095ed4480477mr3733261ejc.33.1684528492332;
        Fri, 19 May 2023 13:34:52 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y2-20020a170906914200b0094e597f0e4dsm22928ejw.121.2023.05.19.13.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 13:34:52 -0700 (PDT)
Date: Fri, 19 May 2023 23:34:49 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Woojung Huh <woojung.huh@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
	Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230519203449.pc5vbfgbfc6rdo6i@skbuf>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519143004.luvz73jiyvnqxk4y@skbuf>
 <20230519185015.GA18246@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519185015.GA18246@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 08:50:15PM +0200, Oleksij Rempel wrote:
> Thank you for your feedback. I see your point. 
> 
> We need to remember that the KSZ switch series has different types of
> ports. Specifically, for the KSZ8 series, there's a unique port. This
> port is unique because it's the only one that can be configured with
> global registers, and it is only one supports tail tagging. This special
> port is already referenced in the driver by "dev->cpu_port", so I continued
> using it in my patch.

Ok, I understand, so for the KSZ8 family, the assumption about which
port will use tail tagging is baked into the hardware.

> It is important to note that while this port has an xMII interface, it
> is not the only port that could have an xMII interface. Therefore, using
> "dev->info->internal_phy" may not be the best way to identify this port,
> because there can be ports that are not global/cpu, have an xMII
> interface, but don't have an internal PHY.

Right, but since we're talking about phylink, the goal is to identify
the xMII ports, not the CPU ports... This is a particularly denatured
case because the xMII port is global and is also the CPU port.

