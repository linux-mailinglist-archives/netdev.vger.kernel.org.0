Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130C51E83A5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgE2Q2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:28:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725681AbgE2Q2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590769696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOocdEe8JcHWozlDHA2H1VhP1cNSV3Qek6Z4dV8TZIg=;
        b=KEuNiIOtB3hP9R7oVWOSDvRnGQDdWEn4qrl+t53zC4fFvAM/3UDqr/HP+9kGwg/pB9GQxY
        JhInqU0kut2ihQkYM4Cm2ALsKqa+ZQze0ag1JUYwtDrDrpRBiYdJqmgqVfDNXR98a8IL4s
        stMH8DjyofIX79eE2GPf8Nnn9m31te4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-TrjcmuouNH6DG4JTYjvPbQ-1; Fri, 29 May 2020 12:28:11 -0400
X-MC-Unique: TrjcmuouNH6DG4JTYjvPbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 308081855A1D;
        Fri, 29 May 2020 16:28:10 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 393A27A8CC;
        Fri, 29 May 2020 16:28:04 +0000 (UTC)
Date:   Fri, 29 May 2020 18:28:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next RFC 1/3] bpf: move struct bpf_devmap_val out of
 UAPI
Message-ID: <20200529182803.526832ed@carbon>
In-Reply-To: <a0cadc6b-ceb4-c40b-8a02-67b99a665d74@gmail.com>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
        <159076798058.1387573.3077178618799401182.stgit@firesoul>
        <a0cadc6b-ceb4-c40b-8a02-67b99a665d74@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 10:06:25 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/29/20 9:59 AM, Jesper Dangaard Brouer wrote:
> > @@ -60,6 +60,15 @@ struct xdp_dev_bulk_queue {
> >  	unsigned int count;
> >  };
> >  
> > +/* DEVMAP values */
> > +struct bpf_devmap_val {
> > +	__u32 ifindex;   /* device index */
> > +	union {
> > +		int   fd;  /* prog fd on map write */
> > +		__u32 id;  /* prog id on map read */
> > +	} bpf_prog;
> > +};
> > +  
> 
> I can pick up this name change for v4.

Great - I will appreciate, as this will make my patchset compatible
with yours :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

