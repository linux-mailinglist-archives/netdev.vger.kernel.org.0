Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBDB572C0F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiGMD5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGMD5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:57:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49B4D9150
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 20:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B7A2B81CD4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 03:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73876C3411E;
        Wed, 13 Jul 2022 03:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657684624;
        bh=KVtCkBQKszMrIaDEzYkwrGHkeTwIMxEmMgFYri9k7SU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OpkLZf+lpx0JcEvEYSaDe170KG13fjFoBddtICFYcDYzTJ5f0tF5tpiMCmp/9Y430
         VRGSmlfJ8NMmlQ7YFJD0f1T6YjPOqWOPwDeayAsx1VuBmEBcs9uTfcu60nkdf9q4/C
         a7xBSviteUbiI7OKe/wCI8ARm6wRU77duaMdH80QzbNNewlCN9GRRmODONyYlmFcOq
         4Iqb8Hd6anHJfXJFyhms8RNkt2zpiqnAAz+cId8MRyrQgSHnVhHw7fXFt/jY7ZXr1b
         0BfV5/0H8DRkh2CmTA/dwE98WybKihowSdQfuXFHxfqafl1ETRA3+Kn+l3dGxNF38m
         T7/QJxmPVx7QA==
Date:   Tue, 12 Jul 2022 20:56:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        jbrouer@redhat.com
Subject: Re: [PATCH v2 net-next 2/4] net: ethernet: mtk_eth_soc: add basic
 XDP support
Message-ID: <20220712205655.3d3ac17e@kernel.org>
In-Reply-To: <660481b3292e8438b08d129d74e3bf62fab51db7.1657660277.git.lorenzo@kernel.org>
References: <cover.1657660277.git.lorenzo@kernel.org>
        <660481b3292e8438b08d129d74e3bf62fab51db7.1657660277.git.lorenzo@kernel.org>
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

On Tue, 12 Jul 2022 23:16:15 +0200 Lorenzo Bianconi wrote:
> Introduce basic XDP support to mtk_eth_soc driver.
> Supported XDP verdicts:
> - XDP_PASS
> - XDP_DROP
> - XDP_REDIRECT

Looks like you're missing some rcu_access_pointer uses here.
sparse is not happy (2 new warnings)
