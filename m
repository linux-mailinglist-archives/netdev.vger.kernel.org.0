Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C13F5BEDDB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiITTgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiITTgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:36:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA137285E;
        Tue, 20 Sep 2022 12:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52DD7CE1818;
        Tue, 20 Sep 2022 19:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9BAC433D6;
        Tue, 20 Sep 2022 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663702598;
        bh=4ZpzzM0pT1v5jAnKUiINLrDLktKeYd1gJkLXgUwydEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=keOkbiAdYB+4hivymCR3mlUc273Ihc3cNdwCzFyPDi2h9wdNeU953uc7RcXVoQKVL
         eK/Q1Ai70jBosUTCuHoULUQAk7bwn+BEGklv87O6dVniTjT0809IDykPFORuqRi5PW
         uMT+t4p8MNdXVLwGkJMvuiDnQefAA4qsK75+XPMNi8Lj61J5VrY78gOLaNpRp9xPyJ
         i9AW6aGHma2brcLP4wsgpJkaoGGm+VE5W8Nieq/ul/uh0FiUsSNS7DExuVbjOxumpY
         3pUoErkRo6RSBTj1maplblL85Zo/8RFxl3Qjm3HT9NFEI7ixiglVds1YtS12VbMAxq
         rpRYpoM04vn9g==
Date:   Tue, 20 Sep 2022 12:36:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH net-next 05/13] sunhme: Regularize probe errors
Message-ID: <20220920123637.1ade6b2d@kernel.org>
In-Reply-To: <20220918232626.1601885-6-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
        <20220918232626.1601885-6-seanga2@gmail.com>
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

On Sun, 18 Sep 2022 19:26:18 -0400 Sean Anderson wrote:
> -	err = -ENODEV;
> +	err = -EINVAL;
>  	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
>  		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
>  		goto err_out_clear_quattro;
>  	}

Why not move it inside the if?
