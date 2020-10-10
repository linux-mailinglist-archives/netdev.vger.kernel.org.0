Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A8289DFE
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgJJDjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbgJJDc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 23:32:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 627D4208C7;
        Sat, 10 Oct 2020 03:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602300300;
        bh=jBftCB4irlthVNEkcBHQ1gVM5ML5bOtAtfKCx+5tJGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i41X1FMj4oNybt8O3Bm70pBpudAAHleIGzsMXfPtYWegx/W6ISxSuMnz38IcLaaWJ
         lUWS7wr4XM7D5O6ine1rNHHbrFP/LIjX955ffBIzk9BuNZ16sU8kwIie9ro4/6FvmX
         aacNY/tgmOoEIm7qvc5TR7FF7a5FnDKoI3n5WtQ0=
Date:   Fri, 9 Oct 2020 20:24:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/2] netlink: export policy on validation failures
Message-ID: <20201009202458.53dd5d4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008104517.44312-1-johannes@sipsolutions.net>
References: <20201008104517.44312-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 12:45:15 +0200 Johannes Berg wrote:
> Export the policy used for attribute validation when it fails,
> so e.g. for an out-of-range attribute userspace immediately gets
> the valid ranges back.
> 
> v2 incorporates the suggestion from Jakub to have a function to
> estimate the size (netlink_policy_dump_attr_size_estimate()) and
> check that it does the right thing on the *normal* policy dumps,
> not (just) when calling it from the error scenario.
> 
> v3 only addresses a few minor style issues.
> 
> v4 fixes up a forgotten 'git add' ... sorry.
> 
> v5 is a resend, I messed up v4's cover letter subject (saying v3)
> and apparently the second patch didn't go out at all.
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

Applied, thanks!
