Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CF1A6A09
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 18:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgDMQjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 12:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731652AbgDMQjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 12:39:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 949BE206DA;
        Mon, 13 Apr 2020 16:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586795941;
        bh=OoRhd3H2mZNy2v3zODygeRhXiEbly9vr7r5aIwvM+HE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zk8qzDU1IQ+8S+QvQhWMs74W6bhVLWxEUeR2CNxxy+o5BAY9TXg6p7nbw1gPyZ+6w
         xoplIxSndGoIZJbpZjc90Es57ebeXpWD0L8VDMsPAa7zEO/X+0e/5QidCGEyD//joL
         WnWqsUhYh3hhMglsrc/jxpa9jrkJpEkI9WBNZfpI=
Date:   Mon, 13 Apr 2020 12:39:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set
 back-ends to report partial overlaps on insertion
Message-ID: <20200413163900.GO27528@sasha-vm>
References: <20200407000058.16423-1-sashal@kernel.org>
 <20200407000058.16423-27-sashal@kernel.org>
 <20200407021848.626df832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200407021848.626df832@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 02:18:48AM +0200, Stefano Brivio wrote:
>Hi Sasha,
>
>On Mon,  6 Apr 2020 20:00:49 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>>
>> [ Upstream commit 8c2d45b2b65ca1f215244be1c600236e83f9815f ]
>
>This patch, together with 28/35 and 29/35 in this series, and all the
>equivalent patches for 5.4 and 4.19, that is:
>	[PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
>	[PATCH AUTOSEL 5.5 28/35] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
>	[PATCH AUTOSEL 5.5 29/35] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
>	[PATCH AUTOSEL 5.4 24/32] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
>	[PATCH AUTOSEL 5.4 25/32] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
>	[PATCH AUTOSEL 5.4 26/32] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
>	[PATCH AUTOSEL 4.19 08/13] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
>	[PATCH AUTOSEL 4.19 09/13] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
>	[PATCH AUTOSEL 4.19 10/13] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
>
>should only be backported together with nf.git commit
>	72239f2795fa ("netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion")
>
>as they would otherwise introduce a regression. In general, those changes
>are not really relevant before 5.6, as nft_set_pipapo wasn't there and the
>main purpose here is to make the nft_set_rbtree back-end consistent with it:
>they also prevent a malfunction in nft_set_rbtree itself, but nothing that
>would be triggered using 'nft' alone, and no memory badnesses or critical
>issues whatsoever. So it's also safe to drop them, in my opinion.
>
>Also patches for 4.14 and 4.9:
>	[PATCH AUTOSEL 4.14 6/9] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
>	[PATCH AUTOSEL 4.9 3/5] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
>
>can safely be dropped, because there are no set back-ends there, without
>the following patches, that use this way of reporting a partial overlap.

I've just dropped them all as 72239f2795fa ("netfilter: nft_set_rbtree:
Drop spurious condition for overlap detection on insertion") didn't make
it into Linus's tree yet.

>I'm used to not Cc: stable on networking patches (Dave's net.git),
>but I guess I should instead if they go through nf.git (Pablo's tree),
>right?

Yup, this confusion has caused for quite a few netfilter fixes to not
land in -stable. If it goes through Pablo's tree (and unless he intructs
otherwise), you should Cc stable.

-- 
Thanks,
Sasha
