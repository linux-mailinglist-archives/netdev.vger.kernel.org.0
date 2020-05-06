Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CC11C6949
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgEFGr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgEFGr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:47:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6416A20747;
        Wed,  6 May 2020 06:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588747647;
        bh=ytOXmRnuZmgcXJAyYOWuXoaPYMAO9uUP+QC5d6j+MkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xFB7udiounmte/IcpA4rp1CpfNw82L5bqVkGORTzgtHS1hadKlp2JNdmv9eFjtfl5
         wN3RhBH5VBVvi1s4CmVevAhN+e3SzwNnU4LqxxrZAU2DiazTohyjR/N8eRSTYpnIwV
         oX/npF5HnUU8BBrUjTWQuOenU3Rz+r/EAMi4sAT4=
Date:   Wed, 6 May 2020 08:47:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ashwin-h <ashwinh@vmware.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, rostedt@goodmis.org, srostedt@vmware.com,
        ashwin.hiranniah@gmail.com, Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH 1/2] sctp: implement memory accounting on tx path
Message-ID: <20200506064725.GC2273049@kroah.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
 <4ce6c13946803700d235082b9c52460ed38dab1e.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ce6c13946803700d235082b9c52460ed38dab1e.1588242081.git.ashwinh@vmware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 07:50:53PM +0530, ashwin-h wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> commit 1033990ac5b2ab6cee93734cb6d301aa3a35bcaa upstream.
> 
> Now when sending packets, sk_mem_charge() and sk_mem_uncharge() have been
> used to set sk_forward_alloc. We just need to call sk_wmem_schedule() to
> check if the allocated should be raised, and call sk_mem_reclaim() to
> check if the allocated should be reduced when it's under memory pressure.
> 
> If sk_wmem_schedule() returns false, which means no memory is allowed to
> allocate, it will block and wait for memory to become available.
> 
> Note different from tcp, sctp wait_for_buf happens before allocating any
> skb, so memory accounting check is done with the whole msg_len before it
> too.
> 
> Reported-by: Matteo Croce <mcroce@redhat.com>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ashwin H <ashwinh@vmware.com>
> ---
>  net/sctp/socket.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
