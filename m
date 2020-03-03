Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB735177B4A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgCCP60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:58:26 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38278 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbgCCP6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:58:25 -0500
Received: by mail-qt1-f194.google.com with SMTP id e20so3177657qto.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 07:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rn809vRisbHdQ7AlPMKIEuZX36wgQDO8L3EnKX0/q4c=;
        b=HjOeBVDF1DMm/aChqdZwfmp2qfqnWIZlDfKNhEKeJNHjdxh6fMeJSsxJh64E6CNkq8
         N4sTVgNUiRB0YqeM/OwvLHAjx4iiY/wl87YwqS2HYWLsS3QkooYUwzSQxPyHNqQjklH2
         gx+YZy4VKqepJjiWjsflQxgoHJucZpWUQvg2hfOU+r87ip0fzo3FnfTejYtJvktr3wsn
         e/3s8RBRO31fVwg0FER+IrYu4kwU6b7/cF3RFqoTUBZhpoZFij5KpnEQBcq5mcMVZptC
         9VYtf66B3fBAhDpCaP5jq+XzLec2AL5OKIWkJqug00u5F1jz3rw/ZgjYP56GZVk9M3kd
         dAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rn809vRisbHdQ7AlPMKIEuZX36wgQDO8L3EnKX0/q4c=;
        b=cW1GB6+8WDXx6+Ns7TZj+zq8eQJLkBOvZ3nLCO5w2JZ5YYftqpEiFdXCrJzLSSUxQO
         JAmITBIX1LGrsGyCFy2mh6ULJ8XIeXVjDbZr+VG/TP0kH1LHLqkJmpEUn52r5ZdwYFST
         4zlnCDUo1XhqcLOKnghkz00wg032tOHqEdXl1HdTtWJFbub99k4PnvS5X7RkboZgS67h
         Q0F7DcEX5CGtvfFbERsRaWd2FphrvOK2iZolMA6LxAL4+gYWN64Os7r9Zaj9Txm38eMS
         NWyzgghsvv7AJo+JI2n4u0Cti7LYh13hAuw+VaQQH+KduYlpNCz6ztdTmSkULZlZGUt0
         o+6Q==
X-Gm-Message-State: ANhLgQ0VlGt6B63EEUuuz5LU0mPbLc7y7wZeIepOVkSag0z96BURKDBC
        80+uA8Fz2brommRquF5sDNqusQ3D
X-Google-Smtp-Source: ADFU+vtxT7jaaNgS5kEITzRon9LjRtpDjxjC9q49Ei7N/YJhS7hjtcTsgy2s0Ez3MfOY693L22HR+w==
X-Received: by 2002:aed:2a75:: with SMTP id k50mr3360844qtf.168.1583251103446;
        Tue, 03 Mar 2020 07:58:23 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29f0:2f5d:cfa7:1ce8? ([2601:282:803:7700:29f0:2f5d:cfa7:1ce8])
        by smtp.googlemail.com with ESMTPSA id 79sm12451979qkf.129.2020.03.03.07.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:58:22 -0800 (PST)
Subject: Re: [PATCH net 2/3] net/ipv6: remove the old peer route if change it
 to a new one
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
 <20200303063736.4904-3-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1cb697e7-eefa-360d-9431-10ad95f2fd42@gmail.com>
Date:   Tue, 3 Mar 2020 08:58:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303063736.4904-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 11:37 PM, Hangbin Liu wrote:
> When we modify the peer route and changed it to a new one, we should
> remove the old route first. Before the fix:
> 
> + ip addr add dev dummy1 2001:db8::1 peer 2001:db8::2
> + ip -6 route show dev dummy1
> 2001:db8::1 proto kernel metric 256 pref medium
> 2001:db8::2 proto kernel metric 256 pref medium
> + ip addr change dev dummy1 2001:db8::1 peer 2001:db8::3
> + ip -6 route show dev dummy1
> 2001:db8::1 proto kernel metric 256 pref medium
> 2001:db8::2 proto kernel metric 256 pref medium
> 
> After the fix:
> + ip addr change dev dummy1 2001:db8::1 peer 2001:db8::3
> + ip -6 route show dev dummy1
> 2001:db8::1 proto kernel metric 256 pref medium
> 2001:db8::3 proto kernel metric 256 pref medium
> 
> This patch depend on the previous patch "net/ipv6: need update peer route
> when modify metric" to update new peer route after delete old one.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/addrconf.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


