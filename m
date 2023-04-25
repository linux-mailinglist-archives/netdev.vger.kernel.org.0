Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36056EE46C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjDYPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbjDYPGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:06:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F3A4EFD;
        Tue, 25 Apr 2023 08:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766A8629B0;
        Tue, 25 Apr 2023 15:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F0FC433A0;
        Tue, 25 Apr 2023 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682435182;
        bh=ATmjq8pD+3SUwYW+NN9xgGSe8qmNsZwoS5t6pbkMpN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iVhJLcD0QZWSM0conN4OHm+hUY+XyWSrhLF/K71o/aCmxz1nzmZVOdj/OwKaYEVfN
         COfxhhXpnZhkjDihEivVudPUKO9HuKhY1UTFZuiurCD52issEfnlXulmcUYmPs4P34
         mVtj8/FmTaaXdAbN1gwAMfDQBnLV9gvm/R4pIMMRLGow+ODVhxYebKBxDahJDs/U0s
         8BkXQjcdy4KMasJ/dIVtuExCX4b4QBxa1MRzfBsAqfWfvdsW2FjE7w+Y1qSKrWMbOl
         RI9pKJ7+gHPkfew9mY4AlYgsW0nl4hkhVKF75DJHaG/XKGaJ1S+qyvn0FtfCIoYRqK
         zIG+aFZZkiePw==
Date:   Tue, 25 Apr 2023 17:06:19 +0200
From:   Andi Shyti <andi.shyti@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 3/8] net: txgbe: Register I2C platform device
Message-ID: <20230425150619.cj7ed2efnbvjk5mm@intel.intel>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-4-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422045621.360918-4-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

[...]

> +	ret = txgbe_i2c_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
> +		goto err_unregister_swnode;
> +	}
> +
>  	return 0;
> +
> +err_unregister_swnode:
> +	software_node_unregister_node_group(txgbe->nodes.group);
> +
> +	return ret;

no need for the goto here... in my opinion it's easier if you put
software_node_unregister_node_group() under the if and return
ret.

Andi
