Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C715691541
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBJAQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBJAQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:16:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9565DC3F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 16:16:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF3CA61C11
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 00:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9B4C433EF;
        Fri, 10 Feb 2023 00:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675988167;
        bh=kBUfv1e2Y5mGsh7sGrvr1JPQtJufLYGEc7xCRzO9Wmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UuU4SPATQCjbwZDXtDJfOFsx4jffwj36GIfHgeKfU24XtTAIp7+E7bkDRoUVxa6JM
         Nrx0wdbfdlTjKTD5cYPFzfPFiRnbeoAg1lfMEFIe+H/3f38Z6XtM05gMwGd8mIue9K
         bOX+4LV5exdyl/toUhLhapXIG2hPB+Zmi4hN56wEU8KPAV23bMImlCr0cIV/tY7XOF
         YRYoa2o3GWStue4Me+EBteYC4J/LzjYPg+cDgDHUrF3Ogj5s69Uix+pDejb4MHHAlo
         KGraZBWP9UhDYWBaMDJXV82ktnGnujieKwBSzDGHWWNnO9wQ9au1SuUqU/Ijlpi9uE
         bkkm/am4v4E1A==
Date:   Thu, 9 Feb 2023 16:16:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <jacob.e.keller@intel.com>, <gal@nvidia.com>, <moshe@nvidia.com>
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
Message-ID: <20230209161606.79f064ae@kernel.org>
In-Reply-To: <34be65a9-a741-7e4e-c7f3-a80d3e660528@amd.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
        <81b9453b-87e4-c4d4-f083-bab9d7a85cbe@amd.com>
        <20230209133144.3e699727@kernel.org>
        <34be65a9-a741-7e4e-c7f3-a80d3e660528@amd.com>
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

On Thu, 9 Feb 2023 16:37:13 -0600 Kim Phillips wrote:
> On 2/9/23 3:31 PM, Jakub Kicinski wrote:
> > On Thu, 9 Feb 2023 15:05:46 -0600 Kim Phillips wrote:  
> >> Is there a different tree the series can be rebased on, until net-next
> >> gets fixed?  
> > 
> > merge in net-next, the fix should be there but was merged a couple of
> > hours ago so probably not yet in linux-next  
> 
> I=Ok, I took next-20230209, git merged net-next/master, fixed a merge
> conflict to use the latter net-next/master version:

> ...and unfortunately still get a splat on that same Rome system:

Alright, so that's the splat I'm guessing the patch set was supposed 
to address. Can you confirm that you're testing 

 next-20230209 + net-next/master + this patches from the list

? The previous crash (which I called "fixed in net-next") was an
unrelated bug in the socket layer. You still have to apply the
patches from the list to fix the devlink warning.
