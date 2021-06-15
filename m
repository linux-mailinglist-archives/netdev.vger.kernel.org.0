Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C15F3A8C81
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhFOXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhFOXb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:31:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD957C061574;
        Tue, 15 Jun 2021 16:29:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d7so219966edx.0;
        Tue, 15 Jun 2021 16:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dMu6Ebpu3T3ImGY3emMLa/ibwH7Jz5A6ZlvdLonFw94=;
        b=JQbC59Bt9iZ2ofmMkX7Kl9HL7wZA/xVTJDwwp0xpvuMwo3pba02UrjnNg9d0zCKfaD
         4JHyjgm+fvkt0QAozm0OGqxqsBPAGJoSnlb0bIQz6uj7Z72RNQMiPbdy4MfmqnmL38Aj
         Ou986wZdevoaPTBs4B//uhLDseLwl1c6b6gZY3zloQsCd13iAANAM4/dG8lO4whN3fGu
         NlR4704c85iQ3g17AcdaSdqFJN1NK2k1NI1c3xmTCPPdqhOu44itOnKwBlvaScfLYepe
         3rhHqQqlMbSbSL+BKlzLolRqG6uTd/1idpXMkHRjbDL9LeQPt4EZXzoz/2vB7Q+IWvf1
         GSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dMu6Ebpu3T3ImGY3emMLa/ibwH7Jz5A6ZlvdLonFw94=;
        b=CQ68oiAatZjpOyxArxpXtU3WGljyxGdn0VN0pSSEdE+s2mJEpc2Hju3RW0JtIaftXh
         oK1wcdysDTVY0emR9OJAMZjbJ08TMtcvhnT/gACBZTPz2gymyitatimTvF8FnQzpahUj
         UzmlbHh+WTzmdqBN8Z/P6bTT5ZrmZs5Ca8nfA5kmcfRhf1qc3RcAI17oEP67oH+ME+ls
         Un7HCliy6Lh34WaNNqf1TDGHuwuGcbqWnMHzXMtkjbiVQdB4gBzfLvLCL05M6qs/tPCv
         CAfTRUq5d9e3UWCCqFfYSwPhnqzmajlqv8S/t6rRjhA0ml7KzCEA+k/88P9/4o8pZv5k
         86fg==
X-Gm-Message-State: AOAM531IKMWEtirigwA2tOYFoiKWZm1RW7I9T7c3yOiYlkT24nHCgiql
        gU1ALuuywnI8VHF2UtJ62sQ=
X-Google-Smtp-Source: ABdhPJyr9pJPFLX4drWnvJMzUHLNg4ImgihZ1B8LGDBTk8opezpzsSyrD4Z2oro8ZkFoOcKUrN15wQ==
X-Received: by 2002:aa7:d344:: with SMTP id m4mr667424edr.281.1623799792558;
        Tue, 15 Jun 2021 16:29:52 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dh18sm313170edb.92.2021.06.15.16.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 16:29:52 -0700 (PDT)
Date:   Wed, 16 Jun 2021 02:29:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Subject: Re: [PATCH net-next v2 0/3] Some optimization for lockless qdisc
Message-ID: <20210615232949.2ntjv5kh3g7z2ua2@skbuf>
References: <1622684880-39895-1-git-send-email-linyunsheng@huawei.com>
 <20210603113548.2d71b4d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20210608125349.7azp7zeae3oq3izc@skbuf>
 <64aaa011-41a3-1e06-af02-909ff329ef7a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64aaa011-41a3-1e06-af02-909ff329ef7a@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 09:31:39AM +0800, Yunsheng Lin wrote:
> By the way, I did not pick up your "Tested-by" from previous
> RFC version because there is some change between those version
> that deserves a retesting. So it would be good to have a
> "Tested-by" from you after confirming no out of order happening
> for this version, thanks.

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> # flexcan
