Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36A96427E1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLELzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiLELzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:55:09 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083CC24D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:55:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id bj12so27127769ejb.13
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NBOGF8+aet6XcQembZ/mMbGiUrwTsb/R0mIXWdywGsE=;
        b=U+7fQMoWLlhqaTZGAW0g4SnUl4nQ4T8TVBumgF7yS+KLEJxHgU9B3F9C6SO1isw457
         EVxECdeUWqt+HX5Udad4fXM3XoCFElfc05/QzucjaaFpJNZgEZO+l7EavOPLmSwy3Z7U
         PZsWVpkwQkGBy1W5+P5rSuqSx1dhf383iw2ayVrfCaGRsGteCzDIjsEKmRDdzeDOb2oN
         AcGMppgg0Z+F4pRERQv9t2NcNa+onaWUWApajFJYkEU05BaWOqjZIuT4r3gFjcAtYX4/
         VCmbKxFS6fTQa5yu3LM/0lvTHDM/TLeC+YAUPZgHH2R7rtq95hStR7/AGsmpYEHRAzci
         MwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NBOGF8+aet6XcQembZ/mMbGiUrwTsb/R0mIXWdywGsE=;
        b=joa7F84A8Rjh9OEzPY1YFNIYpiGUHRKRNnBOFPaY6t2Usghjztoskxolc3hMi5EK24
         FA14aam0+QbhzKvRrM0vibEVYA5UtNw7uzXJUO3kA6RKIz55Lf5ULpRuZKddoKt//8+N
         xRxa2kbkt+mUMrl6RU/YKkDgtb5ZE0lppf2Ve/q7BefyAW9J1oY6IdcWo5g1PvB5y8DO
         7k+oMLdp0HDiOhUdMj/e1/igX2GXwjNfRqdv6h/vOXr1lLjvCOhMLhSqhTxGFo0tUJVo
         kW6FwHIc+aLJXzWbDsgIJLXSF8fn77P0CoRkfxYJTTXcl29nKvtPN+/jKEeHMh8ruxBB
         Dvwg==
X-Gm-Message-State: ANoB5pl7lcQwPWoyWDNP4jYirOHAs9vmfJU/VSYjA425vLhqKndrtyzL
        A/7vSIcSmcWUKiAOHxY2NwmtmQ==
X-Google-Smtp-Source: AA0mqf42Ezryk34OFFsHeqFlmobpp31nFpqR2UO3VacNcJL93eDDlbORJi7zcARoxre65ZzEdj1EeA==
X-Received: by 2002:a17:906:8282:b0:7c0:aa3b:9bd6 with SMTP id h2-20020a170906828200b007c0aa3b9bd6mr17316160ejx.454.1670241306512;
        Mon, 05 Dec 2022 03:55:06 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906348f00b007bf86800a0asm6091933ejb.28.2022.12.05.03.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:55:06 -0800 (PST)
Message-ID: <73405dec-e1ec-e581-ba8e-83bb8343d2b0@blackwall.org>
Date:   Mon, 5 Dec 2022 13:55:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 0/8] bridge: mcast: Preparations for EVPN
 extensions
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 09:42, Ido Schimmel wrote:
> This patchset was split from [1] and includes non-functional changes
> aimed at making it easier to add additional netlink attributes later on.
> Future extensions are available here [2].
> 
> The idea behind these patches is to create an MDB configuration
> structure into which netlink messages are parsed into. The structure is
> then passed in the entry creation / deletion call chain instead of
> passing the netlink attributes themselves. The same pattern is used by
> other rtnetlink objects such as routes and nexthops.
> 
> I initially tried to extend the current code, but it proved to be too
> difficult, which is why I decided to refactor it to the extensible and
> familiar pattern used by other rtnetlink objects.
> 
> Tested using existing selftests and using a new selftest that will be
> submitted together with the planned extensions.
> 
> No changes since initial RFC.
> 
> [1] https://lore.kernel.org/netdev/20221018120420.561846-1-idosch@nvidia.com/
> [2] https://github.com/idosch/linux/commits/submit/mdb_v1
> 
> Ido Schimmel (8):
>   bridge: mcast: Centralize netlink attribute parsing
>   bridge: mcast: Remove redundant checks
>   bridge: mcast: Use MDB configuration structure where possible
>   bridge: mcast: Propagate MDB configuration structure further
>   bridge: mcast: Use MDB group key from configuration structure
>   bridge: mcast: Remove br_mdb_parse()
>   bridge: mcast: Move checks out of critical section
>   bridge: mcast: Remove redundant function arguments
> 
>  net/bridge/br_mdb.c     | 312 +++++++++++++++++++---------------------
>  net/bridge/br_private.h |   7 +
>  2 files changed, 156 insertions(+), 163 deletions(-)
> 

As I also commented on the RFC, nice work! Allowing user-space to manipulate and manually
install such entries is a natural extension.

One thought (not a big deal) but it would've been ideal if we could initialize the config
struct once when parsing and then pass it around as a const argument. I know that its
arguments are currently passed to functions that don't expect const, but I *think* it
could be a small change.

Thanks,
 Nik

