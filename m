Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364164861BE
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiAFJAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiAFJAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:00:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A2EC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 01:00:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c126-20020a1c9a84000000b00346f9ebee43so746085wme.4
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 01:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PgHNbaRqas1l3wMBwr+/AZncsBNs3yigaIJCQ1mjUt4=;
        b=C5NfgAA3j2HX6sHvkgogflJHKY9cekhexhzduBoU2wvdooLAhPXO2TSvMwsy8MU6Fo
         qxhWcJqOvf2cxMj23nVahQBbR7NqKO035IT3mhsBtRufhhTLWeiid6E/jwWLKgcGWYLb
         wcbr1IO+6r0+P5rqZ4f5WTrwfm6+2rXwtxYcD4H1Fb3Ed5DIE9n2JNWldY8sOezNuFMz
         Lsgz+h6dmLA0V6ezXFPqci9UOS+5F9tj/gnC54GD9g/GJoVuwe8i2FyhRk8kePu7xFqC
         2bAuuQYggRbAAPy+ZFKRghuZYyf5/wPrf5rRo8Hx1hyX/92nRbl1bwSm8TSyO1Uu/QBr
         dgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PgHNbaRqas1l3wMBwr+/AZncsBNs3yigaIJCQ1mjUt4=;
        b=q0jrq5IjuwrNW71L0WO/mxUIBcpcgUNj7wmry67JZwXXKeu4eCCwMU49X1vDvWh/eb
         ev2Xq8mjeBeNWjql68k4IJTZfmCDXZQlaRI71amiOkbCNQDv4GM0z1PQ9wnFlbEdS0Q6
         RTKM5fv288bcN+3F4640C0mKrccd0IJLaYdNv5d6ZeLaum0AU4EDZ25yBzNjWf6e0sha
         YFo3jUVpYWQP6DcILrXp0GEiddSeSEXGVlik7R5GgIVrRnIjt04iOkfEBdB4BD15x0fQ
         fZg4q7ralPz4qBJtAsP1mc46l0qSaHv8njYOfChMQnZuNz366yoLLOFveeL0FuvmUPr5
         YMNA==
X-Gm-Message-State: AOAM531uhTzu8QOmkr3Pi9FveKj1uGSfeCSmr2o9phUwu+6R+94ZtTLs
        M4ugSfh5+KIKo/ivzpOdsy4=
X-Google-Smtp-Source: ABdhPJxhjJGKkO52RcvzGPOtwd5VkJ+C+UfJrYL/8OuwOla3xYpOeeeQooiocvg9AshOu20NYn9ikQ==
X-Received: by 2002:a05:600c:21cd:: with SMTP id x13mr6377635wmj.110.1641459611039;
        Thu, 06 Jan 2022 01:00:11 -0800 (PST)
Received: from [10.0.0.5] ([37.165.220.115])
        by smtp.gmail.com with ESMTPSA id f10sm1221579wmq.16.2022.01.06.01.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 01:00:10 -0800 (PST)
Message-ID: <c46e0a96-b027-903e-bc08-0daa9a54e1af@gmail.com>
Date:   Thu, 6 Jan 2022 01:00:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, laurent.bernaille@datadoghq.com,
        maciej.fijalkowski@intel.com, toshiaki.makita1@gmail.com,
        pabeni@redhat.com, john.fastabend@gmail.com, willemb@google.com
References: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/5/22 16:46, Daniel Borkmann wrote:
> Laurent reported that they have seen a significant amount of TCP retransmissions
> at high throughput from applications residing in network namespaces talking to
> the outside world via veths. The drops were seen on the qdisc layer (fq_codel,
> as per systemd default) of the phys device such as ena or virtio_net due to all
> traffic hitting a _single_ TX queue _despite_ multi-queue device. (Note that the
> setup was _not_ using XDP on veths as the issue is generic.)
>
> More specifically, after edbea9220251 ("veth: Store queue_mapping independently
> of XDP prog presence") which made it all the way back to v4.19.184+,
> skb_record_rx_queue() would set skb->queue_mapping to 1 (given 1 RX and 1 TX
> queue by default for veths) instead of leaving at 0.
>
> This is eventually retained and callbacks like ena_select_queue() will also pick
> single queue via netdev_core_pick_tx()'s ndo_select_queue() once all the traffic
> is forwarded to that device via upper stack or other means. Similarly, for others
> not implementing ndo_select_queue() if XPS is disabled, netdev_pick_tx() might
> call into the skb_tx_hash() and check for prior skb_rx_queue_recorded() as well.
>
> In general, it is a _bad_ idea for virtual devices like veth to mess around with
> queue selection [by default]. Given dev->real_num_tx_queues is by default 1,
> the skb->queue_mapping was left untouched, and so prior to edbea9220251 the
> netdev_core_pick_tx() could do its job upon __dev_queue_xmit() on the phys device.


Nice changelog and fix, thanks Daniel !

Reviewed-by: Eric Dumazet <edumazet@google.com>

> Unbreak this and restore prior behavior by removing the skb_record_rx_queue()
> from veth_xmit() altogether.
>
> If the veth peer has an XDP program attached, then it would return the first RX
> queue index in xdp_md->rx_queue_index (unless configured in non-default manner).
> However, this is still better than breaking the generic case.
>
> Fixes: edbea9220251 ("veth: Store queue_mapping independently of XDP prog presence")
> Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
> Reported-by: Laurent Bernaille <laurent.bernaille@datadoghq.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> ---
>   drivers/net/veth.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index d21dd25f429e..354a963075c5 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -335,7 +335,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>   		 */
>   		use_napi = rcu_access_pointer(rq->napi) &&
>   			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
> -		skb_record_rx_queue(skb, rxq);
>   	}
>   
>   	skb_tx_timestamp(skb);
