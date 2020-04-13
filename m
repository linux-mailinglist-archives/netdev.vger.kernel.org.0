Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E923E1A656A
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 12:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgDMKyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 06:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgDMKyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 06:54:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF1420692;
        Mon, 13 Apr 2020 10:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586775252;
        bh=0bRjkpN572GAmwCZaUD02OC+FW1GvlcVKNrb990oFDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CF4T0rl21Dat2Lpxt7sCr0xrnCH9ncHb8u7tSQNwu28tNu0Og+ADkbDGQGIV3eg88
         Y8StAT/75hmxLeRYep7Pq4fGyMxzpRloMs/+uu3wD2OXS7vAlEjbw9pdoeciCv6MWw
         TZ55ZzwRarsPjddJtKQ4EuNKAoKr1M4i6CaXr31s=
Date:   Mon, 13 Apr 2020 13:54:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200413105408.GJ334007@unreal>
References: <20200412060854.334895-1-leon@kernel.org>
 <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200413102053.GI334007@unreal>
 <BN8PR12MB32661B539382B14B4DCE3F95D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32661B539382B14B4DCE3F95D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 10:37:24AM +0000, Jose Abreu wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Apr/13/2020, 11:20:53 (UTC+00:00)
>
> > On Mon, Apr 13, 2020 at 09:01:32AM +0000, Jose Abreu wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Date: Apr/12/2020, 07:08:54 (UTC+00:00)
> > >
> > > > [  281.170584] ------------[ cut here ]------------
> > >
> > > Not objecting to the patch it-self (because usually stack trace is
> > > useless), but just FYI we use this marker in our CI to track for timeouts
> > > or crashes. I'm not sure if anyone else is using it.
> >
> > I didn't delete the "NETDEV WATCHDOG .." message and it will be still
> > visible as a marker.
> >
> > >
> > > And actually, can you please explain why BQL is not suppressing your
> > > timeouts ?
> >
> > Driver can't distinguish between "real" timeout and "mixed traffic" timeout,
>
> The point is that you should not get any "mixed traffic" timeout if the
> driver uses BQL because Queue will be disabled long before timeout happens
> as per queue size usage ...

Sorry, if I misunderstood you, but you are proposing to count traffic, right?

If yes, RDMA traffic bypasses the SW stack and not visible to the kernel, hence
the BQL will count only ETH portion of that mixed traffic, while RDMA traffic
is the one who "blocked" transmission channel (QP in RDMA terminology).

Thanks

>
> ---
> Thanks,
> Jose Miguel Abreu
