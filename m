Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A1531ADCB
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBMTje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMTj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:39:29 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4360FC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:38:49 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id d20so2327188ilo.4
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6MCizH7ETWIi/+xtBstJ/VHU029nE1lufmMJc+8QoLs=;
        b=KAkL1cp1nMGRGK4TkkcT1S/4H/5SYVAIADvVukGRsD3KPzHhgWwQv2+ylkJmt8Ury/
         NgzTgzRkTpBUC3zXEHsZwYzBUXUsnOu/xKsG5kXs8DSQl4vP535F/cMNh9UUWIihLzbx
         o4/OQaoOE+G4xd12FCoY1l8AtbdTrK7TLMmm6Qo5jqx3H/mYRFmlfLuW0frQYHQj5Pbm
         RRcgYyszM6M/4TUtLtL087cdCGnsmyMTph20GVKnSTsn4X+/TSTLRQOX7302Tu4JPB3R
         IhCsr2KWXwvYBYW+M8AEKqbPiW7Cxtn7yeBhraih2OvgT1U3/gKck3TEZBk4jEf5sdyw
         sipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6MCizH7ETWIi/+xtBstJ/VHU029nE1lufmMJc+8QoLs=;
        b=uSEmKLF0EC/j2KA/MWhrG+0HipB6Xw2tkxoV84jMo8V+JRlPGkMPVFNubqeHmlqpPw
         jHp1f1JMKFZOVGhz7flMBpko2cdYQbYIoAQ0lgdalMYaE06yLzP63s/Zig2pCg325YxZ
         6OcyLEuiAW+P3VtdZ0pObdcsdCZNsi5rIh3ubRgT642mir9iJc0mIp7odx+6OBo94KHt
         /XOLv/HaxPsO2yaMGArLsy5KvsZwOW4gHgbU+w7ADiLVJoNYj4Q3PDX++7T0FcUMdgDk
         AAl9FIKevrucJ0lvkOPPjm5M6ifAE2HEeEreVy14py57NKQD6838h7wy3rUFiZmkbeXY
         PeCQ==
X-Gm-Message-State: AOAM530fFza2pCKguSt6tBqN31nF+k0bnnRJZXVfsfzl37D/CNkDDA26
        pjlDDrGCdhK1c3JdZ5ftGTY=
X-Google-Smtp-Source: ABdhPJymdqigQZG68jb0Zy/EEmMJP40Wi4GTm7iuwbX7pWmIG2nVgmM0zeDUdPB4TfKJj/yk9aTfpQ==
X-Received: by 2002:a05:6e02:4ca:: with SMTP id f10mr7194424ils.112.1613245128672;
        Sat, 13 Feb 2021 11:38:48 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id o19sm6322832ioh.47.2021.02.13.11.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 11:38:48 -0800 (PST)
Subject: Re: [RFC PATCH 04/13] nexthop: Add implementation of resilient
 next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
 <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b9a8fc9e-4e0c-7e7c-0b8a-da520c9dd837@gmail.com>
Date:   Sat, 13 Feb 2021 12:38:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 1:42 PM, Petr Machata wrote:
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 5d560d381070..4ce282b0a65f 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c> @@ -734,6 +834,22 @@ static struct nexthop
*nexthop_select_path_mp(struct nh_group *nhg, int hash)
>  	return rc;
>  }
>  
> +static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)
> +{
> +	struct nh_res_table *res_table = rcu_dereference(nhg->res_table);
> +	u32 bucket_index = hash % res_table->num_nh_buckets;

Have you considered requiring the number of buckets to be a power of 2
to avoid the modulo in the hot path? Seems like those are the more
likely size options.
