Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5805398E7
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 23:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348071AbiEaVli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 17:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbiEaVlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 17:41:35 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E346873542;
        Tue, 31 May 2022 14:41:34 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id rs12so29078150ejb.13;
        Tue, 31 May 2022 14:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7rh5nvb4XbF3hJdZaalfU68PU7CQH9LwSIEOWdUV9YY=;
        b=ggqp+1Ib/3AwFyHbxbcSWc1omJFIDJNOLpmP611Z1rV6AvJYhQMTr8XBh6g3p80Y/D
         Qe01a0JWXV8iuYkieOMLLIndI4q7UWS+7zDnzms967ygH9mlEUJCLrIelsOis+orSh2w
         RdnAhALoOEn05aPNUGNT7YNiDWZRY81WlSzLFLlEywPfgp6+QScXEvsF7X46qzw27Sry
         BqGahmV0wuHurImn/9wBvGo3TsfJE2eD9327q0mprXw96fhOPOzT81brOtLAfKOgMfiJ
         1FiAlkDzSdATkDB4aDe+dmH8ALaxgDwCXg48fq9HbM7xUKtioyVX/y0RUtlMXpVLFYxq
         QrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7rh5nvb4XbF3hJdZaalfU68PU7CQH9LwSIEOWdUV9YY=;
        b=mJzwNbgtlh0aehSKOyqSrCbpfvA/BqcWTID5US5euakEnidy1Ql6xszcbAHYVIsD6s
         lg6B9WfzHbWGi7lLJ5ofLSPplwRKNdjQ8/ugBS/mhsIVgK2T0PyzCbuTFtPvi8l4FpsJ
         5WTpIEMMPCZe2LLlWsm25tcSGrMEvOQe81OV9LRoCyZ1knYn/AJ0pSrEwk6EINWNu6XJ
         f1nDNk3FQuOD8r/yTuyRspK4+KE3yK+BPNdTT06VZRk+th8txPDaQgByYItu4Vnoqz7G
         MLW/cDZlVxbe4IHGYbTYwxKynec6pIcswoR1MumaL17obxcnUWAkvRTMckH3J88Ixcdu
         ne/A==
X-Gm-Message-State: AOAM532UWQeb5xSDs3sTdj2WsPnQrTyLhCLxDOWdWf3j6jel3lMn2jrb
        gnPoosd+WVcKQX8H+uD5xbk=
X-Google-Smtp-Source: ABdhPJwg1/SvmiuuszgYtn4LfM6R+BmuVOyRSLr+lW0JgoalyC71TFl4QS3CAfZX9d3tmXtIh/38Yg==
X-Received: by 2002:a17:907:629a:b0:6d7:b33e:43f4 with SMTP id nd26-20020a170907629a00b006d7b33e43f4mr55668365ejc.149.1654033293350;
        Tue, 31 May 2022 14:41:33 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id pw18-20020a17090720b200b006fe7d269db8sm5288528ejb.104.2022.05.31.14.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 14:41:32 -0700 (PDT)
Date:   Wed, 1 Jun 2022 00:41:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net/dsa: Add spi-peripheral-props.yaml
 references
Message-ID: <20220531214130.fe3bpyb4jxhkyzjr@skbuf>
References: <20220525205752.2484423-1-robh@kernel.org>
 <20220526003216.7jxopjckccugh3ft@skbuf>
 <20220526220450.GB315754-robh@kernel.org>
 <20220526231859.qstxkxqdetiawozv@skbuf>
 <20220531150101.GA1742958-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531150101.GA1742958-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 10:01:01AM -0500, Rob Herring wrote:
> On Fri, May 27, 2022 at 02:18:59AM +0300, Vladimir Oltean wrote:
> > On Thu, May 26, 2022 at 05:04:50PM -0500, Rob Herring wrote:
> > > On Thu, May 26, 2022 at 03:32:16AM +0300, Vladimir Oltean wrote:
> > > > Also needed by nxp,sja1105.yaml and the following from brcm,b53.yaml:
> > > > 	brcm,bcm5325
> > > > 	brcm,bcm5365
> > > > 	brcm,bcm5395
> > > > 	brcm,bcm5397
> > > > 	brcm,bcm5398
> > > > 	brcm,bcm53115
> > > > 	brcm,bcm53125
> > > > 	brcm,bcm53128
> > > 
> > > Okay. Looks like you missed bcm5389?
> > 
> > I went to the end of drivers/net/dsa/b53/b53_spi.c and copied the
> > compatible strings. "brcm,bcm5389" is marked in b53_mdio.c, so I would
> > guess not.
> 
> The datasheet I found says it is SPI interface, but I guess someone that 
> cares about this h/w can sort that out if needed.
> 
> Rob

If someone adds a new compatible string for a SPI controlled DSA switch,
I will remember to remind him to update the dt-bindings doc as well.
