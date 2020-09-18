Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255B127014E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIRPs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgIRPs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 11:48:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539EE23787;
        Fri, 18 Sep 2020 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600444108;
        bh=vYHqxiSsNlcgpf57V7vynnjHK9hYf9Ia0a2q5adA60w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pc5BkkclvMuMnaC1HvXJLj5O3/MGKRSCpQasvTRJvxA3KwhXCAArIr+Cf6+S7Y8AL
         EndNsqL+wZ2uolR8+HQpX7P9DiMaKUmtivKdammN1nX/VvJ+L9z3ZHHnjOD0Z2t8ai
         V0HgciAfSaOSAX1Ls1H1J9y9qyAdzAetCEe0kGpQ=
Date:   Fri, 18 Sep 2020 08:48:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: promote missed packets to the -s row
Message-ID: <20200918084826.14d2cea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0371023e-f46f-5dfd-6268-e11a18deeb06@gmail.com>
References: <20200916194249.505389-1-kuba@kernel.org>
        <0371023e-f46f-5dfd-6268-e11a18deeb06@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 09:44:35 -0600 David Ahern wrote:
> On 9/16/20 1:42 PM, Jakub Kicinski wrote:
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
> >     RX: bytes  packets  errors  dropped overrun mcast
> >     6.04T      4.67G    0       0       0       67.7M
> >     RX errors: length   crc     frame   fifo    missed
> >                0        0       0       0       7
> >     TX: bytes  packets  errors  dropped carrier collsns
> >     3.13T      2.76G    0       0       0       0
> >     TX errors: aborted  fifo   window heartbeat transns
> >                0        0       0       0       6
> > 
> > After:
> > 
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
> >     RX: bytes  packets  errors  dropped missed  mcast
> >     6.04T      4.67G    0       0       7       67.7M
> >     RX errors: length   crc     frame   fifo    overrun
> >                0        0       0       0       0
> >     TX: bytes  packets  errors  dropped carrier collsns
> >     3.13T      2.76G    0       0       0       0
> >     TX errors: aborted  fifo   window heartbeat transns
> >                0        0       0       0       6  
> 
> changes to ip output are usually not allowed.

Does that mean "no" or "you need to be more convincing"? :)

JSON output is not changed. I don't think we care about screen
scrapers. If we cared about people how interpret values based 
on their position in the output we would break that with every
release, no?

