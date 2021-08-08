Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B73E3B53
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 18:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhHHQQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 12:16:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhHHQQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 12:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628439390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gxiT4tHPMMwG4z1tnV753/NcwtQf2gEijqfbmiwYjJI=;
        b=Bo46Vf0rZW2tyLv4F2YgXE9pGTZXC6ILMueJycb9h+b9MgLTm7bP2EOC2lpEAS5blKkzYq
        mXSRt0mgPVBldLjHAPXz0jBoSUH6juMsbCnwjg2fJGqi8NG8ceSkkMsOQYhvztLdyo5Scz
        OzLcViCx5vu1jNUpW8X1jja5dpBYTIE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-AWpCo4VENFCJnFnjmWA4eQ-1; Sun, 08 Aug 2021 12:16:29 -0400
X-MC-Unique: AWpCo4VENFCJnFnjmWA4eQ-1
Received: by mail-wm1-f71.google.com with SMTP id 21-20020a05600c0255b02902571fa93802so3807255wmj.1
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 09:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gxiT4tHPMMwG4z1tnV753/NcwtQf2gEijqfbmiwYjJI=;
        b=djWgqrtml+sX+6kfOBkB86n0lI9KiLku0svEro/xpwzbESkv3OhO3ktyhulmt0HUtT
         XM2JlbB1rYNQmclTn5XfVNClohzUB2ulDcsJO25mwJr+JEaRB9NDIP+vobb1gAZ6r3gY
         HY0mR000xKs7ZNdOKGT77NqA3GRUzBB+8VePf+/08GgyR3MLCkyNkFPq7CxpZM34Fue2
         ++o+k+N8jlRZvF4PMFx/I5KlvBzGONo/2tkGTyAH2uRhQuQehlnEEWazVfIcOuD3qBHK
         ao/ul3lDp+khXB3xJiAe86whw2FfoylNxZTsLpKkEe+ZeG3d0isyDyXZiMqv1BGclPz8
         f/IQ==
X-Gm-Message-State: AOAM531hGkjw6AvVwaUHe+ECxo7Uua46IAIFA+JcGomvpvaGa5JbX/14
        FcBrxGMi5En7nT22ASgXiiLXV49vxVfIK0vHUn4i4B2ie5gRWcReS8DRlrfvwmV0qsnHzJqOULT
        4q1+HsVc88OFLSnSi
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr20740636wrd.108.1628439388250;
        Sun, 08 Aug 2021 09:16:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO0fhr9qI/x9zK6sthJtFPyyWDA7xREtChOJN8gIcNtx8Y+SSOVqVsLvMAy27JPOjN0VETCw==
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr20740622wrd.108.1628439388053;
        Sun, 08 Aug 2021 09:16:28 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id y19sm18905827wmq.5.2021.08.08.09.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:16:27 -0700 (PDT)
Date:   Sun, 8 Aug 2021 18:16:25 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] bareudp: Fix invalid read beyond skb's linear data
Message-ID: <20210808161625.GA2912@pc-32.home>
References: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
 <20210806162234.69334902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806162234.69334902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 04:22:34PM -0700, Jakub Kicinski wrote:
> On Fri, 6 Aug 2021 17:52:06 +0200 Guillaume Nault wrote:
> > Data beyond the UDP header might not be part of the skb's linear data.
> > Use skb_copy_bits() instead of direct access to skb->data+X, so that
> > we read the correct bytes even on a fragmented skb.
> > 
> > Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  drivers/net/bareudp.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > index a7ee0af1af90..54e321a695ce 100644
> > --- a/drivers/net/bareudp.c
> > +++ b/drivers/net/bareudp.c
> > @@ -71,12 +71,18 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >  		family = AF_INET6;
> >  
> >  	if (bareudp->ethertype == htons(ETH_P_IP)) {
> > -		struct iphdr *iphdr;
> > +		__u8 ipversion;
> >  
> > -		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
> > -		if (iphdr->version == 4) {
> > -			proto = bareudp->ethertype;
> > -		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
> > +		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
> > +				  sizeof(ipversion))) {
> 
> No preference just curious - could skb_header_pointer() be better suited?

I have no preference either. I just used skb_copy_bits() because it
didn't seem useful to get a pointer to the buffer (just to read one
byte of data).

But I don't mind reposting with skb_header_pointer() if anyone prefers
that solution.

