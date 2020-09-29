Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B94527BFBE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgI2Ijj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbgI2Ijj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:39:39 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A44C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:39:38 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id z193so2450357vsz.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZUBddKNPgJHj5qtM1eGlZtL03dAbKbibCL5xODrGyaI=;
        b=USPhHzIjFDsnuU065wTU/l9LlzFcP7JbECKZOgZ8uevFoDWkcCmhvUCQtncBtDiZhX
         BTsLIM+2+6uuLMmsZ9Xxi+ejCd3JFxklq/sxNcpfZ4h/0ZIGSXXllM4cHsK5M4Vnka/b
         7vl08mbeq3BJ50eQ34tEPZ9Kp2pOII2XF3NPu6gEDocyAqclrk2zfoOanadon5vDGQh4
         a/VOpYWZj02gZpTZok3Nfl20b+lW951WcyoUP/9hMem6Yu4T0lr1e79v7mszd/Rnwp3m
         SI1o8fpqZzfF0OGz031Trek8UWTz60t3QVXqoOSxpl7fh+E+s5Xj++emQ054GaCjSMr3
         NrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZUBddKNPgJHj5qtM1eGlZtL03dAbKbibCL5xODrGyaI=;
        b=OBMNZBnf6+UHsYwCY/7JCg/z+vk0CNUssbJLt/Qol2tZYl5aCjb8P478HvQd0jgYfB
         3DgIRdQ1jHFRAkqHGll/udt5stJYeV7TKLSGaUSjK+UZRwdBHMg3Qb45d+AWV61RiLjW
         oUDnriPyxRKKV01jCg+O6eDWcAjgq7gzSmnCMKAHObsWfrgOd8ryMf+RSMWuKS9a5xul
         4KTj/qNpbmC/V3Yb9A5+ZU+itqGIXaCDACClqctcdV3JrObeoDFpASUJAd9jGO2ujBsM
         2eyI0l/iNF/wplpAHsyy2/Rv0AkFAZLhg1TSsvUF/bka03uBTgif5ehq2HlQEsN1O4C2
         H24w==
X-Gm-Message-State: AOAM532imgweMOhpHwEgInPsC1my3qYPq78tvb6DNfHSTWxXsOuciI2y
        FxS/DCgSrPadzW3Z7Hz9UKprwO8x2EXkaw==
X-Google-Smtp-Source: ABdhPJxoD6aAaojxHIaPkoj1X98o0H7/lcLwgmSijYk+L+es/LM927CmrlZ69h2DmRie4P/y340D0g==
X-Received: by 2002:a67:e951:: with SMTP id p17mr2019945vso.21.1601368776902;
        Tue, 29 Sep 2020 01:39:36 -0700 (PDT)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id t20sm380877uap.7.2020.09.29.01.39.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 01:39:35 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id a16so2230124vke.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:39:35 -0700 (PDT)
X-Received: by 2002:a1f:1f15:: with SMTP id f21mr1895617vkf.12.1601368775291;
 Tue, 29 Sep 2020 01:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
 <CA+FuTSebRQ=2VfT0KnM6ChjMg0j3NWJDPwn9S=aQk8tbNrUt6w@mail.gmail.com> <CAMDZJNW=hEEcsJy1gUEwrnERRgH3kRBkEuDtcPwPdfXr91eTGg@mail.gmail.com>
In-Reply-To: <CAMDZJNW=hEEcsJy1gUEwrnERRgH3kRBkEuDtcPwPdfXr91eTGg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 29 Sep 2020 10:38:59 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdJ78xSTQJeLOuarSm5sR_MJZ3MFjiA9V6SiMJy81E5dg@mail.gmail.com>
Message-ID: <CA+FuTSdJ78xSTQJeLOuarSm5sR_MJZ3MFjiA9V6SiMJy81E5dg@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 9:56 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 3:32 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 4:00 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Open vSwitch and Linux bridge will disable LRO of the interface
> > > when this interface added to them. Now when disable the LRO, the
> > > virtio-net csum is disable too. That drops the forwarding performance.
> >
> > I had focused on the code previously.
> >
> > The s/w checksum verification cost is significant in a VM with traffic
> > to local destinations. A bridge does not verify transport layer
> > checksums OTOH?
> Hi Willem.
> No, think about GRO(In the GRO we don't know packets will be forwarded
> to other ports or to local).

I had expected a pure bridging setup that disables LRO to disable GRO as well.

But if not, then, indeed, the checksum needs to be verified before
coalescing. Makes sense.

> The call tree as below:
>    + 5.41% secondary_startup_64
>    - 1.22% ret_from_fork
> ....
>         net_rx_action
>         napi_poll
>         virtnet_poll
>         virtnet_receive
>         napi_gro_receive
>         dev_gro_receive
>         inet_gro_receive
>         tcp4_gro_receive
>         __skb_gro_checksum_complete
>         skb_checksum
>         __skb_checksum
>         csum_partial
>         do_csum
>    - 1.13% do_csum
>
> $ brctl show
> bridge name bridge id STP enabled interfaces
> br0 8000.001122330001 no eth1
> eth2
