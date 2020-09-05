Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB6E25EB95
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgIEWvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbgIEWvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 18:51:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2349C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 15:51:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d9so317256pfd.3
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 15:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lX116o0Qoe5kFHw87Ea0c4wc3ABOZRjqelXyGPNNiBU=;
        b=jjgPnSD2tHQCXdYpE7BoWXC7VB+C+ztsEVlZ5InOwRpTVubAcWFPxMfzqrPDx646lv
         epK7hMCxQdJkCdp2GVl6Vp1fLWL61kMUBEzwcj1U0PJubcz0OhiegW2e7UR1k9CCJzbl
         v7iwbulZqJDTenz61Srx+ze07kVVHPcn07U7lDrziqiFTZY0oqXe0aRayL5nbIRX/hK3
         xdxBL69wmpNs1CLGMfNe5v+rK8oHkzYVtIcDGErAzMa5tlPM9EYmBxU4h5OtKrPh62T9
         lkK4QfskEwi47xc/Coz7HEsqXqDLUpLwbWnC25DQAOamXzqF2PpFU2eUwh0k1jAPODB/
         zHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lX116o0Qoe5kFHw87Ea0c4wc3ABOZRjqelXyGPNNiBU=;
        b=nF5Pf7u+OwvCwHIBYoQ9mZSvoIWvnUW/CWdw9X7dv51D5lgp6qw7iKFDesQPcMVMcA
         w+AuU/3qL2363CSisD8esNONAIq28qwlArMNWCj/UrK2oRzcG6/vajuGflQ9K4PuK601
         jFVynYSRedQbv6gIPBIwZrA/waP6joekY2RnSusCWDyP4c4/hhKG1KAG50/clkNGgOlz
         B6S0tFSzg6MbgHP3J+GuUIukLSz/SMjIG5ApETV6gIh7B0dAJAzZ77uRsqHhoJDnF3Tq
         8eEAUpy/GYYO9gdRrJni1AA08VZWljzWwR1MbSYri5Igck4644BoivsbJKbUpNagyon6
         yPGw==
X-Gm-Message-State: AOAM531jbysl4vq6vm7Z9NlJGJcmo39O4dnCwwp24mOaDpH9qAqYDt3X
        dtEx0PMVtZ6Ke8mhLbWCsnXprXnI/u1yki0I
X-Google-Smtp-Source: ABdhPJw+hj1UlhwpttwB3xZ0HfZdN5Su+LbCIWOA8yU07/aReilPayCRJi4Afe64251GNYgTTA180A==
X-Received: by 2002:a63:d157:: with SMTP id c23mr12099358pgj.281.1599346263414;
        Sat, 05 Sep 2020 15:51:03 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t10sm8893940pgp.15.2020.09.05.15.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 15:51:02 -0700 (PDT)
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes a
 socket
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
 <20200905153947.66f28395@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bd92ec4a-459f-64ff-4fa7-c6e6db2738a7@kernel.dk>
Date:   Sat, 5 Sep 2020 16:51:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200905153947.66f28395@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/20 4:39 PM, Jakub Kicinski wrote:
> On Sat, 5 Sep 2020 16:05:48 -0600 Jens Axboe wrote:
>> No functional changes in this patch, needed to provide io_uring support
>> for shutdown(2).
>>
>> Cc: netdev@vger.kernel.org
>> Cc: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> There's a trivial io_uring patch that depends on this one. If this one
>> is acceptable to you, I'd like to queue it up in the io_uring branch for
>> 5.10.
> 
> Go for it.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks! Added your Acked-by.

-- 
Jens Axboe

