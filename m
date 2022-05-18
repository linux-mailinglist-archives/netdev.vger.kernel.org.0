Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D731B52C078
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbiERQXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240055AbiERQXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:23:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAC61F0DD0;
        Wed, 18 May 2022 09:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B73CCCE21AE;
        Wed, 18 May 2022 16:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BC8C385A5;
        Wed, 18 May 2022 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652891008;
        bh=/Ybk8m/djEMtyRg29QUVApIAfaXZyYituDCyvsrcOSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NFQ+exhbR9/ckJbmbOvrhE4sjaipQ8eRQVN/x+S8c/N7YcpukYSzQ8zQwQJx9Mwev
         IOTW+i6P0xhBAB/u6VC+iCFBmRW/5JpyCasNizrtF7Va4apZrjYs5LS1yk2vQAUcwF
         pYqPcZe0Slosj4KOkzD3jOHYJFZD5MZcVEGP3M0GHLsU4OzesBaFFbZEVKLh23RlbG
         b00NPjYw82md/E0r2KJhJNfLgRnb6B+QtKHbr+AhBZs0coU5IPX9u559beAdPUmoq8
         wc1jN8dPNyAmzGrzG8R7Qxc6u45pI79Dxfxvh2vP9isa1Am27QOaxHTnxj9eqchnVw
         YurqJA4gd8oeA==
Date:   Wed, 18 May 2022 09:23:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Carlos Fernandez <carlos.escuin@gmail.com>
Cc:     pabeni@redhat.com, carlos.fernandez@technica-engineering.de,
        davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] Retrieve MACSec-XPN attributes before offloading
Message-ID: <20220518092326.52183e77@kernel.org>
In-Reply-To: <20220518090151.7601-1-carlos.fernandez@technica-engineering.de>
References: <20220518085745.7022-1-carlos.fernandez@technica-engineering.de>
        <20220518090151.7601-1-carlos.fernandez@technica-engineering.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 11:01:51 +0200 Carlos Fernandez wrote:
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.
> 
> Fix by copying salt and id to context struct before calling the
> offloading functions.
> 
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

Does not apply to net, please rebase.
