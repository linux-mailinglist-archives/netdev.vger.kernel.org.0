Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BEC15C524
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbgBMPxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:53:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388059AbgBMPxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581609215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FkWdFXSGm8nRf/G4t6XQozUjKUXP7Krdr59zDr+Cjw=;
        b=gBl+ut21WhW/bOBDWFonkIWdQiR9tv0EcGB7BBNxiOCUCJ/NDnWAuLscPYpBLOIWwXlhEI
        Ja16R4LyqmEBaH32ZpiUlRfj+f3efkck9bYDp1A3/JozkTZW9HhVjgRXcgtZe9g0qkiR8v
        uO1RhELPAkapUE9BB4p370yc0WnkOR4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-ZbFlUmSUNb-Rz46GVXV3uw-1; Thu, 13 Feb 2020 10:53:31 -0500
X-MC-Unique: ZbFlUmSUNb-Rz46GVXV3uw-1
Received: by mail-qv1-f70.google.com with SMTP id v3so3777657qvm.2
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:53:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3FkWdFXSGm8nRf/G4t6XQozUjKUXP7Krdr59zDr+Cjw=;
        b=jPgj2pU9d+PNJlq5J4JfnPFvOu3PtmsrU4jYQXqbjfj6vUPcdhgoA6T9ryQ6LqeGGR
         yI+yHDO/1MQsMgO18UppvuYPcL8XE9TrkbCIUfbOfgcMkWHGLwgj41OJY2mkL6yF4huL
         J4JjN8Cv6u+Kdguft9UBEuN9MT7PAS7d90nBhThOFv0vOaomHQgWW/iz6xq77tMd04DD
         tREahQK4vvoWd9g0ciEO/wwhVFoSxHh670ADKQveaP4lh0OTO0DVgTSUD0oWNSYlatJo
         hTq219RWNscGnrkZYayhGEkezf+7c+XKU0+B881cI4XLUJvPkXRLCABqK0XpUqYR4wlQ
         su3w==
X-Gm-Message-State: APjAAAVejr2M8EDjPPp49EUEO30mgPZ73hhWgZiz78lHcVEAW+6O7Q8W
        FJmA4fZojlRSiwtQaIaH0Sr/+aiZ9dlbj7381brebDbMgZz5Mg8mYB1deQUaRgDtQEa/z0nxFvH
        7CLCVIssZ/dZgfJyB
X-Received: by 2002:ae9:e88e:: with SMTP id a136mr172040qkg.71.1581609210920;
        Thu, 13 Feb 2020 07:53:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxik+NUrSDUNwyo9OGo5sO0s3wLTjJedNNG8mgbQZB+akZZDVEf2GTRfMcPb1EYKXHzYpEcoQ==
X-Received: by 2002:ae9:e88e:: with SMTP id a136mr172018qkg.71.1581609210635;
        Thu, 13 Feb 2020 07:53:30 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id l6sm1651426qti.10.2020.02.13.07.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:53:29 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:53:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200213105010-mutt-send-email-mst@kernel.org>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
 <20200213045937-mutt-send-email-mst@kernel.org>
 <94fb9656-99ee-a001-e428-9d76c3620e61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94fb9656-99ee-a001-e428-9d76c3620e61@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 07:44:06AM -0800, Eric Dumazet wrote:
> 
> 
> On 2/13/20 2:00 AM, Michael S. Tsirkin wrote:
> > On Wed, Feb 12, 2020 at 05:38:09PM +0000, Anton Ivanov wrote:
> >>
> >>
> >> On 11/02/2020 10:37, Michael S. Tsirkin wrote:
> >>> On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
> >>>> On 11/02/2020 02:51, Jason Wang wrote:
> >>>>>
> >>>>> On 2020/2/11 上午12:55, Anton Ivanov wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
> >>>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> >>>>>>>
> >>>>>>> Some of the frames marked as GSO which arrive at
> >>>>>>> virtio_net_hdr_from_skb() have no GSO_TYPE, no
> >>>>>>> fragments (data_len = 0) and length significantly shorter
> >>>>>>> than the MTU (752 in my experiments).
> >>>>>>>
> >>>>>>> This is observed on raw sockets reading off vEth interfaces
> >>>>>>> in all 4.x and 5.x kernels I tested.
> >>>>>>>
> >>>>>>> These frames are reported as invalid while they are in fact
> >>>>>>> gso-less frames.
> >>>>>>>
> >>>>>>> This patch marks the vnet header as no-GSO for them instead
> >>>>>>> of reporting it as invalid.
> >>>>>>>
> >>>>>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> >>>>>>> ---
> >>>>>>>    include/linux/virtio_net.h | 8 ++++++--
> >>>>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> >>>>>>> index 0d1fe9297ac6..d90d5cff1b9a 100644
> >>>>>>> --- a/include/linux/virtio_net.h
> >>>>>>> +++ b/include/linux/virtio_net.h
> >>>>>>> @@ -112,8 +112,12 @@ static inline int
> >>>>>>> virtio_net_hdr_from_skb(const struct sk_buff *skb,
> >>>>>>>                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> >>>>>>>            else if (sinfo->gso_type & SKB_GSO_TCPV6)
> >>>>>>>                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> >>>>>>> -        else
> >>>>>>> -            return -EINVAL;
> >>>>>>> +        else {
> >>>>>>> +            if (skb->data_len == 0)
> >>>>>>> +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
> >>>>>>> +            else
> >>>>>>> +                return -EINVAL;
> >>>>>>> +        }
> >>>>>>>            if (sinfo->gso_type & SKB_GSO_TCP_ECN)
> >>>>>>>                hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
> >>>>>>>        } else
> >>>>>>>
> >>>>>>
> >>>>>> ping.
> >>>>>>
> >>>>>
> >>>>> Do you mean gso_size is set but gso_type is not? Looks like a bug
> >>>>> elsewhere.
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>>
> >>>> Yes.
> >>>>
> >>>> I could not trace it where it is coming from.
> >>>>
> >>>> I see it when doing recvmmsg on raw sockets in the UML vector network
> >>>> drivers.
> >>>>
> >>>
> >>> I think we need to find the culprit and fix it there, lots of other things
> >>> can break otherwise.
> >>> Just printing out skb->dev->name should do the trick, no?
> >>
> >> The printk in virtio_net_hdr_from_skb says NULL.
> >>
> >> That is probably normal for a locally originated frame.
> >>
> >> I cannot reproduce this with network traffic by the way - it happens only if the traffic is locally originated on the host.
> >>
> >> A,
> > 
> > OK so is it code in __tcp_transmit_skb that sets gso_size to non-null
> > when gso_type is 0?
> >
> 
> Correct way to determine if a packet is a gso one is by looking at gso_size.
> Then only it is legal looking at gso_type
> 
> 
> static inline bool skb_is_gso(const struct sk_buff *skb)
> {
>     return skb_shinfo(skb)->gso_size;
> }
> 
> /* Note: Should be called only if skb_is_gso(skb) is true */
> static inline bool skb_is_gso_v6(const struct sk_buff *skb)
> ...
> 
> 
> There is absolutely no relation between GSO and skb->data_len, skb can be linearized
> for various orthogonal reasons.

The reported problem is that virtio gets a packet where gso_size
is !0 but gso_type is 0.

It currently drops these on the assumption that it's some type
of a gso packet it does not know how to handle.


So you are saying if skb_is_gso we can still have gso_type set to 0,
and that's an expected configuration?

So the patch should just be:


-        if (skb_is_gso(skb)) {
+        if (skb_is_gso(skb) && sinfo->gso_type) {



?

