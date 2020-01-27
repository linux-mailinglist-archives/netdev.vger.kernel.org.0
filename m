Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF0214A156
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgA0J6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:58:13 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:58396 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbgA0J6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 04:58:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 13BD3201AA;
        Mon, 27 Jan 2020 10:58:11 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yu6aEt-5KMkB; Mon, 27 Jan 2020 10:58:10 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 70C262008D;
        Mon, 27 Jan 2020 10:58:10 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 27 Jan 2020
 10:58:10 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2512F31800D2;
 Mon, 27 Jan 2020 10:58:10 +0100 (CET)
Date:   Mon, 27 Jan 2020 10:58:10 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec v3 0/2] ipsec interfaces: fix sending with
 bpf_redirect() / AF_PACKET sockets
Message-ID: <20200127095810.GC27973@gauss3.secunet.de>
References: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
 <20200113083247.14650-1-nicolas.dichtel@6wind.com>
 <20200115095652.GR8621@gauss3.secunet.de>
 <35524394-8ba1-1868-4e85-ddfd9d829c6c@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35524394-8ba1-1868-4e85-ddfd9d829c6c@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 10:28:10AM +0100, Nicolas Dichtel wrote:
> Le 15/01/2020 à 10:56, Steffen Klassert a écrit :
> > On Mon, Jan 13, 2020 at 09:32:45AM +0100, Nicolas Dichtel wrote:
> >> Before those patches, packets sent to a vti[6]/xfrm interface via
> >> bpf_redirect() or via an AF_PACKET socket were dropped, mostly because
> >> no dst was attached.
> >>
> >> v2 -> v3:
> >>   - fix flowi info for the route lookup
> >>
> >> v1 -> v2:
> >>   - remove useless check against skb_dst() in xfrmi_xmit2()
> >>   - keep incrementing tx_carrier_errors in case of route lookup failure
> >>
> >>  net/ipv4/ip_vti.c         | 13 +++++++++++--
> >>  net/ipv6/ip6_vti.c        | 13 +++++++++++--
> >>  net/xfrm/xfrm_interface.c | 32 +++++++++++++++++++++++++-------
> >>  3 files changed, 47 insertions(+), 11 deletions(-)
> > 
> > Applied to the ipsec tree, thanks a lot!
> > 
> Thanks. Those patches are now in Linus tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=95224166a903
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f042365dbffe
> 
> Could you queue them for stable trees?

I'll do an ipsec stable submission the next days.
