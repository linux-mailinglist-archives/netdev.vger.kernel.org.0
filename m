Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F0C59EC4C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiHWT1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiHWT1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:27:22 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16E4816AA
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:14:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c39so19100453edf.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=33rl/btDpnjrhyzizIPpxy/2vxqpyqvjjCKRXBb+pXk=;
        b=E58vLjIWLiVvRitfjurOJnQK14IMw8T7G22bYOT9QKjLTPlCHLS3m3XfHJuYhwqvvW
         BnEnYC2tJoK8TV0BJpo7FCgZX9iORbx0+u8iMvgG/ypx/ViMmwOxbFtZRMheF2udI6uL
         FctDoSqDAs1o+lFhnHQoxEtAdK/hnGdEinyTQuwAmO1359mxj2VVgrCYd85P38Nv1WAP
         m/iB4J28q5lZ0UFwtfkdp42hNO1LF4MIvAUGfJ6IXIw3NbP8Rd+TNaFHX5xbUwI9WALG
         foPLPIbLfgK0cfnLflFXUDzdaImgR2KBD6wNho7C4kLOt1WMCWw2Fq0JkSskPkW4ZF0p
         rMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=33rl/btDpnjrhyzizIPpxy/2vxqpyqvjjCKRXBb+pXk=;
        b=rmWVCcIwHjsZVkYUHMtFC11Hv7o0w+JUNBe9Rjru9Cz6GjKBrk3AXn6xjRu6uTYJKa
         ZJkAf9ZRT2zPbf5xtOzRu4p0DKLWjX8Z/XqTUKO6nhx5IvmxowSUufKtnzviePqSdZ/u
         ir4OUMfRNIPH/HUiXdXyWgpbpdVVf7kBIWY/dfljDzi7P/nfTbZfFTzGXsFw2BP1ft2c
         DQahpFmhIuiV9xbOTMThh5d4l0YsvXfDh8OfwAehuIN5vr8FtBI7ilgnyJr19cONVGw5
         6+gLwkUjba9LelXO5GgT5qktJ0b0RNZFXNY+v8QIRD4YNxXJ0jdZ+hpu8etuZPk+U+Wd
         QDKA==
X-Gm-Message-State: ACgBeo1Np7LeTQWOzMqJfqfGQ71A0OFEKOHUiTee/EVn3RtiOdnSzm4Q
        oM/FxrjYb+v3QMoqAYhWyc8=
X-Google-Smtp-Source: AA6agR5u54u/ACvTagPMWBQ/LaU8WvLAtjhMm71NUDZ8ekzdmrgzWAYhAnZ2B/gEGGSA3sY2TCFQUw==
X-Received: by 2002:a05:6402:2691:b0:43d:ba10:854b with SMTP id w17-20020a056402269100b0043dba10854bmr4563739edd.158.1661278421741;
        Tue, 23 Aug 2022 11:13:41 -0700 (PDT)
Received: from skbuf ([188.26.185.16])
        by smtp.gmail.com with ESMTPSA id g19-20020a056402425300b004462849aa06sm1844424edb.5.2022.08.23.11.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 11:13:40 -0700 (PDT)
Date:   Tue, 23 Aug 2022 21:13:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: microchip: Support GMII on user ports
Message-ID: <20220823181338.zyzv3qkd2g5oecjq@skbuf>
References: <20220823104343.6141-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823104343.6141-1-marex@denx.de>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 12:43:43PM +0200, Marek Vasut wrote:
> The user ports on KSZ879x indicate they are of GMII interface type instead
> of INTERNAL interface type. Add GMII into the list of supported user port
> interfaces to avoid the following failure on probe:
> 
> "
> ksz8795-switch spi0.0 lan1 (uninitialized): validation of gmii with support 0000000,00000000,000062cf and advertisement 0000000,00000000,000062cf failed: -EINVAL
> ksz8795-switch spi0.0 lan1 (uninitialized): failed to connect to PHY: -EINVAL
> ksz8795-switch spi0.0 lan1 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 0
> "
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: Arun Ramadoss <arun.ramadoss@microchip.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>

https://lore.kernel.org/netdev/20220818143250.2797111-1-vladimir.oltean@nxp.com/
