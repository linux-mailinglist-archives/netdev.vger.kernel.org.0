Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B472D4529D8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhKPFiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbhKPFiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:38:06 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FD6C0E2F5C
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:48:50 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id bf8so39203365oib.6
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4X2gZrnhLwJ6Gk5x/DcF7/Ud+/oGPGT9xwEEfBNwObQ=;
        b=WxDTMRqizpyKWgO5LJ6WZGeCRVAXXsyyrbjpPw9Y1+kaBI4TZGt4GNjmFRjtB4sqD3
         /KDdVyU3xS7wVMUZHuBR6C/Rq4HzZtWf72qexGSgsWOrcHvqkacEXjeUGPUulmmXO2uH
         ZGMYIae1P+V1++TxoybPIbWt02mryvSMzGHmvwopFDctdgfF6tEpNe7BAiUBzEUmJCbt
         2O8ENtIRdE/uQSsiLCLut8fugJvI6NwhjjhilkmA66De7yNkQ4Fzhm75psl6MljyhP0i
         3xSz8aBXNwVTP7Lw/zjzOODMWJNJf2s+6ilpb+foFCRh2yED6AYqhYogv2Q2btV5QDpE
         tAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4X2gZrnhLwJ6Gk5x/DcF7/Ud+/oGPGT9xwEEfBNwObQ=;
        b=LKfy7jwsDCg7lehQzpyGtvydEb9nEA+n8y9fBOXWyYNI+eSm2TZukvHgaFNiTq1wtn
         9H9qjA/l/X0YFOq2wWMkyf5tm6tOgRucwciQgACrut6vaCWLL7NcODanb9LQpKs0Fue2
         qSE6SDloAnoXxrChFitWTk74lgiMLimKFyHyyyus7Q1sdXnGrCjASBrWLJCw0QQVOJw+
         V2jJ4EKnzxyh3VU0pYJvnI+GO/WW+IQnPk4ApG21rGjoRRSsJdQBguQx6/8pMfaiQsXt
         MUenxOtZGz6F1ulea6unhIlWU9cc8E2ks2izxUWr7Wx007aoLmKNiHaKV+p5ug/JY0gT
         x8wA==
X-Gm-Message-State: AOAM532iaGFsmAZPt6YOIjXQ02SEJ/QsG/Jnhe0gFCGAA/zgaczR1x0T
        Q39db4nWxnuESK3mb61L1oc=
X-Google-Smtp-Source: ABdhPJyYrnGM7g9s5OUBJrHgTnsscua+XTcj6EYnPB0pHYI43ge4XTnnXCejhwTUpWRjR7ji2k9UGQ==
X-Received: by 2002:aca:3e09:: with SMTP id l9mr48761656oia.131.1637030929660;
        Mon, 15 Nov 2021 18:48:49 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id g1sm2919053ooq.2.2021.11.15.18.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 18:48:49 -0800 (PST)
Message-ID: <45a9fde2-5c6d-dd9c-00a2-2681d0a8ab40@gmail.com>
Date:   Mon, 15 Nov 2021 19:48:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 02/20] tcp: remove dead code in
 __tcp_v6_send_check()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-3-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211115190249.3936899-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 12:02 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For some reason, I forgot to change __tcp_v6_send_check() at
> the same time I removed (ip_summed == CHECKSUM_PARTIAL) check
> in __tcp_v4_send_check()
> 
> Fixes: 98be9b12096f ("tcp: remove dead code after CHECKSUM_PARTIAL adoption")

Given the Fixes, should this go one through -net?
