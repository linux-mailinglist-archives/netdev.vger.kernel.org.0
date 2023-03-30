Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C466D0B71
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjC3QhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjC3QhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA31C159
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACF3962115
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CBBC433D2;
        Thu, 30 Mar 2023 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680194225;
        bh=XtkTqKmTa4Do1XyOce7YzTky9wxy6vDupU7eV9YHHU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RWz/ueiq9vsTB+H3xBBBz399wWJy4F7Hdxpqv0psAN28iHmxSkqGVKzXwWSXJxmaP
         Rfvh1cC+J7XEwd7djFmURcbbNDpjm9FVJL+jt3EPCgUrnX+RttHzidJtL7ufpZVR80
         bUwVV/B8c+wmnxo+V+pLQYaTcE2T6AOTudmn2WGnAv7zM2JT1S55JAM3/6NcdpqO6r
         PO2oawUzOC2uADudFYTyztPVMHIOWOXWBCw3csYlIp1PHSHRoru0SUqGD2EgCYmFpr
         4kGdaxYPY5ZPy2XphwWsuLTgeKj5ODBZ86ET6FrrARLdwVFpuhl+EGx0UrJUgG5iBd
         fJXS4g7pZG6rw==
Date:   Thu, 30 Mar 2023 09:37:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [PATCH 1/1] net: stmmac: add support for platform specific
 reset
Message-ID: <20230330093703.6be37eb7@kernel.org>
In-Reply-To: <PAXPR04MB9185649FB402ACF46BF47434898E9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230321190921.3113971-1-shenwei.wang@nxp.com>
        <PAXPR04MB9185649FB402ACF46BF47434898E9@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 14:55:02 +0000 Shenwei Wang wrote:
> A soft ping. =F0=9F=98=8A

Simon's proposal is much better.
Just do that instead of pinging the list :|
