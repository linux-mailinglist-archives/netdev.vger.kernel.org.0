Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFDB355CE9
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbhDFUcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhDFUcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 16:32:09 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97887C06174A;
        Tue,  6 Apr 2021 13:32:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x15so6354330wrq.3;
        Tue, 06 Apr 2021 13:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iDSBevfnSHjqAh+8L9vGNjgbXl9qa9YYnJmRsxsIFBg=;
        b=QaUYIV0eJSPkp+njCCbosiy/LsgJqkkiNdeIpM6wPHY2yAMZpXGBJrSmxm7nPIEcQd
         CtFA7VUkLT87BfWNOgtQBWtO4r/HzIKM7HybwESMgISnl5Sdy4qoGOsmw8SpEsQPLhLO
         sTKKezPtKz3zXjAeFI7GRcdLsVmhUdF/lKxh3wT5ZxJS/3gU1TcgUkC9dypwLh/QSmCk
         ahH+mVtT/fz8eOxUD2tgdw2JUpP9RYfP0eXp/10vB9J+fCE5jQaY5lPF1O0ZenA0OMUK
         pXnSBH5Li00BjghwCKJkJAfEiE2af2NZo6IXiOFj0XEuGk6nJmF/YgAOpoDy7BamkZzp
         sw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iDSBevfnSHjqAh+8L9vGNjgbXl9qa9YYnJmRsxsIFBg=;
        b=J9GNbzwM3I912A411p9U5I9439cuRoTr1P//3P5RqFVUVuUJl6UmN18Ra7INF94/W7
         5TP4HJvtCl1KzAGdbV5XnAvX3i5dcTjXrO4h7x0wRzAukVG6dcbqzKr9NY26lWafqt36
         DIICa2n/Nk2kW844z4lEn+wRh7gMceKRPxoVjVcvrU1UvfgtWjVB5OeKS2B6OhOyxB8+
         DdzXCs14NBsuObFCxr/tJKFzntjhSW4M1KFmQwlAIYs1biBMwK6bHWQw6vLhwcKyiCSO
         z9+C6dQVvmhLAQqvI5W2s6NUQjTGtoaQA+NCzfCjir3dYEn8PZRD5AZz/c4tV0JAycAb
         4q7w==
X-Gm-Message-State: AOAM532BWmewgAKqyAciXNzlDxL8ThZNITgce5qNQ4p/wLS8nu52YBp5
        xRaOScF1uM/6sc/fvV7zS7ZMT4nMfxE=
X-Google-Smtp-Source: ABdhPJy7nOZQouOdH2nLn2BBzTjZ3rSa+21agDAmE2W8D6MrRbimJWKhgNVgskyHElIMTxIb5YVSlw==
X-Received: by 2002:a05:6000:18cd:: with SMTP id w13mr86539wrq.20.1617741120204;
        Tue, 06 Apr 2021 13:32:00 -0700 (PDT)
Received: from [192.168.1.101] ([37.170.75.38])
        by smtp.gmail.com with ESMTPSA id l21sm4321075wmg.41.2021.04.06.13.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 13:31:59 -0700 (PDT)
Subject: Re: [PATCH v3] net: tun: set tun->dev->addr_len during TUNSETLINK
 processing
To:     Phillip Potter <phil@philpotter.co.uk>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210406174554.915-1-phil@philpotter.co.uk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cdf3dcac-38d8-e63f-d43a-029a9742ec4d@gmail.com>
Date:   Tue, 6 Apr 2021 22:31:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406174554.915-1-phil@philpotter.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/21 7:45 PM, Phillip Potter wrote:
> When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
> to match the appropriate type, using new tun_get_addr_len utility function
> which returns appropriate address length for given type. Fixes a
> KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> 
> Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
> Diagnosed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---

SGTM, thanks a lot.

Reviewed-by: Eric Dumazet <edumazet@google.com>

