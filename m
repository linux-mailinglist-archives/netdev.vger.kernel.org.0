Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE48A308431
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhA2DV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2DVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:21:21 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9424DC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:20:41 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id f6so7360923ots.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w68W9J0C5JrGHn1u6WQ3KJu4YWOksLwkhS60ozBXoxQ=;
        b=PEdo8rk+JipiJ/a4EqwWxLMiGyomkAHPdgVr1rTRE6OoNvwJinHlBCpCSjNZS1wcQ4
         kkWu7wGZLGdx0KbSAM7FDV07KdfrKhA/tFsXeTmHC2ZGxWB3+hQ4ykaR+KjjtzgBsCn5
         XtetoO7px5YFPGHcIQ7h0UzfL8sXF2Xfb+bESblWo9kUEJkmN18F7SuaysARhvBTg02r
         d1oClDvEO5LAPRb/IFlEUDurEqLLX9B8FkyWOr7m+LaW7zZURNcBvTeAEDvMf+VSeqC3
         Y5I+Kj0+0XIxEAZcrQNSH0oW2jrAgoQ5tEzlxAhXWHSONmsGhMObuK5i4CrV4OVP7E4F
         Iqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w68W9J0C5JrGHn1u6WQ3KJu4YWOksLwkhS60ozBXoxQ=;
        b=Iy9zi8m+RLse34NfwBZX+XVjvZeFfgGSn9X42lddvoGRBLfR6XPAterKezpc/3TDku
         DBweg5DanBVXbUAXsvGBjk3aBvrX4onny6xaaXBrxrDwZpiYmI9na4cPDhnilvuSFy2V
         gYZv8kMpOMwuZfR25rSiKTqmjIBePJpQ5H2IFwCz7Pi6BJ+fyowfHqpIX26sotcJajRm
         KW9kGsgmAPCMtq1kPn5pv4hEAdNrqNxnmTPBN/R0l0/0U4fdkWHkJO2B/yZy1Ryl59ZA
         sPmWScTGIYICzIIrIeQNSfTzDr1wTBBq1xW1+orDIo0RCD7yHwdysO0FGqjtP4C4260O
         WnLQ==
X-Gm-Message-State: AOAM531V7dPnTaw6xGDS7kXw1TLMNtTYIxwZ+ROgxuqIk+OwNAJjxpmP
        bKcqyvrHv3XlzsRhh0sACYyeZFNLd20=
X-Google-Smtp-Source: ABdhPJyp91Km1vI8vz8nJ05M8Q1MTTpHYJr1s6QMZjrK2xQiLgO24IkoSiR4Gs7gaU1x2wXCuXseAg==
X-Received: by 2002:a9d:42b:: with SMTP id 40mr1776243otc.248.1611890441091;
        Thu, 28 Jan 2021 19:20:41 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id l3sm1676295ooa.12.2021.01.28.19.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:20:40 -0800 (PST)
Subject: Re: [PATCH net-next 11/12] nexthop: Add a callback parameter to
 rtm_dump_walk_nexthops()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <8f895fa4bb87f623226aaf681faec62da3ce0432.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <34d94e42-42e0-198a-84ff-add87b4d0a2f@gmail.com>
Date:   Thu, 28 Jan 2021 20:20:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <8f895fa4bb87f623226aaf681faec62da3ce0432.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> In order to allow different handling for next-hop tree dumper and for
> bucket dumper, parameterize the next-hop tree walker with a callback. Add
> rtm_dump_nexthop_cb() with just the bits relevant for next-hop tree
> dumping.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


