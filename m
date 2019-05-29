Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B85E2E4C5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfE2Ssk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfE2Ssj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:48:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A40240AC;
        Wed, 29 May 2019 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559155719;
        bh=AHC2B0Mx8E7VfpBekFB21lf/IxFld+6/D+1fIfurU3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yznERW92LTkHlXto/cGkoOxVVDbFeYyNCibZEPWZR0KU5KLEdtjuI8zOq4MiNJ6mw
         XzKg+NPMNQt4lF0I+v+YfsJg/mTMn2eZOHkA7T17DnMWt09ptRsdB6cMBC8a4N3FdT
         k48i4ZMPppiLRFatkZ1tTDisb1Kv2vEmKMSbS+3s=
Date:   Wed, 29 May 2019 14:48:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stefan Bader <stefan.bader@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 011/375] ip6: fix skb leak in
 ip6frag_expire_frag_queue()
Message-ID: <20190529184837.GF12898@sasha-vm>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-11-sashal@kernel.org>
 <1036ddff-720f-ad5b-dbc0-2d4ad4de0392@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1036ddff-720f-ad5b-dbc0-2d4ad4de0392@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 09:47:23AM +0200, Stefan Bader wrote:
>On 22.05.19 21:15, Sasha Levin wrote:
>> From: Eric Dumazet <edumazet@google.com>
>>
>> [ Upstream commit 47d3d7fdb10a21c223036b58bd70ffdc24a472c4 ]
>>
>> Since ip6frag_expire_frag_queue() now pulls the head skb
>> from frag queue, we should no longer use skb_get(), since
>> this leads to an skb leak.
>>
>> Stefan Bader initially reported a problem in 4.4.stable [1] caused
>> by the skb_get(), so this patch should also fix this issue.
>
>Just to let everybody know, while changing this has fixed the BUG_ON problem
>while sending (in 4.4) it now crashes when releasing just a little later.
>Still feels like the right direction but not complete, yet.

mhm, this commit is really under David's domain, it squeezed through my
filters as it doesn't actually touch net/. I'll drop it for now.

--
Thanks,
Sasha
