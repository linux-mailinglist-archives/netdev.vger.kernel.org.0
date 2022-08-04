Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36276589F15
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiHDQGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 12:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiHDQGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 12:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5FE64F6;
        Thu,  4 Aug 2022 09:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB2656145D;
        Thu,  4 Aug 2022 16:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6978C433C1;
        Thu,  4 Aug 2022 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659629168;
        bh=yIBhe5VH/Mtc9UsxkvWfeuMI7NsYBSBH6YG9F3/NAjc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L4CBv5AssfXjZqYIFVgNxzAIjY7jYFfZw8S9OtNrpvalddVvilbAFPrLZA2vY6/4+
         1EJBparExiBcTS1KDZPdmOhDRcTNUkfNRKllg7K9UnjtP6+GMN+9Zy0S2D6L2sW8cB
         5onDeb2jsUO2RlCfg9tXDJ8UFmGe0iz2a9uN5PwSVDeg9+bb/1IwNVmynVjdkF2pOA
         JpnNMnwHAOHg5AEym5exT7omBzs3O1FmidoIKzJKGwssKsUJabnS2p8YEo7uw6JWbD
         PMEOcOuWkNXmm3eruVplAwmgUWntbyZ0nYFoYb0+iJyVFZil1/we2rFKVbDv4xk+Dp
         yD5O6TTVfdQgA==
Date:   Thu, 4 Aug 2022 09:06:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Naveen Mamindlapalli <naveenm@marvell.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [net-next PATCH v2 0/4] Add PTP support for CN10K silicon
Message-ID: <20220804090606.0c892e51@kernel.org>
In-Reply-To: <Yus4QrgERE9yR9WG@hoboy.vegasvil.org>
References: <20220730115758.16787-1-naveenm@marvell.com>
        <20220802121439.4d784f47@kernel.org>
        <20220802214420.10e3750f@kernel.org>
        <Yus4QrgERE9yR9WG@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 20:08:50 -0700 Richard Cochran wrote:
> > Oh, well. These will have to wait until after the merge window then :(  
> 
> FWIW - I'm okay with any PTP patches that are about specific hardware
> drivers.  When I can, I'll review them for proper use of the core
> layer, locking, etc, but at the end of the day, only the people
> holding the data sheet know how to talk to the hardware.
> 
> Patches that touch the core layer are another story.  These need
> careful review by me and other.  (Obviously)

I was hoping you could cast an eye over the 1-step implementation here.
Giving the device a random time reference along the packet looks odd.
Unfortunately I don't have much (any?) experience with 1-step myself so
I can't trust my own judgment all that much.
