Return-Path: <netdev+bounces-6888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F6B718915
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA0A82815AB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6E519BC0;
	Wed, 31 May 2023 18:11:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A00019BBD
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:11:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14098128
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685556706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAWAJe3UA9xA6PqORf3KUovsk+ctYnZo8FLCQDjgOnc=;
	b=crju0aubawoYU4mm8exgvUgGHdWCH2IbFJuXA8+Ajhh9ywkwgHVINh1+8VkilEyBJa/HOU
	OCkd+IeTgq+Fxzw5JtpRySQ765RwAf17GMrhEAlKeWg2IJRppy/Rd4oN2J8AQ7QYsrN++6
	RLvAR/c25DDR/BoZbVeU7NDWGCVYOiA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-_j90I5nYNJWjX4fC2_L_3g-1; Wed, 31 May 2023 14:11:44 -0400
X-MC-Unique: _j90I5nYNJWjX4fC2_L_3g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30ae9958ff6so1654462f8f.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685556703; x=1688148703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAWAJe3UA9xA6PqORf3KUovsk+ctYnZo8FLCQDjgOnc=;
        b=C+q6RwnVVmHhqbDIdVpRed4tG4wNvrjsL2bY7KFlziiTwE9I1/h+Lj+J+Wsw+lFYFZ
         INCnQOKFFF92YXajThY5P/cFLnLBd20cR4VW8Y2g2eN3Ea93VHSlq3FJpwfOGB6+owIR
         d9IPHyRG8Jd3+G7a0cfx70QkJlvQf6hROAwvyBv46pZKT1XAQqZw+dAMBn2fnlgATRfP
         1HdUCt2+DYV7X//mCrKS2wCAZYBMvoh3qsSj8S5O1gJnRkVMHeC4x0OnbbC+zlaHhcD9
         fypkHhOuDz3B2+eHKsg+R7lMk9oXSmkXRSUIUVi4N0KYhntyPHJ93s2tALTZnbWSEarg
         js7Q==
X-Gm-Message-State: AC+VfDyBK7bcG5jSbUiIg4WSuWWdn2nZvkXVZ03gBAL0A0y+fWtZFnN2
	8hWiQGuSt+HcSS8pFMJuATlfYSeHiXIHz8A4ihgSwkBMqO9WdWXlAGIevfFPdOJl0IT7pgW8jWI
	5Uk7fOgRj7ZgT+iFX
X-Received: by 2002:a7b:c00f:0:b0:3f6:464:4b32 with SMTP id c15-20020a7bc00f000000b003f604644b32mr29555wmb.13.1685556703648;
        Wed, 31 May 2023 11:11:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4I3bej1gd6wxKA029xGlz2GTs++Hria7YlGL0+uG0cpjKlxWcboCFOk9SMAY3CSI+B+vPhdg==
X-Received: by 2002:a7b:c00f:0:b0:3f6:464:4b32 with SMTP id c15-20020a7bc00f000000b003f604644b32mr29540wmb.13.1685556703308;
        Wed, 31 May 2023 11:11:43 -0700 (PDT)
Received: from debian (2a01cb058d652b003ebe8a257dfba413.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:3ebe:8a25:7dfb:a413])
        by smtp.gmail.com with ESMTPSA id t7-20020a5d4607000000b0030647449730sm7533168wrq.74.2023.05.31.11.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 11:11:42 -0700 (PDT)
Date: Wed, 31 May 2023 20:11:41 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
Message-ID: <ZHeN3bg28pGFFjJN@debian>
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:17:09PM +0200, Mirsad Todorovac wrote:
> Hi,

Hi Mirsad,

> The very recent 6.4-rc3 kernel build with AlmaLinux 8.7 on LENOVO 10TX000VCR
> desktop box fails one test:
> 
> [root@host net]# ./fcnal-test.sh
> [...]
> TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
> TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [FAIL]
> TEST: ping in - ns-A IPv6                                                     [ OK ]
> [...]
> Tests passed: 887
> Tests failed:   1
> [root@host net]#

This test also fails on -net. The problem is specific to ping sockets
(same test passes with raw sockets). I believe this test has always
failed since fcnal-test.sh started using net.ipv4.ping_group_range
(commit e71b7f1f44d3 ("selftests: add ping test with ping_group_range
tuned")).

The executed command is:

ip netns exec ns-A ip vrf exec red /usr/bin/ping6 -c1 -w1 -I 2001:db8:3::1 fe80::a846:b5ff:fe4c:da4e%eth1

So ping6 is executed inside VRF 'red' and sets .sin6_scope_id to 'eth1'
(which is a slave device of VRF 'red'). Therefore, we have
sk->sk_bound_dev_if == 'red' and .sin6_scope_id == 'eth1'. This fails
because ping_v6_sendmsg() expects them to be equal:

static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
{
...
                if (__ipv6_addr_needs_scope_id(ipv6_addr_type(daddr)))
                        oif = u->sin6_scope_id;
...
        if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
            (addr_type & IPV6_ADDR_MAPPED) ||
            (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if)) <-- oif='eth1', but ->sk_bound_dev_if='red'
                return -EINVAL;
...
}

I believe this condition should be relaxed to allow the case where
->sk_bound_dev_if is oif's master device (and maybe there are other
VRF cases to also consider).


