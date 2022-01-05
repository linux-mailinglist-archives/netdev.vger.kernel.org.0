Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE44858A8
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbiAESqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243178AbiAESqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:46:47 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A911C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:46:46 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id p37so171580pfh.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oZemAiWmVZltbjo7b+0lNdsefyg2pLVo3zrbKNV/nqE=;
        b=dHC1lCzLktEJraw4HjCHOgCCs5qIYj0ppH4g9yzc2F3FpSLObB/CwobiqnXSZ5HV1+
         EClkZV1AQvJguGcVpUiBogU8YbAjI1bm02nMJDBSIMH8fnchz2GhAhZdWi3iAS9zWJfB
         T6t5hFV47YkNN7ow4MiSAeEHt6rq4/KNxfOD+xodFY5cu7vOi2om2BDypMeS74zLy2fv
         CC1PhIaBGgFL/KitHVw7XO6ybK8bZusMuIUK6TAzGL9loMO2QsX6FPeAry8dFFqXiMBl
         fLO+h57QC987v0JcrQHykgFb534nLqJFlAczWeCiF+gVxGrfDcsM7KN7SynfoK9U33kr
         x0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oZemAiWmVZltbjo7b+0lNdsefyg2pLVo3zrbKNV/nqE=;
        b=tjshaeVPZxVGKrXHmASetDKJLE+xCNIbgU6r+ZjRlvmGoBXhZK4rC3nx7QhLg3jXaM
         lAsrxc8mub5EXoBtrb78IyFm5wAr33nJMaG8oCNT021ldNbl5fRTT5FgWWdc2IFdKMDu
         I2M8TyQowFNMsu9UW2dNv3dEiGUYob9jN8qYjYpPTVh3byoenY0DCH85H9Ik9hQOjTIB
         IreySMYBg/XxYxGWdJqgcECJrrQmJF6XFlmvCJYi67AjQS8iWOR9M6+roqqTfNosDqye
         Slmvvzj3MfEYz7e60sd5igOzKF81PLjj2NGN676cxGlLKwNtSbV+JgMYqXFIk4U5IkbF
         8g5g==
X-Gm-Message-State: AOAM533+j+als/2A4eHW/g2+fH+56zGWemUQs0gYfOy/4SB65clnkp/O
        tmAT+gC4INKP00ksEQxdDuM=
X-Google-Smtp-Source: ABdhPJyBfFTsl+hMuEclWYSYa3bFRTZ8nsun2gWwU2YHGApz33j4V4isk5vnGTMcrham7I3iTwRB6A==
X-Received: by 2002:a05:6a00:2316:b0:4bb:231c:1b92 with SMTP id h22-20020a056a00231600b004bb231c1b92mr56795468pfh.27.1641408406043;
        Wed, 05 Jan 2022 10:46:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f15sm3238053pjt.18.2022.01.05.10.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:46:45 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-3-vladimir.oltean@nxp.com>
 <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
 <20220105183934.yxidfrcwcuirm7au@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <07c9858a-aae1-725e-67e7-fc64f8341f3e@gmail.com>
Date:   Wed, 5 Jan 2022 10:46:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105183934.yxidfrcwcuirm7au@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 10:39 AM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Wed, Jan 05, 2022 at 10:30:54AM -0800, Florian Fainelli wrote:
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks a lot for the review.
> 
> I'm a bit on the fence on this patch and the other one for dsa_switch.
> The thing is that bit fields are not atomic in C89, so if we update any
> of the flags inside dp or ds concurrently (like dp->vlan_filtering),
> we're in trouble. Right now this isn't a problem, because most of the
> flags are set either during probe, or during ds->ops->setup, or are
> serialized by the rtnl_mutex in ways that are there to stay (switchdev
> notifiers). That's why I didn't say anything about it. But it may be a
> caveat to watch out for in the future. Do you think we need to do
> something about it? A lock would not be necessary, strictly speaking.

I would probably start with a comment that describes these pitfalls, I
wish we had a programmatic way to ensure that these flags would not be
set dynamically and outside of the probe/setup path but that won't
happen easily.

Should we be switching to a bitmask and bitmap helpers to be future proof?
-- 
Florian
