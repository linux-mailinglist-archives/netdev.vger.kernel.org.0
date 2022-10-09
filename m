Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFD65F9278
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiJIWtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiJIWrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:47:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD1D45053;
        Sun,  9 Oct 2022 15:24:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d26so14384172eje.10;
        Sun, 09 Oct 2022 15:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwL6Q06tcEg55k3CAW/++tP9oxeC6z0U71pHVEC/xds=;
        b=ODA1nHe7pTAuAXx7eAAlL2NiZlo9nIvFHRwbLrnZM12NnHCVUjBOOpqiUiUeDdzukm
         EqAtRBdozD2WDfPX1ZPqGitX2hqUyJV2moBdRrCOIC42b/Pst6EkrDlw8DSEzMzS2bXL
         VUr/CoPUIo0lc+sYLIioJgJZxHfcNqbV3NxLKBIcSxT+fM7HUTdItCi7kOiWnO3J9zlA
         frCqrIiMRRhOLBYLfyoLi2gFgZbXOrUpIl4WXIwXgE6H5DLYxln/HvBVLl0W235GLMBO
         dFC6jk5mRlSTERJd4xCR/vD1Ex5od6oA6FUZ2DnfpETRQC81fhTT/HLcYwLUEeNImLXB
         l2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwL6Q06tcEg55k3CAW/++tP9oxeC6z0U71pHVEC/xds=;
        b=AdCOduIaiqCJQsWr+FJ8jX1hD8WNIVxv3b7r6P15tUrhyTdpFQ9TdolszkDUu00EsD
         clfmVkWrgwtbw0AFuzQ+sM9rH+lhLO4Ry5WFpq11SSBVLCAqQ0UN1/F6bxDYRs2KdRLI
         OGhw6jyyHW7zrnbScR2+yPZ/J5e+uqMl14ok22RRsP0KSnSqPvJbTlfshQR9C0bFHivv
         KNcyzHlGF9dhczfNohxctjjfEG1OkxtwXb9S6WJKbWcZC7bnIjgyiWtuQ9bph4HZkmCF
         fhJedrszVjaaAB6JOsW5OCE3N31GwlaQcC3pQ7UDuoHpfRPR3FyMnNo6LJIJj/voDVOL
         Gqsw==
X-Gm-Message-State: ACrzQf1qL1Fs6Hu2AW8d52ueNfYvmh1B6rd0w9bD6kGMK3RuRhcg3Wfv
        Id9rpgwObfGdKUcA0b5FGjiaoNtGAOaTOw==
X-Google-Smtp-Source: AMsMyM5LROiCFvnjZqpAQWZUWr7W1/ylm2/RxW7l9ph9FFB/Oa1f4prvYtNDkb3co/rCQpIBgR3aXQ==
X-Received: by 2002:a17:907:1c98:b0:78d:3b06:dc8f with SMTP id nb24-20020a1709071c9800b0078d3b06dc8fmr12388589ejc.58.1665354181351;
        Sun, 09 Oct 2022 15:23:01 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id p2-20020a056402044200b00458c07702c1sm5849031edw.23.2022.10.09.15.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 15:23:00 -0700 (PDT)
Date:   Mon, 10 Oct 2022 01:22:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Message-ID: <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
 <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 05:20:03PM +0200, Krzysztof Kozlowski wrote:
> On 09/10/2022 00:56, Vladimir Oltean wrote:
> >>  
> >> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
> >> +M:	Jerry Ray <jerry.ray@microchip.com>
> >> +M:	UNGLinuxDriver@microchip.com
> >> +L:	netdev@vger.kernel.org
> >> +S:	Maintained
> >> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> >> +F:	drivers/net/dsa/lan9303*
> >> +
> > 
> > Separate patch please? Changes to the MAINTAINERS file get applied to
> > the "net" tree.
> 
> This will also go via net tree, so there is no real need to split it.

I meant exactly what I wrote, "net" tree as in the networking tree where
fixes to the current master branch are sent:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git, or in
other words, not net-next.git where new features are sent:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
