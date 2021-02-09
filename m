Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F74314A66
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBIIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:36:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhBIIgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:36:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612859691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fe4ZuBAI8UR2Grpm24wf3/ZXc6K9G/enuqlpW1OLE/I=;
        b=TcnhKw+ZQ2WM3CR0zjqHChrC/tJ0IYcIzVgttsTNSFh90NsOJ9BNv/MuNOw/xbWBKJ/aEk
        /f14Gm/LkGDydu502i0HlMYi0aaPuqqDj+L7MJRELa4bPins1J71CchYPM/LlAak5qopH4
        p4qJYls+RmQwp8ZX62bd5uqGQI+6YiI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-OVnBcLvVNU2qUjWm-9nHlA-1; Tue, 09 Feb 2021 03:34:49 -0500
X-MC-Unique: OVnBcLvVNU2qUjWm-9nHlA-1
Received: by mail-ej1-f71.google.com with SMTP id yh28so14956001ejb.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fe4ZuBAI8UR2Grpm24wf3/ZXc6K9G/enuqlpW1OLE/I=;
        b=ZDViBqMjUmzWvswIPi6IfZBHvwW7e/9rI6kVImlOESvs70NsiGq000Ag9vk5WQhHK2
         dhjZLg1bm5P29tN/ij9avw62qmFzr+hR9yRUyC6jMB/DtNWamjSRKS42dzaswBTFtkAU
         J8Bblm2Dx6QehfTXJXhEM+n+m5TqXq7W0wvyEkoncbPusGCUMB45/mVB1az4ht4L0aG8
         tWmydLDegRgjV9Sep644y8ONT+n2MYpK+O/VyeAS37sRl2E6kWc1SV1C1a2IZGGaD5Vp
         w5FDqOcD1vUyei7OfUzG0MZXXasSqbRwO65wqMfktYFCn9tVqW6XfxK97kSjvNs9mo+m
         MG8A==
X-Gm-Message-State: AOAM53055My9VHnzJ6eQaFDnP0KR7jST3O1ANftxl5h1R0Ah+BqyHv2h
        kIYS1oI7Yw/vGL4njPQlbp4dqSTPy22vM7XelllP0LyB5dv7WFD7XpmWcy/tlWmqB2CsvQq/FhJ
        j7f1KSTZNATca9fWD
X-Received: by 2002:a05:6402:3514:: with SMTP id b20mr21125071edd.100.1612859688148;
        Tue, 09 Feb 2021 00:34:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCocNc5d8+bB5h5tf5dga0/EVJinBR9/sgmnfDLrauffuqpHPMZ1Ax7y+H18jBiWecZ3qFfw==
X-Received: by 2002:a05:6402:3514:: with SMTP id b20mr21125052edd.100.1612859687959;
        Tue, 09 Feb 2021 00:34:47 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id r11sm11077625edt.58.2021.02.09.00.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 00:34:47 -0800 (PST)
Date:   Tue, 9 Feb 2021 09:34:44 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Andy King <acking@vmware.com>, Wei Liu <wei.liu@kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        George Zhang <georgezhang@vmware.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net] vsock: fix locking in vsock_shutdown()
Message-ID: <20210209083444.nmi73z2zcunqvche@steredhat>
References: <20210208144307.83628-1-sgarzare@redhat.com>
 <20210208150431.jtgeyyf5qackl62b@steredhat>
 <20210208111200.467241da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210208111200.467241da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 11:12:00AM -0800, Jakub Kicinski wrote:
>On Mon, 8 Feb 2021 16:04:31 +0100 Stefano Garzarella wrote:
>> What do you suggest?
>>
>> I did it this way because by modifying only the caller, we would have a
>> nested lock.
>>
>> This way instead we are sure that if we backport this patch, we don't
>> forget to touch hvs_shutdown() as well.
>
>I'm not a socket expert but the approach seems reasonable to me.
>

Thanks, I'll send v2 fixing the warning.

Stefano

