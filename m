Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC66563140
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiGAKUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiGAKU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:20:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6019C21;
        Fri,  1 Jul 2022 03:20:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z19so2319790edb.11;
        Fri, 01 Jul 2022 03:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mq3hRzGTGMhk335oG2HYjZUusfbXbC7tEFXtOdbV1t4=;
        b=brQbv8IGSh8xyGOvS1g2NuNmaXe3M5txM/ryxd+u57y47lY16cfD7aUwM2V3xuZpZJ
         XvYt5VMrT0yzEM6RfpQSf7ZEGwhLD7YMT/ygmCasqrgfNLHNmfHmQmJ29U8wNVJO9Spl
         2ANtb5+Ry4lZOkpfDJbIFqGBy65xM8p7EhtONLp2oSNyZHvh7ty4KwTeOULyK6+n7tpb
         A3sEJLBIJbyCS1R4EirMS93OTIKQc92HzQL6dM/L99XDjCNuSrpwSHUfuuEFGqWrSZIF
         fJmTYc0v50jsNCrnuDlQcWavirpMclPpZ62HiMW8FzAdIHmANUcknPRH/3KKos6BQoNs
         jkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mq3hRzGTGMhk335oG2HYjZUusfbXbC7tEFXtOdbV1t4=;
        b=KnS/6kViujAm90wjpOPn6wLaoXi2GSavi65hxnd3sXbbvEgXzkzOPvjz5hM3TqjQyX
         FNA55louUNVPi1iPZAa6Twnts+La1a8W//0TVaBpjUL9JloCU6elx5a/JDkv9Vf/c2gZ
         gz8xRkNnNFE+HWWne/G1iQeXwacO/hsJuNu/ZGhjc6lKcQ3B7yBLcaktkun+Oue9u+Za
         avgymlyaqld1Z3nchf8c6+AsyqB6Zh2dOCyft2mkMYFyVa5iQLjebXKPHtOB90UFTv57
         E6Pc+j/13jaiqcj05xy1qRwd2H0S4LUz/Ib+jEC2UADLoRuE+pqhatH9VD6apwh5qP6F
         vmDQ==
X-Gm-Message-State: AJIora+5wKp/byxpl4HIdI3CiqHF0UeebsEzIFRw2JPJV4yjOrYHzVU6
        N8vQ/L7QvRGvNhGNJYOIsE4=
X-Google-Smtp-Source: AGRyM1vEbAeIdWfrK+9u2hl9HgwIYrMYz7g+aIEzd2c1v6lPSkyFw+pmlCQZrhCtGCD3XVSFl5aZeA==
X-Received: by 2002:aa7:cb83:0:b0:435:9170:8e3b with SMTP id r3-20020aa7cb83000000b0043591708e3bmr18090952edt.144.1656670826558;
        Fri, 01 Jul 2022 03:20:26 -0700 (PDT)
Received: from skbuf ([188.25.161.207])
        by smtp.gmail.com with ESMTPSA id f9-20020a17090660c900b007262a5e2204sm10226783ejk.153.2022.07.01.03.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:20:25 -0700 (PDT)
Date:   Fri, 1 Jul 2022 13:20:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: sja1105: silent spi_device_id
 warnings
Message-ID: <20220701102024.ewlnhtnjrpnukim5@skbuf>
References: <20220630071013.1710594-1-o.rempel@pengutronix.de>
 <20220630161059.jnmladythszbh7py@skbuf>
 <20220701071835.GC951@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701071835.GC951@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 09:18:35AM +0200, Oleksij Rempel wrote:
> Without this patch, module is not automatically loaded on my testing
> system.

Ok, in that case do we need to target 'net' and split the patch into 2,
one with Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
and one with Fixes: 3e77e59bf8cf ("net: dsa: sja1105: add support for the SJA1110 switch family")?
