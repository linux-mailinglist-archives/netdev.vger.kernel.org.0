Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1843FE52
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhJ2OWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 10:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJ2OWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 10:22:13 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5436CC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:19:44 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id b17so8300538uas.0
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=La4tP0M+nnhi8waYnrjqdGJjsunXvhEgBrpfo4j3630=;
        b=Cv08/C1AHqhp5HgXJSWQfVm55wALjktLxdkGvZy8FUqAjMD6DRFlm7yq0oZEJK7G8H
         TM8RGXTySMgQcavVwR6JRLyVv9ClzA7DJ6fHKsMUsQHaRNnFWthH9zKLMsri6VZJqz3K
         TLOKbGkOZdCukXTBPbQxZ/lixFnPJowTjmI6YkLxpiqY7FPKJwV1PSszcUXNKneN+v+x
         gmLWk8KE9ZGrBRjTsCglmLavtFSPBLMyVRuLHSld9LY+XOCFPcuEAI5htqJzRWRWuHqz
         /ACXpoidTaywdNfzDOxFg3szLuALw3OH3uZedN93cqCiKTW1zj9gHgn/aCfno/y77oWu
         tFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=La4tP0M+nnhi8waYnrjqdGJjsunXvhEgBrpfo4j3630=;
        b=m0O8UvL7DtIa/Eu6IoXZnRVNgrszn7mK5/SWUnPqng4WqylGzS/aR+264DpxGD3q9/
         YVkkr1oxj9eJAKzO8RdSQl/6RWpuHvc5ilqrzqf6LLf8PGIvyDo5gnJYBNfA5itm5Phv
         fSk69n5fJczebChojE6jRMYkK4sVa8bSJ0kkwBpM+2JfsbMOu57GIS0pd6ekKdOn04n1
         aWaoQf/5itgrP/VYCBDFKBj2+Lz7fS6QQjx+b0Bhq/Bcpu0C49UnOCXGEtlUa2H1jBsk
         a6aP5bxjSttTAJBgDUEbzH/E3JT/aq3yCiZAHJ1i/spg9uUU+FS3or5HCtWDbvzPqNSg
         GuLQ==
X-Gm-Message-State: AOAM530JY8j/KxP4C9uy3nu2kD9aLmmRNIghNNMQwuqkkVrE76JRMLXD
        vRCccWpvVFBmhlip+pW3konEVAg/ZBE=
X-Google-Smtp-Source: ABdhPJwPasbvmCzPTq2d76RPStKwXO7/g9HtaZvlXpiDTlDM2bHMq4gxoGSchYbPw2poF4qejatssQ==
X-Received: by 2002:ab0:26d2:: with SMTP id b18mr12104686uap.53.1635517183510;
        Fri, 29 Oct 2021 07:19:43 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id d128sm943432vsd.20.2021.10.29.07.19.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 07:19:43 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id h133so4670196vke.10
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:19:43 -0700 (PDT)
X-Received: by 2002:a05:6122:98a:: with SMTP id g10mr11917964vkd.17.1635517182626;
 Fri, 29 Oct 2021 07:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <CABcq3pG9GRCYqFDBAJ48H1vpnnX=41u+MhQnayF1ztLH4WX0Fw@mail.gmail.com>
In-Reply-To: <CABcq3pG9GRCYqFDBAJ48H1vpnnX=41u+MhQnayF1ztLH4WX0Fw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Oct 2021 10:19:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfytchd3Fk7=VB-6mTHsdjEjkEEHUFXRg_8ZaZkAyxbrg@mail.gmail.com>
Message-ID: <CA+FuTSfytchd3Fk7=VB-6mTHsdjEjkEEHUFXRg_8ZaZkAyxbrg@mail.gmail.com>
Subject: Re: VirtioNet L3 protocol patch advice request.
To:     Andrew Melnichenko <andrew@daynix.com>
Cc:     davem@davemloft.net, bnemeth@redhat.com,
        gregkh@linuxfoundation.org, Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 6:51 AM Andrew Melnichenko <andrew@daynix.com> wrote:
>
> Hi all,
> Recently I've discovered a patch that added an additional check for the
> protocol in VirtioNet.
> (https://www.spinics.net/lists/kernel/msg3866319.html)
> Currently, that patch breaks UFOv6 support and possible USOv6 support in
> upcoming patches.
> The issue is the code next to the patch expects failure of
> skb_flow_dissect_flow_keys_basic()
> for IPv6 packets to retry it with protocol IPv6.
> I'm not sure about the goals of the patch

A well behaved configuration should not enter that code path to begin
with. GSO packets should also request NEEDS_CSUM, and in normal cases
skb->protocol is set. But packet sockets allow leaving skb->protocol
0, in which case this code tries to infer the protocol from the link
layer header if present and supported, using
dev_parse_header_protocol.

Commit 924a9bc362a5 ("net: check if protocol extracted by
virtio_net_hdr_set_proto is correct") added the
dev_parse_header_protocol check and will drop packets where the GSO
type (e.g., VIRTIO_NET_HDR_GSO_TCPV4) does not match the network
protocol as stores in the link layer header (ETH_P_IPV6, or even
something unrelated like ETH_P_ARP).

You're right that it can drop UFOv6 packets. VIRTIO_NET_HDR_GSO_UDP
has no separate V4 and V6 variants, so we have to accept both
protocols. We need to fix that.

This guess in virtio_net_hdr_set_proto

        case VIRTIO_NET_HDR_GSO_UDP:
                skb->protocol = cpu_to_be16(ETH_P_IP);

might be wrong to assume IPv4 for UFOv6, and then as of that commit
this check will incorrectly drop the packet

                                virtio_net_hdr_set_proto(skb, hdr);
                                if (protocol && protocol != skb->protocol)
                                        return -EINVAL;

> and propose the next solution:
>
> static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
> >                      const struct virtio_net_hdr *hdr)
> > {
> >     __be16 protocol;
> >
> >     protocol = dev_parse_header_protocol(skb);
> >     switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
> >     case VIRTIO_NET_HDR_GSO_TCPV4:
> >         skb->protocol = cpu_to_be16(ETH_P_IP);
> >         break;
> >     case VIRTIO_NET_HDR_GSO_TCPV6:
> >         skb->protocol = cpu_to_be16(ETH_P_IPV6);
> >         break;
> >     case VIRTIO_NET_HDR_GSO_UDP:
> >     case VIRTIO_NET_HDR_GSO_UDP_L4:

Please use diff to show your changes. Also do not mix bug fixes (that
go to net) with new features (that go to net-next).

> >         skb->protocol = protocol;

Not exactly, this would just remove the added verification.

We need something like

@@ -89,8 +92,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
                                __be16 protocol =
dev_parse_header_protocol(skb);

                                virtio_net_hdr_set_proto(skb, hdr);
-                               if (protocol && protocol != skb->protocol)
-                                       return -EINVAL;
+                               if (protocol && protocol != skb->protocol) {
+                                       if (gso_type ==
VIRTIO_NET_HDR_GSO_UDP &&
+                                           protocol == cpu_to_be16(ETH_P_IPV6))
+                                               skb->protocol = protocol;
+                                       else
+                                               return -EINVAL;
+                               }

But preferably less ugly. Your suggestion of moving the
dev_parse_header_protocol step into virtio_net_hdr_to_skb is cleaner.
But also executes this check in the two other callers that may not
need it. Need to double check whether that is correct.
