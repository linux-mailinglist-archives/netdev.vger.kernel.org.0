Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFDF9EAF5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfH0O1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:27:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37944 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfH0O1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 10:27:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id w11so11416977plp.5
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 07:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=3xSWWMcZwXtfKFj20ZTqCr2MvVcUTR7AHkSOi8NosQQ=;
        b=AXS6+GbSPFMDjs6IzGnpfBDLK/EP6Gi+0p9TA5PdDh9O+oxoZr1PtzGSdWfUga1eIo
         K4RyUfCBPnAoyZy2h0JBp2qFFpJ8oxHwuTHv+VTxqY0/msbIz5IInWwXVtZGeMtTnVlA
         KF3VSQ1YyFdjWoiNWVB+KYpEG2DxmsLO+cj4HPNT7G+cuJQZu95UG8bMLrEw54DhfGo0
         8A2+1/9JCeRldVvqJ8GsUWL67c378Vnb9e0sZ1gfSWL3kMs2Q8PRlF1JRHweHIhrFVxY
         AB+/1y2Nn8oH5ydpgfkUuO7Q0KpbooiXiPWNNQxXc+vYXpGWJZUpXHt2z7WE6kVQzhsc
         BnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3xSWWMcZwXtfKFj20ZTqCr2MvVcUTR7AHkSOi8NosQQ=;
        b=HtK5FbB66QvCbPLum4d3zEFGd6uVf77f00nrTIdUqlVkNQh5kylDl/lSgpmkEhNSDX
         RidNT2Kc3e05V2a+SWoMJ9eVDpm2yWT/VGxRca+z5yTs7+KKE2Wia5d2dd9UNOsivyKa
         97iHD2obidCt0+x75FZM9ctZ28fqT+JQJpBjAMT7rTA/b092zHejQ6SQIjCErHBTyMln
         QsZhqWLYuBTkncLd/mkMtSVwZOy0r2x/Cj34+Sofh8PP1ezx7wRl5SPVMLEjCFG29hXg
         CP5MVR/p1FqHHgNVEmzW88q3A1AyES3uDrW5BvEZANYif/TbHHewIHz3ot/J3bORVUUK
         oI0w==
X-Gm-Message-State: APjAAAWJTb16/RccstGu92AjVlljbnO1432Dk6KOT1nsxO8cZeqIPMTG
        tHzUJfa57KX87iio/vH9oGaID9rw
X-Google-Smtp-Source: APXvYqzpq3ubolEhTZNPxhsO0SugKHwD/tDmhWiJ7lfufl23WIbYA8+oXfJ/En52NXm7HqFuqvB/tg==
X-Received: by 2002:a17:902:7c8b:: with SMTP id y11mr2015612pll.259.1566916066902;
        Tue, 27 Aug 2019 07:27:46 -0700 (PDT)
Received: from [192.168.0.16] (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id y128sm21218527pgy.41.2019.08.27.07.27.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 07:27:46 -0700 (PDT)
Subject: Re: [PATCH V2 net 1/2] openvswitch: Properly set L4 keys on "later"
 IP fragments
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
References: <1566852359-8028-1-git-send-email-gvrose8192@gmail.com>
 <CAOrHB_B3MZF4UyZgemTYr1uG0bEg0La6ShsJ8hpeVSvjceDdEA@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <2730fb7f-3316-a04e-b8d2-99a5bbd5e085@gmail.com>
Date:   Tue, 27 Aug 2019 07:27:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_B3MZF4UyZgemTYr1uG0bEg0La6ShsJ8hpeVSvjceDdEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/26/2019 10:13 PM, Pravin Shelar wrote:
> On Mon, Aug 26, 2019 at 1:46 PM Greg Rose <gvrose8192@gmail.com> wrote:
>> When IP fragments are reassembled before being sent to conntrack, the
>> key from the last fragment is used.  Unless there are reordering
>> issues, the last fragment received will not contain the L4 ports, so the
>> key for the reassembled datagram won't contain them.  This patch updates
>> the key once we have a reassembled datagram.
>>
>> The handle_fragments() function works on L3 headers so we pull the L3/L4
>> flow key update code from key_extract into a new function
>> 'key_extract_l3l4'.  Then we add a another new function
>> ovs_flow_key_update_l3l4() and export it so that it is accessible by
>> handle_fragments() for conntrack packet reassembly.
>>
>> Co-authored by: Justin Pettit <jpettit@ovn.org>
>> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
>> ---
>>   net/openvswitch/conntrack.c |   5 ++
>>   net/openvswitch/flow.c      | 161 ++++++++++++++++++++++++++------------------
>>   net/openvswitch/flow.h      |   1 +
>>   3 files changed, 101 insertions(+), 66 deletions(-)
>>
> ...
> ...
>> +/**
>> + * key_extract - extracts a flow key from an Ethernet frame.
>> + * @skb: sk_buff that contains the frame, with skb->data pointing to the
>> + * Ethernet header
>> + * @key: output flow key
>> + *
>> + * The caller must ensure that skb->len >= ETH_HLEN.
>> + *
>> + * Returns 0 if successful, otherwise a negative errno value.
>> + *
>> + * Initializes @skb header fields as follows:
>> + *
>> + *    - skb->mac_header: the L2 header.
>> + *
>> + *    - skb->network_header: just past the L2 header, or just past the
>> + *      VLAN header, to the first byte of the L2 payload.
>> + *
>> + *    - skb->transport_header: If key->eth.type is ETH_P_IP or ETH_P_IPV6
>> + *      on output, then just past the IP header, if one is present and
>> + *      of a correct length, otherwise the same as skb->network_header.
>> + *      For other key->eth.type values it is left untouched.
>> + *
>> + *    - skb->protocol: the type of the data starting at skb->network_header.
>> + *      Equals to key->eth.type.
>> + */
>> +static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
>> +{
>> +       struct ethhdr *eth;
>> +
>> +       /* Flags are always used as part of stats */
>> +       key->tp.flags = 0;
>> +
>> +       skb_reset_mac_header(skb);
>> +
>> +       /* Link layer. */
>> +       clear_vlan(key);
>> +       if (ovs_key_mac_proto(key) == MAC_PROTO_NONE) {
>> +               if (unlikely(eth_type_vlan(skb->protocol)))
>> +                       return -EINVAL;
>> +
>> +               skb_reset_network_header(skb);
>> +               key->eth.type = skb->protocol;
>> +       } else {
>> +               eth = eth_hdr(skb);
>> +               ether_addr_copy(key->eth.src, eth->h_source);
>> +               ether_addr_copy(key->eth.dst, eth->h_dest);
>> +
>> +               __skb_pull(skb, 2 * ETH_ALEN);
>> +               /* We are going to push all headers that we pull, so no need to
>> +                * update skb->csum here.
>> +                */
>> +
>> +               if (unlikely(parse_vlan(skb, key)))
>> +                       return -ENOMEM;
>> +
>> +               key->eth.type = parse_ethertype(skb);
>> +               if (unlikely(key->eth.type == htons(0)))
>> +                       return -ENOMEM;
>> +
>> +               /* Multiple tagged packets need to retain TPID to satisfy
>> +                * skb_vlan_pop(), which will later shift the ethertype into
>> +                * skb->protocol.
>> +                */
>> +               if (key->eth.cvlan.tci & htons(VLAN_CFI_MASK))
>> +                       skb->protocol = key->eth.cvlan.tpid;
>> +               else
>> +                       skb->protocol = key->eth.type;
>> +
>> +               skb_reset_network_header(skb);
>> +               __skb_push(skb, skb->data - skb_mac_header(skb));
>> +       }
>> +
>> +       skb_reset_mac_len(skb);
>> +
>> +       /* Fill out L3/L4 key info, if any */
>> +       return key_extract_l3l4(skb, key);
>> +}
>> +
>> +/* In the case of conntrack fragment handling it expects L3 headers,
>> + * add a helper.
>> + */
>> +int ovs_flow_key_update_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
>> +{
>> +       int res;
>> +
>> +       res = key_extract_l3l4(skb, key);
>> +       if (!res)
>> +               key->mac_proto &= ~SW_FLOW_KEY_INVALID;
>> +
> Since this is not full key extract, this flag can not be unset.
>
> Otherwise looks good.

Thanks Pravin,

I'll send along a V3 patch set with that change.

- Greg
