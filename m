Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0964D3682A0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbhDVOnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236459AbhDVOnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 10:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619102566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMd6QraW89ebnEa3y2lxPV+flD1OuOpvVcOjWqIojUQ=;
        b=gNxZmuC0maG/xARvnSDEgvtXClAUx6UwdZwemsVksF49YRC9/Ofo2d9duZuy8hp4ASp9P5
        gbFd2pyrom6L7iEvX5o9zIO+eVqWIk/NSDVhYFr/UTETZuE3R2ODlR4vGOiKe08QaXWz+P
        C82wugxYhuuFp33QtyexDfwM8OJ/XFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-g7b2sgbaOt2wYepYMmrfVg-1; Thu, 22 Apr 2021 10:42:35 -0400
X-MC-Unique: g7b2sgbaOt2wYepYMmrfVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F784802575;
        Thu, 22 Apr 2021 14:42:32 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C75D369320;
        Thu, 22 Apr 2021 14:42:24 +0000 (UTC)
Date:   Thu, 22 Apr 2021 16:42:23 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>, brouer@redhat.com
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210422164223.77870d28@carbon>
In-Reply-To: <CAJ8uoz2JpfdjvjJp-vjWuhw5z1=2D32jj-KktFnLN6Zd9ZVmAQ@mail.gmail.com>
References: <cover.1617885385.git.lorenzo@kernel.org>
        <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
        <20210418181801.17166935@carbon>
        <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
        <YH0pdXXsZ7IELBn3@lore-desk>
        <CAJ8uoz101VZiwuvM-bs4UdW+kFT5xjgdgUwPWHZn4ABEOkyQ-w@mail.gmail.com>
        <20210421144747.33c5f51f@carbon>
        <CAJ8uoz3ROiPn+-bh7OjFOjXjXK9xGhU5cxWoFPM9JoYeh=zw=g@mail.gmail.com>
        <20210421173921.23fef6a7@carbon>
        <CAJ8uoz2JpfdjvjJp-vjWuhw5z1=2D32jj-KktFnLN6Zd9ZVmAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 22 Apr 2021 12:24:32 +0200
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Wed, Apr 21, 2021 at 5:39 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Wed, 21 Apr 2021 16:12:32 +0200
> > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> >  
[...]
> > > more than I get.  
> >
> > I clearly have a bug in the i40e driver.  As I wrote later, I don't see
> > any packets transmitted for XDP_TX.  Hmm, I using Mel Gorman's tree,
> > which contains the i40e/ice/ixgbe bug we fixed earlier.

Something is wrong with i40e, I changed git-tree to net-next (at
commit 5d869070569a) and XDP seems to have stopped working on i40e :-(

$ uname -a
Linux broadwell 5.12.0-rc7-net-next+ #600 SMP PREEMPT Thu Apr 22 15:13:15 CEST 2021 x86_64 x86_64 x86_64 GNU/Linux

When I load any XDP prog almost no packets are let through:

 [kernel-bpf-samples]$ sudo ./xdp1 i40e2
 libbpf: elf: skipping unrecognized data section(16) .eh_frame
 libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
 proto 17:          1 pkt/s
 proto 0:          0 pkt/s
 proto 17:          0 pkt/s
 proto 0:          0 pkt/s
 proto 17:          1 pkt/s

On the same system my mlx5 NIC works fine:

 [kernel-bpf-samples]$ sudo ./xdp1 mlx5p1
 libbpf: elf: skipping unrecognized data section(16) .eh_frame
 libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
 proto 17:   10984608 pkt/s
 proto 17:   24374656 pkt/s
 proto 17:   24339904 pkt/s



> > The call to xdp_convert_buff_to_frame() fails, but (see below) that
> > error is simply converted to I40E_XDP_CONSUMED.  Thus, not even the
> > 'trace_xdp_exception' will be able to troubleshoot this.  You/Intel
> > should consider making XDP_TX errors detectable (this will also happen
> > if TX ring don't have room).  
> 
> This is not good. Will submit a fix. Thanks for reporting Jesper.

Usually I use this command to troubleshoot:
  sudo ./xdp_monitor --stats 

But as driver i40e doesn't call the 'trace_xdp_exception' then I don't
capture any error this way.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

