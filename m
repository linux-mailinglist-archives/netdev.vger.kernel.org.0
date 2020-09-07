Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F113A25FBD8
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgIGOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:09:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729789AbgIGOIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599487689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OWiEwbKTV7E2xnnNVFq3xGVSzUyW2sxaJcO4BqWhJU8=;
        b=dyBBOQq3Yzl8XBqPzdc1X4aPurkbUycjIVtT5FCiZqBndJW24CwfD7xm3X/ECFKHDJmcB3
        9iTsJbL2/M9AlqOTBHohf/4MKt673SSLOVg1ojHnHUT9g0OjIujorpPIWoh/+XcdqZfQUq
        eqe5y3ibaVJejPUC/foLzfePkwzvpIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-pMixxMfnMbu5ORrtS7mCOA-1; Mon, 07 Sep 2020 10:08:05 -0400
X-MC-Unique: pMixxMfnMbu5ORrtS7mCOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F19B80B70F;
        Mon,  7 Sep 2020 14:08:04 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14A865D9D2;
        Mon,  7 Sep 2020 14:07:58 +0000 (UTC)
Date:   Mon, 7 Sep 2020 16:07:57 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com,
        Maciej Zenczykowski <maze@google.com>
Subject: Re: [PATCH bpf-next] bpf: don't check against device MTU in
 __bpf_skb_max_len
Message-ID: <20200907160757.1f249256@carbon>
In-Reply-To: <20200904163947.20839d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <159921182827.1260200.9699352760916903781.stgit@firesoul>
        <20200904163947.20839d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 16:39:47 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 04 Sep 2020 11:30:28 +0200 Jesper Dangaard Brouer wrote:
> > @@ -3211,8 +3211,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
> >  
> >  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> >  {
> > -	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > -			  SKB_MAX_ALLOC;
> > +	return SKB_MAX_ALLOC;
> >  }
> >  
> >  BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
> >   
> 
> Looks familiar:
> https://lore.kernel.org/netdev/20200420231427.63894-1-zenczykowski@gmail.com/
> 

Great to see that others have proposed same fix before.  Unfortunately
it seems that the thread have died, and no patch got applied to
address this.  (Cc. Maze since he was "mull this over a bit more"...)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

