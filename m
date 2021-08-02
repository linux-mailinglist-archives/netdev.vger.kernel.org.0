Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F133DD774
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhHBNnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:43:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233850AbhHBNnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:43:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627911782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SLB5Wppyf3HhgKlJbKvVGRoxW2c24dGzTvH4Hy2jF/Y=;
        b=QfgZz4STnc02Rh9g9zzYIdOTS2t6oJLtxs62w3BniptITKMhNUZMkrC28DapJQXVno+VxG
        Jx4oZVbgFck2sq0zOTK6SknjIwjR85sSe8U4rf2OlGxhJfXIEHLM3xtlXreBIacd7nDqW5
        wUaOxQJnY4li7IJYGKhCi46pi0TrN3w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-Soe8eyiDPsSJ-GNt_dFgHg-1; Mon, 02 Aug 2021 09:43:00 -0400
X-MC-Unique: Soe8eyiDPsSJ-GNt_dFgHg-1
Received: by mail-ej1-f70.google.com with SMTP id nb40-20020a1709071ca8b02905992266c319so1251539ejc.21
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 06:43:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SLB5Wppyf3HhgKlJbKvVGRoxW2c24dGzTvH4Hy2jF/Y=;
        b=tWoLJIuSP3JyJGoTq5oFr+wMAB5m9qsWgb6KyL3Mx7ZfOTTqwUwtR9KeMJS/hDuvoW
         66ZoGskXQQeJXQn81gItEq7z/0CYcmZAbwnfZUQjeADP1EDHZ0ppGEPaa0iys4GPMVAV
         rpwDO7gFqC/cW7TchDDYmr02TZ9HVthEP5LimSIcPbWVUTYEWV/Q8KiSPSg5yGmOEfJW
         yghWJtyZUWzK6l7DNjJlIyuk7xT3sa8g+1mjUQdKBiPGWO362nMxcHzyBQZliG1H5n2R
         1nI4/c6jEkWmznbvOOmDMulvn4GvN9hcU+ld15TC8ORNxsn+ia/SFmXraiC36eMWdF7Q
         0vBw==
X-Gm-Message-State: AOAM533DZQxBdBHac7t8EqiJSFLh0VsqdqSnKL5rp7vEPA4zIO7Qetu7
        tm85TDmWiqw5LHL0aogGikDjfF5O+EMJCnPeqWfqGm7kFwplClT2JrdqR0SVhIaAkR7Shjdnkqy
        RUzDDpriKgwU8HGra
X-Received: by 2002:a17:906:b351:: with SMTP id cd17mr15955953ejb.36.1627911779587;
        Mon, 02 Aug 2021 06:42:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw42KADDqSCxnBjQagyeBWMBJYH2GNJQ+isAlFVy8Aq7jtoj+DcyNpXJj2+GajVJYGf0thj9g==
X-Received: by 2002:a17:906:b351:: with SMTP id cd17mr15955937ejb.36.1627911779411;
        Mon, 02 Aug 2021 06:42:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id oz31sm4545973ejb.54.2021.08.02.06.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:42:59 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:42:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     fuguancheng <fuguancheng@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        davem@davemloft.net, kuba@kernel.org, arseny.krasnov@kaspersky.com,
        andraprs@amazon.com, colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Add multi-cid support for vsock driver
Message-ID: <20210802134251.hgg2wnepia4cjwnv@steredhat>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210802120720.547894-1-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:07:16PM +0800, fuguancheng wrote:
>This patchset enables the user to specify additional CIDS for host and
>guest when booting up the guest machine. The guest's additional CIDS cannot
>be repeated, and can be used to communicate with the host. The user can
>also choose to specify a set of additional host cids, which can be
>used to communicate with the guest who specify them. The original
>CID(VHOST_DEFAULT_CID) is still available for host. The guest cid field is
>deleted.
>
>To ensure that multiple guest CID maps to the same vhost_vsock struct,
>a struct called vhost_vsock_ref is added.  The function of vhost_vsock_ref
>is simply used to allow multiple guest CIDS map to the
>same vhost_vsock struct.
>
>If not specified, the host and guest will now use the first CID specified
>in the array for connect operation. If the host or guest wants to use
>one specific CID, the bind operation can be performed before the connect
>operation so that the vsock_auto_bind operation can be avoided.
>
>Hypervisors such as qemu needs to be modified to use this feature. The
>required changes including at least the following:
>1. Invoke the modified ioctl call with the request code
>VHOST_VSOCK_SET_GUEST_CID. Also see struct multi_cid_message for
>arguments used in this ioctl call.
>2. Write new arguments to the emulated device config space.
>3. Modify the layout of the data written to the device config space.
>See struct virtio_vsock_config for reference.

Can you please describe a use case?

vsock was created to be zero configuration, we're complicating enough 
here, we should have a particular reason.

Also I gave a quick view and it seems to me that you change 
virtio_vsock_config, are you sure it works if one of the two peers 
doesn't support multiple CIDs?

Maybe we'd need a new feature bit, and we'd definitely need to discuss 
specification changes with virtio-comment@lists.oasis-open.org first.

How does the guest or host applications know which CIDs are assigned to 
them?

Please use the RFC tag if the patches are not in good shape.
Patches seem hard to review, please avoid adding code that is removed 
later (e.g.  multi_cid_message), and try not to break the backward 
compatibility.

Thanks,
Stefano

