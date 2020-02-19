Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1761638F9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgBSBGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:06:03 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39462 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBSBGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 20:06:02 -0500
Received: by mail-qk1-f194.google.com with SMTP id a141so11657134qkg.6;
        Tue, 18 Feb 2020 17:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OwfuP5nGjqxy79JMZZiigB23bcGhIb7riQCt1QZquPY=;
        b=i8brOLYuPtuxuL6R0n667/ZUqpFTCCpewfMKnl/XDjdTDO5M6ebkK8Uf+vUTjKUC5Z
         YgCQljZuCf7fh3grRa0glhcFtyiZo7vTZbPeBZyWl/dWwBfvmjRJw+7CA3N10hgl4IAs
         WA5AQw8j02wgCmVu2YpXkLtIUABvUHyOGP35KejxM5mk43OqXTguPRQd9ME4WMsWm69I
         Jzqf7SmIzDpdJ1idCvBR74zxFTKoTsv/Aww5SvJQPhVjuXiz9lq4rQ8GpuPX/cWmHQ+J
         UbzFi4RhGhIHaUQ4i/7PsckLQXsEMHyIx4nKnEWe4rn+mqWUoMAP8Nu46Ok7xsGqUKep
         kbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OwfuP5nGjqxy79JMZZiigB23bcGhIb7riQCt1QZquPY=;
        b=Cc7FPzNXw3zaO+PGFSZjZzZVK6eIC6qW6T3Fxy/McFP5PzGsUfbXlVe3Og9H3SALEk
         PcBLHuPrU9yvQrtiMLmgVLzmllIoUgBKprKay1m7vQYnuFp4znH/zr6gzDa8/BqhHAJw
         Opb8CQ7lL4UhrFjFWRdxfQbQSNgwhSXbhlHReOFmX6iRDQO72HCJ+HXOHLkkjtnpZ20Z
         KWvK49n1VvGtpVYdzE7qfU4+dSSqSOuGcKduNSHTcG9438pGhMyTXs1u0sqYbb6ZUQLQ
         fHofB/nHktLwWsQ5V2ZYXner6hi6RrY74AM6RJ+ZboCV6RvBmHVKck5+VRPeYJBfnj+h
         w5mg==
X-Gm-Message-State: APjAAAVg2ZDda89Kbjx98Zxaufp+nC1vrYwiLVmXLVxLQ6cFcBk8PJSp
        rN+IWKXTR2xEZb0O9jaeVJg=
X-Google-Smtp-Source: APXvYqx/zjFkEC8bz2JJmFlSRjhc4MJJfniyQ6Fjav3IyHnUNf7sVst+AnbkK6KVfJeDi9SH7hMzVA==
X-Received: by 2002:a37:e81:: with SMTP id 123mr17873898qko.193.1582074361074;
        Tue, 18 Feb 2020 17:06:01 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:5af:31c:27bd:ccb5? ([2601:282:803:7700:5af:31c:27bd:ccb5])
        by smtp.googlemail.com with ESMTPSA id g11sm130191qtc.48.2020.02.18.17.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 17:06:00 -0800 (PST)
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
To:     Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ahmed.abdelsalam@gssi.it,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
 <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
 <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
 <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
Date:   Tue, 18 Feb 2020 18:05:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 4:50 PM, Carmine Scarpitta wrote:
> Indeed both call fib_table_lookup and rt_dst_alloc are exported for modules. 
> However, several functions defined in route.c are not exported:
> - the two functions rt_cache_valid and rt_cache_route required to handle the routing cache
> - find_exception, required to support fib exceptions.
> This would require duplicating a lot of the IPv4 routing code. 
> The reason behind this change is really to reuse the IPv4 routing code instead of doing a duplication. 
> 
> For the fi member of the struct fib_result, we will fix it by initializing before "if (!tbl_known)"

The route.c code does not need to know about the fib table or fib
policy. Why do all of the existing policy options (mark, L3 domains,
uid) to direct the lookup to the table of interest not work for this use
case?
