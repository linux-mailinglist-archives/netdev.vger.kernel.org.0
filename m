Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A55E4ADD
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 14:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504429AbfJYMQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 08:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504406AbfJYMQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 08:16:35 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ACBC7C057F2C
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 12:16:34 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id x186so1937295qke.13
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 05:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lDtOQyoiNI8iBD+BJV41nuz3/0N81N8+l8LN/u4t5zU=;
        b=nsxlDp6sTOhG674pX8Brhj68dO96q6Z4Q+N3lBs07HYHTfTugGUHbsv4GvauvfRnOJ
         zG/dN4oA1Vj31eqUx8y2dC0N2RGTyKpMT78RHIauEXYzObPRPSw8hV9JK4DcNm9q0/lC
         lueXwiGo4Yph8MG6pdPCqSAjrq+Mz7ZD/GL8wQNFo3aO8T4Jp8/HnHdxY52bczr1vnyb
         bSGyJQxSj/EX44BN5Dcx9p/MPhqULEUe7LcuPF2Aq7DiLu+bmBzy2LMNXlWzjW3Unp/8
         ejRSrynUjjWtkvYO9RHikAmmqm2rqesW/k+41xP08NYfGxCOfI0p9RtnAG87HIOQQzoI
         XyfQ==
X-Gm-Message-State: APjAAAWe82+RWj949ultrLC8t7kOWO15o5mcjUHq3vXHuw8UxPH1lopO
        wIkTNJsuqLD92upTPqREjr8cHjc8fHCH5KsrSTpWDatQNa+WFFU5TCGd8aS7I/bDqX2Ip5jiz/B
        /Z8iN9JpGLn8kSl3R
X-Received: by 2002:ac8:1109:: with SMTP id c9mr2661814qtj.10.1572005794008;
        Fri, 25 Oct 2019 05:16:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwK3+y0bW2iZzlHnWckL9qOZZ46Wovnc/341JCURY96Ut9tQ0zB6Sv5xfgv85VGvBF7MyqL9g==
X-Received: by 2002:ac8:1109:: with SMTP id c9mr2661774qtj.10.1572005793671;
        Fri, 25 Oct 2019 05:16:33 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id s21sm1555600qtc.12.2019.10.25.05.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 05:16:32 -0700 (PDT)
Date:   Fri, 25 Oct 2019 08:16:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
Message-ID: <20191025080143-mutt-send-email-mst@kernel.org>
References: <20191023070747.GA30533@___>
 <106834b5-dae5-82b2-0f97-16951709d075@redhat.com>
 <20191023101135.GA6367@___>
 <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
 <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
 <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 05:54:55PM +0800, Jason Wang wrote:
> 
> On 2019/10/24 下午6:42, Jason Wang wrote:
> > 
> > Yes.
> > 
> > 
> > >   And we should try to avoid
> > > putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
> > > guests having the chance to bypass the host (e.g. QEMU) to
> > > setup the backend accelerator directly.
> > 
> > 
> > That's really good point.  So when "vhost" type is created, parent
> > should assume addr of ctrl_vq is hva.
> > 
> > Thanks
> 
> 
> This works for vhost but not virtio since there's no way for virtio kernel
> driver to differ ctrl_vq with the rest when doing DMA map. One possible
> solution is to provide DMA domain isolation between virtqueues. Then ctrl vq
> can use its dedicated DMA domain for the work.
> 
> Anyway, this could be done in the future. We can have a version first that
> doesn't support ctrl_vq.
> 
> Thanks

Well no ctrl_vq implies either no offloads, or no XDP (since XDP needs
to disable offloads dynamically).

        if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
            && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
                virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
                virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
                virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
                virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
                NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
                return -EOPNOTSUPP;
        }

neither is very attractive.

So yes ok just for development but we do need to figure out how it will
work down the road in production.

So really this specific virtio net device does not support control vq,
instead it supports a different transport specific way to send commands
to device.

Some kind of extension to the transport? Ideas?


-- 
MST
