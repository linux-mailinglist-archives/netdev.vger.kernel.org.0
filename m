Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E2DD530F
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 00:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfJLWcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 18:32:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46796 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbfJLWcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 18:32:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id b8so7825867pgm.13
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 15:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EUytYsgismnGdLjrYT1f0D/ivlcB+VQ8GRyrP/oYfX8=;
        b=VBs+QBoVHJCnP5YQqA8mNk1nKouTo1snowQoHzOd1ZorebOzDaje0mcjZNemM9Oy9W
         avsbJPGLxOIZIJq7gtHlkv/c1E9VUV7XXZPQZ/76Nt3ATijiguEpuIERlb2yw4a+6AuE
         C5E9PYji+e67bpXWCgnFAifbEemiShfNMLyv0Hugcp8tRNh2Ih7x4Fa4uChKgaSbReoT
         4E0z17sWgGQPlh6RERptdtr9FHZgEolPD6nNkFJt0xcwc8tym6J0GpQMKR/ZssX7ipKq
         npB9e/vnZ9VxEzoBKpr2P23jKUvXU4ldADZJgJ4Uh7xfH+No7pn/1ED0hCgd4Mom0hVk
         jKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EUytYsgismnGdLjrYT1f0D/ivlcB+VQ8GRyrP/oYfX8=;
        b=lYi7YojkSJPLurSTWGbkdhCXRQIjsX4nGqd34dSL6bp7lJQ5e4u6PcwQDjoDmoVo8R
         IZ1CdP/8PouaEDkJ9wx2GJsJx6qVj8IGhCjkLmkZkjdrDwk05vyDXHhQTMoK3RheUyeY
         epSZYepkcOIhIdiQ5BPBlH/RuCXjGqB/yjz7hmddwmiMKAfMcA5zqR+3nJ4H/LcgIzR8
         NwZ/PpZKz0fEggJ4K/UeS9kquEeFX4QK40+/PQDGq43w4wYg4DgwVUTW50UYDLeS5ePj
         RXjIiTGOPrD9nXcwDVnv1vPQxJsg7MO7Fz48jyWLfBiR3U0Kh5fkH+jVmm7vGFP0hWlK
         T+eQ==
X-Gm-Message-State: APjAAAWv/fD69O3nAIf085JYXdz2meAU+QJ/eBUOH/wjMzGyJm/KsBKc
        c/0hy2DWt9+HVobIycKIvHTMPA==
X-Google-Smtp-Source: APXvYqzwerfAMCLkzfc6iw/hQmNINLGN5bzPoTAZm4z5/mB1dyyOaS8uYz7N4ku1A1iKIynFmulEig==
X-Received: by 2002:a17:90a:1617:: with SMTP id n23mr26521029pja.75.1570919519713;
        Sat, 12 Oct 2019 15:31:59 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id v28sm17346964pgn.17.2019.10.12.15.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 15:31:59 -0700 (PDT)
Date:   Sat, 12 Oct 2019 15:31:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH] netdevsim: Fix error handling in nsim_fib_init and
 nsim_fib_exit
Message-ID: <20191012153156.01d962f1@cakuba.netronome.com>
In-Reply-To: <20191011094653.18796-1-yuehaibing@huawei.com>
References: <20191011094653.18796-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Oct 2019 17:46:53 +0800, YueHaibing wrote:
> In nsim_fib_init(), if register_fib_notifier failed, nsim_fib_net_ops
> should be unregistered before return.
> 
> In nsim_fib_exit(), unregister_fib_notifier should be called before
> nsim_fib_net_ops be unregistered, otherwise may cause use-after-free:
> 
> BUG: KASAN: use-after-free in nsim_fib_event_nb+0x342/0x570 [netdevsim]
> Read of size 8 at addr ffff8881daaf4388 by task kworker/0:3/3499
> 

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 59c84b9fcf42 ("netdevsim: Restore per-network namespace accounting for fib entries")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
