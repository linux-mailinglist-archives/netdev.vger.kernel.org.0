Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843E93CF47D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhGTFsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 01:48:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230328AbhGTFr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 01:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626762516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNH6zsjCfAXwZqQxKujTcuZRpVuHUvtcZf7vWJW9dkY=;
        b=EDarrPon84Q1/4jDv0lmhgPyyx870dOW+1mYe3Xmo/SxgDw1Exc122m2b7kyxTJ1q/30NE
        zeQy/tqh4Ydhvqew6jfuNVhokN3ZrIY8c/Gq5xCpwdnAaRksAkzkvJhqXCuMNHMAxrLFma
        /Mth/Ko3FQ3UORyVk06Nhsd5S/2Ie+c=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-vu544Dx4PJ-YwkLX8lxtNw-1; Tue, 20 Jul 2021 02:28:34 -0400
X-MC-Unique: vu544Dx4PJ-YwkLX8lxtNw-1
Received: by mail-pl1-f200.google.com with SMTP id x15-20020a170902e04fb02900f5295925dbso4303448plx.9
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 23:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KNH6zsjCfAXwZqQxKujTcuZRpVuHUvtcZf7vWJW9dkY=;
        b=rFSTt6uPZY/SDazAP3fGjqghyvrChdRdta0Pmq2gxILgHVSn1KDUjaHYpdIYzKBGpz
         dWd3ilYMqYFB4k0drux3QbxmG3TQM5cFO+6DpueFWvkxClIMME4pnxufa/6d2Brlhj1S
         sTQEnLvn7BHLPiuOECaPMCPKRTNljznBqUH7GvGRJVGjl9IYB/E1KqptSkBPhFQMrO3K
         u9QMVrAjxoQINIWBr9oIsRdNATsDIOGmJVTPnUC65qR3hEhR3lB4TWvRHOuIBRKmeC0C
         xztiOYGn5L8cGDkE9IaHtOMuKR8PMO6DX4bA4XHznMZ4jvivecnVPEG3URl4eCzkZzX1
         HjuA==
X-Gm-Message-State: AOAM533bvchJUlfAXeIbiUdGimJWyp+P1eXRYt7rbSXMps8zD6fTS/4J
        I7L6cp0XJ/LO8SXzOBBTqnDTtdlDOnp9OOb1gMmb0LIL8DmhyWoF63optwDNEyY2HHDLOZe9yB2
        ZCslO1ROf3Epn5Y43
X-Received: by 2002:a63:ee0a:: with SMTP id e10mr29264287pgi.385.1626762513517;
        Mon, 19 Jul 2021 23:28:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqXIhBsHE4OMO19DsmYnji2nMu1Erm/LjLpnHHVNBKtlqCmktcLZd6Ck+YaPnj7kdpYu9RDQ==
X-Received: by 2002:a63:ee0a:: with SMTP id e10mr29264267pgi.385.1626762513229;
        Mon, 19 Jul 2021 23:28:33 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b15sm8946536pfi.49.2021.07.19.23.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 23:28:32 -0700 (PDT)
Subject: Re: [PATCH] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Xianting Tian <tianxianting.txt@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
References: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <73d486dd-17d9-a3b3-c1e9-39a1138c0084@redhat.com>
Date:   Tue, 20 Jul 2021 14:28:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


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


It's better to do this after the mutex_lock().

Thanks


>   
>   	return 0;

