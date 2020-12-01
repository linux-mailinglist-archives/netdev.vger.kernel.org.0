Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1334B2CA57E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgLAOXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728951AbgLAOXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:23:14 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0995C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 06:22:33 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id j10so3178941lja.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 06:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=xYitzlRGiOFrphkGw4K1N3Po7l4fx/na5v8lcfzY4o8=;
        b=TLvVFRa1Kc3u0ln6XjSob3MkhyvQ5aiZq5N/acvC3T5sE9rRwd6/ZUXKZFsb8l80Dp
         7bgnSLKVNKd+fjzRtCersDz7oq5Em4N1XY0VBNA+dVQMdmUS0fSxHQej/EsWAYEX/c0e
         vZXozVlUod2P+OVsnNGUvcatXe2IpUOHzgV0tciueBWDE376nXuSG6HSp0/UCmwZMX4V
         pUVHEXdHnyZfB7ohAoC/FIZHD4801qVVZnrXf3mMZzQt5h3hcfvxANglV54lpNvRbzak
         PH/1EhuYrrgpaE8t1Q3FyNyuvcP8LHtnAYJ561f6+SMq/HsSgTc5oKOs32oU+/GztLgP
         cfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xYitzlRGiOFrphkGw4K1N3Po7l4fx/na5v8lcfzY4o8=;
        b=EQgJ06yBp9WhgKZsKpQvunfc4qusxSp6Yph50y3LddO1KbKEzhp9X64XiZUkDZQSJY
         bmHcv9EFcfHpbi0uijYfsuBLNEaC7e2Tx/ANuzohdgzos9bSx63YjlSV/1U5K2t2Z/Sk
         lPZqzPLLvrZAgTIgq0/EXW5rfHqLUQqFIis+ImBCdPpearPs7Swuzbhiu+t1DblvtNSJ
         v47EyGMVx//diesHDGlBq2f1nNdtyxGXRVoOJZ1v5p6ZCeestgrVhERnvl1JbPEzbuXP
         Ai6RfpvIspQfO1h1dxY2kSh/JjA/CyllqJIQGIvxBLrOJb4dZkSu7Rax526sJ0sNZUAj
         00Nw==
X-Gm-Message-State: AOAM531r1kDlceWCG7clDu604KikX+hZ3M3StDMV0Kyw9WTK+P9K/TmH
        cg9O+6hI6IeOxBogfqXhlB8c4zfLNYW/i/+m
X-Google-Smtp-Source: ABdhPJxX1s+K+OVxiRnsYAn28wM+mwm48qIS5GfOBsLBjqSVpkhpgMEDsAA3k8O41nRv9hyrJycllw==
X-Received: by 2002:a05:651c:211c:: with SMTP id a28mr1433870ljq.343.1606832551864;
        Tue, 01 Dec 2020 06:22:31 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id b145sm215220lfg.225.2020.12.01.06.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 06:22:31 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201201132933.paof42x5del3yc2f@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com> <20201130140610.4018-3-tobias@waldekranz.com> <20201201013706.6clgrx2tnapywgxf@skbuf> <87czzu7xkq.fsf@waldekranz.com> <20201201132933.paof42x5del3yc2f@skbuf>
Date:   Tue, 01 Dec 2020 15:22:30 +0100
Message-ID: <874kl58v2x.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 15:29, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Dec 01, 2020 at 09:13:57AM +0100, Tobias Waldekranz wrote:
>> I completely agree with your analysis. I will remove all the RCU
>> primitives in v3. Thank you.
>
> I expect that this also gives us a simple refcount_t instead of the
> struct kref?

Yeah sure, I was just trying to be consistent with what was being used
in other dsa-related structs. I will change it.
