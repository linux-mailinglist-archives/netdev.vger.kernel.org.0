Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53378D3A15
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 09:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfJKHel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 03:34:41 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45485 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfJKHel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 03:34:41 -0400
Received: by mail-ed1-f66.google.com with SMTP id h33so7754437edh.12
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 00:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z8JWsCX1sov+NV4Hx0exNWypI70nyJieNo4YAIlxaMs=;
        b=x2GK7EXM6nzXeT7W5Op16Z5LpbJlBTjpDg3m2btD16kbG04onc6QuvBnxpl5Zls0ZU
         spK2nmHy9bmO7QMFUUydUj0TTdIzD5Gz7O8pFi3lqIRdiqXkcgJMNRnlSrWXkTf6Bumh
         Ro25+2PpBtNVuvIi08qj7MClRIezqos0WxrdCUafeTPWy9Xciv8GePqrr4PVqLWDKji2
         5pHaDSwD/uckNpq59l6LY90z6K0rCYUf/bFBs+k6XbSfSp6wjlxGRFVM0+H84AiiCNxl
         xEyzIKIcmSmVTT89hs86/lLxA4bdazIYt2PRjSEH/nFyORGlrj5/hi2TxKak2fH9qkpU
         +rkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z8JWsCX1sov+NV4Hx0exNWypI70nyJieNo4YAIlxaMs=;
        b=g4vRhLN4NT61Spf82mWjhU5An62Sa/WurslzblcxDCeNIXMpOUZ0kL+qb/Dj+7Z6yV
         P7YyimQoC5spvD0ruD2wNi/xoJI7PT1K628RnkVgBvfx1QPfrKLqPev7B6aYb89DIV7K
         3PmW3fq0G74HTvAvvMsXMtUwlOFuy1PX4ziFTBLoaq7/8wRiSLF2zK1kkefT7ZKIZGX4
         12H4wqY/AhoHSBhxHoTXoM/qnZsdyqQLGZKUJk8jJt0DqDUZ5bXij5NLRVx7qimSsTex
         58+F8A4rgUrgDF3v0NSwwX2LWzoYvrAi2cyziW4V2GKB4unUPoWJmzZaaxsoEz+jsjaJ
         DEqg==
X-Gm-Message-State: APjAAAX7vWHVE/CPrhuu1eJCcMd0L9VkA3il18No7KUV591DtDcREn3S
        4kvB9VBsisyOpja+YEcoFdvx1kk0erE=
X-Google-Smtp-Source: APXvYqy6lwEP5A3cpmmeFT/4O9WmHT+A56j5IW6YsTxmCh+zhQ2AmeoeeNLY9/xvWTYbhxiGp1wnPQ==
X-Received: by 2002:a50:c949:: with SMTP id p9mr11880621edh.25.1570779279413;
        Fri, 11 Oct 2019 00:34:39 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id k40sm1328292ede.22.2019.10.11.00.34.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Oct 2019 00:34:38 -0700 (PDT)
Date:   Fri, 11 Oct 2019 09:34:38 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/sched: fix corrupted L2 header with MPLS
 'push' and 'pop' actions
Message-ID: <20191011073437.uwtftvhofrrm5r5v@netronome.com>
References: <cover.1570732834.git.dcaratti@redhat.com>
 <d53ddea1cab35c3bd7775203aa8ce8f9a3b1ae6e.1570732834.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d53ddea1cab35c3bd7775203aa8ce8f9a3b1ae6e.1570732834.git.dcaratti@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:43:53PM +0200, Davide Caratti wrote:
> the following script:
> 
>  # tc qdisc add dev eth0 clsact
>  # tc filter add dev eth0 egress protocol ip matchall \
>  > action mpls push protocol mpls_uc label 0x355aa bos 1
> 
> causes corruption of all IP packets transmitted by eth0. On TC egress, we
> can't rely on the value of skb->mac_len, because it's 0 and a MPLS 'push'
> operation will result in an overwrite of the first 4 octets in the packet
> L2 header (e.g. the Destination Address if eth0 is an Ethernet); the same
> error pattern is present also in the MPLS 'pop' operation. Fix this error
> in act_mpls data plane, computing 'mac_len' as the difference between the
> network header and the mac header (when not at TC ingress), and use it in
> MPLS 'push'/'pop' core functions.
> 
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

