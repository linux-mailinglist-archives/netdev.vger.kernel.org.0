Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E779A135D31
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbgAIPs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:48:57 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:43609 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgAIPs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:48:56 -0500
Received: by mail-io1-f68.google.com with SMTP id n21so7550179ioo.10
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 07:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hBoM63FA+bAdgAnGDNUYorDtL9Y9TVuOyl9zNPdpgXI=;
        b=EeD9oJZTCCZrysT96AcAWoB/pl17bXAsw+67qTW33iV9XcZQPH6jnlx1I2NFj8o9wl
         oOrk94UB3S9/HG1Kl2JxxmEoU882e0Y3JAL6POEkIwwZ0Koi/Oty08zBjL+7UdTDrfUv
         J3e+SJfWCyO9FuYC+EWcbEUed2N2ot52bZhyQYiVI+3LDKNUHB7wy5mpvbYNnlT1lFHk
         FEXWHHiNVnOenfRcJWRqhXrbsAZyi1SeMqvE2SwrILaF5BXzajOEGkhTG1U/hVql/rJI
         tMu4JC7VZHgAH+UkM01KehFZeOnVTYRoxIdqSRBoOZA59znvtWbgXHSmiKQDuiZIV7Vk
         zELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBoM63FA+bAdgAnGDNUYorDtL9Y9TVuOyl9zNPdpgXI=;
        b=nCQGmAVnxXrqJzfNG/FlEXm/G44OKUYYQ5sGIkUF7ZHibHoFp9MAclIy8wtajHcHnf
         hE0Iv6AXDgxIXZWdTjyys1bqBM7uNqYPjWPoCYk8/R58H/Y1B47PXUv6A36XuKZ5eZ+V
         /1BcnMMJf1Wl/Pa/MGKLxkWU1FOHtrHVQPNXEpV5QizBL5SeQwcLMF6ycs5r/3Jp9MTG
         mDrwfpElOGtkltf3zdrD7au+K/JSgzw1bSCG0OZMjl4Gyn+RvEd/+Prh4DkhRvGtg9GR
         5uCPkaJ1XQrvD4Ngyc1SKEij/DP/iywKJtk0pUooTm+ayRM+cTEo47iWCewZ8/l7K1oY
         O/uA==
X-Gm-Message-State: APjAAAVhkUsfDdNo72zxBf8U/lR3AS795k5mEXI9sdD4yOdnYFLwMDzU
        AuG0bGUrK9XDy0NaQVWZhq1hsxvdpYA=
X-Google-Smtp-Source: APXvYqyABcZhR3126xn4Yvo9cQ1E5bJFO97SKbnLGYn/jwiRA3tBTXDi4RcdqVFBdvMZ5uiMXFZETQ==
X-Received: by 2002:a6b:c8c8:: with SMTP id y191mr8508348iof.104.1578584936134;
        Thu, 09 Jan 2020 07:48:56 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:aca7:cb60:c47a:2485? ([2601:282:800:7a:aca7:cb60:c47a:2485])
        by smtp.googlemail.com with ESMTPSA id h3sm2148511ilh.6.2020.01.09.07.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:48:55 -0800 (PST)
Subject: Re: [PATCH net-next 04/10] ipv6: Add "offload" and "trap" indications
 to routes
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20200107154517.239665-1-idosch@idosch.org>
 <20200107154517.239665-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9afd718-398a-065a-1f93-439eba0780f4@gmail.com>
Date:   Thu, 9 Jan 2020 08:48:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107154517.239665-5-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 8:45 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> In a similar fashion to previous patch, add "offload" and "trap"
> indication to IPv6 routes.
> 
> This is done by using two unused bits in 'struct fib6_info' to hold
> these indications. Capable drivers are expected to set these when
> processing the various in-kernel route notifications.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/ip6_fib.h | 11 ++++++++++-
>  net/ipv6/route.c      |  7 +++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


