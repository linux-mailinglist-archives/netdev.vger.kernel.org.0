Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACBA6E6722
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjDRO2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjDRO2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:28:19 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE2ADD
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:28:16 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id l17so8354941qvq.10
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681828096; x=1684420096;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pbyb7YRbWVY1jqMIAo7GBKxj24WPofzZvHygRFDrXHI=;
        b=JwcPOjCoxL8Dg2zkLO1YFaiNIbdD/IwE9BxxHZUv5ODHhR7PJUgTeuUoDOyq+m1mfD
         9t8LKtmT8P71/iaqWSwZsdq7waRXNgiXLdE2lYJphwXCwr4cPK8cOs1+BWRxs/8pTZFc
         rbvnvibunEg3FDs4lGf2/E4fB6d5tILZekTzOHmvumV2qbjNx8C5NCPKzFaVDDGT0gx/
         0P/ZmlkLWPmn1ghjkWJB66Yx/prsK2JQbWug4kqhZwzx865I8uG7gxln5QjyLZc0yMOE
         biQk1PZ8O9DfWbMOpkvaDprGj2ke4ZEkP+TksVySWx6YM//BHzOwU4stNrSUJyJMh22Z
         wDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681828096; x=1684420096;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pbyb7YRbWVY1jqMIAo7GBKxj24WPofzZvHygRFDrXHI=;
        b=d3Ku5k2aYUTPE9tBILqnLG68E7n2PeGdL/7XWDBtlCg7cYiY/QLv8O9En4SKO/DiHk
         ezF7LSrOMeiMPsQMByuiKP5KTe+ys6tSkUFPc7+UXZzUINXeSRAR3+S2YnZ7ej4st79T
         P8ZJ1mSPthTRGPM4iv7a/H+txi2ePH827OncCTt37giV+dtbVGV/0BoVLxluZYMXUfYa
         Jd2ydXSXc7vOn3TAUWCDEhGZQ9yxCW0eV6c4QvwvgOwd+i7JbjbQ/hQjVFTXGR1+2tIr
         OfGUXXZGNgbn/EukC0O4iFB8NxpqokQ6lzJptwXCzq0m1kb5hLrWqK9Kfu6U+tEovfgH
         gMEg==
X-Gm-Message-State: AAQBX9eptDOBKtYfFLTZ7GtB4PUJRncrVpi4/g3UMb+81QDym0IcyxIE
        1E1+5xUVdlDn1So7D1dqqAE=
X-Google-Smtp-Source: AKy350b3JFEAyNMFsPMpVAID9ah4LpD+/AK5H109i4ictrmxi+oyO5bUOnJ9cizuNkQWE413nSLPLA==
X-Received: by 2002:ad4:5f0b:0:b0:5c7:cc77:d203 with SMTP id fo11-20020ad45f0b000000b005c7cc77d203mr20247445qvb.3.1681828095918;
        Tue, 18 Apr 2023 07:28:15 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id l5-20020a05620a210500b0074cf009f443sm2385149qkl.85.2023.04.18.07.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:28:15 -0700 (PDT)
Date:   Tue, 18 Apr 2023 10:28:15 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Message-ID: <643ea8ff510b2_332aa4294c4@willemb.c.googlers.com.notmuch>
In-Reply-To: <a57ca89f-0816-d691-06b1-78f28a824b1a@huawei.com>
References: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
 <64341d839d862_7d2a4294d@willemb.c.googlers.com.notmuch>
 <ae16f222-86ad-af35-8a05-82d7a0e7f234@huawei.com>
 <a57ca89f-0816-d691-06b1-78f28a824b1a@huawei.com>
Subject: Re: [PATCH net v2] ipv4: Fix potential uninit variable access buf in
 __ip_make_skb()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ziyang Xuan (William) wrote:
> >> Ziyang Xuan wrote:
> >>> Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
> >>> __ip6_make_skb()"). icmphdr does not in skb linear region under the
> >>> scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
> >>> trigger the uninit variable access bug.
> >>>
> >>> Use a local variable icmp_type to carry the correct value in different
> >>> scenarios.
> >>>
> >>> Fixes: 96793b482540 ("[IPV4]: Add ICMPMsgStats MIB (RFC 4293)")
> >>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> >>> ---
> >>> v2:
> >>>   - Use sk->sk_type not sk->sk_socket->type.
> >>
> >> This is reached through
> >>
> >>   raw_sendmsg
> >>     raw_probe_proto_opt
> >>     ip_push_pending_frames
> >>       ip_finish_skb
> >>         __ip_make_skb
> >>
> >> At this point, the icmp header has already been copied into skb linear
> >> area. Is the isue that icmp_hdr/skb_transport_header is not set in
> >> this path? 
> >>
> > Hello Willem,
> > 
> > raw_sendmsg
> >   ip_append_data(..., transhdrlen==0, ...) // !inet->hdrincl
> > 
> > Parameter "transhdrlen" of ip_append_data() equals to 0 in raw_sendmsg()
> > not sizeof(struct icmphdr) as in ping_v4_sendmsg().
> > 
> > William Xuan.
> Hello Willem,
> 
> Does my answer answer your doubts?

Thanks. Yes, that explains. Would you mind adding a comment to that
effect. Sommething like

    /* for such sockets, transport hlen is zero and icmp_hdr incorrect */
    if (sk->sk_type == SOCK_RAW && !inet_sk(sk)->hdrincl)

I missed your previous response, William. Sorry about that.
 
> William Xuan
> >>> ---
> >>>  net/ipv4/ip_output.c | 12 +++++++++---
> >>>  1 file changed, 9 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> >>> index 4e4e308c3230..21507c9ce0fc 100644
> >>> --- a/net/ipv4/ip_output.c
> >>> +++ b/net/ipv4/ip_output.c
> >>> @@ -1570,9 +1570,15 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
> >>>  	cork->dst = NULL;
> >>>  	skb_dst_set(skb, &rt->dst);
> >>>  
> >>> -	if (iph->protocol == IPPROTO_ICMP)
> >>> -		icmp_out_count(net, ((struct icmphdr *)
> >>> -			skb_transport_header(skb))->type);
> >>> +	if (iph->protocol == IPPROTO_ICMP) {
> >>> +		u8 icmp_type;
> >>> +
> >>> +		if (sk->sk_type == SOCK_RAW && !inet_sk(sk)->hdrincl)
> >>> +			icmp_type = fl4->fl4_icmp_type;
> >>> +		else
> >>> +			icmp_type = icmp_hdr(skb)->type;
> >>> +		icmp_out_count(net, icmp_type);
> >>> +	}
> >>>  
> >>>  	ip_cork_release(cork);
> >>>  out:
> >>> -- 
> >>> 2.25.1
> >>>
> >>
> >>
> >> .
> >>
> > 
> > .
> > 


