Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE085967CA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiHQDmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiHQDmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:42:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CAA7F0B3;
        Tue, 16 Aug 2022 20:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EFA3B81AD3;
        Wed, 17 Aug 2022 03:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D2AC433D6;
        Wed, 17 Aug 2022 03:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660707720;
        bh=JB+uYnew1TY4hlA/hravuGJRZJpftlS1oeDaF0n04pw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KPvi5Be+9yCdfykFTpkB0jkAFXiVC+34Af7CdqYqQd5AnSrEjClmDB4aMxH5sjM3H
         3LRLxiZgYyz81i55uacqlj+Y8SxuHsB36RchqpbtIX5jmTKRgmQbwcDtyFVG+wZczA
         UGpddhg7HBISAsBpENs5+EBwuMlP5CSNvW/TBSa6zovaj48c6fyrffSQ+6Mk50Yk8+
         hR4e92Xp9msKozGS6DU8SFd2kOIg5wMWkRVQxRYeFOoInZnMiVpHfwJM40eEALQyij
         r0mx0cOWVbNInTEsxGPP/SueTYRd6G8vuqHwgSmpxphm7o5dQWFOOujPm6qZpt3jOs
         yuAaZZ4OqAu7w==
Date:   Tue, 16 Aug 2022 20:41:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: lantiq_xrx200: confirm skb is allocated
 before using
Message-ID: <20220816204158.32f24172@kernel.org>
In-Reply-To: <20220815145740.12075-2-olek2@wp.pl>
References: <20220815145740.12075-1-olek2@wp.pl>
        <20220815145740.12075-2-olek2@wp.pl>
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

On Mon, 15 Aug 2022 16:57:38 +0200 Aleksander Jan Bajkowski wrote:
> +		netdev_err(net_dev, "failed to build skb\n");

I don't thinkg this is needed, is build_skb() using GFP_NOWARN?
Otherwise there will be an OOM splat anyway. Do check, I'm not sure.

If there won't be an OOM splat this line should be rate limited.
