Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E23EF01E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhHQQWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229721AbhHQQWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8226024A;
        Tue, 17 Aug 2021 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629217318;
        bh=uvTnRPMf3m+BMa0dC84OgWxUTeCf5SBKHaey7ORbF60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RHXDYfrc0vYScIDGjw7tI64vXtnESwYGy/fivZuqu7yCMOZ5w/ivrzCbE9RZxdMND
         qvd8wiAGhAD6wrPpX7REEr7UFqwcx/cKxQJUV8Yj/1uD8uJeHkl347XKuR/iZJhlJu
         oLJspdr9vf7Apeie+M8FAfKUtmI3jizDzwqbc8T+guDd4sKFrY7K0WqTnADkqzfmw4
         tGQc1B1o9xuDhAXP5I8DmqsNMIEYyScbX6mrtLbYWks2iG+ehSBiy6Jng0t0SX0/03
         QNdGIDl6XYBnbO9g+Jz6jvWfZIsLqeYY49fs1NCdU4geOFU2KMKMdS/WsuCtVK+Rgj
         E+jmXLmFuPvQw==
Received: by pali.im (Postfix)
        id 747EA842; Tue, 17 Aug 2021 18:21:55 +0200 (CEST)
Date:   Tue, 17 Aug 2021 18:21:55 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210817162155.idyfy53qbxcsf2ga@pali>
References: <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
 <20210812134845.npj3m3vzkrmhx6uy@pali>
 <20210812182645.GA10725@pc-23.home>
 <20210812190440.fknfthdk3mazm6px@pali>
 <20210816161114.GA3611@pc-32.home>
 <20210816162355.7ssd53lrpclfvuiz@pali>
 <20210817160525.GA20616@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210817160525.GA20616@pc-32.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 17 August 2021 18:05:25 Guillaume Nault wrote:
> On Mon, Aug 16, 2021 at 06:23:55PM +0200, Pali Rohár wrote:
> > On Monday 16 August 2021 18:11:14 Guillaume Nault wrote:
> > > Do you have plans for adding netlink support to pppd? If so, is the
> > > project ready to accept such code?
> > 
> > Yes, I have already some WIP code and I'm planning to send a pull
> > request to pppd on github for it. I guess that it could be accepted,
> 
> I guess you can easily use the netlink api for cases where the "unit"
> option isn't specified and fall back to the ioctl api when it is. If
> all goes well, then we can extend the netlink api to accept a unit id.
> 
> But what about the lack of netlink feedback about the created
> interface? Are you restricted to use netlink only when the "ifname"
> option is provided?

Exactly, this is how I wrote my WIP code...

> > specially if there still would be backward compatibility via ioctl for
> > kernels which do not support rtnl API.
> 
> Indeed, I'd expect keeping compatiblitity with old kernels that only
> have the ioctl api to be a must (but I have no experience contributing
> to the pppd project).
> 
> > One of the argument which can be
> > used why rtnl API is better, is fixing issue: atomic creating of
> > interface with specific name.
> 
> Yes, that looks useful.
> 
