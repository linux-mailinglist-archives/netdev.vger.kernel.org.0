Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B31645B399
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhKXEtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:49:33 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:41652 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhKXEtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 23:49:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uy3pXuY_1637729181;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uy3pXuY_1637729181)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:21 +0800
Date:   Wed, 24 Nov 2021 12:46:20 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net/smc: Unbind buffer size from clcsock
 and make it tunable
Message-ID: <YZ22dvQYB0oWN4Mk@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211122134255.63347-1-tonylu@linux.alibaba.com>
 <f08e1793-630f-32a6-6662-19edc362b386@linux.ibm.com>
 <YZyQg23Vqes4Ls5t@TonyMac-Alibaba>
 <9aaa03b2-4478-6dff-0bfc-06eba7ef2bf7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aaa03b2-4478-6dff-0bfc-06eba7ef2bf7@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 10:33:07AM +0100, Karsten Graul wrote:
> On 23/11/2021 07:56, Tony Lu wrote:
> > To solve this issue, we developed a set of patches to replace the
> > AF_INET / SOCK_STREAM with AF_SMC / SMCPROTO_SMC{6} by configuration.
> > So that we can control acceleration in kernel without any other changes
> > in user-space, and won't break our application containers and publish
> > workflow. These patches are still improving for upstream.
> 
> This sounds interesting. Will this also be namespace-based like the sysctls
> in the current patch? Will this future change integrate nicely with the current
> new sysctls? This might allow to activate smc for containers, selectively. 
> 
> Please send these changes in a patch series together when they are finished.
> We would like to review them as a whole to see how things play together.
> 
> Thank you!

Hi Graul,

I am glad to hear that. The container, which is isolated by
net-namespace, is the minimal deployment unit in our environment. The
transparent replacement facility is namespace-based, so that we can
control the applications behaviors according to the dimensions of
containers.

The per-netns sysctl is the first step, control the applications'
buffer, and not to disturb TCP connections in the same container. The
container's memory is not as large as that of a physical machine, and
containers might run different workload applications, so we use
per-netns sysctl to adjust buffer. And it can be sent out separately.

Then, we can allow to activate SMC for some containers with transparent
replacement. These patches are improving, make sure the flexible enough
for containers and applications scopes, and cohesion enough for
upstream.

I will send them out as the containers solutions. Thank for you advice.

Thanks,
Tony Lu
