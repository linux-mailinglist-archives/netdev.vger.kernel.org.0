Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36FE64505A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiLGAdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGAdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:33:10 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3CC1209C;
        Tue,  6 Dec 2022 16:33:09 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vv4so10383343ejc.2;
        Tue, 06 Dec 2022 16:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=50mq//tdgJVoA6Oeoi/GpAOj/u6aWs+IjfwQD6KOGW8=;
        b=aa0JP36Qh8dtbU3A8uYb5yU6faAayomgIsIYsCT7R6EMUUmCqu1CH12UvKg5Gepm+C
         T/W9jy9uoJ6ujzm50dTq7eFf1pqvntFX0F2Bi2pS6tu0ywqj2OxyRMS4LoojofGOdpWq
         JC7lL4iKvY4O93/6ZzlfOHzXHc+W8E+ECNHComzT+Fi6qrb3NUmB5jIBLPqFGevN/91U
         KU9xHTtp0JQ9oImgvSKU4KV8vxN+C5oqtLRBujWD2fV61sFIEO/RRAwvuXS/jywHJwdv
         oArI/SJuMXPGp9fCKMnBX/4tpLsBFrjj4dK+37C5FKlU4+TkfwQoRdVyVd6xnJNiwNfJ
         XrMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50mq//tdgJVoA6Oeoi/GpAOj/u6aWs+IjfwQD6KOGW8=;
        b=ksR8HXIpncX4KIldZ5rAfTNLZjxHMPNipaGeZK9n0p5/mf+A+Jtk4aCxog/mhaKv+t
         MX9RnkDV9P/M1HzTOmgSZmbgINZ2tC4W9Egc/Tp+8g+lFW6vuWFJPh72RLRlvRrTXGLp
         WW0VZ8lRIXHq5K4N3c3tVaDhBhrfSWljQmLzF+X60m4rmZZ6d2rFbB0dtdLCE65PDrL/
         CI0THbRQ+isy825zpRL2FCY1VgQrEGrTIfVNnKKCzwjozhvbvQlqaRKNV79nac+2kbIr
         1sQkoWjwM1GKoUz6flh1Ko0nbWg7J17z0/aMGoGEemjap0Hyq7x6Vu2VPE0qU1bo8hE1
         q1Ig==
X-Gm-Message-State: ANoB5pkWi4TMe7BxcK3svaXFydt0JSC3WoopR8+Can3/CVrEH6EvwyBt
        VWY3gHhw9D4WNkK3yi4LHQbrHvguxikhq3/d
X-Google-Smtp-Source: AA0mqf6ZLdHvwvcHscTgHU/8H/oWOW0MXBqNme5+4o83r2elnq5YGiQkN9ZJL++HIUvmMcyxRXR2UQ==
X-Received: by 2002:a17:907:2bc9:b0:7c1:534:c203 with SMTP id gv9-20020a1709072bc900b007c10534c203mr5847036ejc.436.1670373187834;
        Tue, 06 Dec 2022 16:33:07 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id kz14-20020a17090777ce00b007806c1474e1sm7905834ejc.127.2022.12.06.16.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:33:06 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:33:17 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y4/fTVKJEbTYQxja@gvm01>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49IBR8ByMQH6oVt@lunn.ch>
 <Y49THkXZdLBR6Mxv@gvm01>
 <Y49yxcd6m7K3G3ZA@lunn.ch>
 <Y4+FqsZLBzDzadcC@gvm01>
 <Y4+UAmyS5hJ0+c66@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4+UAmyS5hJ0+c66@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 08:12:02PM +0100, Andrew Lunn wrote:
> > I was wondering if there is some interface (sysfs / proc / other) to set
> > parameters which are very specific to a PHY implementation?
> 
> Please describe what they are, and in what context you need them. Then
> we can decide on the correct API.
> 
> In general, the OS is there to abstract over the hardware so they all
> look the same. We don't want anything specific to the PHY.
That's clear, let me explain.

Enable of enhanced-noise-immunity mode
- This trades off CSMA/CD performance for noise immunity. It could be a
  static setting, but the user may want to conditionally enable it
  depending on application decisions. E.g. some people may want to
  enable/disable this when using CSMA/CD as a fallback in case the PLCA
  coordinator disappears. Of course, there are better ways of doing
  this, but it is a possible use-case that some people want to use.

Tuning of internal impedance to match the line/MDI
- This is really board dependent, so DT seems good to me

Tuning of PMA filters to optimize SNR
- same as above?

Tuning of TX voltage levels
- I am not 100% sure that is static (DT) but for the time being it could
  be considered as such. It basically trades-off EMI (immunity) for EME
  (emissions).

Topology Discovery
- This is a special mode to detect the physical distance among nodes on
  the multi-drop cable. It is also being standardized in the OPEN
  Alliance, but for the time being, it is proprietary. I think it will
  require some kernel support as a protocol is also involved (but not
  standardized, yet).

Multi-putrpose I/Os (LED, GPIO, SFD detect).
- I know the kernel already has the infrastructure for those functions
  (not sure about SFD) so I assume this could be some DT work and some
  code to configure the MUX to achieve the specific function.

Selection of link status triggers
- This is what I was trying to achieve with the module parameter. i.e.,
  the link status can be a simple on/off based on the link_control
  setting (this is what it is for CSMA/CD as there is no link concept)
  or it could be masked by PLCA status whrn PLCA is enabled. This is a
  design choice of the user. In the former case, you don't get a link
  down if the PHY automatically go back to CSMA/CD as a result of PLCA
  status being 0. In the latter case you get a link down until PLCA is
  up & running, preventing the application to send data before time.

Thanks,
Piergiorgio
