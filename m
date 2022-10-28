Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56ABE610C60
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJ1IlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiJ1IlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:41:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106B652E7B
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666946409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3igmv4m9mJVl18Gxms4pQuE8amjlv6pT1bIcnLF+UeQ=;
        b=ZOTRP06OUO1pNwZVVhW3U48MyPlM5CpZXT1PdtMcrJhQhcQ4vtQjBg2cB7GmB1h8KTSmN8
        JYfF8JdE0OllI9AeP2unl6gcHzyECECN+owwts6VD98JhbEu96+iHApazyhO4RfgsBqjOl
        u9drME3XGvfD1J3SPf/NZhROA9HQ9iY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-456-P3mgKNsFOyCtsqh6MJobqA-1; Fri, 28 Oct 2022 04:40:08 -0400
X-MC-Unique: P3mgKNsFOyCtsqh6MJobqA-1
Received: by mail-ed1-f72.google.com with SMTP id b13-20020a056402350d00b0045d0fe2004eso2817759edd.18
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3igmv4m9mJVl18Gxms4pQuE8amjlv6pT1bIcnLF+UeQ=;
        b=Qr+1Wefzu4ad62okO0y+wfsDN6ZZEjYr58hJtdUfR4qviWg/9t++60MwSXtQC0NTPL
         d134za7RS0EAL4DGEGuZN1fkQZKoUIxiwIfxZILVjIe8P8KKv0kqlD/Sd3N9B0wZer0J
         NQDArJDhxSA2cNYULqdomugWgaBFnTfKI8UfLWc3mZ+IPI2mnkgk6ZJAjYlU9lmc5pMO
         CuhZbuO/uvZhHeWSyXExlpSNk2oaBXMgVpiU3n74xcT9I3Q9FyTwOgBSlY9WkNCn+orw
         fxx2H1M6PQUeas7N8l2hDhIPkjQr8A3wypl1rquW5Ycj/fwaUulxvmOa7vkrsXt7j6QO
         ZK3Q==
X-Gm-Message-State: ACrzQf3cQ/kt6VkQ3xQmQ9csfmACeNkcbX5qNonvX3FTCTYLN6Ka4j30
        mGw8C0pyUltRcjJquGWtVTMo4VexfxFpeF8iO9H4csu9Mig0F+D376RxjFrr5FMykhJQP1GMt78
        wlvSCMItGACDNXNx0
X-Received: by 2002:aa7:d650:0:b0:462:d945:3801 with SMTP id v16-20020aa7d650000000b00462d9453801mr1055327edr.117.1666946407070;
        Fri, 28 Oct 2022 01:40:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4fu5XA4I4vklWepx4GGeridV5qwSCB+s3SM2ZNu/K/oyyr+JE1voYDIrBmDLpM0uqUi3BNYQ==
X-Received: by 2002:aa7:d650:0:b0:462:d945:3801 with SMTP id v16-20020aa7d650000000b00462d9453801mr1055300edr.117.1666946406840;
        Fri, 28 Oct 2022 01:40:06 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id n30-20020a50935e000000b004575085bf18sm2209753eda.74.2022.10.28.01.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 01:40:06 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1596dd80-246b-80d0-b482-4248691de68e@redhat.com>
Date:   Fri, 28 Oct 2022 10:40:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 2/5] veth: Support rx timestamp metadata for xdp
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
References: <20221027200019.4106375-1-sdf@google.com>
 <20221027200019.4106375-3-sdf@google.com>
In-Reply-To: <20221027200019.4106375-3-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27/10/2022 22.00, Stanislav Fomichev wrote:
> xskxceiver conveniently setups up veth pairs so it seems logical
> to use veth as an example for some of the metadata handling.
> 
> We timestamp skb right when we "receive" it, store its
> pointer in xdp_buff->priv and generate BPF bytecode to
> reach it from the BPF program.
> 
> This largely follows the idea of "store some queue context in
> the xdp_buff/xdp_frame so the metadata can be reached out
> from the BPF program".
> 
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 09682ea3354e..35396dd73de0 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -597,6 +597,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
>   
>   		xdp_convert_frame_to_buff(frame, &xdp);
>   		xdp.rxq = &rq->xdp_rxq;
> +		xdp.priv = NULL;

So, why doesn't this supported for normal XDP mode?!?
e.g. Where veth gets XDP redirected an xdp_frame.

My main use case (for veth) is to make NIC hardware hints available to
containers.  Thus, creating a flexible fast-path via XDP-redirect
directly into containers veth device.  (This is e.g. for replacing the
inflexible SR-IOV approach with SR-IOV net_devices in the container,
with a more cloud friendly approach).

How can we extend this approach to handle xdp_frame's from different 
net_device's ?


>   
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>   
> @@ -820,6 +821,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>   
>   	orig_data = xdp.data;
>   	orig_data_end = xdp.data_end;
> +	xdp.priv = skb;
>   

So, enabling SKB based path only.

>   	act = bpf_prog_run_xdp(xdp_prog, &xdp);
>   
> @@ -936,6 +938,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
>   			struct sk_buff *skb = ptr;
>   
>   			stats->xdp_bytes += skb->len;
> +			__net_timestamp(skb);
>   			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
>   			if (skb) {
>   				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
> @@ -1595,6 +1598,33 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>   	}
>   }
>   
> +static int veth_unroll_kfunc(struct bpf_prog *prog, struct bpf_insn *insn)
> +{
> +	u32 func_id = insn->imm;
> +
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_HAVE_RX_TIMESTAMP)) {
> +		/* return true; */
> +		insn[0] = BPF_MOV64_IMM(BPF_REG_0, 1);
> +		return 1;
> +	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> +		/* r1 = ((struct xdp_buff *)r1)->priv; [skb] */
> +		insn[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1,
> +				      offsetof(struct xdp_buff, priv));
> +		/* if (r1 == NULL) { */
> +		insn[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1);
> +		/*	return 0; */
> +		insn[2] = BPF_MOV64_IMM(BPF_REG_0, 0);
> +		/* } else { */
> +		/*	return ((struct sk_buff *)r1)->tstamp; */
> +		insn[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
> +				      offsetof(struct sk_buff, tstamp));

Just to be clear, this skb->tstamp is a software timestamp, right?

> +		/* } */
> +		return 4;
> +	}

I'm slightly concerned with driver developers maintaining BPF-bytecode
on a per-driver bases, but I can certainly live with this if BPF
maintainers can.

> +
> +	return 0;
> +}
> +
>   static const struct net_device_ops veth_netdev_ops = {
>   	.ndo_init            = veth_dev_init,
>   	.ndo_open            = veth_open,
> @@ -1614,6 +1644,7 @@ static const struct net_device_ops veth_netdev_ops = {
>   	.ndo_bpf		= veth_xdp,
>   	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
>   	.ndo_get_peer_dev	= veth_peer_dev,
> +	.ndo_unroll_kfunc       = veth_unroll_kfunc,
>   };
>   
>   #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \

