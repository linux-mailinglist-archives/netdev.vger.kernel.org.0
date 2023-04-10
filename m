Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC196DC7D6
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjDJOac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDJOab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:30:31 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04D14C35
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 07:30:29 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id ly9so6677150qvb.5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 07:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681137029; x=1683729029;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+7uPJ8A68o3LC6WzaydyAWXennBsgJwAZggs6RzPac=;
        b=i4zZft3/GOc3u6ny4COX7Q4zOh6R+j1nDKsToR0VeFKdXm81YT5/0XJzTuHYr5uaIW
         7WUYNgcs9twleAFPAU1AhAKZYT6Fy5wU+M5XWG3aTw2JCSU4x4+SBkiPm5Vzxhf9cjHY
         Zi6Hgo4+qJf0+K2jIWELrtIOWgmMt0+JxkB9OpG4Os43g1zY36naKWbh+uEvYMNWvULV
         EZPSnka3WLaHqDHs1yyjewMfcPsJjy5faWxu7JV9YL9xKktaONOiDol2SDramqowpeZa
         TaM80yyB3iTeyh8Aq9seLfIm5/yiHgws0CXm1cu0X8kCedEOD6Xl/b7v2cm5PHON50jQ
         MmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681137029; x=1683729029;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+7uPJ8A68o3LC6WzaydyAWXennBsgJwAZggs6RzPac=;
        b=mw3o0zvE112yf6JDePSPQvsBafwOOZWO7eqdxd+6y+LW9EkbG9Fl7qu9JJqdlJ9zS4
         QtRNQ+R8pFatTvBDcpdKmoyhCa2IdMdNUfSC7RCxMa7RcplZRhMu3rK2xr2DxS0ZJXVH
         t8KkF4TjEcnS0PgqTuGonRgO7XLsZoeV2n2yAjSAjKFnFjgalFEyOn3vATBkl8p/0Pne
         2IFobvyZjSueGO7KqZHpYuV1z9VWJTW48vROs/5+L76oHAvTZHf0DY8hUz7mjWMr+ha/
         f+KF1O8a1FoUKT5uX5aijvluz195by48ZnNXBOqQ2Ajyr5p0lR+9C/c1k5hGdjXl49dr
         0u/g==
X-Gm-Message-State: AAQBX9dHs3sR/EOVLYpDnxqfjpPD+yxVK1OUtxJZM3XmtJiE3c5si7HZ
        216213w9T4ApsllOAvplvhc=
X-Google-Smtp-Source: AKy350b5wew74DCKW75O+CRv6Qc4/M2pS1wVybEj3O9H35F39rl+qvMwBgPwe/lKEKPn9owHAe9w8g==
X-Received: by 2002:a05:6214:761:b0:5aa:8e3e:496e with SMTP id f1-20020a056214076100b005aa8e3e496emr11207795qvz.34.1681137028737;
        Mon, 10 Apr 2023 07:30:28 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id g5-20020ad457a5000000b005e927555c96sm2003038qvx.30.2023.04.10.07.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 07:30:28 -0700 (PDT)
Date:   Mon, 10 Apr 2023 10:30:27 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Message-ID: <64341d839d862_7d2a4294d@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
References: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
Subject: RE: [PATCH net v2] ipv4: Fix potential uninit variable access buf in
 __ip_make_skb()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ziyang Xuan wrote:
> Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
> __ip6_make_skb()"). icmphdr does not in skb linear region under the
> scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
> trigger the uninit variable access bug.
> 
> Use a local variable icmp_type to carry the correct value in different
> scenarios.
> 
> Fixes: 96793b482540 ("[IPV4]: Add ICMPMsgStats MIB (RFC 4293)")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
> v2:
>   - Use sk->sk_type not sk->sk_socket->type.

This is reached through

  raw_sendmsg
    raw_probe_proto_opt
    ip_push_pending_frames
      ip_finish_skb
        __ip_make_skb

At this point, the icmp header has already been copied into skb linear
area. Is the isue that icmp_hdr/skb_transport_header is not set in
this path? 

> ---
>  net/ipv4/ip_output.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 4e4e308c3230..21507c9ce0fc 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1570,9 +1570,15 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
>  	cork->dst = NULL;
>  	skb_dst_set(skb, &rt->dst);
>  
> -	if (iph->protocol == IPPROTO_ICMP)
> -		icmp_out_count(net, ((struct icmphdr *)
> -			skb_transport_header(skb))->type);
> +	if (iph->protocol == IPPROTO_ICMP) {
> +		u8 icmp_type;
> +
> +		if (sk->sk_type == SOCK_RAW && !inet_sk(sk)->hdrincl)
> +			icmp_type = fl4->fl4_icmp_type;
> +		else
> +			icmp_type = icmp_hdr(skb)->type;
> +		icmp_out_count(net, icmp_type);
> +	}
>  
>  	ip_cork_release(cork);
>  out:
> -- 
> 2.25.1
> 


