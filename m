Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1D548363
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbiFMJc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiFMJcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:32:46 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B760B18B20;
        Mon, 13 Jun 2022 02:32:45 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fu3so9986540ejc.7;
        Mon, 13 Jun 2022 02:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ouugFA4wvIvBuAMFZVHlrzyWmRsNThmM8N7DKEf0gGY=;
        b=oblnuSouSDHMuqqARXqLd++pJVy0ujuQRDiQLY4ejPoBD5wsxfGqhSrTcVzAt5Gt26
         QiFuWxurpt5YZkOQSm0Tp3o+xudHbm87PKyI1FPii/mfmTQp3wb57k39LNfQgEWzcUuw
         1XsQCib9W/SQti9C/PVNRuWN7jfnY4msyCtg4/4eRZqlPqy+XogtJ7RCKQJr82OPwibF
         cyIX2cItdXwXnywtg5EwwRXFHO1cje+97NICmD3MxynF8a9kt00y+/PvexlP0UuJExTA
         tpA6vBc642YpKduVNWMGqRHC66OD1i1VwG/rWg+nhOpRhi0vKSBXjAayFRyguvLNUNwy
         Pv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ouugFA4wvIvBuAMFZVHlrzyWmRsNThmM8N7DKEf0gGY=;
        b=XH7pkNp1MJJEUkN8ugSWGiZHhIFTp7l+ifY0qwUqmwlQtuUKEqmFrQu2fUr7V6cgyH
         vu+dWFfRxonQdgjYeSNbyWFBzGPR2otEKsNObJ2qePCkUPNamp3YZ00qS744kYli4us5
         RJSyzic3ABtQrzz7sRCmclkOdm/AK23jYg27bMArCYgt1M0kw28/afUIE2JEdP1SG4t2
         LzTYdSotJLRMHWkK78nLbCM26zlGu5s0XKJOd2l5UOwb4WUJRiOAij3EHr4YyXuUoxvC
         EGoiLDjEZn1RaWdB9fz/QudLVNR/uXnh2Thfnfg2V64b9YJ92WfN+h70rOcEyw4jQhd0
         CfrQ==
X-Gm-Message-State: AOAM5308zj8033xJ1N6I6Rq47azbZ5CM+uOniOQlcOrkpQUDtL0YG1Lv
        aWv18kcUd/HimU5IE6z9QJM=
X-Google-Smtp-Source: ABdhPJwAs1tRfFppx8kO1Vel1dF59AAvl8ss/jjooMB0Wgg9BxIlvxBNGJxskC/qCCUplkShMlSgzA==
X-Received: by 2002:a17:906:fb0f:b0:715:7e23:bbbc with SMTP id lz15-20020a170906fb0f00b007157e23bbbcmr6489946ejb.373.1655112764229;
        Mon, 13 Jun 2022 02:32:44 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id h1-20020a17090791c100b006f3ef214dc7sm3614269ejz.45.2022.06.13.02.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:32:43 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:32:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 07/15] net: dsa: microchip: update the
 ksz_phylink_get_caps
Message-ID: <20220613093242.ja2jbmhi5uucsavn@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:49PM +0530, Arun Ramadoss wrote:
> This patch assigns the phylink_get_caps in ksz8795 and ksz9477 to
> ksz_phylink_get_caps. And update their mac_capabilities in the
> respective ksz_dev_ops.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
