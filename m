Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7978714F95D
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 19:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgBASUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 13:20:13 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:44668 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgBASUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 13:20:12 -0500
Received: by mail-pg1-f182.google.com with SMTP id x7so5394033pgl.11;
        Sat, 01 Feb 2020 10:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sc/wmcgsvsqqJPAqusNZRRjiSGWwsUdCmJftv69qgL4=;
        b=EuhES7IO0EreL19++LRkzUvPxKaR8b5xehcp3NlephRQVM3qIND/gc0ki3gfZBvfIt
         DKDLAUqS+7FXvPZvfj/i7q7WuzfR/JPUy+ThnRpliusNT31MCODc5p2ucnHDSBkeeZ73
         FuGtJ+GLpL4hiSCZdImSZRr2tnrC7cp/HD1kgSN0COXPS6kTwrW8oLZw01ELRQZgpZtQ
         NypKSvTDZd5q9po/8QwrQKsCWZ9nU6fOFjFtv85xKr3wi0kHGviGZStAvNPy5GqJBqoH
         l3bscRRtxVavDE2dUHCaycEON+TfRRZrGmRXupx9P+Y3tXpbKzdyA5NUv5yKs7TWUS7i
         pxsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sc/wmcgsvsqqJPAqusNZRRjiSGWwsUdCmJftv69qgL4=;
        b=Uvzg1em9FJSD8KUS/fdikVuAg7lLY0tgaSresGyEuJVQ4q5UozE5g8hr0TdBPYepP1
         gGOpycE3t+9YJ9cUWRAPCeXOd2Tb+GeVIX+QiZUxf1KzgCuhN2K22mwb+MGxOWlAX1Ln
         NXQwmkFVABZusbRx9aNlZpzBKkj77sbeSsX25qvvjqPoC3mMa4XbkFDfiXlTkhCMM9KB
         9MnWE3y6FQrLd5qOA8wUy8Z3NesAjVwkjRDfAJ89aSnYUR+ng7YCVFtWYE9lFLiAUHSH
         uEcEtqDEna0hHZCik/Lotjw0sI47fwH0qeH/m9Cgg5OLkw5tRdQwgO8/bQ7s/Q2glZBz
         0BCA==
X-Gm-Message-State: APjAAAWWwTpoTkysQuaGXIqVB2RvPVtlLxWH6RkeRGYa6iw8tABupzfi
        9PskV9IQhM4J/z6NMe5TjXc=
X-Google-Smtp-Source: APXvYqzf/T5Qq1zGlU3DeMkQFmTkZcoWE6uF1OlLdGiQlMxoUc/+8hBa4DPpcKCdceRASeaqqubUlg==
X-Received: by 2002:a62:1d1:: with SMTP id 200mr17043051pfb.184.1580581211911;
        Sat, 01 Feb 2020 10:20:11 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p4sm2989884pgh.14.2020.02.01.10.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 10:20:10 -0800 (PST)
Subject: Re: [PATCH v2 2/2] selftests: net: Add FIN_ACK processing order
 related latency spike test
To:     sj38.park@gmail.com, edumazet@google.com
Cc:     davem@davemloft.net, aams@amazon.com, ncardwell@google.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org, ycheng@google.com,
        David.Laight@ACULAB.COM, SeongJae Park <sjpark@amazon.de>
References: <20200201071859.4231-1-sj38.park@gmail.com>
 <20200201071859.4231-3-sj38.park@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0fc6654c-c938-3920-0097-cddc34474855@gmail.com>
Date:   Sat, 1 Feb 2020 10:20:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200201071859.4231-3-sj38.park@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/20 11:18 PM, sj38.park@gmail.com wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> This commit adds a test for FIN_ACK process races related reconnection
> latency spike issues.  The issue has described and solved by the
> previous commit ("tcp: Reduce SYN resend delay if a suspicous ACK is
> received").
> 
> The test program is configured with a server and a client process.  The
> server creates and binds a socket to a port that dynamically allocated,
> listen on it, and start a infinite loop.  Inside the loop, it accepts
> connection, reads 4 bytes from the socket, and closes the connection.
> The client is constructed as an infinite loop.  Inside the loop, it
> creates a socket with LINGER and NODELAY option, connect to the server,
> send 4 bytes data, try read some data from server.  After the read()
> returns, it measure the latency from the beginning of this loop to this
> point and if the latency is larger than 1 second (spike), print a
> message.
> 
> Signed-off-by: SeongJae Park <sjpark@amazon.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>

