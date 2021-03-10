Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514343338D3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhCJJdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:33:53 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:58361 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232433AbhCJJdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:33:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0URGK1KC_1615368810;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URGK1KC_1615368810)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 17:33:30 +0800
Date:   Wed, 10 Mar 2021 17:33:29 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <YEiSaR/8MEBEHNzQ@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <203c49a3-6dd8-105e-e12a-0e15da0d4df7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <203c49a3-6dd8-105e-e12a-0e15da0d4df7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 09:12:45PM +0100, Eric Dumazet wrote:
> 
> 
> On 3/9/21 5:43 AM, Tony Lu wrote:
> > There are lots of net namespaces on the host runs containers like k8s.
> > It is very common to see the same interface names among different net
> > namespaces, such as eth0. It is not possible to distinguish them without
> > net namespace inode.
> > 
> > This adds net namespace inode for all net_dev events, help us
> > distinguish between different net devices.
> > 
> > Output:
> >   <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > ---
> >
> 
> There was a proposal from Lorenz to use netns cookies (SO_NETNS_COOKIE) instead.
> 
> They have a guarantee of being not reused.
> 
> After 3d368ab87cf6681f9 ("net: initialize net->net_cookie at netns setup")
> net->net_cookie is directly available.

It looks better to identify ns with net_cookie rather than inode, and
get the value with NS_GET_COOKIE. I will switch net_inum to net_cookie
in the next patch.


Cheers,
Tony Lu

> 
