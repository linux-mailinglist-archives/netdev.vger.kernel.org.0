Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4300152A7C0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350844AbiEQQUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiEQQT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243C63A5FC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 09:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3494B81852
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 16:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A1EC385B8;
        Tue, 17 May 2022 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652804395;
        bh=3k8wWNT0Qt9ysU5XABBJtcaOmbC3//qNuOYPwER9KBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I4yAiIrZfwo/KC42nrXVq/+2rr4109TZ7K7t/iK6M5Z4SzY9Ro/rwTXAB4i74i4ly
         Un1DEFw8UfTg1CZrlWRE0PCN7UCnD71O6JwMK5k4j4M+I7HEW3Ofgx1R1NI93pNxUu
         nPSWMoOeMpa7y01QZst3q1W7IqopjbSUSHRjiaUSeEvISRNEztI+1GwxYlyZgPUdLO
         CzBfb4OIqU/8bSy5BmX0RtnUOBVFWMwFaF3JfR9lHu5uoLopGQ/Rnwz0ri7UZEU7yE
         avMtUiO4ARTfDL7ZYMl5w9Wfw26/jlbLaU7OI3DWv9x/x1f1PCT6tvGuw2LNa/8bLI
         cU3yVOfIotchQ==
Date:   Tue, 17 May 2022 09:19:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 08/10] ptp: ocp: fix PPS source selector
 reporting
Message-ID: <20220517091953.4d9a0e4b@kernel.org>
In-Reply-To: <20220517153942.6ze5kj7hoj7z4caq@bsd-mbp.dhcp.thefacebook.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
        <20220513225924.1655-9-jonathan.lemon@gmail.com>
        <20220516174317.457ec2d1@kernel.org>
        <20220517015428.l6ttuht3ufrl2deb@bsd-mbp.dhcp.thefacebook.com>
        <20220517153942.6ze5kj7hoj7z4caq@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 08:39:42 -0700 Jonathan Lemon wrote:
> On Mon, May 16, 2022 at 06:54:28PM -0700, Jonathan Lemon wrote:
> > On Mon, May 16, 2022 at 05:43:17PM -0700, Jakub Kicinski wrote:  
> > > This one and patch 10 need Fixes tags  
> > 
> > This is for a debugfs entry.  I disagree that a Fixes: tag
> > is needed here.
> > 
> > I'll do it for patch 10 if you insist, but this only happens
> > if ptp_clock_register() fails, which not normally seen.  
> 
> Actually, patch 10 would be:
> 
> Fixes: c205d53c4923 ("ptp: ocp: Add firmware capability bits for feature gating")
> 
> Which is only in 5.18-rcX at this point.
> 
> Do we need a fixes tags for code which hasn't made it into a
> full release release yet?

Yup, having the Fixes tag makes it obvious to the maintainer that 
the tree selection is correct and helps backporters figure out if 
they need to worry that the patch didn't apply.
