Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3465E308425
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhA2DLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhA2DLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:11:19 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9540C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:10:38 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id i30so7365854ota.6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J4u7OEtr/C5VuNEGMxuXWVaPcFTBGWfPeuL+ZnTgwg8=;
        b=APmfq7adguHAOEf7uRGvclEO+xQleGXgOrEGstJQ8wb4efhU6nWPDSSnaSQ56O86Do
         jroaQo4igme3hRmRYo8diPL1MKy9NiOVUREOn4K+RpJ/GM5Lo3LqU2w17//Dmo/fo8J6
         ODwE++oMmMRBE5v0Rt6TTQEb5hd6yqgNkzj8f2t01abBDYUmeMOlUhO7kOTcMEF+/CMo
         IvfRbEuLG0X8NIrpAj6Bz3eGmB8JoqvrUhw9ZTTXVt/WtBjN/Q2fvIGmasTUCZbwK/3Q
         HBgaI51x/75QetXsBxLAoj/mA8h3kawwZehG1ViHZBPHVOAz4rng5eI0NZ9yBzXazFKx
         b95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J4u7OEtr/C5VuNEGMxuXWVaPcFTBGWfPeuL+ZnTgwg8=;
        b=V1FtuiLL+sb1EKpTBUWgMRea6f9KArru7fkIG1Hzu2hiOToV+2WcARjDWtcgloiz+q
         i729fIO2lMyq6DkqXSYt5t9OAm913BiJVbtJwcgaEqDYJxgbWipjdw5aBi2Ok2ivRlx2
         7eAijB7dNP9f6jfKXm/TvFHhEPcpaV5L0Qg+ZPQ+4faRRMNW626r4CsigCipd0RmenvU
         fsm4BuZEF5l48K+lvpjflb7cmz5VrHTlsVxv/yAxjDEbSYIF16bAbZZV4fFa9d9ayRds
         0QVs3jjqQ8mWCE7tqOLs6m/5vealxEmdRg88fya9ibrBHVhIWPwg+gik0SarkB83lp3R
         tP3Q==
X-Gm-Message-State: AOAM532ofhCAjg9zgFpAEOwuyaB6/MsF0TT1bGJ2um3Jf4oJO6FBfxe+
        bCV4Xs+VgwpzLFIMSK4/FNI=
X-Google-Smtp-Source: ABdhPJxNiePUmzxjjHRPRW1aZP+DxKoNbLplmbKsN2GgoYU51vmoHmwPrQDRNhqrcRT+qgG29PRsng==
X-Received: by 2002:a9d:62c8:: with SMTP id z8mr1698359otk.65.1611889838467;
        Thu, 28 Jan 2021 19:10:38 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id r5sm1717135otd.24.2021.01.28.19.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:10:37 -0800 (PST)
Subject: Re: [PATCH net-next 04/12] nexthop: Assert the invariant that a NH
 group is of only one type
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <e73db0a825d62df59f2ba11f5582e5e21711102b.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <474a4286-2ced-55ff-66a8-0f67bf5dee40@gmail.com>
Date:   Thu, 28 Jan 2021 20:10:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <e73db0a825d62df59f2ba11f5582e5e21711102b.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> Most of the code that deals with nexthop groups relies on the fact that the
> group is of exactly one well-known type. Currently there is only one type,
> "mpath", but as more next-hop group types come, it becomes desirable to
> have a central place where the setting is validated. Introduce such place
> into nexthop_create_group(), such that the check is done before the code
> that relies on that invariant is invoked.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


