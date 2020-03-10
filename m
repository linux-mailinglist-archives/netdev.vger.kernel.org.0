Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D386417F0B7
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 07:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJGqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 02:46:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbgCJGqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 02:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583822778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EhpLH+5ZpGFALzCiu9NCcVjq4wHw699c69K4HhGZTTk=;
        b=UBw1awbXUJ03X1z11z6v50BaSF75itcZ5xNvewCYEJHqHSoc0Pb0ivWgvqJG104RmlcrbG
        LHTkP5TiSUdE8nHm9eGrg+/mYDuMphhfceJdFQXMHoxbO0W965Pbt3+sTyePV+Uh9NV/RZ
        O0sry6NgFt/dv07a0AIjZ4XxIy99fA4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-e-EAvbPNMU6S-pYtfQWqrg-1; Tue, 10 Mar 2020 02:46:16 -0400
X-MC-Unique: e-EAvbPNMU6S-pYtfQWqrg-1
Received: by mail-qk1-f197.google.com with SMTP id c1so1575890qkm.16
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 23:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EhpLH+5ZpGFALzCiu9NCcVjq4wHw699c69K4HhGZTTk=;
        b=IAJcesKLzUNVrNG+GLpK82Gakj+e4ii2W2NnbystOZ8ngJFzT9VPZZRsWUq5lEYSr/
         R9DZ7T97jNzOncNj41j89kQFpiOGqjj5N+jTHTjAiwYN/zehsMhJ/W9/T87BOk8z6mH7
         X6cXV1M3zj62cM0C2Ixq2/37dRm970cSWSElpWYA2fh9oDc3scCmKWRqlT6kKEf/YDEA
         gIbXcGlv/VMogV3q2nsb9IUnkiTNI6H6qWJI1IYjVBeMT7Te703mbFasa954wLhN1RIm
         azZIyk9t6kcPeK5qLkFgqWPaM64L+o45oMuI2b4EZxotQNQVXamHZtURK+dcbUv/eB1M
         ii8A==
X-Gm-Message-State: ANhLgQ18iNGZu7n5aXJC7I2vJGaSHYGRiHQwqrSTLCN1i9rrva/6WWl1
        8FqjU3pg6FcmiWRqf4ty4Jfv1tcQF8x+GRlYb8NqPV5c+6FKe38KNDkHWljCLcvfApTHpJzVZE+
        zIZAfB2YY0IWNtErS
X-Received: by 2002:a05:620a:110c:: with SMTP id o12mr18104795qkk.87.1583822775749;
        Mon, 09 Mar 2020 23:46:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtks7KG+p4uaHqmmcFvZLCMxBMt1ZI8c/BLIY5TJAGIr9Em2oZghA+4PvFHcpY+KxdhNnglUQ==
X-Received: by 2002:a05:620a:110c:: with SMTP id o12mr18104785qkk.87.1583822775540;
        Mon, 09 Mar 2020 23:46:15 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id x89sm9266920qtd.43.2020.03.09.23.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:46:14 -0700 (PDT)
Date:   Tue, 10 Mar 2020 02:46:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200310024417-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <CA+FuTSfTac=Ut43nFJdB_z605Y-NO7En8AqKT3X8q8=SjFHe6Q@mail.gmail.com>
 <CA+FuTSc9gdNO1O1HxOz+j-KVhL_+24LyQjb_gB0tF6uH++ykGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSc9gdNO1O1HxOz+j-KVhL_+24LyQjb_gB0tF6uH++ykGg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 11:50:23AM -0400, Willem de Bruijn wrote:
> On Mon, Mar 9, 2020 at 11:42 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, Mar 9, 2020 at 11:34 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > In one error case, tpacket_rcv drops packets after incrementing the
> > > ring producer index.
> > >
> > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > thus the reader is stalled for an iteration of the ring, causing out
> > > of order arrival.
> > >
> > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > to encountering an unknown GSO type.
> > >
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> >
> > Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
> >
> > I forgot to add the Fixes tag, sorry. This goes back to the
> > introduction of GSO support for virtio_net.
> 
> The problem of blinding receivers to certain packet types goes back to
> that commit.
> 
> But the specific issue of ring out of order arrival is added later,
> when vnet_hdr support is extended to tpacket_rcv:
> 
> Fixes: 58d19b19cd99 ("packet: vnet_hdr support for tpacket_rcv")


In fact it looks like

commit 9fd1ff5d2ac7181844735806b0a703c942365291
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Sat Jan 25 11:26:45 2020 +0100

    udp: Support UDP fraglist GRO/GSO.

and

commit 90017accff61ae89283ad9a51f9ac46ca01633fb
Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Thu Jun 2 15:05:43 2016 -0300

    sctp: Add GSO support
    
both break userspace using virtio due to lack of fallback...

-- 
MST

