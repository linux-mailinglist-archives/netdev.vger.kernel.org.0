Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F031AE9E
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBNBFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhBNBFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:05:14 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D82C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:04:34 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id r21so2894812otk.13
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3zCdoR6LqryXjWa4UPmKa9RdaKrcIULo6OUr1E4K3/8=;
        b=MrvwV5bz27DnDzBK1Id4V6nrEZJLnFUTqoKwfMh0UovkXf7Lh77yDJJd48q4elYxOu
         wdEjgrzK76CcEcsm6K4tW3iBSrART7y9lF1kyMvZGOipF2wRWsw3O/hKQLrNQvFQ1313
         NINt14KGN6+UdZN2ENcqE1/jYUE8UBtSgG5TQy2gWvaavxTNuLzgPNPI+d5U/zvBucU0
         8dzEYAUqAzGm4g30EzgA0gxXoS09d3k6wYlb8SbgFqC9UTO8V2hovbfI0RoYVoLKU2+q
         2tQj0eXFc/Prq6gByAjUbTeKuhrun4wA/2Jq6jQ4bJihKyaDlFVq99+1zcvxwO6zZ029
         ex/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3zCdoR6LqryXjWa4UPmKa9RdaKrcIULo6OUr1E4K3/8=;
        b=OVfJGVx6QU+70iUNLPXOzR39YnPocVi/sjzW7YtKqx/sf617RtFKYvD2N8xno+5BQ7
         a9lFyYpWKykQu9JcnynCt5uQNveTTqK6wxNBxFrFImFL2WMtFqPESqJ0Cho4qQ1WsPRt
         oM0SiJvZjJViR1xytq/i01RKFXTQFaEk3BZ1iF6WVJkweEncASojj1ZSj5vFoOzduYTh
         O1Ag11qNK08TNcbWNGPFTkdJlY9nwJQnRkm5RezLT4qtuw5HvtiVSnah7nrkUiOZr8ZT
         ge4fA6w9DKcJDgpBfSGlG1PmUvln6yNfXgvbrEVfkGehPRUwnU6FJChRxOgxVnCF09DT
         BfLg==
X-Gm-Message-State: AOAM532MsTxxH8dGWYDjFGPxnpC7WMORXmtXBojXdi85mI6VBB1LXxsF
        IQN/8T+cyH8ZkLo4W6gLIho=
X-Google-Smtp-Source: ABdhPJw3xLGuSEgIpvw5CpuLNV0Fbhn+FhNZqhZjRCKOXOSmwljAa5LnwgB+nX53CmwjP6TZq3i+RQ==
X-Received: by 2002:a05:6830:19ea:: with SMTP id t10mr7317144ott.61.1613264673859;
        Sat, 13 Feb 2021 17:04:33 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id l2sm392393oom.19.2021.02.13.17.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:04:33 -0800 (PST)
Subject: Re: [PATCH net-next 1/5] net: bridge: remove __br_vlan_filter_toggle
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b0438804-133a-9237-12da-2b3e4301b813@gmail.com>
Date:   Sat, 13 Feb 2021 17:04:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213204319.1226170-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 12:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This function is identical with br_vlan_filter_toggle.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
