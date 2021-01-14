Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB82F6676
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbhANQxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbhANQxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 11:53:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2EE123B44;
        Thu, 14 Jan 2021 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610643189;
        bh=NKV799qssd6mtI8W4HAEuxXm9BpsHzwmqRsFQiCrK+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IXQYsdnici57kxCBNe61TsHUr3kj6NtUPTN4lot5Ur/SqmVxehSXy6I7Rww/3htd5
         kk1XhfOQUhplRN22vV/G0GnUZ8U7cpkEw66fPHP4IkUodPC538kHLPoPNdAV2eC+aJ
         XiiVhYhp06Mb6N9paw2m6ZKe+eCH5qsYv03D2mNSuGfbs3tcsgqM63DqXWv+whNVIV
         7LVSX4BuFow6WfPyflN3E4hZCu2Zcy8qw+77E6EzFwTR/y/NMLo//TGUacJ168wZW6
         n7Jf7H9xKNa0tt5B64Jkud0vEXUjn8/MJPsmsD+XfL49QQddcRgoA1ePmUWbvztdp0
         nM9gbbfAxj+YA==
Date:   Thu, 14 Jan 2021 08:53:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     edumazet@google.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] tcp: fix TCP_SKB_CB(skb)->tcp_tw_isn not being used
Message-ID: <20210114085308.7cda4d92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609192760-4505-1-git-send-email-yangpc@wangsu.com>
References: <1609192760-4505-1-git-send-email-yangpc@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Dec 2020 05:59:20 +0800 Pengcheng Yang wrote:
> TCP_SKB_CB(skb)->tcp_tw_isn contains an ISN, chosen by
> tcp_timewait_state_process() , when SYN is received in TIMEWAIT state.
> But tcp_tw_isn is not used because it is overwritten by
> tcp_v4_restore_cb() after commit eeea10b83a13 ("tcp: add
> tcp_v4_fill_cb()/tcp_v4_restore_cb()").
> 
> To fix this case, we record tcp_tw_isn before tcp_v4_restore_cb() and
> then set it in tcp_v4_fill_cb(). V6 does the same.
> 
> Fixes: eeea10b83a13 ("tcp: add tcp_v4_fill_cb()/tcp_v4_restore_cb()")
> Reported-by: chenc <chenc9@wangsu.com>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>

Please fix the date and resend. This patch came in last night, 
but it has a date of December 28th.
