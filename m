Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A92D93E2
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 09:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439153AbgLNIOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 03:14:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439138AbgLNIOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 03:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607933599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xhkpw+Eaniad1r8faQn7ubpHzEGzLN8EOpHrM/P9QFI=;
        b=BjWNBftEKy/ywyc0x2YaHDtGRZrgp9M+NWYYczXrbqusE2gB64amD6sNRO7dJcwbJJ2qpq
        7PrV7atvycjFkOfkQ8avu9qiTdz2Vm6lvE2HCOnpjdZiBNfB9vf2/wVvBrY/GY/2DXy/Aj
        dZhYfYBXMF7dKtL5RrcLFSFrJa1RFTU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-CizYjKwhMPu2-AbsYY197Q-1; Mon, 14 Dec 2020 03:13:17 -0500
X-MC-Unique: CizYjKwhMPu2-AbsYY197Q-1
Received: by mail-wm1-f69.google.com with SMTP id g198so3110678wme.7
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 00:13:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xhkpw+Eaniad1r8faQn7ubpHzEGzLN8EOpHrM/P9QFI=;
        b=E6j33RpS0mIs9WqAvh+epaD8Anh5YXa21BWWWWXaO1QHKcSKLUQH7mv7uIBlECSdp4
         pf9r/hdBsY/E7bQ1OLrzd8Wd7YQzMpy76wrMGm0U4uGf/kv5eqn2OfCz1cEEjBkx6SNk
         kAZXnqDJNq0bMNWyQnIbEbhXpaqU/PZOsW+j5l6MVSo9a/0ithdRJ3w44XTX0+JYT1qG
         llKzXPVZ4SatCAv/Da1uLDlhjB0TJKtQNUH1LkuAuaRfItjsr61azLzlozA0AmC2vYZO
         WBXG3vLIFywMRZV9xgFIrHVeuwXTJmAWNUjpFhPXCBxJX5POK4y3G8ZKiH7SCMvHCXrZ
         QHJw==
X-Gm-Message-State: AOAM532P7ezVlgPKuSPi0GN8dd/kMdv85yjrMKtIu3vuG3a+6fcek2KA
        S+L0qSIdR3ZvrNpHAs39LlFRrCtzHqNZMmnWls8iiXYXP4wNtpxfFNj+6m9p9TckHAcVqvHspDU
        Y9rjEbuWWfXeDfcD0
X-Received: by 2002:a7b:c091:: with SMTP id r17mr23111176wmh.129.1607933596454;
        Mon, 14 Dec 2020 00:13:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB2jYVNqzpZdpbofXQRKv5j71XyWbXV5qyzWR2yGIVV9bf10Gc1xTnk7F1zX5VHmsI4FIFXw==
X-Received: by 2002:a7b:c091:: with SMTP id r17mr23111157wmh.129.1607933596269;
        Mon, 14 Dec 2020 00:13:16 -0800 (PST)
Received: from steredhat (host-79-13-204-15.retail.telecomitalia.it. [79.13.204.15])
        by smtp.gmail.com with ESMTPSA id y6sm29843276wmg.39.2020.12.14.00.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 00:13:15 -0800 (PST)
Date:   Mon, 14 Dec 2020 09:13:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v3 0/4] vsock: Add flags field in the vsock
 address
Message-ID: <20201214081312.g6nrzf2ibawhnryr@steredhat>
References: <20201211103241.17751-1-andraprs@amazon.com>
 <20201211152413.iezrw6qswzhpfa3j@steredhat>
 <20201212091608.4ffd1154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201212091608.4ffd1154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 09:16:08AM -0800, Jakub Kicinski wrote:
>On Fri, 11 Dec 2020 16:24:13 +0100 Stefano Garzarella wrote:
>> On Fri, Dec 11, 2020 at 12:32:37PM +0200, Andra Paraschiv wrote:
>> >vsock enables communication between virtual machines and the host they are
>> >running on. Nested VMs can be setup to use vsock channels, as the multi
>> >transport support has been available in the mainline since the v5.5 Linux kernel
>> >has been released.
>> >
>> >Implicitly, if no host->guest vsock transport is loaded, all the vsock packets
>> >are forwarded to the host. This behavior can be used to setup communication
>> >channels between sibling VMs that are running on the same host. One example can
>> >be the vsock channels that can be established within AWS Nitro Enclaves
>> >(see Documentation/virt/ne_overview.rst).
>> >
>> >To be able to explicitly mark a connection as being used for a certain use case,
>> >add a flags field in the vsock address data structure. The value of the flags
>> >field is taken into consideration when the vsock transport is assigned. This way
>> >can distinguish between different use cases, such as nested VMs / local
>> >communication and sibling VMs.
>> >
>> >The flags field can be set in the user space application connect logic. On the
>> >listen path, the field can be set in the kernel space logic.
>> >
>>
>> I reviewed all the patches and they are in a good shape!
>>
>> Maybe the last thing to add is a flags check in the
>> vsock_addr_validate(), to avoid that flags that we don't know how to
>> handle are specified.
>> For example if in the future we add new flags that this version of the
>> kernel is not able to satisfy, we should return an error to the
>> application.
>>
>> I mean something like this:
>>
>>      diff --git a/net/vmw_vsock/vsock_addr.c b/net/vmw_vsock/vsock_addr.c
>>      index 909de26cb0e7..73bb1d2fa526 100644
>>      --- a/net/vmw_vsock/vsock_addr.c
>>      +++ b/net/vmw_vsock/vsock_addr.c
>>      @@ -22,6 +22,8 @@ EXPORT_SYMBOL_GPL(vsock_addr_init);
>>
>>       int vsock_addr_validate(const struct sockaddr_vm *addr)
>>       {
>>      +       unsigned short svm_valid_flags = VMADDR_FLAG_TO_HOST;
>>      +
>>              if (!addr)
>>                      return -EFAULT;
>>
>>      @@ -31,6 +33,9 @@ int vsock_addr_validate(const struct sockaddr_vm *addr)
>>              if (addr->svm_zero[0] != 0)
>>                      return -EINVAL;
>
>Strictly speaking this check should be superseded by the check below
>(AKA removed). We used to check svm_zero[0], with the new field added
>this now checks svm_zero[2]. Old applications may have not initialized
>svm_zero[2] (we're talking about binary compatibility here, apps built
>with old headers).
>
>>      +       if (addr->svm_flags & ~svm_valid_flags)
>>      +               return -EINVAL;
>
>The flags should also probably be one byte (we can define a "more
>flags" flag to unlock further bytes) - otherwise on big endian the
>new flag will fall into svm_zero[1] so the v3 improvements are moot
>for big endian, right?

Right, I assumed the entire svm_zero[] was zeroed out, but we can't be 
sure.

So, I agree to change the svm_flags to 1 byte (__u8), and remove the 
superseded check that you pointed out.
With these changes we should be fully binary compatibility.

Thanks,
Stefano

>
>>              return 0;
>>       }
>>       EXPORT_SYMBOL_GPL(vsock_addr_validate);
>

