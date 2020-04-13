Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD231A659F
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 13:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgDMLdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbgDMLZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 07:25:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D733A20732;
        Mon, 13 Apr 2020 11:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586777134;
        bh=28rP04l7BrPu7uLKpbtNd+EGfa/QFLZfAPq4HSjmE0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ns5IWQZGccQYaOdvkcVcBWVZwiKjkOIcR7YvuRztTiJkUrBo1j0/D2r/75WJlYdYJ
         KTDJNJrH3h5ifKO8f2uVqCtiD7LF0bZNvJ1V7X8SPStt9Tx5NtCA1YLyngHZrJfyoJ
         FhdjgYNlypD/gYrgukRTZThhdJESeExBQGjNa7Vk=
Date:   Mon, 13 Apr 2020 14:25:30 +0300
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
Message-ID: <20200413112530.GL334007@unreal>
References: <20200412060854.334895-1-leon@kernel.org>
 <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200413102053.GI334007@unreal>
 <BN8PR12MB32661B539382B14B4DCE3F95D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200413105408.GJ334007@unreal>
 <BN8PR12MB3266B788233057BB024B92B3D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266B788233057BB024B92B3D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 11:01:42AM +0000, Jose Abreu wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Apr/13/2020, 11:54:08 (UTC+00:00)
>
> > Sorry, if I misunderstood you, but you are proposing to count traffic, right?
> >
> > If yes, RDMA traffic bypasses the SW stack and not visible to the kernel, hence
> > the BQL will count only ETH portion of that mixed traffic, while RDMA traffic
> > is the one who "blocked" transmission channel (QP in RDMA terminology).
>
> Sorry but you don't mention in your commit message that this is RDMA
> specific so that's why I brought up the topic of BQL. Apologies for the
> misunderstood.

No problem, I'm glad that you asked those questions, hope that my
answers clear the rationale behind change from WARN_ON to be pr_err().

Thanks

>
> ---
> Thanks,
> Jose Miguel Abreu
