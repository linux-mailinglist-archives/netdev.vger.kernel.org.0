Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847E45FC141
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 09:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJLH1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 03:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJLH1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 03:27:23 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC39A98E4;
        Wed, 12 Oct 2022 00:27:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qw20so35544954ejc.8;
        Wed, 12 Oct 2022 00:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O12FuokJG81xIdymtEaWIVms4586lGlP0FbvJ/Ms9Us=;
        b=EYIGBAyHVf6K/ighbfQaUBCBRXJGccBsLUwdeHSxqrkerZpt2IrXgl6JvmFj1OMqKo
         Pk4UQe5ntYeXbgyj2MO7lc01swS7RTdhkTRpXUVyfNu7I0HcPCYZD2KmvgEOb6XdsvHx
         jG7cioT0xzxfeD9fArd0X9R9ylzufFQRJ7R1nc8YuxQtuWc6D6NadpMN3myYZXOCgoEX
         t9EtFJLWEW7CQ4Ri+2qblZWtwflWdWK4pOZxy3dR7vPeSmg+rGW/LaC+oxeocWQ/k42l
         V8SxXLqoGk+WNNpzfwobm0rYLCj7df6qmfwVGgHASJdOYrduyDlimPNvMQDTnigRIRii
         YiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O12FuokJG81xIdymtEaWIVms4586lGlP0FbvJ/Ms9Us=;
        b=kxDv+XtaqIzPoDrH4+lZzO9qDWBRQkDdqlX6nxyO23GkQNc79t5mVG25rngtTXq+PK
         YolWhWd3EeTnl3HpUtls5GKg8WwL3Ud54G0wrOEABn72s2vASAP9vMxel8A4xMDvFoor
         py4hufo5MrDNLaT9d0NGck4jW9f3g5lqDgpz0eaW6IRxAHScvfbqpNjPfFiklBFK1gU7
         2aFqP8pIAN55nQu2CkgJU/mxdGMmrrht+Rj0aDK6ieDoXBO7rmb8lHQstzGnSmRJMBCW
         Ra8azB5DD7/VRW2RfNge83qfx59ec/bFnNtnzWinoT+lwQGMAD/jvQqaqnnyMbAWsY/Y
         UqWg==
X-Gm-Message-State: ACrzQf0MzUh/4kAWyAzwEQgSi4njrNz3lYOv4D1RFom9BiMB5zL/sNJc
        x6IH5M0/qFInc6Ur2n4mBvA=
X-Google-Smtp-Source: AMsMyM5mHSmWcUubZd6kl3Y7560/NgeFDmhwJwilKU2YLj3/3TDjE8L2C3mRg5Q615aRwi1bl0NX6w==
X-Received: by 2002:a17:907:744:b0:741:36b9:d2cc with SMTP id xc4-20020a170907074400b0074136b9d2ccmr21462064ejb.613.1665559640755;
        Wed, 12 Oct 2022 00:27:20 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id kf3-20020a17090776c300b0074182109623sm784344ejc.39.2022.10.12.00.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 00:27:20 -0700 (PDT)
Date:   Wed, 12 Oct 2022 10:27:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
Message-ID: <20221012072717.nuybkswd7zuwvqsp@skbuf>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010111459.18958-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 01:14:58PM +0200, Christian Marangi wrote:
> The header and the data of the skb for the inband mgmt requires
> to be in little-endian. This is problematic for big-endian system
> as the mgmt header is written in the cpu byte order.
> 
> Fix this by converting each value for the mgmt header and data to
> little-endian, and convert to cpu byte order the mgmt header and
> data sent by the switch.

By any chance, is the endianness of the data configurable?
