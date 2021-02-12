Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A94931A237
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhBLP7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:59:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhBLP7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:59:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613145465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oo7Y3FmddPsT+l+jXmBLSYbXq2Wm/xOLFiB2OfHnxsg=;
        b=LNBeUTxdI3XOpBLL1MOM0Wskz7efKdq/k6qpSDcCkYjr+glNJOFOINhA8VFa1jeFU6bzDW
        2W1vnW02gS9X2Nr7Dz9G8QTCJeubFYEFFpXZ7m/zgHSe4BF2lEiJ6PUXX1wygNAVQvgAfG
        BiZSTvxVEk27iNs61lmhiXDkI4i02jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-Mp03Df6vN4yHTIMZKyxKQQ-1; Fri, 12 Feb 2021 10:57:41 -0500
X-MC-Unique: Mp03Df6vN4yHTIMZKyxKQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C82C71E563;
        Fri, 12 Feb 2021 15:57:39 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8DA71F456;
        Fri, 12 Feb 2021 15:57:33 +0000 (UTC)
Date:   Fri, 12 Feb 2021 16:57:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
Message-ID: <20210212165732.77a34579@carbon>
In-Reply-To: <20210129120723.1e90ab42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
        <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
        <20210129085808.4e023d3f@carbon>
        <20210129114642.139cb7dc@carbon>
        <20210129113555.6d361580@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <28a12f2b-3c46-c428-ddc2-de702ef33d3f@gmail.com>
        <20210129120723.1e90ab42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 12:07:23 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 29 Jan 2021 20:47:41 +0100 Eric Dumazet wrote:
> > On 1/29/21 8:35 PM, Jakub Kicinski wrote:
> >   
> > > kdoc didn't complain, and as you say it's already a mess, plus it's
> > > two screen-fulls of scrolling away... 
> > > 
> > > I think converting to inline kdoc of members would be an improvement,
> > > if you want to sign up for that? Otherwise -EDIDNTCARE on my side :)
> > >     
> > 
> > What about removing this kdoc ?
> > 
> > kdoc for a huge structure is mostly useless...  
> 
> It's definitely not useful for "us", I'd guess most seasoned developers
> will just grep for uses of the field - but maybe it is useful for noobs
> trying to have high-level sense of the code? 
> 
> Either way is fine by me, we can always preserve meaningful comments
> inline without the kdoc decorator.

I agree that removing this kdoc makes sense. But as Jakub says we
should preserve meaningful comments inline.  I'll add this task to my
TODO list, but anyone feel free to do the work before I get around to it.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

