Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5501346DD5
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfFOCer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:34:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57576 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfFOCer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:34:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D24C13411E38;
        Fri, 14 Jun 2019 19:34:47 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:34:46 -0700 (PDT)
Message-Id: <20190614.193446.1347676345099982906.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        willemb@google.com
Subject: Re: [PATCH net-next] virtio_net: enable napi_tx by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
References: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:34:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 13 Jun 2019 12:24:57 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> NAPI tx mode improves TCP behavior by enabling TCP small queues (TSQ).
> TSQ reduces queuing ("bufferbloat") and burstiness.
> 
> Previous measurements have shown significant improvement for
> TCP_STREAM style workloads. Such as those in commit 86a5df1495cc
> ("Merge branch 'virtio-net-tx-napi'").
> 
> There has been uncertainty about smaller possible regressions in
> latency due to increased reliance on tx interrupts.
> 
> The above results did not show that, nor did I observe this when
> rerunning TCP_RR on Linux 5.1 this week on a pair of guests in the
> same rack. This may be subject to other settings, notably interrupt
> coalescing.
> 
> In the unlikely case of regression, we have landed a credible runtime
> solution. Ethtool can configure it with -C tx-frames [0|1] as of
> commit 0c465be183c7 ("virtio_net: ethtool tx napi configuration").
> 
> NAPI tx mode has been the default in Google Container-Optimized OS
> (COS) for over half a year, as of release M70 in October 2018,
> without any negative reports.
> 
> Link: https://marc.info/?l=linux-netdev&m=149305618416472
> Link: https://lwn.net/Articles/507065/
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied.
