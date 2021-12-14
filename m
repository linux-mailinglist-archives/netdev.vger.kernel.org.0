Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80AE473C4C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhLNFGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhLNFGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639458375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBHzgpNG5qwGxFpFqo+UbXajiFs/3vLUugDY970MpYI=;
        b=jGVfLSmCplXBYA0IWKNp84CeWtsdhHWdq2I4a+jaAv0ZpxCM2C5HHWgNJ+iPhutaYU9eA0
        dT1PjOsJmZ0wPUl7XzcPtNiO3J5FzBTSKhuNOUtx9k/b9rHh7eFudfWO7HQEBn3WM05SG9
        kROKmZ6a8oDAhdZbAwzxvZ1KZM+DDsM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-wUnN6fzfM_Ol1MORsO7cZA-1; Tue, 14 Dec 2021 00:06:13 -0500
X-MC-Unique: wUnN6fzfM_Ol1MORsO7cZA-1
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso12626062wms.4
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 21:06:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OBHzgpNG5qwGxFpFqo+UbXajiFs/3vLUugDY970MpYI=;
        b=zptmZ+D8xT+tkSukVZ7HKrIjCLO3HOuFlYCXvJpFhLQShzuMoOfn2GxjfRq5IWjMv7
         qp7RqPu8s5s9YnTdZBr31pSJj1LhqMtq/TpBUOxB1wbBY10yDfz3gC4EDoZdazNUf/B3
         ffbDB9rAOZEvS/zLGziwfZYiEERZoyZpKFPdHhlDTbKuYOa+oERKWx1RziAOFM/iS0d1
         K5wG498Ch7TDmlbBDq8mOrflWlZ+nT23NeZZW+1SwAun2WluOSBlL8TAyWur6PLhBBTo
         ojfVBZ32e+hE0PbQSwStqrwDYIF2znyPbUNPCJKHR94vbUI/udLpRDp9f7eblEU8rjCi
         c5zA==
X-Gm-Message-State: AOAM531nEhZ1FmgFnb7CMIRfHmH+zg0P7Xw8Inm9sZCSY2f5qDAoFXig
        qoTDxPcuTsqPN2R8jl4c3h3+JXMxOo5oa7dWwyfdhONuIexzJWn9j7mN6GAtiYIys/8i66JCBxI
        jDYUQ/wppI6/SqrLW
X-Received: by 2002:a5d:5144:: with SMTP id u4mr3227108wrt.91.1639458371969;
        Mon, 13 Dec 2021 21:06:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwk+n+lFy9zCHYPdTwwmcgN7nodpnWuaVSWcgWLaxCR9R8nw1xYnLu3T2KMPKGtr/XXwrwMVw==
X-Received: by 2002:a5d:5144:: with SMTP id u4mr3227076wrt.91.1639458371678;
        Mon, 13 Dec 2021 21:06:11 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:207d:b931:2ce5:ef76:2d17:5466])
        by smtp.gmail.com with ESMTPSA id s18sm948675wrb.91.2021.12.13.21.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:06:10 -0800 (PST)
Date:   Tue, 14 Dec 2021 00:06:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Message-ID: <20211214000245-mutt-send-email-mst@kernel.org>
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
> 
> 
> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
> > On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> > > Sorry for reviving this ancient thread. I was kinda lost for the conclusion
> > > it ended up with. I have the following questions,
> > > 
> > > 1. legacy guest support: from the past conversations it doesn't seem the
> > > support will be completely dropped from the table, is my understanding
> > > correct? Actually we're interested in supporting virtio v0.95 guest for x86,
> > > which is backed by the spec at
> > > https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
> > > if there's request/need to support wilder legacy virtio versions earlier
> > > beyond.
> > I personally feel it's less work to add in kernel than try to
> > work around it in userspace. Jason feels differently.
> > Maybe post the patches and this will prove to Jason it's not
> > too terrible?
> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
> layout level and is limited to x86 only, there should be easy way out.

Note a subtle difference: what matters is that guest, not host is x86.
Matters for emulators which might reorder memory accesses.
I guess this enforcement belongs in QEMU then?

> I
> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
> 0.95 support, it seems all the ingredient had been there already dated back
> to the DPDK days. The only major thing limiting is in the vDPA software that
> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
> a few DMA setup ops, which is virtio 1.0 only.
> 
> > 
> > > 2. suppose some form of legacy guest support needs to be there, how do we
> > > deal with the bogus assumption below in vdpa_get_config() in the short term?
> > > It looks one of the intuitive fix is to move the vdpa_set_features call out
> > > of vdpa_get_config() to vdpa_set_config().
> > > 
> > >          /*
> > >           * Config accesses aren't supposed to trigger before features are
> > > set.
> > >           * If it does happen we assume a legacy guest.
> > >           */
> > >          if (!vdev->features_valid)
> > >                  vdpa_set_features(vdev, 0);
> > >          ops->get_config(vdev, offset, buf, len);
> > > 
> > > I can post a patch to fix 2) if there's consensus already reached.
> > > 
> > > Thanks,
> > > -Siwei
> > I'm not sure how important it is to change that.
> > In any case it only affects transitional devices, right?
> > Legacy only should not care ...
> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
> modern one in a transitional device model rather than being legacy only.
> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
> guests without having to reconfigure. Or are you suggesting limit to legacy
> only at the time of vdpa creation would simplify the implementation a lot?
> 
> Thanks,
> -Siwei


I don't know for sure. Take a look at the work Halil was doing
to try and support transitional devices with BE guests.


> > 
> > > On 3/2/2021 2:53 AM, Jason Wang wrote:
> > > > On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
> > > > > On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > > > > > On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
> > > > > > > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > > > > > > Detecting it isn't enough though, we will need a new ioctl to notify
> > > > > > > > > the kernel that it's a legacy guest. Ugh :(
> > > > > > > > Well, although I think adding an ioctl is doable, may I
> > > > > > > > know what the use
> > > > > > > > case there will be for kernel to leverage such info
> > > > > > > > directly? Is there a
> > > > > > > > case QEMU can't do with dedicate ioctls later if there's indeed
> > > > > > > > differentiation (legacy v.s. modern) needed?
> > > > > > > BTW a good API could be
> > > > > > > 
> > > > > > > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > 
> > > > > > > we did it per vring but maybe that was a mistake ...
> > > > > > Actually, I wonder whether it's good time to just not support
> > > > > > legacy driver
> > > > > > for vDPA. Consider:
> > > > > > 
> > > > > > 1) It's definition is no-normative
> > > > > > 2) A lot of budren of codes
> > > > > > 
> > > > > > So qemu can still present the legacy device since the config
> > > > > > space or other
> > > > > > stuffs that is presented by vhost-vDPA is not expected to be
> > > > > > accessed by
> > > > > > guest directly. Qemu can do the endian conversion when necessary
> > > > > > in this
> > > > > > case?
> > > > > > 
> > > > > > Thanks
> > > > > > 
> > > > > Overall I would be fine with this approach but we need to avoid breaking
> > > > > working userspace, qemu releases with vdpa support are out there and
> > > > > seem to work for people. Any changes need to take that into account
> > > > > and document compatibility concerns.
> > > > 
> > > > Agree, let me check.
> > > > 
> > > > 
> > > > >    I note that any hardware
> > > > > implementation is already broken for legacy except on platforms with
> > > > > strong ordering which might be helpful in reducing the scope.
> > > > 
> > > > Yes.
> > > > 
> > > > Thanks
> > > > 
> > > > 
> > > > > 

