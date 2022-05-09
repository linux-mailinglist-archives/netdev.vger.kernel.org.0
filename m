Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA6A520808
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiEIW7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiEIW7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:59:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8698F2C4F67;
        Mon,  9 May 2022 15:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2334160BC5;
        Mon,  9 May 2022 22:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216F8C385B3;
        Mon,  9 May 2022 22:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652136926;
        bh=eOxOKk3ZG98rLra0WnplqxNnsGlWGScNzyOmq/fwewM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iVwc7ON6x7KA8RL7JKq7syWCbuOrk3bj+ONYR7nESKE+4dRrKHNDCsMv1VrZsBsT3
         5MMZ1Yb1jhA3Rxv0uFyPQaq9CJcxMgRQEj5/YqD3mqvwG3y25+OGDyFgK+0eXqAeSY
         q6T2pdkQyaPb5AlzJbdSpK3TRzqrlV04hUDXGHF3RMA91W4qswKZ0EVjylOp6OyW0B
         m8LAeAdoZVIpCAvZP7XzPyieIp2T4MaRMXYSbnKJXDv9Nya5kYqtrv5tGzxzMkz6ab
         RvQQOXsMfGxEKidoKLCkv1bbRiInpuBek1ikEdkLXQA6EmCuXpNy9xvfBd84YcbT0N
         yPHO0nuRdsU2w==
Date:   Mon, 9 May 2022 15:55:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <netdev@vger.kernel.org>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <davem@davemloft.net>,
        <edumazet@google.com>
Subject: Re: [PATCH] net: stmmac: fix missing pci_disable_device() on error
 in stmmac_pci_probe()
Message-ID: <20220509155525.26e053db@kernel.org>
In-Reply-To: <20220506094039.3629649-1-yangyingliang@huawei.com>
References: <20220506094039.3629649-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 May 2022 17:40:39 +0800 Yang Yingliang wrote:
> Fix the missing pci_disable_device() before return
> from stmmac_pci_probe() in the error handling case.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Here indeed pcim_enable_device() seems like a better fit.
