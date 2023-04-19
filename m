Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E196E7252
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjDSEdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSEdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B01D6EAF;
        Tue, 18 Apr 2023 21:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E732962F2B;
        Wed, 19 Apr 2023 04:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA24C433D2;
        Wed, 19 Apr 2023 04:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681878822;
        bh=hbjMvG0U69437nzwhAQ8/phnSWj0HXK6MrnJduauKNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nqP/cPmw6oie4DbF4zTGeDTppWbkk7nYuR/DBFMrRpHUHI1fsGgp5a5aSRoqVtuqh
         VjMLG7tVa0RSs8Vp9oaVHFC5kQumLZCvpDlpieBJ3fg5Ypt2V9UN2xXvpF5EpIMjt3
         ZlC8/ZPH125ALWIqvegQDz2GfITWrqnep1WdwE2LNRT3AwnIiB/Q7mkUPfHQtWeGqP
         pXvQGRshL5Ho/y5u+nEzYBsdfGLlJE+ReqWeaUs0YpUZnzEvXfoKuFB1LnauN9PTfu
         KX0eBgPuxrCZT3oINpL2iRc8M2F6vOVICmCp9InPoQLnMGFQHETKcmpgMeWuM0l0mu
         Nh4Q8I4xm5ODA==
Date:   Tue, 18 Apr 2023 21:33:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     davem@davemloft.net, horatiu.vultur@microchip.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net v3] net: ethernet: fix use after free bug in
 ns83820_remove_one  due to race condition
Message-ID: <20230418213340.153529d7@kernel.org>
In-Reply-To: <20230417013107.360888-1-zyytlz.wz@163.com>
References: <20230417013107.360888-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 09:31:07 +0800 Zheng Wang wrote:
> +	netif_carrier_off(ndev);
> +	netif_tx_disable(ndev);
> +
>  	unregister_netdev(ndev

It's not immediately obvious to me why disabling carrier and tx
are supposed to help. Please elaborate in the commit message if
you're confident that this is right.

-- 
pw-bot: cr
