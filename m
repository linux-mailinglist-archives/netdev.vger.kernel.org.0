Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A32E6236AE
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiKIWlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKIWlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:41:16 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857D0D13D;
        Wed,  9 Nov 2022 14:41:15 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p16so73569wmc.3;
        Wed, 09 Nov 2022 14:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=72SRA5lrKUs0W8xkTsquem3V1Ku1VH8DVJEO2i+3wLM=;
        b=ibl7hcVB2q3N30mwPYiDyU2n2efcA2mhjwKrEycsn2/uMV/RxGxZgN0FaG/Z+5ON/s
         7d6Vl01KgwNOhgBbfOcX83aLRUItOmOcU225DWB2BsI8I31zEEYbtzFvsCq5/IAIEPZb
         8nLhQvLIh+XpFiyuynQpceqBKuIGkcgca38Id1BucEBQvqSNvpIcHmZJQT/IxXaBE1FI
         vYjjYKYLJlJfsJqKyUxlbHRswqSQUcDJkMnQvUXAahhDWVsmCBmNHUA5Wh3q8/D9CJr3
         jUW7Imnz0cdeUQuIzxmcp+qMjz5p3LUdmqGZjMkvBbLDa5e+XBhPtXLMIimTFGHjshTk
         n49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72SRA5lrKUs0W8xkTsquem3V1Ku1VH8DVJEO2i+3wLM=;
        b=Diaa5c8CsTEUTGOOEUyODoFqv/eCgDH9i3Sg1w/+v+GyhqKEfnvYPFt/os/0pzVkiQ
         j7B4ynnLZFSNOlH4kWECbjRoIgN/BfK2AirjOMqMEYEu3RcQD2nPhKsXk/+Gk5GIQ/ot
         yV20q9o3Y5MLJxES5MoTZl7DNLY+nIvIib3CijCcHILL6JyxCtGoqRbaC2u5yuDnuqoq
         O3+HOa5tLYdlgak8wd9vbxPJys0ESbbrmJEdyomzyNLu2HmkijCpbZxG4H46g+VY9quR
         yFM+/2o2HyOlL3RvlpkAOfdyfIER2AyLdljNNKyyc5tEEULxYYPopN2y2Gc66D5IkFE3
         Zp1Q==
X-Gm-Message-State: ACrzQf06uImP81dVDBUhZHEJg0nVj2lhsu2tGJPqVXYWyidEleNTeJxK
        3FgSFGlaTqu+DMUl+fPzwCDBMR4wwQBRpA==
X-Google-Smtp-Source: AMsMyM5R51wkRbWukTP527Ud/KNaaX7vPG9ioje5356mfGLpTU0MufKXFd6OipCgf3slypg5cLb5gg==
X-Received: by 2002:a7b:cb8d:0:b0:3cf:4969:9bc7 with SMTP id m13-20020a7bcb8d000000b003cf49699bc7mr53086243wmi.71.1668033673843;
        Wed, 09 Nov 2022 14:41:13 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c2ca800b003b4a699ce8esm3166923wmc.6.2022.11.09.14.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 14:41:13 -0800 (PST)
Date:   Thu, 10 Nov 2022 00:41:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <20221109224110.erfaftzja4fybdbc@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
> Several (later) patches in this series cannot be applied until a stable
> release has occured containing the dts updates.

New kernels must remain compatible with old device trees.
