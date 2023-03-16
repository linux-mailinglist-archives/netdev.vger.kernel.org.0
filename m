Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1434C6BD343
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCPPUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjCPPUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:20:53 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F32B1E295
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:20:50 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id mg14so1421226qvb.12
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678980049;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEjmOnZ9HoQ2zGr+nHBIc1ApDvVu5Nrv2U+EXjt28hk=;
        b=dHNytBqInDrq2Vgsa9tKGpuzTVI2W+Vof5Q3OwHIZSwyO8iWRkpC1nwSfoiEeidIHy
         GdsOmnyRT2G5ddbML1qJxsU6ED+CvZF92VHyYur89HY5XP781VHx3DF5h1LsJ1NVZxg5
         53rpizI7+Pzj+D3GsWX41Krosy561Saadw3RkGYzWrmksQXVHWjqjdUu/7FdvQOlBrs7
         nqudBdZqH+qgl8IC2plBXa5c+RYcHmk2AhqvJjrS15C4iUwII8VhMVuCQA/uI3oUQGKR
         f6Ii2X2PYkzMije/CZssKLsuYFFCF42dO2VM3QihFeENb1yhPvZR5KuIBA6vaScTqeOB
         Z+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980049;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fEjmOnZ9HoQ2zGr+nHBIc1ApDvVu5Nrv2U+EXjt28hk=;
        b=mpLBTdI/UHg6oaOWiUZsINJnquIzl3q6scT8jCPWFD41cfsqqcerfxa+WnlZ23G/O2
         wgU3B+qp9MkVAXBnBtue12Pwpo6YRICB0gnMkTpders68C7C5YIP7hCFlwylh2Bbz0ML
         r806p8BMOM3mhk8ve1FHx5GYo15NnMrqWfSSF0YMZ2j8ygvw1QZYd3/ZMjsmQCiwqzdC
         bT0wQczZ9TQrwKnezHdEgK3B+bUKpLPKW2VQf5tsLg96uO5WklHN1SuFdWkz1PHyFKcN
         VC6Dg+YA70jWoS396wCZlQhSelBa1iGOVwf1GxioyiiqIwmCB7C/0jPibZmWNyKeDxpV
         v0xQ==
X-Gm-Message-State: AO0yUKXMM5ktoWg4rd6H2KKnq7FhWQq2+x7LaEFVMaGpeoFXl44cAVJD
        BbOGk9mNb5QJJi2eel16XKs=
X-Google-Smtp-Source: AK7set9WhUPaGItYo+DHD0HSFwxM+SV7Vb+H52zwPUp0a4yQDo/xjvlfe9T2kQiP+CvhCnUnrlxwRg==
X-Received: by 2002:a05:6214:c86:b0:5aa:d3e6:1205 with SMTP id r6-20020a0562140c8600b005aad3e61205mr19747046qvr.23.1678980049324;
        Thu, 16 Mar 2023 08:20:49 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id s127-20020a372c85000000b00739f84a6c23sm6087677qkh.113.2023.03.16.08.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:20:48 -0700 (PDT)
Date:   Thu, 16 Mar 2023 11:20:48 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Message-ID: <641333d07c6b0_3333c72088e@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230316011014.992179-2-edumazet@google.com>
References: <20230316011014.992179-1-edumazet@google.com>
 <20230316011014.992179-2-edumazet@google.com>
Subject: RE: [PATCH net-next 1/9] net/packet: annotate accesses to po->xmit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> po->xmit can be set from setsockopt(PACKET_QDISC_BYPASS),
> while read locklessly.
> 
> Use READ_ONCE()/WRITE_ONCE() to avoid potential load/store
> tearing issues.
> 
> Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/packet/af_packet.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index d4e76e2ae153ea3b3c7d73ef6ac2f8c2742f790d..d25dd9f63cc4f11ad8197ab66d60180b6358132f 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -307,7 +307,8 @@ static void packet_cached_dev_reset(struct packet_sock *po)
>  
>  static bool packet_use_direct_xmit(const struct packet_sock *po)
>  {
> -	return po->xmit == packet_direct_xmit;
> +	/* Paired with WRITE_ONCE() in packet_setsockopt() */
> +	return READ_ONCE(po->xmit) == packet_direct_xmit;
>  }
>  
>  static u16 packet_pick_tx_queue(struct sk_buff *skb)
> @@ -2867,7 +2868,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  		packet_inc_pending(&po->tx_ring);
>  
>  		status = TP_STATUS_SEND_REQUEST;
> -		err = po->xmit(skb);
> +		/* Paired with WRITE_ONCE() in packet_setsockopt() */
> +		err = READ_ONCE(po->xmit)(skb);
>  		if (unlikely(err != 0)) {
>  			if (err > 0)
>  				err = net_xmit_errno(err);
> @@ -3070,7 +3072,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>  	}
>  
> -	err = po->xmit(skb);
> +	/* Paired with WRITE_ONCE() in packet_setsockopt() */
> +	err = READ_ONCE(po->xmit)(skb);
>  	if (unlikely(err != 0)) {
>  		if (err > 0)
>  			err = net_xmit_errno(err);
> @@ -4007,7 +4010,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
>  		if (copy_from_sockptr(&val, optval, sizeof(val)))
>  			return -EFAULT;
>  
> -		po->xmit = val ? packet_direct_xmit : dev_queue_xmit;
> +		/* Paired with all lockless reads of po->xmit */
> +		WRITE_ONCE(po->xmit, val ? packet_direct_xmit : dev_queue_xmit);

We could avoid the indirect function call with a branch on
packet_use_direct_xmit() and just store a bit?

>  		return 0;
>  	}
>  	default:
> -- 
> 2.40.0.rc2.332.ga46443480c-goog
> 


