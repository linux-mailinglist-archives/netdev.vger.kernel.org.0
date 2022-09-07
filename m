Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B366F5AFAFF
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 06:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIGENp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 00:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIGENo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 00:13:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C817E00B
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 21:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662524023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAjDz4sR+CkkuN65TaxyzVYEg4bR36wJx58FYQ4lykw=;
        b=VPhVXT1i2843BdHopm5pbxzFyuHlZ7JA5/Z4WjhypaKbbWmL5luVlufY19gpHj0NiKSAq4
        PfCF/PSv2spAvweabpii3d2NOJoqFv8/vvvoUVcsHEVDOinDvTIN3cXvxptQMjWKq2L+XR
        JcmMyoJiVHeQKkj0OQou0fYo9eIySMo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-V3zI5oiwPCOMMyrHIKwA3Q-1; Wed, 07 Sep 2022 00:13:41 -0400
X-MC-Unique: V3zI5oiwPCOMMyrHIKwA3Q-1
Received: by mail-pj1-f70.google.com with SMTP id ng1-20020a17090b1a8100b001f4f9f69d48so10397669pjb.4
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 21:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QAjDz4sR+CkkuN65TaxyzVYEg4bR36wJx58FYQ4lykw=;
        b=aHkUtPxurCpOEzMSokJtzkRysFvKVm8v0EN9YPl32SVywI9DBeDYDjBBf5V5P4WNUz
         +wtriLyVApK4hH8RuhoP5xNd8HGQlVT11b+beg2RUbSJC+FuBrJGIC8nYa85Dqr71eN0
         DuI/L/q4ccTktXoIMvtCciOG5PqI5whgIG+uBrMUnzKlcGJsW41Peg8fAlE80ZKM7PcY
         SnuXsnNbH7uxdZu/tODH5bYHzjGMloOJrUIP39djvzNs+fuOELAUjP0H3tT7iCxMtMSQ
         9+d9SaO/8+yuQdYV/pb4VN4QMWazHWE43jG5FTb79Ws07gl1+0d+7FQiGv6xuP1w5Jdr
         7/UA==
X-Gm-Message-State: ACgBeo3/uBTz5ygo5lkRWlj+GvozbJ0ee6jA5ikBhc83VUtu28fJVsJc
        ow7Iq8VYqv4K7n3ebLfwXQMGs+dCfoVN16EKZyncnTO2Gk1rUeU4pp7Gv6y5UJ1lpacv3jiNG+j
        nR/JeNcfKWoBTyI/r
X-Received: by 2002:a17:90b:164f:b0:1f5:4ced:ed81 with SMTP id il15-20020a17090b164f00b001f54ceded81mr27894927pjb.122.1662524020662;
        Tue, 06 Sep 2022 21:13:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6tb2znMua0rzcLRn+uEQoCxTA59Ra17knzBtFeDBJjJ2A8wstPFAsHDWkW6ISWVk/3jYZOcA==
X-Received: by 2002:a17:90b:164f:b0:1f5:4ced:ed81 with SMTP id il15-20020a17090b164f00b001f54ceded81mr27894912pjb.122.1662524020456;
        Tue, 06 Sep 2022 21:13:40 -0700 (PDT)
Received: from [10.72.13.171] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w13-20020a1709027b8d00b0016c0eb202a5sm10856284pll.225.2022.09.06.21.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 21:13:40 -0700 (PDT)
Message-ID: <f02e4c7a-3cbe-20dd-fdea-77dfcae7b67e@redhat.com>
Date:   Wed, 7 Sep 2022 12:13:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v3 0/7] In order support for virtio_ring, vhost and vsock.
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/1 13:54, Guo Zhi 写道:
> In virtio-spec 1.1, new feature bit VIRTIO_F_IN_ORDER was introduced.
> When this feature has been negotiated, virtio driver will use
> descriptors in ring order: starting from offset 0 in the table, and
> wrapping around at the end of the table. Vhost devices will always use
> descriptors in the same order in which they have been made available.
> This can reduce virtio accesses to used ring.
>
> Based on updated virtio-spec, this series realized IN_ORDER prototype in virtio
> driver and vhost. Currently IN_ORDER feature supported devices are *vhost_test*
> and *vsock* in vhost and virtio-net in QEMU. IN_ORDER feature works well
> combined with INDIRECT feature in this patch series.


As stated in the previous versions, I'd like to see performance numbers. 
We need to prove that the feature actually help for the performance.

And it would be even better if we do the in-order in this order (vhost 
side):

1) enable in-order but without batching used
2) enable in-order with batching used

Then we can see how:

1) in-order helps
2) batching helps

Thanks


>
> Virtio driver in_order support for packed vq hasn't been done in this patch
> series now.
>
> Guo Zhi (7):
>    vhost: expose used buffers
>    vhost_test: batch used buffer
>    vsock: batch buffers in tx
>    vsock: announce VIRTIO_F_IN_ORDER in vsock
>    virtio: unmask F_NEXT flag in desc_extra
>    virtio: in order support for virtio_ring
>    virtio: announce VIRTIO_F_IN_ORDER support
>
>   drivers/vhost/test.c         | 16 ++++++--
>   drivers/vhost/vhost.c        | 16 ++++++--
>   drivers/vhost/vsock.c        | 13 +++++-
>   drivers/virtio/virtio_ring.c | 79 +++++++++++++++++++++++++++++++-----
>   4 files changed, 104 insertions(+), 20 deletions(-)
>

