Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8C66E4007
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDQGpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDQGpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:45:42 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1291BD0;
        Sun, 16 Apr 2023 23:45:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VgEk5q-_1681713935;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgEk5q-_1681713935)
          by smtp.aliyun-inc.com;
          Mon, 17 Apr 2023 14:45:36 +0800
Message-ID: <1681713856.1928573-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Date:   Mon, 17 Apr 2023 14:44:16 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 06:38:43 +0000, Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
> > Actually, I think that all you need to do is disable NETIF_F_SG,
> > and things will work, no?
>
> I think that this is not so simple, if I understand correctly, by disabling NETIF_F_SG we will never receive a chained skbs to transmit, but we still have more functionality to address, for example:
> * The TX timeouts.

Why tx timeout without frags?

> * Guest GSO/big MTU (without VIRTIO_NET_F_MRG_RXBUF?), we can't chain page size buffers anymore.


Or, we disable the GUEST_GSO, HOST_GSO......

Thanks.

>
> > Alvaro, can you try?
>
> It won't matter at the moment, we'll get TX timeout after the first tx packet, we need to address this part as well.
