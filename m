Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345412BC779
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 18:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgKVRYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 12:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbgKVRYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 12:24:15 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B352075A;
        Sun, 22 Nov 2020 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606065854;
        bh=Elh3R1YSSvrCOACWDQxGvtTzosAavyGIFoVducOAnUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z4kkeaD0QENS2NPkiKXOmOObDqpsWs8qko7XdkqmPMkpX1V3WFHZUw3RTFkS5zl0v
         0f/iBwV5IuYtUxkQoMu6JfTwOUEDSnREJNc52u/9gt6+IwCqBPOwNVkEDQg8gjf37H
         DKB3bB8pGGDdH1VVc9FgQi2D795HIjGwGlVHcF1s=
Date:   Sun, 22 Nov 2020 12:24:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>, liuzx@knownsec.com,
        Edward Cree <ecree@solarflare.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Patch stable] netfilter: clear skb->next in NF_HOOK_LIST()
Message-ID: <20201122172413.GG643756@sasha-vm>
References: <20201121034317.577081-1-xiyou.wangcong@gmail.com>
 <20201121222249.GU15137@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201121222249.GU15137@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 11:22:49PM +0100, Florian Westphal wrote:
>Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> From: Cong Wang <cong.wang@bytedance.com>
>>
>> NF_HOOK_LIST() uses list_del() to remove skb from the linked list,
>> however, it is not sufficient as skb->next still points to other
>> skb. We should just call skb_list_del_init() to clear skb->next,
>> like the rest places which using skb list.
>>
>> This has been fixed in upstream by commit ca58fbe06c54
>> ("netfilter: add and use nf_hook_slow_list()").
>
>Thanks Cong, agree with this change, afaics its applicable to 4.19.y and 5.4.y.

Queued for 5.4 and 4.19, thanks!

-- 
Thanks,
Sasha
