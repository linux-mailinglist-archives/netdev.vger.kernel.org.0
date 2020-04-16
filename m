Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260FA1AB48B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 02:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390979AbgDPAAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 20:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390966AbgDPAAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 20:00:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9B92076A;
        Thu, 16 Apr 2020 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586995210;
        bh=xpO78oMgj/uC8+HMF+oDbOkcOyitDZEw/D96sA2n8gQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z2XcvfF8pcCA/kkcz2YWaQmgNqpidz1/3oMA+7a7CIa3s39GjtM599gGc7OYFTFWT
         s25rpYEh3/osDMrV6FPe7wbN4iGqqaBuxule/NRKsSZRuVv22ne8s6UmGZXSc/c41y
         cvseByQMPydW/2M17OfRbzJAukNqS/kvTG2KzBUM=
Date:   Wed, 15 Apr 2020 20:00:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416000009.GL1068@sasha-vm>
References: <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 05:18:38PM +0100, Edward Cree wrote:
>Firstly, let me apologise: my previous email was too harsh and too
> assertiveabout things that were really more uncertain and unclear.
>
>On 14/04/2020 21:57, Sasha Levin wrote:
>> I've pointed out that almost 50% of commits tagged for stable do not
>> have a fixes tag, and yet they are fixes. You really deduce things based
>> on coin flip probability?
>Yes, but far less than 50% of commits *not* tagged for stable have a fixes
> tag.  It's not about hard-and-fast Aristotelian "deductions", like "this
> doesn't have Fixes:, therefore it is not a stable candidate", it's about
> probabilistic "induction".
>
>> "it does increase the amount of countervailing evidence needed to
>> conclude a commit is a fix" - Please explain this argument given the
>> above.
>Are you familiar with Bayesian statistics?  If not, I'd suggest reading
> something like http://yudkowsky.net/rational/bayes/ which explains it.
>There's a big difference between a coin flip and a _correlated_ coin flip.

I'd maybe point out that the selection process is based on a neural
network which knows about the existence of a Fixes tag in a commit.

It does exactly what you're describing, but also taking a bunch more
factors into it's desicion process ("panic"? "oops"? "overflow"? etc).

>> This is great, but the kernel is more than just net/. Note that I also
>> do not look at net/ itself, but rather drivers/net/ as those end up with
>> a bunch of missed fixes.
>drivers/net/ goes through the same DaveM net/net-next trees, with the
> same rules.

Let me put my Microsoft employee hat on here. We have driver/net/hyperv/
which definitely wasn't getting all the fixes it should have been
getting without AUTOSEL.

While net/ is doing great, drivers/net/ is not. If it's indeed following
the same rules then we need to talk about how we get done right.

I really have no objection to not looking in drivers/net/, it's just
that the experience I had with the process suggests that it's not
following the same process as net/.

-- 
Thanks,
Sasha
