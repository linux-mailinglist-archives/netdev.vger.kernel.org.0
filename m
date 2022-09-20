Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569C55BEE4E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiITUN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiITUN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:13:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3936674DE0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2AEDB82CBC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAB5C433D6;
        Tue, 20 Sep 2022 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663704833;
        bh=4tCEKL1uq5efdUzroUuToafe6UsXvtnls44XlZvAHCI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IjfO1IqeQY7+s1aCtEDZtyv8ItFZKWFxBvd0eNpwL8a3sZyL5G6eauI0+pN24npmE
         lMS2CPBmyV8zLN2wRLY+uzyJimqpsluXOeNZTRqnAis8IMhTgXJ2pWaPeO9aSzRQ1A
         Nbfr00ftOMe6+SNqqqaEmQSwQU74eHQ325gr/u+MxSN0LgcUZRt4+ftuDSZpa40CjQ
         3f5zcRiAlGP7zFLGBY486YphaOO+7kOE0/G0bWieq9276xTFF8z6ZwSOwks3Fs/nNw
         KP/eNBPTWYjll/AAiiWX1vHSUZy4xsultHdSSdv+eia8aRzjXOevXZ0mu3ZxrUJ9ph
         u0BUtyvGAVSGA==
Date:   Tue, 20 Sep 2022 13:13:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [RFCv8 PATCH net-next 03/55] treewide: replace multiple feature
 bits with DECLARE_NETDEV_FEATURE_SET
Message-ID: <20220920131352.7e9666db@kernel.org>
In-Reply-To: <20220918094336.28958-4-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
        <20220918094336.28958-4-shenjian15@huawei.com>
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

On Sun, 18 Sep 2022 09:42:44 +0000 Jian Shen wrote:
> +	netdev_active_features_zero(netdev);
> +	netdev_active_features_set_set(netdev, NETIF_F_HIGHDMA_BIT,

There's a ton of those zero() + set_set(), can we combine the two into
a single init() helper?
