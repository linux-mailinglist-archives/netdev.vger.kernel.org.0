Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDAE3636EE
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhDRRHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 13:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhDRRHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 13:07:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044BEC06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:06:43 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q11so3375963plx.2
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dfjqz1qNL7lj+VSz7yDIm8dV79tnTp9KJwuZmahrsl8=;
        b=aUlVLBZf+1V4kJq2O5uWUzBlKSQESGr+9omIkuS+BEekNHmUcN7iZgk5jcK/3WGdTQ
         ptORJMutfsbJX0mimeVqAjHwYFcEmIBr8s0sVpPHL31vE3mD16XFfDRn0/PnY0dZ+AK+
         idhBbwLd/qtHgAaBd1C+7R2n/YLGlYkVG13/jHbxX149vCFYHsU/QQfRms0OovO5vIux
         8nmcn/uauiDxe0+T7fR/2D/kO5AWS7t5CnAHJoBnZdG65AY6fc+6KThsWsya/qmw+eiN
         e7XPqSrTrDvHnIBME4UWtaEvB0hRWg6z05aII5wwu0H/N8TtVaI2zaTojzhyP2uOkTzZ
         fOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dfjqz1qNL7lj+VSz7yDIm8dV79tnTp9KJwuZmahrsl8=;
        b=K8wcon9yyGR6aTk2xPtZdGL817/6NmLRwT01DbS2PTvqcbEmM919RmEO46f7ZeGqG5
         PNe7hHFiFe1NOE9qO65H1ReILwi8q/Z/mhLoVRtzpsTRfezEIwxsJFSFk8GQWSTDwPRt
         3/DsmqJpEG4v09OugSCRAuEkWOJjwkaEekYPk0G6ksg/03JIsswAiu/v42Fci7KMtFb1
         xZq7hHW/9Lr68pySWdYiqb8ZrZyQ2v6QMRLyl8BpegJMx5lz78noCk2a6AO5HGTu3eJZ
         4BoAj3jf4F9g56Nf08RPzz0sVhQE0VrWIBlldMf0TWlYHJv12w2NGqQt7KRhaAyxfPuh
         vj+Q==
X-Gm-Message-State: AOAM532fmTcqVPBjN6ekwJVT2DcsmO4BxjopHaEw6yRp1sU5XuFrp+S4
        1K8GB180EQL4OuTZD/U5+y7x5nvrTfU=
X-Google-Smtp-Source: ABdhPJyQID8g9YvxVT7nhKfExfTQR5S2eYdUbxNuOrMGYoG4DjLZNZoIaG7lzzHKsKCIxYXI2dFZpA==
X-Received: by 2002:a17:90a:f992:: with SMTP id cq18mr20197566pjb.7.1618765603528;
        Sun, 18 Apr 2021 10:06:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.41.12])
        by smtp.googlemail.com with ESMTPSA id w3sm12055684pjg.7.2021.04.18.10.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 10:06:42 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] nexthop: Restart nexthop dump based on last
 dumped nexthop identifier
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210416155535.1694714-1-idosch@idosch.org>
 <20210416155535.1694714-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91838deb-c82d-444e-6a19-3926aeff87f2@gmail.com>
Date:   Sun, 18 Apr 2021 10:06:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416155535.1694714-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/21 8:55 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, a multi-part nexthop dump is restarted based on the number of
> nexthops that have been dumped so far. This can result in a lot of
> nexthops not being dumped when nexthops are simultaneously deleted:
> 
>  # ip nexthop | wc -l
>  65536
>  # ip nexthop flush
>  Dump was interrupted and may be inconsistent.
>  Flushed 36040 nexthops
>  # ip nexthop | wc -l
>  29496
> 
> Instead, restart the dump based on the nexthop identifier (fixed number)
> of the last successfully dumped nexthop:
> 
>  # ip nexthop | wc -l
>  65536
>  # ip nexthop flush
>  Dump was interrupted and may be inconsistent.
>  Flushed 65536 nexthops
>  # ip nexthop | wc -l
>  0
> 
> Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

Any reason not to put this in -net with a Fixes tag?


