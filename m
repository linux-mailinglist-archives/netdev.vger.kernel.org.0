Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3401D6E6F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 03:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgERBKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 21:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgERBKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 21:10:38 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED34DC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 18:10:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d7so6808233qtn.11
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 18:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=+an3oPGmouqmxdjWxODoJ0P7yGRva780mi9DZnk5Z9s=;
        b=gjlWNcQrdCuWM43qeMi+V4QKXL/aKhrbIRPll+QFxszv6qeT0yt1ZqeI8igBFYS+AL
         ymgfCQksdKME74IuUHXRdDBv6ZChOEnFoPxMINHk7xxSGFpFwHru08cGNX7DE6LQ9D+O
         O2g/xxmV+924nH+bngRMzr/JBsJcHG8NRTgskVqkoxXnWWJIzZqFRz3U78F/4Zes9rSN
         Kn09fuOEHRyeTscgd8whIBzf/VkSb6atAciuPigMKwVHlvIYQ9op+UKv5cMZiEZbdFez
         rMWnMx8y8vyO4NkU52eGowx0wFnVgyv+wOoxVrXT8SnPBfjrGbAxGyQp8jVzA9vzJmtg
         xAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=+an3oPGmouqmxdjWxODoJ0P7yGRva780mi9DZnk5Z9s=;
        b=I13L7uEblV18Dq4h6XMpYWa2h4mDA1+2SiGhcP7MbIVQjjt228p+4HNQ/yPCmWZhkN
         lec6CeI/0vggP6xZ8GAcnRoIhkCfsQEGe13jLsScGaNKtKvwBOEwMqLNStX8qBOmjzJT
         pk85pBvbEM3W18qjv1ZTBt7Iy+CasJauDtW0/9l+SP39Kz2Ny5Z1z2aMTnj+ltsDAyXk
         ZoOsLtL6Hagj3l9iBd+curu2j/krJrnj3jkjLO/PvauLOQDPgzRxE4SE3FCJg8H0n7Vc
         cpU492sAc7V7nmxx9oSCohnR5eqY/M7fUuiEGDJET4qWRy3ydbgSsalsNZ2Wwd5P2F6Z
         p1Aw==
X-Gm-Message-State: AOAM530eO3ZGgMIjmIEsJ8qSovvKkFdfNTUPTaCqFUe6s22xJxX4FHpo
        2wGj7shDVnqJDE6wkwXwBH32vjL4YZB79A==
X-Google-Smtp-Source: ABdhPJyo6tuxHSanqQO0qbMcMFjQiDoMfR8M+1LekOsbx2DPMftx0yZeKSaRSNruR5rktbIQx1XpPg==
X-Received: by 2002:aed:24a6:: with SMTP id t35mr13994390qtc.72.1589764236027;
        Sun, 17 May 2020 18:10:36 -0700 (PDT)
Received: from sevai ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id o18sm8331920qtb.7.2020.05.17.18.10.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 May 2020 18:10:35 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel@mojatatu.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net 1/1] net sched: fix reporting the first-time use timestamp
References: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
        <CAM_iQpXx-yBm2jQ57L+vkiU+hR4VExgzFrntw3R2HmOFpzF5Ug@mail.gmail.com>
Date:   Sun, 17 May 2020 21:10:17 -0400
In-Reply-To: <CAM_iQpXx-yBm2jQ57L+vkiU+hR4VExgzFrntw3R2HmOFpzF5Ug@mail.gmail.com>
        (Cong Wang's message of "Sun, 17 May 2020 11:47:18 -0700")
Message-ID: <85y2pqm4jq.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Sun, May 17, 2020 at 5:47 AM Roman Mashak <mrv@mojatatu.com> wrote:
>>
>> When a new action is installed, firstuse field of 'tcf_t' is explicitly set
>> to 0. Value of zero means "new action, not yet used"; as a packet hits the
>> action, 'firstuse' is stamped with the current jiffies value.
>>
>> tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.
>
> Your patch makes sense to me.
>
> Just one more thing, how about 'lastuse'? It is initialized with jiffies,
> not 0, it seems we should initialize it to 0 too, as it is not yet used?

Yes, exactly. I was planning to send a separate patch for this.

Thanks for review, Cong.
