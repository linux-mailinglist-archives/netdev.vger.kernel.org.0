Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4635CEDC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244785AbhDLQvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245760AbhDLQl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:41:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7683EC06123B;
        Mon, 12 Apr 2021 09:32:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s14so2080895pjl.5;
        Mon, 12 Apr 2021 09:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8z+/ms9HXXuc1u59TPf3kgky3kvFQaPstoWisAaXMAg=;
        b=GheD5xk6FCX0Y3/HoHa1l6VnTCdijSOTbozl3pVjfAakw4z8Yx4yOk5DkGxIGMAsns
         sqCXNRWBgE/wFdwUAstG39HV71yl0aiKw/UfJR98CnqAQYvrUqY2b4V26E8w7xu+B3os
         TN0R0pPyWAo9NwepW36QyckWHZokzXBsmX6kVl8VCxVviPy0ZksmtWYp0F/YNnpMaykK
         nkEU2ITHRX5rt9tdCGEanffiie6HJzBxWPTzC3nvx7wmpfZxR2Ydpa05LMtXDHyE+sjZ
         eqE94OaG+Y6bnoF8ee1Pleh1cqlJPoiWaWlxCfabUsqLQRT1C9vLeEX9LqQ7eZHZTfNz
         pO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8z+/ms9HXXuc1u59TPf3kgky3kvFQaPstoWisAaXMAg=;
        b=DMJ32vlGWkIsNEF7S/+1wVricCNtDb9qvi4Dmt2lZlko1G2qUL+jeGpKNvL0zP/xTs
         xhl+igUsHjmjZIpCOG5bDe4p8TW5gREc+iehoykDchMagUeUFFKRgz+iyATOLtugeTCT
         RQgPg4IjVrVIZPB4k3dttfvm7h7nkREjDytK/Vf4KcQAlkPPhI4Mrecq6oOpPGpme29z
         Isznf4RVR3DqEGB58hx4ln0sdeX+IODYhjAhQth9wglMbQRqpzIxh0UZ3jSXOP5hzQk4
         Jzl4GxyyFDLgTBpUx2Znyxzvf9b+TvbIvlwTqAI69Z7m1UGZPab+h7xt0PC4TpKy36+b
         Xuqg==
X-Gm-Message-State: AOAM530wE0f9PdWCwU6sSbZNYRoi29SBfPn8UgIewkCA7ptC6N5IdVy0
        r2dRLOAtW8fiC2Mc6YFJz3c=
X-Google-Smtp-Source: ABdhPJwhcgI9IeGvhjgoT4tAqP4AX2pjomksj/ek+5xymVy4vfiUsqxODG3qwUQsULA7bFo5zMt0aQ==
X-Received: by 2002:a17:90a:8815:: with SMTP id s21mr29369762pjn.200.1618245146911;
        Mon, 12 Apr 2021 09:32:26 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id e11sm9725487pfv.48.2021.04.12.09.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:32:26 -0700 (PDT)
Date:   Mon, 12 Apr 2021 19:32:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Marek Behun <marek.behun@nic.cz>,
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
Message-ID: <20210412163211.jrqtwwz2f7ftyli6@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
 <20210412150045.929508-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412150045.929508-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:00:45PM +0800, DENG Qingfang wrote:
> On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:
> >
> > So I'd be tempted to say 'tough luck' if all your ports are not up, and
> > the ones that are are assigned statically to the same CPU port. It's a
> > compromise between flexibility and simplicity, and I would go for
> > simplicity here. That's the most you can achieve with static assignment,
> > just put the CPU ports in a LAG if you want better dynamic load balancing
> > (for details read on below).
> >
>
> Many switches such as mv88e6xxx only support MAC DA/SA load balancing,
> which make it not ideal in router application (Router WAN <--> ISP BRAS
> traffic will always have the same DA/SA and thus use only one port).

Is this supposed to make a difference? Choose a better switch vendor!
