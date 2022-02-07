Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3394AB3B9
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 06:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiBGFrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350654AbiBGDlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 22:41:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D80E4C061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 19:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644205274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mPACxARX/I5xiz/m71QMlfbaJbgGVVXIBRuTffqi1uU=;
        b=eNZRdYx+FhQuo9eI4n9rPfgS78i6skF+jAhjJ6QaPx4p/ltYy+X2KooJ5iBbl6zplHlyCP
        RVJ1GlPEM+bsIyei7CjiCvgTeok97m6LvJc88iv3NtOCLqk0Wne9wDfxEgT66IDRZUO2eJ
        Ul7XaGqKc9ubV3y/ht/qj4JA4Qhi8kk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-dxTEToTRMvSANgoSS8Q34g-1; Sun, 06 Feb 2022 22:41:13 -0500
X-MC-Unique: dxTEToTRMvSANgoSS8Q34g-1
Received: by mail-pj1-f71.google.com with SMTP id e1-20020a17090ada0100b001b83a55e809so9281475pjv.7
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 19:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mPACxARX/I5xiz/m71QMlfbaJbgGVVXIBRuTffqi1uU=;
        b=ftRuanrTmAz4KQVtUngHzMJ6/BxqAiF89xsn2Pmoo1Xpppcf7NOf+5E/x333YswKSX
         ZMTUyv+yuWJKAuVVh7v9VowKK+mXr0a/kI9+W3oPeh33CcdEIKtQSnG636bfXktyhOfO
         QyyYY0aCzk1rwRI2sz0G+lPPG3PslHdMuovzFCwXkvretOQhSIC4ckyZmQMmXJ+KmcKC
         WhG+r7q/pU3HDXpydU+hPV3ZG80WhJFCTTj63B7eAlFjcphylRXeixGoCd0xC17q0mfP
         UAk0Nw927ax3bMwyWz2nRs01/gfN8XBmhfepMzuL6WiCAAgkC71KhBjQjdCmEoqS3sIX
         sM/w==
X-Gm-Message-State: AOAM531Q98CxdoF4lpwFV7bvF8xq1TRt0KRy/hCk+pKmkH4hyLP/aljl
        T7YBl1SGLoYayEjsHbofKUcBEdYBh7UuVZMPwYDgoHlK4JIOnuysbakQAnOzq36lRMpU2apIg+4
        cmUQNNiJQ6npPZIXt
X-Received: by 2002:a62:6385:: with SMTP id x127mr13677044pfb.10.1644205272643;
        Sun, 06 Feb 2022 19:41:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOe3ubwUCsl51ytoYFQpcbOFgshGwu+VsOh9kV8c5aIWL/MikcAmaOlMl0lJQNMK56KLKFvA==
X-Received: by 2002:a62:6385:: with SMTP id x127mr13677031pfb.10.1644205272410;
        Sun, 06 Feb 2022 19:41:12 -0800 (PST)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a12sm5892101pfv.18.2022.02.06.19.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 19:41:11 -0800 (PST)
Message-ID: <28013a95-4ce4-7859-9ca1-d836265e8792@redhat.com>
Date:   Mon, 7 Feb 2022 11:41:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 01/17] virtio_pci: struct virtio_pci_common_cfg add
 queue_notify_data
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <20220126073533.44994-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220126073533.44994-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/26 下午3:35, Xuan Zhuo 写道:
> Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> here https://github.com/oasis-tcs/virtio-spec/issues/89
>
> Since I want to add queue_reset after it, I submitted this patch first.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   include/uapi/linux/virtio_pci.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index 3a86f36d7e3d..492c89f56c6a 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -164,6 +164,7 @@ struct virtio_pci_common_cfg {
>   	__le32 queue_avail_hi;		/* read-write */
>   	__le32 queue_used_lo;		/* read-write */
>   	__le32 queue_used_hi;		/* read-write */
> +	__le16 queue_notify_data;	/* read-write */
>   };


So I had the same concern as previous version.

This breaks uABI where program may try to use sizeof(struct 
virtio_pci_common_cfg).

We probably need a container structure here.

THanks


>   
>   /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */

