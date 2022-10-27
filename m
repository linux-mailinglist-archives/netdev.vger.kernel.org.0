Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9102260FF87
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiJ0RqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiJ0RqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:46:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F05F6FA23;
        Thu, 27 Oct 2022 10:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89159CE27E4;
        Thu, 27 Oct 2022 17:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3371CC433D6;
        Thu, 27 Oct 2022 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666892769;
        bh=PTCvPjAnFVeS3meoff5ZtTQufXHxLH4YUrDCSv5aopw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q82RL/v1trKyzmnz4PSR34S7gbpLZDsa4AFTV7CEt0Zo10j2OpnPfBK36PYrhJMl5
         5AWguugs008UCWNZa6YzXvA21KV8kQOtmv0zXIDxu2DY1kapUD9LcWmAGKPu2jOLZ6
         CqdBXO78y/0r5/DLeDqwbLFwVXiwodsUsARy21q5cu/pUo87eihsJS9McJFwB6piM3
         oNNpA8cfS78HIF1872mxwybNxXixtNw18ap+dLUgUJbiZDaqzkkCM0Ana6dimbjqow
         mR45ZjUTnrUfItCJjLqk9P9wGYWVHN6VWmj7ML35eOAAZ/K1nNAvR7CWMkrFBBCq9/
         gpi0tbaiPe1sA==
Date:   Thu, 27 Oct 2022 10:46:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "zhaoping.shu" <zhaoping.shu@mediatek.com>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Cc:     <m.chetan.kumar@intel.com>, <linuxwwan@intel.com>,
        <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <haijun.liu@mediatek.com>,
        <xiayu.zhang@mediatek.com>, <lambert.wang@mediatek.com>,
        "hw . he" <hw.he@mediatek.com>
Subject: Re: [PATCH net v2] net: wwan: iosm: fix memory leak in
 ipc_wwan_dellink
Message-ID: <20221027104608.246aa30c@kernel.org>
In-Reply-To: <20221027070206.107333-1-zhaoping.shu@mediatek.com>
References: <20221027070206.107333-1-zhaoping.shu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 15:02:06 +0800 zhaoping.shu wrote:
> From: hw.he <hw.he@mediatek.com>
> 
> IOSM driver registers network device without setting the
> needs_free_netdev flag, and does NOT call free_netdev() when
> unregisters network device, which causes a memory leak.
> 
> This patch sets needs_free_netdev to true when registers
> network device, which makes netdev subsystem call free_netdev()
> automatically after unregister_netdevice().
> 
> Fixes: 2a54f2c77934 ("net: iosm: net driver")
> Signed-off-by: hw.he <hw.he@mediatek.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: zhaoping.shu <zhaoping.shu@mediatek.com>

Annoyingly the patches are still not making it to the list.

John, any hints you can gather from vger's logs? The patches
were resent 3 times with a 0 success rate.

Last time we hit this was with Gmail, but it doesn't seem like
mediatek.com is using Google Mail?
