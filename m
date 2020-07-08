Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD0A21820D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 10:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgGHIOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 04:14:36 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33718 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgGHIOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 04:14:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7CA31200AC;
        Wed,  8 Jul 2020 10:14:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0Pdwzdzl2xex; Wed,  8 Jul 2020 10:14:33 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 334522058E;
        Wed,  8 Jul 2020 10:14:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 8 Jul 2020 10:14:32 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 8 Jul 2020
 10:14:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 905D53180236;
 Wed,  8 Jul 2020 10:14:31 +0200 (CEST)
Date:   Wed, 8 Jul 2020 10:14:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH ipsec] xfrm: esp6: fix encapsulation header offset
 computation
Message-ID: <20200708081431.GZ19286@gauss3.secunet.de>
References: <37e23af3698e92fd095c401937ed0cacf5f2e455.1593785611.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <37e23af3698e92fd095c401937ed0cacf5f2e455.1593785611.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 04:57:09PM +0200, Sabrina Dubroca wrote:
> In commit 0146dca70b87, I incorrectly adapted the code that computes
> the location of the UDP or TCP encapsulation header from IPv4 to
> IPv6. In esp6_input_done2, skb->transport_header points to the ESP
> header, so by adding skb_network_header_len, uh and th will point to
> the ESP header, not the encapsulation header that's in front of it.
> 
> Since the TCP header's size can change with options, we have to start
> from the IPv6 header and walk past possible extensions.
> 
> Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
> Fixes: 26333c37fc28 ("xfrm: add IPv6 support for espintcp")
> Reported-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks Sabrina!
