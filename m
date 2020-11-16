Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6226F2B4952
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgKPPaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgKPPaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:30:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9182620E65;
        Mon, 16 Nov 2020 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605540615;
        bh=WqZ4iJPv5KD34c2PuG2d+Tjpeq8OVk+TP0a/gky8J9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M1hy8c57fHmk0f8OIgev+ztHYbT8gbk/cOc8Q1a3s2jz14p063tA0+6TwGxR3g1CH
         hKUSLEn1r5z6fmTiEAvUGNOIrXtMQ5thgZZhV2PoTUhPxJhVm6oN1XQrduS+gNXOZX
         yeHc9ycHeVB8GouSmORbwmx8qO2QsFCaFWayqTvI=
Date:   Mon, 16 Nov 2020 07:30:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: linux/skbuff.h: combine SKB_EXTENSIONS
 + KCOV handling
Message-ID: <20201116073013.24d45385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116143121.GC22792@breakpoint.cc>
References: <20201116031715.7891-1-rdunlap@infradead.org>
        <ffe01857-8609-bad7-ae89-acdaff830278@tessares.net>
        <20201116143121.GC22792@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 15:31:21 +0100 Florian Westphal wrote:
> > > @@ -4151,12 +4150,11 @@ enum skb_ext_id {
> > >   #if IS_ENABLED(CONFIG_MPTCP)
> > >   	SKB_EXT_MPTCP,
> > >   #endif
> > > -#if IS_ENABLED(CONFIG_KCOV)
> > >   	SKB_EXT_KCOV_HANDLE,
> > > -#endif  
> > 
> > I don't think we should remove this #ifdef: the number of extensions are
> > currently limited to 8, we might not want to always have KCOV there even if
> > we don't want it. I think adding items in this enum only when needed was the
> > intension of Florian (+cc) when creating these SKB extensions.
> > Also, this will increase a tiny bit some structures, see "struct skb_ext()".  
> 
> Yes, I would also prefer to retrain the ifdef.
> 
> Another reason was to make sure that any skb_ext_add(..., MY_EXT) gives
> a compile error if the extension is not enabled.

Oh well, sorry for taking you down the wrong path Randy!
