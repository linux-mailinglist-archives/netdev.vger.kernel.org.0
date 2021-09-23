Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E17415F4C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241178AbhIWNPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhIWNPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC9CE61164;
        Thu, 23 Sep 2021 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632402859;
        bh=BVr6kqYhkAduH6XsyaB12IVBO3ZIxCQHT8D5mV14SFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gwWMxlXc3IWHCT6JUfKu2MOEOiDenzbzTDnPYEzaBPA/lcZpo4pLpdRsg7D1TCZOj
         RFnd0Jc4dTr9vFzpWM4403QLUp7VzB3MD3F1xDDUbcaz2b3joL5Kyvt6BeZSaOpVNF
         OzrZ/c+s13zJtSJB1Bar3ri+xEaWucVng6j3nFe34u1H61ge+SGwCxV+cBjqAGB0ra
         XzDQswj0LR5HoA0J3weiX4GeNgkktCooRQNDgvSa+Sk9eiaH9Ja+sLbpEmiYs2psNQ
         uGEzplpx50cib4aZbw9QTZpHuhheFnBSy51sPWUxSsFcGOd4SZ554oZHhMijkI2WMd
         w7YstKdlAjr6w==
Date:   Thu, 23 Sep 2021 06:14:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Wei Wang <weiwan@google.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <20210923061417.049df44d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1632293267.9421082-1-xuanzhuo@linux.alibaba.com>
References: <20210920122024.283fe8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1632293267.9421082-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 14:47:47 +0800 Xuan Zhuo wrote:
> > Why don't you just invert the order of clearing the bits:  
> 
> I think it should be an atomic operation. The original two-step clear itself is
> problematic. So from this perspective, it is not just a solution to this
> problem.

[resending, my MUA seems to have corrupted the CC list previously]

Can you show what breaks by it being non-atomic?

Because, again, the disable part is not atomic. Either it's needed on
both sides or it's not needed on either.
