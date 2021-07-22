Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8FC3D25A5
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhGVNnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhGVNn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:43:29 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98498C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:24:04 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id c16so1758259ybl.9
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZrDdzs8PEEUYBhRoHxBInlAmMts2fSYYQKODBWYcMQ=;
        b=ZU5nnf20kYGsWviyI76tYstfqIqub/it6RsYY8lnp/E/cCz2ZzgjgEs/I/gzyBsm4E
         WBiwsdRWrMoL+7OzBQ8whsq9LxyfCJz5t2k0pj/YCmQ2D4+wY/3hFJ9+1PUQQeMzPjFS
         WlFulK9YpokK62kea1Iz6nmj5MXHdxKJbHgzKvWtmyHHeZRhykziPyPuKf1BuUpYDqAA
         WfZgmoe3KnTfLdPAoNE7bdcoCirjMg2sb2S10b4eVOWRCILMKIdYSDgnVCU+rjlbMa83
         HggAEe6D+pf0KtYmStvha7JqN7sTu8TGvavfOiv5NX5aqwa+Un7l/DCOkWDzu51z07/1
         ZP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZrDdzs8PEEUYBhRoHxBInlAmMts2fSYYQKODBWYcMQ=;
        b=W+46xiqJDqmo2llwsSatjlCr16dPBYjDKcYyGso2i+b0Ye7t1KG8Dpg0MS+6V6S4p1
         62S/j8lAwBMsiTtRv5KaPNBQILcu94fVRk3hP0IHMlZYZ9ObcctYoOKzfvSuEXfYTpF+
         1N7715Q207oPqgLH9HugcCdZFdeMigVUdcvLvrsxAuW8YDADixGyZWkr8Ut3i2thPeIE
         0Ui19xv5MWQtMFwHH9e6xcVZ/mIshm5nJYh430fpawWwUEbNkkOxUs/C2HFU3wBgamYN
         QEbOAF/zhv7gxkgTRBe02UFU2s5pBQBQQrNEKMuwc3z0A1tM82glAaBbfI1JzDMMgvI5
         bIug==
X-Gm-Message-State: AOAM532FuPnc8XTAHrLOfSKtG81+6zV+1DNMfrl8nde82itrXUUs6m2S
        UFWJLR568SRz33g/iO9YQ0gUNnaD8zPL+yAJblud3g==
X-Google-Smtp-Source: ABdhPJw3/tZuxDkr6ZjXPwr7PbS/ybmHtdyHUfRL0NL/tqHjWRehBhWRwwCsQl0Qp8VCbvjW7Yy1V2aITCwLZ4DD5o8=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr54243090ybm.234.1626963843442;
 Thu, 22 Jul 2021 07:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-25-borisp@nvidia.com>
In-Reply-To: <20210722110325.371-25-borisp@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Jul 2021 16:23:52 +0200
Message-ID: <CANn89i+xCzwGEbWCu6A2neqFt_SaDK9Y3GVPCTz0Nv0+OrnQiw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 24/36] net: Add MSG_DDP_CRC flag
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 1:06 PM Boris Pismenny <borisp@nvidia.com> wrote:
>
> From: Yoray Zack <yorayz@nvidia.com>
>
> if the msg sent with this flag, turn up skb->ddp_crc bit.
>
> Signed-off-by: Yoray Zack <yorayz@nvidia.com>

Ok, but why ?

How would you document in linux manpages the purpose of this flag ?

How can applications be sure the kernel they run on is actually
supporting this flag ?
Maybe it is a hint only ?
