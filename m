Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D921D17834A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgCCToh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgCCToh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 14:44:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F4720870;
        Tue,  3 Mar 2020 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583264676;
        bh=8J0f3l8y+HS/622MWk4eZPYr7OpxDZ7Q4+Hypr7LJuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDmyNZxMvkTqnkgEE3kh8wIk34pfT2chYwBpKX7tDF85G92ogxsN+uHhAAI5aDwQk
         vxcAELdiAVjJdbLp81Nv3K4sGy3EGS+oWBhxuBVEixQ66aG1fhpQVNeNKU+TTyOupr
         wn0F+2vI+OByUxsnJTrk3CYXEH3vDB537uIORo5g=
Date:   Tue, 3 Mar 2020 11:44:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify
 type of HW stats for a filter
Message-ID: <20200303114434.584612bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228172505.14386-13-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-13-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 18:25:05 +0100 Jiri Pirko wrote:
>  static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
>  static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
>  	[TCA_ACT_KIND]		= { .type = NLA_STRING },
>  	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
>  	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
>  				    .len = TC_COOKIE_MAX_SIZE },
> +	[TCA_ACT_HW_STATS_TYPE]	= { .type = NLA_U8 },
>  	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
>  	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
>  				    .validation_data = &tca_act_flags_allowed },

Ah, we will probably also want to set the strict checking up for new
attrs here.
