Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64BC6C449D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 09:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCVIIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 04:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVIIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 04:08:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E739DBDFB;
        Wed, 22 Mar 2023 01:08:42 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id ew6so6358120edb.7;
        Wed, 22 Mar 2023 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679472521;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KOS/AQ9Mxky4fQ6rjcr9RElvh14G5SX1SO150d01EVk=;
        b=k1NSpqSY2Ai+jnahWTFmKmP0dJYXCS29JrRHwmQtyJ+pUPr2a481l1UM+wijV2Mfg3
         x8pctI8fqa0K7NmHzxIpB9uRuH+tsev4TknN5cc0xh0mEBdn55Dyu+y5/cB+cwps/qgw
         mOa06INvmc5XgU8XLkdwISoF1jYcnix0X9wkXZkDCqahkOCU9PrprT3y8ijqIZtUuz6P
         Fo/OcN1Auz4IVkHINGtEymYfOq6QXugwDLdRLZP4fYOJ0tQjoyXTQEE86BaUiTcLmcDc
         pKhLHw61mxSthSeEurPA8tLQHi5NwFjDv9E4GSubehHe44Fcq3UYbGDa4g7tFcvk32cF
         00uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679472521;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KOS/AQ9Mxky4fQ6rjcr9RElvh14G5SX1SO150d01EVk=;
        b=DFN4mcaoWGKbi+MTErX/PUyMgPTjlvPlXkYiw3epU6uT+7mdIlenkHtet2ygpwdVb8
         op8WbRxxb29KBzxI9CSwPEHBHAqogVt8PvDaC7/ZMRduonDfjUyl+gDrHr7G2x0BySc4
         sOwuPQ/QB4E6II4+u6rs7FSP0+51XWAW99JY2nPCrKo1hJ6VTTqXx1gnsriDlGDPPphz
         2UAgDy81hoxDpiqaSO4Gr92aSgP2lZh+UiFugDp8d7T3sraWUwdjafQNWHkQB3wMf4sq
         n7QEgtETnYMygVhm5RHaLa4h24s8wCdbBf9fI5JpwFjMMtzw+ZWOgzPC2LqWmCcIRiUr
         Tbvg==
X-Gm-Message-State: AO0yUKWSQhETx4TZDUJVYp7UU8zClIFH2NmtZ4TLmOpmeXdLceS9YEqQ
        RvvkSNjTSxCSI3nVIc94ulM=
X-Google-Smtp-Source: AK7set+JBeg3sdmWOIbqfYUGokDkx//K3duJycIWzBJMP2SHTMm6PvPV/HFnnoPEtzSLX78EEb8/JQ==
X-Received: by 2002:a17:906:9b8f:b0:8af:22b4:99d2 with SMTP id dd15-20020a1709069b8f00b008af22b499d2mr1592331ejc.5.1679472521466;
        Wed, 22 Mar 2023 01:08:41 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id ot9-20020a170906ccc900b009331450d04esm5683871ejb.178.2023.03.22.01.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 01:08:41 -0700 (PDT)
Date:   Wed, 22 Mar 2023 11:08:37 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_EXTTS
 for lan8841
Message-ID: <1e989615-79f9-483c-9229-6f1e22c0fd8c@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321115541.4187912-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

url:    https://github.com/intel-lab-lkp/linux/commits/Horatiu-Vultur/net-phy-micrel-Add-support-for-PTP_PF_EXTTS-for-lan8841/20230321-195743
patch link:    https://lore.kernel.org/r/20230321115541.4187912-1-horatiu.vultur%40microchip.com
patch subject: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_EXTTS for lan8841
config: riscv-randconfig-m031-20230319 (https://download.01.org/0day-ci/archive/20230322/202303221128.KLPNcDLt-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202303221128.KLPNcDLt-lkp@intel.com/

New smatch warnings:
drivers/net/phy/micrel.c:3480 lan8841_gpio_process_cap() warn: impossible condition '(tmp < 0) => (0-u16max < 0)'

Old smatch warnings:
drivers/net/phy/micrel.c:1683 ksz9x31_cable_test_get_status() error: uninitialized symbol 'ret'.

vim +3480 drivers/net/phy/micrel.c

25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3467  static void lan8841_gpio_process_cap(struct kszphy_ptp_priv *ptp_priv)
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3468  {
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3469  	struct phy_device *phydev = ptp_priv->phydev;
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3470  	struct ptp_clock_event ptp_event = {0};
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3471  	s32 sec, nsec;
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3472  	int pin, ret;
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3473  	u16 tmp;
                                                        ^^^^^^^

25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3474  
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3475  	pin = ptp_find_pin_unlocked(ptp_priv->ptp_clock, PTP_PF_EXTTS, 0);
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3476  	if (pin == -1)
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3477  		return;
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3478  
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3479  	tmp = phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_CAP_STS);
25cbf94843ee0b7 Horatiu Vultur 2023-03-21 @3480  	if (tmp < 0)
                                                            ^^^^^^^
u16 can't be negative.

25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3481  		return;
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3482  
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3483  	ret = phy_write_mmd(phydev, 2, LAN8841_PTP_GPIO_SEL,
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3484  			    LAN8841_PTP_GPIO_SEL_GPIO_SEL(pin));
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3485  	if (ret)
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3486  		return;
25cbf94843ee0b7 Horatiu Vultur 2023-03-21  3487  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

