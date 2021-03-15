Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844D133C11F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhCOQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbhCOQDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:03:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30B0C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:03:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jt13so67206935ejb.0
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpzSuLMr24ceVXTRfQCZf09xlLfjD5K1IfVDAJ6Jn6A=;
        b=GwguUGQaQ3LYbwnEXFcyjejCNnUmzedQEySZ61MejBS3Lr3jXzUnJlMs9PpGdgZ9rR
         6O+PT0/LrheOb5VtUdexpdrLUzMeeG0reV+jmML2dMpBXsU47jrV3xkhI+CdlJJFReHK
         fryOScM2u1VdS7oWImi/mvMS5ffkoP6sKtEp8HCO7LllFuSpWZouTZQSMgTR929TKB3U
         w2/XAL2BSFv41prmUCti2+wJUi4gC1a+kPuN1bNujQnTrcQv7W9895L7Spi0ygQMGmba
         bIUFw7PIaIU2JaDwVuMo8MuJSxe7KmUPjGoSoH5wkihgjVKtCrxRZER2QBOw2iDW6nzp
         LWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpzSuLMr24ceVXTRfQCZf09xlLfjD5K1IfVDAJ6Jn6A=;
        b=llXv59MO4ARp5MS5tWEFs71hEIxqPeEmgTEReklbkTMjYjz56mt2hhP4+2lxfMSRzj
         ZvPozK1mhRMr7w8S9Pz+HBR80ZBOGeKG+cQojGv111cSTTGHtBZ4ZgdqK+hhROkBHJcT
         n6DpCxfTtReV8kmz1HWW7d2jqCsb3HHrHDSAUfrhSWXUHm5KMxODzBdpr4iRr/TH+4Eg
         AXk96tePYeioskBKgy2RAiE1y2mkxY7wVSmQ8rGjyNif6iKo0yrmmwBc2FW1R6zIJwgw
         84GQfT3tcXVP+xwF3ERm4x6svR5rVHEhRZSmeb3//UFlVT0dLIEWRlyhpfTCh3rNBDzp
         1Xkw==
X-Gm-Message-State: AOAM532K8F5LOfstCyISzVWuCp44umaenaAWG5fGZdATSlAqGeJ0l2pY
        hsc91bJZEygRayopCcRk8iQa618d43A=
X-Google-Smtp-Source: ABdhPJxyJG1RThrKPj08zVzwcp4XwX605WzAI6+I6YtJBHJ5igZETvxyrODaOmE5zd1S/xCOEtIyGA==
X-Received: by 2002:a17:906:558:: with SMTP id k24mr24558787eja.387.1615824202057;
        Mon, 15 Mar 2021 09:03:22 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id n16sm8492729edr.42.2021.03.15.09.03.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 09:03:21 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id 12so3414960wmf.5
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:03:21 -0700 (PDT)
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr369315wmg.87.1615824201330;
 Mon, 15 Mar 2021 09:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210313063535.38608-1-ishaangandhi@gmail.com>
In-Reply-To: <20210313063535.38608-1-ishaangandhi@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 15 Mar 2021 12:02:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSezOVa2rfvgFx7gfYXsxg-6k0QUAe32o_MSUJ0b_-R3zw@mail.gmail.com>
Message-ID: <CA+FuTSezOVa2rfvgFx7gfYXsxg-6k0QUAe32o_MSUJ0b_-R3zw@mail.gmail.com>
Subject: Re: [PATCH v2] icmp: support rfc5837
To:     ishaangandhi <ishaangandhi@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 1:35 AM ishaangandhi <ishaangandhi@gmail.com> wrote:
>
> From: Ishaan Gandhi <ishaangandhi@gmail.com>
>
> This patch identifies the interface a packet arrived on when sending
> ICMP time exceeded, destination unreachable, and parameter problem
> messages, in accordance with RFC 5837.
>
> It was tested by pinging a machine with a ttl of 1, and observing the
> response in Wireshark.
>
> Changes since v1:
> - Add sysctls, feature is disabled by default
> - Device name is always less than 63, so don't check this
> - MTU is always included in net_device, so don't check its presence
> - Support IPv6 as first class citizen
> - Increment lengths via sizeof operator as opposed to int literals
> - Initialize more local variables with defaults
>
> Change request still unaddressed:
> - Willem pointed out yesterday that `skb_iif` is not guaranteed
> to be the iif of the device the packet arrived on. To get around this
> I propose adding a `skb_orig_iif` field to sk_buff which will remain
> unchanged after rounds. Would this be ok?

There is no space to extend struct sk_buff, unfortunately.

Perhaps it is possible to inspect the skb->dev and infer whether that
is a physical (i.e., orig_iif) device.

> +icmp_errors_identify_if - BOOLEAN
> +
> +       If set non-zero, then the kernel will append an extension

"If 1, .." see also comment on proc_dointvec_minmax.

> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 9e36738c1fe1..fd68a47f1130 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -90,6 +90,7 @@ struct netns_ipv4 {
>         int sysctl_icmp_ratelimit;
>         int sysctl_icmp_ratemask;
>         int sysctl_icmp_errors_use_inbound_ifaddr;
> +       int sysctl_icmp_errors_identify_if;

per-netns is a prime example of why skb_iif is overwritten in each
__netif_receive_skb_core iteration.

In a containerized setting, the response is probably expected to come
from the container device, not the physical nic.


> +/*  Appends interface identification object to ICMP packet to identify
> + *  the interface on which the original datagram arrived, per RFC 5837.
> + *
> + *  Should only be called on the following messages
> + *  - ICMPv4 Time Exceeded
> + *  - ICMPv4 Destination Unreachable
> + *  - ICMPv4 Parameter Problem
> + *  - ICMPv6 Time Exceeded
> + *  - ICMPv6 Destination Unreachable
> + */
> +
> +void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
> +                                    char *icmph, int ip_version)
> +{
> +       unsigned int ext_len, orig_len, word_aligned_orig_len, offset, extra_space_needed,
> +                    if_index, mtu = 0, name_len = 0, name_subobj_len = 0;
> +       struct interface_ipv4_addr_sub_obj ip4_addr_subobj = {.addr = 0};
> +       struct interface_ipv6_addr_sub_obj ip6_addr_subobj;
> +       struct icmp_extobj_hdr *iio_hdr;
> +       struct inet6_ifaddr ip6_ifaddr;
> +       struct inet6_dev *dev6 = NULL;
> +       struct icmp_ext_hdr *ext_hdr;
> +       char *name = NULL, ctype;
> +       struct net_device *dev;
> +       void *subobj_offset;
> +
> +       if (ip_version != 4 && ip_version != 6) {
> +               pr_debug("ip_version must be 4 or 6\n");
> +               return;
> +       }

always true

> +       skb_linearize(skb);
> +       if_index = inet_iif(skb);
> +       orig_len = skb->len - skb_network_offset(skb);
> +
> +       // IPv4 messages MUST be 32-bit aligned, IPv6 64-bit aligned
> +       if (ip_version == 4) {
> +               word_aligned_orig_len = (orig_len + 3) & ~0x03;
> +               icmph[6] = word_aligned_orig_len / 4;
> +       } else {
> +               word_aligned_orig_len = (orig_len + 7) & ~0x07;
> +               icmph[5] = word_aligned_orig_len / 8;

for alignment, see ALIGN

> +       }
> +
> +       ctype = ICMP_5837_ARRIVAL_ROLE_CTYPE;
> +       ext_len = sizeof(struct icmp_ext_hdr) + sizeof(struct icmp_extobj_hdr);
> +
> +       // Always add if_index to the IIO
> +       ext_len += sizeof(__be32);
> +       ctype |= ICMP_5837_IF_INDEX_CTYPE;
> +
> +       dev = dev_get_by_index(net, if_index);
> +       // Try to append IP address, name, and MTU
> +       if (dev) {

I think this is always true, but I see the same check in icmp6_send,
so I might be wrong. Good to have as is, then.

> +               if (ip_version == 4) {
> +                       ip4_addr_subobj.addr = inet_select_addr(dev, 0, RT_SCOPE_UNIVERSE);
> +                       if (ip4_addr_subobj.addr) {
> +                               ip4_addr_subobj.afi = htons(1);
> +                               ip4_addr_subobj.reserved = 0;
> +                               ctype |= ICMP_5837_IP_ADDR_CTYPE;
> +                               ext_len += sizeof(ip4_addr_subobj);
> +                       }
> +               }
> +               if (ip_version == 6) {
> +                       dev6 = in6_dev_get(dev);
> +                       if (dev6) {
> +                               ip6_ifaddr = *list_last_entry(&dev6->addr_list,
> +                                                             struct inet6_ifaddr, if_list);

Why is the last entry the right one? Not criticism, I honestly don't
know the order.

> +                               memcpy(ip6_addr_subobj.addr, ip6_ifaddr.addr.s6_addr32,
> +                                      sizeof(ip6_addr_subobj.addr));
> +                               ip6_addr_subobj.afi = htons(2);
> +                               ip6_addr_subobj.reserved = 0;
> +                               ctype |= ICMP_5837_IP_ADDR_CTYPE;
> +                               ext_len += sizeof(ip6_addr_subobj);
> +                       }
> +               }
> +
> +               name = dev->name;
> +               if (name) {

always true

> +                       name_len = strlen(name);
> +                       // 1 extra byte for the length field
> +                       name_subobj_len = name_len + 1;
> +                       // Sub-objects must be aligned to 32-bits
> +                       name_subobj_len = (name_subobj_len + 3) & ~0x03;
> +                       ctype |= ICMP_5837_NAME_CTYPE;
> +                       ext_len += name_subobj_len;
> +               }
> +
> +               mtu = dev->mtu;
> +               ctype |= ICMP_5837_MTU_CTYPE;
> +               ext_len += sizeof(__be32);
> +       }
> +
> +       if (word_aligned_orig_len + ext_len > room) {
> +               offset = room - ext_len;
> +               extra_space_needed = room - orig_len;
> +       } else if (orig_len < ICMP_5837_MIN_ORIG_LEN) {
> +               // Original packet must be zero padded to 128 bytes
> +               offset = ICMP_5837_MIN_ORIG_LEN;
> +               extra_space_needed = offset + ext_len - orig_len;
> +       } else {
> +               // There is enough room to just add to the end of the packet
> +               offset = word_aligned_orig_len;
> +               extra_space_needed = ext_len;
> +       }
> +
> +       if (skb_tailroom(skb) < extra_space_needed) {
> +               if (pskb_expand_head(skb, 0, extra_space_needed - skb_tailroom(skb), GFP_ATOMIC))
> +                       return;
> +       }
> +
> +       // Zero-pad from the end of the original message to the beginning of the header
> +       if (orig_len < ICMP_5837_MIN_ORIG_LEN) {
> +               // Original packet must be zero-padded to 128 bytes
> +               memset(skb_network_header(skb) + orig_len, 0, ICMP_5837_MIN_ORIG_LEN - orig_len);
> +       } else {
> +               // Just zero-pad so the original packet is word aligned
> +               memset(skb_network_header(skb) + orig_len, 0, word_aligned_orig_len - orig_len);
> +       }
> +
> +       skb_put(skb, extra_space_needed);
> +       ext_hdr = (struct icmp_ext_hdr *)(skb_network_header(skb) + offset);
> +       iio_hdr = (struct icmp_extobj_hdr *)(ext_hdr + 1);
> +       subobj_offset = (void *)(iio_hdr + 1);
> +
> +       ext_hdr->reserved1 = 0;
> +       ext_hdr->reserved2 = 0;
> +       ext_hdr->version = 2;
> +       ext_hdr->checksum = 0;
> +
> +       iio_hdr->length = htons(ext_len - sizeof(struct icmp_ext_hdr));
> +       iio_hdr->class_num = 2;
> +       iio_hdr->class_type = ctype;
> +
> +       *(__be32 *)subobj_offset = htonl(if_index);
> +       subobj_offset += sizeof(__be32);
> +
> +       if (ip4_addr_subobj.addr) {
> +               *(struct interface_ipv4_addr_sub_obj *)subobj_offset = ip4_addr_subobj;
> +               subobj_offset += sizeof(ip4_addr_subobj);
> +       }
> +
> +       if (dev6) {
> +               *(struct interface_ipv6_addr_sub_obj *)subobj_offset = ip6_addr_subobj;
> +               subobj_offset += sizeof(ip6_addr_subobj);
> +       }
> +
> +       if (name) {
> +               *(__u8 *)subobj_offset = name_subobj_len;
> +               subobj_offset += sizeof(__u8);
> +               memcpy(subobj_offset, name, name_len);
> +               memset(subobj_offset + name_len, 0, name_subobj_len - (name_len + sizeof(__u8)));
> +               subobj_offset += name_subobj_len - sizeof(__u8);
> +       }
> +
> +       if (mtu) {
> +               *(__be32 *)subobj_offset = htonl(mtu);
> +               subobj_offset += sizeof(__be32);
> +       }

> @@ -628,6 +628,13 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec
>         },
> +       {
> +               .procname       = "icmp_errors_identify_if",
> +               .data           = &init_net.ipv4.sysctl_icmp_errors_identify_if,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec

procdointvec_minmax with zero and one. This allows future refinements,
if necessary.

See also another ICMP patchset in review:

https://patchwork.kernel.org/project/netdevbpf/list/?series=447825&archive=both&state=*
