Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB363AC7BD
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhFRJhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231891AbhFRJhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624008939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rLL8PB172SRL8lGgz205HV0dC/eqDJtIYHSvhcZcv70=;
        b=fzMLwXq8ghGTtTkF6cEwGWk19tFWo1nvopXBikxp2ZO37bP3cSuawZchKeeSJw4UX6Ih7Q
        PEZ2EH2oPE/8StesFgUS5U9ikvQ0hU2wYv6PNO6jyzdyG2OXsUd+7wkIrdVHY62ja+yYf2
        fOtU4nd0KP6APa53Ttwhfce+DTg64WM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-qQVl0UZxNWGh-Hd_7tMlvQ-1; Fri, 18 Jun 2021 05:35:37 -0400
X-MC-Unique: qQVl0UZxNWGh-Hd_7tMlvQ-1
Received: by mail-ed1-f69.google.com with SMTP id y16-20020a0564024410b0290394293f6816so3207753eda.20
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rLL8PB172SRL8lGgz205HV0dC/eqDJtIYHSvhcZcv70=;
        b=n36aMda/NY443kr4hsRFne/y06zKL0jE5nZK01rcykmZ36PmGLrL9N2ORMxWlY3oop
         sOhXb1WH16MNhOvHjdwe/8PgTVTyin3w2/FxOHcjwQSFJCo+Jsv0q1424cJg3vdf6WJR
         t09DvNfZeA7X+PWoRcdN54aL5/8c2lrSR0t4m3OKtdDkJ+j3GsRD1iAc24kH6j+WKe+/
         kjx1/JoX12CX5fJ3ZmlLaQqReFW7vLtkJAFjmZd5meKy7hKBCNJsaV1JGutwx27TkE0u
         kcLbITknhUR1QBu+6YNgXhg/I5jao4KzH5DKN6NrEbhQsJMflhTEz6nQISl0/DHt3KHD
         PIYw==
X-Gm-Message-State: AOAM533E0Ry3/GvvILv00tnPGU9/EK8dTImoApN1GbQzQ9/JC6ipR4N+
        sCfno4rcpdHcnq4Lrc45M3K7WnjTLq7Ppmt9nQEP3A4RF/ui5ez1bKsF/O8coCGpKoVpgDuUfm/
        i+beCfUSNheTaDlPO
X-Received: by 2002:a50:9d8d:: with SMTP id w13mr3745081ede.94.1624008934361;
        Fri, 18 Jun 2021 02:35:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrTXbUUFRfwaNYCZ2CYmaoH3ldgRuFW7Ykg1x5qXMOhN3Q/A6Vhme8lxLfTWTSAbzIR/PDfg==
X-Received: by 2002:a50:9d8d:: with SMTP id w13mr3745054ede.94.1624008934194;
        Fri, 18 Jun 2021 02:35:34 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.252])
        by smtp.gmail.com with ESMTPSA id ch17sm5993778edb.42.2021.06.18.02.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 02:35:33 -0700 (PDT)
Date:   Fri, 18 Jun 2021 11:35:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
Message-ID: <20210618093529.bxsv4qnryccivdsd@steredhat.lan>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609232501.171257-1-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 11:24:52PM +0000, Jiang Wang wrote:
>This patchset implements support of SOCK_DGRAM for virtio
>transport.
>
>Datagram sockets are connectionless and unreliable. To avoid unfair contention
>with stream and other sockets, add two more virtqueues and
>a new feature bit to indicate if those two new queues exist or not.
>
>Dgram does not use the existing credit update mechanism for
>stream sockets. When sending from the guest/driver, sending packets
>synchronously, so the sender will get an error when the virtqueue is full.
>When sending from the host/device, send packets asynchronously
>because the descriptor memory belongs to the corresponding QEMU
>process.
>
>The virtio spec patch is here:
>https://www.spinics.net/lists/linux-virtualization/msg50027.html
>
>For those who prefer git repo, here is the link for the linux kernel：
>https://github.com/Jiang1155/linux/tree/vsock-dgram-v1
>
>qemu patch link:
>https://github.com/Jiang1155/qemu/tree/vsock-dgram-v1
>
>
>To do:
>1. use skb when receiving packets
>2. support multiple transport
>3. support mergeable rx buffer

Jiang, I'll do a fast review, but I think is better to rebase on 
net-next since SEQPACKET support is now merged.

Please also run ./scripts/checkpatch.pl, there are a lot of issues.

I'll leave some simple comments in the patches, but I prefer to do a 
deep review after the rebase and the dynamic handling of DGRAM.

Thanks,
Stefano

