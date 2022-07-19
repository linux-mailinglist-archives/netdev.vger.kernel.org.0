Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68637578F5E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiGSAld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiGSAlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:41:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241A24947;
        Mon, 18 Jul 2022 17:41:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id tk8so12988856ejc.7;
        Mon, 18 Jul 2022 17:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0UFO2LEB4N3gT8fM5N0L2BjWrPKcIQI1x0+D9+PXyM=;
        b=CrsObfdoQkRTNBGQviz57J895etCe1uCs6faYu8P9SApkKbWomIm/hs3s7+oYHIULl
         FVYWW0/w/csJyjTU6BpJBb9aHdYFWI05ZR9s9+ubvInSO1K8j7u+NM2eARqCag4FrPUc
         Ax0xXDi35ZeMgzJ9HnCM43PQawEcART3F5Yyul+sWxMI2Auk/h27zBlc/kB+UUJBBVMQ
         IUOd4OrTYiUAo4VBnWUECIXMm/pILggQhzNGN3pRWZLy+vkipLooLggqlmcNLSOrQy2M
         JflfZ1PICW+KLpe6DrtyEDZa+kP3XxvUybLwldorMfSbd2fX4HGJdXmMiP9ItRqSQjQc
         7a6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0UFO2LEB4N3gT8fM5N0L2BjWrPKcIQI1x0+D9+PXyM=;
        b=nph7fztI5LX5YGGv6ml+HB8+IYp90OM5vj+xoy9LslNgoGF9/8xryuN5jajE63qN0Q
         5IQie48uPeJkXsV74EBi9Di6gxfT+ZAEI4GlMyqJSzC9A0fSjO+Q75S5FBo9zzHyPtHD
         speLqXREgHVfCLawJh7xq2VFLG1IrQ8GVmn9RVNEABNqMGa94m0HCDW/K9W9V359QAEh
         Dn+PcOAK27WaqCrHIt7nidR3ch/PTQLVyCl9XsBXmpQzve2zn7su0JWk5m3BfAW6gu8T
         /zVIvamy6WCnFe/5uWi4JCGMgUf4GZmxTcwRyNlcKcbYD+lnX3BycDKXyQPiEDXTT1Pg
         Ao6w==
X-Gm-Message-State: AJIora/SkGNWS5tjN5pGIiEwqtJ+CwYTvLkO+EH35QBinvgrKeCt+w91
        EYxr3SrRdoF5dn9T46oJy+Q=
X-Google-Smtp-Source: AGRyM1svc/KRbFwjDP944pTBOdvhHaa4ZAuA4xFFY+a7/Zcbuaqb4XYRStVOgEjyFucz8SKjqDGgkA==
X-Received: by 2002:a17:907:9706:b0:72b:4b0d:86a2 with SMTP id jg6-20020a170907970600b0072b4b0d86a2mr26993817ejc.242.1658191289781;
        Mon, 18 Jul 2022 17:41:29 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id d25-20020a170906305900b0072f42ca292bsm1095210ejd.129.2022.07.18.17.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 17:41:29 -0700 (PDT)
Date:   Tue, 19 Jul 2022 03:41:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
Message-ID: <20220719004126.2ysae4vhbmfnqsta@skbuf>
References: <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
 <20220718203042.j3ahonkf3jhw7rg3@skbuf>
 <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
 <20220718234358.27zv5ogeuvgmaud4@skbuf>
 <62d5f18e.1c69fb81.35e7.46fe@mx.google.com>
 <20220719001811.ty6brvavbrts6rk4@skbuf>
 <62d5fc18.1c69fb81.28c9a.a5c2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5fc18.1c69fb81.28c9a.a5c2@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:17:20AM +0200, Christian Marangi wrote:
> Wonder if a good idea would be leave things as is for now and work of a
> single dsa_switch_ops on another series.
> 
> With "leave things as is" I mean that function will get migrated to
> qca8k-common.c and exposed with the header file.
> 
> And the dsa_switch_ops is defined in qca8k specific code.
> 
> The warn about the 23 patch was scary so considering this series is
> already a bit big and I can squash only a few patch, putting extra logic
> to correctly handle each would make this even bigger.
> 
> Think the right thing to do is handling the changes for single
> dsa_switch_ops to a separate series and at the same time also get some
> info on ipq4019 and what can be generalized.
> 
> What do you think?

I don't have a clear mental image right now of how things would look like,
but I suppose you can try and I can review the result. I imagine the
only code added now that you'll need to delete when you later migrate from
switch-specific dsa_switch_ops to common dsa_switch_ops are the function
prototypes from qca8k.h, since the implementations of the dsa_switch_ops
will become static functions at some point in the future.
