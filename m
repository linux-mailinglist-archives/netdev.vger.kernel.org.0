Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6AF308421
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhA2DIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhA2DIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:08:44 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF8FC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:08:04 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id s2so7363997otp.5
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgvBHzbZGxLn+aXj42Q/Bch9qJuRZ459bTnzQARHNN4=;
        b=Vs8cylotuzpaeCCAFsnUYa+Y0Y9pXaYEwg+gbZsDdkvXqk3aa7j2Rl5XUEm41fyZgj
         4EE52QhvRB1u8qMSBBThtzrQJ43vgbPOTTshrYDcegPjyTKHmy8Ri6I1xR5ygIvEb745
         84WeUHK8AcORs5THe5GYfHkXr1ISyYciH6A70M8h1pN/efw9ESkR8vaLdW0/eQdcB8rJ
         RZkg/SVD4+jGDFkVFtIympJ0e4PkDIru2BZmX5VtG88WNdIi33Cli7whzWdFCmJflwfx
         xC1qsh8gUbwjghkvpXbUyAjB5kxdWNhxA8KNUFihZxyFliEHsDOHRhu4imF6KBzTXWtL
         K+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgvBHzbZGxLn+aXj42Q/Bch9qJuRZ459bTnzQARHNN4=;
        b=ZEXT36NeaspjdP2oT9cPNlVsV0zJBtlGZU4hT/swB25teu/REnYAp9jI72Pok9KNXd
         5wsBUdhCz5+pCOaG1UIhmMHrH1YjLQ7BA7PIzG9CoeY4ZLv0zRHHAaBYKt/7Nt4kcYLU
         /9JV5KnrOmbl8nRs48f/yHTk9h+/9QkYo4r0r+BXQNPpI0xt3OY5DKPW4/OB8OlHBQQ4
         SlB3yNwajlK1Qct7zfvCNV+Qc8a8hf0QO2nJ0dQ+a/k49pIXt98W7SA/Xy8JlH8EPEZD
         XWjmuKuPdY8BzwfB7+D/NvCwZ7vxvI1QZDfha1wQadLpdysbiudQFTbMmMn0Wdw+kd87
         6HSg==
X-Gm-Message-State: AOAM530hFtLkITwnvpG34TdqncL7jKVaObtZ9DwQlXwRMlIthYkIyrN5
        DSmZK9V2kk7GLFUFB/PrSsI=
X-Google-Smtp-Source: ABdhPJxuJHoEbt/vT/SvXjF3miTA4gZeela1uA92xxCSwGqyDWK/svR9bBwUHKVSfJGG/qZjm3/mQw==
X-Received: by 2002:a9d:67d5:: with SMTP id c21mr1656121otn.247.1611889684080;
        Thu, 28 Jan 2021 19:08:04 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id h18sm1644619otr.66.2021.01.28.19.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:08:03 -0800 (PST)
Subject: Re: [PATCH net-next 02/12] nexthop: Dispatch nexthop_select_path() by
 group type
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <5c7bfb40a5aa8beacedefd9144d4e179db516569.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <07b59f55-ed2d-2412-bcc1-c97def029d00@gmail.com>
Date:   Thu, 28 Jan 2021 20:08:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <5c7bfb40a5aa8beacedefd9144d4e179db516569.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> The logic for selecting path depends on the next-hop group type. Adapt the
> nexthop_select_path() to dispatch according to the group type.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 1deb9e4df1de..43bb5f451343 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -680,16 +680,11 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
>  	return !!(state & NUD_VALID);
>  }
>  
> -struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
> +static struct nexthop *nexthop_select_path_mp(struct nh_group *nhg, int hash)

FYI: you can use nh as an abbreviation for nexthop for all static
functions in nexthop.c. Helps keep name lengths in check.

Reviewed-by: David Ahern <dsahern@kernel.org>

