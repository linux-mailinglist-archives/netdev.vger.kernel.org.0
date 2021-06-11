Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D832C3A468A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFKQds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:33:48 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:44595 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhFKQdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:33:46 -0400
Received: by mail-ej1-f45.google.com with SMTP id c10so5397495eja.11
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=X0nvZpnGky/NWn0KopF5FVyAGtyugTVgLVACKDgJ6N0=;
        b=SzrVoysPkmpkhm+YtHTNxDPDieszvX6KrHwg4BKm3oLCZOTksJURLj1yBwie1pQ4Na
         QkX282UeZs3huPBVofe6GhC9bibKNkTM9vMNuGNnhlRQ7apDKIQOdHG3hU4Vaw2zlDUp
         tyIDpI80X66xTI71mCgXo4k4uPMmH1cZ4OmW7IIj3Agmd65/LhOUzcsZz7asS4S3Io8i
         VJjxxnva3Fgw8tyGAi9kAKpt8gLblz0vSpsgHTHnRMSCR6TzUFlBx5cWnLfVtisVsxND
         /s43pqVRkzCk6bRqR/kTTx/n8DRC2Lmyheu8wNuHCJsuCh/5Bx9wYjv1cziAyLTQ99X4
         cDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=X0nvZpnGky/NWn0KopF5FVyAGtyugTVgLVACKDgJ6N0=;
        b=ug0ZhwGDcz/ANr4EgM9THmIcX3llotwmyrWPSBUsvuvppHkYbVoQIue5DvyaFT62u0
         M4ieO3oFwWUuJ1fo7KbBfb4ec0CqCFEEJKekKA4lYvZv3w66PLTPyFjvF/ib2ags+XMa
         8ZsyW6H+DMCGFSZZUmFF3SH6iRKMH3NqDMSxMZzl70FotF2tnHN0010CF36Bmu1eoGZa
         k75BUEFZz066GvYzbdoa31XwvamLY+0t0C3VSOD7kxlHIH4/aBRGKtqxybUOxVd03UWN
         Ywe4ZjrHzV8N7EEhYFxfjYwLHCEyHqy0WfaD3a8Ga8xvZFgvblRSvQYhKjWPq5xl0/7u
         487Q==
X-Gm-Message-State: AOAM531xPWxmnqh9+Ir/6xRc5oRucc5QJNK2/SVnlxynYFbZ7pDoJnaC
        L28lqEV+9Z6KLa2kVEt9QSZrUg==
X-Google-Smtp-Source: ABdhPJx5DuAyNbqVmovvIBW2ZsiwnHJaXz2jRxKlr2Sk4FcGAo2l1zfQN8RwPtEWQXWUwvxcsfpm+A==
X-Received: by 2002:a17:906:6d51:: with SMTP id a17mr4442434ejt.543.1623429047404;
        Fri, 11 Jun 2021 09:30:47 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id jo13sm2248869ejb.91.2021.06.11.09.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 09:30:46 -0700 (PDT)
Date:   Fri, 11 Jun 2021 18:30:46 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        oss-drivers@netronome.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next 12/17] nfp: remove rcu_read_lock() around XDP
 program invocation
Message-ID: <20210611163045.GC10632@netronome.com>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-13-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609103326.278782-13-toke@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Jakub

On Wed, Jun 09, 2021 at 12:33:21PM +0200, Toke Høiland-Jørgensen wrote:
> The nfp driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small.
> 
> While this is not actually an issue for the nfp driver because it doesn't
> support XDP_REDIRECT (and thus doesn't call xdp_do_flush()), the
> rcu_read_lock() is still unneeded. And With the addition of RCU annotations
> to the XDP_REDIRECT map types that take bh execution into account, lockdep
> even understands this to be safe, so there's really no reason to keep it
> around.
> 
> Cc: Simon Horman <simon.horman@netronome.com>
> Cc: oss-drivers@netronome.com
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index eeb30680b4dc..5dfa4799c34f 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -1819,7 +1819,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
>  	struct xdp_buff xdp;
>  	int idx;
>  
> -	rcu_read_lock();
>  	xdp_prog = READ_ONCE(dp->xdp_prog);
>  	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
>  	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
> @@ -2036,7 +2035,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
>  			if (!nfp_net_xdp_complete(tx_ring))
>  				pkts_polled = budget;
>  	}
> -	rcu_read_unlock();
>  
>  	return pkts_polled;
>  }
> -- 
> 2.31.1
> 
