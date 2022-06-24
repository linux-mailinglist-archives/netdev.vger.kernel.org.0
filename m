Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E075593DA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiFXG7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFXG7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:59:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C738F69246
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656053990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+FWCkGupGlsZhDvUF+chx88Z13TTRnc4OkTdsQ7elnE=;
        b=A9REk11BMEi53EzheRJ3bUy+goh2nOXm3CmkC3xMFP36Dau8sG1/zhu4M3IFILnSPkSMK3
        nZJG8vvNXvXNygj/c/zgjirm3fb0S34Y91YstvDi35f1aZ5/6KUepCWVl9O2AIa3PKl7up
        da4YWG6iIMNkSy7tjSmUWrFKPSpAnoU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-RuTWwC66Mv61NDXhz9djdA-1; Fri, 24 Jun 2022 02:59:49 -0400
X-MC-Unique: RuTWwC66Mv61NDXhz9djdA-1
Received: by mail-ej1-f69.google.com with SMTP id qf29-20020a1709077f1d00b00722e68806c4so482276ejc.4
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+FWCkGupGlsZhDvUF+chx88Z13TTRnc4OkTdsQ7elnE=;
        b=Ccb/kUwcjonRIxbg72gPIGQMfwOvIF8Tif8evw3p3d6ZEtNg6AdQq24tFJKeBtgbc4
         my2o1O54T8nzpQ/Db2eh0qOMwRjb5GV7yshb0lTY/16lspxZbRCW5nrPzrA7WPl+3x8N
         KHtBfDPxsmGOLmb513cRDeTl93pnRLzkf6xqoghWif2bgF1zV7NJqWdNRpPC8Fn6G+sK
         QPQf+wNw5jcrl3SAabY3YSOiba/F8/havm+mPQFYD/r3LXKVZIhPOqA4T4iF0nfGKlx5
         rx7IreYso6reXw1Nf19zWjkyiwPnppEXi2gcQMJv8AbhzluaVscJNVEBmO0s7DLHR/w7
         LI8w==
X-Gm-Message-State: AJIora9sQ7GdYd1n7zjs1qLrFBJXe8kgwz45u2FW+Jpd2UIKc0gSh4cx
        1GLQu++ZNSIWQvBNQDK0oCH9KfrmEtL9Odl2OdMhohOFLctUytpMT1cJNFrEZkuqSt4+JAh7fdr
        vjh/ozoY/13LckDEE
X-Received: by 2002:a17:906:dc8f:b0:725:28d1:422d with SMTP id cs15-20020a170906dc8f00b0072528d1422dmr6755869ejc.131.1656053987942;
        Thu, 23 Jun 2022 23:59:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1te/UstSdzxfRYfD6/tSqZXRF+jwCBe0/TwLXdOIJy4AlZcp3dqgfDv8QmtvsXyUBUV1p/nQw==
X-Received: by 2002:a17:906:dc8f:b0:725:28d1:422d with SMTP id cs15-20020a170906dc8f00b0072528d1422dmr6755835ejc.131.1656053987674;
        Thu, 23 Jun 2022 23:59:47 -0700 (PDT)
Received: from redhat.com ([2.55.188.216])
        by smtp.gmail.com with ESMTPSA id ec35-20020a0564020d6300b004316f94ec4esm1262273edb.66.2022.06.23.23.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:59:46 -0700 (PDT)
Date:   Fri, 24 Jun 2022 02:59:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: Re: [PATCH v10 25/41] virtio_pci: struct virtio_pci_common_cfg add
 queue_notify_data
Message-ID: <20220624025817-mutt-send-email-mst@kernel.org>
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
 <20220624025621.128843-26-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624025621.128843-26-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 10:56:05AM +0800, Xuan Zhuo wrote:
> Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> here https://github.com/oasis-tcs/virtio-spec/issues/89
> 
> For not breaks uABI, add a new struct virtio_pci_common_cfg_notify.

What exactly is meant by not breaking uABI?
Users are supposed to be prepared for struct size to change ... no?


> Since I want to add queue_reset after queue_notify_data, I submitted
> this patch first.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  include/uapi/linux/virtio_pci.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index 3a86f36d7e3d..22bec9bd0dfc 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -166,6 +166,13 @@ struct virtio_pci_common_cfg {
>  	__le32 queue_used_hi;		/* read-write */
>  };
>  
> +struct virtio_pci_common_cfg_notify {
> +	struct virtio_pci_common_cfg cfg;
> +
> +	__le16 queue_notify_data;	/* read-write */
> +	__le16 padding;
> +};
> +
>  /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
>  struct virtio_pci_cfg_cap {
>  	struct virtio_pci_cap cap;
> -- 
> 2.31.0

