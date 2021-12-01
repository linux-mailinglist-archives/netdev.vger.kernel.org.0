Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D65464470
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345982AbhLABOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:14:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbhLABO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 20:14:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBE07B81BBC;
        Wed,  1 Dec 2021 01:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF48C53FC7;
        Wed,  1 Dec 2021 01:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638321066;
        bh=ibYEhdQ6qCb6NIp86asXF/EY13plUiUKGpSjmmIhbHo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dblL7bnu7vujLOp1KvLALeTX6p3V/4T3ReMT7ZpOj77Pi40eCve4tM6hCdZq6Yhw3
         ti1H/CyR83EY9NR+ctrYnsDcGPhjsQqfcd2IJdLbSlhf3B7qHbSpSuqsBg9aBuhFF/
         b2AljWkgqr1yMsfO3Jnq2KDLLtdw1kx1XMGgQKwv9gyiPXDj2lQxSTM6Jh+wQLSeYU
         DBUHxpy9J6krZ/mhsTbvWU0xvtuMO8IGtkDFuDnf0NVlT/CWbYgllw4UZrTQZsXN8U
         JG70+KJp8HAjblXwRqN0l4gmPj8ntrdkFLg9+wYL/zBakPe+aXwuv4xNJ2jVgPwOuX
         N1VLOV5pAs7rA==
Date:   Tue, 30 Nov 2021 17:11:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 01/15] skbuff: introduce skb_pull_data
Message-ID: <20211130171105.64d6cf36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201000215.1134831-2-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
        <20211201000215.1134831-2-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 16:02:01 -0800 Luiz Augusto von Dentz wrote:
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> 
> Like skb_pull but returns the original data pointer before pulling the
> data after performing a check against sbk->len.
> 
> This allows to change code that does "struct foo *p = (void *)skb->data;"
> which is hard to audit and error prone, to:
> 
>         p = skb_pull_data(skb, sizeof(*p));
>         if (!p)
>                 return;
> 
> Which is both safer and cleaner.

It doesn't take a data pointer, so not really analogous to
skb_put_data() and friends which come to mind. But I have 
no better naming suggestions. You will need to respin, tho,
if you want us to apply these directly, the patches as posted 
don't apply to either netdev tree.
