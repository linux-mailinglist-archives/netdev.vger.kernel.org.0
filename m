Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60C2CF6AA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgLDWSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLDWSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:18:14 -0500
Date:   Fri, 4 Dec 2020 14:17:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607120254;
        bh=npLMxHcpEYQyvrwoDxGhmwr6Zw8n/fCkGcnf2Yes66g=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=E0wZLJNg8o9hl+YP2xWWOGEYH+dXakQjldVMSRpIrlKsEGdr6UL+v/HXgxK2edAvh
         6VM9a5Sn0B81EJ1RF7QXLwbEKpTb0jCV7ad7c9bRxBQIX7WFB87WSlooddH+BSLbRP
         EjieKzFHcfONb/uuo7/VT16nhCqAEMsdASC6019T0653X5DCNYYLe+jqpVZVN0ow0S
         DPbQb/nDgY6DvwkdEGORFQW4BWfz0D6ai3ZxA5khp560WrP/xLNyD1fjijNgNH6LYS
         Mbgmu2DkzXE0+HDt/u7RvjO7NocqD2o+TPGtNd7beRuqk0/jG5UYNLqwhtT33QJGKp
         EPCkYgsHR/1ZQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>
Subject: Re: [PATCH net] net/sched: fq_pie: initialize timer earlier in
 fq_pie_init()
Message-ID: <20201204141732.6bd0bdca@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAM_iQpWf4CS_fR69JQfa2pEV9Yd26p=neZ+nu_1rOLvbbn=TiA@mail.gmail.com>
References: <2e78e01c504c633ebdff18d041833cf2e079a3a4.1607020450.git.dcaratti@redhat.com>
        <CAM_iQpWf4CS_fR69JQfa2pEV9Yd26p=neZ+nu_1rOLvbbn=TiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 10:35:07 -0800 Cong Wang wrote:
> On Thu, Dec 3, 2020 at 10:41 AM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> > with the following tdc testcase:
> >
> >  83be: (qdisc, fq_pie) Create FQ-PIE with invalid number of flows
> >
> > as fq_pie_init() fails, fq_pie_destroy() is called to clean up. Since the
> > timer is not yet initialized, it's possible to observe a splat like this:  
> ...
> > fix it moving timer_setup() before any failure, like it was done on 'red'
> > with former commit 608b4adab178 ("net_sched: initialize timer earlier in
> > red_init()").
> >
> > Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>  
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Applied, thanks!
