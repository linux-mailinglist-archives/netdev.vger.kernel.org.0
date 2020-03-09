Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9617D92F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 07:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCIGDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 02:03:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43477 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIGDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 02:03:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id u12so4204656pgb.10
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 23:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zCA4L8/UOJ0Aaa+ZC6yuG7ZDi/cQWNvO5SeMmEnXmtU=;
        b=HBVrIfnojGaUZIpEAp6pfMgt78f/GwFjYCDdX8t7p9yE4O6iMjuPKGvssSfVtgXF2V
         0hqqWeH4EusqzaaXr0NEL/EvzzncWteAns1g8M7tn1E0JYltmERTJCuIU9a/6kedOP8y
         Uui+zjkMNAw2WZh5QGWDPPcVva3isqtmFWnMZEo2MZc2I1+rUizsbITd+7EmfSi+BhTd
         WrlZS+4Mgo4MjXVr9S1HKnR3VRDt7JkOjnpkevXNk4Mfs+A1RZYQOKy/GPw8UDJWGAM+
         4JEhqTXN42FujPJX+XLm36dPXkY1EDYBAgBWP8Q2fVnMiePPcfxCSeprS38AFon9vIr3
         D3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zCA4L8/UOJ0Aaa+ZC6yuG7ZDi/cQWNvO5SeMmEnXmtU=;
        b=s3lAX3giBrR406+nWEx5LGQJ6XlgzGvqwxBa8bQdqGF8s2p9NZh6mkeK94Jo7oizgT
         fGODuXQxl/DOF9ViSK6ZFjYIWfZlc7VxpomlfWB/4k8e4LUTYNhMO+l5G5wJ0zybOEgE
         RWECyUtn3qOFej/d9aZUXMZ5sxJfdjtv6Jm2QRiXrYbvBE+WTbeoDPXekrabsd0NDKlE
         ngBohKXM8C2kMgPNtuyDOfW/UXJCm+QLxfuxX8nvUTF6kzzSJ9XVRoTlUW6Os6EDDJtm
         khvehcZ3ShmlAaYB7XygtvanFhPtvAIo/6CdjYwkl2d3EoqtzGyQLZSUfdcNhi9Y6mJO
         49cA==
X-Gm-Message-State: ANhLgQ1t8lrr/o0uBcwbB+UexZJRiLV7EkQNVhR2qmV9JQctC9uxdsYO
        uBSeuBVfeKisM8a/eoR/WXcrJvrPR0o=
X-Google-Smtp-Source: ADFU+vu8DJQVSO4tiHkYe1BQAAcN0yG/u1tpErkWIbKac9dDtLvzwNH2uygBAqKVTmrVwre/xv8hxw==
X-Received: by 2002:a62:be0d:: with SMTP id l13mr15399329pff.217.1583733787864;
        Sun, 08 Mar 2020 23:03:07 -0700 (PDT)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id m9sm9888980pga.92.2020.03.08.23.03.06
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 08 Mar 2020 23:03:07 -0700 (PDT)
Date:   Mon, 9 Mar 2020 11:33:04 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] bareudp: remove unnecessary
 udp_encap_enable() in bareudp_socket_create()
Message-ID: <20200309060304.GA16103@martin-VirtualBox>
References: <20200308011930.6923-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200308011930.6923-1-ap420073@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 01:19:30AM +0000, Taehee Yoo wrote:
> In the current code, udp_encap_enable() is called in
> bareudp_socket_create().
> But, setup_udp_tunnel_sock() internally calls udp_encap_enable().
> So, udp_encap_enable() is unnecessary.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/bareudp.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index c9d0d68467f7..71a2f480f70e 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -250,9 +250,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
>  	tunnel_cfg.encap_destroy = NULL;
>  	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
>  
> -	if (sock->sk->sk_family == AF_INET6)
> -		udp_encap_enable();
> -
udp_encap_enable is not called for V6 sockets so we need to have the above lines of code 
>  	rcu_assign_pointer(bareudp->sock, sock);
>  	return 0;
>  }
> -- 
> 2.17.1
> 
