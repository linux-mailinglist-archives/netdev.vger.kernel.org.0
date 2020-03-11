Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A920E182348
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCKUac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCKUab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 16:30:31 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E2D2073E;
        Wed, 11 Mar 2020 20:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583958632;
        bh=DxYnVTJp+B2Vx0uly/eYT8LCAU6XKWIauJtUwlVZ2NE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iEZhYqaKz6E3QBJ6l7BlEvPkgNCzpTYov54QKFgqBS66xCM2RSLvuY4ZVdYz/qM5q
         D4dQ3xPg7D7OdU+kDdzhhj1xxz70Lru2GiFxSzTtSohdFWsaK9VD/zoVDwL6sAkr1S
         PCFg0/fKp8qGawCwuMa7CSJW6UER5JN28NnY3n5g=
Date:   Wed, 11 Mar 2020 13:30:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
Message-ID: <20200311133028.7327abb5@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200311071955.GA2258@nanopsycho.orion>
References: <20200310154909.3970-1-jiri@resnulli.us>
        <20200310120519.10bffbfe@kicinski-fedora-PC1C0HJN>
        <20200311071955.GA2258@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 08:19:55 +0100 Jiri Pirko wrote:
> Tue, Mar 10, 2020 at 08:05:19PM CET, kuba@kernel.org wrote:
> >On Tue, 10 Mar 2020 16:49:06 +0100 Jiri Pirko wrote:  
> >> This patchset includes couple of patches in reaction to the discussions
> >> to the original HW stats patchset. The first patch is a fix,
> >> the other two patches are basically cosmetics.  
> >
> >Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> >
> >This problem already exists, but writing a patch for nfp I noticed that
> >there is no way for this:
> >
> >	if (!flow_action_hw_stats_types_check(flow_action, extack,
> >					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
> >		return -EOPNOTSUPP;
> >
> >to fit on a line for either bit, which kind of sucks.  
> 
> Yeah, I was thinking about having flow_action_hw_stats_types_check as a
> macro and then just simply have:
> 
> 	if (!flow_action_hw_stats_types_check(flow_action, extack, DELAYED))
> 		return -EOPNOTSUPP;
> 
> WDYT?

I'd rather have the 80+ lines than not be able to grep for it :(

What's wrong with flow_action_stats_ok()? Also perhaps, flow_act 
as a prefix?
