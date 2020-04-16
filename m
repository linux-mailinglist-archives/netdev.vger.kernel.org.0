Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7771AD09D
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgDPTxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727886AbgDPTxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 15:53:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1B6221F9;
        Thu, 16 Apr 2020 19:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587066811;
        bh=ULzS1r3V0P8vl28OgQGS1tlJzBJze1nWE+ovPyIR5Ec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FNC+ZjgVOtkTtlepjvFjH8VqMfIJZetUfPNsgu6Pwf1iHvMjUWANUu/gIHFIOPVaJ
         85ucAtnkE+3/1L8q6QrL1zwg3QQACTx3ID2jtDNcwUXj5mKpkhuzXjlsQOWMpz0WqY
         gtcJR4X63h93XxvhNc0ie1zAImV69E9jamP+XmHQ=
Date:   Thu, 16 Apr 2020 15:53:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416195329.GO1068@sasha-vm>
References: <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
 <20200416172001.GC1388618@kroah.com>
 <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 07:31:25PM +0000, Saeed Mahameed wrote:
>On Thu, 2020-04-16 at 19:20 +0200, Greg KH wrote:
>> So far the AUTOSEL tool has found so many real bugfixes that it isn't
>> funny.  If you don't like it, fine, but it has proven itself _way_
>> beyond my wildest hopes already, and it just keeps getting better.
>>
>
>Now i really don't know what the right balance here, in on one hand,
>autosel is doing a great job, on the other hand we know it can screw up
>in some cases, and we know it will.
>
>So we decided to make sacrifices for the greater good ? :)

autosel is going to screw up, I'm going to screw up, you're going to
screw up, and Linus is going screw up. The existence of the stable trees
and a "Fixes:" tag is an admission we all screw up, right?

If you're willing to accept that we all make mistakes, you should also
accept that we're making mistakes everywhere: we write buggy code, we
fail at reviews, we forget tags, and we suck at backporting patches.

If we agree so far, then why do you assume that the same people who do
the above also perfectly tag their commits, and do perfect selection of
patches for stable? "I'm always right except when I'm wrong".

My view of the the path forward with stable trees is that we have to
beef up our validation and testing story to be able to catch these
issues better, rather than place arbitrary limitations on parts of the
process. To me your suggestions around the Fixes: tag sound like "Never
use kmalloc() because people often forget to free memory!" will it
prevent memory leaks? sure, but it'll also prevent useful patches from
coming it...

Here's my suggestion: give us a test rig we can run our stable release
candidates through. Something that simulates "real" load that customers
are using. We promise that we won't release a stable kernel if your
tests are failing.

-- 
Thanks,
Sasha
