Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7345D2A09A8
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgJ3PWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgJ3PWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 11:22:51 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10DA32224E;
        Fri, 30 Oct 2020 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604071370;
        bh=qgzKRr8G8eLsjm02a7ruBUeSbPrka8cTWgm3aNJdvgk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bA2oVeTS6lAGSNXY6MygmY93AIdTxdC93L+H6AN8niHsnr7UA3rcS0qvC4bb+fyjL
         MgYZ8c/OOrk51wcpTsAdIXgDOQ9CN9sS+GeGQ2HaFWC6plG04TMhVIqijZWeAxQSWC
         EK1sGGYy8XACFVMsqzt9hkgd9sCKe/PahSMPKMfk=
Date:   Fri, 30 Oct 2020 08:22:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [net-next v2] tipc: add stricter control of reserved service
 types
Message-ID: <20201030082248.033df7ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030012938.489557-1-jmaloy@redhat.com>
References: <20201030012938.489557-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 21:29:38 -0400 jmaloy@redhat.com wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> TIPC reserves 64 service types for current and future internal use.
> Therefore, the bind() function is meant to block regular user sockets
> from being bound to these values, while it should let through such
> bindings from internal users.
> 
> However, since we at the design moment saw no way to distinguish
> between regular and internal users the filter function ended up
> with allowing all bindings of the reserved types which were really
> in use ([0,1]), and block all the rest ([2,63]).
> 
> This is risky, since a regular user may bind to the service type
> representing the topology server (TIPC_TOP_SRV == 1) or the one used
> for indicating neighboring node status (TIPC_CFG_SRV == 0), and wreak
> havoc for users of those services, i.e., most users.
> 
> The reality is however that TIPC_CFG_SRV never is bound through the
> bind() function, since it doesn't represent a regular socket, and
> TIPC_TOP_SRV can also be made to bypass the checks in tipc_bind()
> by introducing a different entry function, tipc_sk_bind().
> 
> It should be noted that although this is a change of the API semantics,
> there is no risk we will break any currently working applications by
> doing this. Any application trying to bind to the values in question
> would be badly broken from the outset, so there is no chance we would
> find any such applications in real-world production systems.
> 
> Acked-by: Yung Xue <ying.xue@windriver.com>
> 
> ---

Please be careful with the separator, git am cuts off the rest of the
message including your sign-off. 

> v2: Added warning printout when a user is blocked from binding,
>     as suggested by Jakub Kicinski
> 
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>

Fixed up the message, and applied. Thanks!
