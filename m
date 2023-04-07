Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CBB6DB26B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjDGSFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjDGSFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:05:15 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4209C646;
        Fri,  7 Apr 2023 11:05:09 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id bx42so16033355oib.6;
        Fri, 07 Apr 2023 11:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680890709; x=1683482709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pVWWNnevGYcIX44/9Rtg07AkMRMvtlyvu+P6BaPgs4U=;
        b=pFSH4am2cfu0NpsQdFED1amUu7I+RuyiHsbwrU+dPzLVXwtV9eJjTOTNA8rB+tvZI5
         6yQHEe/c7Zzm+G/C4TuH/sTU4qAG74F/+xMq+qsj+Zr6t5ndmOBPab+1itwy13NA9DAb
         FykOKF7xIBqBc8mKZ4mXesIVc5L49vcvbXj5rmRayQD80K+pc+tkHHvzbQYyrouyUz3E
         LBPoLVoL0Hmb3ErTKlQ/JDnpl0b2H4LT+Kdlr+Zq50Aj7iLFVSFy1PQYccnnrD6xCPhF
         +mFYc6dhjKLpKL1JwMNwA17PX9Exv1rgUohrM3T8keLOwm2RXgKvwCQatBLYTjHxmJ3I
         vi9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680890709; x=1683482709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVWWNnevGYcIX44/9Rtg07AkMRMvtlyvu+P6BaPgs4U=;
        b=xx8/04IVuwEMkQRq+N8gJ4VI7V5SBJN9eZqffcY1NuedDZp0w7hRP43WcPf/jd1FVI
         PYNZM/RiHXgVyAb81/T9bOqjw+R7EQfi/41StH+Uvt88d4+B6vbn/M/8VwBeRCXzxXU2
         96XTzqwYRxTwFtmN2n/b7BdXoiMNlXAaoNYcaX8Entk05vqngZtaEAwcoz/ZhpI/Jtpx
         e9WhA7Q/aZpI5B26cF3ObYkYdZ0HUBuUnnXbkzJqRH5WJuMVZFWBp/cyTRcxJTIDlyBq
         FAsokthjnKvLAegfZb1nPv9sxN/KzU0OeDmAmU3+zGxyrGKT67Jv3QMCSH77oH9H74IF
         jchA==
X-Gm-Message-State: AAQBX9f6DpqJnLDHc+3Cm6HI2YftChwUZs74BE5jhx8RheG5xLVL0Rev
        64eBdEfs5opuq+KMyxi/bgg=
X-Google-Smtp-Source: AKy350avvLjqWh3OYQY55XilU6JN/EcZ//jxqILAkddASItdct3Il6r91YjXbWqCZs0vshJmWWX86g==
X-Received: by 2002:aca:1e1a:0:b0:386:e3f8:2c6b with SMTP id m26-20020aca1e1a000000b00386e3f82c6bmr1152904oic.11.1680890708884;
        Fri, 07 Apr 2023 11:05:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6-20020a056808120600b003874631e249sm1899179oil.36.2023.04.07.11.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 11:05:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 7 Apr 2023 11:05:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
Message-ID: <3a0391e7-21f6-432a-9872-329e298e1582@roeck-us.net>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
 <20230407084745.3aebbc9d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407084745.3aebbc9d@kernel.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 08:47:45AM -0700, Jakub Kicinski wrote:
> On Fri,  7 Apr 2023 16:59:04 +0200 Krzysztof Kozlowski wrote:
> > This depends on hwmon core patch:
> > https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/
> 
> That patch should have been put on a stable branch we can pull
> and avoid any conflict risks... Next time?

Yes, and I don't feel comfortable applying all those patches through
the hwmon tree since I have zero means to test them.

I created a stable branch at

git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-const

Feel free to use it.

Guenter
