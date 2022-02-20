Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774794BCFE2
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 17:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243064AbiBTQcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 11:32:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiBTQck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 11:32:40 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CC6E70
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 08:32:19 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id y26so11251143vsq.8
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 08:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JYnP3q7TXlLUy1XLn2m5CwnhR2OGlO525rdZ+tITisc=;
        b=Rw9l43W0JdjL2vZDCqx1F2qjFrPh47g8mOhG3tGA5e1RK+tcalXRWqm+PTqL2/AIO2
         BhwbQpf7T1ZW6RqmPlmJ67BrMaxq/r2qD/ngnHgmeYlcOkMIwYgAqJrJuduKI3eDE6x3
         JLhwo9gNsZDZ6p12l5sDYPcggA1un2YorDmxyd7GGTGWF3B6RWvXzc5A1Y4Vfhx5jOIX
         G4fKtya8iHPmIrIthhnYUo1eeq+2djuAdxzXyJdmeEuXf21UylC0aDu8NGWwvqkQjF1s
         SGdiW+zt0A+MHJhLgxU+hHGt8WWKY6jxYPgzz0VLJaDOEP6n1IFykDR1u7x+NH9Q2pNQ
         BMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JYnP3q7TXlLUy1XLn2m5CwnhR2OGlO525rdZ+tITisc=;
        b=nIk7XxKl8OA6BIBeU5WH6WvRX6BHcTM5MzpaQBqFaN5Xlk72Sh2rE1MCHJK7maPBTQ
         FgMBnMUdfFK1pY/hFyBg3frAUlqbfQJIqyQbZRZS80ZoFtVD0TfZaV4KQfwsK4OQuD59
         YxbKGHs18+HPxsddynX9rlbdiGjKRNp7zoZMaj97ptBAwRMGCF4dRuy+Suw+ZXreiDjk
         rqBP9GkcU8BJJHsyOCR/1tGyXFIl37xSfPwWbk9atML3M8bYQSDjXmDeNN8BJXIVFEGB
         2DNLU8232fp69BeFB/ttGrkXrwy88kPfXN3zdd4kJdAUeYV0ZKUqFsGdJOBNAAjwfTAa
         Ootg==
X-Gm-Message-State: AOAM5301rs3/w78BH85gUqb7mk/MmlxC+X7KZ233p6YQriIPVoPGt2jq
        c4AVHj5FA8iUf80LcA3G4OJtSkM4kAM=
X-Google-Smtp-Source: ABdhPJy/srndRMJdmcVZbMH/LuvLk5hA3Tx34M66QRuZKG3C22//PVVRhSzFkDomcMXFSE32A8I3pA==
X-Received: by 2002:a05:6102:a90:b0:31b:6ed9:7702 with SMTP id n16-20020a0561020a9000b0031b6ed97702mr6454830vsg.70.1645374738616;
        Sun, 20 Feb 2022 08:32:18 -0800 (PST)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id g27sm477327vsp.3.2022.02.20.08.32.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 08:32:18 -0800 (PST)
Received: by mail-vs1-f54.google.com with SMTP id g20so15128539vsb.9
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 08:32:17 -0800 (PST)
X-Received: by 2002:a67:c384:0:b0:31b:6b52:33c7 with SMTP id
 s4-20020a67c384000000b0031b6b5233c7mr6847946vsj.74.1645374737046; Sun, 20 Feb
 2022 08:32:17 -0800 (PST)
MIME-Version: 1.0
References: <20220218143524.61642-1-thomas.liu@ucloud.cn>
In-Reply-To: <20220218143524.61642-1-thomas.liu@ucloud.cn>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 20 Feb 2022 08:31:41 -0800
X-Gmail-Original-Message-ID: <CA+FuTScWvCUH3-fyMNeO5KS7FQ0QBmhfLuGAybiV0rhM1q2b0Q@mail.gmail.com>
Message-ID: <CA+FuTScWvCUH3-fyMNeO5KS7FQ0QBmhfLuGAybiV0rhM1q2b0Q@mail.gmail.com>
Subject: Re: [PATCH net v3] gso: do not skip outer ip header in case of ipip
 and net_failover
To:     Tao Liu <thomas.liu@ucloud.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 6:36 AM Tao Liu <thomas.liu@ucloud.cn> wrote:
>
> We encounter a tcp drop issue in our cloud environment. Packet GROed in
> host forwards to a VM virtio_net nic with net_failover enabled. VM acts
> as a IPVS LB with ipip encapsulation. The full path like:
> host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
>  -> ipip encap -> net_failover tx -> virtio_net tx
>
> When net_failover transmits a ipip pkt (gso_type = 0x0103, which means
> SKB_GSO_TCPV4, SKB_GSO_DODGY and SKB_GSO_IPXIP4), there is no gso
> did because it supports TSO and GSO_IPXIP4. But network_header points to
> inner ip header.
>
> Call Trace:
>  tcp4_gso_segment        ------> return NULL
>  inet_gso_segment        ------> inner iph, network_header points to
>  ipip_gso_segment
>  inet_gso_segment        ------> outer iph
>  skb_mac_gso_segment
>
> Afterwards virtio_net transmits the pkt, only inner ip header is modified.
> And the outer one just keeps unchanged. The pkt will be dropped in remote
> host.
>
> Call Trace:
>  inet_gso_segment        ------> inner iph, outer iph is skipped
>  skb_mac_gso_segment
>  __skb_gso_segment
>  validate_xmit_skb
>  validate_xmit_skb_list
>  sch_direct_xmit
>  __qdisc_run
>  __dev_queue_xmit        ------> virtio_net
>  dev_hard_start_xmit
>  __dev_queue_xmit        ------> net_failover
>  ip_finish_output2
>  ip_output
>  iptunnel_xmit
>  ip_tunnel_xmit
>  ipip_tunnel_xmit        ------> ipip
>  dev_hard_start_xmit
>  __dev_queue_xmit
>  ip_finish_output2
>  ip_output
>  ip_forward
>  ip_rcv
>  __netif_receive_skb_one_core
>  netif_receive_skb_internal
>  napi_gro_receive
>  receive_buf
>  virtnet_poll
>  net_rx_action
>
> The root cause of this issue is specific with the rare combination of
> SKB_GSO_DODGY and a tunnel device that adds an SKB_GSO_ tunnel option.
> SKB_GSO_DODGY is set from external virtio_net. We need to reset network
> header when callbacks.gso_segment() returns NULL.
>
> This patch also includes ipv6_gso_segment(), considering SIT, etc.
>
> Fixes: cb32f511a70b ("ipip: add GSO/TSO support")
> Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>

Reviewed-by: Willem de Bruijn <willemb@google.com>
