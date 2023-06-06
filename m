Return-Path: <netdev+bounces-8493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D827B7244BF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96155280E05
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D6D2A9F2;
	Tue,  6 Jun 2023 13:47:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8196E2910B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:47:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EA183
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686059218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ptXauuCBD1PCG9ib1NA3tuS4we6SP4trE10C7/jO/rU=;
	b=i6ZudmSQBfnWO44QyjRRw3R6/M9n58jaCGJCLLoXqesS1Z76lusQjz/1dfIeFASYswDL96
	UJxyy6KCYV2QZHigrCFDG/v2UkTXeBIcobpPsSLzPkNAci28KSdprcLLZU+wQCUkhk1NqY
	pso/SER+I5FJQfjgOJQt8bY4n81gTcA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-QA1iP--LPJm0TtLU92FsBA-1; Tue, 06 Jun 2023 09:46:56 -0400
X-MC-Unique: QA1iP--LPJm0TtLU92FsBA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f7ebe8523eso2589455e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 06:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686059215; x=1688651215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptXauuCBD1PCG9ib1NA3tuS4we6SP4trE10C7/jO/rU=;
        b=DMchDpfJJzdKZ+9loUsDfeaLBi69L81CjvenfUG6xpPHcc3PZHmxlthqb/J2xOwokn
         XkPbOzyJPQtTUVcvZNhldrOLqDhXcWosyv37HMm6omXk0SXh92ysINvkMY1atzLNZ3eh
         XKl71O48B4XXJ/vVtdH6DY8DhnmPwn6PJLi+SnNNdlSybU7ZU4pbkIn7mOC/oOMM4oDn
         P0hLSlePJ7fmRigZB7sbiLSqt2o+5RmzFRPZWLFbGly2a2rhWE7mYPj9xuduOX+XvDLW
         vr9TNqVZ8XCw0H4rrdZKRSjBqEWy5Vn7566eQBulumbpLH7EQZ4kSB4VcXw+L8tniCso
         vriA==
X-Gm-Message-State: AC+VfDyWvuK1rPJd1UbYoIuO9pHGfP0jSDYEpH4KrtXh2XndbmvZuZxg
	F/mJidzc9UjP4ovAcPxdBIMXQsmAKV+3ZYcGVue0NFhxyiKG4PFnkg22jv93prYiMo0eZyJxoeG
	gp7R7fYG8WsCF0p1O
X-Received: by 2002:a05:600c:210:b0:3f7:2d7d:c673 with SMTP id 16-20020a05600c021000b003f72d7dc673mr2418145wmi.14.1686059215081;
        Tue, 06 Jun 2023 06:46:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4y42arS3sf+JMJGfQY8U+MTu6mCEmQV2avTDbCSIXEM+noeWVrgY9hMz5LISuQwGh0nAEYYA==
X-Received: by 2002:a05:600c:210:b0:3f7:2d7d:c673 with SMTP id 16-20020a05600c021000b003f72d7dc673mr2418122wmi.14.1686059214733;
        Tue, 06 Jun 2023 06:46:54 -0700 (PDT)
Received: from debian (2a01cb058d652b00fa0f162c47a2f35b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:fa0f:162c:47a2:f35b])
        by smtp.gmail.com with ESMTPSA id l12-20020a5d4bcc000000b0030e5482bd8esm251173wrt.90.2023.06.06.06.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:46:54 -0700 (PDT)
Date: Tue, 6 Jun 2023 15:46:52 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
Message-ID: <ZH84zGEODT97TEXG@debian>
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 08:24:54AM +0200, Mirsad Goran Todorovac wrote:
> On 5/31/23 20:11, Guillaume Nault wrote:
> > I believe this condition should be relaxed to allow the case where
> > ->sk_bound_dev_if is oif's master device (and maybe there are other
> > VRF cases to also consider).
> 
> I've tried something like this, but something makes the kernel stuck
> here:
> 
> TEST: ping out, blocked by route - ns-B loopback IPv6                         [ OK ]
> TEST: ping out, device bind, blocked by route - ns-B loopback IPv6            [ OK ]
> TEST: ping in, blocked by route - ns-A loopback IPv6                          [ OK ]
> TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
> TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
> 
> #################################################################
> With VRF
> 
> [hanged process and kernel won't shutdown]
> 
> The code is:
> 
> ---
>  net/ipv6/ping.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index c4835dbdfcff..81293e902293 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -73,6 +73,9 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>         struct rt6_info *rt;
>         struct pingfakehdr pfh;
>         struct ipcm6_cookie ipc6;
> +       struct net *net = sock_net(sk);
> +       struct net_device *dev = NULL;
> +       struct net_device *mdev = NULL;
>         err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
>                                   sizeof(user_icmph));
> @@ -111,10 +114,17 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>         else if (!oif)
>                 oif = np->ucast_oif;
> +       if (oif) {
> +               dev = dev_get_by_index(net, oif);
> +               mdev = netdev_master_upper_dev_get(dev);
> +       }
> +
>         addr_type = ipv6_addr_type(daddr);
>         if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>             (addr_type & IPV6_ADDR_MAPPED) ||
> -           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
> +           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
> +                   !(mdev && sk->sk_bound_dev_if &&
> +                             mdev != dev_get_by_index(net, sk->sk_bound_dev_if))))
>                 return -EINVAL;
>         ipcm6_init_sk(&ipc6, np);
> 
> I am obviously doing something very stupid.

The problem is that dev_get_by_index() holds a reference on 'dev' which
your code never releases. Also netdev_master_upper_dev_get() needs rtnl
protection. These should have generated some kernel oops.

You can try this instead:

-------- >8 --------

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index c4835dbdfcff..f804c11e2146 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -114,7 +114,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	addr_type = ipv6_addr_type(daddr);
 	if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
 	    (addr_type & IPV6_ADDR_MAPPED) ||
-	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
+	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
+	     l3mdev_master_ifindex_by_index(sock_net(sk), oif) != sk->sk_bound_dev_if))
 		return -EINVAL;
 
 	ipcm6_init_sk(&ipc6, np);


