Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5291652D9D9
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbiESQIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbiESQIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:08:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F319AA2062;
        Thu, 19 May 2022 09:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B63EDB82520;
        Thu, 19 May 2022 16:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B91C385AA;
        Thu, 19 May 2022 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652976499;
        bh=NfrUNwkZUllU2Xeg370eRsoQxuMGxFVq8oahzo9zirk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KbrPy3ZjLMeW2ubPfPmPc8etb2Jc/YjQ2IMNGmWcESVRDT6QNhkB+Z/oNYxS07ary
         HnAMPWj+/9KX4/3eLOqPAzeayunUzyo6VfVDl9IbOsEzEa5sqmxm6fZVU2EOuqAmTO
         AXxDNLTquX96n6MowEGjdzP4lsbdfAIuq1HNSd3EiX8juIsOz5PdQGA7rtJR+j944J
         Xtaq9XJcIfansxkF2ocQGizRURUpxSkCUqEM6Cntk6Pm1Cv+zs5e7FNy+eCrbcJFtr
         NqCKxMZevjv8tWLr9OSTBCpYEOdruSQV2UdjhIMeTSruy+V7vQocVhhg9DAKndqnm6
         ytG7fSpKz/ERQ==
Date:   Thu, 19 May 2022 09:08:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     patchwork-bot+netdevbpf@kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        yangyingliang@huawei.com, davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH v3] tulip: convert to devres
Message-ID: <20220519090817.3187b659@kernel.org>
In-Reply-To: <4749559.31r3eYUQgx@eto.sf-tec.de>
References: <2630407.mvXUDI8C0e@eto.sf-tec.de>
        <165269761404.8728.16015739218131453967.git-patchwork-notify@kernel.org>
        <4749559.31r3eYUQgx@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 15:40:44 +0200 Rolf Eike Beer wrote:
> Works fine on my HP C3600:
> 
> [  274.452394] tulip0: no phy info, aborting mtable build
> [  274.499041] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
> [  274.750691] net eth0: Digital DS21142/43 Tulip rev 65 at MMIO 0xf4008000, 00:30:6e:08:7d:21, IRQ 17
> [  283.104520] net eth0: Setting full-duplex based on MII#1 link partner capability of c1e1
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>  drivers/net/ethernet/dec/tulip/eeprom.c     |  7 ++-
>  drivers/net/ethernet/dec/tulip/tulip_core.c | 64 ++++++---------------
>  2 files changed, 20 insertions(+), 51 deletions(-)
> 
> v2: rebased
> 
> v3: fixed typo in variable for CONFIG_GSC code

Thanks for following up. Unfortunately net-next is "stable" in terms of
commits it contains, we can swap the old patch for the new one. You
need to send an incremental change.

Please provide a Fixes tag, and if you prefer to reply to something
with the patch please reply to the report of breakage, that's better
context for this work. Or just post independently (which is generally
recommended) 
