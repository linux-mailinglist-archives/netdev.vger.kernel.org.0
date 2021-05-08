Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A06377362
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhEHRcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 13:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhEHRcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 13:32:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A618C061574;
        Sat,  8 May 2021 10:31:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v191so10227487pfc.8;
        Sat, 08 May 2021 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LJ2u5qenUCrHLrmZ9AtmQix1IkQW0R0KEH+pIruBj7s=;
        b=j7AJi3lW2CPsZjusQ0hMex1WmUv5v9ZbPUAOl7TAvKtlze+GM/SJpkmhDtzevq3IuF
         UXwuJM9sNWytrYC6/oVHckMRn7ImRLWctg+mvfuidBIvZ/hKhkjFIms5TGRY1RXdx4ce
         yzjQJx/Qf6CePcYnGSH2csBqTfGPFvzD8CttI3fYxahvGh6I57/ymDu9Bx7513AOmte0
         XYxBWSmv24hq/73zl/wrD38yl0hj9AYdbXQroXekPkqWEwr5APFdZdsmYYONar/TXQio
         3Z5wvyKRcPsjOm5aG2bWDifLdaBcj92Ec+tFPcr4dQwx8IQVTmeZ89pawjFXhKvC6u9Q
         40ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LJ2u5qenUCrHLrmZ9AtmQix1IkQW0R0KEH+pIruBj7s=;
        b=I/g0IYE/5m7ZkohvVXR/5MUy9Csgr9ah3nr2fXrSjtuDI76ZaXSorKVIa0C+ssfiEP
         1OWbcMKl0TJ9KrCWdzPQK3ZFxUSeMMBUzniBTr/fJ0wnlk997MxTYfzNPF0+9J7bpm3G
         /ZSCzLXiCQYLEoT/yp0XeciwDdyYe3Wrrr6CanzQ/cfMhamEP/k3WUcwr63whKIl/H1o
         2JfslSjBKj3bqDUpnBQLle18bN6H80MdwqUIO9F3/f6YbDdIYuwVrMaYBV8CHiqT0rvN
         i/E95D6ceVQyiUK7IBCZHNvaXzN16OELSkgDz3jrErUSSLrxDgQziCHCRMdglHs1wfHL
         N6gw==
X-Gm-Message-State: AOAM531sxZxe+xu+P9P1qa/YtZIupzYxMvqXwD/CixX4fBmheoi1ISBD
        5dHafDieKHowixJOmPBqoinooUj4g7Q=
X-Google-Smtp-Source: ABdhPJyotPX3a6ZH73ELinV6RqNJ3jJt5PzWp92dpgZ6eVWcLPDZUq9SZV7P/PWTFKlnIQm/T7hSdA==
X-Received: by 2002:a63:9c01:: with SMTP id f1mr16644302pge.427.1620495112141;
        Sat, 08 May 2021 10:31:52 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f3sm41176946pjo.3.2021.05.08.10.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 10:31:51 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: fix a crash if ->get_sset_count() fails
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YJaSe3RPgn7gKxZv@mwanda>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <240e9883-aec9-6c93-34a8-bb1dd63257c5@gmail.com>
Date:   Sat, 8 May 2021 10:31:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YJaSe3RPgn7gKxZv@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/21 6:30 AM, Dan Carpenter wrote:
> If ds->ops->get_sset_count() fails then it "count" is a negative error
> code such as -EOPNOTSUPP.  Because "i" is an unsigned int, the negative
> error code is type promoted to a very high value and the loop will
> corrupt memory until the system crashes.
> 
> Fix this by checking for error codes and changing the type of "i" to
> just int.
> 
> Fixes: badf3ada60ab ("net: dsa: Provide CPU port statistics to master netdev")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
