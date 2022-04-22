Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E539550C2E4
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiDVWoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiDVWoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:44:02 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D38F2BBA1C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:40:27 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id s4so6800989qkh.0
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X3jmrp9pTRv13ERfd24S+BNAmPr2s08tVQATG4YHUlI=;
        b=PeMUPreV4X4m1QbrqoSErYIw7TY5RJtJFjtE3UvbI9L1JGck3l52g90PJqKpnjpsmx
         AM8SY/SgMDx4z+tVUcRPKc1qzvY4v7r/lIvCcQA974wNPSyyEPY9V4pQ8VZ1o9QSNdow
         LQOp2w+WFFa7UE6LV3OR1n3ZdzId36u/hsWhXmE+C77KgXOC5wRRAgOIX3wJ/Os5JCCf
         +HrZRIemdwA2FSOI51ix1h6aNF3vgkSEY4XiNiRPsChiM4v9DHPUxbyvPn6PY7U9LIYe
         GrLZ2cjNFpmq0TXgkXgs3AbY7WgVpMjq8yiNFu3pDAqeiZnRi/MGBF27u5WKHrN+qpGo
         ncdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X3jmrp9pTRv13ERfd24S+BNAmPr2s08tVQATG4YHUlI=;
        b=uQQ5dOFPkAcxEwr01qpTzssCbkHBuJpm76QC2NpqwBfDak9RhaLPzlC4pRHN6AwUZw
         dd9eP5DyVcmIhPXmCIm1uqnHwcqxeZRLTr+TbO9Ip6wok61+wqavmWiOSD217R0VNWnF
         Ae/iAbKXUqZoe/CIeskX9ejW2/N/ehXlvqNLt6T3HCRBzabmSrgwO26GfxMo+zt29PLW
         eHQ3oozLhxOnut5/EBAQH0v3ohDMHGzsEwLWGaB6+cAL4+MBS8mpXumC7qj2DRXrU5Og
         PCTazgml0N/4Dz+8J1HsXQKSIl88G8ksTyCXDvEda0oegSGCmVUrSweFnYeBM7Y35e/d
         Y5+Q==
X-Gm-Message-State: AOAM5327MiW49zLK6Ilwx8HZE8Upzi00hk9dweehe65ZZSBgKFm7sP/2
        tAxqW/YaLOdTfiTqDLv2tyP91NIF7Tw=
X-Google-Smtp-Source: ABdhPJxz6OG6Mg2ggRsBS3/M9v1lmbS5JcYohsASl3+uq111evwENDiiJVgoLjI385G0jy0iXdmGSA==
X-Received: by 2002:a05:620a:280d:b0:67d:2480:fdea with SMTP id f13-20020a05620a280d00b0067d2480fdeamr3940112qkp.157.1650663626285;
        Fri, 22 Apr 2022 14:40:26 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id d9-20020a05620a158900b0069ec88bfc13sm1398904qkk.50.2022.04.22.14.40.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 14:40:26 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id b95so16802015ybi.1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:40:25 -0700 (PDT)
X-Received: by 2002:a25:b94a:0:b0:644:db14:ff10 with SMTP id
 s10-20020a25b94a000000b00644db14ff10mr6458202ybm.648.1650663625249; Fri, 22
 Apr 2022 14:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220420082758.581245-1-liuhangbin@gmail.com> <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
 <YmDCHI330AUfcYKa@Laptop-X1> <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
 <YmIOLBihyeLy+PCS@Laptop-X1>
In-Reply-To: <YmIOLBihyeLy+PCS@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 22 Apr 2022 17:39:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfzcAUXrxzbLd-MPctTyLu8USJQ4gvsqPBfLpA+svYMYA@mail.gmail.com>
Message-ID: <CA+FuTSfzcAUXrxzbLd-MPctTyLu8USJQ4gvsqPBfLpA+svYMYA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 10:10 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Hi Willem,
> On Thu, Apr 21, 2022 at 10:15:16AM -0400, Willem de Bruijn wrote:
> > Your approach does sound simpler than the above. Thanks for looking
> > into that alternative, though.
>
> Sorry I have to bring this topic back. I just remembered that
> tpacket_snd() already called skb_probe_transport_header() before calling
> virtio_net_hdr_* functions. e.g.
>
> - tpacket_snd()
>   - tpacket_fill_skb()
>     - packet_parse_headers()
>       - skb_probe_transport_header()
>   - if (po->has_vnet_hdr)
>     - virtio_net_hdr_to_skb()
>     - virtio_net_hdr_set_proto()
>
> While for packet_snd()
>
> - packet_snd()
>   - if (has_vnet_hdr)
>     - virtio_net_hdr_to_skb()
>     - virtio_net_hdr_set_proto()
>   - packet_parse_headers()
>     - skb_probe_transport_header()
>
> If we split skb_probe_transport_header() from packet_parse_headers() and
> move it before calling virtio_net_hdr_* function in packet_snd(). Should
> we do the same for tpacket_snd(), i.e. move skb_probe_transport_header()
> after the virtio_net_hdr_* function?

That sounds like the inverse: "move after" instead of "move before"?

But I thought the plan was to go back to your last patch which brings
packet_snd in line with tpacket_snd by moving packet_parse_headers in
its entirety before virtio_net_hdr_*?

> I think it really doesn't matter whether calls skb_probe_transport_header()
> before or after virtio_net_hdr_* functions if we could set the skb->protocol
> and network header correctly. Because
>
> - skb_probe_transport_header()
>   - skb_flow_dissect_flow_keys_basic()
>     - __skb_flow_dissect()
>
> In __skb_flow_dissect()
> ```
>  * @data: raw buffer pointer to the packet, if NULL use skb->data
>  * @proto: protocol for which to get the flow, if @data is NULL use skb->protocol
>  * @nhoff: network header offset, if @data is NULL use skb_network_offset(skb)
>  * @hlen: packet header length, if @data is NULL use skb_headlen(skb)
> ```
>
> So when data is NULL, we need to make sure the protocol, network header offset,
> packet header length are correct.
>
> Before this patch, the VLAN packet network header offset is incorrect when calls
> skb_probe_transport_header(). After the fix, this issue should be gone
> and we can call skb_probe_transport_header() safely.
>
> So my conclusion is. There is no need to split packet_parse_headers(). Move
> packet_parse_headers() before calling virtio_net_hdr_* function in packet_snd()
> should be safe.

Ack. Sorry if my last response was not entirely clear on this point.

> Please pardon me if I didn't make something clear.
> Let's me know what do you think.
>
> Thanks
> Hangbin
