Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E13E59648B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbiHPVVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiHPVVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:21:03 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD54A8A1FE;
        Tue, 16 Aug 2022 14:21:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f30so10419494pfq.4;
        Tue, 16 Aug 2022 14:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=rZz8bTF2NcPtmVJ0WP5KDpOKcOl43ZBJ+1AR/XSbYLg=;
        b=bV+k5Bi7aHC7OQ5MMSqyosvgyjzXZiK+iNX2RNdes6NMjMk7SbtPl5oivBva1PkcL8
         rKwBzUVoOLc4QHdIN2suICc/baLJjosEkTBtp3cm11v+mqIyGwtNAiDUK0Su9i9YaSxi
         SzTHPlzRpkPnDozzpDpTwXi0pZaxr+B2ne8tM3A6KrOkKJnYgF94ocw14WYt1gZYmJvg
         S3i9JiB0F78nLKgq/HDabD7tBcDNDHeDrN2YllPbw/JIgJMEVYDojsAGALR1S9QtrUza
         EfAtaXRi/oI90POA/6DJM94mGMJiqLkfqiaePIGR0tLCQI9DZFNfObPZGG4kYolPgXsa
         Bk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rZz8bTF2NcPtmVJ0WP5KDpOKcOl43ZBJ+1AR/XSbYLg=;
        b=nCfNsV8vzNEUZv1KbXePRDu1u6eMpDo1SeiPiDu5u22FXxvqykDI7moLNigAUVLFbI
         /XPdHBJOtNBvvbiWG60w1pZF9v5+GPjc489ok2POoJNL3ti899D/5OFzDQePUKh6HB+S
         F6PFmC8q/RgQ1zuFOBb9n2Zaa13A80TtvO6QnqqOQEIrfGXaTl9t5wpDBok77j1pV40u
         DC9YEW3s1yativIapq1Zrm5sdqHwR9tzMQOSGnLTdd3xzYroIZRqcch3jDr347z5p0sA
         UvO4YAaqootraofL9g5YB3sooo3iv3IlkbqBr3fdGjWux3Xrxvi8x4QCnQ1go4ZWT3mw
         D80w==
X-Gm-Message-State: ACgBeo1NZ4KlvpuO0BJzZZlDrw2+VqTStvfU1wqcy95JsG57FIGpKsil
        sm3sEpend1hZGxjsrUl2820=
X-Google-Smtp-Source: AA6agR4YLR5lA1zKDCby2mqX+HJq2T8wb9mbU/S5aW4j2gvI5lNQI5i6E+T0F3z/J2jFYlIAzGfMOw==
X-Received: by 2002:a63:284:0:b0:41d:9b60:497c with SMTP id 126-20020a630284000000b0041d9b60497cmr18960653pgc.29.1660684862179;
        Tue, 16 Aug 2022 14:21:02 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902680a00b00172913c0e44sm951851plk.28.2022.08.16.14.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:21:01 -0700 (PDT)
Date:   Tue, 16 Aug 2022 06:18:54 +0000
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
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <Yvs2qqx/sG0C3zvz@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816123701-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 12:38:52PM -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 10:56:06AM -0700, Bobby Eshleman wrote:
> > In order to support usage of qdisc on vsock traffic, this commit
> > introduces a struct net_device to vhost and virtio vsock.
> > 
> > Two new devices are created, vhost-vsock for vhost and virtio-vsock
> > for virtio. The devices are attached to the respective transports.
> > 
> > To bypass the usage of the device, the user may "down" the associated
> > network interface using common tools. For example, "ip link set dev
> > virtio-vsock down" lets vsock bypass the net_device and qdisc entirely,
> > simply using the FIFO logic of the prior implementation.
> 
> Ugh. That's quite a hack. Mark my words, at some point we will decide to
> have down mean "down".  Besides, multiple net devices with link up tend
> to confuse userspace. So might want to keep it down at all times
> even short term.
> 

I have to admit, this choice was born more of perceived necessity than
of a love for the design... but I can explain the pain points that led
to the current state, which I hope sparks some discussion.

When the state is down, dev_queue_xmit() will fail. To avoid this and
preserve the "zero-configuration" guarantee of vsock, I chose to make
transmission work regardless of device state by implementing this
"ignore up/down state" hack.

This is unfortunate because what we are really after here is just packet
scheduling, i.e., qdisc. We don't really need the rest of the
net_device, and I don't think up/down buys us anything of value. The
relationship between qdisc and net_device is so tightly knit together
though, that using qdisc without a net_device doesn't look very
practical (and maybe impossible).

Some alternative routes might be:

1) Default the state to up, and let users disable vsock by downing the
   device if they'd like. It still works out-of-the-box, but if users
   really want to disable vsock they may.

2) vsock may simply turn the device to state up when a socket is first
   used. For instance, the HCI device in net/bluetooth/hci_* uses a
   technique where the net_device is turned to up when bind() is called on
   any HCI socket (BTPROTO_HCI). It can also be turned up/down via
   ioctl().

3) Modify net_device registration to allow us to have an invisible
   device that is only known by the kernel. It may default to up and remain
   unchanged. The qdisc controls alone may be exposed to userspace,
   hopefully via netlink to still work with tc. This is not
   currently supported by register_netdevice(), but a series from 2007 was
   sent to the ML, tentatively approved in concept, but was never merged[1].

4) Currently NETDEV_UP/NETDEV_DOWN commands can't be vetoed.
   NETDEV_PRE_UP, however, is used to effectively veto NETDEV_UP
   commands[2]. We could introduce NETDEV_PRE_DOWN to support vetoing of
   NETDEV_DOWN. This would allow us to install a hook to determine if
   we actually want to allow the device to be downed.

In an ideal world, we could simply pass a set of netdev queues, a
packet, and maybe a blob of state to qdisc and let it work its
scheduling magic...

Any thoughts?

[1]: https://lore.kernel.org/netdev/20070129140958.0cf6880f@freekitty/
[2]: https://lore.kernel.org/all/20090529.220906.243061042.davem@davemloft.net/

Thanks,
Bobby
