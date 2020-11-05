Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A662A8401
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgKEQvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEQvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:51:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34A5D20759;
        Thu,  5 Nov 2020 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604595076;
        bh=8ToTuZ7qm9NTKaQyT+NGylj1byXgZNloZjlMSL5/+GI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0fsxCm93NMe4rBrrNGggCrqaofiJXOnQRyxdJ1nMOUNyaHHva8ceGm4qUsOSXC7rf
         jMLzf3Tl2CKtKdqPqjJC1LYBDWltYvlYkQd6LmgyHoGiYIcu21FzMWDYJwRpfBkOBM
         NlWcZSKadCih2BSv2r9coSHRDuQ4WiBbIgt79DXc=
Date:   Thu, 5 Nov 2020 08:51:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v2] net: sched: implement action-specific terse
 dump
Message-ID: <20201105085115.609cade1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ba0251f7-e3d4-5197-3a09-8598418e10dc@mojatatu.com>
References: <20201102201243.287486-1-vlad@buslov.dev>
        <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ba0251f7-e3d4-5197-3a09-8598418e10dc@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 06:48:48 -0500 Jamal Hadi Salim wrote:
> On 2020-11-04 7:39 p.m., Jakub Kicinski wrote:
> > On Mon,  2 Nov 2020 22:12:43 +0200 Vlad Buslov wrote:  
> >> Allow user to request action terse dump with new flag value
> >> TCA_FLAG_TERSE_DUMP. Only output essential action info in terse dump (kind,
> >> stats, index and cookie, if set by the user when creating the action). This
> >> is different from filter terse dump where index is excluded (filter can be
> >> identified by its own handle).
> >>
> >> Move tcf_action_dump_terse() function to the beginning of source file in
> >> order to call it from tcf_dump_walker().
> >>
> >> Signed-off-by: Vlad Buslov <vlad@buslov.dev>
> >> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>  
> > 
> > Jiri, Cong, can I get an ack?
> > 
> > The previous terse dump made sense because it fulfilled the need of
> > an important user (OvS).   
> 
> The requirement is to save on how much data crosses between user
> space and the kernel. If you are polling the kernel every second
> for stats and you can shave say 32B per rule - it is not a big
> deal if you have a few rules. If you have 1M rules thats 32MB/s
> removed.
> So how do you get the stats? You can poll the rules (which have actions
> that embed the stats). That approach is taken by Ovs and some others.
> Or you can poll the actions instead (approach we have taken to cut
> further on data crossing). Polling the actions has also got a lot of
> other features built in for this precise purpose (example time-of-use
> filtering).
> Terse is useful in both cases because it cuts the amount of data
> further.

Ack.
