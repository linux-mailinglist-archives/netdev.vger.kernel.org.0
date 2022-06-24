Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E326E55A42B
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 00:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiFXWEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 18:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiFXWED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 18:04:03 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E502A2AC9;
        Fri, 24 Jun 2022 15:04:02 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id h23so7268611ejj.12;
        Fri, 24 Jun 2022 15:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B7CbF/eHVpTLIpu/caWo6Fgq1Er9yzU5olt2xIVAwzU=;
        b=E9shHF72RjZojpZn7ZP3+qtfItqkWzUor4lEheGp2EyRCvkBxLHandaeQnNWUZJSBJ
         5scq4y906YbiDkpcu4pAMNuWFAC3m2194ljEO+Axw0Br0+tBgwBULRC8880cHD6uB1Nz
         hnxLIQ/IK5tMC4uB5E+JQ8Cvjg87WgyWi74YmTOixKERMnpYy40rCM32KVUmDpKOhEWQ
         5Opt4x0A5crmAbLg4mmvNQGLg49z9tqXU4slBy573nasq0YRDFCTnMEjoQi17zqqKjXx
         k6SSS6qE80XNflJ6Do6+YloPevaRKeZk5l2l4hm9iAs07B5Q5blGp44rrQLIoYuOUUbl
         8Vhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B7CbF/eHVpTLIpu/caWo6Fgq1Er9yzU5olt2xIVAwzU=;
        b=GNoAjVT7d23wuVj1oilmmZEasYrZJycY1PFPGJHGA6kK9DnXjf8i4v3FLdQLYIUNRr
         lr4hf/WytMEvvQCCyoH5jy7E9xYYGXv58rd3lpfi5z96akzW/Gw5FBAey56QFbzzt0kl
         +PCsjBgjK4Ax45G4RX/9FlII9HdzcHpYN/teYYG+Z1u5g7QIJJU0z6evnaFG0tU1T2vP
         l7Zo6tlowbby4FhSOK7xVwtmhNBwJFUyMVsdtLRrnxf+OcLta4TPlAIEav+MH67+/CpQ
         nAY7EeeVeFcPbyZ7L8z3Engh/Oqf8LWxraXm+HutbeI+gWhBOVbgeAOKvT5sax1lNLvE
         fuwA==
X-Gm-Message-State: AJIora8ElRhmse86/xYO6FhmOTH4hdDWiJG7xLt+BLK4QLOHLA3GOM7e
        tu1JCxmcQZlDR375ZINdXoQ=
X-Google-Smtp-Source: AGRyM1sk1Ci4EOsIOv9m5FnkNM34Oh/4nGgSKS2JomW9dnp37Y+yNwaBDT2DbLCbD7PvIWsVbFDJ6A==
X-Received: by 2002:a17:906:4fc6:b0:722:e739:53cb with SMTP id i6-20020a1709064fc600b00722e73953cbmr1146880ejw.128.1656108241530;
        Fri, 24 Jun 2022 15:04:01 -0700 (PDT)
Received: from skbuf ([188.27.185.253])
        by smtp.gmail.com with ESMTPSA id s18-20020a170906501200b00722e49c06e8sm1711772ejj.216.2022.06.24.15.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 15:04:00 -0700 (PDT)
Date:   Sat, 25 Jun 2022 01:03:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 1/3] net: dsa: add get_pause_stats support
Message-ID: <20220624220359.fvxvhionjhagwi3q@skbuf>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624125902.4068436-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 02:59:00PM +0200, Oleksij Rempel wrote:
> Add support for pause stats
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
