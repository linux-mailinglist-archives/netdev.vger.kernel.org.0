Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0269A3E56B3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbhHJJWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238933AbhHJJWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:22:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01800C0617B0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:21:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d1so20167151pll.1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hnxN0xm/rnx8MoGjHciVjkzOW9+mOimTOqjKzUKPWjk=;
        b=lhPv+FwXsJa/GL4+InANBk6HLpSBSFLzAXVs05T5kp7n9nLh5GP0oiZg0N9Upg+EhH
         PdVdjwOYwm1jQ2kj6DBZ80hjDmXZov/wImFM67+pS3cGYUSi3JszpUuwP3Ll89ISDIDW
         roH2up5pSZ+FRTwihi0MuT6Ev3mHxa2DBuX74MNbdmNQinJbH0mKK8DbHLRBfwfyhTei
         peovQpTW5v/zuHAvvrcZOhZqpi87f3ScjFhSPg+cbtzHWiFiXxPP9FFtqqtk+vNKj6gP
         NiQt8VHqNJrEXNt5ZFdduvrO40OU3PndoHTJf0164H/ehuw2Gog9A0fYPYuN/X9s2Rnd
         HrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hnxN0xm/rnx8MoGjHciVjkzOW9+mOimTOqjKzUKPWjk=;
        b=PnYx5r9ptLkNBPyliTZICIGis72LAUXfHM1C5XU/rexB6vSWjSyF/OAmBLrPYEiXBx
         jSAGdX1KUAIMe20YDyYhGBFkr9aA2M5Cjnisls7mTUmTOHqAO6fQX8o/z33aVQj+6FTx
         5lKXO9Y6zyTv9tOBq36Kj0aWA4yboYU0mYsePt0lVTKlAHahch/YwdfUHKGHLRmAt/0+
         lFBjyfeX7XQAtIoAcqoa0Qkq7AqKeEETrCFz7ChiNtRE3NozNqZ2hR1sJYCkIiWYOGWd
         ZbnGD5wfOSMh8gN7MXg6Dc39FZgCNp2WQivIJWqKKxQ39kpFbHTn7ZbgzW70vzuZaQ8B
         4xCA==
X-Gm-Message-State: AOAM5332r9Yuot/J2pdGJJu4XwIXxOkGiS0sr52KjFsP9WJY6I/ZZBSg
        ApMCIiEyiC71qJUte/zHnVA=
X-Google-Smtp-Source: ABdhPJz2FtLjc7CKSIeiL98KZjpE/OKwDDFqGpMaE/lxXQxEVRNpSn6MU/AxZYszt7HG67o52WhwgQ==
X-Received: by 2002:a63:40c1:: with SMTP id n184mr581887pga.74.1628587306602;
        Tue, 10 Aug 2021 02:21:46 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id t19sm24808449pfg.216.2021.08.10.02.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:21:46 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 3/4] net: dsa: create a helper for locating
 EtherType DSA headers on RX
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a8da86b9-973c-f678-509f-c6fac2c7bbb9@gmail.com>
Date:   Tue, 10 Aug 2021 02:21:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809115722.351383-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 4:57 AM, Vladimir Oltean wrote:
> It seems that protocol tagging driver writers are always surprised about
> the formula they use to reach their EtherType header on RX, which
> becomes apparent from the fact that there are comments in multiple
> drivers that mention the same information.
> 
> Create a helper that returns a void pointer to skb->data - 2, as well as
> centralize the explanation why that is the case.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
