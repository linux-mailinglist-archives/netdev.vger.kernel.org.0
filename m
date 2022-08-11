Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE8B58F8DD
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbiHKINX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiHKINX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:13:23 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB78CE1
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:13:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VLyTMzl_1660205596;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VLyTMzl_1660205596)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 16:13:17 +0800
Message-ID: <1660205553.7374692-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 0/2] virtio_net: fix for stuck when change ring size with dev down
Date:   Thu, 11 Aug 2022 16:12:33 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
 <20220811041041-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220811041041-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 04:11:22 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Aug 11, 2022 at 04:02:56PM +0800, Xuan Zhuo wrote:
> > When dev is set to DOWN state, napi has been disabled, if we modify the
> > ring size at this time, we should not call napi_disable() again, which
> > will cause stuck.
> >
> > And all operations are under the protection of rtnl_lock, so there is no
> > need to consider concurrency issues.
> >
> > PS.
> > Hi Michael, I don't know which way is more convenient for you, so I split the
> > commit into two commits, so you can fixup to my previous commit:
> >
> >     virtio_net: support tx queue resize
> > 	virtio_net: support rx queue resize
> >
> > Xuan Zhuo (2):
> >   virtio_net: fix for stuck when change rx ring size with dev down
> >   virtio_net: fix for stuck when change tx ring size with dev down
> >
> >  drivers/net/virtio_net.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
>
>
> Which patches does this fix?
> Maybe I should squash.

These two:
     virtio_net: support tx queue resize
     virtio_net: support rx queue resize

Thanks.


>
> > --
> > 2.31.0
>
