Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7503D662859
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 15:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjAIOVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 09:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjAIOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 09:21:28 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D094617430;
        Mon,  9 Jan 2023 06:21:26 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so20498686ejc.4;
        Mon, 09 Jan 2023 06:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lMgaEMqYWBr0ZV9OAHT3ME8dKmeEAGEVFmSCHTLSato=;
        b=Wes2o6lTDu94ENLfUswH7Fl2VCCEenfqma0m8Fy78rebt1t7SrElKzERcjqJpoZ2YY
         OMkYWjGjPTN3EozxehCTP3OGTv/8y09SqT+braOz481zE0yJ/atMucoUaEBCUnOfFDoB
         gju2BLfTDXjCemhVHvp1dw/C7i+VCteXqDx6tV9nj7zDUGiHGE2rOU+iYhk04WzFmjDx
         kP3ExBi38k3KSEkghIWcBolLXZJqULQNMNchAqc4qU5myXxRg8C/O0kfjcQ2wSSFovSo
         clpXtNRTIbgFVEwUMiZfrvEfawwN2d1LooKepMQY/ctqlatb+Jq9cFjbh2qbP29zzxkp
         5dqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMgaEMqYWBr0ZV9OAHT3ME8dKmeEAGEVFmSCHTLSato=;
        b=LtQkj7vVLUTOaRKtI9rc9iqGJd13k7dJJZwcobg5riHZtOisSf+dCNIZN12gcFfbhr
         lDoajoIiIAW8umjia0hVkGdkz0FWeJK8E/6thR4nNQ7yNV3C/Pr6IegnKj/jMj5ff24I
         ZCaSPQd33Fqd3tXJ5h4Cxdt51KHxZty61IaprolvW28oLXAukfbl3opiF/N7SH+ZE2NB
         hhKZrRuo9DbbMGqeYpjJkDlu1c9lmtPwqDWGFwHC4Vjg32FWgM46fGffhvy5pxfUatxL
         NdivEwnLvsxiCbQxTzoxiBDmk9Gz2FTKFoidAhAXjXU9FtpS6opHXI0ctBI+Y7uedtWK
         y+3A==
X-Gm-Message-State: AFqh2krCN3bDfQIc9S6QosVFkX0KOAH0p+YLZEYPBplAVpeBmUCsDZEC
        xFbMXyu0VjgnvoRcvEnG370=
X-Google-Smtp-Source: AMrXdXt/czzJrtUriHeD4x3yynThse5hrKXkz8BS3PwKqEIrRC+x2UnY/N72egl97vwq4FFU+RI8/g==
X-Received: by 2002:a17:907:cbc9:b0:7ad:b6d8:c9d0 with SMTP id vk9-20020a170907cbc900b007adb6d8c9d0mr60330799ejc.53.1673274085290;
        Mon, 09 Jan 2023 06:21:25 -0800 (PST)
Received: from gvm01 ([91.199.164.40])
        by smtp.gmail.com with ESMTPSA id i3-20020a0564020f0300b00461cdda400esm3762548eda.4.2023.01.09.06.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:21:24 -0800 (PST)
Date:   Mon, 9 Jan 2023 15:21:18 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y7wi3qwG3b6i0x7T@gvm01>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <b15b3867233c7adf33870460ea442ff9a4f6ad41.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7m4v8nLEc4bVBDf@lunn.ch>
 <Y7tYT8lkgCugZ7kP@gvm01>
 <Y7wXO7x7Wh7+Hw/Z@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7wXO7x7Wh7+Hw/Z@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 02:31:39PM +0100, Andrew Lunn wrote:
> Linux tends to ignore Marketing, because Marketing tends to change its
> mind every 6 months. Also, Linux ignores companies being bought and
> sold, changing their name. So this PHY will forever be called whatever
> name you give it here. The vitesse PHY driver is an example of
> this. They got bought by Microsemi, and then Microchip bought
> Microsemi. The PHY driver is still called vitesse.c.
> 
> How about using the legal name, 'ON Semiconductor
> Corporation'
That's perfectly clear Andrew, I can certainly see why Linux should
ignore marketing.

Sill, 'ON Semiconductor' is the old company name, the product datasheet can be
found at www.onsemi.com. I would honestly feel more comfortable using
the current company name. If you really want the first 'o' to be
capitalized, then so be it. Hopefully people will not notice :-)

Thanks,
Piergiorgio
