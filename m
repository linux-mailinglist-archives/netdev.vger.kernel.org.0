Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23F1571413
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiGLILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiGLILx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A564164E2B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657613510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PiK97hxbSQcrcZZ9h/UZBOCe7lExlgOYfvQuvWlHi7E=;
        b=RoxODzkhcU2FI5ECsESvkIgid7bbJRtzOUl5b928S6WJPPZ0sR4EQ+TSvmGwhjfexzGzyD
        bBer3zUwbXvNZ4ImHoUHUdshQV0lgo7Hya0ppbPYXZ5sgFeEM6H9dSLaSZBCx4hLJrvUwC
        s88Z3pTVW8BhAYyvGr+/cyATgb9SqPk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-ozZsXvPHPpWQZzFzmb_PnQ-1; Tue, 12 Jul 2022 04:11:49 -0400
X-MC-Unique: ozZsXvPHPpWQZzFzmb_PnQ-1
Received: by mail-qt1-f197.google.com with SMTP id i14-20020ac84f4e000000b0031eb16d8b42so4944233qtw.14
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PiK97hxbSQcrcZZ9h/UZBOCe7lExlgOYfvQuvWlHi7E=;
        b=kjL9B10/XqEyU0NGNQkCuBcOOU76euRjYglj+hC1vSAiNTvIHwX5wA9BCBYJUZvQHq
         i1rbrncCl70HnYvNbXG/+tSX70hP/gw0e9tJsuPDzJZ0+oOo4t2DshwGK63TA8ndEFtb
         ghizHMuBsOQHZ2SsC9Z4gRx/RSVVTqgcD+Sh3PyHabubqNXFIk/CEJXn3SOeJEYGZRqR
         LAXRp4D39/i5fRMBgHQoHYVC1M6Ay4OrL4o0rZ658qvgapn54MhSuo3oRWXwe4dTVo8+
         gZg/+TcZ4rZyAK+4AxQjRxM4T9ArZ31E3RNf6cG3s9w042ZoqkRwgiG4mCANbn1mD1pi
         CsKA==
X-Gm-Message-State: AJIora99WsFmNiMc03pTJMBaQPqhZCeiiCiuyZCluVrPJzwtFAcz6BXC
        05tUuBS3IRMYKpNfQtPLzToSaHYjnB04DBxRFXvLWvnmo4FpYsitwz9Jnr0jWUaOJV1jGIvFNeb
        s0TpMhq1+HCcM+gRz
X-Received: by 2002:a05:620a:2402:b0:6af:19d6:7445 with SMTP id d2-20020a05620a240200b006af19d67445mr14011586qkn.450.1657613508957;
        Tue, 12 Jul 2022 01:11:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tItRBJYnc4TBvxkryM0sx+lexwq3UcqtVxvKgTokcj+inEZ2nKn/AMlmD5oa2qGwPpjuU9Jg==
X-Received: by 2002:a05:620a:2402:b0:6af:19d6:7445 with SMTP id d2-20020a05620a240200b006af19d67445mr14011575qkn.450.1657613508640;
        Tue, 12 Jul 2022 01:11:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id cn7-20020a05622a248700b0031e9d9635d4sm3659975qtb.23.2022.07.12.01.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 01:11:48 -0700 (PDT)
Message-ID: <231358c3284c5ab18981ad9cbc143154d346ec9f.camel@redhat.com>
Subject: Re: [PATCH net 1/2] ip: fix dflt addr selection for connected
 nexthop
From:   Paolo Abeni <pabeni@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Edwin Brossette <edwin.brossette@6wind.com>
Date:   Tue, 12 Jul 2022 10:11:43 +0200
In-Reply-To: <20220706160526.31711-1-nicolas.dichtel@6wind.com>
References: <20220706160526.31711-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-06 at 18:05 +0200, Nicolas Dichtel wrote:
> When a nexthop is added, without a gw address, the default scope was set
> to 'host'. Thus, when a source address is selected, 127.0.0.1 may be chosen
> but rejected when the route is used.
> 
> When using a route without a nexthop id, the scope can be configured in the
> route, thus the problem doesn't exist.
> 
> To explain more deeply: when a user creates a nexthop, it cannot specify
> the scope. To create it, the function nh_create_ipv4() calls fib_check_nh()
> with scope set to 0. fib_check_nh() calls fib_check_nh_nongw() wich was
> setting scope to 'host'. Then, nh_create_ipv4() calls
> fib_info_update_nhc_saddr() with scope set to 'host'. The src addr is
> chosen before the route is inserted.
> 
> When a 'standard' route (ie without a reference to a nexthop) is added,
> fib_create_info() calls fib_info_update_nhc_saddr() with the scope set by
> the user. iproute2 set the scope to 'link' by default.
> 
> Here is a way to reproduce the problem:
> ip netns add foo
> ip -n foo link set lo up
> ip netns add bar
> ip -n bar link set lo up
> sleep 1
> 
> ip -n foo link add name eth0 type dummy
> ip -n foo link set eth0 up
> ip -n foo address add 192.168.0.1/24 dev eth0
> 
> ip -n foo link add name veth0 type veth peer name veth1 netns bar
> ip -n foo link set veth0 address 00:09:c0:26:05:82
> ip -n foo link set veth0 arp off

It looks like the 'arp off'/fixed mac address is not relevant for the
test case, could you please drop it, so that the example and the self-
test are more clean?

> ip -n foo link set veth0 up
> ip -n bar link set veth1 address 00:09:c0:26:05:82
> ip -n bar link set veth1 arp off
> ip -n bar link set veth1 up
> 
> ip -n bar address add 192.168.1.1/32 dev veth1
> ip -n bar route add default dev veth1
> 
> ip -n foo nexthop add id 1 dev veth0
> ip -n foo route add 192.168.1.1 nhid 1
> 
> Try to get/use the route:
> > $ ip -n foo route get 192.168.1.1
> > RTNETLINK answers: Invalid argument
> > $ ip netns exec foo ping -c1 192.168.1.1
> > ping: connect: Invalid argument
> 
> Try without nexthop group (iproute2 sets scope to 'link' by dflt):
> ip -n foo route del 192.168.1.1
> ip -n foo route add 192.168.1.1 dev veth0
> 
> Try to get/use the route:
> > $ ip -n foo route get 192.168.1.1
> > 192.168.1.1 dev veth0 src 192.168.0.1 uid 0
> >     cache
> > $ ip netns exec foo ping -c1 192.168.1.1
> > PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> > 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.039 ms
> > 
> > --- 192.168.1.1 ping statistics ---
> > 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> > rtt min/avg/max/mdev = 0.039/0.039/0.039/0.000 ms
> 
> CC: stable@vger.kernel.org
> Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")

Why that commit? It looks like fib_check_nh() used SCOPE_HOST for nongw
next hop since well before ?!?

Otherwise LGTM.

Paolo

