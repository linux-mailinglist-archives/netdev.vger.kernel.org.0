Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A641B5A5BC9
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 08:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiH3G1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 02:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiH3G1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 02:27:23 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45775C96E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 23:27:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 691CA20561;
        Tue, 30 Aug 2022 08:27:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SOOHuiywBH9C; Tue, 30 Aug 2022 08:27:14 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DBE632052D;
        Tue, 30 Aug 2022 08:27:14 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id CE19680004A;
        Tue, 30 Aug 2022 08:27:14 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 08:27:14 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 30 Aug
 2022 08:27:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 263573183BE2; Tue, 30 Aug 2022 08:27:14 +0200 (CEST)
Date:   Tue, 30 Aug 2022 08:27:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] esp: choose the correct inner protocol for GSO on
 inter address family tunnels
Message-ID: <20220830062714.GN2950045@gauss3.secunet.de>
References: <4b5a7ed6ce98b91362f2d16c84655919299c40e3.1661341717.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4b5a7ed6ce98b91362f2d16c84655919299c40e3.1661341717.git.sd@queasysnail.net>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 05:16:51PM +0200, Sabrina Dubroca wrote:
> Commit 23c7f8d7989e ("net: Fix esp GSO on inter address family
> tunnels.") is incomplete. It passes to skb_eth_gso_segment the
> protocol for the outer IP version, instead of the inner IP version, so
> we end up calling inet_gso_segment on an inner IPv6 packet and
> ipv6_gso_segment on an inner IPv4 packet and the packets are dropped.
> 
> This patch completes the fix by selecting the correct protocol based
> on the inner mode's family.
> 
> Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks a lot Sabrina!
