Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7AC42048C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 02:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhJDAfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 20:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhJDAfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 20:35:38 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36210C0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 17:33:50 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id l20so4195197ilk.2
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 17:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qhmVOSJJhXUxmby2LZ1rQNOJIc5RXdNWyU23DEK7n9w=;
        b=iQ8RoHDKOjyS7XITWYh8JWE+d0m9R0opftmV45rBkBA6cLVBXiYBsXZM9lgOBZ4t8J
         XjUv5pJIac67t6RE+THlBPOrDUbQHQwRCqoDk9eKZOwd0EYEacoqNcp1XHJzN1qSIXmI
         7rLTgwzuQ4jjDZ+okZCNjzD0Jb9HmslR1aOkDINn6wzYhXiiE9Xmn4IxqoVuyGz6yFYb
         NO6JByUxk8Ukw7LGNvnIZ/mJnPAYSfrrWLM8EktSKV7Fhlk+iXf6ml7qE1WRQtMbw/9z
         e5xBPMQaq9Z4eOd8NaI+O4E3cUXi0KRZe+oCRsL36Xp3Vo9rgz4QloidUzdboCWbPwtG
         4ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qhmVOSJJhXUxmby2LZ1rQNOJIc5RXdNWyU23DEK7n9w=;
        b=GJxBpFxZaOAC8A3486TK6NLGgG6eQagn7KRtA9Xj21UzDuAQNltd6Yi4XnpYHDZNkC
         +OjVqI2yCcV9Q8FbZmCID24b54Rl76PZC6/ngjFX5x+oXZJVWnJ+XXSezsFaiV/+sGgp
         I0q3N8AT4pKkpWXvFFVf6+s9kADMcrZWKL33MlxTsbnJ2FtJquaOARF7Cr6bGRiRqzXf
         vpKb1t1intIH9oVaQn9XtbFs104zwGvzeOSA1inLwU92pb1dB1z9NmfUec8wNigimECd
         i83Y2JqQlpEY9N0bIqkFcd1F1zTbPQptMoj9iJ80s1gtPgPJdEuGyqaNYwd0e36PSCtC
         W7pA==
X-Gm-Message-State: AOAM533mmuOnS3NxNAjOH4GuDc25krgt1FWcRkJAD/AwU/nuNF/KEVTM
        AaRpg57li3wYvN0qu4h/XDKJSic6n6myKQ==
X-Google-Smtp-Source: ABdhPJwuaGy+C+I0qGCVJsuYwfNKSJ6frkMi2OKoC6+hmikDuYl98/BkMIuQ1I1CavrJki0xwPQaXA==
X-Received: by 2002:a05:6e02:1a6d:: with SMTP id w13mr7487830ilv.304.1633307629320;
        Sun, 03 Oct 2021 17:33:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id f21sm8086839iox.38.2021.10.03.17.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 17:33:48 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 09/12] ip: nexthop: add cache helpers
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210930113844.1829373-1-razor@blackwall.org>
 <20210930113844.1829373-10-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c036dc79-0d78-df8b-343b-fa9a913bd5cf@gmail.com>
Date:   Sun, 3 Oct 2021 18:33:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930113844.1829373-10-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 5:38 AM, Nikolay Aleksandrov wrote:
> +static struct nh_entry *ipnh_cache_add(__u32 nh_id)
> +{
> +	struct rtnl_handle cache_rth = { .fd = -1 };
> +	struct nlmsghdr *answer = NULL;
> +	struct nh_entry *nhe = NULL;
> +
> +	if (rtnl_open(&cache_rth, 0) < 0)

Set applied to iproute-next; wondering if this can be cached - avoid the
open on every nexthop.

