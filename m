Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8388256387C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiGARRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiGARRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:17:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14148220F8;
        Fri,  1 Jul 2022 10:17:50 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r18so3734414edb.9;
        Fri, 01 Jul 2022 10:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hRl1fT5GiQR9TFaETxQucSTDY/nhuafsxdqUzPdTL1c=;
        b=eHpqzkNcCukSCQ9GKHJQHSKYTay3qxFmtq2ZU6X1BoPFrkYCccz870sNKKZQCroNAI
         CJSzu9+kL2XMiSwRv5rKzcKA5RzyMIDHksciy2zrnek1hu2RMXIBuX4oCKJ6+Dnt/sZc
         owHGGHlRTthgYz3i6hhUWQ5tdoeZu2yRrGv+Qf5ZwU+DED9Vc4mlPygi3WgywRNnFmtY
         WDpu/37X1Y5Q1w5BMyHaLw6PBPuyPwUkGMWAX8E3xQOAO2EUenod0OVGfeICIvDZ6Ibs
         0sb/9h5igEesXtIeQiz+PQwS14XNSVTirK1J70sXs8V15IXCPXMddapAu/HJZwDu9qmZ
         63jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hRl1fT5GiQR9TFaETxQucSTDY/nhuafsxdqUzPdTL1c=;
        b=kVFy/Z9aZLiNx4ItOsg+75MlUBjZW2CJMByXmx0ImYAxndqv9LAj+/nlx4KlHcVneW
         8XMXFeDhVyxWm4j2SMr1QaP+Q1uaRXen5z1Lk5AZCEpeNAXDA+QHLqG0eZR5sZSrGT2g
         bBaG7IgFZv/l1O2GEVCGtdnaiIfaJjeVG/6VtN5BnMOIFCetPI0AGprUw6v4Ywfpi2LY
         oNo2DQDHBpw2v5FemSyq2TMxqXUAUb9fnxV+uXbpccuYa2MSKESp757wiSHOG014cIPB
         wF0xDUWNjPPuVF1jHDqjHLqWeIzruG+DziwarN22Gvjo8XYJkr37XmTsg8OsyhVXIKhR
         8bEw==
X-Gm-Message-State: AJIora9SL/kFlMZWxUPqQw4MIRdUs/Rz6woQs81o7myPRMslR5NatCrE
        D6GUCVTe071le7ehyx1ktaY=
X-Google-Smtp-Source: AGRyM1vE3Y2+aukx+MB4VotCtoITOYWRe953H/qz0d4hwXqZcoN8+it2XOMSrkLDFhM8qGok8DJRfQ==
X-Received: by 2002:a05:6402:520c:b0:435:af40:8dc6 with SMTP id s12-20020a056402520c00b00435af408dc6mr20809932edd.343.1656695868648;
        Fri, 01 Jul 2022 10:17:48 -0700 (PDT)
Received: from skbuf ([188.25.161.207])
        by smtp.gmail.com with ESMTPSA id s10-20020a1709060c0a00b0070beb9401d9sm10749599ejf.171.2022.07.01.10.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 10:17:47 -0700 (PDT)
Date:   Fri, 1 Jul 2022 20:17:46 +0300
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
Message-ID: <20220701171746.lpxsbi4vgk6r2g3r@skbuf>
References: <20220630071013.1710594-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630071013.1710594-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 09:10:13AM +0200, Oleksij Rempel wrote:
> Add spi_device_id entries to silent following warnings:
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105e
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105t
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105p
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105q
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105r
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105s
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110a
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110b
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110c
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110d
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
