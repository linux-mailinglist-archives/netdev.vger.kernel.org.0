Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80812A33D
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 17:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLXQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 11:40:21 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:38284 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfLXQkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 11:40:21 -0500
Received: by mail-io1-f68.google.com with SMTP id v3so19574715ioj.5
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 08:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FbplzOXkHm2MxKxi+7L4bdlNecGTr77cjWhCGnGQ3Dg=;
        b=ABGtxYAmZskID/Hrnq4YvgwkYTQUk/xLhbSnLEVA2wbB7iVuMkqJsMG8tOXrWY5CnM
         OMZOwxGxY/3EEjlgVMHp5WXi8Fau1Stcp10CN0f4ao3ws4ch6zhc4UaU7CB3iBuPfRub
         hey/ji0TF/71BYH2tZEQD2qnH/xgADKVCq3TYu4fPRHlfmRo51yYkv0UPeMDGiIoJgfL
         erMDjnH+Ss/jVvftvnkOoPqbaRId+lZrxNlqI5vw3l12K4+cf9Wn8JsGjofed/eCWBNz
         7Bx746HLetRA1eSrEbR3QNtOtwhGYpI2Tnuplba8k7dsW2jzPytmN/TOJCKEhBWUSTvh
         XkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FbplzOXkHm2MxKxi+7L4bdlNecGTr77cjWhCGnGQ3Dg=;
        b=WKHkiJsVoRbNM1HK71fA1ceYpUSGy9GS7afWuCg3sn6mt9wg3N0tueeJXvzSnWLD21
         mQYZtjdhYQUWoTGx36ZrT9vCukcrb871JctKMSolVhZ9JhX2RxN4oXW5xQY5g9sUgiq5
         70vb/0npLf8fdaGrvPchu27TBQXGeW/Nkm+z+v0Z0tJjumnemo2lhABOSJ9bZXyL4I9Y
         1OVcfUKrPf88duHqPwYig0ia/W9+0jz2lz+uXNRnALHMVgNb4si9ZKrUdOwuY0EyOpAT
         3ZvMUtpVfEqUWhApnprwVdho6azGyfn0obvNlB/vAtMskx5KV/EVjB5aDeLt0J+/Lx6c
         4T6g==
X-Gm-Message-State: APjAAAUiGM2JJesTJgBOezOOjOwqshgGU8qb9vaK3mAtXjni2s/ybSLJ
        GSUafD01qicoTRv7GStH+Ns=
X-Google-Smtp-Source: APXvYqzl9xVp2Iyp9kULXGsq3Xz6molEpGlMWx2QcWHa/ZFW/ElO07x0fG72Rjne0SBQZ7C1uWHMjg==
X-Received: by 2002:a6b:7201:: with SMTP id n1mr21729680ioc.37.1577205620770;
        Tue, 24 Dec 2019 08:40:20 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id a12sm7218309ion.73.2019.12.24.08.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 08:40:19 -0800 (PST)
Subject: Re: [PATCH net-next 1/9] net: fib_notifier: Add temporary events to
 the FIB notification chain
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4f9cc7e-f1bd-404b-6705-572b6e1390ac@gmail.com>
Date:   Tue, 24 Dec 2019 09:40:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-2-idosch@idosch.org>
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
> Subsequent patches are going to simplify the IPv6 route offload API,
> which will only use three events - replace, delete and append.
> 
> Introduce a temporary version of replace and delete in order to make the
> conversion easier to review. Note that append does not need a temporary
> version, as it is currently not used.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/fib_notifier.h | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


