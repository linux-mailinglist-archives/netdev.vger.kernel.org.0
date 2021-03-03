Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F3432B3EF
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840312AbhCCEIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhCCDRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 22:17:33 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DA9C06178B
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 19:16:48 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id w69so24453234oif.1
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 19:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=U5nL1pHjF7dJtMnRxyrkpYjc9bJ59mGf2PZUmh4zgLM=;
        b=d7RHmmuoepI1w5LnxbVKZAbBHQcCOTdUQNLIgMSBdZD7kKFc74U8Zh/efhcuBbbDBr
         a5xrsU0cgZxto7uz+6E2jP1dN5f9nRXPMpY7YyTLEbcH1NF5ZyzmfbD7ZwsY0/p2U+6J
         KSs3SUHnljp62pl3xZj042GB1kiBt4a/jeFpftr6YiNPVM7iX3CDHWpdha2nyQcGbnaN
         O9uzClc57jEuRv5x29SEsTkxNKsb1UXVO9cd9ppdlWxtUl3Xy75fxGSluu1CJu1xLXFJ
         bnSC0/6LIig5wDaj6RMulxqgAvi6qdmGbOKF5ZoarC8j1pzl0Jthnt0QWAYufaePFyXx
         t8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U5nL1pHjF7dJtMnRxyrkpYjc9bJ59mGf2PZUmh4zgLM=;
        b=I4J7IZVNEbcY5MNCqEXmnHnuCEpVVHHSozaSLRsdDejrUXWH9V5YQuL7czg5BocPaa
         kShcQyvGPf50BNOLa4NCiTG/XNeRR/wbdZi7A/rYK+ZAwEMERiJVI/IcJGp4IgmQMJhR
         kdJIbvkLumH7NFfNYKgA7qSQ2QW+pQT2XD7wNAJYc3+Tihd2uM4vRyU0Tgv4M0Pl0dbL
         ks/aN0mFPfVKtnyUOcwP3vtVsV+SzHhMQIQUuRU0Tm/aeww65xM8jt6tJcgYsKwbSyM5
         6WK4yruSf6GNVgKNXQ4TU7CZ7T7IQBciF3A21yXGlQnpGVWnm4sfW1/8XNUpFvpGBes1
         dBnw==
X-Gm-Message-State: AOAM530LOpiFADF80awlkPbcZcLaEE6lad+31W//F+tOeQmAisE/lHwr
        hlCtfkl4146Ue81PR1fxYxHx5SFXy2c=
X-Google-Smtp-Source: ABdhPJzdF9P3BUARHtn/Jw6Ww20xj79giKOM2s2751Z5GsN+652Bu1AldBKaM8+pa7hNMjYqa5FuGQ==
X-Received: by 2002:a05:6808:aa6:: with SMTP id r6mr5749630oij.128.1614741408055;
        Tue, 02 Mar 2021 19:16:48 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id i21sm856618otj.33.2021.03.02.19.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 19:16:47 -0800 (PST)
Subject: Re: [PATCH] ipv6:delete duplicate code for reserved iid check
To:     zhang kai <zhangkaiheb@126.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20210303005321.29821-1-zhangkaiheb@126.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a24a05b-be2e-afb0-1389-3cd612ed7b52@gmail.com>
Date:   Tue, 2 Mar 2021 20:16:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303005321.29821-1-zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/21 5:53 PM, zhang kai wrote:
> Using the ipv6_reserved_interfaceid for interface id checking.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv6/addrconf.c | 45 +++++++++++++++++++--------------------------
>  1 file changed, 19 insertions(+), 26 deletions(-)
> 

Looks equivalent to me. Code wise:

Reviewed-by: David Ahern <dsahern@kernel.org>

The commit message needs more words about the change.
