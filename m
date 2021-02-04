Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B5730F563
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhBDOvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236737AbhBDOuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:50:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0FC0613ED
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 06:50:08 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l7fxO-0007L7-9Q; Thu, 04 Feb 2021 15:50:06 +0100
Date:   Thu, 4 Feb 2021 15:50:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
Message-ID: <20210204145006.GT3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
 <20210204140450.GS3158@orbyte.nwl.cc>
 <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 09:34:01AM -0500, Jamal Hadi Salim wrote:
> On 2021-02-04 9:04 a.m., Phil Sutter wrote:
> > Jamal,
> > 
> > On Thu, Feb 04, 2021 at 08:19:55AM -0500, Jamal Hadi Salim wrote:
> >> I couldnt tell by inspection if what used to work before continues to.
> >> In particular the kernel version does consider the divisor when folding.
> > 
> > That's correct. And so does tc. What's the matter?
> > 
> 
> tc assumes 256 when undefined. Maybe man page needs to be
> updated to state we need divisor specified otherwise default
> is 256.

tc-u32.8 mentions the default in 'sample' option description. Specifying
divisor is mandatory when creating a hash table, so that path is
covered, too. I still don't get how this is related to my patch, though.

> >> Two examples that currently work, if you can try them:
> > 
> > Both lack information about the used hashkey and divisor.
> > 
> >> Most used scheme:
> >> ---
> >> tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
> >> ht 2:: \
> >> sample ip protocol 1 0xff match ip src 1.2.3.4/32 flowid 1:10 \
> >> action ok
> >> ----
> > 
> > htid before: 0x201000
> > htid after: 0x201000
> > 
> 
> Ok, this is the most common use-case. So we are good.

Whatever.

Thanks, Phil
