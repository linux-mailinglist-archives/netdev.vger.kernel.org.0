Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5619447183D
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 05:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhLLEZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 23:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhLLEZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 23:25:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBF2C061714;
        Sat, 11 Dec 2021 20:25:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p18so8878435plf.13;
        Sat, 11 Dec 2021 20:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+VrVykfSRznj9NGypXhUmf+sgI4lkh8qtBNSWTDVmlc=;
        b=gxAcqODD8QOzJ12cpX6ZmLfo2N9IecVplED+O9E5FvlbAG7hOFzm/Vt+ERN5caUrOp
         gTvW6vVQkwInJSjrpDG+8DLzhiAfoFaDqvdhXLzr42qwomp8LvFAnPn6N+TcK25G1bZI
         Vf3slhLx89CACFvwuGIF003g8miYYZJB9pRRG06dJvl1yJCHyBH787ALdxNxllQmMYQn
         YlXTYRZgqCo70Vv436R1jRRGplWg+aj9TGSQKkV1G3hyARJmv1JakunBACfiXNs7JMAF
         ih/Kn+66geIeROL8jAQuNR1Z24r9T0Pduroj+Rr1OfQAgr8FWeY7bqre10rkEHG4z/3b
         zWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+VrVykfSRznj9NGypXhUmf+sgI4lkh8qtBNSWTDVmlc=;
        b=VzJxvm4ZCvceLTCbx/qHAHhEbLWI0xHA8XzbFI99ORAOkhypbNBwoJRX4S/H/Yx+LR
         /u2DMFwyQOMavdZqJqMi9kSTea+3ifAtw/eP4sMmtgNsNTbjjUuNM1guA45D9Y/RqU+Z
         dAggkMbFAA93b14W6JjwdT5BW5EizglZ2bdouSd4OYYihhnUJAogFn1Z1QhmRb5R+C8N
         A0Qx59Q745U0dW/BNDO5CSzszDoMGKCtsSb6Yb6rHbqfMj/BLMFTolJWKqjxtNugmZdP
         aW7HsJX6/zgj+EFSW/Z2fuoAlToIGiDRa0iVxVQlxTwFtCdhM+nvlJDtAgzRsda4o68h
         z/gA==
X-Gm-Message-State: AOAM5337dnIsSbAUWqciIDDBa/SsbrRb34dTPwDQpjl9yfswqW5IUeu6
        InXAz9/B/aqJCd6TrPB8Xqw=
X-Google-Smtp-Source: ABdhPJxz49dgDTSB3a7teKeI4Si4BFF+4GAoE2cWAQF7iPTInMFhRwxxEH39IlV3zZuzg0A+sQNPnw==
X-Received: by 2002:a17:90a:4142:: with SMTP id m2mr35374776pjg.80.1639283115272;
        Sat, 11 Dec 2021 20:25:15 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4964:df1f:902d:8530? ([2600:8802:b00:4a48:4964:df1f:902d:8530])
        by smtp.gmail.com with ESMTPSA id u3sm8657626pfk.32.2021.12.11.20.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 20:25:14 -0800 (PST)
Message-ID: <ad276128-fe13-3a0f-24e9-111d5fb4e174@gmail.com>
Date:   Sat, 11 Dec 2021 20:25:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [net-next RFC PATCH v4 04/15] net: dsa: replay master state
 events in dsa_tree_{setup,teardown}_master
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-5-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211211195758.28962-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In order for switch driver to be able to make simple and reliable use of
> the master tracking operations, they must also be notified of the
> initial state of the DSA master, not just of the changes. This is
> because they might enable certain features only during the time when
> they know that the DSA master is up and running.
> 
> Therefore, this change explicitly checks the state of the DSA master
> under the same rtnl_mutex as we were holding during the
> dsa_master_setup() and dsa_master_teardown() call. The idea being that
> if the DSA master became operational in between the moment in which it
> became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
> when we checked for the master being up, there is a chance that we
> would emit a ->master_state_change() call with no actual state change.
> We need to avoid that by serializing the concurrent netdevice event with
> us. If the netdevice event started before, we force it to finish before
> we begin, because we take rtnl_lock before making netdev_uses_dsa()
> return true. So we also handle that early event and do nothing on it.
> Similarly, if the dev_open() attempt is concurrent with us, it will
> attempt to take the rtnl_mutex, but we're holding it. We'll see that
> the master flag IFF_UP isn't set, then when we release the rtnl_mutex
> we'll process the NETDEV_UP notifier.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

With the caveat from patch #1 about qdisc_noop addressed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
