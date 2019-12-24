Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1201912A33F
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 17:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLXQoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 11:44:25 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36261 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXQoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 11:44:24 -0500
Received: by mail-io1-f67.google.com with SMTP id r13so9508946ioa.3
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 08:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SUxgsZyApg4KkbWhZUSWoBOcaMQj+/Hebp7i0KZjw6Q=;
        b=vCoClSyxfzKoclorowq2DNQ3bERMV8EMZEI+lBNrhkjG2AkZvtcLZMyzZS3GV1Jhsu
         NF3q9/ITzr/I2FQkwyLeYYcjC22aq/kiijwdxnwi81kM5vv8qniGXQrYh8+t0FTms7M5
         Gg7qlKz2WT+Pi+3McLr+SlA4O5WHYfNwXkTFnBKZQG8hCqz45VngEM63kYM76ii00dDU
         roYBVJrv9heOe+fP7qm5QXrWwSe1WNBfghAwqVRRCHxjIlo5TjGiEgxiuX2cdHCacgGD
         dbFbaFJOnJ78semksWjF2XRDozflFQd67OM6ZvkQMeFVQNT978F6QrifL7BXpnRywI+O
         3+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SUxgsZyApg4KkbWhZUSWoBOcaMQj+/Hebp7i0KZjw6Q=;
        b=UJJ/cBstQUlpnQ8N2hpPTcHPJXg6dPS4k/aM1MPhu8Qn9dx0TDR2pZUaJhL3FyyjXZ
         4iTD2ohEDKp0o+7jkvSRgxvILzHDms+wbIql6vGbHrtzkUEu35r7rb4TvRHOV2OsL93M
         wnEVM1ED150QHFRHF1cVc+BOct3IDYoOOTChM1zeHq1fhQCujDdIhVnMd/BmXl3MFee7
         EnZTZwJMlAuZK+3zbhAXl4jSQQJ4w8W/e5q2i6dFfnBJfV4FO5iBx946uk1FEE88BZxP
         w3accZjDNB/rJNadGX0HbkjZVJ2mcrXPwjC7sRo7YrgGsMJAYLYfw8oHZTKBx52wYPMT
         qbqw==
X-Gm-Message-State: APjAAAWQi15sDKsApA9wZxnG62Igr4uWe/YrVYd4LWI+vczKxkI/WCtX
        sSoffzf3Y1+nghBxgLFazAc=
X-Google-Smtp-Source: APXvYqznkyMTRSYom6Ih8VMzd/vkHfm2MAk8yRap+6devEjPJZ6KzNWcY8ewQLYSSLh6iwLWrKkmCw==
X-Received: by 2002:a02:a898:: with SMTP id l24mr18993175jam.107.1577205864275;
        Tue, 24 Dec 2019 08:44:24 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id s10sm7106707ioc.4.2019.12.24.08.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 08:44:23 -0800 (PST)
Subject: Re: [PATCH net-next 3/9] ipv6: Notify route if replacing currently
 offloaded one
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e649aa5e-b187-0379-35be-1c4a99a59f01@gmail.com>
Date:   Tue, 24 Dec 2019 09:44:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 6:28 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Similar to the corresponding IPv4 patch, only notify the new route if it
> is replacing the currently offloaded one. Meaning, the one pointed to by
> 'fn->leaf'.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/ip6_fib.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


