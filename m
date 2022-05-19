Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A86552E047
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245679AbiESXJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiESXJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:09:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DCADFF79
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:09:09 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h11so7586054eda.8
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9CWDSURQk/3htkD4j+cM1CkjRNsaAvbsFTzIT2f2lb0=;
        b=RAc5sGkL5HuqaIGTgSm16Fb01mjDi1MQEgWef+w4QOdWr6N1r/IDA2I3EYivJYx6Rh
         96uB8h2yei4fRJGI1MGiv1waNzwGjqBjZ3pdbbu+FW4FW6h8KZ+4wRr8XiwJTJ6YW9/n
         r/ZR1dTroWRb5/4EvzJSElOvC+x9dIqrhdNFsJ/OP+OleVmuqPR1Q6WeOMg/9nAQ00FP
         JgBtQwB/ngcvsVCtE0FpAq5WN7WWbv5vDtNS84gqpfE6Dx44osHwNybMHkFmxqjwp0dm
         lGL0yf37sBeCWX2xewZvE5CsJ25h0ZvW3PbyGecCyBAXNTX4iNGpbGTNwYef4FseLAgL
         EOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9CWDSURQk/3htkD4j+cM1CkjRNsaAvbsFTzIT2f2lb0=;
        b=ZECVBt2LbWzUF3YxtbbRvDjFADk9G9WpBsmyHsOoAoCENHKhTKjshrETCrzmJkY5O/
         OAXyWkxRpFEGAJ+A8z4E4ZW0CSE/2Wjx32b+mud1LR2n1CSezA+soynOYIsfgji8/Lo1
         MBpWmWDgagnpuIudw8s4RhTVqSHp72cwmTOYSPKoP8CYYZDwybGx/9UP6ZkFK9JRX4ZK
         TSq97bQDeBKpwM7eo5PFknIIXMzIbG1M8cl96yh6lW319zv8LEqsDmEar5Io1hdw9FNX
         nrY5WSgAGXjV+KDX9psT3aG5Yi82+XJV13bm0+pitMxzjjwuvQvOqacNMewEJQK8JwQ7
         HQ/w==
X-Gm-Message-State: AOAM530JTVxxVRws5iV3gJq2NZ1zEcX2MZr2Kl+iJo6r0wyH7C6CPV/u
        guQo6SgLp7/FixbAvc3Lgdo=
X-Google-Smtp-Source: ABdhPJxyot9iRBoP6LKx0451QYxc1SBc4bgJYCP7NDqTs5B94M7uT1oxPm4J4jcldSZCSWZJ3ksffA==
X-Received: by 2002:a05:6402:94a:b0:42a:be9f:6698 with SMTP id h10-20020a056402094a00b0042abe9f6698mr7842739edz.393.1653001747702;
        Thu, 19 May 2022 16:09:07 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id ec9-20020a0564020d4900b0042acd20d46csm3378831edb.92.2022.05.19.16.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:09:07 -0700 (PDT)
Date:   Fri, 20 May 2022 02:09:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Message-ID: <20220519230905.mkuwi3ytguxrwbpl@skbuf>
References: <20220519213351.9020-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519213351.9020-1-rdunlap@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On Thu, May 19, 2022 at 02:33:51PM -0700, Randy Dunlap wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C so that it is limited to VLAN_8021Q if
> the latter is enabled and results in changing NET_DSA_SMSC_LAN9303_I2C
> from =y to =m and eliminating the kconfig warning.
> 
> WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
>   Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>   Selected by [y]:
>   - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
> 
> Fixes: be4e119f9914 ("net: dsa: LAN9303: add I2C managed mode support")

The Fixes: tag is incorrect. It should be:

Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Juergen Borleis <jbe@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/dsa/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -82,6 +82,7 @@ config NET_DSA_SMSC_LAN9303
>  config NET_DSA_SMSC_LAN9303_I2C
>  	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C managed mode"
>  	depends on I2C
> +	depends on VLAN_8021Q || VLAN_8021Q=n

I'm pretty sure that NET_DSA_SMSC_LAN9303_MDIO needs the same treatment
as NET_DSA_SMSC_LAN9303_I2C. And the "depends" line can now be removed
from NET_DSA_SMSC_LAN9303, it serves no purpose.

>  	select NET_DSA_SMSC_LAN9303
>  	select REGMAP_I2C
>  	help
