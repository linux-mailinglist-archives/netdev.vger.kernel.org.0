Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07929305217
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhA0FSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239272AbhA0Eji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:39:38 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B1CC061788
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:38:10 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id e70so494734ote.11
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Viq40zTHvFwKQPrVDb7y7FQByG5ZIxXW3TghaE8qVfA=;
        b=ZdyV2gBA7ldS9N46Dzy6JhKZPKFRmATvAazRL59YQ2k4++z1ghShb8/mDyQxuCKWju
         C3ubAhD6fPhMF8+gxqDGluK6rEJPawA8DPYAo90VglJTjtYYmceARdlLEVn36mTAiEh0
         /9Xh7FREdA0UzbpXJ2HACn2Sc5dX2wl5HZFWe8irdH23/yRCl37yPkXAcR2Q5qK7AYsm
         31GZd2NLWkANDoWx/oplZNWNgtz79eySlHOaKO7b0iUWBHOzLKyx/ZxoGD8IbsnmnX+r
         /KhZ48HDaGcL6cPhsyUPRvv8588Mpusn7c/Tooe9oISZTiGJHpACzr1+CDyj7zECtsLb
         3zTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Viq40zTHvFwKQPrVDb7y7FQByG5ZIxXW3TghaE8qVfA=;
        b=GDKkuwQWU3SXLRoEyJP2Zh65iCN7MPru5X+tknJ2wG+sXA7QUU/SyuOaYVlxg4b/m8
         gQ4unz+8MEVkqBUAYH7lReL3WSoXurFgSvXWNnhKi02sjXfzJpDAEkhF96kc4kCmh4hM
         hns1O3il4+YTt1KoGqaaBL+r+g0fFT4x7zCvxotwAGHbsTP9SU69H1SaeVseI576j8+T
         mVDuxhGdlifAn5JXoQVpV+of2tnOqxoz1j4Wn3C1eGanTDq78XSQ1O9ygdy4tstu22sz
         zk13hQPqGwISGzG1vwZEYp0YArikkbGYoQqss227lCHfskaJPEFrh9C1AzmvHfE/pmD7
         ouWA==
X-Gm-Message-State: AOAM533acOdaK1Ikp6Tp/Euxa+Po8Wu9uERAnAdhLaiS9ZV59aeda1Q4
        kHn18enBlbjXSIAicn/amq2FlStq06E=
X-Google-Smtp-Source: ABdhPJxjGJqvmxA0n1TZVabdE8I7qPWx2ZfLPkEgwEPjpJWmlG7X31Rq0kTd/tLCTOYCanP0DQEjuw==
X-Received: by 2002:a05:6830:3482:: with SMTP id c2mr6364616otu.59.1611722289858;
        Tue, 26 Jan 2021 20:38:09 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id 49sm176618oth.31.2021.01.26.20.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 20:38:09 -0800 (PST)
Subject: Re: [PATCH net-next 03/10] net: ipv4: Pass fib_rt_info as const to
 fib_dump_info()
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e56245ff-b30c-e1f3-f609-edec8345a250@gmail.com>
Date:   Tue, 26 Jan 2021 21:38:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> fib_dump_info() does not change 'fri', so pass it as 'const'.
> It will later allow us to invoke fib_dump_info() from
> fib_alias_hw_flags_set().
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_lookup.h    | 2 +-
>  net/ipv4/fib_semantics.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


