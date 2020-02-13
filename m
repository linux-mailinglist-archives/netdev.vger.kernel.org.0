Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E3D15BF02
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgBMNMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:12:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46537 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729557AbgBMNMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 08:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581599541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wsQZ3q+lcvXCCh85Qi7IpJnWbcPUNf37iJtXE8O7tyE=;
        b=KF6TW1qjuTUvU8FPDANnC7PFnUMLtIF9jx6nx5y6bL/HJk103ZHfi3UPiSom19euPxaMAG
        SYM/Cuo8KmcH6eg44AMHlsHawAiVU2wt+3QkNZIIiVN2dx2vNjKdq9BVr/yl2La5trmits
        1z/bkGfvElXl/Cpxnvx+b3ohH7cGxKc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-oQ78EN12Nm6zNI7BH8m1_Q-1; Thu, 13 Feb 2020 08:12:15 -0500
X-MC-Unique: oQ78EN12Nm6zNI7BH8m1_Q-1
Received: by mail-wr1-f71.google.com with SMTP id u18so2288837wrn.11
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 05:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wsQZ3q+lcvXCCh85Qi7IpJnWbcPUNf37iJtXE8O7tyE=;
        b=pzQpuEc1CQyv/zd7zMWSJQMSMlSX6hF/q7gj7hgdVqfIUfVkv6ZS6E+uzEPE2anX1Q
         YJQqDo2WszZhl5dQh+a8afjQmHcn/Wfe3njlxfoVcVLBUBzOU7NI8H4ovuQTb6+hgPKC
         QamASJf9sI+smUWLHQJwe7HAfK2xMdz3nhmdtFn4T3SMUjGIMXwKwKZrTa8N51VMOft2
         BOdnTLs0GWJPTC9jIIzsUohJx2IC3TlwcIZNF+DRnEgv0VnrcKHaZTRLo0H/EotZf3wP
         gg8jyx+P8FxiGJHGju0S1Jqa12SokVAh+04jEz4ngjqa46Euiwg9UA/dzMwq/XRvnzGg
         cfuQ==
X-Gm-Message-State: APjAAAXVt2lndFFPXDsWphvNazNr54i+ziF1Laz4py1pvVWpcshmost8
        0wdyaOUAUmiItPVrNyvxpA5PLhbRQTlulFBp9U/91+nzwluVeHMzEa2sitk9K9Y8wHpGgUV4NdP
        dgAt5FXqiinLWHxm2
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr5715542wmc.111.1581599534674;
        Thu, 13 Feb 2020 05:12:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzTTvnhnAah+aJFeotACloGF4Z8cs+TlgrEmrseuB5EWMr6pm93mTatL71DwY45++oS6yAGhQ==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr5715529wmc.111.1581599534436;
        Thu, 13 Feb 2020 05:12:14 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id q1sm2692269wrw.5.2020.02.13.05.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 05:12:13 -0800 (PST)
Date:   Thu, 13 Feb 2020 08:12:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200213081154-mutt-send-email-mst@kernel.org>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
 <20200213045937-mutt-send-email-mst@kernel.org>
 <54692f06-f687-8bd3-7a1b-3dac3e79110b@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54692f06-f687-8bd3-7a1b-3dac3e79110b@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 11:12:45AM +0000, Anton Ivanov wrote:
> 
> 
> On 13/02/2020 10:00, Michael S. Tsirkin wrote:
> > On Wed, Feb 12, 2020 at 05:38:09PM +0000, Anton Ivanov wrote:
> > > 
> > > 
> > > On 11/02/2020 10:37, Michael S. Tsirkin wrote:
> > > > On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
> > > > > On 11/02/2020 02:51, Jason Wang wrote:
> > > > > > 
> > > > > > On 2020/2/11 上午12:55, Anton Ivanov wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
> > > > > > > > From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > > > 
> > > > > > > > Some of the frames marked as GSO which arrive at
> > > > > > > > virtio_net_hdr_from_skb() have no GSO_TYPE, no
> > > > > > > > fragments (data_len = 0) and length significantly shorter
> > > > > > > > than the MTU (752 in my experiments).
> > > > > > > > 
> > > > > > > > This is observed on raw sockets reading off vEth interfaces
> > > > > > > > in all 4.x and 5.x kernels I tested.
> > > > > > > > 
> > > > > > > > These frames are reported as invalid while they are in fact
> > > > > > > > gso-less frames.
> > > > > > > > 
> > > > > > > > This patch marks the vnet header as no-GSO for them instead
> > > > > > > > of reporting it as invalid.
> > > > > > > > 
> > > > > > > > Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > > > ---
> > > > > > > >     include/linux/virtio_net.h | 8 ++++++--
> > > > > > > >     1 file changed, 6 insertions(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > > > > > index 0d1fe9297ac6..d90d5cff1b9a 100644
> > > > > > > > --- a/include/linux/virtio_net.h
> > > > > > > > +++ b/include/linux/virtio_net.h
> > > > > > > > @@ -112,8 +112,12 @@ static inline int
> > > > > > > > virtio_net_hdr_from_skb(const struct sk_buff *skb,
> > > > > > > >                 hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> > > > > > > >             else if (sinfo->gso_type & SKB_GSO_TCPV6)
> > > > > > > >                 hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> > > > > > > > -        else
> > > > > > > > -            return -EINVAL;
> > > > > > > > +        else {
> > > > > > > > +            if (skb->data_len == 0)
> > > > > > > > +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
> > > > > > > > +            else
> > > > > > > > +                return -EINVAL;
> > > > > > > > +        }
> > > > > > > >             if (sinfo->gso_type & SKB_GSO_TCP_ECN)
> > > > > > > >                 hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
> > > > > > > >         } else
> > > > > > > > 
> > > > > > > 
> > > > > > > ping.
> > > > > > > 
> > > > > > 
> > > > > > Do you mean gso_size is set but gso_type is not? Looks like a bug
> > > > > > elsewhere.
> > > > > > 
> > > > > > Thanks
> > > > > > 
> > > > > > 
> > > > > Yes.
> > > > > 
> > > > > I could not trace it where it is coming from.
> > > > > 
> > > > > I see it when doing recvmmsg on raw sockets in the UML vector network
> > > > > drivers.
> > > > > 
> > > > 
> > > > I think we need to find the culprit and fix it there, lots of other things
> > > > can break otherwise.
> > > > Just printing out skb->dev->name should do the trick, no?
> > > 
> > > The printk in virtio_net_hdr_from_skb says NULL.
> > > 
> > > That is probably normal for a locally originated frame.
> > > 
> > > I cannot reproduce this with network traffic by the way - it happens only if the traffic is locally originated on the host.
> > > 
> > > A,
> > 
> > OK so is it code in __tcp_transmit_skb that sets gso_size to non-null
> > when gso_type is 0?
> 
> It does look like that, but I cannot see it when reading it :(

dump skb pointer at the two locations and see whether it matches :)

> 
> > 
> > 
> > > > 
> > > > 
> > > > > -- 
> > > > > Anton R. Ivanov
> > > > > Cambridgegreys Limited. Registered in England. Company Number 10273661
> > > > > https://www.cambridgegreys.com/
> > > > 
> > > > 
> > > > _______________________________________________
> > > > linux-um mailing list
> > > > linux-um@lists.infradead.org
> > > > http://lists.infradead.org/mailman/listinfo/linux-um
> > > > 
> > > 
> > > -- 
> > > Anton R. Ivanov
> > > Cambridgegreys Limited. Registered in England. Company Number 10273661
> > > https://www.cambridgegreys.com/
> > 
> > 
> 
> -- 
> Anton R. Ivanov
> Cambridgegreys Limited. Registered in England. Company Number 10273661
> https://www.cambridgegreys.com/

