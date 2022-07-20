Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CB157AB0E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiGTAko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiGTAkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B8DF5AC
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D271DB81DC9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A833C341C6;
        Wed, 20 Jul 2022 00:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658277639;
        bh=xRO8Cerl/DsoZ7VXIDoqk7KPdb3xy0m5ieKJhE+IzbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L+AK2xxcxjO/IGBmuodb0J7D+3BB6rkaFmyBySN7f1XaTq3HiVwSmpHfxd2Kds0Fi
         F9xzxaF1UGYG6MzR3Jq1x9ObDZgDAT/J8qlRVnTmzf+V4fLf4wqN8quSKijJKZSE4V
         uWrK8PYbAB9KCZKnOXscoj9kkaYEXOp91AYfeuhdjM5QjJOZldbA1Mjkwdd7HUXr5t
         k/qXH/UQImPMDHNCRE0XyX2Ad07YInhyQDSIbz9yeoeNLKerKCftOLg0IMDhtTlBVA
         OTmOhZ123APoI6hJ8jkXXvx5sNKvtW1o1jwcNNADjgXRn8SozHeOnqxnvX9i2P0v6p
         YofbBXt7r63kg==
Date:   Tue, 19 Jul 2022 17:40:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Ryder.Lee@mediatek.com, Evelyn.Tsai@mediatek.com
Subject: Re: [PATCH net-next] net: ethernet: mtk-ppe: fix traffic offload
 with bridged wlan
Message-ID: <20220719174038.7ee25c6d@kernel.org>
In-Reply-To: <7fa3ce7e77fb579515e0a7c5a7dee60fc5999e2b.1658168627.git.lorenzo@kernel.org>
References: <7fa3ce7e77fb579515e0a7c5a7dee60fc5999e2b.1658168627.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 20:36:39 +0200 Lorenzo Bianconi wrote:
> A typical flow offload scenario for OpenWrt users is routed traffic
> received by the wan interface that is redirected to a wlan device
> belonging to the lan bridge. Current implementation fails to
> fill wdma offload info in mtk_flow_get_wdma_info() since odev device is
> the local bridge. Fix the issue running dev_fill_forward_path routine in
> mtk_flow_get_wdma_info in order to identify the wlan device.

AFAIU this will conflict with 53eb9b04560c ("net: ethernet: mtk_ppe:
fix possible NULL pointer dereference in mtk_flow_get_wdma_info")? 
We merge net -> net-next every Thu, please wait for that to happen 
and then repost. Conflicting patches are extra work for Stephen and
for me.
