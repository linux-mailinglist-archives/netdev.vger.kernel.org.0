Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8B6179807
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgCDSgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:36:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:46512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729675AbgCDSgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:36:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5FE6CAC79;
        Wed,  4 Mar 2020 18:36:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 078D3E037F; Wed,  4 Mar 2020 19:36:44 +0100 (CET)
Date:   Wed, 4 Mar 2020 19:36:44 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304183643.GK4264@unicorn.suse.cz>
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-2-kuba@kernel.org>
 <20200304075926.GH4264@unicorn.suse.cz>
 <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 10:00:50AM -0800, Jakub Kicinski wrote:
> On Wed, 4 Mar 2020 08:59:26 +0100 Michal Kubecek wrote:
> > Just an idea: perhaps we could use the fact that struct ethtool_coalesce
> > is de facto an array so that this block could be replaced by a loop like
> > 
> > 	u32 supported_types = dev->ethtool_ops->coalesce_types;
> > 	const u32 *values = &coalesce->rx_coalesce_usecs;
> > 
> > 	for (i = 0; i < __ETHTOOL_COALESCE_COUNT; i++)
> > 		if (values[i] && !(supported_types & BIT(i)))
> > 			return false;
> > 
> > and to be sure, BUILD_BUG_ON() or static_assert() check that the offset
> > of ->rate_sample_interval matches ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL.
> 
> I kind of prefer the greppability over the saved 40 lines :(
> But I'm happy to change if we get more votes for the more concise
> version. Or perhaps the Intel version with the warnings printed.

No problem, it was just an idea, I can see that each approach has its
advantages.

Michal
