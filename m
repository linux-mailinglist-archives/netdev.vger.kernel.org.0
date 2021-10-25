Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B977439A93
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhJYPgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:36:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbhJYPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 11:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635176067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YwfmUEaIE65kckhigKIeO5UdqtC2rRmoFNbtu9Az7TY=;
        b=PrCagFbqe2SftCWQtqF1pSbrGBo1zy5/PaSWX/pW80axNUXqwhw70ZoOvI33D6gAfSP0yz
        iPiwe8+fTO25AoS114l2ngLgvH00Po8eTbI7mb9N75u8XAOdX+NGMlhfjKbZ7Cbp1+6wvU
        b+b60vY7BXhmsHDAl7F1c+fKt86ANOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-N-kBO1zsOkaw3lre8tgruQ-1; Mon, 25 Oct 2021 11:34:24 -0400
X-MC-Unique: N-kBO1zsOkaw3lre8tgruQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5113091273;
        Mon, 25 Oct 2021 15:34:23 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5863A69119;
        Mon, 25 Oct 2021 15:34:21 +0000 (UTC)
Date:   Mon, 25 Oct 2021 17:34:18 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jk@codeconstruct.com.au, netdev@vger.kernel.org, kuba@kernel.org,
        matt@codeconstruct.com.au
Subject: Re: [PATCH net-next v5] mctp: Implement extended addressing
Message-ID: <20211025153418.GA6853@asgard.redhat.com>
References: <20211025032757.2317020-1-jk@codeconstruct.com.au>
 <20211025.161549.899716517054473254.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025.161549.899716517054473254.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 04:15:49PM +0100, David Miller wrote:
> From: Jeremy Kerr <jk@codeconstruct.com.au>
> Date: Mon, 25 Oct 2021 11:27:57 +0800
> 
> > @@ -152,10 +155,16 @@ struct mctp_sk_key {
> >  
> >  struct mctp_skb_cb {
> >  	unsigned int	magic;
> > -	unsigned int	net;
> > +	int		net;
> > +	int		ifindex; /* extended/direct addressing if set */
> > +	unsigned char	halen;
> >  	mctp_eid_t	src;
> > +	unsigned char	haddr[];
> >  };
> >  
> putting a variably sized type in the skb control blocxk is not a good idea.
> Overruns will be silent, nothing in the typing protects you from udsing more space
> han exists in skb->cb.
> 
> Plrease find another way, thank you.

haddr[MAX_ADDR_LEN]?  It is defined to 32 bytes.

