Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E22C35E1D7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbhDMOq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhDMOqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:46:55 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF8C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:46:34 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id f41so4394584lfv.8
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ZkxBrXhgahAL76PVBBK7Q4bfFvD6vehXOz4V8yxaY8Q=;
        b=ARk9lGt4JUI7Mwp/JCQhq8RXeBHM4DdVbLAd7FTZVbJxylhsyaKm3Ykp+7auLj8u+l
         epOt4KXUSGKsbAslnWOue4nlxmY1IrGboR3HUtXg1egFEtnSQnMjDJJ+zcddlXQ1atlU
         oOGH8qiDHRez91vwXq+PBP0WsoNAStD3Bj8613wkWL91RIQg5Ph0AVpBcV6vp2NEHAzd
         AYZ2KMZlIGERN3j3Rn/rtg5NAs0NyJhBHfYg9u+piXo+5plZByQcNfjDkh4r6q0n16a8
         ChiYWVl1dZwfYsZJ6Ae+0DTqUj9NPO9J0epXKgVvPrYKeQDhm/t2zDwz3zLmZza4gW3I
         V2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZkxBrXhgahAL76PVBBK7Q4bfFvD6vehXOz4V8yxaY8Q=;
        b=GUGL0k9CerHNk4MNLpmCuMyt2IQlnbI+3S4uciNJytXKff7ZUDzhkB24XdMzakYoGw
         RPoE7jRpJg5sMdVK9VBKhqFasfBUYkf728dT/j9stQ3l3HJh5hcT69JUo+3dynuSqp6d
         vQZ5oD8wRd+sh9G+zZFdMP5Cgy4T+h+dIg2nTHbdmzMRaNiHCva/8PlqRF82XYOWfv9Y
         4hEekN+6pzbP3os1CfZLh1u41eHYf1ZGBYXCOvwi/pUYOsvjoVstpc2dLN7e5J//h6Mh
         aGSsdshmZl6MCOH6fSkD4J+Nl/9LPQic6DTJrrPOdnuPOngM07c3ShysWxM2Hfs0NjIM
         ZGfA==
X-Gm-Message-State: AOAM532eZcVtLUXzVC6H4h1izVltUge+vxAsR3ZkjoB9KfVvk0PueHBf
        jqN1w9LFaDGLocIqlE71hLljuQ==
X-Google-Smtp-Source: ABdhPJyqBSvBQkRrpVsn5SdmR929MtyUuaXqbaUqDciPYHwVuL4enRrtMzFCXKhvvh5875PM3QNtwQ==
X-Received: by 2002:a05:6512:34c7:: with SMTP id w7mr22365583lfr.83.1618325193402;
        Tue, 13 Apr 2021 07:46:33 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f3sm4046840ljm.5.2021.04.13.07.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:46:32 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
In-Reply-To: <20210413022730.2a51c083@thinkpad>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412235054.73754df9@thinkpad> <87wnt7jgzk.fsf@waldekranz.com> <20210413005518.2f9b9cef@thinkpad> <87r1jfje26.fsf@waldekranz.com> <87o8ejjdu6.fsf@waldekranz.com> <20210413015450.1ae597da@thinkpad> <20210413022730.2a51c083@thinkpad>
Date:   Tue, 13 Apr 2021 16:46:32 +0200
Message-ID: <87im4qjl87.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 02:27, Marek Behun <marek.behun@nic.cz> wrote:
> On Tue, 13 Apr 2021 01:54:50 +0200
> Marek Behun <marek.behun@nic.cz> wrote:
>
>> I will look into this, maybe ask some follow-up questions.
>
> Tobias,
>
> it seems that currently the LAGs in mv88e6xxx driver do not use the
> HashTrunk feature (which can be enabled via bit 11 of the
> MV88E6XXX_G2_TRUNK_MAPPING register).

This should be set at the bottom of mv88e6xxx_lag_sync_masks.

> If we used this feature and if we knew what hash function it uses, we
> could write a userspace tool that could recompute new MAC
> addresses for the CPU ports in order to avoid the problem I explained
> previously...
>
> Or the tool can simply inject frames into the switch and try different
> MAC addresses for the CPU ports until desired load-balancing is reached.
>
> What do you think?

As you concluded in your followup, not being able to have a fixed MAC
for the CPU seems weird.

Maybe you could do the inverse? Allow userspace to set the masks for an
individual bond/team port in a hash-based LAG, then you can offload that
to DSA. Here there be dragons though, you need to ensure that there is
no intermediate config in which any buckets are enabled on multiple
ports.

