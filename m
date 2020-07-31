Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EAE233FA7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgGaHCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:02:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49280 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731375AbgGaHCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:02:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D3B5D20501;
        Fri, 31 Jul 2020 09:02:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FAyETA3zn7ah; Fri, 31 Jul 2020 09:02:06 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 544D620571;
        Fri, 31 Jul 2020 09:02:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:02:06 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:02:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 930F73180676;
 Fri, 31 Jul 2020 09:02:04 +0200 (CEST)
Date:   Fri, 31 Jul 2020 09:02:04 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <cagney@libreswan.org>
Subject: Re: [PATCH ipsec 1/2] espintcp: handle short messages instead of
 breaking the encap socket
Message-ID: <20200731070204.GE20687@gauss3.secunet.de>
References: <7be76ce1ce1e38643484d72d3329ed9d7aa62b94.1596038944.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7be76ce1ce1e38643484d72d3329ed9d7aa62b94.1596038944.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 06:38:42PM +0200, Sabrina Dubroca wrote:
> Currently, short messages (less than 4 bytes after the length header)
> will break the stream of messages. This is unnecessary, since we can
> still parse messages even if they're too short to contain any usable
> data. This is also bogus, as keepalive messages (a single 0xff byte),
> though not needed with TCP encapsulation, should be allowed.
> 
> This patch changes the stream parser so that short messages are
> accepted and dropped in the kernel. Messages that contain a valid SPI
> or non-ESP header are processed as before.
> 
> Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> Reported-by: Andrew Cagney <cagney@libreswan.org>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks!
