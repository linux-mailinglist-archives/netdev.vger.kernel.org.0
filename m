Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB79A68FBD1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjBIAGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBIAGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:06:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879881E5D7;
        Wed,  8 Feb 2023 16:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 418E5B81FDA;
        Thu,  9 Feb 2023 00:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDDCC433EF;
        Thu,  9 Feb 2023 00:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675901195;
        bh=SErohad/pM+SbSsuiCTv3GgZjAmuNlvw7nW8SV0r+jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t1kifL0E2IA8zDvbcsWL/tbkHxGqKe7a4Y6nnnVbBEaCI48ZxRhkgpZ8g5efcJQ30
         Hdnxc//Bn3ylELOgTNIDt//poCXrOxNoSRLs/iBWXO2ypdlkz52BdQWOjfoJmfmEZK
         gZBVaNk8S1DmuP5N0ex3KVH4NpksBaOjZFnM0zNjeZO9aUZT3ph34Sbh2HPfT9hS8U
         8MAkn+gdMh32pPWTBRhVhsefVavktEVb3X5vef5UGHLIlWqI0g5K/H8zL9OKLLtSSQ
         MORedatv8QIvMoRImUlaMAyWpBsRh0REmlw/AZj8i4J6JmZeOU21MSgyUdyJf5kzBw
         yc9AM7oSw5ACg==
Date:   Wed, 8 Feb 2023 16:06:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: renesas: rswitch: Improve TX
 timestamp accuracy
Message-ID: <20230208160634.33d2abfd@kernel.org>
In-Reply-To: <20230208073445.2317192-5-yoshihiro.shimoda.uh@renesas.com>
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
        <20230208073445.2317192-5-yoshihiro.shimoda.uh@renesas.com>
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

On Wed,  8 Feb 2023 16:34:45 +0900 Yoshihiro Shimoda wrote:
> In the previous code, TX timestamp accuracy was bad because the irq
> handler got the timestamp from the timestamp register at that time.
> 
> This hardware has "Timestamp capture" feature which can store
> each TX timestamp into the timestamp descriptors. To improve
> TX timestamp accuracy, implement timestamp descriptors' handling.

2 new sparse warnings here:

drivers/net/ethernet/renesas/rswitch.c:917:24: warning: restricted __le32 degrades to integer
drivers/net/ethernet/renesas/rswitch.c:918:23: warning: restricted __le32 degrades to integer
