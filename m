Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F7550C3F0
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiDVWN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiDVWNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:13:02 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F1530A40D
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:00:10 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id z8so10389085oix.3
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b5eU7gPx9t3klRzKCs5VFN3zrCi+uJ+ZaTV+VNObwqU=;
        b=mRD3JbRttSEeOM/5KeWRA5L/3QQuhIMHFTmgEM84OOc0PWVVjnJq0N0awz8/QBbhjQ
         p/RBNQjsddhXWR21tPhhg6/ogp46ktV6a2PF5vD76XdGB0k1ShRLKL4/AoWD3SkwCyQN
         dsiA9sAFWtbs2G1xc3713JUql/Ajpfo9qOrnSNqAMROBebR4MCrXXND/YH87vuK66lbu
         I15H0cVekcYWmy7uTfUtW+kiE9XJz1WKyCq5KevvunSa1QVOVpA98c5gCDX/4CAdVZhy
         +5RuezWEFzBRR6Bc1+OnWXcOtYmAa6I8tLtZrUL4uUxGNtIk9+hDdUyt4E7yRV2UbyKk
         U46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b5eU7gPx9t3klRzKCs5VFN3zrCi+uJ+ZaTV+VNObwqU=;
        b=lqhUQNsZIf0CkJOGoXu4fq9M6Z4RDGLU7jSKZVgkrVPKrcP/BeUJcrstZ4NdIAqg/8
         6lTC47gzO2YJWS0WI8L8dsyza2XAzSg7Rk13dQoCwd7jIWymydhEzq2X9EqAzjBzW2gL
         5HiIGBNgURH58RpHnuCk0lzO9dBHBBHwI/lZrCg+lq6irT2xMhlSj4AnrcUFi5KceV7j
         yLviiyOWS5roiozWSwrQGvYG0KDRNz5mT53s6XbZ4XXt0d3H0BCSp/VZ3FE4kCVIFU/y
         ee5KiefYwDX1LcZh9cjfVYUd1FBTYw9SJ75UXBYlEn/eDQpx5mSCiW6E28jsGXNNbJWA
         wfkQ==
X-Gm-Message-State: AOAM532tEx0b3ExP3wJwvb1J8SioSz8P4QifjE+F55Z28sEt5HxjYF+R
        sEMSYpbFzDDhI61jwe0wfRd+vLoTB0A=
X-Google-Smtp-Source: ABdhPJyHNIUPJOuFZoEhbeHBKjViaCCqOoIcZum10WXOmwHzLc8ismXiNEMu6WlksB8hgY55OO/TGQ==
X-Received: by 2002:a17:90b:3b46:b0:1c7:9ca8:a19e with SMTP id ot6-20020a17090b3b4600b001c79ca8a19emr17728714pjb.245.1650656893254;
        Fri, 22 Apr 2022 12:48:13 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j9-20020aa78009000000b004fde2dd78b0sm3196460pfi.109.2022.04.22.12.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 12:48:12 -0700 (PDT)
Date:   Fri, 22 Apr 2022 12:48:10 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lasse Johnsen <lasse@timebeat.app>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] 1588 support on bcm54210pe
Message-ID: <20220422194810.GA9325@hoboy.vegasvil.org>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <YmBc2E2eCPHMA7lR@lunn.ch>
 <C6DCE6EC-926D-4EDF-AFE9-F949C0F55B7F@timebeat.app>
 <YmLC98NMfHUxwPF6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmLC98NMfHUxwPF6@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 05:00:07PM +0200, Andrew Lunn wrote:

> > I am confident that this code is relevant exclusively to the
> > BCM54210PE.

Not true.

> It will not even work with the BCM54210, BCM54210S and
> > BCM54210SE PHYs.

The registers you used are also present in the BCM541xx devices.
Pretty sure your code would work on those devices (after adjusting
register offsets).

> Florian can probably tell us more, but often hardware like this is
> shared by multiple devices. If it is, you might want to use a more
> generic prefix.

My understanding is that there are two implementions, gen1 and gen2.
Your bcm542xx and the bcm541xx are both gen1, and both support inband
Rx time stamping.

Because the registers are all the same (just the offsets are
different), I'd like to see a common module that can be used by all
gen1 devices.  The module could be named bcm-ptp-gen1.c for example.

Thanks,
Richard
