Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF30063911A
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKYVcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiKYVcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:32:41 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4328E186E8;
        Fri, 25 Nov 2022 13:32:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b8so7894425edf.11;
        Fri, 25 Nov 2022 13:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VONFYT4AURNaTYs5rJwmKOLQ/6WDExSPVR7SnweH9a4=;
        b=C9WQHR/1b4JUCiAnW2MDxbKR7WmToTeLJDTuRcHkadgtmXgEWMWUuvgfCbh/t21MkK
         IKgsWdQpK7uZSjA2kubI3GkXymFc3skjdL14plk15AwrjHMenLgmZzPrafWptQTM6PFx
         1EFBHwHgfjhl2m4WJVF7tqhYA065RHCBsYa7v1jL/5QNeFunCeiZfjcG8r6426SLPmA8
         2dX02CBiyLOf44bWk86pKoZNpHLzwDKuKJ3XnRmmVHEUDQXTDAXTj9Yg8bSmRgbnBPYg
         5hlPXiwtSNRBttCitr2dkFxpDIHOYaD4RW0zu9xyoHr1hJAHoFTJZ6k1CB+EgaGqSNzU
         xTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VONFYT4AURNaTYs5rJwmKOLQ/6WDExSPVR7SnweH9a4=;
        b=RzbVYcT0ghXbt1E4t3dJNVwkbBGCFsHeq08acdLMXEtPLVBQAve38swvKEK/C+Osue
         GveJF31aAZC38CcbbtrlGqDn9UcW9o1uUbj6O0hiYph0ZTXJ0Geg/1pCeYd5uzSSV/K3
         bHPKY2aMR5YIGcAFFhHQb1k+EdhqEXFASY71UXBXdBz0IGnASPuxb7Ft8oW0AGY7fklA
         gZKKg3tWEXTb2z6pOmfcAJ2YUl/v60I55b024NXD0LZE+qrvmGECHQuFGadlf4YJRjn1
         VE9CyKjR+W82TZ2gRCRj6g9sHN6KEtlOTv8Y7DRhMEZtVh3jAtntA1ij0xy68ZX+Nalz
         7HwA==
X-Gm-Message-State: ANoB5pkY0GSUVJTPlhUNgQQ2zhhGik8CkVK+iCaEaevF57+b0u+57ClA
        7FreIDucPfnQIUK2gFRvO5M=
X-Google-Smtp-Source: AA0mqf6m6mWQQ74JBI+aQyE5MBqgwRA5k+DZUCfyOXodcv12VVI1/EpNsz6p9NMySXwonAyzKsnr4A==
X-Received: by 2002:a05:6402:4284:b0:461:8156:e0ca with SMTP id g4-20020a056402428400b004618156e0camr4025383edc.271.1669411956618;
        Fri, 25 Nov 2022 13:32:36 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b007add1c4dadbsm1977455ejt.153.2022.11.25.13.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:32:33 -0800 (PST)
Date:   Fri, 25 Nov 2022 23:32:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v6 5/6] net: dsa: microchip: enable MTU
 normalization for KSZ8795 and KSZ9477 compatible switches
Message-ID: <20221125213230.da42rnyolrxpybng@skbuf>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
 <20221124101458.3353902-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124101458.3353902-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 11:14:57AM +0100, Oleksij Rempel wrote:
> KSZ8795 and KSZ9477 compatible series of switches use global max frame
> size configuration register. So, enable MTU normalization for this reason.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
