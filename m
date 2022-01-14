Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA9E48EAE5
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbiANNid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:38:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236612AbiANNic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 08:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642167511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YhO8ftDsk4+jW9Ti1jjOdqgLJ1dfN2h8UN/qErYWEn4=;
        b=eqA6B3a5PWfUoSYxM4GrzF1IpSaoyDFfOsvUWLD/kJR1lBGnqpTde7QtSGc/1tE2f/xp+B
        w93Odnziw/vjvJ0NqWgzu+2GXFjtG2oi6F21vIlHsSYhQF/6PcgWbBlAPhbAy7oTbTX7vt
        /lpULM5b94ndDWWFNNa9jnIe15fKJOg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-32ndweUqMFC2Dk0NKEcl7Q-1; Fri, 14 Jan 2022 08:38:30 -0500
X-MC-Unique: 32ndweUqMFC2Dk0NKEcl7Q-1
Received: by mail-pj1-f69.google.com with SMTP id g12-20020a17090a4b0c00b001b313b7a676so8500630pjh.4
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 05:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YhO8ftDsk4+jW9Ti1jjOdqgLJ1dfN2h8UN/qErYWEn4=;
        b=gSaGHJfUutygcWiBYIBq7dRBPwip6S2NoBrmxrySB04vSct7N5xV10HctmljOqgyal
         A20M1xyupSlX29pWrVYFCUISf/63PJvEP91+3iM28W3wopnWXLM5FCM6qO15GWmc+2g2
         fssKdf9NUAmc9e7dregXmqDBNyH/l9ui2gyuu5dxS6E5Eb9fdXmsQJSHxhcR70hyqSq+
         6oxwsGmWWKIdkpfFnjYPz4lw9ER6Rbpi3wsz1NcJ4kA7+S5Z/CgQpD62042Sr6QUzdhS
         1ijpl7ajKQRpUJ4IDBqZH6L0+fbGwArlZ5EhZJh/qRml09Ac3uyYsbWvIMmsxeOshZfz
         qZPA==
X-Gm-Message-State: AOAM532WJftiq+7PbLhaf3G9DsWFdp1kIAYisob5ekSJi6oqnpI8bYzP
        1Krp8YsFiFgNe8IjAH0l4TGvidomkmwgRxvo2P/MRaNax/C9peBPmBpoC6jojEyol7MbOiSODR0
        HcxLn5Z4ME3p1618i
X-Received: by 2002:a17:902:a502:b0:149:c5a5:5329 with SMTP id s2-20020a170902a50200b00149c5a55329mr9559618plq.164.1642167509351;
        Fri, 14 Jan 2022 05:38:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxILsnBPX9TsvIa9qO8Uq+U+Jo4SOThql41KRmDC+m0uXyl0MuvIPYYRITKGIUaFyG3qpSUrA==
X-Received: by 2002:a17:902:a502:b0:149:c5a5:5329 with SMTP id s2-20020a170902a50200b00149c5a55329mr9559603plq.164.1642167509120;
        Fri, 14 Jan 2022 05:38:29 -0800 (PST)
Received: from steredhat (host-95-238-125-214.retail.telecomitalia.it. [95.238.125.214])
        by smtp.gmail.com with ESMTPSA id g7sm5820333pfu.61.2022.01.14.05.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:38:28 -0800 (PST)
Date:   Fri, 14 Jan 2022 14:38:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220114133816.7niyaqygvdveddmi@steredhat>
References: <20220114090508.36416-1-sgarzare@redhat.com>
 <20220114074454-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220114074454-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 07:45:35AM -0500, Michael S. Tsirkin wrote:
>On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
>> In vhost_enable_notify() we enable the notifications and we read
>> the avail index to check if new buffers have become available in
>> the meantime.
>>
>> We are not caching the avail index, so when the device will call
>> vhost_get_vq_desc(), it will find the old value in the cache and
>> it will read the avail index again.
>>
>> It would be better to refresh the cache every time we read avail
>> index, so let's change vhost_enable_notify() caching the value in
>> `avail_idx` and compare it with `last_avail_idx` to check if there
>> are new buffers available.
>>
>> Anyway, we don't expect a significant performance boost because
>> the above path is not very common, indeed vhost_enable_notify()
>> is often called with unlikely(), expecting that avail index has
>> not been updated.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
>... and can in theory even hurt due to an extra memory write.
>So ... performance test restults pls?

Right, could be.

I'll run some perf test with vsock, about net, do you have a test suite 
or common step to follow to test it?

Thanks,
Stefano

