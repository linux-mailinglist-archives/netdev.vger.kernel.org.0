Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E002ED432
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbhAGQXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGQXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:23:03 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C43C0612F8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:22:22 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id b24so6834557otj.0
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v8tqnTYrEy7llBdGwoGLTQzXUn5p2OM1JaJB7GFn73k=;
        b=KKOc0Z5iHbV/14x08wKkjsfyEZddZHT9ZpN7qvBTOxkwkoFSXLLCmdS+P9Qw0ugOZU
         iM+F0FfGlJnYn0ZyhR8cEY6co/TwrdDpUalApqFQrr6ZbcuI2MAbVhPEWTQBdEKyUgJK
         yACVarGWlOsvtP7QoDQztScCfbl+rFQCo2WHTs7otKYNgzCVvViicxsUqQmoHuesd4kh
         FqjEwmi6DGB0fI56UM0Ir/1+taFCmugahr6lX5/Fx/7TkpwWaGQF2IG6nbwmoX4Bmnlk
         ZbQplvSrO4/1GfZEygu0gqI/g5SS/vqozrWgGjbHLpJEsJgTkmklrW3K5OBg9Oy5meM8
         4muQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8tqnTYrEy7llBdGwoGLTQzXUn5p2OM1JaJB7GFn73k=;
        b=K2lhy/8jaRx41QQ1spJKtkQ46BtEvRB3ns6yAwd/vqAbGfFmELtUxH/MSiMeZwCh/V
         /wfR6r66WYe0AAABU6/0Keqtd4wMsCj/PvbmrNbV+zYWnR6zx6ChiUx1nnIOcyih+Th/
         U5RAFK4uvGNdsQJhjYHc8cTNOpyAA4l9lP+LRfzgB0Atjz4xMcYgGG29LF26mfaKrtG9
         5ZLoUSQ9/BA9SLbm78IgKkfDOaT0svqf3o1zt4CSavlCIfBiDgOm9VJpb7cyXm6GV7uS
         jfZomwC47cpDpPpsipWUjAd6eW07+J+3+hrzkj4Y3RxQe6f/ns6qRphKTnr+kwq/wMnA
         gsFg==
X-Gm-Message-State: AOAM532jq90fVqn/OksCBUJcC0uRwfM54YyXHb1jK9RGyk6Rg/Opwf2/
        wWYlQmHl3FFyQ2VZOgLBG2k=
X-Google-Smtp-Source: ABdhPJx4rWnsEKIw+6AIaBWpb8dUBqO2b9m9fhMxKTdTFE6I/TDfi7uxVrLyriFRBAVDi5HJSQEI0A==
X-Received: by 2002:a9d:675a:: with SMTP id w26mr7120922otm.340.1610036542049;
        Thu, 07 Jan 2021 08:22:22 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:800d:24b4:c97:e28d])
        by smtp.googlemail.com with ESMTPSA id l142sm1375081oih.4.2021.01.07.08.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 08:22:21 -0800 (PST)
Subject: Re: [PATCH net 2/4] nexthop: Unlink nexthop group entry in error path
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210107144824.1135691-1-idosch@idosch.org>
 <20210107144824.1135691-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <18d7b758-5b36-dd02-c12b-c2df53ee1128@gmail.com>
Date:   Thu, 7 Jan 2021 09:22:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107144824.1135691-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 7:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> In case of error, remove the nexthop group entry from the list to which
> it was previously added.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


