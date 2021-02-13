Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F8D31ADA1
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBMS5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 13:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMS5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 13:57:45 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20DDC061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 10:57:05 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e133so2721568iof.8
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 10:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SSiIY9/WEeGpnjVB1oQnPOEx9ruzX3c6uw+HsdoUSRc=;
        b=KHHUYgRyUTtNuek5q7vcr5ntC7dzmxtDlsbFZL2eed2waujqYKU38YiHaLhc8BKIQx
         VUjNJW20LeQdZ5h4Y2qEmNGW0U7qlrrspm/DSHc0qquxUeyiP1kF1S8lysfdhNCxbeEc
         y/PSD1A1p0ciFK8DF7VeHEx7voqybsXfTOzX24YukAm5L3OOAPokoAfiAWQdwTce5LDe
         iCaL+082+LJNSbGxQmRYcgaayJUz9EsPYy1J13vEGZuRE1Yth6T7WLbee0M3oRzW48I3
         n8QHiu3YBbwnUpM6OcjA1qhHHl/inIN6k2/8h+XeR4FVsWnXVlb9zT71xs4e6l5FRFFj
         iIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SSiIY9/WEeGpnjVB1oQnPOEx9ruzX3c6uw+HsdoUSRc=;
        b=bXFAvjKvMKTjJYqSN/21RImUNS1ZmfaZQxiRk5M1yUoaX7xQQPldpcOUGV2YgQx9Jk
         Kws8aG1EzIJsMI8n+bNc2e7LFZ7uqE648xxF9Ura9QTdFVZSCs8FZn8hPXjxojlFyGH8
         i1zuhCyFbn+mdArrdksVnrm1vMnWc+pKWAGn4JdZHibaNAjskL/YFtOt6J6yrRZdmPgo
         mbrwqgtIP8O6HO11gQZvGiB7jgtDG7iAUdfkJ5uEfD2DtR+myp2KTv2+9A75p6YYdMTY
         7LwOc54JQp5Z9E/NctXiD4X5SwgvbQCeXMRcJF4YikZbR75hbRLX0iTJnV5cfKgQUCmn
         Eb2w==
X-Gm-Message-State: AOAM533ywlIcvKBKVMXeXflXSFT3AvXX0rO8NKmEC7glSqVNX/0hjJzP
        KiIEK2lKWGL1MFsIeBdCO2o=
X-Google-Smtp-Source: ABdhPJyNxH2y9OCayIbLpqOF0Ggj+/+u3onCSXHwnV41cbEQSsTUlxNBS4AhmZ1VyK6lZLZrT4vE/Q==
X-Received: by 2002:a02:83ca:: with SMTP id j10mr8032436jah.129.1613242625292;
        Sat, 13 Feb 2021 10:57:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id c4sm6423683ilm.21.2021.02.13.10.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 10:57:04 -0800 (PST)
Subject: Re: [RFC PATCH 00/13] nexthop: Resilient next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e15bfcec-7d1f-baea-6a9d-7bcc77104d8e@gmail.com>
Date:   Sat, 13 Feb 2021 11:57:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <cover.1612815057.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 1:42 PM, Petr Machata wrote:
> To illustrate the usage, consider the following commands:
> 
>  # ip nexthop add id 1 via 192.0.2.2 dev dummy1
>  # ip nexthop add id 2 via 192.0.2.3 dev dummy1
>  # ip nexthop add id 10 group 1/2 type resilient \
> 	buckets 8 idle_timer 60 unbalanced_timer 300
> 
> The last command creates a resilient next hop group. It will have 8
> buckets, each bucket will be considered idle when no traffic hits it for at
> least 60 seconds, and if the table remains out of balance for 300 seconds,
> it will be forcefully brought into balance. (If not present in netlink
> message, the idle timer defaults to 120 seconds, and there is no unbalanced
> timer, meaning the group may remain unbalanced indefinitely.)

How did you come up with the default timer of 120 seconds?

overall this looks really good.
