Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE93E026F
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbhHDNvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbhHDNvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:51:52 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A3EC0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 06:51:39 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id y1so2440746iod.10
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 06:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=68nPIx50G72fNHdU1dcBEsPtx3OF9xmvajVBIyCS/po=;
        b=qPayotjezohGISbFc0kL/JoSZmCfzaa9gtukgjIfhkhs24b15kO53YIUvTe1cg8JtO
         OoYS86Lkwd0Q+Q4l44kZDefCpFAXXGfJ7glm1DkY3RKl9WCaed5QYICankMU/h/UF4u0
         tEAbcRm0mCgBGBJMpHErxs5hWriK9njJqhDEM3fTcpqI04WxTC6G2tC3Q9mB26wWez8v
         XmqmPSMCte9pCEY6Mzy6qvKC/NX6d34kkrMooMr/liRidv8/YXdgNbKEw2rYoV4u6r9w
         IqnHYERy2PFy3o0EZydJzoP3jvRdqZTXhA9KX2IBVFbYdi+N/CTS0I5zXec7xYjplPDj
         LETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=68nPIx50G72fNHdU1dcBEsPtx3OF9xmvajVBIyCS/po=;
        b=YmRTlLxCyP/wl7mfd7gRA0C0u+h2LEjMo8gzqZ5u0wVaOMF7ijHL9Da1vxfrSryBOf
         KfOi6vzs7/ySny1NyyOQHgHJQ769zJP2O1fxpizQmevclowagcvNMTbsJhHi9KL+k9xz
         5ow4vU+Bts0HcteQ8TEU2b1k//XKvy+577sWySRk+U77TQBSiZseLT0hZBorYNqftAEk
         WiasSZqAAatd5/EY6lX/GaQZ2i5j3Cwf7mU0k3U+F4S08XEf9gHeElQf7l8v735B1N83
         uXHlY6Kc756ef6oxjtaBPVAg9/UaPcoLaBrN59sutUEZyCQNoFM4sW2B1LLa6EFuGXbc
         ZjjQ==
X-Gm-Message-State: AOAM5311YhzS8ST6kmPFaJUtjlOyHdPEX6eVVyhaV9XZe8IRKUji2eMP
        PARg9AEjBMvopdf3TrtvEYBPylFoi8nUVtFewoo=
X-Google-Smtp-Source: ABdhPJx/s5W4aY4K+0PL8ycaC5ei0GbKojAogtOUr3HbryX7jmwMlpuUnAvnixVbtuP6fbqpISKI76GlF6qY4HOpRq8=
X-Received: by 2002:a5d:96da:: with SMTP id r26mr872103iol.47.1628085099337;
 Wed, 04 Aug 2021 06:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210723055626.GA32126@lst.de>
 <02c4e0af-0ae9-f4d9-d2ad-65802bdf036a@grimberg.me>
In-Reply-To: <02c4e0af-0ae9-f4d9-d2ad-65802bdf036a@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 4 Aug 2021 16:51:27 +0300
Message-ID: <CAJ3xEMjzRqrj-EN7gbqKmD5txAV-gZn828V+6QAf5wfwYsqySQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 00/36] nvme-tcp receive and tarnsmit offloads
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Shai Malin <smalin@marvell.com>, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 10:59 PM Sagi Grimberg <sagi@grimberg.me> wrote:

> [.. ] It is difficult to review.
> The order should be:
> 1. ulp_ddp interface
> 2. nvme-tcp changes
> 3. mlx5e changes

.. and this is exactly how the series is organized, for v6 we will drop the
TX offload part and stick to completing the review on the RX offload part.

> Also even beyond grouping patches together I have 2 requests:
> 1. Please consolidate ddp routines under a single ifdef (also minimize
> the ifdef in call-sites).

ok, will make an effort to be better in that respect

> 2. When consolidating functions, try to do this as prep patches
> documenting in the change log that it is preparing to add ddp. Its
> difficult digesting both at times.

to clarify, you would like patch #5 "nvme-tcp: Add DDP offload control path"
to only add the call sites and if-not-deffed implementation for the added knobs:

nvme_tcp_offload_socket
nvme_tcp_unoffload_socket
nvme_tcp_offload_limits
nvme_tcp_resync_response

and a 2nd patch to add the if-yes-deffed implementation?

This makes sense, however IMHO repeating this prep exercise for
the data-path patch (#6 "nvme-tcp: Add DDP data-path") doesn't
seem to provide notable value  b/c you will only see two call sites
for the two added empty knobs:

nvme_tcp_setup_ddp
nvme_tcp_teardown_ddp

but whatever you prefer, so.. let us know
