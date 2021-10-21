Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8844363C5
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJUOK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhJUOKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 10:10:23 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9A9C061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:08:07 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id o83so1004988oif.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=wc/Tv1JnPe5JTHtl2WCYvQx2YZQyxySJ0ERsKW7fM8E=;
        b=J6bp4hyPkMyY6KBsufIevPBlG4KiyN093DyEY0n0VvFxhrgRnFeTVN4AesmKUqA36N
         aHrj/tEeBnYwAJwBrSyXG2FmKKHwWdq9gbotppfh7sLYfA48H39qndh4kIK+MBxHWEPo
         +C8NVkouyEH4ICZzrsVs6YIQT/jkNRTzTrEblcnPBHOAf3uxVW/Z/EqgFxuswe3JrYgT
         FP9iOVR2f+b43/WBSWhtwdQyKzFIlAq4y6hr5eRHkjZ1PxCLG6BIiVo12S3VT/B8JxPY
         2Da503tahDIJDQx7W3Ig+wgew29xWFYdEKV5lUVgId6L9hVaWL7AfUp1tbpofMjHIj8a
         224w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wc/Tv1JnPe5JTHtl2WCYvQx2YZQyxySJ0ERsKW7fM8E=;
        b=7NI55N0OtcFo746egBpr88l8AeGUGp9rJU9XxiQOG0uA9Ttg8qpCPZ21nV9NmGvlOA
         SMcQcEm99GJ1N6ymmf6XQkG6a1857GvUjy7jsQ2cPJtdCxeo0ILv0Au9+yr1EaF+TICX
         ysZK66SiJ4ijy3RKMxKn8eZiXVF4QMUAy9tDfCYSu4CjxOZQbPQGlShNAD8Gn5uFpiFo
         rIf6vnAsFxD7wvMNZ73GqWEkCh7ZhK0F3bqOU+75ojGtCNzEuapC5xFklJY/yiOaxUA9
         oBqImk2exAjLmswEShBxM6Dz9f8y4nRXveu+NhylpUGZ6+HZII3SuzRB44hJosa1SfYS
         gODw==
X-Gm-Message-State: AOAM532nn71guw0d2MmqK4pGvDUJmaiIcvkIfEd/x27+H4hwGk3Q1NoR
        gS1WL3uMGR9N43hgJkna9Dz+6w9Kikg=
X-Google-Smtp-Source: ABdhPJzyyhtJtUeJ8lejaXV4dpyY5omv3e9BaMtM5nhWJJd5QH5BEkgtItSfiC8WgMxvAaz08m+UiQ==
X-Received: by 2002:a05:6808:1148:: with SMTP id u8mr4375904oiu.69.1634825287237;
        Thu, 21 Oct 2021 07:08:07 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id h26sm944037oov.28.2021.10.21.07.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:08:06 -0700 (PDT)
Message-ID: <549f780b-3afb-ca30-acfe-76522bbea36a@gmail.com>
Date:   Thu, 21 Oct 2021 08:08:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v5 1/2] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
References: <20211021003212.878786-1-prestwoj@gmail.com>
 <20211021003212.878786-2-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211021003212.878786-2-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/21 6:32 PM, James Prestwood wrote:
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 922dd73e5740..4d3b8d1463b7 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -1257,7 +1259,16 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
>  		change_info = ptr;
>  		if (change_info->flags_changed & IFF_NOARP)
>  			neigh_changeaddr(&arp_tbl, dev);
> -		if (!netif_carrier_ok(dev))
> +
> +		rcu_read_lock();
> +		in_dev = __in_dev_get_rcu(dev);
> +		if (!in_dev)
> +			evict_nocarrier = true;
> +		else
> +			evict_nocarrier = IN_DEV_ARP_EVICT_NOCARRIER(in_dev);
> +		rcu_read_unlock();

I believe the rtnl lock is held, so you can use __in_dev_get_rtnl and
avoid the rcu_read_{,un}lock.

> +
> +		if (evict_nocarrier && !netif_carrier_ok(dev))
>  			neigh_carrier_down(&arp_tbl, dev);
>  		break;
>  	default:

