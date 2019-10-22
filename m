Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1736E094C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbfJVQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:40:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42967 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387675AbfJVQkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:40:21 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so27684608qto.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 09:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=oOLUW7z/uR/ZE9IriulkvZavt5cgpGH+Idk/4muWfog=;
        b=KY/7lQRwy0YztOVMya8zqkweg9ZMCIpJle8SYv9epjSTpZuLMTpW6ECr8yvPm1451x
         xxAOxdequ8Ht0mqUiJjwGcQxpXB4qEqNwhMRBOvV0UZ1xAxvlCbRUvNIp31CyBx7/8wA
         YAlzztVGOsGdBv6Igj4IvNaGrHOU1lGzpcJ90fdCQ7lmROlrLca9QUuseBqKbx1nvHuE
         QUeGyjw/pLwTvWB7dsctro3vxOpAxAW57pe4b564QUtsxfQST5sz68KpYQCuSFJV+DgU
         FMSOUZQDRmWdah0tHRmIC09S3Pt2RoqR3rYWIcRMizkoAqFPFZxUeBSwRrtQD9WQyTGc
         vuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=oOLUW7z/uR/ZE9IriulkvZavt5cgpGH+Idk/4muWfog=;
        b=FJH+28OtvAC63ZFBFsgK6nxhONMmH+9dF0+fZronzqstoawxpm+Kgsf8YnDpQZXx33
         FUQscfDXF/cqcXGj0dYnH121HcmYULelde4HufzU0fyAvHUzFKvPaJBUldTbDl+vJxBL
         gqEJv82pANo8lvtQWyE/89WJzCQ7AFjBRdX9hu7yfHV36KIawl46bUWFePLNJ5FqHebs
         mteBcJz49Une/twdWmzuKi6iWzB8j35I6k6FVXv/RtagSlplgSxyM1Ac2MXVRdcy0m+p
         pBedpcvKkEaNE6VOUPk7q+ELUMvAx+g0gp2jqN2vX58OOiSNvpC+N4i17ka7nekebZnu
         ZUdg==
X-Gm-Message-State: APjAAAVcYy0qXEmVOVXiW0llqycNjVDWuTSPqqzyafdzgP7KI1uMwjZP
        obCiCmtK6oDCKWzautntBdU8VOlS
X-Google-Smtp-Source: APXvYqyn7T8Owt5tz31C1y2zpF2Ro9GALkhl6OzY1utUQPcHYTfXFW0VAypOmo/IQtXARzecPakcAA==
X-Received: by 2002:a63:1c03:: with SMTP id c3mr4614554pgc.198.1571761986692;
        Tue, 22 Oct 2019 09:33:06 -0700 (PDT)
Received: from [172.20.54.239] ([2620:10d:c090:200::1:58c1])
        by smtp.gmail.com with ESMTPSA id u3sm18679340pfn.134.2019.10.22.09.33.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 09:33:05 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next 0/4] page_pool: API for numa node change handling
Date:   Tue, 22 Oct 2019 09:33:04 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <C432BC84-7B9F-41BF-99F5-E259831A3A49@gmail.com>
In-Reply-To: <20191022044343.6901-1-saeedm@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21 Oct 2019, at 21:44, Saeed Mahameed wrote:

> Hi Dave & Jesper,
>
> This series extends page pool API to allow page pool consumers to update
> page pool numa node on the fly. This is required since on some systems,
> rx rings irqs can migrate between numa nodes, due to irq balancer or user
> defined scripts, current page pool has no way to know of such migration
> and will keep allocating and holding on to pages from a wrong numa node,
> which is bad for the consumer performance.
>
> 1) Add API to update numa node id of the page pool
> Consumers will call this API to update the page pool numa node id.
>
> 2) Don't recycle non-reusable pages:
> Page pool will check upon page return whether a page is suitable for
> recycling or not.
>  2.1) when it belongs to a different num node.
>  2.2) when it was allocated under memory pressure.
>
> 3) mlx5 will use the new API to update page pool numa id on demand.
>
> The series is a joint work between me and Jonathan, we tested it and it
> proved itself worthy to avoid page allocator bottlenecks and improve
> packet rate and cpu utilization significantly for the described
> scenarios above.
>
> Performance testing:
> XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
> while migrating rx ring irq from close to far numa:
>
> mlx5 internal page cache was locally disabled to get pure page pool
> results.
>
> CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)
>
> XDP Drop/TX single core:
> NUMA  | XDP  | Before    | After
> ---------------------------------------
> Close | Drop | 11   Mpps | 10.9 Mpps
> Far   | Drop | 4.4  Mpps | 5.8  Mpps
>
> Close | TX   | 6.5 Mpps  | 6.5 Mpps
> Far   | TX   | 4   Mpps  | 3.5  Mpps
>
> Improvement is about 30% drop packet rate, 15% tx packet rate for numa
> far test.
> No degradation for numa close tests.
>
> TCP single/multi cpu/stream:
> NUMA  | #cpu | Before  | After
> --------------------------------------
> Close | 1    | 18 Gbps | 18 Gbps
> Far   | 1    | 15 Gbps | 18 Gbps
> Close | 12   | 80 Gbps | 80 Gbps
> Far   | 12   | 68 Gbps | 80 Gbps
>
> In all test cases we see improvement for the far numa case, and no
> impact on the close numa case.

These look good, thanks Saeed!
-- 
Jonathan



>
> Thanks,
> Saeed.
>
> ---
>
> Jonathan Lemon (1):
>   page_pool: Restructure __page_pool_put_page()
>
> Saeed Mahameed (3):
>   page_pool: Add API to update numa node
>   page_pool: Don't recycle non-reusable pages
>   net/mlx5e: Rx, Update page pool numa node when changed
>
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  3 ++
>  include/net/page_pool.h                       |  7 +++
>  include/trace/events/page_pool.h              | 22 +++++++++
>  net/core/page_pool.c                          | 46 +++++++++++++------
>  4 files changed, 65 insertions(+), 13 deletions(-)
>
> -- 
> 2.21.0
