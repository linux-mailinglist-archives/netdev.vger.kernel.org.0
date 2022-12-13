Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AD464B176
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbiLMIsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiLMIrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:47:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0EF5F5F
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 00:47:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEA29B810D9
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9149C433D2;
        Tue, 13 Dec 2022 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670921259;
        bh=XshzbYRyfhQmhtsWHYIJxqmd5TM7J+zRk3BhxWOt5jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8/vXxcdKftH7oxI/anN6t2rkIeZQlcL0hj0Ei0yEEdoceHKpcHoSDncevkvX+/av
         tKHYVMvT87+HAL2emSBR95ckVUeszRls0NoKDeA5MAk1q4LBoJbelqJnwx3+j1JBxF
         zrhVlFFTG8YrfXzqq0TF2UQpPFn2xjzYNxRPxAHut+Hkdzxd5eMU6U+TF2ai/sP7ac
         jPhqsjquAzTz+gtfxdGW+fles0VU6pyHqeih1vQ0IO55CenwHchp+pxRLsrArFvo2e
         z1ccmtZdJL9c/zO4mAWPvgmF53E/UXsnfAmB8QYMGTibkrGDrcMIPY/0YTli6dLUyR
         U91vabKglvYUQ==
Date:   Tue, 13 Dec 2022 10:47:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, agraf@suse.de,
        akihiko.odaki@daynix.com, yan@daynix.com,
        gregkh@linuxfoundation.org, security@kernel.org
Subject: Re: [PATCH net 1/1] igb: Initialize mailbox message for VF reset
Message-ID: <Y5g8J/mFDaW/6GHq@unreal>
References: <20221212190031.3983342-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212190031.3983342-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 11:00:31AM -0800, Tony Nguyen wrote:
> When a MAC address is not assigned to the VF, that portion of the message
> sent to the VF is not set. The memory, however, is allocated from the
> stack meaning that information may be leaked to the VM. Initialize the
> message buffer to 0 so that no information is passed to the VM in this
> case.
> 
> Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
> Reported-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
