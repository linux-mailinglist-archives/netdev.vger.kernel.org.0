Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DF961FF34
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiKGUKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbiKGUKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:10:10 -0500
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EE310BE;
        Mon,  7 Nov 2022 12:10:10 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id l127so13365767oia.8;
        Mon, 07 Nov 2022 12:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZK4T+hFtvLVcMaNSYnoxn4R9pND87EMS3+QkZNcXac=;
        b=MXtvU0510jixv/rXPkD4YX6v6NN7hZnySbpSXUjKOb862VLu4r6eYk2aE3TvezKMK6
         x7/uXG3s9fY4BhXy4kBAcagFArVLn6o0D9xibj+utECEi/TLPM2waaf+lW5ChVCkvyQm
         PHT9TLntUWECfhQgSQA/aF9LyUmPn7NcEJ6JBKYkoTA1Fi79M7ooeS/GDJGyzsV2e7IV
         OACpdPE/eThGxf8LeA0bC0yBshwqz9sRyWzh3HzdTqavSovU4E6STYPI73M709+GmaLL
         ciSuVfpo0EcUPt7vaRndW8jLQzpPLXAQXTFZeYnJ3aCnMUaleOouNHpS1wwGjyrkozkH
         +kjw==
X-Gm-Message-State: ACrzQf38I95mV3p16s0W3qdpaTXFmDT38Ghei6BA31MNaUYLtnkWrBzy
        aI1DKD9RdsZ3LD0fUYPjNQ==
X-Google-Smtp-Source: AMsMyM6tKjJ1NRIBNZiMEaIPfaMpV3me/iNtZjbvD4IHK0Ohl6D4b0ypCv70CMuqSmJepSZSa5gwQA==
X-Received: by 2002:a05:6808:23cf:b0:35a:51a6:bd33 with SMTP id bq15-20020a05680823cf00b0035a51a6bd33mr13383796oib.164.1667851809274;
        Mon, 07 Nov 2022 12:10:09 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bx26-20020a056830601a00b0066ca9001e68sm2785806otb.5.2022.11.07.12.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:10:08 -0800 (PST)
Received: (nullmailer pid 1551305 invoked by uid 1000);
        Mon, 07 Nov 2022 20:10:10 -0000
Date:   Mon, 7 Nov 2022 14:10:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/11] of: property: Add device link support
 for PCS
Message-ID: <20221107201010.GA1525628-robh@kernel.org>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221103210650.2325784-9-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103210650.2325784-9-sean.anderson@seco.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:06:47PM -0400, Sean Anderson wrote:
> This adds device link support for PCS devices. Both the recommended
> pcs-handle and the deprecated pcsphy-handle properties are supported.
> This should provide better probe ordering.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> (no changes since v1)
> 
>  drivers/of/property.c | 4 ++++
>  1 file changed, 4 insertions(+)

Seems like no dependency on the rest of the series, so I can take this 
patch?

Rob
