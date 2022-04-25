Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E8D50E256
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiDYNxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiDYNxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:53:30 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64904C41B
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:50:21 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id a186so10749437qkc.10
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQaUkr3WtXeM4l+yYw+D+Lve0rcRfEc1HUSwqSzmCAQ=;
        b=FwFguEWD2isc8P8+8JB8YRZdcap8E4bX5IIr9+a5+3Gy2XIZAZtkiXSL6M635d7o3k
         2YuIzbyNt8T1SYYVnFE0R1himDAcqrW42Ttk29YAvnzk+qRlRCEktxgzpHchZhX5tmnn
         tilf06W1xD6z9yAwy9EPBC0lZR7cNAixMcotIa21Fmw7GA2kCGvVKkPBAsfdkMwTITDe
         iyVe/89lFJAk1ZaXFsfXDsDcZZ348FupmYaWTNWEwVGkPektVMoMepvVvnDXqwDiOxF3
         wHqRBzKqWF4yBP/KwWo5qEGO7VTYbJLXDlKJoCfUzdi+hjel1Q5yWgDiwZ4lJolVHzKu
         8ohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQaUkr3WtXeM4l+yYw+D+Lve0rcRfEc1HUSwqSzmCAQ=;
        b=TB/tYl3X/h1z72UUg/3MV6fisDRndXAE3RA6EA77acdxtnfKu06cz49XsLeOOb72uN
         urxPHDy8kWpKXoXht3QUtzxliSaUywa8cEbJ1soPZxSriWKhMCqx4hC47H4GuPV6NXVS
         gZ/OMfhctNo6oLHj+8WENIzNUeICjgO9VXB2ezMeintGb1vU/ucH+vYbxkfrckVKbVY0
         crVXKWmXoe5n5VdBcn8mDeNA3mJSEBydlQ79gchK8pzwAR/u9Zcme5xTRTz/m16xXMmW
         7H1WiORFwXPaM6KNgbNjhKksM2yx52fo0AJffmcnT+ZBQtYt9T9/aarcDsQ1gLAW6QeO
         2uJA==
X-Gm-Message-State: AOAM530NqH07yvsBQgIiQY11O4YJ7Qehy0P/lpJcJrJBhdW6e0V8aHxt
        f/1OlMvlb1evn8UtY7jKm2Mp/LelqzM=
X-Google-Smtp-Source: ABdhPJwnWfBX8Hh64aMzOALQ2X3rsJDcnh3itwsmjPsSPDTGXmgxtqFKmb6hOqVi1iyhDQqT/YH4zg==
X-Received: by 2002:a05:620a:1925:b0:69e:b500:5f41 with SMTP id bj37-20020a05620a192500b0069eb5005f41mr10077218qkb.579.1650894620709;
        Mon, 25 Apr 2022 06:50:20 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id l8-20020ac84cc8000000b002f3638c32c7sm3431271qtv.7.2022.04.25.06.50.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 06:50:19 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2f7b90e8b37so71185857b3.6
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:50:19 -0700 (PDT)
X-Received: by 2002:a81:3902:0:b0:2eb:f9f0:4b0c with SMTP id
 g2-20020a813902000000b002ebf9f04b0cmr16754283ywa.419.1650894619290; Mon, 25
 Apr 2022 06:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220425014502.985464-1-liuhangbin@gmail.com>
In-Reply-To: <20220425014502.985464-1-liuhangbin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 25 Apr 2022 09:49:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSciR9svdOntOBk5OQ_xJzO5iFHJSgFzTL+Kz7QAkcBmiQ@mail.gmail.com>
Message-ID: <CA+FuTSciR9svdOntOBk5OQ_xJzO5iFHJSgFzTL+Kz7QAkcBmiQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn 
        <WillemdeBruijnwillemdebruijn.kernel@gmail.com>,
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

On Sun, Apr 24, 2022 at 10:01 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Currently, the kernel drops GSO VLAN tagged packet if it's created with
> socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
>
> The reason is AF_PACKET doesn't adjust the skb network header if there is
> a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> is dropped as network header position is invalid.
>
> Let's handle VLAN packets by adjusting network header position in
> packet_parse_headers(). The adjustment is safe and does not affect the
> later xmit as tap device also did that.
>
> In packet_snd(), packet_parse_headers() need to be moved before calling
> virtio_net_hdr_set_proto(), so we can set correct skb->protocol and
> network header first.
>
> There is no need to update tpacket_snd() as it calls packet_parse_headers()
> in tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
> functions.
>
> skb->no_fcs setting is also moved upper to make all skb settings together
> and keep consistency with function packet_sendmsg_spkt().
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
