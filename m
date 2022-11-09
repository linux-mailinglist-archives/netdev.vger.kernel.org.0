Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6D76236E7
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiKIW7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiKIW7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:59:50 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E29F11C36;
        Wed,  9 Nov 2022 14:59:49 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v7so117567wmn.0;
        Wed, 09 Nov 2022 14:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=swcrtWEk/pjEDFJKOi6muSLrFWlp8giizOyeDdjr3QI=;
        b=qgV5InPtVbonJaw0kv4ZbCSPNUG0xf4Pn9GME0tsiZ0IUqaOWghUYHueI4ljO6Po1T
         o4irPUC5EKmGrtN2mrzJF2gFRCiwSyOxJRriuGI96ZjO5Siks+qR8efhjNt9GRubLaik
         KgyWYE447kS3+rmtz5QuDgEmy7LzOQ50dH7ns8itJ5M8mT+n1FVvbR33jD+XIU9TNOlR
         6VD7WdQkVPWhcqH4M7OEaadnw9LR+yTrKE3XVtepyRZ82Ph4VacvfwmoWmnn0zcDYlFi
         1plh0u6lKqfAeTB/C4spDO4eqcFBbGJWFcJNDntsA8fgeO2LE7GOoSgCfo3oKvVar0q1
         xTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swcrtWEk/pjEDFJKOi6muSLrFWlp8giizOyeDdjr3QI=;
        b=q7/mLo3GTiUcp36bsQWKGt4YEiUwUVndgft6eFUv1QSdAzDC2Ev1X8jZWWEJVY72tQ
         ZUOwgl/r+PR4QxPnIdVXavspBdqVXiBDV1hBlY33Vzw4TWlzRRuRBzGX/2BUCK6rXFf9
         ZWuanZxmrWrIuHjj3D/G1jsXrzH7u4Qbknhq5oEQqhll3UnDl0R/5ZqjETB/El5Vaqx7
         PQjDuzhdM0Gm7ZmTCODYICCvjOLNaz48F3dARkE5HWb1c1GLhr8u/V1+oCb5bNuHp9sp
         mnGS3cpxwX5riE/GJj9psRCApGXkwuhKOLAjSc9icPK8LA0OmCByPz/8n/aVl3VRtSP4
         5Y/A==
X-Gm-Message-State: ANoB5pksH2yFvz3egQRtCaEf3Fim/2YlGTalqTRocHIPP3BevBuh0xuK
        l3Uv0XzWIEIbbt/y1rbEBhs=
X-Google-Smtp-Source: AA0mqf79cVkwjf7QQCHzuNa6IK4Sqr+HRH2GA9ig8lczx/Yt8P39Cw2PM+3pWIS8kfcqXPHw8pEUMQ==
X-Received: by 2002:a05:600c:3393:b0:3cf:b30a:e202 with SMTP id o19-20020a05600c339300b003cfb30ae202mr9650192wmp.91.1668034787609;
        Wed, 09 Nov 2022 14:59:47 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q10-20020adff94a000000b0022e035a4e93sm13982413wrr.87.2022.11.09.14.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 14:59:47 -0800 (PST)
Date:   Thu, 10 Nov 2022 00:59:44 +0200
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
Message-ID: <20221109225944.n5pisgdytex5s6yk@skbuf>
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
> For a long time, PCSs have been tightly coupled with their MACs. For
> this reason, the MAC creates the "phy" or mdio device, and then passes
> it to the PCS to initialize. This has a few disadvantages:
> 
> - Each MAC must re-implement the same steps to look up/create a PCS
> - The PCS cannot use functions tied to device lifetime, such as devm_*.
> - Generally, the PCS does not have easy access to its device tree node

Is there a clear need to solve these disadvantages? There comes extra
runtime complexity with the PCS-as-device scheme (plus the extra
complexity needed to address the DT backwards compatibility problems
it causes; not addressed here).
