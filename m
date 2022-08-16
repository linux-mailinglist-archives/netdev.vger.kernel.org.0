Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCF65973C0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbiHQQLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240881AbiHQQLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:11:20 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A93F9F76C;
        Wed, 17 Aug 2022 09:11:09 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r69so12356161pgr.2;
        Wed, 17 Aug 2022 09:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=MecChw+7gX16c23ZglNUB2LcmNSIQPOmIL4PPR6f9Ek=;
        b=RC3Bcsjz+Tt/WKmtQIcxzHpr6VlfHcVwuCYhhyjhlMY0iFwVRz+CrSrre4h9hzgA8e
         a+0dRoipxqsQiC8J15r4HlSOqvqiL0ECPZB7b/al2XN8LZArVQqFOTqcBELIywim7TJj
         8GS89CzE7+8i9IYuiVUAhppK/F1JJ/6w6NXJEHprNRMm1YnBFUyGdeW0n+/w6iNHEPVm
         VjpTI2qspfUNtgNN9LLgpeBJ1zUC/OlcFsmJQ/NeO/9dX9WoMolVpJlBRzgP9L3j+SIQ
         2lgWw5beGR8nfFSQdW6ciW5guLaLk/ZpoFw/jeiNBByFUCj5hY93OymA9jxnybfjJsy6
         12Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=MecChw+7gX16c23ZglNUB2LcmNSIQPOmIL4PPR6f9Ek=;
        b=W/07aw8pzYB9vbZphEnddW9VkT1g0ZtDKgAOwPWHteNom5h9JXlGijeOyyG9gcMtHb
         /nKBPdVjuu5owkSUZsbKwxGJLH6ph4zg9Lu6GfgXmCsgM/1PPOpbQ7TXyBjoPilmNFz1
         DI9vLgGuLGNQ6O/9TVnA5Oy4f9eRAITYgr5/YM+/9z7Pj4aOc7RWFFtxKmteLYjVJb9L
         RnfdwvkbELUMuyHgYEYUtxLtHmRyep0PPj+pWTBgy29r4ypIh3Ofm7jlGARwxhmmreBM
         enx5f3eFYoIgNmrfoUddR5bOJUUcCr0YriQzhLjWe7XHfPmt29bEbVKdLa7pZX5GWVLD
         OyvQ==
X-Gm-Message-State: ACgBeo3/TLy0ATgxAKy00wqB5raQZcfTejgE8bSUtx1RpAMo+NINUFb1
        Q4wfFe5rS+2epYgTR2X9/Ac=
X-Google-Smtp-Source: AA6agR51o8Q+PHdYduMQAiLT/vq4twBjog7wFsfFXrbDSHoWsRTQ2lnX1+Ji8LbLYrqEQo74+Ytzlw==
X-Received: by 2002:a63:b07:0:b0:429:411a:ff51 with SMTP id 7-20020a630b07000000b00429411aff51mr11987848pgl.207.1660752669309;
        Wed, 17 Aug 2022 09:11:09 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id 5-20020a620605000000b0052e57ed8cdasm10685780pfg.55.2022.08.17.09.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:10:50 -0700 (PDT)
Date:   Tue, 16 Aug 2022 09:42:51 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <YvtmYpMieMFb80qR@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817025250-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 02:54:33AM -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
> > Hey everybody,
> > 
> > This series introduces datagrams, packet scheduling, and sk_buff usage
> > to virtio vsock.
> > 
> > The usage of struct sk_buff benefits users by a) preparing vsock to use
> > other related systems that require sk_buff, such as sockmap and qdisc,
> > b) supporting basic congestion control via sock_alloc_send_skb, and c)
> > reducing copying when delivering packets to TAP.
> > 
> > The socket layer no longer forces errors to be -ENOMEM, as typically
> > userspace expects -EAGAIN when the sk_sndbuf threshold is reached and
> > messages are being sent with option MSG_DONTWAIT.
> > 
> > The datagram work is based off previous patches by Jiang Wang[1].
> > 
> > The introduction of datagrams creates a transport layer fairness issue
> > where datagrams may freely starve streams of queue access. This happens
> > because, unlike streams, datagrams lack the transactions necessary for
> > calculating credits and throttling.
> > 
> > Previous proposals introduce changes to the spec to add an additional
> > virtqueue pair for datagrams[1]. Although this solution works, using
> > Linux's qdisc for packet scheduling leverages already existing systems,
> > avoids the need to change the virtio specification, and gives additional
> > capabilities. The usage of SFQ or fq_codel, for example, may solve the
> > transport layer starvation problem. It is easy to imagine other use
> > cases as well. For example, services of varying importance may be
> > assigned different priorities, and qdisc will apply appropriate
> > priority-based scheduling. By default, the system default pfifo qdisc is
> > used. The qdisc may be bypassed and legacy queuing is resumed by simply
> > setting the virtio-vsock%d network device to state DOWN. This technique
> > still allows vsock to work with zero-configuration.
> 
> The basic question to answer then is this: with a net device qdisc
> etc in the picture, how is this different from virtio net then?
> Why do you still want to use vsock?
> 

When using virtio-net, users looking for inter-VM communication are
required to setup bridges, TAPs, allocate IP addresses or setup DNS,
etc... and then finally when you have a network, you can open a socket
on an IP address and port. This is the configuration that vsock avoids.
For vsock, we just need a CID and a port, but no network configuration.

This benefit still exists after introducing a netdev to vsock. The major
added benefit is that when you have many different vsock flows in
parallel and you are observing issues like starvation and tail latency
that are caused by pure FIFO queuing, now there is a mechanism to fix
those issues. You might recall such an issue discussed here[1].

[1]: https://gitlab.com/vsock/vsock/-/issues/1

> > In summary, this series introduces these major changes to vsock:
> > 
> > - virtio vsock supports datagrams
> > - virtio vsock uses struct sk_buff instead of virtio_vsock_pkt
> >   - Because virtio vsock uses sk_buff, it also uses sock_alloc_send_skb,
> >     which applies the throttling threshold sk_sndbuf.
> > - The vsock socket layer supports returning errors other than -ENOMEM.
> >   - This is used to return -EAGAIN when the sk_sndbuf threshold is
> >     reached.
> > - virtio vsock uses a net_device, through which qdisc may be used.
> >  - qdisc allows scheduling policies to be applied to vsock flows.
> >   - Some qdiscs, like SFQ, may allow vsock to avoid transport layer congestion. That is,
> >     it may avoid datagrams from flooding out stream flows. The benefit
> >     to this is that additional virtqueues are not needed for datagrams.
> >   - The net_device and qdisc is bypassed by simply setting the
> >     net_device state to DOWN.
> > 
> > [1]: https://lore.kernel.org/all/20210914055440.3121004-1-jiang.wang@bytedance.com/
> > 
> > Bobby Eshleman (5):
> >   vsock: replace virtio_vsock_pkt with sk_buff
> >   vsock: return errors other than -ENOMEM to socket
> >   vsock: add netdev to vhost/virtio vsock
> >   virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
> >   virtio/vsock: add support for dgram
> > 
> > Jiang Wang (1):
> >   vsock_test: add tests for vsock dgram
> > 
> >  drivers/vhost/vsock.c                   | 238 ++++----
> >  include/linux/virtio_vsock.h            |  73 ++-
> >  include/net/af_vsock.h                  |   2 +
> >  include/uapi/linux/virtio_vsock.h       |   2 +
> >  net/vmw_vsock/af_vsock.c                |  30 +-
> >  net/vmw_vsock/hyperv_transport.c        |   2 +-
> >  net/vmw_vsock/virtio_transport.c        | 237 +++++---
> >  net/vmw_vsock/virtio_transport_common.c | 771 ++++++++++++++++--------
> >  net/vmw_vsock/vmci_transport.c          |   9 +-
> >  net/vmw_vsock/vsock_loopback.c          |  51 +-
> >  tools/testing/vsock/util.c              | 105 ++++
> >  tools/testing/vsock/util.h              |   4 +
> >  tools/testing/vsock/vsock_test.c        | 195 ++++++
> >  13 files changed, 1176 insertions(+), 543 deletions(-)
> > 
> > -- 
> > 2.35.1
> 
