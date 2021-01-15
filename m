Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240FD2F83E6
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbhAOSRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732052AbhAOSRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:17:11 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861DFC061796
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 10:16:10 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id j59so3197139uad.5
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 10:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VTlINeSVg0q4ArXqDy2KEmadEKZMV/zMWMhRsiB5z8U=;
        b=aDj1h7aR8vmf5hMcBHemhjEe6KAqV2ftTaIATgd95BLUDf4mmMssHbQYMV1I4w1RK2
         Nf7Rg0ZSZ71P+poNIYZOItUw5vE3L3bDtt6y8zwOA81VsnV/dHGGeu7YBFTnXCKsviPm
         rD0OQU2+QRyRc2JaH0+/HW4hgzQ4zzkZJvzYEJ00cIuRNe1BXoVjsz2Anwn875vz2KFE
         PmOXOaoK68C8ulKfoxw1+2wRndjC+ko3yFv0n9xK81TpsWyLWwdWEBZPVdICor9vIy0H
         TZ6xsN983jhCbGAMzV3EoM2lhMKR4OkalNvMesrxBzu0dmbtxdNdZ1qHR6ZNpW9NIGrZ
         EdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VTlINeSVg0q4ArXqDy2KEmadEKZMV/zMWMhRsiB5z8U=;
        b=JywaF/PGQ2l3nUPbtoGb1BhMWvFXZZiXX3MypFVdgZXx5cCkDKcn9CwUctGzuaVdOw
         WiJ8wve0vQR2H2E5EgU944oITXR9d7lkudpj/lBxNr2njWfzIWyCCNCUodogimatoeJ3
         PZCG/qpf3o+hUHbcVuOjtV1k2wukuTzx4K4GfjBoKjKoXmN6OJ8Xra3NkushhI5uEd+0
         BURFlO4a8TNDRVBxmccl2qDswUsIefkYEnbJu3SUQq/nSkpmlKUSqJpM2KvD340LP1Pn
         7Bbwee8vxLZhi6T6jJ0KGM6DJbKL6ll8CnxXdl46rRHALqwtJighkDmgYRqLAl+ogKJS
         hcWw==
X-Gm-Message-State: AOAM5309rcYLDWe5gmjkDZVBN4U9pRuHGxTFOg6JMZ1xKxjdk5L0zmdx
        cxaoEYFdTjQJMceUXcZRXEVn7xEI0cQ=
X-Google-Smtp-Source: ABdhPJy8IBngCaVABJJF8DvCAJzC+f9QSC1W88DzHoRS/u4Y9NLqIf3MwKuGnXWc8glNQOQ3DZSyEA==
X-Received: by 2002:ab0:7317:: with SMTP id v23mr11084286uao.46.1610734568529;
        Fri, 15 Jan 2021 10:16:08 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id w66sm1324122vkb.50.2021.01.15.10.16.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 10:16:07 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id p128so2379668vkf.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 10:16:06 -0800 (PST)
X-Received: by 2002:a1f:2f81:: with SMTP id v123mr11517700vkv.24.1610734565853;
 Fri, 15 Jan 2021 10:16:05 -0800 (PST)
MIME-Version: 1.0
References: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com> <ff01b9da-f2a7-3559-63cc-833f52280ef6@redhat.com>
In-Reply-To: <ff01b9da-f2a7-3559-63cc-833f52280ef6@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 15 Jan 2021 13:15:30 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdvhJ9An9F5pZHKzEKx1NWFArY=QE0C1RB2+nOVP6iNyw@mail.gmail.com>
Message-ID: <CA+FuTSdvhJ9An9F5pZHKzEKx1NWFArY=QE0C1RB2+nOVP6iNyw@mail.gmail.com>
Subject: Re: [PATCH net-next v7] vhost_net: avoid tx queue stuck when sendmsg fails
To:     Jason Wang <jasowang@redhat.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 1:12 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/15 =E4=B8=8B=E5=8D=8812:46, wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently the driver doesn't drop a packet which can't be sent by tun
> > (e.g bad packet). In this case, the driver will always process the
> > same packet lead to the tx queue stuck.
> >
> > To fix this issue:
> > 1. in the case of persistent failure (e.g bad packet), the driver
> >     can skip this descriptor by ignoring the error.
> > 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM)=
,
> >     the driver schedules the worker to try again.
> >
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>
