Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047EF3CF2D7
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 05:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347836AbhGTDEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 23:04:49 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:48531 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237423AbhGTDEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 23:04:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UgNuUBs_1626752688;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgNuUBs_1626752688)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 11:44:48 +0800
Subject: Re: [PATCH] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Xianting Tian <tianxianting.txt@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
From:   tianxianting <xianting.tian@linux.alibaba.com>
Message-ID: <3228d3f9-90c5-1033-97f7-642a261773a5@linux.alibaba.com>
Date:   Tue, 20 Jul 2021 11:44:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please help review this one, thanks

ignore the one https://lkml.org/lkml/2021/7/19/3279 
<https://lkml.org/lkml/2021/7/19/3279>, which contains wrong mail address.

ÔÚ 2021/7/20 ÉÏÎç11:42, Xianting Tian Ð´µÀ:
> From: Xianting Tian <xianting.tian@linux.alibaba.com>
>
> Add the missed virtio_device_ready() to set vsock frontend ready.
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>   net/vmw_vsock/virtio_transport.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e0c2c992a..eb4c607c4 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -637,6 +637,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>   	vdev->priv = vsock;
>   	rcu_assign_pointer(the_virtio_vsock, vsock);
>   
> +	virtio_device_ready(vdev);
> +
>   	mutex_unlock(&the_virtio_vsock_mutex);
>   
>   	return 0;
