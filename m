Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9328166CF8F
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 20:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjAPT3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 14:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbjAPT2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 14:28:54 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72A2BF1F;
        Mon, 16 Jan 2023 11:28:53 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id az20so51228637ejc.1;
        Mon, 16 Jan 2023 11:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CEXSnU92F25+pQZ7j/ugqhVpdFpJuO21X3P5/Cl5PKQ=;
        b=Em5DoiYpYrIyZy2p3QJASxwL5PBvpr5AlBw7El6F3zr/+EEOD7iuRHUTJRYtzzVfRt
         A05Lqb4r5SV/e4bPIqK3cCgn3uMEO4L8Io2gsZgnn1fXhM3nzc2mnt6kRJt5cEWN119R
         NvUSwI4zMUtmaVKzaQWn5IRh2TnG8/IZ5RrwE/qQMihxQkNlMaK6yC2GjK16XJEjXa/q
         X6dVvb4nZq2sQTFjAKM+bAmsdvYNhJpPZNuk0bLY74X5w0bugQ5kNivcnB+j5FSMlBQ5
         OWvi6v7xzSbtwIpgPvMx8OGT/ihVDlsx1QLvu38cyk74ITIBRE9qRkneZNH0leKJiaD/
         mZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEXSnU92F25+pQZ7j/ugqhVpdFpJuO21X3P5/Cl5PKQ=;
        b=DFKL+DHEyyoRw3s4YPGQk2tTHkCn7MJf2NXuv5XICgVMicFcpTVRc232j3QRWd4WKL
         PIS4kyxDJXQ5FT1eu99f/9Oz55b0dtRjQYhKVilNNoPx+i+vzJiyhmvtgofktg1QCpCx
         RD9UmP7/8MWO9c+jkuedsJW7845gS60jKxpHYK55II0TmWikgtnhMGcph1y8QUx/a4uS
         ecrM3hyxL8VY8OPXn6uFgJ9jML4IQJK92fBEEDi3ZbkD898Is4ABLqeZQTs0O+HYsLDg
         5KKNAoW78RjjT/LoaHLARpjoR4xTGz7Fy8Iix2bYxDgglD+42DhjAMQCyzcdChQiWFKf
         UTEQ==
X-Gm-Message-State: AFqh2kpLc8/d09dP1dlCjDhmGqUOz+c8cpFSKf1c+0IrjgQmuPKGlbnT
        /cOJJTNFDrExBuOKSR/r3Ek=
X-Google-Smtp-Source: AMrXdXsvdrtS57ZbbOQdVeoHVOfWaJG213U9hdwNzzZXDq7P7HeiNHiHnyKY7Z9C7+GuvgKw9jPSGQ==
X-Received: by 2002:a17:906:2288:b0:872:23b8:d6ed with SMTP id p8-20020a170906228800b0087223b8d6edmr155759eja.20.1673897332179;
        Mon, 16 Jan 2023 11:28:52 -0800 (PST)
Received: from skbuf ([188.27.185.68])
        by smtp.gmail.com with ESMTPSA id w15-20020a17090633cf00b008711cab8875sm1151237eja.216.2023.01.16.11.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 11:28:51 -0800 (PST)
Date:   Mon, 16 Jan 2023 21:28:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH RFC net-next v2 11/12] net: dsa: Separate C22 and C45
 MDIO bus transaction methods
Message-ID: <20230116192848.bi7bs5e55pdlxffm@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20230103153134.utalc6kw3l34dp4s@skbuf>
 <Y7ROa8ql9R5SHPsK@lunn.ch>
 <20230103155633.tfdxncl75s4tb2ln@skbuf>
 <6208c429b0b5541a4f6d2a8556ae1fcb@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6208c429b0b5541a4f6d2a8556ae1fcb@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 08:51:55AM +0100, Michael Walle wrote:
> Hi,
> 
> Am 2023-01-03 16:56, schrieb Vladimir Oltean:
> > > So Luiz patches may allow a C45 bus, but are there any drivers today
> > > actually using it?
> > 
> > I sent a private email to Luiz a few minutes ago asking him to confirm.
> 
> Any news here? Do we need the c45 methods?

No news it seems. I am going to default to assuming that no, a ds->slave_mii_bus
created by dsa_switch_setup() does not need C45 accessors.

This patch should be modified to only touch the mt7530 driver, and
adjust the commit message accordingly. I see no connection to what the
DSA core does.
