Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139584DB875
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350303AbiCPTTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 15:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239247AbiCPTTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 15:19:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544621FA76
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 12:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA297B81CCE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 19:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C04C340EC;
        Wed, 16 Mar 2022 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647458307;
        bh=auNLxIlGNcIvuiL+RdmhXJCK5ajm41FRCgIOC4esN5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kFkCd6XrMQQVoD8lv83V5bL/E3lN5kQ79S73Q6S9ll8D0YJLHRoMe1N42IINmKBWv
         lwTCljjh0ksccCJNhkRK2y/1Ttb5Xj01ACVKlpZcg4F/3u0It5AptN2GlmphGZxCU2
         A/4zul/LJFf2jatf4kI/oFxJc3SZk0f5RbqmouNPHcG28KWWYGWeLaDgC6b76M52zw
         g6CF/sRdA4L8hb/aavbc4eu4atEhkQTwubi5g1dHXc7ywQpdHjUr1YnXO/RPh+0SiA
         YuduwxNSVSqfJ2MoDDaxh4DwyfG3KXZzEtTE1uErU1uf3TuP/E+R0Dz79wYPG9rNca
         BB69rHuckvCFw==
Date:   Wed, 16 Mar 2022 12:18:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Manish Chopra <manishc@marvell.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>
Subject: Re: [EXT] Re: bnx2x: ppc64le: Unable to set message level greater
 than 0x7fff
Message-ID: <20220316121825.6eb08c07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316185232.ttsuvp4wbdxztned@lion.mk-sys.cz>
References: <0497a560-8c7b-7cf8-84ee-bde1470ae360@molgen.mpg.de>
        <20220315183529.255f2795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <db796473-69cf-122e-ec40-de62659517b0@molgen.mpg.de>
        <ade0ed87-be4f-e3c7-5e01-4bfdb78fae07@molgen.mpg.de>
        <BY3PR18MB4612AD5E7F7D59233990A21DAB119@BY3PR18MB4612.namprd18.prod.outlook.com>
        <20220316111754.5316bfb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220316185232.ttsuvp4wbdxztned@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 19:52:32 +0100 Michal Kubecek wrote:
> > Yup, IIUC it works for Paul on a 5.17 system, that system likely has
> > old ethtool user space tool which uses ioctls instead of netlink.
> > 
> > What makes the netlink path somewhat non-trivial is that there is 
> > an expectation that the communication can be based on names (strings)
> > as well as bit positions. I think we'd need a complete parallel
> > attribute to carry vendor specific bits :S  
> 
> Yes, that would be a way to go. However, in such case I would prefer
> separating these driver/device specific message flags completely rather
> then letting drivers grab currently unused flags (as is the case here,
> IIUC) as those are likely to collide with future global ones.

I was thinking let the driver specify which flags it is squatting on in
a mask in ethtool_ops, and then make sure the generic vs non-generic
flags are routed appropriately in the user space <> core communication.
We can also split the private vs generic on the ethtool_op level.

User space would have to jump thru extra hoops to figure the separation
out (maybe we can expose the "private mask" in get?)

I agree that the more we can separate the private and generic flags,
the better, that's just what I could come up with.
