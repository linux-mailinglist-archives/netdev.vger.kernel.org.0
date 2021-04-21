Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0736F366989
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 12:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhDUK6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 06:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDUK6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 06:58:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DF6C06174A;
        Wed, 21 Apr 2021 03:57:39 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so1069926wmg.0;
        Wed, 21 Apr 2021 03:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VAvm+Mtrjos2StRVAqzUtX1KNYRRC1JRWpY9uC7QIp0=;
        b=lJBhvGnsKvXRE2WtbQWWMl8Kf87aYvj6dH5EQrvmX//ZVwWnfNwTlSmBLL1MpLpry+
         wGXVAaVeG2unr6dHVF5QT4pRs98zC3b+lQT6FbjsZeRJNMw4JE3N6KW3QaRPh0f59QTa
         8FG6cw0qFFaS2FCyq5Ii4/u7NaCKyUUo/fLlW+tgXFzdnNIBrcVNY4WJ2YwekjQmuv5/
         TMs1j5opm2tKkHL9IhsLUhbPSb0UcPTKrkzMOszsOP2hxHz7QVhc4BhEBmLtDUKJdFeN
         9yC2l2iVFHpBe/dUGDfwLHV8lA380LZksVYzR4iUAsG8ET8EoghGl7UPwqsI7tTXFabY
         fUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VAvm+Mtrjos2StRVAqzUtX1KNYRRC1JRWpY9uC7QIp0=;
        b=HJjDUm0ck/auVviFN3+oNi4NBNei+HyJPDMBc1/LkyEilmeFIjWdBHRvuwSFE9Tv0v
         8yanPUDQb/V7r+2w4ZN9oLdkDb/1xsWyiTtW4wo3+7zn4+VZ8dmnOSIJqAtnchrG47JB
         9D8/uU3KJ6MNhZLKaeIYg/sJgo/fJOvDytzxAojJsmxeUw3KAtwTiVI86sYleCbRpJDx
         2UOMbPjVJqz7FpgHV6kunDCDYw1XD7VlPdTdnbjUlklkSfhJuAVQHU2JhpBQH+zkeemy
         bkQmozYrnlpfEuWxroZQIcVwcgyZRR/PlEbx6KycsihjozuLtXJiS2Q84PVpyB1FpneV
         drQA==
X-Gm-Message-State: AOAM533xhQNPGGGCgWwYwo3ehC8Q5Kb3shzCMiJyKF7AUL+QWcjIfene
        IDvBP614/nhxtf0M0Dl6CwLaBVTBIOYHQw==
X-Google-Smtp-Source: ABdhPJwuhJLJnt7K4J4fL/WQ/zQ94Xql9xNKmtWGmXWRZhcNba1YXJh4oT9eqiXQrJ62t7VFfkykNA==
X-Received: by 2002:a05:600c:4b92:: with SMTP id e18mr9519184wmp.150.1619002658628;
        Wed, 21 Apr 2021 03:57:38 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id t20sm1914447wmi.35.2021.04.21.03.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 03:57:38 -0700 (PDT)
Subject: Re: [PATCH] net: sfc: Fix kernel panic introduced by commit
 044588b96372 ("sfc: define inner/outer csum offload TXQ types")
To:     Yury Vostrikov <mon@unformed.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20210420194203.24759-1-mon@unformed.ru>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <31ac7255-1c45-bb90-316d-751cb3186946@gmail.com>
Date:   Wed, 21 Apr 2021 11:57:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210420194203.24759-1-mon@unformed.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2021 20:42, Yury Vostrikov wrote:
> efx_get_tx_queue(efx, qid / EFX_MAX_TXQ_PER_CHANNEL,
>                       qid % EFX_MAX_TXQ_PER_CHANNEL);
> 
> This uses qid / EFX_MAX_TXQ_PER_CHANNEL as index inside
> efx_nic->channels[] and qid % EFX_MAX_TXQ_PER_CHANNEL as index inside
> channel->tx_queue_be_type[].
> 
> Indexing into bitset mapping with modulo operation seems to oversight
> from the previous refactoring.

This should be fixed by 5b1faa92289b ("sfc: farch: fix TX queue lookup
 in TX flush done handling") and 83b09a180741 ("sfc: farch: fix TX queue
 lookup in TX event handling"), which were applied to 'net' this morning.
Do you see any call sites that I've missed and that remain broken?
(The one in ef100_ev_tx() is technically incorrect, but qlabel is always
 0 there so it shouldn't matter.)

-ed
