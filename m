Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3350C642560
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiLEJFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiLEJEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:04:02 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838DB2AF3;
        Mon,  5 Dec 2022 01:03:51 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i131-20020a1c3b89000000b003d1cb516ce0so1832162wma.4;
        Mon, 05 Dec 2022 01:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e/CZbUfVc92ihBtnZodjLsSvk+mrxIQEYUtjx/OCLL0=;
        b=pp81H3Yt4+1Cpj1ilPVV5q62Hnu0Hs+IllFYW/m+/vT08VtOey0TfVE/2v45ADNlcQ
         D2KEciG6R58sCSq6WpgF9WuGrW78vDv/pPdnHijjo+szCjfpNbXNwAeWC2wlZ8GFk1WS
         jfBQrOPEcmPo+w1S4unbFEQXa6koPY732HFKyANAwbkXoH+K6UXUjZbJ4kWER+fJyiy6
         xI7GPzNBwd7H+3GeQZAoBZR4vch+d74YG2sOEl/1GmZUGE3s17EcnPzz6tfY9C4iWqEL
         38VpXzK5iowBW7JfTbBt7OJPGvvRm4yx4MBQoTWaDRhSgcogwQyy9JPhy0Ym+Pel7PV8
         OI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/CZbUfVc92ihBtnZodjLsSvk+mrxIQEYUtjx/OCLL0=;
        b=V+iwY+/7mM+TiBGVb83tM+KC/RNs2MutZLWCrOXohEUiKxZ1PHWIlYGzysJaNVbDTH
         Uo1RaChCW1owgnoflkOWwtbwnQR6ZU/d5q4DYxBGbA6AuqyqN+Nicnn1JcR1pIC/8M3b
         A1q9qpmVvTzzeVrEJe532bzfNVglFqic7dh6Wujw717QY7NnvgbYdkC4JnlNSLb+8Xpn
         vhM2pZ0vhHnJkb/d8LnM9seg0LDh/0BlpOXG7+uk2WRESlUxup1SHep7fXiMpDyY73PB
         mCzpAxEJ1cbol9my4H8AHlEHi4CZiGAm8uB1C9yN/v0BLB/SB/B8+heFLiIdMHxBRCUu
         UCzQ==
X-Gm-Message-State: ANoB5pkgl5ZRHnptX2uWvNG3SYVN+X2hLfcRbUnqo0K7frZL4u62S9mr
        ob89Utr8BfRDTez4/JAGYQ7ezhvjb1SEdg==
X-Google-Smtp-Source: AA0mqf4WTCIUBsC2Punap4p9avd5YzN7MONDVYDrH2H3jVmXQQH7sy5+uw60icPc4KqRQlK1T0xoLw==
X-Received: by 2002:a05:600c:3acd:b0:3cf:550e:d7a2 with SMTP id d13-20020a05600c3acd00b003cf550ed7a2mr1585649wms.97.1670231029911;
        Mon, 05 Dec 2022 01:03:49 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g6-20020a05600c4ec600b003b49bd61b19sm23638795wmq.15.2022.12.05.01.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:03:49 -0800 (PST)
Date:   Mon, 5 Dec 2022 12:03:46 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: mvneta: Prevent out of bounds read in
 mvneta_config_rss()
Message-ID: <Y42z8kv8ehkk6YKf@kadam>
References: <Y4nMQuEtuVO+rlQy@kili>
 <Y4yW0fhKuoG3i7w3@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4yW0fhKuoG3i7w3@unreal>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 02:47:13PM +0200, Leon Romanovsky wrote:
> On Fri, Dec 02, 2022 at 12:58:26PM +0300, Dan Carpenter wrote:
> > The pp->indir[0] value comes from the user.  It is passed to:
> > 
> > 	if (cpu_online(pp->rxq_def))
> > 
> > inside the mvneta_percpu_elect() function.  It needs bounds checkeding
> > to ensure that it is not beyond the end of the cpu bitmap.
> > 
> > Fixes: cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> I would expect that ethtool_copy_validate_indir() will prevent this.
> 

Huh...  Sort of, but in the strictest sense, no.  mvneta_ethtool_get_rxnfc()
sets the cap at 8 by default or an unvalidated module parameter.

regards,
dan carpenter

