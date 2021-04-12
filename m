Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC80435C956
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbhDLPBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241302AbhDLPBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 11:01:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEDEC061574;
        Mon, 12 Apr 2021 08:00:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t22so6184378ply.1;
        Mon, 12 Apr 2021 08:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=0hXhggls3SsdmeEdICPiR/mw1VhFjhbR9Aip2rqIyO4=;
        b=Lt7Kkeff+wv/0Sl+wVWKVeQuDdCJsddS3WDO/HsC7ExIVOTCGMqJ53FXjfq4eVyIym
         pJKnIVc+O4MisoROlRvAQc9NAQzobVbiuCLk8GHwE0ttLYCB9ML5VAUxiWar0OEdMzSU
         Uug2+3qMemrFi7/VGW3QUlvsRZoHX9avflweqAQH5yvxQOujn6/iGvKT4SijR7zil+rl
         x6/AnREpIPbZ1Tq4MrunHSc+prLscYWUtde56wIbn1BgTik89FOU279kyA7PoX9eb6bz
         JbcxqyrzcN/t8Y3V33W6VdpUYoBuSQOFi/EhMzNq5Lj15Ikg9oM4Hkx/+4hOH7byY3Lq
         5asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=0hXhggls3SsdmeEdICPiR/mw1VhFjhbR9Aip2rqIyO4=;
        b=EzrIIZYgmw6VOSLHt4dpTqb8cP6VvFac+SLAbw/x+Gz8Yo1mXUdJ5UYhQoktxTodp8
         Nd0qnBUbU2OG35d8cruxFG1xnWKqNkemx7m6gknNxzmlpY54Ym/KygvlWwMEWWem+Rr7
         8Y7+x1wi5on/QfqGQTUeZyCVQvHp7UnROlgSPIvGRo8mJCaLM+wADIOWjYO7GiWWzWlR
         y9ixGtvgYNHYWA8B7iPf/qZgfTuNw8O1pEIHVP5ZrLSvoQGJLb7Wg50KRGiUJXWs7Yr0
         KvFAH81x6GevRA9JAGj/ZDBguImMwGnL503BLGiqIqUIgFmotUFD9zLIcd5IWK5Yh4PZ
         yNKA==
X-Gm-Message-State: AOAM532Di8n9Jk0cZz1PfA0xhjXun8Ud+Uo7gQThxdbYejOnbaguwe0I
        bUMXSlDKGI0SYDV+HdmTPxdKoyY/Sr+9WTlU
X-Google-Smtp-Source: ABdhPJyN89fUbcwYmwo8tfuHo+uILoVx2ouA4h+2bcTXZPQh0cGMV43Wr4ZOUK3zn/geNKDM7piASA==
X-Received: by 2002:a17:90b:3892:: with SMTP id mu18mr27963088pjb.7.1618239654319;
        Mon, 12 Apr 2021 08:00:54 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y19sm12255982pge.50.2021.04.12.08.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:00:53 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Date:   Mon, 12 Apr 2021 23:00:45 +0800
Message-Id: <20210412150045.929508-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411185017.3xf7kxzzq2vefpwu@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:
> 
> So I'd be tempted to say 'tough luck' if all your ports are not up, and
> the ones that are are assigned statically to the same CPU port. It's a
> compromise between flexibility and simplicity, and I would go for
> simplicity here. That's the most you can achieve with static assignment,
> just put the CPU ports in a LAG if you want better dynamic load balancing
> (for details read on below).
> 

Many switches such as mv88e6xxx only support MAC DA/SA load balancing,
which make it not ideal in router application (Router WAN <--> ISP BRAS
traffic will always have the same DA/SA and thus use only one port).
