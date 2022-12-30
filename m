Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2B8659493
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 05:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiL3EJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 23:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiL3EJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 23:09:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5BEA1A1;
        Thu, 29 Dec 2022 20:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6907B819DB;
        Fri, 30 Dec 2022 04:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AF3C433EF;
        Fri, 30 Dec 2022 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672373366;
        bh=FW0Ghro1YfdNHaROU9BLpNPW2URNdS5e0jD4DYmFGVY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kR05itrw1kY8GUsweeZDGSYnJBtWuUFsFErsSMBT/BpgOg+eumQO/OE1RdlGak3Ck
         N2XTmaGosrMItGcO/RcaBkLEz5EFY6jPNxfexB1LrXy8d7dHmMHCAJzzd6XuCdf+Vc
         hFA8ZogeaeEekR2fBOPdp/UheZKA21tuJiWwsTrLX2LoAMQAxoBtR2cNg7opETwHYK
         LawMlUvg7FDBREjRR8Fmiwnv8MSChIn3x5BUIRvjZeVBZPYFfVSPBQK9GNYI8CiqbB
         RQEdgAAUbcIV5dG4NcMg5pyUFUj3iHKiJhwmYKjILhbdtYHn0+LgE0AkzMSKNZnIjN
         pWSGiYAO9rfow==
Date:   Thu, 29 Dec 2022 20:09:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: dpaa2-mac: Get serdes only for backplane links
Message-ID: <20221229200925.35443196@kernel.org>
In-Reply-To: <20221227230918.2440351-1-sean.anderson@seco.com>
References: <20221227230918.2440351-1-sean.anderson@seco.com>
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

On Tue, 27 Dec 2022 18:09:18 -0500 Sean Anderson wrote:
> +	if (!(mac->features & !DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||

This line is odd as sparse points out
