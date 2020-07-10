Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED0721BDB4
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgGJTcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 15:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbgGJTcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:32:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E172FC08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 12:32:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f16so3036026pjt.0
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 12:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G9thzUdus1jwGwpbJqecUdLCO9kuhLvArm1gzFbZOzw=;
        b=E+KqliagRVN2uVHE/u57FGeeBa1d5ddBKbnyK2AHULwxysut9Vq+CwaW4Jeg3gwWtK
         ng/Q3XzfXME2tqPH9QyYVfNQQHepjkO2lCBYnQWD8OUEK1OB8jEdE8x/lAHJv7YgxkVb
         CKOhFl9+nX2yVi2022fy+qkmcfGBTaC+9gGPtfJeiEihCS6PMZQa/Lju5nAQUUHU0mDN
         PiOXzxR/GvoqMrLB+hfO+96L2us0A0WTdXdwiuJTKsEWCs83yBvcX8y79cL8/mrOzYCe
         KH2ZS+mfqqgAyL5OWg7XG1ai+tGzeN+Ie5zl5/oW6eaKR4/WCMarf+HujsKO+h/7qkC6
         0Naw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G9thzUdus1jwGwpbJqecUdLCO9kuhLvArm1gzFbZOzw=;
        b=PAm9vqhayhubRww8wuUk4JnY2KG4Mv0kdMUMWWk5Uk6nuAeqR/qubfuCPzBQHISdcY
         ruBaCpATl31DCCNoMerga2Ar2g6Eau24EfDjHIwTvNZfJ2GUItUnbGSKmxgjm0F7plEg
         Ir9IOxu0UmncQS61/KXmQ4MxPIgN1DKpOidJ+zuoAgqXOodSCyKZQcGIjzOnXfiLyKHW
         kGsrKWc1y5zeAqyEoluDCnPKqxvNh6Hv9JhLDhFVu/cUogFDwV0rOuc8hWMk2HkaeBbN
         R5HOSs0Oi5qtualb0+66qrYMz/Fd924PpECMR+4w9HT+AgqzPyzd/OkfoKweiDF5dbMK
         uJ2w==
X-Gm-Message-State: AOAM533q8dALq9EMjp61snS0wE314LYaRHgwfgvq/WhUAZmckJBbJ81m
        CVoLYzufH4Ss0m+kI+9B5bk=
X-Google-Smtp-Source: ABdhPJzBGy8+GkW5a7tVJa6ljbO2/pLFUcw3sLiOqfSvg82mmlfN4fJYzLtRNDonHiTDwF2eroUFOg==
X-Received: by 2002:a17:90a:ad8e:: with SMTP id s14mr7657964pjq.36.1594409527473;
        Fri, 10 Jul 2020 12:32:07 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g3sm6614489pfq.19.2020.07.10.12.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 12:32:06 -0700 (PDT)
Subject: Re: [PATCH v4 net-next] inet: Remove an unnecessary argument of
 syn_ack_recalc().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        osa-contribution-log@amazon.com, Julian Anastasov <ja@ssi.bg>
References: <20200710155759.87178-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6920caee-c422-52a6-3787-36b56e9f5120@gmail.com>
Date:   Fri, 10 Jul 2020 12:32:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710155759.87178-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/20 8:57 AM, Kuniyuki Iwashima wrote:
> Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
> retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
> if a minisock is held and a SYN+ACK is retransmitted or not.
> 
> If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
> has the same value because max_retries is overwritten by rskq_defer_accept
> in reqsk_timer_handler().
> 
> This commit adds three changes:
> - remove redundant non-zero check for rskq_defer_accept in
>    reqsk_timer_handler().
> - remove max_retries from the arguments of syn_ack_recalc() and use
>    rskq_defer_accept instead.
> - rename thresh to max_syn_ack_retries for readability.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> CC: Julian Anastasov <ja@ssi.bg>


Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks.
