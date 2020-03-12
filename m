Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2198A1839B0
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgCLTkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgCLTkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 15:40:16 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42DFA206E2;
        Thu, 12 Mar 2020 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584042015;
        bh=/U+yUbvg7DT7d48f92hAxFtmcLkNlfNWwtM19iEWmGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0IFvp74cEwQKKdGYXgCWysZnoumSB8EJcXVa0hWDLC9+O4ImnShmvftvHTn7b4ysy
         8AlG4iG5IfUnImxkt8EGFjP6BE9+n0CfXCOZ3Ce/hFi0zQNnahHGRDIuaTtatx9OPp
         hNhHir7h1FcMrERrEMRQprOCtHrt7DgXnV4f1M6Q=
Date:   Thu, 12 Mar 2020 12:40:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
Message-ID: <20200312124013.06609fbc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200312070359.GA2221@nanopsycho.orion>
References: <20200310154909.3970-1-jiri@resnulli.us>
        <20200310120519.10bffbfe@kicinski-fedora-PC1C0HJN>
        <20200311071955.GA2258@nanopsycho.orion>
        <20200311133028.7327abb5@kicinski-fedora-PC1C0HJN>
        <20200312070359.GA2221@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 08:03:59 +0100 Jiri Pirko wrote:
> Wed, Mar 11, 2020 at 09:30:28PM CET, kuba@kernel.org wrote:
> >On Wed, 11 Mar 2020 08:19:55 +0100 Jiri Pirko wrote:  
> >> Tue, Mar 10, 2020 at 08:05:19PM CET, kuba@kernel.org wrote:  
> >> >On Tue, 10 Mar 2020 16:49:06 +0100 Jiri Pirko wrote:    
> >> >> This patchset includes couple of patches in reaction to the discussions
> >> >> to the original HW stats patchset. The first patch is a fix,
> >> >> the other two patches are basically cosmetics.    
> >> >
> >> >Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> >> >
> >> >This problem already exists, but writing a patch for nfp I noticed that
> >> >there is no way for this:
> >> >
> >> >	if (!flow_action_hw_stats_types_check(flow_action, extack,
> >> >					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
> >> >		return -EOPNOTSUPP;
> >> >
> >> >to fit on a line for either bit, which kind of sucks.    
> >> 
> >> Yeah, I was thinking about having flow_action_hw_stats_types_check as a
> >> macro and then just simply have:
> >> 
> >> 	if (!flow_action_hw_stats_types_check(flow_action, extack, DELAYED))
> >> 		return -EOPNOTSUPP;
> >> 
> >> WDYT?  
> >
> >I'd rather have the 80+ lines than not be able to grep for it :(
> >
> >What's wrong with flow_action_stats_ok()? Also perhaps, flow_act 
> >as a prefix?  
> 
> Well nothing, just that we'd loose consistency. Everything is
> "flow_action_*" and also, the name you suggest might indicate that you
> are checking sw stats. :/

SW stats in flow action? flow stuff is an abstraction for HW/drivers.
