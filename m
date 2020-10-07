Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD23528656D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgJGRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgJGRHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:07:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF097216C4;
        Wed,  7 Oct 2020 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602090421;
        bh=r1qZdvMfADhlnIS+CsJzlSobb2ffocmjr8kqQ63GkTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FIncYpLTnhGRHcm54Z/ZcItSH1Be5WQAmT0aYhsP/EIIVodaN45rHkPVPQCPgwgCK
         UL6lpOA8AVTdKielHjEXQI6odKCwz1xeQ8SCLu8uV8bVCQ5QmewW6ZNjzdyFZP9uOb
         OC1GBtCCqt9ioD5bcMQcVJupacR7s61XP8/vwbuY=
Date:   Wed, 7 Oct 2020 10:06:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH v2 0/2] netlink: export policy on validation failures
Message-ID: <20201007100658.26013c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006181555.103140-1-johannes@sipsolutions.net>
References: <20201006181555.103140-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 20:15:53 +0200 Johannes Berg wrote:
> Export the policy used for attribute validation when it fails,
> so e.g. for an out-of-range attribute userspace immediately gets
> the valid ranges back.
> 
> v2 incorporates the suggestion from Jakub to have a function to
> estimate the size (netlink_policy_dump_attr_size_estimate()) and
> check that it does the right thing on the *normal* policy dumps,
> not (just) when calling it from the error scenario.
> 
> 
> Tested using nl80211/iw in a few scenarios, seems to work fine
> and return the policy back, e.g.
> 
> kernel reports: integer out of range
> policy: 04 00 0b 00 0c 00 04 00 01 00 00 00 00 00 00 00 
>         ^ padding
>                     ^ minimum allowed value
> policy: 04 00 0b 00 0c 00 05 00 ff ff ff ff 00 00 00 00 
>         ^ padding
>                     ^ maximum allowed value
> policy: 08 00 01 00 04 00 00 00 
>         ^ type 4 == U32
> 
> for an out-of-range case.

Too minor nits, with those addressed:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
