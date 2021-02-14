Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FEB31B03D
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 12:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhBNLlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 06:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNLlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 06:41:01 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C840AC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:40:20 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k22so2176323pll.6
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJybayAddUPLvfeqm0Y0qVxyftX3nGqk9Za5VVi1LcE=;
        b=Q3caW2U+ryf5XOgbOzbcmQZxqPB03IcBTpD1GfYQjvcyB79jrSTNexFAwtbPk7g33n
         MIssScZX9utiSiTiCNJKxxRM6rgqISckvvdkbj45sY32tkMr7LssMvMCu6iVMCH47ZTG
         j0weH4FrM5/ZU0TD0xgEMvZ3W7Thc29r8e5jGHnf0KDNm/NoqwLzLuJ7TAVhtVT8O+4p
         4GtQ+pULtVF183XkEbI9jmv4BuzKg9jKcP83pnscT5D+MwoqbgPULln/R83KYdZfAOyZ
         d3wEdfH8Naw5xCessIVEMV3Q5n6tvBtnvuupT4gZr6qrisKGqzJBOYTKFaISYhODQro8
         rHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eJybayAddUPLvfeqm0Y0qVxyftX3nGqk9Za5VVi1LcE=;
        b=e9ZnYyvHeyyLDNxPtGN1pANvkZY+n7OLqs9xZzjxDHzfTqDssNmVHMN9iViJKCmslq
         eS64mPTGZ1cx7cNHbqqFiCxGpm4GcDVtgodYlgBKWjLOElSGwK8Q21i9wVpqqn/gaOs/
         AwWY4DcxZqms5Q827Se8gBAUGPTo6Vs21LyqYLOMBaBy26z0w9AUwb01MyiDXtbfmTZp
         nCT+0NanxZwzWnniAlOG6AGtyQKXWs1i/hdB+B4OObCUpef089pJ16uqlVG7nbkW6bF3
         J0BxDKdZf2N7ZmIkn6xXOWHo7sR4VQv3Vs8u4ZFacc958MrGW2qsL6rESBVu0z5cvWCO
         BOjg==
X-Gm-Message-State: AOAM532AbhK51qidSpjMsCdfG6wJs6hAMQjD4jdDdTOjMAxvJUZLY6Xs
        tMbI+iBjCr2fd9cLPmx20Z4=
X-Google-Smtp-Source: ABdhPJwwmOF94tz7UbRtC0yZ2xbniAASzksDHqHi9SnSQJr0C8wMy2bgsb4MgFQAxcarAdxslWkL2w==
X-Received: by 2002:a17:90a:6d96:: with SMTP id a22mr11257715pjk.84.1613302820234;
        Sun, 14 Feb 2021 03:40:20 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id l25sm13974605pff.105.2021.02.14.03.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 03:40:19 -0800 (PST)
Subject: Re: [PATCH net-next v2 0/7] mld: change context from atomic to
 sleepable
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210213175038.28171-1-ap420073@gmail.com>
 <3032e730-484f-d58d-8287-44e179c27ebb@gmail.com>
Cc:     ap420073@gmail.com
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <cdd58315-0550-fb80-c1fa-f1a913f6c9e7@gmail.com>
Date:   Sun, 14 Feb 2021 20:40:14 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3032e730-484f-d58d-8287-44e179c27ebb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21. 2. 14. 오전 4:58, David Ahern wrote:
> your patches still show up as 8 individual emails.
> 
> Did you use 'git send-email --thread --no-chain-reply-to' as Jakub
> suggested? Please read the git-send-email man page for what the options do.
> 

I sent all patches individually with these options.
git send-email --thread --no-chain-reply-to 0000.patch
git send-email --thread --no-chain-reply-to 0001.patch
and so on.

So, it didn't work I think.
Then I tested the below command and it works well.
git send-email --thread --no-chain-reply-to 000*

So, the next time, it would work well.
Sorry for this,
Thanks!
