Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DA7634461
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiKVTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiKVTNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:13:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B65F8E286
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E85B56184B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1573C433D6;
        Tue, 22 Nov 2022 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669144431;
        bh=BzY1j8UXgqGOA0ByBqb0ncDAZprAVGgykyt3l+5pq3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FvdSvM74+9X3hcBwXgI4uMB7rtGHGx/59I+4LvuYaEzYeio9txt2f3TqhjlaOu1QS
         7oVp19yqyc7oL18KqtJq6SxUCfj78WcDRUqPqoSLmdOrkIXGILA4zZAWWC7jAA36oL
         E+KC7hvE9IuDmWdlAu2bQ5AUU1C/BB7vIh+h8kVuc4XZQIMeGnnBCFAs3M4LfCh2Ao
         RLrqoeiFMJTbShfnPg+WMW0d5Vkn6B89lEs2JcsPV++xnBCHp96UJCJ9q0bo1xn+N7
         0MsyIpwptBpU69Kp/dnSEphzsnQh3sJkkAfxrHlLhO8ooGa/HLcqF3rXTm7IV0KYBB
         8lxzh/w38exiA==
Date:   Tue, 22 Nov 2022 11:13:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, sujuan.chen@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/5] net: ethernet: mtk_wed: add reset to
 tx_ring_setup callback
Message-ID: <20221122111350.1f18aa44@kernel.org>
In-Reply-To: <0193456e-0acb-75d6-8c6f-be0917990708@nbd.name>
References: <cover.1669020847.git.lorenzo@kernel.org>
        <9c4dded2b7a35a8e44b255a74e776a703359797b.1669020847.git.lorenzo@kernel.org>
        <20221121121718.4cc2afe5@kernel.org>
        <Y3vrKcqlmxksq1rC@lore-desk>
        <20221121201917.080365ce@kernel.org>
        <0193456e-0acb-75d6-8c6f-be0917990708@nbd.name>
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

On Tue, 22 Nov 2022 10:41:28 +0100 Felix Fietkau wrote:
> > That's a tiny bit better, yes, saves the reader one lookup.
> > 
> > Are the ops here serving as a HAL or a way of breaking the dependency
> > between the SoC/Eth and the WiFi drivers?  
> The latter. For a multi-platform kernel it's important that the wifi 
> driver does not depend on mtk_eth_soc directly, even when support for 
> WED is enabled.

Ah, I see, that's more legit. In the stmmac case it was just a poorly
designed abstraction. I'll try to remember not to complain again.
