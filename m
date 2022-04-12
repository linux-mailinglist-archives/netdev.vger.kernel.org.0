Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A5E4FC929
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbiDLAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiDLAUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:20:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469891C107;
        Mon, 11 Apr 2022 17:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649722681; x=1681258681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RsPgl6JS8IMFJXGV1Eo0MBdyDoNAzeMZdr4UYrfqzAA=;
  b=Sxq7jxGaiCQR31J7THa3TcmZXHFu0WFSNXI7rnZpZNLLjK72QeUvtjYk
   2Fuy560E2EioOHqQfyffQKh2qPnMWmAVLrKt+8feRIEtRv030XRykSdrm
   Rr5k/FxOLch0DTi/DtIcwSO3mR6xY3EC8uvIFKMezSbri5ZymS1Tc6X4S
   ky4daNyJt3/qkpPF07LrNiqGsi0Df7um2PUczd2ZuUemlHbWna29Nu/Jn
   eFxN7I1Ba/dVduAtAGsC1JTYfW0QTrXYA353//Oe8bKV2Lziq8ZA05QDA
   wI/WhUOvnJLDVT12UmcdBvou8kuXnseDrVmWZVlBK7GM31SVsqbQ/EmXS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="322689108"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="322689108"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 17:18:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="660258800"
Received: from zhoufuro-mobl.ccr.corp.intel.com (HELO [10.249.171.224]) ([10.249.171.224])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 17:17:57 -0700
Message-ID: <cca8a37b-a648-52ba-c14c-1e1078bc628e@linux.intel.com>
Date:   Tue, 12 Apr 2022 08:17:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 5/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Content-Language: en-US
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Ramon Fried <rfried.dev@gmail.com>
References: <20220324112620.46963-1-alexandru.tachici@analog.com>
 <20220324112620.46963-6-alexandru.tachici@analog.com>
 <CAGi-RUJLmT-jfjtaYvPjaNHX-QCohhkZ3rkXaHHbmOHk56jTaA@mail.gmail.com>
From:   Zhou Furong <furong.zhou@linux.intel.com>
In-Reply-To: <CAGi-RUJLmT-jfjtaYvPjaNHX-QCohhkZ3rkXaHHbmOHk56jTaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>> +static int adin_config_aneg(struct phy_device *phydev)
>> +{
>> +       struct adin_priv *priv = phydev->priv;
>> +       int ret;
>> +
>> +       if (phydev->autoneg == AUTONEG_DISABLE) {
>> +               ret = genphy_c45_pma_setup_forced(phydev);
>> +               if (ret < 0)
>> +                       return ret;
>> +
>> +               if (priv->tx_level_prop_present && priv->tx_level_2v4) {
>> +                       ret = phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_B10L_PMA_CTRL,
>> +                                              MDIO_PMA_10T1L_CTRL_2V4_EN);
>> +                       if (ret < 0)
>> +                               return ret;
>> +               } else {
>> +                       ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_B10L_PMA_CTRL,
>> +                                                MDIO_PMA_10T1L_CTRL_2V4_EN);
>> +                       if (ret < 0)
>> +                               return ret;
>> +               }
move below out if/else

if(ret < 0）
	return ret;


>> +static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
>> +{
>> +       int ret;
>> +       int val;
>> +
>> +       if (en)
>> +               val = ADIN_CRSM_SFT_PD_CNTRL_EN;
>> +       else
>> +               val = 0;please consider below change which looks neat
            val = en? ADIN_CRSM_SFT_PD_CNTRL_EN : 0


Best regards,
Furong
