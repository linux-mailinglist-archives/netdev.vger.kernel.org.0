Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7658467A851
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjAYBRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjAYBRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:17:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783551734
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 17:17:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F287B6140D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A146C433EF;
        Wed, 25 Jan 2023 01:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674609458;
        bh=jvQmcESZOqDbnbIitoKLKFqWY4wM0g90DAuYb7sf2a8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YujLJoBLl3VTUrt2LSGIvF+dPeP7gJ3qzl7C1jdlSjBk1qizkoviFU3hxta/jNZ1R
         oV5wg21NkyxniUA5kyfKX4X0eDtL8WipRmzDFbSqHrmvXh9WClDCZRoJ97Ow2B+S1i
         xL3hxgHRnCSFMqqIdOHQb6bCKSv/GVLxNy3WVtIP+TsYdaY/erbzvqoBmkKEkp9lMC
         arV//e5MbYRfnMGQSplVPmLinHqL7crVpKz5DRekUV+NNq/0p9IU9dzs9mfahWiQot
         /s609ZTlfDZLONYJuOqwsAZZ8iyvTzhHPOfZ3i8PI3ZoIqfINtJYOOegJQFcwfNWN8
         VsF7mWIpSAsYA==
Date:   Tue, 24 Jan 2023 17:17:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
Message-ID: <20230124171736.30729264@kernel.org>
In-Reply-To: <20230125005333.dmphl4vuwnh66moa@skbuf>
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
        <20230124162347.48bdae92@kernel.org>
        <20230125004517.74c7ssj47zykciuv@skbuf>
        <20230124165223.49ab04b5@kernel.org>
        <20230125005333.dmphl4vuwnh66moa@skbuf>
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

On Wed, 25 Jan 2023 02:53:33 +0200 Vladimir Oltean wrote:
> > > Yeah, sorry, I shouldn't have left your question unanswered ("should we make
> > > a fake struct genl_info * to pass here?") - but I don't think I'm qualified
> > > enough to have an opinion, either. Whereas the immediate fix is neutral
> > > enough to not be controversial, or so I thought.
> > > 
> > > The problem is not so much "the time to fix this properly", but rather,
> > > I'm not even sure how to trigger the ethtool dumpit() code...  
> > 
> > Ack, makes sense. I just wanted to make sure you weren't disagreeing.  
> 
> Since we're talking about it, do you know how to exercise that code?

Your MM code? Not really. But the code is fairly copy'n'paste.
I test what netdevsim supports (netdevsim support for MM highly
encouraged).
