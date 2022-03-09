Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7D4D2B4B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiCIJFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiCIJFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:05:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2789C1480ED
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646816671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8eOwlkZcGQDXJozobV2VKRCePhnXpJDnIKdIuSxdQwY=;
        b=DIkKYiIYR8PSqDyTC/LifulEZk6PAGXeQJdztYPzxIX7SZ0Oa0if+HLZEa45iyfsA1Wfjd
        eljR6AUPAqdR6i46iP+Z2WhoOsu81Dwool1d6K3ryAFYcJw1SIe5A7f+65I8zLW14NxZNi
        ZkAehu5TS0LylhE4tUniAEEtiQ5ycdw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-hiEHDnjoMImmm8rOHji61Q-1; Wed, 09 Mar 2022 04:04:29 -0500
X-MC-Unique: hiEHDnjoMImmm8rOHji61Q-1
Received: by mail-pg1-f199.google.com with SMTP id t62-20020a635f41000000b0037c9ae5fb8bso950370pgb.19
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:04:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8eOwlkZcGQDXJozobV2VKRCePhnXpJDnIKdIuSxdQwY=;
        b=dJuhKGyUk7MNwtbSvqUy91KwaIsJZaSjETIoFsP1AGezhnEypVEyIKXJcDVB32ODhq
         ajLkD9X1PNSWH6qUqgqcfYCnB3otS38Biz7q58BOBT6lvERTKh2nl1wdA8j9dhK64gJH
         PuX7S8MOhVXPMFXJiCpTe+mgIT9MuOZHFNTeNdtcMpAZs2xwgv85+txETo2h50Izx6Ik
         +mua8PUBCz07dRS9zJ4b/1A16kQua6nK6aSLoT5LHJswP04gUvivvyjhzDU1f9BtYvio
         umxbFMTSCG+MFiFeZZ9SddQV8D3PKjY35VIQ7fD9vnNUS8JDeev+RjGvxe62/lS2XiY3
         qVUg==
X-Gm-Message-State: AOAM5300QEyT/+Ef+A62Lxr9bDfbhcgw1Ulwq3dqn3x19ntDaMugbA2K
        D7IbsrRCWneM7MZoP4wUMTt7+W7bSOeFNV5FHHZs3KulgBTDL/R6mFg9USgPKX+K+zAFGyvJcbA
        s+YBiE+eTumsMY3YY
X-Received: by 2002:a62:1881:0:b0:4e0:1b4c:36f8 with SMTP id 123-20020a621881000000b004e01b4c36f8mr22643977pfy.26.1646816668193;
        Wed, 09 Mar 2022 01:04:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUnje7NyiCBB5gGNjdXAqLUtIZXfE6NBoxWfMgYiTY4JFlOMy5UMt3jQvXKvTlc37/MUAVcA==
X-Received: by 2002:a62:1881:0:b0:4e0:1b4c:36f8 with SMTP id 123-20020a621881000000b004e01b4c36f8mr22643942pfy.26.1646816667945;
        Wed, 09 Mar 2022 01:04:27 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d25-20020a639919000000b00364f999aed5sm1614910pge.20.2022.03.09.01.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:04:27 -0800 (PST)
Message-ID: <f1fb522d-74ce-a642-7768-deaad76aeddc@redhat.com>
Date:   Wed, 9 Mar 2022 17:04:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 21/26] virtio: add helper virtio_find_vqs_ctx_size()
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-22-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-22-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午8:35, Xuan Zhuo 写道:
> Introduce helper virtio_find_vqs_ctx_size() to call find_vqs and specify
> the maximum size of each vq ring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   include/linux/virtio_config.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 5157524d8036..921d8610db0c 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -233,6 +233,18 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
>   				      desc, NULL);
>   }
>   
> +static inline
> +int virtio_find_vqs_ctx_size(struct virtio_device *vdev, u32 nvqs,
> +				 struct virtqueue *vqs[],
> +				 vq_callback_t *callbacks[],
> +				 const char * const names[],
> +				 const bool *ctx, struct irq_affinity *desc,
> +				 u32 sizes[])
> +{
> +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> +				      desc, sizes);
> +}


Do we need to convert all the open coded direct call to find_vqs() other 
than net?

Thanks


> +
>   /**
>    * virtio_reset_vq - reset a queue individually
>    * @vq: the virtqueue

