Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7E22B1284
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKLXM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLXM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:12:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8CB720B80;
        Thu, 12 Nov 2020 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605222776;
        bh=yGzOpisp2T11IcOD2LVn3gF+D9VwQNFySDaY7+EixE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a0KGJS9NTTPp5hrOzLtl5CUjIdhBT4MonJH9vhCcKMOOYwAGgwVf2pu75ng4v/HSc
         CZnlBP6FWUAcaU158g2nRpMU/WVyD8/UxzSPFhrg/uwEKEV47GLvACV7j0zQqrEPOm
         ACPb5SI9cyb1MRI5aJ+frjSROwzmBScm1etoLMqw=
Date:   Thu, 12 Nov 2020 15:12:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 01/13] tcp: factor out tcp_build_frag()
Message-ID: <20201112151254.14e3b059@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112150831.1c4bb8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1605199807.git.pabeni@redhat.com>
        <8fcb0ad6f324008ccadfd1811d91b3145bbf95fd.1605199807.git.pabeni@redhat.com>
        <20201112150831.1c4bb8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 15:08:31 -0800 Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 18:45:21 +0100 Paolo Abeni wrote:
> > +		skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
> > +				tcp_rtx_and_write_queues_empty(sk));  
> 
> no good reason to misalign this AFAICT

Maybe not worth respining just for this, I thought there are build
warnings but seems it's mostly sparse getting confused.

Is there a chance someone could look into adding annotations to socket
locking?
