Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF173F9527
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbhH0HdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244198AbhH0HdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 03:33:01 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345EFC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 00:32:13 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so8497836wmd.3
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 00:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aVtU1CUSjFvPdguZrQwPpkwz1NlBGUKm5Gj8P0LPjAw=;
        b=c79/4ime8sa/Ygoahc5I5NUgZ+vOq/+i3/UVErFWED8q2RFQG8ke355X8SEuxKfMmM
         nkkXNlK2yIWQYrtrjZoe+GwIEssoctnt1FmtRmgOK38xp3sjO0OAZ73vydQhBFRn7bcG
         l0izRMMYOYknOduOu7Gq6b1AUWe4K0uaEWlPbiEXF0783bQvt37n1kYJShvxWPa7z+7t
         km/KrfImHnqiHBzRArJZJdvLyc10wl9RbXVRiTV48REkdTmCuYvMOdFvExMGF/0zgzYU
         Wvrlm/YT7DHSefGvfRbwWfhUJztiY7z9EkzXYLHfWLorf/KF0gDKPBF5bSm+kiFZNiF2
         jxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aVtU1CUSjFvPdguZrQwPpkwz1NlBGUKm5Gj8P0LPjAw=;
        b=CGZnKaPyiKP1l4/gQOy9V3i3z29qv5IO3qTM6Io5XkMzOYZfs/PRepkwN/JeahgfHm
         Ph0zbmb9vSqJJfcT7Lv//lChAmKJ6bihb5z9asEwuRGdWsugIq1KCAw1BZTRPlg1808S
         ZjRhiJQcO7KIJwJzTTp8Gn4J3H+iHFVodDnRFbcQqdUiKqWRBDtZgTHHpN+I/NeBec5a
         lY6OdBo0pf5YHR9KxSrIwl4k620OI57wC73i1fqDWuXDK7m22D9vZeoQfIptR1t0IbUg
         OVBCVHK64hQWAvs3df8gvZrSCSaH9vumlPOlD3hf1CEabMn5zCbIdmGtPGnz0jkpdyEy
         TaKw==
X-Gm-Message-State: AOAM533wBGh/Nbr6qpgMXRxGYWGKc3JwzHsBw6VoIBb2/oPB+O/c36cq
        pRPzJAWb0gVJ+S620AWxQvo78A==
X-Google-Smtp-Source: ABdhPJyfoAJtSSP3Et2qLxQ7EqyHgkVC4B3qB8XrzqYMvIk8wjGJctlyz/Z+SqvQzdz3dkH9BDkwgg==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr17817889wmj.56.1630049531731;
        Fri, 27 Aug 2021 00:32:11 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:c9d3:467d:ff28:670a? ([2a01:e0a:410:bb00:c9d3:467d:ff28:670a])
        by smtp.gmail.com with ESMTPSA id u27sm5772332wru.2.2021.08.27.00.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 00:32:11 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com,
        edumazet@google.com
References: <20210826140150.19920-1-justin.iurman@uliege.be>
 <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com>
 <1977792481.53611744.1629994989620.JavaMail.zimbra@uliege.be>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <76c2a8bf-e8c8-7402-ba20-a493fbf7c0e4@6wind.com>
Date:   Fri, 27 Aug 2021 09:32:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1977792481.53611744.1629994989620.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/08/2021 à 18:23, Justin Iurman a écrit :

[snip]

>>> Thoughts?
>> I'm not sure to understand why the current code isn't enough. The fallback
>> tunnels created by legacy IP tunnels drivers are able to receive and decapsulate
>> any encapsulated packets.
> 
> Because, right now, you need to use the ip6_tunnel module and explicitly configure a tunnel, as you described below. The goal of this patch is to provide a way to apply an ip6ip6 decapsulation *without* having to configure a tunnel.

What is the difference between setting a sysctl somewhere and putting an
interface up?
