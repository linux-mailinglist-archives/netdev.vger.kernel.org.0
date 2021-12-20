Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B5247B60F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 00:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhLTXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 18:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230038AbhLTXGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 18:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640041574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NEHMiAq9vdS3tFIazyfylWAmTGiUgQc497at2F3jzF4=;
        b=VaIXH6oABA+L7XXw6I962OGXLF7h5oIRcPdHAVQnQM1eV9Ppw4t9gcaAv4eEwOk7WrT3Vv
        9MKu13pIMXGrUoeHrfGpNt57CN9HsYEhumpw9l+IWl2zsjoAZBM1Jo44HWsBnWIBgGJSRW
        g5+a+L5/PM5iYI4Htnxcjza3gxvA86E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-9GE3GIbFN4iTMn9qA0K5wA-1; Mon, 20 Dec 2021 18:06:13 -0500
X-MC-Unique: 9GE3GIbFN4iTMn9qA0K5wA-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso8762800edt.20
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 15:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NEHMiAq9vdS3tFIazyfylWAmTGiUgQc497at2F3jzF4=;
        b=2B4Xiu4LBTvq2Oy3E4yUn7xW3e2f8kyEEWZx2DnlfXD8/uJ/eW/XlESOWPGDAhxPCZ
         QWNMYC59m8b8cdECVLqp6H5Dy5J2h63rUb1hHmyj89ENm2UE5m0oNBGAEi5TM5Cf0DGP
         Op1myQR5P79U7wsXSyanxzAnk6Vr/fILfh677Mfdr7GSpSBe4d8+69d8MvigU7xw8D1S
         8EAH+/ekJTZBy7kFQBWZpZo9+A2ybbB3tfO59IwZS5jyfLZfTcQR7OTh5e8yGW272k8E
         zEE6+DV6nVQFgGWqM7UFLeiYDH3iiuddAlqi657t4ZepxEWv/lGIPUp7ujjN7FkW/Dwp
         +tTg==
X-Gm-Message-State: AOAM533fLLyujzbioX5JubjigmN2pWHwb43oz8zlweXNgCZu+vm30SBX
        KZGaIqWePBWf+qRiFKEjDzo910y2RosXwvi4/wo91mvd/QUZSJenTE2hWr3wQxBMuzA7a10Goqf
        9g8iavr/QghtWB3YQ
X-Received: by 2002:a17:906:38c9:: with SMTP id r9mr323562ejd.69.1640041572425;
        Mon, 20 Dec 2021 15:06:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLuJeGKRXUMTefzTaE9Yvi1xD+us101vreqECr8RvPdGCe6ckZLAovFn1k026XGNKf41H2Tg==
X-Received: by 2002:a17:906:38c9:: with SMTP id r9mr323553ejd.69.1640041572287;
        Mon, 20 Dec 2021 15:06:12 -0800 (PST)
Received: from redhat.com ([2.55.141.192])
        by smtp.gmail.com with ESMTPSA id e4sm6045615ejs.13.2021.12.20.15.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 15:06:11 -0800 (PST)
Date:   Mon, 20 Dec 2021 18:06:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Message-ID: <20211220180507-mutt-send-email-mst@kernel.org>
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
 <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
 <20211218170602-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548189EBA8346A960A0A409FDC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20211220070136-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1BA270A1992AC0E52A8DC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <8df990f1-7067-b336-f97a-85fe98882fb9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8df990f1-7067-b336-f97a-85fe98882fb9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 02:11:44PM -0700, David Ahern wrote:
> On 12/20/21 12:11 PM, Parav Pandit wrote:
> >> After consideration, this future proofing seems like a good thing to have.
> > Ok. I will first get kernel change merged, after which will send v3 for iproute2.
> 
> this set has been committed; not sure what happened to the notification
> from patchworks bot.

OK in that case it's too late, so maybe let's worry about supporting
extensions later when we actually need them, in particular when linux
better supports mtu > 64k.

-- 
MST

