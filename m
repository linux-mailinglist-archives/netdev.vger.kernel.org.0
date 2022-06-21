Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5138355321E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiFUMfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350446AbiFUMfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:35:15 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337322899F;
        Tue, 21 Jun 2022 05:33:39 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n20so20394080ejz.10;
        Tue, 21 Jun 2022 05:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5o+zdYM+vlkJ/ETr8IZbrEttMVwvTnCxmkgyjTPOaXA=;
        b=X0hNhBuvvzekBU5xUsYNIQuUHCsyFw+nBSCpEZlMo4JzSiJaUMmPMPpDpCPXSGcnKk
         0v7VNyUdJfLeycUJVOxYKoGUBnsexBsCCydma6QwiqmtTL6j56Vw22vgf6a/9Y8q58vh
         EBnmF0HpeS7SK7fSLmOVPWGxOWByeVkBLH0hOIiR+CDT3/W8wpa7AAy40eeqT5+E9RSr
         aybr/leJa0E1bXH20IhAVjVpmmftJfyjMh67Y4dh/oA+nXGu/o4UpN76swlvu8Xuw+8c
         EPdwj6kYI5vY/i2EzQG/OkDdlj1nnxCHF9ReDmyKJxNeaH3bJZst1EJqmqgoTQjVnfat
         H1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5o+zdYM+vlkJ/ETr8IZbrEttMVwvTnCxmkgyjTPOaXA=;
        b=baGF+vENFwLVLbTRZJh31+/9SJDqMnneiNGODp2R5jEbX/rBMfXeFRVYLEUMLk4zTY
         mQi6iitqu9cCIifnu2bHG1ceOdcw2PDKgRLhLhD25dfdd/38sr6s+rIyjwEko0/+QYYE
         p8jUaaLj/3QQ2occv9m2OAQntBxjITndX77fz3JB0MGFGoQd7aC3dyHlLwVSRBjU9Brd
         jc9/zH/pjGSx2RNHA1Wsi3WbI0b2togcoeZiO9bkIop9ihBmwQTvLeu/fDGk8UaxBYo2
         8gHBwA7VTPanynGOaCbctXQKUKNeTHe2ciIfLA6Qwgxq686mMf0gh7U8irUH9eHXrYMh
         hkyg==
X-Gm-Message-State: AJIora+QZ+o1yshHwysJeSXhHrAW9pTgBEnWKNrK52BdyHg2vVex5ymj
        fiuEN7Vrz7HN2wwFERR+YVo=
X-Google-Smtp-Source: AGRyM1u/qFBVbWaGw+p34D5Bgxy/Px8eZZ63zLweGlAIH+BpOMkrI1zgzcd4oX6umfyCsO5OaMZ1+w==
X-Received: by 2002:a17:907:7b85:b0:711:e42d:4955 with SMTP id ne5-20020a1709077b8500b00711e42d4955mr25806477ejc.482.1655814817731;
        Tue, 21 Jun 2022 05:33:37 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id e15-20020a056402190f00b0043580ac5888sm4785419edz.82.2022.06.21.05.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 05:33:37 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:33:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: dsa: qca8k: reduce mgmt ethernet timeout
Message-ID: <20220621123335.gvuuob7pnlz77lof@skbuf>
References: <20220618062300.28541-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220618062300.28541-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 18, 2022 at 08:22:58AM +0200, Christian Marangi wrote:
> The current mgmt ethernet timeout is set to 100ms. This value is too
> big and would slow down any mdio command in case the mgmt ethernet
> packet have some problems on the receiving part.
> Reduce it to just 5ms to handle case when some operation are done on the
> master port that would cause the mgmt ethernet to not work temporarily.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

I think this could very well qualify as a regression and have a tag of:

Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")

if it was presented along with a situation where users could hit some
real life conditions where the Ethernet management interface isn't
functional.

>  drivers/net/dsa/qca8k.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 04408e11402a..ec58d0e80a70 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -15,7 +15,7 @@
>  
>  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
>  #define QCA8K_ETHERNET_PHY_PRIORITY			6
> -#define QCA8K_ETHERNET_TIMEOUT				100
> +#define QCA8K_ETHERNET_TIMEOUT				5
>  
>  #define QCA8K_NUM_PORTS					7
>  #define QCA8K_NUM_CPU_PORTS				2
> -- 
> 2.36.1
> 
