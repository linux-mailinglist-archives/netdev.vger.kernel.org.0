Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8387407EDD
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhILRMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 13:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhILRM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 13:12:29 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E308C061574;
        Sun, 12 Sep 2021 10:11:15 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id n27so11011342oij.0;
        Sun, 12 Sep 2021 10:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ckneqBV4m5yhzX0e5HXejAdr5h7UhHv/CJwouecS3hY=;
        b=FYSREK2SOUKrMu7bpcCoi3tSkuowJ1l329hhh+v6bQclv68FQZOPPX4wq8assuOdrY
         zYNraCjps7CTpWuU7C//dKaMuY92Ye4EW2CKMfSEMAI9lmvqNzX3fTaT9IgpZRbRw4jv
         rnZpjqc1TtrD7iQhLSnjO7HHLl5KoiAFsRj3yCBe/q6htZWZ5EKxF08yS/Btqv+lzAoB
         ZD5H5z1X/BdxoUIcJDoMTqc2478LYwLR7E5pYLUoeIMiHZEQyTmhNqw9hjdUBoWGIbU8
         1rnA7bHGN0463GjwgdFRPbx0+9tzqAqTEBZyuB7qIfRFExxY0KIIknz8ugpB2PXi2g3K
         fzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ckneqBV4m5yhzX0e5HXejAdr5h7UhHv/CJwouecS3hY=;
        b=NyUAKKujZKJk++x06UqpgvbX30pXhxOmRAo464vMu5RGHEtvko92bZ+u4/uX5Il/A9
         ZhGiyU5ahSzwDzNIE7tHlmkUw4X7YVlJNgTC8pq8uauByO4tX0loDLivGAqWqUVkDzcT
         wVgOmNJXMxD+TQCoQ5eMgBN6Y4S8qwwrkWhredr0rsNZkmg6n3rIqMblwC6AVeynktxg
         sswR8Z4oGzQALpbCEEDcLWQdwGDBXbP3IKJ7ms7XHrz2Dvl6aV+fW58NsIUclsa88coL
         3RLWbG5jL67HYsKoDV29ybKpmHwwHoK3a3OxjO9MAGQCPYzIteE/rRVJ297QlUF7uBD9
         OYSw==
X-Gm-Message-State: AOAM5323Hz1rZGehCnRI5L43PnDls/LZfY+A263bQriB1/ID5vrEF6C9
        FYdKRfRMpCQhZ5Lnq2CLox+V04pidtg=
X-Google-Smtp-Source: ABdhPJz7GTvDsTcLSgA0N48wqHnqSXJnbOo8bQ04cxkYGHpF3QQ/hCp1NQ+XUevodHyuR/nTBmGCGA==
X-Received: by 2002:a05:6808:1911:: with SMTP id bf17mr5224847oib.91.1631466674765;
        Sun, 12 Sep 2021 10:11:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id b25sm1242960ooq.6.2021.09.12.10.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 10:11:14 -0700 (PDT)
Subject: Re: [PATCH] ipv6: delay fib6_sernum increase in fib6_add
To:     zhang kai <zhangkaiheb@126.com>, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210909083918.27008-1-zhangkaiheb@126.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <51233d97-951a-aa5c-7939-ef9db20a0f1e@gmail.com>
Date:   Sun, 12 Sep 2021 11:11:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210909083918.27008-1-zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 2:39 AM, zhang kai wrote:
> only increase fib6_sernum in net namespace after add fib6_info
> successfully.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv6/ip6_fib.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


