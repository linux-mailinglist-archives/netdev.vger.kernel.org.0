Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9182174064
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgB1TlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB1Tk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 14:40:59 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE852072A;
        Fri, 28 Feb 2020 19:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582918859;
        bh=otP5wMssbtbJ1SBWr9iRXUUxW65YKSBhSR5JoAWSb5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T9gcakM+7ZJpoU9qdx121pLHeiFvFej+3cyuEbT2Bbo14yyCRD+YhllpfR++68K5+
         LTr0ymC4azJM6gZ98pypzr7ftQZ6K5lu+5nSpxoU+5HIuqFCew5irTLZQgyicak/O1
         aaBvoB1BBsg5/Mcyg2dC8aD0xWCoVK7T3Ajac8jY=
Date:   Fri, 28 Feb 2020 11:40:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 03/12] flow_offload: check for basic action
 hw stats type
Message-ID: <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228172505.14386-4-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 18:24:56 +0100 Jiri Pirko wrote:
> @@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
>  		return -EINVAL;
>  	}
>  
> +	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
> +		return -EOPNOTSUPP;

Could we have this helper take one stat type? To let drivers pass the
stat type they support? 

At some point we should come up with a way to express the limitations
at callback registration time so we don't need to add checks like this
to all the drivers. On the TODO list it goes :)

>  	flow_action_for_each(i, act, flow_action) {
>  		switch (act->id) {
>  		case FLOW_ACTION_DROP:

