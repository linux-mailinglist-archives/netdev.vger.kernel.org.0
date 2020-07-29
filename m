Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C173231D6D
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgG2Lfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:35:45 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56760 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2Lfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 07:35:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 550F220299;
        Wed, 29 Jul 2020 13:35:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s0yUh9rZhab1; Wed, 29 Jul 2020 13:35:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DEC56201E4;
        Wed, 29 Jul 2020 13:35:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 29 Jul 2020 13:35:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 29 Jul
 2020 13:35:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 140D83181096;
 Wed, 29 Jul 2020 13:35:42 +0200 (CEST)
Date:   Wed, 29 Jul 2020 13:35:42 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Xiumei Mu <xmu@redhat.com>
Subject: Re: [PATCH ipsec] xfrm: esp6: fix the location of the transport
 header with encapsulation
Message-ID: <20200729113541.GF27824@gauss3.secunet.de>
References: <2159be20972bd53beefeb0b8ad31adac2792105d.1595858511.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2159be20972bd53beefeb0b8ad31adac2792105d.1595858511.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 04:03:47PM +0200, Sabrina Dubroca wrote:
> commit 17175d1a27c6 ("xfrm: esp6: fix encapsulation header offset
> computation") changed esp6_input_done2 to correctly find the size of
> the IPv6 header that precedes the TCP/UDP encapsulation header, but
> didn't adjust the final call to skb_set_transport_header, which I
> assumed was correct in using skb_network_header_len.
> 
> Xiumei Mu reported that when we create xfrm states that include port
> numbers in the selector, traffic from the user sockets is dropped. It
> turns out that we get a state mismatch in __xfrm_policy_check, because
> we end up trying to compare the encapsulation header's ports with the
> selector that's based on user traffic ports.
> 
> Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
> Fixes: 26333c37fc28 ("xfrm: add IPv6 support for espintcp")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks a lot Sabrina!
