Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A21283D5D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfHFWcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 18:32:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45924 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfHFWcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 18:32:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id s22so64346708qkj.12
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 15:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EGaZ8RP80FY9CmE0fn2kYCqnI1vjVxqIduIlg4yYPMA=;
        b=yMgJAm3Boa6/US3MTiXxCrBYRnxwlP1x2Dqt0vvSZdyUDvMoEHAd4GlIjzD4L/khnI
         KJwgPG9t4ZEG58uc89j+ZXACAau0F7aCpnUjcN8nm+xYwzyPPo7yYplrwr+bqRnp71ge
         GsIUaSsJSb/PxFAs4sxOp59KEVnoS5aB+wMuUygTkCYEx9fBSsQBdh+Ce5B0bGmho4MO
         SRIJy0HXsImP7++kozBuY8zQY3c27qkoRhxvBmasmW2dSQKcHjWNQzDxT5OwCmus+jfW
         WeHVDvX5VIQ350Xox+1xbUyL2t2eP0IN3+9Yulqod6U4dBTn9D4C8oHZcnQxd+ZZSbHq
         vL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EGaZ8RP80FY9CmE0fn2kYCqnI1vjVxqIduIlg4yYPMA=;
        b=PBeP9/q+87DlDcV3YRv1QqcnZteqTo2QddcKFU2u7iAqFqHw4xsW8rFI2nE5JzB8+D
         OOthkLnn20+lYhaHhwLJpsGiUMYydaF0g7iT+oRwJJIJNzZPU0O+CcWjD9xtKwJy5P5P
         5OM1U6rc1bTvXvWqPv4H6IU6NUddaI5erVTkZGWNSI5GbCYKbYBcr8yHzXaXT7h1XUZQ
         MeK/coeMr39m8hV+4SEkAKVyqkBbeUMlE15StfMiDk6e4L6JF7xoCbPYJVG2UQazrXBq
         uquUyFVF52P9a9xnW3qQZt2KJ9WelsxnGZnzZdxOYfqjXjxpS0y0AuYqnsaY9EpGmjrA
         /PuA==
X-Gm-Message-State: APjAAAU3u4YEDZBuGFGRv3IRcXBAOYDuiqkMWEOLk4RG7ENhmWDBTgGz
        w0i84myfkeA1XLQGkheM03T+GA==
X-Google-Smtp-Source: APXvYqxzWHWcSkVl7jJj/3cx270+lBA6XQMF18Q9hEC1STdP+dwcn0ftnU/H3LlhWPt5fBR8sKEpyw==
X-Received: by 2002:a37:8b86:: with SMTP id n128mr5392653qkd.446.1565130760915;
        Tue, 06 Aug 2019 15:32:40 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y6sm35551963qki.67.2019.08.06.15.32.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 15:32:40 -0700 (PDT)
Date:   Tue, 6 Aug 2019 15:32:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190806153214.25203a68@cakuba.netronome.com>
In-Reply-To: <20190806191517.8713-1-dsahern@kernel.org>
References: <20190806191517.8713-1-dsahern@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 12:15:17 -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Prior to the commit in the fixes tag, the resource controller in netdevsim
> tracked fib entries and rules per network namespace. Restore that behavior.
> 
> Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Thanks.

Let's see what Jiri says, but to me this patch seems to indeed restore
the original per-namespace accounting when the more natural way forward
may perhaps be to make nsim only count the fib entries where

	fib_info->net == devlink_net(devlink)

> -void nsim_fib_destroy(struct nsim_fib_data *data)
> +int nsim_fib_init(void)
>  {
> -	unregister_fib_notifier(&data->fib_nb);
> -	kfree(data);
> +	int err;
> +
> +	err = register_pernet_subsys(&nsim_fib_net_ops);
> +	if (err < 0) {
> +		pr_err("Failed to register pernet subsystem\n");
> +		goto err_out;
> +	}
> +
> +	err = register_fib_notifier(&nsim_fib_nb, nsim_fib_dump_inconsistent);
> +	if (err < 0) {
> +		pr_err("Failed to register fib notifier\n");

		unregister_pernet_subsys(&nsim_fib_net_ops);
?

> +		goto err_out;
> +	}
> +
> +err_out:
> +	return err;
>  }
