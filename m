Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9A735B8F6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhDLDfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhDLDfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 23:35:53 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A5AC061574;
        Sun, 11 Apr 2021 20:35:36 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id p12so8315865pgj.10;
        Sun, 11 Apr 2021 20:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zz+Tw8OZ3h7FdO/ul6ahr3fJRsNT7ZFl+jHU8Ix627M=;
        b=hJX/Cz6KrB1hU5cib883UIgJBzkAo9o8JX5imTz9nYkdP+Iqq7YtsxE5UXIFQh/BSR
         /ggY5hkWhJvEDsRm0sGuYzB0ZaA0zflppUuLGOY/gLj1zHV2D1bxHtj9JX5yGMsYlmZ4
         8AL3/Qb365VKWuqJ5DDbzbT9c0k7IlFqAGzg2RPka4MmTpZkVm9PB+D9/ZAWo26ESI14
         QFfQdDPnGsc2ZffFSRqLUBzPZPBJMS1GJNJo0IlvadvvgeHLD7WKpvkkf48ZScXNRfpD
         03FmXgYGA6y/JFioY7AOPHZPPXR8zyvTW3B6TJf+McaOHjCPMZnJoekGCgOFg+CJ42Lp
         o/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zz+Tw8OZ3h7FdO/ul6ahr3fJRsNT7ZFl+jHU8Ix627M=;
        b=JnFTjr8fRbmcfiE89mFcMWGc289Dq45s1x8IEJtr1Qbi0CReCi8qkb0enbvyvW9O2t
         sNokWYbT1lmiuBdImSxZyRnm+y7y2uvSwQ5yO8gYSLBPpdc3us8qu/0OM9AAF1vCUGi3
         enIdM2FW0vDiWdroKgXiunrAg3pfmBbT6t5sg790R/4RMGly+WExk/aPDdonhkTqheAk
         0g+KOEulrtPioWptZGRTku1xoTLzA8f8rgty57O8lPg7UQcWrwuQjF6bMWcleluDYfzL
         rbOzEmKEh7iBTsj44Exj3MZgU5uQp8tmLyl3BbAAhtJ+QITmPFLKe3nFdv0eqteMaFqW
         GSEQ==
X-Gm-Message-State: AOAM530ZD35tpOD3ldn8Rzwo7gfrDVNiw3ueowCfPsQSQURAzxdme4O6
        zj6JqljObcwo1MWOaQs0blo=
X-Google-Smtp-Source: ABdhPJw1wQKv2uLnE5vNX/a7O0otJiXPhGwvtuN1P0B0PVQrbPKQDL2UrR+i6JFovtugH+hnotEHcw==
X-Received: by 2002:aa7:904b:0:b029:24d:5447:1270 with SMTP id n11-20020aa7904b0000b029024d54471270mr2415897pfo.38.1618198535662;
        Sun, 11 Apr 2021 20:35:35 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y3sm8426547pfg.145.2021.04.11.20.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:35:34 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Date:   Mon, 12 Apr 2021 11:35:25 +0800
Message-Id: <20210412033525.2472820-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410133454.4768-2-ansuelsmth@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210410133454.4768-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 03:34:47PM +0200, Ansuel Smith wrote:
> Allow for multiple CPU ports in a DSA switch tree. By default the first
> CPU port is assigned mimic the original assignement logic. A DSA driver
> can define a function to declare a preferred CPU port based on the
> provided port. If the function doesn't have a preferred port the CPU
> port is assigned using a round-robin way starting from the last assigned
> CPU port.
> Examples:
> There are two CPU port but no port_get_preferred_cpu is provided:
> - The old logic is used. Every port is assigned to the first cpu port.
> There are two CPU port but the port_get_preferred_cpu return -1:
> - The port is assigned using a round-robin way since no preference is
>   provided.
> There are two CPU port and the port_get_preferred_cpu define only one
> port and the rest with -1: (wan port with CPU1 and the rest no
> preference)
>   lan1 <-> eth0
>   lan2 <-> eth1
>   lan3 <-> eth0
>   lan4 <-> eth1
>   wan  <-> eth1
> There are two CPU port and the port_get_preferred assign a preference
> for every port: (wan port with CPU1 everything else CPU0)
>   lan1 <-> eth0
>   lan2 <-> eth0
>   lan3 <-> eth0
>   lan4 <-> eth0
>   wan  <-> eth1

So, drivers will read the name of every port and decide which CPU port
does it use?

> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
