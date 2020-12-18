Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671D72DEA11
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgLRURJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgLRURI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 15:17:08 -0500
Date:   Fri, 18 Dec 2020 12:16:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608322588;
        bh=YeaEMOo3SNLjGQmp2gbV9BaO9HkSGEdC11PVEMLBvCk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=osi9R86q3d4lfpwoiK++6+XpuzH9t5fdxb4O5auvJfUg3KF8p+jLeqiMQfwn+PoUJ
         7ODGoT66u0HYUbtvl6W8NupiVsEN1KcPgxaC2O1UJUxcqeXdW//Jyj750HminDfvw8
         G6qtqq19tgAhgZ6m8+lbWVdz6pGfjTx2fUVryI/pVsHM5sZjrv/0Sx/HQJQhRhO4sM
         b69R3BN5ntPBxycZWneZ5sAiz1fyfWvu+lQ9rTedyUYVwF8SsZO0bE7WlkO/5l/rKv
         XnGqaFKJR9D1ixIJbJmb3mJYg4qdR6dDpw6rZ5GzwXIzRC5uVJ9oR+sWjHOcVKZJgr
         xvGTAesz/gsYQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ben Greear <greearb@candelatech.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: net: tso: add UDP segmentation support: adds regression for
 ax200 upload
Message-ID: <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
        <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
        <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
        <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
        <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
        <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
        <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
        <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 12:40:26 -0800 Ben Greear wrote:
> On 12/17/20 10:20 AM, Eric Dumazet wrote:
> > On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:  
> >> It is the iwlwifi/mvm logic that supports ax200.  
> > 
> > Let me ask again :
> > 
> > I see two different potential call points :
> > 
> > drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
> > tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> > drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
> > tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> > 
> > To the best of your knowledge, which one would be used in your case ?
> > 
> > Both are horribly complex, I do not want to spend time studying two
> > implementations.  
> 
> It is the queue/tx.c code that executes on my system, verified with
> printk.

Not sure why Intel's not on CC here. 

Luca, is the ax200 TSO performance regression with recent kernel on your
radar?
