Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB905B27A3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiIHUWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiIHUWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:22:44 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB931079FD
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:22:42 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-127d10b4f19so21697965fac.9
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 13:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RX8VIBrkIrN+uaJDyGYK1oayYALRo341SLY9FJGeLKg=;
        b=BOSQ+7TVFALXbxC/myMu5Chncu9V3l4sSSxY4m0Bx02D2bgLEFpAbb5BltskTSr+5F
         F70VCqtvBpr3Q4AFCBsDmpLukbkEYUhpmykaTpNj12w37og7JsupiMmJKnsVhnBNAbdJ
         hAhMAUzA1kQlQmqsKZ/GOKRml0/zJTsu2tPGYflD2YKqBQuBWqCz2Ipf8dbhnqCxz/Z3
         rCsguQKWgB3xbFyTgY/FoqIJ69KBVkn0ktWbgK+gfzDaVhmOc84RzmawuiGIbSZPF06g
         /Qb0TXYcSI7c8gutf7cwJsaoPMP5cQ3oy2G3bklXfmkKos4jtJhiBNaRVkg+RACOz7Bz
         tM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=RX8VIBrkIrN+uaJDyGYK1oayYALRo341SLY9FJGeLKg=;
        b=nFv7OlDoRq2l71QfgMx0X6Hmwx17Hr1vt2mx8gh1SYlHi75FxALxM35IxkMxlbvCOv
         mYN/CdVlUlfjg1g0/KYxRTULp20k7QTU3/xEzCFg8xQGD3GUKjmJPjgwKJtESbfhMkAe
         A7Fak0YTGyRmq8N/wykEK2ckag7W+EPvifNDpfcAu8LF0/WWm8XUa+VZNGR1n2Ld2QK3
         fiusOMsVs3N6/yHKTkmdl8iPWzlaBQLAYad5O5Js6mPkQGpJBDzH67HPTQUCNgYP1Z8f
         Nr/T41rCRvb4ivmiRZSkkvgwFUZoNGInCdp3CQzrWRJQ/VsbCruX5j1Uguud8rUSjhyp
         Z2zA==
X-Gm-Message-State: ACgBeo2HJiUsUdlnxSJjGOlUU81k0QrQWjq0CsV36KsRVwT9YUbZBlly
        VntEgllokILnJ81zLyA6uEGefZI54LOHgw7YzeDpIw==
X-Google-Smtp-Source: AA6agR49XRbIMolMgRxwv8qrnpTs2QgNkLEpVvZTqKvSQ7ilNqc92R6DLRt+yLI0hlnLZ5GHBBBhLlWXrjDL36m0UZg=
X-Received: by 2002:a05:6808:2382:b0:344:90f9:b79 with SMTP id
 bp2-20020a056808238200b0034490f90b79mr2264444oib.137.1662668561813; Thu, 08
 Sep 2022 13:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220907125048.396126-1-andrew@daynix.com> <e1e6519f-2e77-05c1-697c-56b174addc6e@kernel.org>
In-Reply-To: <e1e6519f-2e77-05c1-697c-56b174addc6e@kernel.org>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Thu, 8 Sep 2022 23:09:24 +0300
Message-ID: <CABcq3pFbKB26x2yCAxMFTU02uAkQrRCRvY1YNYRcx6zHbG54Kg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] TUN/VirtioNet USO features support.
To:     David Ahern <dsahern@kernel.org>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, yan@daynix.com,
        yuri.benditovich@daynix.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Thu, Sep 8, 2022 at 3:44 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 9/7/22 6:50 AM, Andrew Melnychenko wrote:
> > Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> > Technically they enable NETIF_F_GSO_UDP_L4
> > (and only if USO4 & USO6 are set simultaneously).
> > It allows the transmission of large UDP packets.
>
> Please spell out USO at least once in the cover letter to make sure the
> acronym is clear.

USO - UDP Segmentation Offload. Ability to split UDP packets into
several segments.
Allows sending/receiving big UDP packets. At some point, it looks like
UFO(fragmentation),
but each segment contains a UDP header.

>
> >
> > Different features USO4 and USO6 are required for qemu where Windows guests can
> > enable disable USO receives for IPv4 and IPv6 separately.
> > On the other side, Linux can't really differentiate USO4 and USO6, for now.
>
> Why is that and what is needed for Linux to differentiate between the 2
> protocols?

Well, this feature requires for Windows VM guest interaction. Windows may have
a separate configuration for USO4/USO6. Currently, we support Windows guests
with enabled USO4 and USO6 simultaneously.
To implement this on Linux host, will require at least one additional
netdev feature
and changes in Linux network stack. Discussion about that will be in
the future after
some research.

>
> > For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> > In the future, there would be a mechanism to control UDP_L4 GSO separately.
> >
> > New types for virtio-net already in virtio-net specification:
> > https://github.com/oasis-tcs/virtio-spec/issues/120
> >
> > Test it WIP Qemu https://github.com/daynix/qemu/tree/USOv3
> >
> > Andrew (5):
> >   uapi/linux/if_tun.h: Added new offload types for USO4/6.
> >   driver/net/tun: Added features for USO.
> >   uapi/linux/virtio_net.h: Added USO types.
> >   linux/virtio_net.h: Support USO offload in vnet header.
> >   drivers/net/virtio_net.c: Added USO support.
> >
> > Andrew Melnychenko (1):
> >   udp: allow header check for dodgy GSO_UDP_L4 packets.
> >
> >  drivers/net/tap.c               | 10 ++++++++--
> >  drivers/net/tun.c               |  8 +++++++-
> >  drivers/net/virtio_net.c        | 19 +++++++++++++++----
> >  include/linux/virtio_net.h      |  9 +++++++++
> >  include/uapi/linux/if_tun.h     |  2 ++
> >  include/uapi/linux/virtio_net.h |  5 +++++
> >  net/ipv4/udp_offload.c          |  2 +-
> >  7 files changed, 47 insertions(+), 8 deletions(-)
> >
>
