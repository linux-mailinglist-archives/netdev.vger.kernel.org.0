Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8F30C98D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhBBSWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbhBBSPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:15:23 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F3AC0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 10:14:42 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k4so21348763ybp.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 10:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q4Yet8/ICUuecxx3G8n77Q2xsvxpIESRvJ/T6154iuQ=;
        b=NhN8vrvP2eO34zTWQNC5MdOiqQA8HXgPZY/h5EGUpkHwzEZ2go5Mfq49nEITvGje9w
         s5eF/Gi4b8T3YprD3BsTD1jGWr4EZJca4IA8kt9WckVCsZL+dxPSpWUrYkhLsWvcVeUU
         cUL1g0NWyFF7cFZoxWKqj8kzbdWcmCPJyxK/+NCq/E50xQ7hdSBDFxpT31b1QcrPof1i
         QeeLXomoBFPeNZPV4CAgRgIM9TZujLSsxmvgIjoYsawAO5fKEYx/S21t7raOSfKQ5lON
         R8zT5gXg3TXPjBHebvRkQkJuYadIYReCo5QjOLaB+E3JgwTKtdT5sESsQrKvzZ4Gk/Pd
         Lxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4Yet8/ICUuecxx3G8n77Q2xsvxpIESRvJ/T6154iuQ=;
        b=HLgLDw35lDDkGBptPEbGaMXOxjtH1FcICrvCN8BnukspCwLguzc4ifJvijxkPDxppq
         fb2WsqH7aAsH1OdxLkLYAy16ArvP08n9OmTPf5j36wDyFszySmhidGqZTyoX6y0kwcWC
         jRzEKv+DJDtRaHgS05Le6o9PwWc24xlHGjlDJ7+UU3iYWhAx8JVc2/cutx+608Q8viHe
         IxT+FZWgZduVD/fH1L7l+N0tW0ysxA82idHPl3/KeNeFCXZGnUGmhIHw8KZHqlo91e2o
         FFvLjoNHYx30qcQzeXeEPNTb21dEr+gpksBr9Vs0GZhUO7ahEkAnFQIdqteb3QgNMFvj
         Ok0w==
X-Gm-Message-State: AOAM533mIVhOEuiVEm+YUQcaObhHeLuI30x1g4VA4TwGA2LEB4DlGSTu
        Ar80Y2n2FDXIus3YwGbAaEE1Tk/cpYDjvu03b9k=
X-Google-Smtp-Source: ABdhPJwuULxnYDOw9vRvGPNO1pzxjIRiQYMajRXjd92soZGhut9VeX5yjyuWhRPpS/rAlGuSs3I5CJ702h6r3k4J7y4=
X-Received: by 2002:a25:76ce:: with SMTP id r197mr13366975ybc.11.1612289681486;
 Tue, 02 Feb 2021 10:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-8-borisp@mellanox.com>
 <20210201173744.GC12960@lst.de>
In-Reply-To: <20210201173744.GC12960@lst.de>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 2 Feb 2021 20:14:30 +0200
Message-ID: <CAJ3xEMhninJE5zw7=QFL4gBVkH=1tAmQHyq7tKMqcSJ_KkDsWQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 07/21] nvme-tcp: Add DDP data-path
To:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com
Cc:     Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        yorayz@nvidia.com, boris.pismenny@gmail.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 7:40 PM Christoph Hellwig <hch@lst.de> wrote:
> Given how much ddp code there is can you split it into a separate file?

mmm, do we need to check the preferences or get to a consensus among
the maintainers for that one?
