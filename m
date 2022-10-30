Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4346128FC
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 09:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ3IPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 04:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3IO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 04:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31C5184
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4CB60DE7
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FE8C433C1;
        Sun, 30 Oct 2022 08:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667117697;
        bh=Q5xRx7G1cQ32+NyN3V9GGJsAYfU6/i+1u8tVH0h+Xhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VYZxnHPI8nMD2gVTl/73wXE8mzSc6MOZOGMP//kbff+3uzZSpoSRaiYcthKzWiPE8
         r3iJMXkFdp0w4DKttrGeQcLISYjbs79gD2jKTA0d41Yl5Y83V6EtH4a0t+vuAzplRZ
         iazW7HJSRzjl8vc3djdhd+bq+Qo9Va13F8HB+NlWjQrH+cWSa9Wx768ltgKJgWoJE6
         yiybZfsAedniKNjEDxLfMTlAuJeCvF1PwpQuZbuMgaWBbWn10hC1sfh7KKnXVHmzJE
         YhYZytrTNDl3AsiTz+hEBYqLxaK9V7+578hVueQpq6mzH0V8lkZllSqhUIT5VJVL7H
         l8/GxjcSifmrw==
Date:   Sun, 30 Oct 2022 10:14:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 3/5] macsec: fix secy->n_rx_sc accounting
Message-ID: <Y14yfbguG+WwARF5@unreal>
References: <cover.1666793468.git.sd@queasysnail.net>
 <b54fb76f963e4b1dbecec5e073a6dfb81f25bed8.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b54fb76f963e4b1dbecec5e073a6dfb81f25bed8.1666793468.git.sd@queasysnail.net>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:56:25PM +0200, Sabrina Dubroca wrote:
> secy->n_rx_sc is supposed to be the number of _active_ rxsc's within a
> secy. This is then used by macsec_send_sci to help decide if we should
> add the SCI to the header or not.
> 
> This logic is currently broken when we create a new RXSC and turn it
> off at creation, as create_rx_sc always sets ->active to true (and
> immediately uses that to increment n_rx_sc), and only later
> macsec_add_rxsc sets rx_sc->active.
> 
> Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
> v2: drop unnecessary !! (Leon Romanovsky)
> 

With comment from Jakub.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
