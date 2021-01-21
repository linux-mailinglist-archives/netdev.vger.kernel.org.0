Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44172FE15D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbhAUFCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbhAUFA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:00:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 169AF2396F;
        Thu, 21 Jan 2021 04:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611205155;
        bh=WLURNc/ARPVwxvKMO/4EToViSWS6r6Z3ONvX9RicN10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rwnQz64KxEKHVwpx0spDQlD3futFxDMtUoA2f+Q5nAyH8dDtU9hv405Xz9sBdQfmq
         nG4vLc6LoVnHrGJvv1ttwwnRJ9jWMuZOWqGHVBdB8Mb1uYc5zW3sicYaqpIPJXZYlf
         KPuN1gDpglsc6tW9kH+FCjY2ILk+uHxoAPKBxzAyeLwjnmrvgkdYPP/1FfxQ8Yy75s
         BYNYJXoQvyhmSX0NRokTko7E6ljzAKRKuXF59VE/2o+KfZCQRMNNlKgwTBEVgFwo7G
         h8lu36d9SAXlwywt5QWqPgLoV8jWFVDNBxUwdBKNw6v9CJRA9uWP3EqEDaG/LeIM1w
         IpwG7/fpymSQA==
Date:   Wed, 20 Jan 2021 20:59:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     sundeep.lkml@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] Revert "octeontx2-pf: Use the napi_alloc_frag() to
 alloc the pool buffers"
Message-ID: <20210120205914.4d382e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121042035.GA442272@pek-khao-d2.corp.ad.wrs.com>
References: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
        <20210121042035.GA442272@pek-khao-d2.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 12:20:35 +0800 Kevin Hao wrote:
> Hmm, why not?
>   buf = napi_alloc_frag(pool->rbsize + 128);
>   buf = PTR_ALIGN(buf, 128);

I'd keep the aligning in the driver until there are more users
needing this but yes, I agree, aligning the page frag buffers 
seems like a much better fix.
