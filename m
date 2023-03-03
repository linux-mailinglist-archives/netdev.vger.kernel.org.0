Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657006AA5D2
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCCXvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCCXvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:51:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F135EFB5
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 15:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEBF261941
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 23:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F73C433D2;
        Fri,  3 Mar 2023 23:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677887460;
        bh=8jw5hOIZnoO/bHj3vDn+08OPVtB1aJUs9D/KLHS5NeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FXdXGkFYXFP7PpCWZmny55tXm7BoLlOMS7DTSnTCg2yi4op4T3IqfJSWwCITs0m0f
         q4Ycy9g37px/ykXp0axNujw3GkJxnXReSewIcnUpF4Z7ikjudeTfC2xDsqOujcc23m
         WMDlfFphThe6WQ4LY6XT+jtHyx4XEjRH3qkx9FhyrrKTsH18fHzaJcOvZsokOjApT8
         DSO6AJLF1uUN+8wI/H/lMKAdoOy33nZuVz4d1U1g3GnrpX2RgeCkogH5sR1iz4ruua
         cQCr/aU6EPcRC2I25OF0bzKWvxUuonwdbVP0ZoAIDHMk0dOfG+JroG/4GTnA0Dirh3
         ijvrSrRgnOTlQ==
Date:   Fri, 3 Mar 2023 15:50:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v2 net-next 1/4] ethtool: Add support for
 configuring tx_push_buf_len
Message-ID: <20230303155058.2041c83a@kernel.org>
In-Reply-To: <20230302203045.4101652-2-shayagr@amazon.com>
References: <20230302203045.4101652-1-shayagr@amazon.com>
        <20230302203045.4101652-2-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Mar 2023 22:30:42 +0200 Shay Agroskin wrote:
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
> +			kr->tx_push_buf_max_len) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
> +			kr->tx_push_buf_len))

Only report these if driver declares support, please
