Return-Path: <netdev+bounces-8503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90B0724569
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AA371C209BB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF98F2DBAF;
	Tue,  6 Jun 2023 14:12:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC3737B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:12:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C422171E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686060743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fw9T5rxLrJVKHG27fIjocIY1CyjQERL7+8LiZXQNd7E=;
	b=gLqsBgQX7mCKdDeutRy5i0OEWVBJoACn6ZURrzNvfTMw3dwFkj/9FC1ku0d+kV7xa0lARY
	GEPXuvyYIJq55TYMFEASNxMPbmSpk/OIvLWdo2tTSR+J0g4sXq9JiCW9BNIWcWg+FNijbU
	ZfcU2LR98YPOpCy8A4HdRgPVl8nea7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-zocJvrFpMl6Low9oaYXJ3w-1; Tue, 06 Jun 2023 10:11:39 -0400
X-MC-Unique: zocJvrFpMl6Low9oaYXJ3w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f6fa88a86bso34521955e9.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686060686; x=1688652686;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fw9T5rxLrJVKHG27fIjocIY1CyjQERL7+8LiZXQNd7E=;
        b=Tpn43PNa40HY0c6hy2Rz8R+JSKcyz3i0Er8kJJyd1z8hKR2ipnyEnUvwRfnV1Yc8kP
         wJYVwmPvZbkVxG1fvJhARgHRAdJXSNdBa24tGh7RPXQkXj8vqf7OxIBCc94dztGHaUxG
         GpI5Zfd7LUP96gRD2DBxi5vHOFqnuwaThAMvEDdC5LzoIFhwn15DHIo6y5PNGTGrd7Up
         E0z9LA3+HwcAtpVix2c+Wal3v3QzDUqXsov/W0JDE4n2CJcfV8s4kAUO7VQFaXVzZIe5
         8onTUKh39yVCQ3DA7s+JeOFcBxtdZZN9o4bjbn9/XseKRxus1jTAI0+MBKgLf1BIYNSX
         HsDQ==
X-Gm-Message-State: AC+VfDyEqHVdStvA4f6KEY7SiFt4BM6ecpCtVSo/8/q8D2bp0t+1gI5q
	rbFjdeG9nok7wrA53/foS0f0pnOtkl5BYsA25iwUFkGpz8JVNTVaFWrtks+BE9o07KIqpI/6dV2
	6uAvPVy6pKfCLCjhZ
X-Received: by 2002:a1c:7912:0:b0:3f7:33cf:7080 with SMTP id l18-20020a1c7912000000b003f733cf7080mr2254961wme.36.1686060686553;
        Tue, 06 Jun 2023 07:11:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5wOLgLIb3XMmyPMrwryL9a1f6reu3dJklYXOBS8ZHG+qjkBneUwt1XyrlPOPxqX+dpQ7I6Tw==
X-Received: by 2002:a1c:7912:0:b0:3f7:33cf:7080 with SMTP id l18-20020a1c7912000000b003f733cf7080mr2254940wme.36.1686060686230;
        Tue, 06 Jun 2023 07:11:26 -0700 (PDT)
Received: from debian (2a01cb058d652b00fa0f162c47a2f35b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:fa0f:162c:47a2:f35b])
        by smtp.gmail.com with ESMTPSA id e21-20020a05600c219500b003f736735424sm9067513wme.43.2023.06.06.07.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:11:25 -0700 (PDT)
Date: Tue, 6 Jun 2023 16:11:24 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
Message-ID: <ZH8+jLjottBw2zuD@debian>
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
 <60f78eaa-ace7-c27d-8e45-4777ecf3faa2@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60f78eaa-ace7-c27d-8e45-4777ecf3faa2@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 03:57:35PM +0200, Mirsad Todorovac wrote:
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index c4835dbdfcff..c1d81c49b775 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -73,6 +73,10 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>         struct rt6_info *rt;
>         struct pingfakehdr pfh;
>         struct ipcm6_cookie ipc6;
> +       struct net *net = sock_net(sk);
> +       struct net_device *dev = NULL;
> +       struct net_device *mdev = NULL;
> +       struct net_device *bdev = NULL;
> 
>         err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
>                                   sizeof(user_icmph));
> @@ -111,10 +115,26 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>         else if (!oif)
>                 oif = np->ucast_oif;
> 
> +       if (oif) {
> +               rcu_read_lock();
> +               dev = dev_get_by_index_rcu(net, oif);
> +               rcu_read_unlock();

You can't assume '*dev' is still valid after rcu_read_unlock() unless
you hold a reference on it.

> +               rtnl_lock();
> +               mdev = netdev_master_upper_dev_get(dev);
> +               rtnl_unlock();

Because of that, 'dev' might have already disappeared at the time
netdev_master_upper_dev_get() is called. So it may dereference an
invalid pointer here.

> +       }
> +
> +       if (sk->sk_bound_dev_if) {
> +               rcu_read_lock();
> +               bdev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
> +               rcu_read_unlock();
> +       }
> +
>         addr_type = ipv6_addr_type(daddr);
>         if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>             (addr_type & IPV6_ADDR_MAPPED) ||
> -           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
> +           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
> +                   !(mdev && sk->sk_bound_dev_if && bdev && mdev == bdev)))
>                 return -EINVAL;
> 
>         ipcm6_init_sk(&ipc6, np);
> 
> However, this works by the test (888 passed) but your two liner is obviously
> better :-)

:)

> Best regards,
> Mirsad
> 
> -- 
> Mirsad Goran Todorovac
> Sistem inženjer
> Grafički fakultet | Akademija likovnih umjetnosti
> Sveučilište u Zagrebu
> 
> System engineer
> Faculty of Graphic Arts | Academy of Fine Arts
> University of Zagreb, Republic of Croatia
> 


