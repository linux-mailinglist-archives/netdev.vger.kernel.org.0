Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38FF4C0591
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbiBVXxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbiBVXxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:53:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11D9431939
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 15:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645573984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EDsu5aTczzOvR3oKds5AvRCwltMBcJ/oF6EuAWc1T2c=;
        b=KhmmPFGmVpygmr980VbZh3J7sskJxt+6aFtFccI2eRvrCIq5y+GI4tAt0rnSJDInxPSHDG
        rE9oV2lpZn0gAAiK8W2OEcgOfQN+XzK0+kwMkg5E15Nz09k8nTkOONZXtPOquiLfm453oQ
        8M2UdmlUF1g5rdR97BtL0wj833QmB6g=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-HlWsnUyWMMe6t_hmVNaXWw-1; Tue, 22 Feb 2022 18:53:02 -0500
X-MC-Unique: HlWsnUyWMMe6t_hmVNaXWw-1
Received: by mail-oo1-f71.google.com with SMTP id y77-20020a4a4550000000b0031be0960299so8357205ooa.11
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 15:53:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EDsu5aTczzOvR3oKds5AvRCwltMBcJ/oF6EuAWc1T2c=;
        b=xROHk/im4qWSeNV1nr1x/6JovVqA0l9I/SLeIqwSrMHcD3b0WzxFmF8IPBlxOIYz9j
         DO+SCfsdhou1Tg7r0cJwseAWMLP5H+bK/VP48cLgCMnLlypY4yk0a5EALb3xZa2G1X5H
         4NbJ1Xe3YQsRulHcu+Xmp25YqrMRcULtwSUQ/9QVzo1L9iSdr4Cl35H185RdgUXbhGHl
         KKgwauZswbq21cdObatF8yK6EafTDkaUawdOoD/0EbWScaqGtzLHawBueXnBnIcniuwa
         xVja+R9Zl743SwaeTseNUV3IPK/hGdMJBSCHlsvOQI22xH0AeNrC5uvHc9SveJQFyXQV
         WWxQ==
X-Gm-Message-State: AOAM532MQbXXQSPwLLgSFcNYCIW/o/hzlmFRL8YMutoWMjyJmaHfG+h0
        N961qT1ApwK83QRg1kbhDc6iYDS1bjqquNH2Bvw1Hn1ocu/36WZnA5c8VcmzKmlgq030xS7Eitz
        Bi2kI1OCm/JXE0cXB
X-Received: by 2002:aca:b957:0:b0:2d4:cf0f:ce1e with SMTP id j84-20020acab957000000b002d4cf0fce1emr3145177oif.22.1645573982130;
        Tue, 22 Feb 2022 15:53:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDVey3GFc827L22t9gWEfGNj6vtWvCa3s3QmPNAs+QhKqYofPao9S/0+I8RDpFjiMHDHgHGQ==
X-Received: by 2002:aca:b957:0:b0:2d4:cf0f:ce1e with SMTP id j84-20020acab957000000b002d4cf0fce1emr3145169oif.22.1645573981895;
        Tue, 22 Feb 2022 15:53:01 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 8sm6711150ota.60.2022.02.22.15.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 15:53:01 -0800 (PST)
Date:   Tue, 22 Feb 2022 16:53:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220222165300.4a8dd044.alex.williamson@redhat.com>
In-Reply-To: <20220220095716.153757-10-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
        <20220220095716.153757-10-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Feb 2022 11:57:10 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Replace the existing region based migration protocol with an ioctl based
> protocol. The two protocols have the same general semantic behaviors, but
> the way the data is transported is changed.
> 
> This is the STOP_COPY portion of the new protocol, it defines the 5 states
> for basic stop and copy migration and the protocol to move the migration
> data in/out of the kernel.
> 
> Compared to the clarification of the v1 protocol Alex proposed:
> 
> https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen
> 
> This has a few deliberate functional differences:
> 
>  - ERROR arcs allow the device function to remain unchanged.
> 
>  - The protocol is not required to return to the original state on
>    transition failure. Instead userspace can execute an unwind back to
>    the original state, reset, or do something else without needing kernel
>    support. This simplifies the kernel design and should userspace choose
>    a policy like always reset, avoids doing useless work in the kernel
>    on error handling paths.
> 
>  - PRE_COPY is made optional, userspace must discover it before using it.
>    This reflects the fact that the majority of drivers we are aware of
>    right now will not implement PRE_COPY.
> 
>  - segmentation is not part of the data stream protocol, the receiver
>    does not have to reproduce the framing boundaries.

I'm not sure how to reconcile the statement above with:

	"The user must consider the migration data segments carried
	 over the FD to be opaque and non-fungible. During RESUMING, the
	 data segments must be written in the same order they came out
	 of the saving side FD."

This is subtly conflicting that it's not segmented, but segments must
be written in order.  We'll naturally have some segmentation due to
buffering in kernel and userspace, but I think referring to it as a
stream suggests that the user can cut and join segments arbitrarily so
long as byte order is preserved, right?  I suspect the commit log
comment is referring to the driver imposed segmentation and framing
relative to region offsets.

Maybe something like:

	"The user must consider the migration data stream carried over
	 the FD to be opaque and must preserve the byte order of the
	 stream.  The user is not required to preserve buffer
	 segmentation when writing the data stream during the RESUMING
	 operation."

This statement also gives me pause relative to Jason's comments
regarding async support:

> + * The kernel migration driver must fully transition the device to the new state
> + * value before the operation returns to the user.

The above statement certainly doesn't preclude asynchronous
availability of data on the stream FD, but it does demand that the
device state transition itself is synchronous and can cannot be
shortcut.  If the state transition itself exceeds migration SLAs, we're
in a pickle.  Thanks,

Alex

