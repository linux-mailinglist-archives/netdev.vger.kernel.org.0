Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F882387CAD
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350297AbhERPqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 11:46:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54446 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350273AbhERPqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 11:46:15 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6016C20B7188;
        Tue, 18 May 2021 08:44:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6016C20B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621352697;
        bh=3HQYFgD4lxpqADotbbiCx33GTkFHpxK08+XG1XtrjPI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aAkJCclcikW+/0HQ2xhJWDmuSo5v7++8kyppG7KPOk4FYls1Zr4KkH7FOig1KrT0x
         ntrA36/umwOyfuecwNuHVZ6ntToWOuTNJ0pu0kn1/nZnuU2sMxEQYFplD9v8InxJ4P
         aQ39IUDGyxvZV8dxu0tCsJ9FJ0BqtoIMKvM4COxg=
Received: by mail-pl1-f178.google.com with SMTP id s4so3753280plg.12;
        Tue, 18 May 2021 08:44:57 -0700 (PDT)
X-Gm-Message-State: AOAM531qjQTQ8yutVE4m2F6w1hajF6tHAx7wLhTefLKPyxAu3OV76w2D
        B+fJ2jhlSgJSLxkQYv4iQ5jaMafjtot5ku8Z4fs=
X-Google-Smtp-Source: ABdhPJyH71DOHHf5vAHuwNoiGYshpXvPej6HckHw0XokpfXTIkipE9bPqtisiMcZNB0rqtLKF6U49DPWaygEV8C2+PI=
X-Received: by 2002:a17:902:bc88:b029:ee:7ef1:e770 with SMTP id
 bb8-20020a170902bc88b02900ee7ef1e770mr5296175plb.19.1621352697022; Tue, 18
 May 2021 08:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-2-mcroce@linux.microsoft.com> <YJ3Lrdx1oIm/MDV8@casper.infradead.org>
In-Reply-To: <YJ3Lrdx1oIm/MDV8@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Tue, 18 May 2021 17:44:21 +0200
X-Gmail-Original-Message-ID: <CAFnufp0jwSMx_-CeFguNnec0pC0WNcPnhobiVE0sH9Jo9tjK+g@mail.gmail.com>
Message-ID: <CAFnufp0jwSMx_-CeFguNnec0pC0WNcPnhobiVE0sH9Jo9tjK+g@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/5] mm: add a signature in struct page
To:     Matthew Wilcox <willy@infradead.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 3:01 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> I feel like I want to document the pfmemalloc bit in mm_types.h,
> but I don't have a concrete suggestion yet.
>

Maybe simply:

/* Bit zero is set
 * Bit one if pfmemalloc page
 */
 unsigned long compound_head;

Regards,
-- 
per aspera ad upstream
