Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF6D3531D9
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 03:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhDCBRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 21:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhDCBRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 21:17:39 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B55C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 18:17:37 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso6298782oti.11
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 18:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oPBciPFOar1AJvdPHMAMXX99d5UDJedwMS6OVrEXsjA=;
        b=ngVpK+0xBL67sgyeL7DAVOeqxJUR21KJZv3AzVGr3Dh4K21xhIn71v/Rl6a4FEZ0BM
         zU+YVb0hG1fLOUNZIOVBYo2LHgmSAqfJEoX4I1UGjeyEfNO8uExVrCsrJECDfABz6Fx+
         qdzjOOaGzURJJjKq0RRdCbSp6jvB2NUeMBTC3ZCaOn6BSEgPEbLczv0xMME+vQ8gr7B6
         aRw36vry0bB/sz2zSLeQ+q/a1P4+eKaUF3Ccf4KobNXrUlM8A35wvCbrK7CGPKQOrqwL
         eQpD28qykDuwaKPuW5oGoYGovIn11csik9DK9ptBsdG6nMg8p3c8zha5VLeIMeP22RS0
         RGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oPBciPFOar1AJvdPHMAMXX99d5UDJedwMS6OVrEXsjA=;
        b=B6ujOOAarUuLE7BbKXtmFz/0Qlx2d+h0uXpKrQNH6hQ3lBD8VFC9M+bIL9N2oF2qiH
         xfFMXnOQirZqn71MuEC5Ivjj0hynAwIXUKp9wdZq8gxjIchNJ878RFpkYG+jiVZBA316
         bc+rBiJMNCoB6oi09j8dHwuYfxXDJZ/lqRGnOceyRQIhGnBvkNz8D+KhNdCtYFF4OkMt
         hLPFllAKKiuyI9un971AVG+xHxiA2PqeX1LjDIJFUrfdRcVB6x7Od605vDcnRfAUoM0V
         tO7wiAKrOV3xOIoXbiSENWmkiKrWiswNjBe6tzpu04Ac4GEM+jEnZrswuUldeHMy7gwB
         UJ9Q==
X-Gm-Message-State: AOAM5321sXTrNsVKt/mBfBL8s1YtobLSk8AQfF1GIy+fCb1Wd+14p3O0
        u+8FaMFPvb9lV7d/rALnjmKYXA3DsSc=
X-Google-Smtp-Source: ABdhPJwC0lh3WHtSL1DE3lHwGh577DTX+bhVa5ZuWu/VV1kPMb/yaxyKCjjjPHW16nOi224qKXV9lQ==
X-Received: by 2002:a9d:bf4:: with SMTP id 107mr13665737oth.252.1617412656790;
        Fri, 02 Apr 2021 18:17:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id y11sm2277486ots.80.2021.04.02.18.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 18:17:36 -0700 (PDT)
Subject: Re: [PATCH v2] ip-nexthop: support flush by id
To:     Chunmei Xu <xuchunmei@linux.alibaba.com>, idosch@idosch.org
Cc:     netdev@vger.kernel.org
References: <20210401040303.61743-1-xuchunmei@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05cb096c-63d8-1aa6-b55d-5ffc04393455@gmail.com>
Date:   Fri, 2 Apr 2021 19:17:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210401040303.61743-1-xuchunmei@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 10:03 PM, Chunmei Xu wrote:
> since id is unique for nexthop, it is heavy to dump all nexthops.
> use existing delete_nexthop to support flush by id
> 
> Signed-off-by: Chunmei Xu <xuchunmei@linux.alibaba.com>
> ---
>  ip/ipnexthop.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 

this version does not apply to iproute2-next.

