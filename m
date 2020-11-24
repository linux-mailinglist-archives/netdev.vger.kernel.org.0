Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A102C3462
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgKXXKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732201AbgKXXKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:10:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E8A206D9;
        Tue, 24 Nov 2020 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606259446;
        bh=9Jts3IF2GU8m/ozajkywPb8yPvDOYRJ0HpxN1YMYYA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=02ExMj0VqpiJmuBi5PiSd3zSA6LOHBaPqRpdDi9XOCq3yhXxU+YQIKxr9nqiYL7/g
         JQGxv0Y817Ewxn8fc4sMc6qemMgh0O0KKRU7H2Ysxo08QNlfpCjss+rNfvNEbU8ZpI
         Rg0rdgrFhC9p+J2AQ+ortx36GPwGkz16yqcWLrzs=
Date:   Tue, 24 Nov 2020 15:10:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        brouer@redhat.com, echaudro@redhat.com, john.fastabend@gmail.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net-next 0/3] mvneta: access skb_shared_info only on
 last frag
Message-ID: <20201124151044.227783cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ef387ff6-48e0-ba17-1143-6e9a88ea2367@iogearbox.net>
References: <cover.1605889258.git.lorenzo@kernel.org>
        <20201124122639.6fa91460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201124221854.GA64351@lore-desk>
        <09034687-75d5-7102-8f9a-7dde69d04a63@iogearbox.net>
        <20201124143056.606fd5d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ef387ff6-48e0-ba17-1143-6e9a88ea2367@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 00:00:33 +0100 Daniel Borkmann wrote:
> On 11/24/20 11:30 PM, Jakub Kicinski wrote:
> > On Tue, 24 Nov 2020 23:25:11 +0100 Daniel Borkmann wrote:  
> >> On 11/24/20 11:18 PM, Lorenzo Bianconi wrote:  
> >>>> On Fri, 20 Nov 2020 18:05:41 +0100 Lorenzo Bianconi wrote:  
> >>>>> Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
> >>>>> skb_shared_info area only on the last fragment.
> >>>>> Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routine.
> >>>>> This a preliminary series to complete xdp multi-buff in mvneta driver.  
> >>>>
> >>>> Looks fine, but since you need this for XDP multi-buff it should
> >>>> probably go via bpf-next, right?
> >>>>
> >>>> Reviewed-by: Jakub Kicinski <kuba@kernel.org>  
> >>>
> >>> Hi Jakub,
> >>>
> >>> thx for the review. Since the series changes networking-only bits I sent it for
> >>> net-next, but I agree bpf-next is better.
> >>>
> >>> @Alexei, Daniel: is it fine to merge the series in bpf-next?  
> >>
> >> Yeah totally fine, will take it into bpf-next in a bit.  
> > 
> > FWIW watch out with the Link:s, it wasn't CCed to bpf@vger.  
> 
> @Jakub, I think it's less hassle if you take the series in. Looking closer, net-next has
> commit 9c79a8ab5f12 ("net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment")
> which bpf-next is currently lacking, and this series here is touching the part of this
> code, so it will create unnecessary merge conflicts. I'll likely flush out bpf-next PR
> on Thurs/Fri at latest, so bpf-next will then have everything needed once we sync back
> from net-next after merge.

I see, applied to net-next then. Thanks!
