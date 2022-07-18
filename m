Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5098578859
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiGRR2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbiGRR2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:28:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F402C678;
        Mon, 18 Jul 2022 10:28:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bk26so18055843wrb.11;
        Mon, 18 Jul 2022 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=SE+OXLYD8zcDEgzlTLoNNCKIcujRnk24kJfM6BVh3/s=;
        b=a88P17pRfzEiS2Py8vikhNd21u3AO7wg6hSBs7DtRAE7+b0M7RbKAkiaucRLGbfaVk
         3L4G47rF7eRc+unyBqFa1Da8ibuxPaiQQ8nIV1o9K2vUVSRRSrqPZTeZcj+kO6kkDx0M
         DAweP6PzUo5lNXNIsrUW0wspmfkmACqQ+ubx4Rp084ofSWo98HvhXr8qD1ePWFeFmczY
         hRUHllOqKwbg3hKkwQ/X6frdqylTlSHG23J+RPPYRKBbTHvejXFcY9SHG8OGGJ1My6rE
         w3/t0sw2lAQtMBz6ncOzF4DqRxHi298k8unmmcWwQoHrnnuo5Wt/Ot06n2NB9EMeDtq9
         sUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=SE+OXLYD8zcDEgzlTLoNNCKIcujRnk24kJfM6BVh3/s=;
        b=uP8I6ANfhUcBftHxbQJx/Xfgbov0kAhm8KTajUwTtZ4GBKFBLTOWdA/OjMuZvPwdDK
         ZqG3sakq/7T45NhNaB4DlqSLGWKOf+utiC1B4s4+Jw0bzdGSw26QZL/cGTFdsSM+AF9L
         OxQEgu/SfeYoxIrlv8USyPbN63z46DBw+1eAreQ2qahcgM4Ku9xApQdtVzQirFzORozu
         j6ZwGbmjjePnSio3abDNgM5FVv+vNeTN6BMATv6hRwr4cU4C2O/I/adW93tF5eLGr6Li
         HHI3O2GxAZNXjmxNbk5eKQlm2rRct1KXmejkMmPAnHLpv1jGgcPNvDQEIHqq2S9RonQ7
         7HGA==
X-Gm-Message-State: AJIora/l6UHN83FkApyveDgwT+2Mib2ZheE8hoeEmkNS0Uy2tLTC1OfY
        oLjjmriuebrhCSasf3XXM14=
X-Google-Smtp-Source: AGRyM1v32hf1Spqq4nXa2qUYus7QJvk1pNXsLpopnExuZB1JtD7ZLZpkvd+9tNebCR0iTWdhtMOMXQ==
X-Received: by 2002:a5d:4911:0:b0:21d:6c60:978e with SMTP id x17-20020a5d4911000000b0021d6c60978emr24493085wrq.615.1658165279941;
        Mon, 18 Jul 2022 10:27:59 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c4fd100b003a305c0ab06sm15163711wmq.31.2022.07.18.10.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:27:59 -0700 (PDT)
Message-ID: <62d5981f.1c69fb81.35e7.2434@mx.google.com>
X-Google-Original-Message-ID: <YtWUHJncJ8z5QieW@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 19:10:52 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 4/4] net: dsa: qca8k: split qca8k in common
 and 8xxx specific code
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-5-ansuelsmth@gmail.com>
 <20220718172135.2fpojugpmoyekcn7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718172135.2fpojugpmoyekcn7@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:21:35PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 16, 2022 at 07:49:58PM +0200, Christian Marangi wrote:
> > The qca8k family reg structure is also used in the internal ipq40xx
> > switch. Split qca8k common code from specific code for future
> > implementation of ipq40xx internal switch based on qca8k.
> > 
> > While at it also fix minor wrong format for comments and reallign
> > function as we had to drop static declaration.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca/Makefile                  |    1 +
> >  drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1210 +----------------
> >  drivers/net/dsa/qca/qca8k-common.c            | 1174 ++++++++++++++++
> >  drivers/net/dsa/qca/qca8k.h                   |   58 +
> >  4 files changed, 1245 insertions(+), 1198 deletions(-)
> >  rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (64%)
> >  create mode 100644 drivers/net/dsa/qca/qca8k-common.c
> 
> Sorry, this patch is very difficult to review for correctness.
> Could you try to split it to multiple individual function movements?

You are right.
Can I split them in category function (bridge function, vlan function,
ATU...) Or you want them even more split? 

-- 
	Ansuel
