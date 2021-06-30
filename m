Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693E23B7B92
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 04:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhF3Chg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 22:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhF3Chg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 22:37:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22670C061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 19:35:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kt19so797264pjb.2
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 19:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=atHdD5Y6BjiIH0B3O5VQqDWuMECsXCMSZepHuCTOzEQ=;
        b=ag6yF8eU6eC9QEW3PupRP67nwjqlQmORf5uA+C14A8oh0/Evp8Uvmum1CV4GNb7PU9
         PPTjfO+LampD+13UKBKUcYCo45tNBlhfUTKEZaquZ3P8mb93JnlaHIZL7zNeHOken1jT
         IGr/eC9mR+gP2xqPu9oskVCFCYkDjb/HIxKR0TQ3O4mTRwadV/ugxrvSF2UrR1B5dgpW
         EmIf01rHNEw4PT98Et7POviFf/sVslREvzk1MY+T0b6JfrafoyEtZumC6q+ZBqVv8MbK
         wD1lZGjkWkUe2o4XMVQlcM6jPFH0a/SeOrJ/JV2D03LnNkcSFves1TkEYfpPhEvxoR53
         +sMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=atHdD5Y6BjiIH0B3O5VQqDWuMECsXCMSZepHuCTOzEQ=;
        b=ZzeSsw4cZ0lJ5kjfh13JwNLfu2pryUstEHk5rW9g0Q6I8C+/Y2HznYDvXlYQD5WE6A
         H0SwbsRjBOVZKs005B5QFQxxrmhAxn2o5UfJirH4wlseRpGvUOErkCbPRnpe5vSM2pS6
         sRBuPQJghWuIjGPpaNn4rjLiJTp6HjtwrNrJ0znckUFVIvwrDspJziZkZrVBKmuxZUde
         luBlQo96Qk7jix8vmnq50W8NF9iqrjg/ntzTyG7mSIDi4mxwAggSvItZZBymRPClx+aG
         n6tUPBD0a41xDwdHBXZHL6UxHIWfjTFMdebtYn19VvI+32LD5K7JokqKUhMmRu5Levw/
         +QDQ==
X-Gm-Message-State: AOAM533tmQqqdcj/XHn7pwROK4F87yqurgG3md3BhqetnYHA9hgwCVM4
        39+d5Z60fC0oExAyEW91L2k=
X-Google-Smtp-Source: ABdhPJy2fUHuVh+6EgzpVzEdCzYWwmAjuzkjlprVrpSjvbosJ7VIf8AUKFwnSAXabK/AwEWRr15ZJQ==
X-Received: by 2002:a17:90b:124f:: with SMTP id gx15mr2050957pjb.8.1625020507750;
        Tue, 29 Jun 2021 19:35:07 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id s42sm19224520pfw.184.2021.06.29.19.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 19:35:07 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: return -EOPNOTSUPP when driver does
 not implement .port_lag_join
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210629203215.2639720-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <77c7a1f3-3d63-91e4-400d-8c7f72146890@gmail.com>
Date:   Tue, 29 Jun 2021 19:34:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629203215.2639720-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2021 1:32 PM, Vladimir Oltean wrote:
> The DSA core has a layered structure, and even though we end up
> returning 0 (success) to user space when setting a bonding/team upper
> that can't be offloaded, some parts of the framework actually need to
> know that we couldn't offload that.
> 
> For example, if dsa_switch_lag_join returns 0 as it currently does,
> dsa_port_lag_join has no way to tell a successful offload from a
> software fallback, and it will call dsa_port_bridge_join afterwards.
> Then we'll think we're offloading the bridge master of the LAG, when in
> fact we're not even offloading the LAG. In turn, this will make us set
> skb->offload_fwd_mark = true, which is incorrect and the bridge doesn't
> like it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
