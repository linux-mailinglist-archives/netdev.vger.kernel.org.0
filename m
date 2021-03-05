Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B25132F5D2
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhCEWT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhCEWTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 17:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C954B65079;
        Fri,  5 Mar 2021 22:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614982771;
        bh=xthW8BSy4OqFaui04rOb9Zbf2qc1PRAlgV/1Tcqd8/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u95+gWvu+3wQwafYVNyjRxhI8lctSM+psTOwLm5bBI/X7N5qSw9okvLt8lx2nWO2G
         RbC5SItzJxWVTTpsSOxd8PNGO/oE6/2ye4YhK2PBsL5eTmM/aC+8iZndEIvkIAAtBa
         rOxHb7rZeDDmSNN4D+LJHL4Z2AhuiaTGVycI3AeJceJJQzbnbqHFCedF3Vng5U4l90
         GPR4yWP9KiJH3JdnOw/pd4dtfBgHTfximFRQvXmSIz0NbuVjrtlIE8w7PQQ4A1FbMy
         kwfM4AVILTRrhqbB6KRUDE2XdP6GvY/IOuMAfRJThC3UfPjbyDUPbmdeAtBoNxlKKY
         y8WQX5j0gHMtw==
Date:   Fri, 5 Mar 2021 14:19:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, zbynek.michl@gmail.com,
        chris.snook@gmail.com, bruceshenzk@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH net] ethernet: alx: fix order of calls on resume
Message-ID: <20210305141930.78fbfac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210305221729.206096-1-kuba@kernel.org>
References: <20210305221729.206096-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Mar 2021 14:17:29 -0800 Jakub Kicinski wrote:
> netif_device_attach() will unpause the queues so we can't call
> it before __alx_open(). This went undetected until
> commit b0999223f224 ("alx: add ability to allocate and free
> alx_napi structures") but now if stack tries to xmit immediately
> on resume before __alx_open() we'll crash on the NAPI being null:

> Cc: <stable@vger.kernel.org> # 4.9+
> Fixes: bc2bebe8de8e ("alx: remove WoL support")
> Reported-by: Zbynek Michl <zbynek.michl@gmail.com>
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983595
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I should have also added:

Tested-by: Zbynek Michl <zbynek.michl@gmail.com>
