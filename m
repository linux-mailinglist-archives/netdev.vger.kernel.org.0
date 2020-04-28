Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01441BB86F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgD1II3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD1II3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:08:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF268C03C1A9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:08:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k13so23531854wrw.7
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YUAj7o9nL2m8DaSAYGzH/e0dE0ICdBviMOVl3bF0PgM=;
        b=Np2vO7sto4H3OeoenKXCo5+2CzmtGPQ29Us54cp17JJDAIK8Pj/G4HSnFHg4s3PVJB
         ExEy8n4ZQK4wIaEM752Qp1fnzI5BlkxjsD8bF5AT+Mey4ox6m3lQREQDjyqFdypmRkmP
         y5joqD5OWqLmqSdfB00QQa2Gq1f2VMcMiLYzWJBQi73fIYmBuI3pgMG23/VgK7/XWv+k
         eMWZjii/I+bVbnMqkaw/hgOBfgzBWhkOw0gXKDsKGLw3XUukKnuxFF2qA3JCX5DCqCjL
         B5Icev9Z6w9vpeNE6NUVSf/a7+ygPzgdzRCzTR90lc3o9OsL+4qFqNjT2z02vFPiuLAx
         ss+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUAj7o9nL2m8DaSAYGzH/e0dE0ICdBviMOVl3bF0PgM=;
        b=gFJLHDtq1T6+94h40Lrw28f8PWJ9qJuZ5Q942/mxgEJSGelMJhkscPH4NGJvAkn2OO
         TPL0MImdNSU2xzJrJNnkmPyv4AInxduiC6Zuw5Qmg5Tlqf8/u2iWEa3wkJcTrtYfua4x
         wyYTtKJhRpYaA13iLaOTXnqvqoQfRTP/CitSTcxxGhdLjEOdJdnJH/TPpjkf1zQBu6wx
         A/1ICOxJOnfvbLUapV8Exi5qL8n2o5qleVd1Nv6sAd1VK5RYbvzRHf0hZVS+MsTbiK7i
         w9WLOgz4h5YbUO74vSuQaNdGkIkcg7BP7ks/gz8udvLNutB7fhrSXvnYvZWspa6G8WNI
         9IMg==
X-Gm-Message-State: AGi0PuYi+xJpnFy2K1OOBGK6L6etitRgTj03WX4OLuD+VYYUGD4zgW6P
        L9OqMCeZZnrslIMbU5Tu+Zw4kQ==
X-Google-Smtp-Source: APiQypKddJ10fDB6N3lY5AmE+6anXczEr+inScltsdAv/p18+2CM1g9UCBnjoMf45gnvYw+uaR4MlQ==
X-Received: by 2002:adf:d087:: with SMTP id y7mr31586455wrh.321.1588061307463;
        Tue, 28 Apr 2020 01:08:27 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.137])
        by smtp.gmail.com with ESMTPSA id h17sm2222133wmm.6.2020.04.28.01.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 01:08:27 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 12/15] bpftool: Add support for XDP egress
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
References: <20200427224633.15627-1-dsahern@kernel.org>
 <20200427224633.15627-13-dsahern@kernel.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <1db59cc9-956e-6583-6fa9-444564e6d760@isovalent.com>
Date:   Tue, 28 Apr 2020 09:08:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427224633.15627-13-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-27 16:46 UTC-0600 ~ David Ahern <dsahern@kernel.org>
> From: David Ahern <dahern@digitalocean.com>
> 
> Add xdp_egress as a program type since it requires a new attach
> type. This follows suit with other program type + attach type
> combintations and leverages the SEC name in libbpf.
> 
> Add NET_ATTACH_TYPE_XDP_EGRESS and update attach_type_strings to
> allow a user to specify 'xdp_egress' as the attach or detach point.
> 
> Update do_attach_detach_xdp to set XDP_FLAGS_EGRESS_MODE if egress
> is selected.
> 
> Update do_xdp_dump_one to show egress program ids.
> 
> Update the documentation and help output.
> 
> Signed-off-by: David Ahern <dahern@digitalocean.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!
