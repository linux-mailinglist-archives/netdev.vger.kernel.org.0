Return-Path: <netdev+bounces-1761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E65276FF12F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A169028170E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78AF19E40;
	Thu, 11 May 2023 12:11:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A665B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:11:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879E759CB
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683807034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dx9jr+hv3Y6YnBWS7LuMRBIDsA14zf/h/znTBgdr2wE=;
	b=fwJ5yo5MaXdnYR6fa63VvSsw94AMKTkOvOhSpvEJqji3sVcjWLM2mL1rsRGtIYTT5+VqKC
	TDBn+SXyfIdOgKEk/r5xyDD+5p6garGe93HyvBzTaHwvtDKMibxzIccJdmxBBfx8G8x6TW
	tRmxHqHMcaHhzKvkmGD1L/dSrvo+yWg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-S5wzXm6qMU2-dX_1fQlu5w-1; Thu, 11 May 2023 08:10:33 -0400
X-MC-Unique: S5wzXm6qMU2-dX_1fQlu5w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30640be4fd0so3078036f8f.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683807031; x=1686399031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx9jr+hv3Y6YnBWS7LuMRBIDsA14zf/h/znTBgdr2wE=;
        b=dDT09wA6TWRlvbcX7lmDakuSlkupot+Edzh7rxFpP6Ha1AqaFoFHioRF2PFBo0BfzQ
         I3Py/4TJk9y9fCi1P3H1b2Qib6Ao6LiCFSrOxPrEgpzTMSwascOJefhNWJPgDqNXvxL4
         gFRUjCwnHf9XaQnzRjlZ3b/TDPTcyxZpskjgyNpL/dIba9UveDlaE37xf9UsWDjsDgNn
         QuPGS1RCtWUpj60wWZlH6fiKfCI6SsSj9ADwvyJQpqINdtUHi+BOzbMFRLUOD9mI374b
         aTsx/UCo6UqS71ttTbN+5aUgXdkfMJFeCj+AYt1ZkiRs7sXlZXtOtOiqQfzXLWxzDJlp
         QsRA==
X-Gm-Message-State: AC+VfDzzq7hoaA4bFwXpYO1nVmhXqVmbsVI1qLvzDee2RbrMBGmbBN2s
	jFdpwxf6CViGshdKQAhMwUHo2K1Mfm2Vgoen0deKEpzlzcRceStS84KKO4e8pQywkLkE13q7oHG
	s11K8LVgSKBbgZy8hM3YL85mf
X-Received: by 2002:adf:f54c:0:b0:307:a24f:c15e with SMTP id j12-20020adff54c000000b00307a24fc15emr7067450wrp.39.1683807031530;
        Thu, 11 May 2023 05:10:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5BAZC4HccyoXQb05B0l4wUNrbWqTeRE6Kev5u5aZmJSe1bSShJiyMnbrHRezOku9JNPrq9Ow==
X-Received: by 2002:adf:f54c:0:b0:307:a24f:c15e with SMTP id j12-20020adff54c000000b00307a24fc15emr7067427wrp.39.1683807031199;
        Thu, 11 May 2023 05:10:31 -0700 (PDT)
Received: from [192.168.178.60] (82-75-96-200.cable.dynamic.v4.ziggo.nl. [82.75.96.200])
        by smtp.gmail.com with ESMTPSA id i6-20020adfdec6000000b002c70ce264bfsm20218559wrn.76.2023.05.11.05.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 05:10:30 -0700 (PDT)
Message-ID: <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
Date: Thu, 11 May 2023 14:10:30 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
Content-Language: en-US
To: Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: netdev@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>
References: <20230511093456.672221-1-atenart@kernel.org>
 <20230511093456.672221-5-atenart@kernel.org>
From: Dumitru Ceara <dceara@redhat.com>
In-Reply-To: <20230511093456.672221-5-atenart@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Antoine,

On 5/11/23 11:34, Antoine Tenart wrote:
> Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
> sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
> used in the TCP Tx path to populate skb->hash, with skb->l4_hash=1.
> With this, skb->l4_hash does not always indicate the hash is a
> "canonical 4-tuple hash over transport ports" but rather a hash from L4
> layer to provide a uniform distribution over flows. Reword the comment
> accordingly, to avoid misunderstandings.

But AFAIU the hash used to be a canonical 4-tuple hash and was used as
such by other components, e.g., OvS:

https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L1069

It seems to me at least unfortunate that semantics change without
considering other users.  The fact that we now fix the documentation
makes it seem like OvS was wrong to use the skb hash.  However, before
877d1f6291f8 ("net: Set sk_txhash from a random number") it was OK for
OvS to use the skb hash as a canonical 4-tuple hash.

Best regards,
Dumitru

> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  include/linux/skbuff.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 738776ab8838..f54c84193b23 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
>   *	@active_extensions: active extensions (skb_ext_id types)
>   *	@ndisc_nodetype: router type (from link layer)
>   *	@ooo_okay: allow the mapping of a socket to a queue to be changed
> - *	@l4_hash: indicate hash is a canonical 4-tuple hash over transport
> - *		ports.
> + *	@l4_hash: indicate hash is from layer 4 and provides a uniform
> + *		distribution over flows.
>   *	@sw_hash: indicates hash was computed in software stack
>   *	@wifi_acked_valid: wifi_acked was set
>   *	@wifi_acked: whether frame was acked on wifi or not


