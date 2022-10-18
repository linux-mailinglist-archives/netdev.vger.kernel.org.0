Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF09C6033BC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJRUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJRUGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AE4A2844
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 13:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AA33616CB
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 20:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56787C433C1;
        Tue, 18 Oct 2022 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666123567;
        bh=c6exiLvsLVnLaT3JGRjpxp1lvjj2Id51KKcf1LCY48E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c1POqBGsmBMMLEOY2uAZ4+utnmEegKpfr1wxMc6LKRPh/sH7tffDvqo5FfExJN/Cd
         Kr3+vq7Oe137FTlIrnbUOTfRf1XDz3cTrDpjMz5j//y9K6O0YA3gng+b8pJfH3i997
         A5xuIMHRgGldO7EOZKIHM0ek0opS2GbgGYZ09Q1krIDdw46Qm9KB4D61Bg8ag4Ojkv
         L4u60z0ND61d1RXmkgVX+PApzJAlWBSecqTR6pxAOlEaY8ujh45Ipt585Xuovh+gCS
         7YF7PvhqfjatGMmcX4ZgegX6gy0udHXcpMnxYtbFXCplDQdspyEW2x8LjugeU67PoH
         Ei5iy5g/g5nfg==
Date:   Tue, 18 Oct 2022 13:06:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com,
        Rick Lindsley <ricklind@us.ibm.com>, haren@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Free rwi on reset success
Message-ID: <20221018130606.46c4ed3d@kernel.org>
In-Reply-To: <0665e241-fd76-8f2b-55d2-ab2df478962d@linux.ibm.com>
References: <20221017151516.45430-1-nnac123@linux.ibm.com>
        <20221018114502.1d976043@kernel.org>
        <0665e241-fd76-8f2b-55d2-ab2df478962d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 15:01:13 -0500 Nick Child wrote:
> On 10/18/22 13:45, Jakub Kicinski wrote:
> > On Mon, 17 Oct 2022 10:15:16 -0500 Nick Child wrote:  
> >> Subject: [PATCH net-next] ibmvnic: Free rwi on reset success  
> > 
> > Why net-next? it's a fix, right? it should go to Linus in the current
> > release cycle, i.e. the next -rc release.  
> 
> Apologies, I must have misunderstood when to use net vs net-next.
> The bug has been around since v5.14 so I did not want to clutter
> net inbox with things not directly relevant to v6.1.
> Would you like me to resend with the `net` tag?

Yes, anything that's a fix for code which is already present in net
should go to net. It will then make it to Linus within a week, and
Greg KH & co. can pick it up for stable trees (like 5.14) some time
later.

> > Please make sure to CC the authors of the change under Fixes, and
> > the maintainers of the driver. ./scripts/get_maintainer is your friend.  
> 
> The ibmvnic list of maintainers is due for an update. I have added the 
> current team to the CC list. We will have a patch out soon to update 
> MAINTAINERS.

I figured that may be the case, if it's not a problem I'd CC everyone
even if you know some of the addresses will bounce. Removes the need
for us to manually check why people aren't CCed.

BTW when you send the update to MAINTAINERS please target net as well,
MAINTAINERS updates are fast-tracked like fixes.
