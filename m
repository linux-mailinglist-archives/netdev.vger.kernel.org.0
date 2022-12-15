Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7964E196
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiLOTJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOTJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:09:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AD5BA8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBC3C61ED4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E4C433D2;
        Thu, 15 Dec 2022 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671131366;
        bh=P7ZQHeA8XVcjD+rud4awsrqgUh4MKWPgnKv2QBe3IOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FBG1UrPraemZuVTVBHhKX7tWElNSeS4BhdfPTH1JEa/elLbbWYCEUvAb3l9JS0BJq
         k2vlfZEfN2wz/CXch1c64A5VKMRlaG/dtB91UKd+PR16jlwb0URpja60EmTipkNszb
         qAE557Z3wQsCuYkdVjf6GHiB8R376dJsizqMKhPrlxm8i++vSgdPAAhsc8kdW3EWPI
         83DJ/4eVEGJ74pin+er6Zffp/kZ53SdLPcrrJU19yMCos7msJBZSsXDF5CSp2OdTVg
         FetrGvQCzWSBjfNifq5q9oVhaS0t2tVLK0r0tqA/6F5f1a2aat1aEUun111OspI31J
         D3xdfkm1rX31w==
Date:   Thu, 15 Dec 2022 11:09:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated
 directory
Message-ID: <20221215110925.6a9d0f4a@kernel.org>
In-Reply-To: <Y5ruLxvHdlhhY+kU@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-2-kuba@kernel.org>
        <Y5ruLxvHdlhhY+kU@nanopsycho>
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

On Thu, 15 Dec 2022 10:51:43 +0100 Jiri Pirko wrote:
> > net/Makefile                            | 1 +
> > net/core/Makefile                       | 1 -
> > net/devlink/Makefile                    | 3 +++
> > net/{core/devlink.c => devlink/basic.c} | 0  
> 
> What's "basic" about it? It sounds a bit misleading.

Agreed, but try to suggest a better name ;)  the_rest_of_it.c ? :)

> > 4 files changed, 4 insertions(+), 1 deletion(-)
> > create mode 100644 net/devlink/Makefile
> > rename net/{core/devlink.c => devlink/basic.c} (100%)
> >
> >diff --git a/net/Makefile b/net/Makefile
> >index 6a62e5b27378..0914bea9c335 100644
> >--- a/net/Makefile
> >+++ b/net/Makefile
> >@@ -23,6 +23,7 @@ obj-$(CONFIG_BPFILTER)		+= bpfilter/
> > obj-$(CONFIG_PACKET)		+= packet/
> > obj-$(CONFIG_NET_KEY)		+= key/
> > obj-$(CONFIG_BRIDGE)		+= bridge/
> >+obj-$(CONFIG_NET_DEVLINK)	+= devlink/  
> 
> Hmm, as devlink is not really designed to be only networking thing,
> perhaps this is good opportunity to move out of net/ and change the
> config name to "CONFIG_DEVLINK" ?

Nothing against it, but don't think it belongs in this patch.
So I call scope creep.
