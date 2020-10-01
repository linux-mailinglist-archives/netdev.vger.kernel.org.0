Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334DA27FCA1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 11:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgJAJrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 05:47:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbgJAJrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 05:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601545639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lPzPuIGXO/Ao+4pICi+9MLX10N1dZAhUeotde1HKkqA=;
        b=hBMTLxWbMggRXsPvrMpCl2rFC1F4trbBTvWvuu95kC1L3MrbJJGZ7hEXIyn0EuLpJXdbpr
        ThlBoI/sAMazAirtM6HR8orCcvMMlhfVpBFe7zg1OAHa7I23c6M5hTyZtKlOOD4PnvcCwu
        YwkTkTCDydmxPsQVz5T1eeO7oNto9wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-OtYRo1vRM4WSsOijVyhGrQ-1; Thu, 01 Oct 2020 05:47:14 -0400
X-MC-Unique: OtYRo1vRM4WSsOijVyhGrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97D812FD0A;
        Thu,  1 Oct 2020 09:47:12 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EDFA7848B;
        Thu,  1 Oct 2020 09:47:02 +0000 (UTC)
Date:   Thu, 1 Oct 2020 11:47:00 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, sameehj@amazon.com,
        kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v3 net-next 06/12] bpf: helpers: add multibuffer support
Message-ID: <20201001114700.6384e6cc@carbon>
In-Reply-To: <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com>
References: <cover.1601478613.git.lorenzo@kernel.org>
        <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
        <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 12:11:21 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Sep 30, 2020 at 05:41:57PM +0200, Lorenzo Bianconi wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> > 
> > The implementation is based on this [0] draft by Jesper D. Brouer.

First of all I think you are giving me too much credit, and this is
both not really relevant and also not specific enough.  The link[0]
contains several proposals (actually from different people) and it is
not clear which of these proposal you reference.

I think this patch need to explain and argue why these BPF-helpers
makes sense... this will become BPF UAPI.

> > Provided two new helpers:
> > 
> > * bpf_xdp_get_frag_count()
> > * bpf_xdp_get_frags_total_size()

Why was the "frag" and "frags" name chosen?

 
> > [0] xdp mb design - https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 14 ++++++++++++
> >  net/core/filter.c              | 42 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 14 ++++++++++++
> >  3 files changed, 70 insertions(+)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a22812561064..6f97dce8cccf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3586,6 +3586,18 @@ union bpf_attr {
> >   * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
> >   * 	Return
> >   * 		0 on success, or a negative error in case of failure.
> > + *
> > + * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the number of fragments for a given xdp multi-buffer.
> > + *	Return
> > + *		The number of fragments
> > + *
> > + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the total size of fragments for a given xdp multi-buffer.
> > + *	Return
> > + *		The total size of fragments for a given xdp multi-buffer.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -3737,6 +3749,8 @@ union bpf_attr {
> >  	FN(inode_storage_delete),	\
> >  	FN(d_path),			\
> >  	FN(copy_from_user),		\
> > +	FN(xdp_get_frag_count),		\
> > +	FN(xdp_get_frags_total_size),	\
> >  	/* */  
> 
> Please route the set via bpf-next otherwise merge conflicts will be severe.
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

