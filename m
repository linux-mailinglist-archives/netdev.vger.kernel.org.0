Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21294AD042
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346888AbiBHEQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346920AbiBHEQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:16:32 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124DEC03FED4
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:16:29 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id om7so1836170pjb.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2ECPgx2kd9DJY/VdwShhzxknrwKmmkKOxR6lH5ObhdM=;
        b=QnYkR6KaEQ/6BTVq0/NVrn5/8pdnAONh6vu73yZLHHlID28WwXAgF5xubU40zDjktR
         6vyhSnSwm3iDMEdzJR8UjP8+IeEZk4yZU1fMFJLwuWyPuClV7GGBd+EgLl+hlGYbQwd5
         xfbj893ObXJMpqvhRtSIoJc0hCmEZWCy0xHLRI8Qvq8sBp5iO8xyvgGFCMCeLatDGI5j
         vbVV2IMddJeLJiIaDcmZVyZaJ8VyezH1JbGTXnlVQ6VD4MDldYLXSbwYR8vgvbi4EWdD
         Sjk1L5JhqyrR9T5FWv4NgDvXjWaK7Ku5mlWiaV+ttUViiUrlVO8DvmspYqUmnDCdW+wO
         Q6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ECPgx2kd9DJY/VdwShhzxknrwKmmkKOxR6lH5ObhdM=;
        b=Vsc2di73fmeTW98P++2OH0/pbb2WdL7PPGjJNHKUn31c8ga9zLj6E9WFuvyr+dMpCY
         xqqPz4ipAbVVrlZ9vzDgzowZYlzSvTNfcTT2g06P95dYVnHirlO2b3ZRGYb3K8rWwNP4
         48WyYm9JxzFE5PFjGOKV6n/tJ8c76JfCHh0G2cJwCzDYIs3GOAOY6aEziLnNDYJVrHRh
         Lo5gvavC6Pg06sW1mwdbVmrozRgdeNTbYqHJIBpWUVwwR2M2pkZBqAFD00JkybEvERA/
         P5Fh0ZSzHLnsFoTptYNX50wcOetGyjtFShagk5A4mX6RXHp57VXjiqrNAZ40PaDmr8Q9
         wV5A==
X-Gm-Message-State: AOAM531tgNeu6TPR32sRCUEqdx9L6KZGJ49fhFLg9cQ7w8qU2PK4SXai
        GmN1njPF5GkwoMT30wkGKWh0GAr0GLg=
X-Google-Smtp-Source: ABdhPJyTx0nm9jE33LYphkcoulJcemGXKAvhVBlvN7GDezK7tXh0ICA6XFCjnzSbmKb0JOHUymMH2g==
X-Received: by 2002:a17:902:e552:: with SMTP id n18mr2935077plf.152.1644293788644;
        Mon, 07 Feb 2022 20:16:28 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id m1sm14349243pfk.202.2022.02.07.20.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:16:28 -0800 (PST)
Message-ID: <4bc1b327-b7f0-a1da-217f-43959c75df19@gmail.com>
Date:   Mon, 7 Feb 2022 20:16:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 05/11] ipv4: add fib_net_exit_batch()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-6-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-6-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> cleanup_net() is competing with other rtnl users.
> 
> Instead of acquiring rtnl at each fib_net_exit() invocation,
> add fib_net_exit_batch() so that rtnl is acquired once.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv4/fib_frontend.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


