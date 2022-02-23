Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37884C1F75
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiBWXQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiBWXQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:16:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B5057B06
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8422EB8219D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 23:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7A7C340E7;
        Wed, 23 Feb 2022 23:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645658158;
        bh=OjqvL9c5L7J0dHkgQv2iXXZTm9OgBtlA1h2WVMzlVCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=esgD6g724hK+uZAnQS3okBzOj6ayUdCtzrf7ndTGRd+kXsqQRZcSG9qcsXQt6nM7m
         vRdMCzsulG8AJDGcFfQbFJ+rKRizRmHv5ff5j2HN5X66/veOrtjROh8t0gVeDOIMvf
         W4eTSosZK4/AsXtIYRWZ1fw6fGWxzK1eKSlhPZZGu/5ZTPQQR8YlNMVqZGbQxV6cws
         2zKh2blhVlCq/Zkbtl5mKb3zBBVCiRJV46m47Y2PQH5do3RfELbrur5FJ5A8PnlT1r
         fdG317HJNWm6GsmROa9/lQNLVjLpvlqT16hj6VfVXc/UvPTslAX+/roB/RqNJQc+Dx
         ndiGUoTe3ANBQ==
Date:   Wed, 23 Feb 2022 15:15:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Message-ID: <20220223151556.45a45c39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6a815a39-0a0b-b3b2-443d-11370ed7d091@gmail.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
        <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
        <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
        <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
        <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
        <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
        <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
        <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
        <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6a815a39-0a0b-b3b2-443d-11370ed7d091@gmail.com>
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

On Wed, 23 Feb 2022 14:58:13 -0800 Florian Fainelli wrote:
> Yes, this looks more elegant and is certainly more correct.
> 
> However there must have been something else going on with Peter's 
> provided information.
> 
> We clearly did not have an interrupt registered for the Wake-on-LAN 
> interrupt line as witnessed by the outputs of /proc/interrupts, however 
> if we managed to go past the device_can_wakeup() check in 
> bcmgenet_set_wol(), then we must have had devm_request_irq() return 
> success on an invalid interrupt number

My thinking was we never called devm_request_irq().

> or worse, botch the interrupt number in priv->irq1 to the point where
> the handler got re-installed maybe and we only end-up calling
> bcmgenet_wol_isr but no longer bcmgenet_isr1.. Hummm.

You're right, my thinking was maybe some IRQ code casts the IRQ 
number to u8, but irq_to_desc() contains no such silliness and 
should be exercised on every path :S
