Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF69030F992
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbhBDRXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238351AbhBDRWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 12:22:44 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D63EC061786;
        Thu,  4 Feb 2021 09:22:04 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j11so3818678wmi.3;
        Thu, 04 Feb 2021 09:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HORz1fkDbNO3XsdHYHw2WWWzA1rELQNxdnPn8rfPpRo=;
        b=RpA/+XCpqk/t2Mz7NEyEIriv84TxmXnPkPk6P1UmcdXw4p6NSE6uhMs1Zn44cTzGaC
         jHdVKrQQPhK5fCHbJjQa9fnnaXhyFQxMWlWVdBsr7eZcrqwJ5ZoEXoTeUZLxqPw00xjM
         QoVEGNFev1KH9TDTlHM5P6oNvwmM8PXZ6dCSk7dhZTJzG7i9cAJO/UR2t1C+JJujqbyJ
         EvwcNc4ARQ8pi19cHTeT3vUhSk7TTZY85BdzWrur5deD/gobpKGxaLLJJ7JzSYRmJar3
         xnuu/kHLCmeDSmi2L64x2bOHDaQm8CGUoNhP/lysBy306ZMrSf+brPIzPXCbtnWOPmfi
         Vf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HORz1fkDbNO3XsdHYHw2WWWzA1rELQNxdnPn8rfPpRo=;
        b=b48bPDeulZzZWv4yvpSpokhzBEbRdiTguJFQqrx+wcepcdINFm5BRqaOPHiXZ1QeDr
         MO+VQP6ID4zwU0mcYWIRvfWCaBWmpPftFSh304O1VIiIla4mYnPayU1dkFxCsnfuExlr
         Z3JioR1lxgBLse1AzMf7bLG9J2DlkJ8r3jr+14609g4tz8E5zL4FHS+oqUUXm4y65gEs
         OMu8nhwmVvwfhMw1NBxhTJEJ/iBe9USbrnQyXYPAMT6WyjAkay61MZN3Cwu4HVEZyQup
         ETUrROkPC/wt6Wgw/Z+hjIM7lJnNwjcHAqs6LS0wXiNG/AxXWkFoD6muT6qbyropAWoG
         voqg==
X-Gm-Message-State: AOAM530AEdoqPQNgo1syvygEF7fBDxlqKDhh4SX+hJZL8lNwlyt//6kD
        0gThB/6CNFNjOgOggPHaLamF4Pr1ClA=
X-Google-Smtp-Source: ABdhPJwgQJl6ZnrJtnRzUeJih4ClaRhyT3lBQJ4H/vg7ZsB8A/muA877fK0WF1jl6+b+c08BqGDeXA==
X-Received: by 2002:a1c:2092:: with SMTP id g140mr241512wmg.4.1612459323020;
        Thu, 04 Feb 2021 09:22:03 -0800 (PST)
Received: from debian64.daheim (p200300d5ff14c400d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff14:c400:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id b4sm8615717wrn.12.2021.02.04.09.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:22:01 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1l7iKP-000LJq-4Q; Thu, 04 Feb 2021 18:22:01 +0100
Subject: Re: [PATCH] carl9170: fix struct alignment conflict
To:     Arnd Bergmann <arnd@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210204162926.3262598-1-arnd@kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <6ec7c9f0-51c6-b16f-9252-2dad7308f6fc@gmail.com>
Date:   Thu, 4 Feb 2021 18:22:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204162926.3262598-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/02/2021 17:29, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Multiple structures in the carl9170 driver have alignment
> impossible alignment constraints that gcc warns about when
> building with 'make W=1':
> 
> drivers/net/wireless/ath/carl9170/fwcmd.h:243:2: warning: alignment 1 of 'union <anonymous>' is less than 4 [-Wpacked-not-aligned]
> drivers/net/wireless/ath/carl9170/wlan.h:373:1: warning: alignment 1 of 'struct ar9170_rx_frame_single' is less than 2 [-Wpacked-not-aligned]
> 
> In the carl9170_cmd structure, multiple members that have an explicit
> alignment requirement of four bytes are added into a union with explicit
> byte alignment, but this in turn is part of a structure that also has
> four-byte alignment.
> 
> In the wlan.h header, multiple structures contain a ieee80211_hdr member
> that is required to be two-byte aligned to avoid alignmnet faults when
> processing network headers, but all members are forced to be byte-aligned
> using the __packed tag at the end of the struct definition.
> 
> In both cases, leaving out the packing does not change the internal
> layout of the structure but changes the alignment constraint of the
> structure itself.
> 
> Change all affected structures to only apply packing where it does
> not violate the alignment requirement of the contained structure.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Christian Lamparter <chunkeey@gmail.com>

I've also applied this patch and a previous one dealing with VLAs to the firmware
source at <https://github.com/chunkeey/carl9170fw>. I did a quick rebuilt and
the same binary firmware was produced, so I think what's left is to update those
shared firmware/driver headers some day...

Cheers,
Christian
