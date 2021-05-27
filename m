Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5824F392536
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhE0DIC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 May 2021 23:08:02 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2310 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbhE0DIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 23:08:01 -0400
Received: from dggeme709-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FrCJw4FxQz19V3l;
        Thu, 27 May 2021 11:01:52 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeme709-chm.china.huawei.com (10.1.199.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 27 May 2021 11:06:26 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2176.012;
 Thu, 27 May 2021 11:06:26 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        dingxiaoxiong <dingxiaoxiong@huawei.com>
Subject: RE: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Thread-Topic: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Thread-Index: AQHXUiPuxqZ0kftZNUuaGRJYw289Yar18/EAgACvT/A=
Date:   Thu, 27 May 2021 03:06:26 +0000
Message-ID: <3540ce31bb974d89bc5d2a612c2675a4@huawei.com>
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
 <20210526172808.485ff268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526172808.485ff268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.60]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Thursday, May 27, 2021 8:28 AM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; mst@redhat.com;
> jasowang@redhat.com; virtualization@lists.linux-foundation.org;
> dingxiaoxiong <dingxiaoxiong@huawei.com>
> Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue is
> broken
> 
> On Wed, 26 May 2021 19:39:51 +0800 wangyunjian wrote:
> > +	for (i = 0; i < vi->max_queue_pairs; i++) {
> > +		if (virtqueue_is_broken(vi->rq[i].vq) ||
> virtqueue_is_broken(vi->sq[i].vq)) {
> > +			netif_carrier_off(netdev);
> > +			netif_tx_stop_all_queues(netdev);
> > +			vi->broken = true;
> 
> Can't comment on the virtio specifics but the lack of locking between this and
> the code in virtnet_config_changed_work() seems surprising.

Thanks for your suggestion, will fix it in next version.

Yunjian
