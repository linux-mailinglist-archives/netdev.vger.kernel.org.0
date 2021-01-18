Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DB42FA7C0
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436576AbhARRnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407246AbhARRmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:42:52 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E36C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:42:12 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o11so17064986ote.4
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6IeVIR1UrLASlyYjuQaFgwH+Arocn/4ajlnaWV4QXYw=;
        b=dcMUQ+YyPS4Q6/WM4cScyaFlZ1i69jbGrQ04CS1vWnXnd9yo2m5jPEC1M1ziIhe+UO
         IAder+vHCZr7qqFwKnfPuntHSatNiFZv2Mnin+KQiaYkaJKweuLoz+g3r6I00z6622AW
         tQCdTT5uk0K58b5fKtnoZjN9gdTqOU2dR0qNQ7o15A58KH2uw8mzzfRhmfdqMlIY45TI
         WDGVcXZjTw5wTIZ5De7rNKwVuNr1u2vb6wKDJx8QrPhaRqc3/QNxePYdVesj5L6Fzzc6
         F21ZKgJN9cauLCgB+eU1J/Zt8i1ciF1ZGKT9Gy31jKljA76RjKJ+cq0c4pbliTFLnzxl
         NR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6IeVIR1UrLASlyYjuQaFgwH+Arocn/4ajlnaWV4QXYw=;
        b=VRGLhgxZimMFpsQqpUoeWF6cF2EFHhX0vGYVcuNNj6FhdSDf7GrUp2sWRiT3+D/IH3
         YEwv9e26jsf3EeUSvQA5O7moh03R1dmdvQyM9WzVm+5Bf8sSU91nAPmJyjYcIlcdbsiZ
         Pek0v9w+ADJMeZ2IaglyQFItYaF1mqQqse8d08INCX1t+TVLPQUVHXBdhMQhVCvL+WxT
         dsZwqN762DdliYsQAwyFZcojP7mqz5lmKumWg8lgOY/40GN7ocTcb680yPweOKSO+wbc
         17S7C+CXCgsjtWH7dG106F9KBsYS4d79r6r6sDEFxRQPd6VaM4YhOClhN/cms9TfstKt
         ln9A==
X-Gm-Message-State: AOAM532q2svZPtykmrhIg9smoU2QheEZ6/SRkRnd3Aqf3vGF7WRjroOk
        Jzej7VUd4AaF0hYwErA3KRflm4wwm3I=
X-Google-Smtp-Source: ABdhPJxGrbVWS56iOsWkho7Y3pMdljgTlkNH9h8Pd1ZskCYyIqhUV8GhOVgAN6k8Q2jZDbKI8pbvNA==
X-Received: by 2002:a05:6830:1654:: with SMTP id h20mr488576otr.366.1610991732096;
        Mon, 18 Jan 2021 09:42:12 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.152])
        by smtp.googlemail.com with ESMTPSA id p28sm3916121ota.14.2021.01.18.09.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:42:11 -0800 (PST)
Subject: Re: [PATCH net-next 3/3] nexthop: Specialize rtm_nh_policy
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1610978306.git.petrm@nvidia.org>
 <13520c35442244c0d622372c12708477ac72146f.1610978306.git.petrm@nvidia.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <63aa873a-c000-64c1-35bd-4f859daec798@gmail.com>
Date:   Mon, 18 Jan 2021 10:42:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <13520c35442244c0d622372c12708477ac72146f.1610978306.git.petrm@nvidia.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 7:05 AM, Petr Machata wrote:
> This policy is currently only used for creation of new next hops and new
> next hop groups. Rename it accordingly and remove the two attributes that
> are not valid in that context: NHA_GROUPS and NHA_MASTER.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


