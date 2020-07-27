Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98522E8F7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgG0J2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:28:22 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:42786 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0J2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:28:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 93B2420573;
        Mon, 27 Jul 2020 11:28:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gOl_xBCQ1ykm; Mon, 27 Jul 2020 11:28:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 33EC320501;
        Mon, 27 Jul 2020 11:28:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 27 Jul 2020 11:28:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 27 Jul
 2020 11:28:19 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 83D923184651;
 Mon, 27 Jul 2020 11:28:19 +0200 (CEST)
Date:   Mon, 27 Jul 2020 11:28:19 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Paul Wouters <paul@nohats.ca>,
        Andrew Cagney <andrew.cagney@gmail.com>,
        Tobias Brunner <tobias@strongswan.org>
Subject: Re: [RFC PATCH ipsec] xfrm: don't pass too short packets to
 userspace with ESPINUDP encap
Message-ID: <20200727092819.GY20687@gauss3.secunet.de>
References: <18a669995a73fefd70e179e6bc11b74e397e56ad.1595594449.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <18a669995a73fefd70e179e6bc11b74e397e56ad.1595594449.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 04:46:07PM +0200, Sabrina Dubroca wrote:
> Currently, any UDP-encapsulated packet of 8 bytes or less will be
> passed to userspace, whether it starts with the non-ESP prefix or
> not (except keepalives). This includes:
>  - messages of 1, 2, 3 bytes
>  - messages of 4 to 8 bytes not starting with 00 00 00 00
> 
> This patch changes that behavior, so that only properly-formed non-ESP
> messages are passed to userspace. Messages of 8 bytes or less that
> don't contain a full non-ESP prefix followed by some data (at least
> one byte) will be dropped and counted as XfrmInHdrError.

I'm ok with that change. But it affects userspace, so the *swan
people have to tell if that's ok for them.
