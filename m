Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F946CFB30
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjC3GEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC3GEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:04:52 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4049E1BD6;
        Wed, 29 Mar 2023 23:04:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VezShXN_1680156287;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VezShXN_1680156287)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 14:04:47 +0800
Message-ID: <1680156097.4586647-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 02/16] virtio_net: move struct to header file
Date:   Thu, 30 Mar 2023 14:01:37 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
 <20230328092847.91643-3-xuanzhuo@linux.alibaba.com>
 <20230329211826.0657f947@kernel.org>
In-Reply-To: <20230329211826.0657f947@kernel.org>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 21:18:26 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 28 Mar 2023 17:28:33 +0800 Xuan Zhuo wrote:
> > diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
> > new file mode 100644
> > index 000000000000..778a0e6af869
> > --- /dev/null
> > +++ b/drivers/net/virtio/virtnet.h
> > @@ -0,0 +1,184 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef __VIRTNET_H__
> > +#define __VIRTNET_H__
> > +
> > +#include <linux/ethtool.h>
> > +#include <linux/average.h>
>
> I don't want to nit pick too much but this header is missing a lot of
> includes / forward declarations. At the same time on a quick look I
> didn't spot anything that'd require linux/ethtool.h

Indeed, I only considered the compilation may pass before, and I didn't think
about it from the perspective of an independent header file.

Will fix.

>
> > diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
> > index e2560b6f7980..5ca354e29483 100644
> > --- a/drivers/net/virtio/virtnet.c
> > +++ b/drivers/net/virtio/virtnet.c
> > @@ -6,7 +6,6 @@
> >  //#define DEBUG
> >  #include <linux/netdevice.h>
> >  #include <linux/etherdevice.h>
> > -#include <linux/ethtool.h>
> >  #include <linux/module.h>
> >  #include <linux/virtio.h>
> >  #include <linux/virtio_net.h>
> > @@ -16,13 +15,14 @@
> >  #include <linux/if_vlan.h>
> >  #include <linux/slab.h>
> >  #include <linux/cpu.h>
> > -#include <linux/average.h>
> >  #include <linux/filter.h>
> >  #include <linux/kernel.h>
> >  #include <net/route.h>
> >  #include <net/xdp.h>
> >  #include <net/net_failover.h>
>
> And you shouldn't remove includes if the code needs them just because
> they get pulled in indirectly.


Will fix.

Thanks.
