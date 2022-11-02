Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C34E61668A
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiKBPw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiKBPwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:52:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC32B2B635;
        Wed,  2 Nov 2022 08:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D7AFB822DD;
        Wed,  2 Nov 2022 15:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C001DC433D6;
        Wed,  2 Nov 2022 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667404371;
        bh=Lgj23CDw6i9SMJxRsnw76QhJRz6ePbjGHpPaCcrPJ4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XoPJLaIg85PR/ETUFWJpLM6nTk+xSPG+nqZfA/jmrMmcIGNSVZRlWRTc4rzSW208g
         hyNizG8E0sO85+7T7HIDSRNDN2SaoPuM6SxiNeDFSZHQiC9Xm4QXgF3jj4K3sOtrWm
         2BAvYQnHwr+WB+mJ9CI8kxiVERCkRegdhPuAALyAk0ZDB7lEY67cEjtuUIB4EGMZBx
         Z1GP7rkcX7wiRVgfngKbUj5zarr417kcLS0L9yiRE7yLI4wsjnVCxXTQmlft84deLp
         ewbs+IcDkRxj9LCbL+8R0wsQePcVo7P6AJY2cuumJ5ZtZZJl4e77lqEKEmSfZnNkQJ
         U9YaYpwJWHAZg==
Date:   Wed, 2 Nov 2022 08:52:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over
 rtnetlink
Message-ID: <20221102085249.3b64e29f@kernel.org>
In-Reply-To: <Y2KOnKs0fsDNihaW@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
        <20221031124248.484405-14-jiri@resnulli.us>
        <20221101091834.4dbdcbc1@kernel.org>
        <Y2JS4bBhPB1qbDi9@nanopsycho>
        <20221102081006.70a81e89@kernel.org>
        <20221102081325.2086edd8@kernel.org>
        <Y2KOnKs0fsDNihaW@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 16:37:00 +0100 Jiri Pirko wrote:
> >> Maybe it's time to plumb policies thru to classic netlink, instead of
> >> creating weird attribute constructs?  
> >
> >Not a blocker, FWIW, just pointing out a better alternative.  
> 
> Or, even better, move RTnetlink to generic netlink. Really, there is no
> point to have it as non-generic netlink forever. We moved ethtool there,
> why not RTnetlink?

As a rewrite?  We could plug in the same callbacks into a genl family
but the replies / notifications would have different headers depending
on the socket type which gets hairy, no?
