Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C920454C14
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhKQRkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbhKQRkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:40:01 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48290C061570;
        Wed, 17 Nov 2021 09:37:02 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id d64so860342pgc.7;
        Wed, 17 Nov 2021 09:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tJhnrf74q/jH7xONckSlHbxsu26bF8IfZRrOkBk3520=;
        b=bd6dNnz3rWuvW49USLmvm1mxRnWOK2Z8Re3hjGYRMxXERcydK4/DXfJw12hMMSJjNh
         Q8PFqKeosskRJFSXMnNJHEFVXPPjhVXYrX+hgEktLJcGmXONH7Kaxuy05YDmEXM6r8Si
         Q6cuHAaDiAsCPAF3vY+lBPTdkYMG4tzkTmXgfAIDTBpys4y2abNE+XFoOUxWzDe0EWDh
         DhgY5/jN/IYDZKMsSg4XMwdQcSmrI05sNP7CTkOz6Vg1CJqVjMWIWZm3i+hJcXlzMdPI
         SCENrU7+VL0yGM3GjVfFwmbmyBmAvotc2tA9PHT1KpmO2gbf1exupjIEr3t9rpjKi6qQ
         2AHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tJhnrf74q/jH7xONckSlHbxsu26bF8IfZRrOkBk3520=;
        b=vPFhJBa36caT622VlYg7bYZzeb232/0/GuTAesPDtcL8ktX2fV89RbQ5Ee0f8Y2/MW
         mNDqd0XsIZi4SDXKOMU4lanM5ekmonkgqzZ5/UIh2tcpH78CTNn/AFGvu33rWKbWWXCD
         HKmTulTSZrCoExA+Bgnh2VkOgS9rKT7B6icJfGe37GsbXUw+Cz8SCst8WpGpQD0x4qgK
         0UJiEjyLPNqWSBv85p7UuBXodivjwcFCOx329jTJjla/sklGE96nOTawKEPRtmcKjO+g
         xlHTknuEpyAqyLXDBmaKwLuMk3kDAGeiBCcOmhUx4Qf9W9UbKrto0qhu9FFh2RHWUhEV
         lZyg==
X-Gm-Message-State: AOAM533ubmiiTgoN2IvA5iA56aziIlWUGrwPHwf0dCuFR43gKJ7Rzuhq
        HH5FL8vpGXHso0IihFlBQxeoXLX1KO8=
X-Google-Smtp-Source: ABdhPJxmz0Hx1ZicfrwrQ+uSOWs7iI0wCgkeGPzqeHzuulM7nqZdaJDktR9r2Bmr4NZ0d34e6qDQ1g==
X-Received: by 2002:a63:f74b:: with SMTP id f11mr6225896pgk.403.1637170621617;
        Wed, 17 Nov 2021 09:37:01 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e23sm260852pgg.68.2021.11.17.09.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 09:37:01 -0800 (PST)
Subject: Re: [PATCH net-next] neigh: introduce __neigh_confirm() for __ipv{4,
 6}_confirm_neigh
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211117120215.30209-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8696b472-efee-7801-8480-dd0a5ebf173b@gmail.com>
Date:   Wed, 17 Nov 2021 09:36:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211117120215.30209-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/21 4:02 AM, Yajun Deng wrote:
> Those __ipv4_confirm_neigh(), __ipv6_confirm_neigh() and __ipv6_confirm_neigh_stub()
> functions have similar code. introduce __neigh_confirm() for it.
> 

At first glance, this might add an indirect call ?
