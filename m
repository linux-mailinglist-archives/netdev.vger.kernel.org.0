Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124D7610038
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiJ0SaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbiJ0SaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:30:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0F52A411
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80540B82750
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA2AC433D6;
        Thu, 27 Oct 2022 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666895397;
        bh=D6hEI2MefJnUUmPfixeID+z2q0LHFjWOFXH/B0/DS/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CPyODxO3fU4nNL3gITTaWM80fAI+d6netBI4b/f6YlMtb03JAqXpXtjKmMMYW+aBo
         IweB9aRQcGl1SLrHMYLSgETdL0pB+3j6XerMEFedbEzWfPqKSBAJVFlMfnFkiLz3Mq
         kk01gMlMuZPBS02/JO6sppRSIaptjMPt3hGKfmQTJVAHwxep7Hoy7cdYpaDHi2g86s
         GcNZAaKWWIWqpMAByqOqbWTZmWdSi2oy4FG1xdCBdj3uSsgcBqgs6MgwnClz7ct9Zk
         Tkn5akbO7zn343ZrwrlUPb9X3M1WlOJ9BruRGBpm0BbbZogt7T1tz2DYKnUUT0knc/
         OqydQXT0VdZFg==
Date:   Thu, 27 Oct 2022 11:29:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 3/5] macsec: fix secy->n_rx_sc accounting
Message-ID: <20221027112955.6a98adb4@kernel.org>
In-Reply-To: <b54fb76f963e4b1dbecec5e073a6dfb81f25bed8.1666793468.git.sd@queasysnail.net>
References: <cover.1666793468.git.sd@queasysnail.net>
        <b54fb76f963e4b1dbecec5e073a6dfb81f25bed8.1666793468.git.sd@queasysnail.net>
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

On Wed, 26 Oct 2022 23:56:25 +0200 Sabrina Dubroca wrote:
>  
> -	rx_sc = create_rx_sc(dev, sci);
> +
> +	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])

nit: double new line :(
