Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C675B9FFD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIOQwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiIOQvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:51:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318119FAA9
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 09:51:14 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y136so18654825pfb.3
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 09:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Nn1cJu1jORyCNe/5wzl/IEFzyhLMt4keHpzAUkg6I0U=;
        b=MUmu5V1I/8zYKFJ+A5UwtKdPremRHxJnGTAXqasxA1EYPmjFOcRJG+G15qZg4b9ZxY
         Z2V3tq9GmY6Nds1gmuafpt+xi/AccAuSo195WFJmd5ExR6Z3nLap8/VFIbG2uNgWPUx/
         hg0b3RF04IasaOxVi0dOuHtUianeWO+GzuBHkIZrOjaU/+uyFcqPBba+vPoDv6+fHFIw
         twnaZt2BKL1oDXsDZFAYUKeyKDfp+uWE+8rbqrOweHEtRH1uWhqySHUpG4Z/9pHi5qf+
         ZxfM+TjSG6OnntlrKJCkMYfPxW4ff5LcbZ4N0INyu1eU2Hg41kpjdt7DCVIuAAq7LFs1
         uoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Nn1cJu1jORyCNe/5wzl/IEFzyhLMt4keHpzAUkg6I0U=;
        b=Z6qzB9uDNSTgQPNZ/qQo2Zi0hiswj5ENelbOooAV/Do6ckjtbG8iB7r55rJ55YLyjt
         cgB+K2b+unqYhW52nWdp7BYuAIAf8Nukrm/VtUaHYVEC2rz1qUuto4nuIsmmg4jRw3mX
         kcFkGjuijpPPY80aYVQ68PDxSQgm3d3a1z+uhYpAWY8CuBv8PjdynjtP+7UCNrukhfFo
         IJ55LxA12tum15JNuKEsbTvoJq8r7h2yuVzCXjy9lRyV8/+aX0Q/0wkY8dJT/cPUff9l
         TRz4HNyzJJK59iBTE1t2PhD9YCNOV6iv7xEp33BKCOa0tFn6Cm2t8WIaamW1Okd9Q3lq
         uazg==
X-Gm-Message-State: ACrzQf1vBQmxIrmyJ9Hj4opdjnBPPQBnnyXssjGTJOihAs82Nle0MA9e
        5r14GOHVW+xmiFw8LxJF/dY=
X-Google-Smtp-Source: AMsMyM6H+43n5TvUY52mP/8EnugboDGFsiF9fYvZklTjxududhT0LbTnBW0oQqThRce5lwv89+697w==
X-Received: by 2002:a63:e118:0:b0:438:7603:8d6e with SMTP id z24-20020a63e118000000b0043876038d6emr707499pgh.72.1663260672623;
        Thu, 15 Sep 2022 09:51:12 -0700 (PDT)
Received: from VICKYMQLIN-NB1.localdomain (114-38-91-185.dynamic-ip.hinet.net. [114.38.91.185])
        by smtp.gmail.com with ESMTPSA id d123-20020a623681000000b00536fc93b569sm12770981pfa.200.2022.09.15.09.51.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Sep 2022 09:51:11 -0700 (PDT)
Date:   Fri, 16 Sep 2022 00:51:03 +0800
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Liang He <windhl@126.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] of: mdio: Add of_node_put() when breaking out of
 for_each_xx
Message-ID: <20220915165103.GA149@VICKYMQLIN-NB1.localdomain>
References: <20220913125659.3331969-1-windhl@126.com>
 <622cae81.8543.18337696f77.Coremail.windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <622cae81.8543.18337696f77.Coremail.windhl@126.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 11:13:20PM +0800, Liang He wrote:
> 
> 
> 
> At 2022-09-13 20:56:59, "Liang He" <windhl@126.com> wrote:
> >In of_mdiobus_register(), we should call of_node_put() for 'child'
> >escaped out of for_each_available_child_of_node().
> >
> >Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
> >Cc: Miaoqian Lin <linmq006@gmail.com>
> >Co-developed-by: Miaoqian Lin <linmq006@gmail.com>
> >Signed-off-by: Liang He <windhl@126.com>
> >Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> Hi, Miaoqian, 
> this Sob should directly from you,
> please do it!
> 
> 
> >---
> > v2: use proper tag advised by Jakub Kicinski
> > v1: fix the bug
> >
> > drivers/net/mdio/of_mdio.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> >index 9e3c815a070f..796e9c7857d0 100644
> >--- a/drivers/net/mdio/of_mdio.c
> >+++ b/drivers/net/mdio/of_mdio.c
> >@@ -231,6 +231,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
> > 	return 0;
> > 
> > unregister:
> >+	of_node_put(child);
> > 	mdiobus_unregister(mdio);
> > 	return rc;
> > }
> >-- 
> >2.25.1
