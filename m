Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4C2CE6C0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbgLDD7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbgLDD7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:59:35 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E07C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:58:55 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id o9so2782233pfd.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JS+mtAo7yfLisyp1QxIYy3W/O/X9JDSEAZZ/x7Fe0G8=;
        b=OHc+Kv7W5NhwH2xw6jg7LILwtjUmGxNnMPeKjeaCFEiFH15/AuB+kM0Af/joW7nWRs
         07AaqYWurY0aHUOO/trJ1Uie7Zu4YNcfl23BJFmTCBMrmsQZBaNfPjZUkN3RhwMlUdik
         r4jpDO7nWT+VemHlkudFRzn4MjlutOFc385CTpSC2zDlYtcYNkAbFwN3Ko+m2YJNZUDt
         ABaliM01qkKb5wx9TWgL3daGvEtUd0+zT3R5CPHfYlGQKvRyd0BJEGu1fNTRlx/BFHR4
         2NJ7FhB4EFrJ6kZ0AM02NW8IlrlkyKirwAYnTduRFypLGwZ7Lbj7VhwF8xpaQlsywAGo
         +qeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JS+mtAo7yfLisyp1QxIYy3W/O/X9JDSEAZZ/x7Fe0G8=;
        b=iPfUvmjtm/3VNTxafV9j0t5rUn8VObOABKIUEDFnSFgjSpGVnBgr7sV+etuivs7Ofy
         R8Tbr+nivIOH0Ri7qR0WFB3f3bOy6wDneQV+dj4RGom0aeriMMafsJot35Dh50xNLB19
         cz1Ikj7m/qEruPGnSftMeWEQog91S8UwOWUA20UATZHImVoz78kYR5kn7khwyX3cUl2L
         6PLuv9wYNtr+UVWfahZIk9AlIdgjhZ0mq7qnmnbWa8wY986tRyWVY4wBi36C6WEkfAml
         5b4FiON+M8mLJhwFsMLuSB5cXl+6SPPbxudCag9xE2Cu9cQ33VkTjQDyRhc7UDUXp0YJ
         rhhg==
X-Gm-Message-State: AOAM5324/kC0PMg2HUtXnZIu15RWrBbCQIcxAgVSAk/ZflU5GvWw5o1o
        uHoqJtK5JymqzYyge1DSC5w96wVZmBc=
X-Google-Smtp-Source: ABdhPJwK7pDFZ0SLwtZ1rDdluP5zuSgGfsgKNaZLlRU4eCBnqQZ5vkqEk3mbc58vQC78JfFko27K2g==
X-Received: by 2002:a63:230a:: with SMTP id j10mr5788779pgj.366.1607054334063;
        Thu, 03 Dec 2020 19:58:54 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id kb12sm673481pjb.2.2020.12.03.19.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 19:58:52 -0800 (PST)
Subject: Re: [PATCH v3 net-next 4/4] net: dsa: tag_dsa: Support reception of
 packets from LAG devices
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-5-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8a27d3ac-6673-4d82-d3b0-027d4089b11e@gmail.com>
Date:   Thu, 3 Dec 2020 19:58:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201202091356.24075-5-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 1:13 AM, Tobias Waldekranz wrote:
> Packets ingressing on a LAG that egress on the CPU port, which are not
> classified as management, will have a FORWARD tag that does not
> contain the normal source device/port tuple. Instead the trunk bit
> will be set, and the port field holds the LAG id.
> 
> Since the exact source port information is not available in the tag,
> frames are injected directly on the LAG interface and thus do never
> pass through any DSA port interface on ingress.
> 
> Management frames (TO_CPU) are not affected and will pass through the
> DSA port interface as usual.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
