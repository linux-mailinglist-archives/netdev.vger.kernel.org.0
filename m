Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A285BD629
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiISVJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiISVJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:09:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696B431DDC;
        Mon, 19 Sep 2022 14:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262ACB811AC;
        Mon, 19 Sep 2022 21:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E398C433D6;
        Mon, 19 Sep 2022 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663621792;
        bh=CkhA1WhQ9MAox4VJarfJaNAZnH0Q3Tzd/AGKamCW4uw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C5wTYjD+I2qDc3YGIGrVL85tKYbtA0PK1aKIUV3bP9UWeKrg1I6vCm/cJYi0J63k5
         G40i3jGQlxW9zDs+8qrZqgf2WjSPGH8Apg5s83pG8C+PRnX204kiPX84ZbV8z6p/jS
         vYdYd5aSxjCf9MJsmqb27HW3UVFsGr2+HSQaFDd1IQZ8ZA95n7NDVKZlNOl44GPi5d
         UlRJNaMdzl5UzOvQvZm7OnvkfcaVcoji83GOTDC3nctGJ1Xlc7HxzKAB/SDCiSfLXU
         BKhVQNhKYsWTDmKldikREypVePDcai7G07rhx2wn96EoYJJvcgH1aT6SuOgUs2Yhjg
         kcFGXEStXD8Rw==
Date:   Mon, 19 Sep 2022 14:09:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sun Ke <sunke32@huawei.com>
Cc:     <joyce.ooi@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2] net: ethernet: altera: TSE: fix error return code in
 altera_tse_probe()
Message-ID: <20220919140951.3dcdcba7@kernel.org>
In-Reply-To: <20220909024617.2584200-1-sunke32@huawei.com>
References: <20220909024617.2584200-1-sunke32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Sep 2022 10:46:17 +0800 Sun Ke wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sun Ke <sunke32@huawei.com>

You must CC Maxime, who authored the change under Fixes,
and is most likely the best person to give us a review.
Please repost with the CC fixed.

> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
> index 89ae6d1623aa..3cf409bdb283 100644
> --- a/drivers/net/ethernet/altera/altera_tse_main.c
> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
> @@ -1411,6 +1411,7 @@ static int altera_tse_probe(struct platform_device *pdev)
>  				       priv->phy_iface, &alt_tse_phylink_ops);
>  	if (IS_ERR(priv->phylink)) {
>  		dev_err(&pdev->dev, "failed to create phylink\n");
> +		ret = PTR_ERR(priv->phylink);
>  		goto err_init_phy;
>  	}
>  

