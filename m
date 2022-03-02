Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE34CACDC
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbiCBSDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244390AbiCBSDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:03:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E4C13FAC
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 10:02:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D05760ACA
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 18:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945B7C340F2;
        Wed,  2 Mar 2022 18:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646244168;
        bh=yXoAgcoMdMwkB1AvxU0MLHMUqHYlMbDYJCTH9R+87a8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fA+Zel0qm4A7WFYIPBmaas/rauBdbtw9bwGPHIkfHFO6cLN3ZcRsUB8UCCss+a3i8
         q8YyMO/pg3rrr0wdZA4b74bQCBUpSAUPfE4mbx74xm/y9R03kG4jvZgTOSwDVFYxqe
         ++mJFhoWUioZBe04niIjqpn1Sew/W8VNvaaTLDfo8QOOICwRvwvuexjRKcrc8nANHl
         0vSRACbnDobKK6vTw3Kwkd7uXlVC0HSH+2dcW/5PUyaT9aik4vB1Dy7BqlF2PtAUHJ
         wGE3RqhZe7kZbSbdTMhI4yWZ0WCMx7OtNCYKOu42pj9SuW+1lZ9Q6jqmFn7ijYtrB9
         +4siOQEd+mjkw==
Date:   Wed, 2 Mar 2022 10:02:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Message-ID: <20220302100246.393f1af7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
        <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
        <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
        <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
        <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
        <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
        <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
        <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
        <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 14:48:18 -0800 Jakub Kicinski wrote:
> > Understood and I won't require you or me to complete this investigating 
> > before fixing the regression, this is just so we understand where it 
> > stemmed from and possibly fix the IRQ layer if need be. Given what I 
> > just wrote, do you think you can sprinkle debug prints throughout the 
> > kernel to figure out whether enable_irq_wake() somehow messes up the 
> > interrupt descriptor of interrupt and test that theory? We can do that 
> > offline if you want.  
> 
> Let me mark v2 as Deferred for now, then. I'm not really sure if that's
> what's intended but we have 3 weeks or so until 5.17 is cut so we can
> afford a few days of investigating.

I think the "few days of investigating" have now run out :( 
How should we proceed?
