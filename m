Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8C4509C0
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhKOQiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhKOQh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:37:56 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED905C061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:34:55 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id s17so2402501vka.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VZxSbYl5jQSt8wP2WiEBDzWy0O0u/xAxqhCPrf7Lr/o=;
        b=iCS17978TSzIQAa0BVPeYfWl+7UloyD5JoRTt4zIwhZyL0g4q+bymce0OmcdgeAXMV
         9kIvfKFWP/yGmqmUAwMpCL1AFf61uZj8A+jvP6wsbTn0vRYmF2VjYJTwZuDRxndPVsAP
         +nKR4RRTl13Sx9d1IrG571PkZQL/t2SbMzYzzX+5JvJjiS1CUMHBew5CV2sFXmL6nXNH
         0WLmM0LpUg/iD/brXqL1glozQ0dUoZMoCsWLx/dvUd+JbnmE6Fxipcz4Gzy8TOHMGcvJ
         4vh98FTvHaKNA9HQ998z9vyeMSXc3/JeyuoAC1UKYUKBmm6KJCJF+nUu0Ztpm4ta97T6
         UKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VZxSbYl5jQSt8wP2WiEBDzWy0O0u/xAxqhCPrf7Lr/o=;
        b=ixb2JDXM2n/3sugueDAN+wGLNG00976zpK4MhgffIvurC/XsWEPRa6zB/sQyqk5MmT
         KMu7A2jB5Z2iiCiBvD4wMbfQ+x9JB2oJq5Sh2pa2GTi6xdx2TQTVLrfyIRlCsnpCMYml
         SCW3kWrY4XpTdI+GDpKMjX9rIZfgVDY3co3DLEcUZMbxIClyDZDU6hixA66XBbiAp9nG
         NiH7kTjYzU5Ct2kLcOcQtxMqMJXbnV4M3mpbb5xgSXRibmlIUhqXqqN4flkYZ5OHRnTl
         tCmI1E/vj2ikYEdE/eVhEWV4kHSoTvOdvJxlFeBbaMYOEU73GWPzNhNsv2DJtlx2CE3c
         oPsA==
X-Gm-Message-State: AOAM530im1p3uRdWfLABuz4ILkY0KNz68aMFef9Da0K+3AvRAOpxqeIc
        lbM+veEEPWvR0DftybamEmMz0Tz4wOF3Pg==
X-Google-Smtp-Source: ABdhPJzgIIEic5A2KnBVQwSTyafdsYL2ET50wXRFuWn5MV3oBQ896FKv/8KMcCgzBbdq0fnXszMbSg==
X-Received: by 2002:a05:6122:1788:: with SMTP id o8mr60622390vkf.8.1636994095107;
        Mon, 15 Nov 2021 08:34:55 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id u145sm10028384vsu.25.2021.11.15.08.34.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 08:34:54 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id o1so3268324uap.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:34:54 -0800 (PST)
X-Received: by 2002:a05:6102:38d4:: with SMTP id k20mr45378060vst.42.1636994094206;
 Mon, 15 Nov 2021 08:34:54 -0800 (PST)
MIME-Version: 1.0
References: <20211115151618.126875-1-jonathan.davies@nutanix.com>
In-Reply-To: <20211115151618.126875-1-jonathan.davies@nutanix.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 15 Nov 2021 17:34:17 +0100
X-Gmail-Original-Message-ID: <CA+FuTScqWToamoOqAWkf1VbzYnjoM-y+-rQe_wEkPmBsOZbsLA@mail.gmail.com>
Message-ID: <CA+FuTScqWToamoOqAWkf1VbzYnjoM-y+-rQe_wEkPmBsOZbsLA@mail.gmail.com>
Subject: Re: [PATCH net] net: virtio_net_hdr_to_skb: count transport header in UFO
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     netdev@vger.kernel.org, Florian Schmidt <flosch@nutanix.com>,
        Thilak Raj Surendra Babu <thilakraj.sb@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 4:16 PM Jonathan Davies
<jonathan.davies@nutanix.com> wrote:
>
> virtio_net_hdr_to_skb does not set the skb's gso_size and gso_type
> correctly for UFO packets received via virtio-net that are a little over
> the GSO size. This can lead to problems elsewhere in the networking
> stack, e.g. ovs_vport_send dropping over-sized packets if gso_size is
> not set.
>
> This is due to the comparison
>
>   if (skb->len - p_off > gso_size)
>
> not properly accounting for the transport layer header.
>
> p_off includes the size of the transport layer header (thlen), so
> skb->len - p_off is the size of the TCP/UDP payload.
>
> gso_size is read from the virtio-net header. For UFO, fragmentation
> happens at the IP level so does not need to include the UDP header.
>
> Hence the calculation could be comparing a TCP/UDP payload length with
> an IP payload length, causing legitimate virtio-net packets to have
> lack gso_type/gso_size information.
>
> Example: a UDP packet with payload size 1473 has IP payload size 1481.
> If the guest used UFO, it is not fragmented and the virtio-net header's
> flags indicate that it is a GSO frame (VIRTIO_NET_HDR_GSO_UDP), with
> gso_size = 1480 for an MTU of 1500.  skb->len will be 1515 and p_off
> will be 42, so skb->len - p_off = 1473.  Hence the comparison fails, and
> shinfo->gso_size and gso_type are not set as they should be.
>
> Instead, add the UDP header length before comparing to gso_size when
> using UFO. In this way, it is the size of the IP payload that is
> compared to gso_size.
>
> Fixes: 6dd912f8 ("net: check untrusted gso_size at kernel entry")
> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>

Thanks for the fix, and the detailed explanation of the bug.

Reviewed-by: Willem de Bruijn <willemb@google.com>

> ---
>  include/linux/virtio_net.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index b465f8f..bea56af 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -122,8 +122,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                 u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
>                 struct skb_shared_info *shinfo = skb_shinfo(skb);
>
> -               /* Too small packets are not really GSO ones. */
> -               if (skb->len - p_off > gso_size) {
> +               /* Too small packets are not really GSO ones.
> +                * UFO may not include transport header in gso_size.
> +                */
> +               if (gso_type & SKB_GSO_UDP && skb->len - p_off + thlen > gso_size ||
> +                   skb->len - p_off > gso_size) {

Perhaps for readability instead something like

  unsigned int nh_off = p_off;

  if (gso_type & SKB_GSO_UDP)
    nh_off -= thlen;




>                         shinfo->gso_size = gso_size;
>                         shinfo->gso_type = gso_type;
>
> --
> 2.9.3
>
