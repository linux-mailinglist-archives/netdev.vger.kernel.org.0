Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711D464E19B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLOTNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOTNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:13:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174692C65F
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A56E561EEC
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B4BC433EF;
        Thu, 15 Dec 2022 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671131597;
        bh=45HAReFuOBgMx5WoUPkDjtpIIb1GIz7gAZkttrJPFuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hs1Ga/xVyE3NVc78rL/yCoizCMrbiFe6ZW+bpGIe+EvswAsVozZ14Tf/74OQBiFJX
         qNtMgDCjG1E4X5oi/7WwQSC0Lgi41HqIdie3p8zhmT98ic5P+Oq54EJ7L0lNsbY5Xc
         EZXHaACVKAKxXjt4XK5YOaXUPVtoaNYyKqIwBfBlp6xvsgc41ABNJlCMwwiomPslsE
         MsjWz2uEziQueDoB+BYv3GREKQQGmjbh2Ope5RV0nBYS8ir94bBucaQaK0BUHR3DO4
         i/sEIxq6SuM+XHmq0yrnQlWuQ0P5y+hdoQ9kzdE1i7gS4wF0wAjhi14Epu6fg3zOVZ
         LNsIb6rsNwm+g==
Date:   Thu, 15 Dec 2022 11:13:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <leon@kernel.org>
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated
 directory
Message-ID: <20221215111315.3637cdcc@kernel.org>
In-Reply-To: <cebb83f7-139d-5d40-5731-425873bae422@intel.com>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-2-kuba@kernel.org>
        <Y5ruLxvHdlhhY+kU@nanopsycho>
        <cebb83f7-139d-5d40-5731-425873bae422@intel.com>
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

On Thu, 15 Dec 2022 10:44:14 -0800 Jacob Keller wrote:
> On 12/15/2022 1:51 AM, Jiri Pirko wrote:
> > Thu, Dec 15, 2022 at 03:01:41AM CET, kuba@kernel.org wrote:  
> >> The devlink code is hard to navigate with 13kLoC in one file.
> >> I really like the way Michal split the ethtool into per-command
> >> files and core. It'd probably be too much to split it all up,  
> > 
> > Why not? While you are at it, I think that we should split it right
> > away.
>
>  From the cover letter it sounds like "not enough time". I like 
> splitting things up but would be fine with just one file per sub object 
> type like one for ports, one for regions, etc.

Indeed, I had to draw the line somewhere. Always plenty of
opportunities to reshuffle and improve code which has grown
organically over the years. But the sun goes down obsitnately...
