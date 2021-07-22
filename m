Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBBC3D24C0
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhGVM7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhGVM7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:59:35 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957C6C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:40:09 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id k184so8315037ybf.12
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/SYEUTpMcYPz7ljfmN2tSvSvDf5PRFbAVjr0C0ufJo=;
        b=Z6pmogOABigg8nzrH2VHgN59Ye6w3ShFXG4i+q7xQd0Bb2BOXwYjLyyZTjv/AXSQum
         p5C8jK/0KJWOROT1gB3IExD+t9qo3MFxYomri2BquX2NOyNMrfq3FFXxkNcEX6DkFfHC
         FKPUcKPqfeD0JtdnqWzvattypfXCdC3vnOFOvTFQtyHEVqbqQfbl/Yh7PiAekWczQIoU
         Yym+3QmGE3KCXcGfRPigHLQR6SLhJbtlUmcL5X6K4PWtVu5ZUHZ83UBp0/Drj2oGrQEt
         wSSNUbx/3/Ak0IxJX35hFnUNnKdIdiMrhBQKKCJI8kNzWSjLRPvclyLQYP0hqxfaeIGF
         q7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t/SYEUTpMcYPz7ljfmN2tSvSvDf5PRFbAVjr0C0ufJo=;
        b=tiMU2ftt5MgbDHGEBqt2VwHwwc66gs+y1PT1pMieMoSm6VCvHfC5uginJzkE/tzi9n
         T2IdhycDASXHvs8NRXuTJrxLWvsBSsmYgPEDS/03pRwh5bTAzLtu/OPfgAvkpQ5ZRBm+
         qlLxSvnH6e0r9vLHxDZd8DWH6pKZhGWjsRY1wqRCLOy98Dx6iQZliOgsGToftcQKJEFO
         2UvFP0nFK5cG1bgMrizKnYC1bbu/dYfMvmiEkF6HawzJjUJeto/lgW/OYeKU54Q3nTQT
         vRDikEcxmVEFxE6ju5Lhg2nX7DA6vrlW7SpxmPeI+NXBW9Eh+9qx8fc+zzFzQDv7q/cS
         SgbQ==
X-Gm-Message-State: AOAM53219pn0NbwxKBgJRtYmPLqdlWkQ8GhloUOGzzZMU6Po7y4n4dBK
        MGP7gNmskW7ZqAv1+YRX+gSlV06/51tx6SWckgdQRw==
X-Google-Smtp-Source: ABdhPJwAMPt2rCrRmZCZp2l0hbRR1pf0HqduTCNcfwu0o+n2AKY27xHTkl/8rX/MYaOvFX5QrKjzeOXVJc+aiSgWK/o=
X-Received: by 2002:a25:f0b:: with SMTP id 11mr51639739ybp.518.1626961208474;
 Thu, 22 Jul 2021 06:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-2-borisp@nvidia.com>
 <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com>
 <7fdb948a-6411-fce5-370f-90567d2fe985@gmail.com> <CANn89iLUDcL-F2RvaNz5+b8oQPnL1DnanHe0vvMb8QkM26whCQ@mail.gmail.com>
 <ba72f780-840e-de73-31b3-137908c52868@gmail.com>
In-Reply-To: <ba72f780-840e-de73-31b3-137908c52868@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Jul 2021 15:39:57 +0200
Message-ID: <CANn89i+kHx5zzKcPQZ406fw9DWchxXrNJQhqwGe2_=hvrxSwYw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 01/36] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borispismenny@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 3:33 PM Boris Pismenny <borispismenny@gmail.com> wrote:

> Sorry. My response above was about skb_condense which I've confused with
> tcp_collapse.
>
> In tcp_collapse, we could allow the copy, but the problem is CRC, which
> like TLS's skb->decrypted marks that the data passed the digest
> validation in the NIC. If we allow collapsing SKBs with mixed marks, we
> will need to force software copy+crc verification. As TCP collapse is
> indeed rare and the offload is opportunistic in nature, we can make this
> change and submit another version, but I'm confused; why was it OK for
> TLS, while it is not OK for DDP+CRC?
>

Ah.... I guess I was focused on the DDP part, while all your changes
are really about the CRC part.

Perhaps having an accessor to express the CRC status (and not be
confused by the DDP part)
 could help the intent of the code.
