Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BAB10901E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 15:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfKYOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 09:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbfKYOfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 09:35:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D085120740;
        Mon, 25 Nov 2019 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574692520;
        bh=5ls0Y5M93Vgvnl4gV57OFRw4tiAJA6Xp1o4BD351SpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2vV7cAaRHNJk4XbDjn3VexHXvThLpmaayWqZ9C4dvwmf2Pf7FUu/WUAEL6q6zNL23
         /b278eNHja7j9nmOZo4z6aJDEIkfQfrxwavl6npVd18fdhLzUliBRN5KVQBoF9g1i5
         PJAAshqw6GqRcfLO1Yx1eV8c/l697GJllEO2jU8I=
Date:   Mon, 25 Nov 2019 09:35:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 89/99] vrf: mark skb for multicast or
 link-local as enslaved to VRF
Message-ID: <20191125143518.GF5861@sasha-vm>
References: <20191116155103.10971-1-sashal@kernel.org>
 <20191116155103.10971-89-sashal@kernel.org>
 <a6c038cb-4b95-beb0-abf3-8938825d379e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a6c038cb-4b95-beb0-abf3-8938825d379e@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 09:44:38AM -0700, David Ahern wrote:
>On 11/16/19 8:50 AM, Sasha Levin wrote:
>> From: Mike Manning <mmanning@vyatta.att-mail.com>
>>
>> [ Upstream commit 6f12fa775530195a501fb090d092c637f32d0cc5 ]
>>
>> The skb for packets that are multicast or to a link-local address are
>> not marked as being enslaved to a VRF, if they are received on a socket
>> bound to the VRF. This is needed for ND and it is preferable for the
>> kernel not to have to deal with the additional use-cases if ll or mcast
>> packets are handled as enslaved. However, this does not allow service
>> instances listening on unbound and bound to VRF sockets to distinguish
>> the VRF used, if packets are sent as multicast or to a link-local
>> address. The fix is for the VRF driver to also mark these skb as being
>> enslaved to the VRF.
>>
>> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
>> Reviewed-by: David Ahern <dsahern@gmail.com>
>> Tested-by: David Ahern <dsahern@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/net/vrf.c | 19 +++++++++----------
>>  1 file changed, 9 insertions(+), 10 deletions(-)
>>
>
>backporting this patch and it's bug fix, "ipv6: Fix handling of LLA with
>VRF and sockets bound to VRF" to 4.14 is a bit questionable. They
>definitely do not need to come back to 4.9.

I'll drop it, thanks.

-- 
Thanks,
Sasha
