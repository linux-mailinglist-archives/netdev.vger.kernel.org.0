Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91103D013C
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbfJHTbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:31:52 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45694 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbfJHTbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:31:52 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so26929973qtj.12
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SQea00OK3ka9jXDuhRBKHumWL8mBSbuGzoBmCZp4cLI=;
        b=utFAnHNRoR857gIAjqSisjD5qqtbyb8K9KH7SQfOnY46aNGWxLwlMstEK20ANILPTt
         ivaSMSwTinFLtsoqp3xceongc4j2D3LACwj3AI0HIiht1FCxaN6HvJmoIH9GGUGVQZ2n
         TUXZFWj+Qo/HGNWRJPBmq+Qg5R9KAhe1hLW/agGn0xZ9+wXGAnh1N3kl7wrp6tPILVww
         8M3wRR4OzaZ0mwokZWtZrp/oETxmZW9uhJWna2w17wjsUkutLmH/fvMfnNkm7EHx0xJi
         oUNWh3LB9cFR3lmZR+uYRc6gDgM5sH4qxmpeSDDsraqekz9Pcg+ySxh6LP3CeoiNmf1U
         EJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SQea00OK3ka9jXDuhRBKHumWL8mBSbuGzoBmCZp4cLI=;
        b=togjGKcR5977Fr0HdV/q1gtwJQF6kKJY2kw8EV7TJkmzy04MOqqYH/3pzZejYpa2tU
         LWXMU3Rbu4rFrSFXzAu9Gp65y8eKvVScEgJeIdRnmZC4fEW2sQKrfHL2ZI+0h30jAdyh
         GVCkivAdz1aL+FY50ijworSQnDycg0lAN5jEgCPEsGUBw9/ymIqBrIrFa3nPP2jfMKwp
         GQfEu28lsAFGh0pCGPtAZu4zOU9DRzZoh3kGTJCIAuk/yahwHAVyo+tEwqKX4xkgtEke
         s2utgOOcIXbj2Ae7e7JYNVY8AWHPyNlv1ppjsgou96r5poK4Y1npp0r3Ox9Q8qr3nV0D
         W8dQ==
X-Gm-Message-State: APjAAAUcxjFlY3dfbtumr/RHHqvdG0ybhtc+ans2Y/O+o9UyPcc3Fwbi
        pS8GK32E5v9vK9b3X2Zqwsw10Q==
X-Google-Smtp-Source: APXvYqweni9ODyUGGTAnYkUoEVsJozo71xB6NjAyiQWfKg+oS1FQmPU7BS6bDq/4VYcW6VmM5kk/Ng==
X-Received: by 2002:a05:6214:1463:: with SMTP id c3mr35089195qvy.48.1570563110124;
        Tue, 08 Oct 2019 12:31:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m186sm10895155qkb.88.2019.10.08.12.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 12:31:50 -0700 (PDT)
Date:   Tue, 8 Oct 2019 12:31:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] tun: fix memory leak in error path
Message-ID: <20191008123137.23c2c954@cakuba.netronome.com>
In-Reply-To: <20191007192105.147659-1-edumazet@google.com>
References: <20191007192105.147659-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 12:21:05 -0700, Eric Dumazet wrote:
> syzbot reported a warning [1] that triggered after recent Jiri patch.
> 
> This exposes a bug that we hit already in the past (see commit
> ff244c6b29b1 ("tun: handle register_netdevice() failures properly")
> for details)
> 
> tun uses priv->destructor without an ndo_init() method.
> 
> register_netdevice() can return an error, but will
> not call priv->destructor() in some cases. Jiri recent
> patch added one more.
> 
> A long term fix would be to transfer the initialization
> of what we destroy in ->destructor() in the ndo_init()
> 
> This looks a bit risky given the complexity of tun driver.
> 
> A simpler fix is to detect after the failed register_netdevice()
> if the tun_free_netdev() function was called already.
> 
> [...]
> 
> Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Looks good, obviously. Presumably we could remove the workaround added
by commit 0ad646c81b21 ("tun: call dev_get_valid_name() before
register_netdevice()") at this point? What are your thoughts on that?

> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 812dc3a65efbb9d1ee2724e73978dbc4803ec171..1e541b08b136364302aa524e31efb62062c43faa 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2290,7 +2290,13 @@ static void tun_free_netdev(struct net_device *dev)
>  	struct tun_struct *tun = netdev_priv(dev);
>  
>  	BUG_ON(!(list_empty(&tun->disabled)));
> +
>  	free_percpu(tun->pcpu_stats);
> +	/* We clear pcpu_stats so that tun_set_iff() can tell if
> +	 * tun_free_netdev() has been called from register_netdevice().
> +	 */
> +	tun->pcpu_stats = NULL;
> +
>  	tun_flow_uninit(tun);
>  	security_tun_dev_free_security(tun->security);
>  	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
> @@ -2859,8 +2865,12 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  
>  err_detach:
>  	tun_detach_all(dev);
> -	/* register_netdevice() already called tun_free_netdev() */
> -	goto err_free_dev;
> +	/* We are here because register_netdevice() has failed.
> +	 * If register_netdevice() already called tun_free_netdev()
> +	 * while dealing with the error, tun->pcpu_stats has been cleared.
> +	 */
> +	if (!tun->pcpu_stats)
> +		goto err_free_dev;
>  
>  err_free_flow:
>  	tun_flow_uninit(tun);

