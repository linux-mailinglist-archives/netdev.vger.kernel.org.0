Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A4D523762
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343749AbiEKPdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244494AbiEKPdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:33:44 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769562BFD;
        Wed, 11 May 2022 08:33:43 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gh6so4924290ejb.0;
        Wed, 11 May 2022 08:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hwv+tHRthGjMF6T+0E5omfvbRMHbBx+VEPozMcOm4FQ=;
        b=RCize1dOWO6Z2UQaXjmfoNi90tsIQzVbnmrcQmRSP4yYiMDdA4FWNns0zbKZ9Yja94
         rGX+NPjMLh2q94s92DsjoCSWkcXIk0E151EhR4Ck7Y4f3EdKmfPd1VZdMUT2JLLmA0oL
         YjgRWgYqV9CMgF/Cy6XwDDBDlzK+Cock8E6ecPudySXQI/5iGe9zMDFUfhEqwke1psvX
         xumEJOVBL7fQY2k1xWi9yrA+rKwkAHevwUwMaVtB7EUMiQkP5wpOuG6U4fCH9M3IZKOg
         w8V28Zjx+7D9j0GVILC6udoWYWo7OEz25YF+YhHGRt+aHV58WMmS8ZCzuRLMiU5kCXBg
         fpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hwv+tHRthGjMF6T+0E5omfvbRMHbBx+VEPozMcOm4FQ=;
        b=zBs0W3hkzVvvkOwt5lfwa0NTy2rmRRzfr+8thKsh6S2/iMphaVvaOnh6WXGdlLeZ3F
         UQjHwVwQnrcnhw6Pn9MxmtSSJScL0+dJ9dWKlivSpqDZCaTVJjSXjb038IcDB2rZyCzk
         Da4WumETHlElIMCBt43u3MPYP7TZMw80J9KY9EppOkLLaxJKVxcYwA12Nn9GEBkKLuc2
         51DbHALnaqYWtF7U4PDNG/kxEXyZYKWut2/JxbIOoUM5aY1zdX7ovJpUtXx7YoHQBtjs
         rtK3XUdetVEvHJJt9CoqpHpvDab0g6lNUniBz1gMPkC2MX7dMLNpQRna492YXRvTbpSn
         9Rig==
X-Gm-Message-State: AOAM530JkLsGMUqkRynk+dZubfxKOBdf9O1laYk+795TtZpxzKtl55NN
        vRHaAq6T1BxyhkawWXC6E7U=
X-Google-Smtp-Source: ABdhPJzBCHND5vtVrFsSKG9WjTxF0PdeUAJcyug8qK+/StsoULuJ4vsbhThOie/Ko9EIIQLNBpkn6A==
X-Received: by 2002:a17:907:c2a:b0:6f4:4b49:9cfb with SMTP id ga42-20020a1709070c2a00b006f44b499cfbmr24098814ejc.697.1652283221695;
        Wed, 11 May 2022 08:33:41 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id z22-20020a50cd16000000b00426488dce1dsm1337316edi.25.2022.05.11.08.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:33:39 -0700 (PDT)
Date:   Wed, 11 May 2022 18:33:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 05/12] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220511153337.deqxawpbbk3actxf@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-6-clement.leger@bootlin.com>
 <20220511152221.GA334055-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511152221.GA334055-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 10:22:21AM -0500, Rob Herring wrote:
> > +patternProperties:
> > +  "^ethernet-ports$":
> 
> Move to 'properties', not a pattern.
> 
> With that,
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Even if it should have been "^(ethernet-)?ports$"?
