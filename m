Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A0E46543F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243714AbhLARwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbhLARwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:52:49 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71167C06174A;
        Wed,  1 Dec 2021 09:49:27 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id b1-20020a4a8101000000b002c659ab1342so8081452oog.1;
        Wed, 01 Dec 2021 09:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1XDu06P04Pjz8/ikLvnu1Vrhi/zfmVsztNfuvwqajak=;
        b=LFK2JqBm/fBD40FqHMEn41tfqpj88fxmZxE0oNbwbsJi9rLMH8VIE/wYChNvNOzCVd
         Q/sPhM4knLso3/jHx/DeW/CGe7VeLyA+/7OWHfv0QuFB2qOTttShqADX/mV1LNW/544v
         MHjeZJVGsj4a0N0X+keTmesDK/9ZdOOID/HAHRrACObd1+CPix8xOerNWJUGK+0UcjcU
         PF5lhq3tmbuSAatkCLaoopfDh0iSMu+UyrevTgvb36UfX5Lq6NjrBTQJPg0Hiw2wNycN
         XCyp0l3vpcaG3uoSEe+AQwEA7G2F2MMaB+g2jpCUjPauHFPMk5Kzcima8JifhkNnTTTw
         8YOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1XDu06P04Pjz8/ikLvnu1Vrhi/zfmVsztNfuvwqajak=;
        b=nlqKdasUnQa1OONejuUi6lDVhPncWKw2KVzIoL7RdoX0HTTLzKMRML5MsHbXeJO0FW
         IlYNjyjrCSFX1qFQ5uGpr4dAu6e+2heV7NMKazwW20YETd9vAXLYg+4mbnz7VBBI28u8
         ja114hCOuVEiFkNyzM7diEfB5II1T2NHZUJlmANGNhpWCpQuBsvgTENRtg260oDqLjsP
         gKO4imTuywXdatNw8OaNq8OUOJ5HAOPEYrZHmk8+7KlulscaydXLJOeq/5/M8JAUn3n1
         7jR3biveYxPVF0MGIL/pYHnwz7Y57rHnn/UrYfeU7Ut+b/BquWWa8kU7GNAbLa5hqM4i
         iF1A==
X-Gm-Message-State: AOAM531xXQvR9icBGJ+9eozJU9XA6XNa+thfSBVhPZOU8zSGdYZL6ymD
        wRyWgXY0vjdMK+58va16XCgjbOutUvbE/A==
X-Google-Smtp-Source: ABdhPJys07tIqMlr8hwT3qISM9EXA2JC7AHZrq2a4Y/0c29uQKU7jCi/EdAzeac5JUzAG0+iYUAD2w==
X-Received: by 2002:a05:6820:30b:: with SMTP id l11mr5316875ooe.32.1638380966836;
        Wed, 01 Dec 2021 09:49:26 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a3sm147030oti.29.2021.12.01.09.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 09:49:26 -0800 (PST)
Message-ID: <2c8bf94e-1265-2f3c-98ae-dfc73598f8f2@gmail.com>
Date:   Wed, 1 Dec 2021 10:49:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <4c0170fa-5b6f-ff76-0eff-a83ffec9864d@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <4c0170fa-5b6f-ff76-0eff-a83ffec9864d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 7:31 AM, Pavel Begunkov wrote:
> 
> Also, as was asked, attaching a standalone .c version of the
> benchmark. Requires any relatively up-to-date liburing installed.
> 
attached command differs from the version mentioned in the cover letter:

https://github.com/isilence/liburing.git zc_v1

copying this version into that branch, removing the duplicate
definitions and it works.
