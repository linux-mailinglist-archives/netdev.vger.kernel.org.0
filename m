Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8398A15BC41
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 11:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgBMKAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 05:00:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729531AbgBMKAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 05:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581588042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ytg6S/SjmgY27QCPpYz1CiXOXhwp3fWgAbdebdN5iyM=;
        b=OBUqw+nKDzhYni3HCFh5shfP/YPIkcPWsispjXcXkwJtx2KKjZ9z3I3KIG5zAQNCqWr7vI
        WcA5i+iLHmbYDKrKH0q9BsdUHFZtlVK05wNmn0F+WR6o2sP82YBjWbHRsI9+4ehcjHXwNB
        j0bvScVdWyDPAvyVPl4FQPrx0hn/pls=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-bdhM4htTMiSl41PLSTWXig-1; Thu, 13 Feb 2020 05:00:36 -0500
X-MC-Unique: bdhM4htTMiSl41PLSTWXig-1
Received: by mail-qt1-f199.google.com with SMTP id c22so3284013qtn.23
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 02:00:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ytg6S/SjmgY27QCPpYz1CiXOXhwp3fWgAbdebdN5iyM=;
        b=NnoMPh+ELD5hcJVlqClFmq6732T9tuoIcWweAu8cjIzHGVHLs0UZzLrB/LlUmpWyFI
         2YWctBqZzj1kIgUjky9qSaSJ3/Gkx8uLnuKZmQJNmA9n/I5MahblnCFa5HSmuJwrMKwS
         CvmiowAdLV5xq7skQaVWeykXnz5RnwmjiU4SkZaPy+aqDo4q4t3ooAvEOTz8cepS6KA/
         zr0mSmhVGYScswRCtvV+2Yba5tScF23T3b+GmWuXKRXkTXcWOE8T2dj6s7eMKFsjy0Ut
         2MzpaAMt7scC9Pjcgctk9OjNXMaCHyiygmGTRHH0wuP17TrmRR+OBzXGOcI8pEDI6/t3
         TInA==
X-Gm-Message-State: APjAAAVSKpkTqGwTmCbEiCBFV53WOjM0vAaHkNTR2nzQjM+0HVYPC3Xg
        O3sgOxOdHJeDftbHVtKfl8XFk+v9D38NnOPXINR3HuSk3P1CXWed082gE3eOnsMHxOPD4xShO+e
        tQqRkXZmzdLpKNfVn
X-Received: by 2002:ac8:5486:: with SMTP id h6mr11035481qtq.17.1581588035511;
        Thu, 13 Feb 2020 02:00:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5YIEiMuYiBy1dpXQWozHdfbbuS4aN+XNzTRes1+I7PcyUDz39RveWTfedPrdmALPyWPBi8w==
X-Received: by 2002:ac8:5486:: with SMTP id h6mr11035446qtq.17.1581588035063;
        Thu, 13 Feb 2020 02:00:35 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id g6sm1030372qki.100.2020.02.13.02.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 02:00:34 -0800 (PST)
Date:   Thu, 13 Feb 2020 05:00:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200213045937-mutt-send-email-mst@kernel.org>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 05:38:09PM +0000, Anton Ivanov wrote:
> 
> 
> On 11/02/2020 10:37, Michael S. Tsirkin wrote:
> > On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
> > > On 11/02/2020 02:51, Jason Wang wrote:
> > > > 
> > > > On 2020/2/11 上午12:55, Anton Ivanov wrote:
> > > > > 
> > > > > 
> > > > > On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
> > > > > > From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > 
> > > > > > Some of the frames marked as GSO which arrive at
> > > > > > virtio_net_hdr_from_skb() have no GSO_TYPE, no
> > > > > > fragments (data_len = 0) and length significantly shorter
> > > > > > than the MTU (752 in my experiments).
> > > > > > 
> > > > > > This is observed on raw sockets reading off vEth interfaces
> > > > > > in all 4.x and 5.x kernels I tested.
> > > > > > 
> > > > > > These frames are reported as invalid while they are in fact
> > > > > > gso-less frames.
> > > > > > 
> > > > > > This patch marks the vnet header as no-GSO for them instead
> > > > > > of reporting it as invalid.
> > > > > > 
> > > > > > Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > ---
> > > > > >    include/linux/virtio_net.h | 8 ++++++--
> > > > > >    1 file changed, 6 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > > > index 0d1fe9297ac6..d90d5cff1b9a 100644
> > > > > > --- a/include/linux/virtio_net.h
> > > > > > +++ b/include/linux/virtio_net.h
> > > > > > @@ -112,8 +112,12 @@ static inline int
> > > > > > virtio_net_hdr_from_skb(const struct sk_buff *skb,
> > > > > >                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> > > > > >            else if (sinfo->gso_type & SKB_GSO_TCPV6)
> > > > > >                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> > > > > > -        else
> > > > > > -            return -EINVAL;
> > > > > > +        else {
> > > > > > +            if (skb->data_len == 0)
> > > > > > +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
> > > > > > +            else
> > > > > > +                return -EINVAL;
> > > > > > +        }
> > > > > >            if (sinfo->gso_type & SKB_GSO_TCP_ECN)
> > > > > >                hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
> > > > > >        } else
> > > > > > 
> > > > > 
> > > > > ping.
> > > > > 
> > > > 
> > > > Do you mean gso_size is set but gso_type is not? Looks like a bug
> > > > elsewhere.
> > > > 
> > > > Thanks
> > > > 
> > > > 
> > > Yes.
> > > 
> > > I could not trace it where it is coming from.
> > > 
> > > I see it when doing recvmmsg on raw sockets in the UML vector network
> > > drivers.
> > > 
> > 
> > I think we need to find the culprit and fix it there, lots of other things
> > can break otherwise.
> > Just printing out skb->dev->name should do the trick, no?
> 
> The printk in virtio_net_hdr_from_skb says NULL.
> 
> That is probably normal for a locally originated frame.
> 
> I cannot reproduce this with network traffic by the way - it happens only if the traffic is locally originated on the host.
> 
> A,

OK so is it code in __tcp_transmit_skb that sets gso_size to non-null
when gso_type is 0?


> > 
> > 
> > > -- 
> > > Anton R. Ivanov
> > > Cambridgegreys Limited. Registered in England. Company Number 10273661
> > > https://www.cambridgegreys.com/
> > 
> > 
> > _______________________________________________
> > linux-um mailing list
> > linux-um@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-um
> > 
> 
> -- 
> Anton R. Ivanov
> Cambridgegreys Limited. Registered in England. Company Number 10273661
> https://www.cambridgegreys.com/

