Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F3D68804D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjBBOmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBBOml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:42:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC9A8C1F6
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675348913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7iy2bjBhE+5ASRMcjrIPiwnyT3pjhYq6egaUAaOhx4=;
        b=Ay4YlcEyOycqLUOeiTjVxzgfbQsqHtoPk8idCGb5wh339LSD6lswJ3zbb/X4F9SHhowjw+
        zWz845QX2QDi8LccfQp3GHeY5Cdm5QPkrOEfN6ekfSIJ2+cTjDdE8Dg6Bu2lnXqbmKJist
        9dMaIGaGpYS0I1UycjNMwJCqINC9dCs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-fjJA2ed3PDCAWN1I7O5mew-1; Thu, 02 Feb 2023 09:41:52 -0500
X-MC-Unique: fjJA2ed3PDCAWN1I7O5mew-1
Received: by mail-qk1-f200.google.com with SMTP id s7-20020a05620a0bc700b006e08208eb31so1432534qki.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 06:41:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z7iy2bjBhE+5ASRMcjrIPiwnyT3pjhYq6egaUAaOhx4=;
        b=MEqA+D5SWWzjNMOir7ybkmWQ1nLzgEFs8rTURCUBipp1q0UC0453rIWSvDcY57LS+Q
         7NgnodUuCC0NdGkwxJZnQZhAkDrvYRddJSbwzYQObvyKjFK3cMEZ/Xl1DIHuDiV7xKWF
         +hkM1N+hK4b9f7VqkszW7PjgXGSzume7mx9wicvIM0PANXcYpOGm6D4t5oVIHizEsgSc
         jsZssq3PG+jYrBFSCcVOHhCbgex7hWci6ibd07wxZDvsKdc7sP4KxcremNGZ7Q08Gkw5
         iwGUc0QNl29lyPHs5wu9ZpbtIGMjokANOLkk+IQm4zNLSgNcjPtUuBFnWICoa2jGJxOv
         kvlA==
X-Gm-Message-State: AO0yUKVRzHOm8f8qKelg6P0YiJsYoWWPtic9283SczTbsmdYdAjBtkEs
        8mJRrY65cDhMf07tJS61iuYHg/Of8lvRU/n2FVWB/RI/EQ/M9Jz6ZjOWqI34CeoWcSBukEecr33
        blhCSZSnkz/LZHCal
X-Received: by 2002:a0c:f44f:0:b0:55b:949e:7721 with SMTP id h15-20020a0cf44f000000b0055b949e7721mr7804120qvm.2.1675348910979;
        Thu, 02 Feb 2023 06:41:50 -0800 (PST)
X-Google-Smtp-Source: AK7set/LyDtDIGcLg99KcjgpY32JW6FBNIIMvyS9KSAsaRgmZ96/nawLigGoKHnlzKr41nnMPX5Dpw==
X-Received: by 2002:a0c:f44f:0:b0:55b:949e:7721 with SMTP id h15-20020a0cf44f000000b0055b949e7721mr7804080qvm.2.1675348910676;
        Thu, 02 Feb 2023 06:41:50 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id q187-20020a378ec4000000b006f7ee901674sm10546872qkd.2.2023.02.02.06.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 06:41:50 -0800 (PST)
Message-ID: <5fda6140fa51b4d2944f77b9e24446e4625641e2.camel@redhat.com>
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Thu, 02 Feb 2023 15:41:44 +0100
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 19:00 +0800, Xuan Zhuo wrote:
> XDP socket(AF_XDP) is an excellent bypass kernel network framework. The z=
ero
> copy feature of xsk (XDP socket) needs to be supported by the driver. The
> performance of zero copy is very good. mlx5 and intel ixgbe already suppo=
rt
> this feature, This patch set allows virtio-net to support xsk's zerocopy =
xmit
> feature.
>=20
> Virtio-net did not support per-queue reset, so it was impossible to suppo=
rt XDP
> Socket Zerocopy. At present, we have completed the work of Virtio Spec an=
d
> Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the supp=
ort for
> the XDP Socket Zerocopy.
>=20
> Virtio-net can not increase the queue at will, so xsk shares the queue wi=
th
> kernel.
>=20
> On the other hand, Virtio-Net does not support generate interrupt manuall=
y, so
> when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last=
 time
> is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also t=
he
> local CPU, then we wake up sofrirqd.

Thank you for the large effort.

Since this will likely need a few iterations, on next revision please
do split the work in multiple chunks to help the reviewer efforts -
from Documentation/process/maintainer-netdev.rst:

 - don't post large series (> 15 patches), break them up

In this case I guess you can split it in 1 (or even 2) pre-req series
and another one for the actual xsk zero copy support.

Thanks!

Paolo

