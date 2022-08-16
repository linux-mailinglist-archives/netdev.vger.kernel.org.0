Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5D4596518
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbiHPWBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237279AbiHPWBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:01:22 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F4D8F951;
        Tue, 16 Aug 2022 15:01:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p125so10495847pfp.2;
        Tue, 16 Aug 2022 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=aDqAZFANkrfjbb5xBv7SEPO2DhDRbGJc0EKtkzDbDQs=;
        b=LYF5Hh1y2onyd8W8fQSoLlPYsE5y1JK91YpRleHxvVj9hm/9MY3oF8fgabM0B9+1VM
         fUBY+DBPccaCMWczC8J8jQHjAB6K87UAY/cVdF9A2mq3+6RbrFbrqJ1czPtqxm0K4jhi
         YPIjc7gQMWaR2uLbcAY4Wba0RJDd5SUUVMjyNRydqIWwrxTbY2XYrdrjBICEK/QeqC15
         djx/j8oQIxSH1RJOa1oTTeOmHFdaM+EmheVI3SIC4fA0zuzGBt1ipQi0idQ/W6oluH2M
         7HDGN8wEbGscPO1N789oUeJLmRflzTgNepDRBayUYu0U3ycVERSSKVbNF2Cf+cn7nN4a
         6rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=aDqAZFANkrfjbb5xBv7SEPO2DhDRbGJc0EKtkzDbDQs=;
        b=rjElzk0+aAcBpvKXf/MAOxLGPQEgOyJ+PLe3yQipZi2AAoGWoUjfX90OSOK534+oa/
         HyUwX06GbrEDGVXmmJKGOgnGFjVNiAwfRASV39Zcx4uZ+oQPePXwRjzLlKWzw1nkUHmv
         s3U+Kbg4RnDtAWoE7rwglxY4wXMrTsDVocXsJLZdbXCVkegA76hJvOE3JkRbzAS4tQZ7
         6m/Bg9CTVFq7OqscEWUbenQqlmK3vhPKFozClU7hklEplVGLyrHVpJUdfjmzq2kodlTp
         sSAfnMedKxH6TLYOZlJJA2kTcqe7RhHYKjphBQovcu7nY07abAWTd7EdTrP9PQ6uepWi
         LTZg==
X-Gm-Message-State: ACgBeo2Z5uczlfxir5OQyaoVwN8qF8tZOieU3Kynj9G7yjEYmBH4qwr0
        GNXMLxNcVXQJVcZg/HRy7ezfBBZJjnWnVhB4WIM=
X-Google-Smtp-Source: AA6agR6x6vy+y2PHqORcgSrXhqqwJpsTjczWMF1JON/I0nEYSqHNSw88p+Q6C+XgrH2niLMCZ7sPow==
X-Received: by 2002:a63:e016:0:b0:427:e7f2:32b3 with SMTP id e22-20020a63e016000000b00427e7f232b3mr12469257pgh.194.1660687279851;
        Tue, 16 Aug 2022 15:01:19 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id f12-20020aa7968c000000b0052d90521d02sm8914276pfk.126.2022.08.16.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 15:01:19 -0700 (PDT)
Date:   Tue, 16 Aug 2022 07:02:33 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <YvtAktdB09tM0Ykr@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org>
 <20220816110717.5422e976@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816110717.5422e976@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:07:17AM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 12:38:52 -0400 Michael S. Tsirkin wrote:
> > On Mon, Aug 15, 2022 at 10:56:06AM -0700, Bobby Eshleman wrote:
> > > In order to support usage of qdisc on vsock traffic, this commit
> > > introduces a struct net_device to vhost and virtio vsock.
> > > 
> > > Two new devices are created, vhost-vsock for vhost and virtio-vsock
> > > for virtio. The devices are attached to the respective transports.
> > > 
> > > To bypass the usage of the device, the user may "down" the associated
> > > network interface using common tools. For example, "ip link set dev
> > > virtio-vsock down" lets vsock bypass the net_device and qdisc entirely,
> > > simply using the FIFO logic of the prior implementation.  
> > 
> > Ugh. That's quite a hack. Mark my words, at some point we will decide to
> > have down mean "down".  Besides, multiple net devices with link up tend
> > to confuse userspace. So might want to keep it down at all times
> > even short term.
> 
> Agreed!
> 
> From a cursory look (and Documentation/ would be nice..) it feels
> very wrong to me. Do you know of any uses of a netdev which would 
> be semantically similar to what you're doing? Treating netdevs as
> buildings blocks for arbitrary message passing solutions is something 
> I dislike quite strongly.

The big difference between vsock and "arbitrary message passing" is that
vsock is actually constrained by the virtio device that backs it (made
up of virtqueues and the underlying protocol). That virtqueue pair is
acting like the queues on a physical NIC, so it actually makes sense to
manage the queuing of vsock's device like we would manage the queueing
of a real device.

Still, I concede that ignoring the netdev state is a probably bad idea.

That said, I also think that using packet scheduling in vsock is a good
idea, and that ideally we can reuse Linux's already robust library of
packet scheduling algorithms by introducing qdisc somehow.

> 
> Could you recommend where I can learn more about vsocks?

I think the spec is probably the best place to start[1].

[1]: https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html

Best,
Bobby
