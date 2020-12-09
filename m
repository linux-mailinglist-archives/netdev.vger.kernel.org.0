Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF892D404F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgLIKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:49:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729361AbgLIKtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607510892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zl3ySWzgSqoKQsP+hNncCyo05eryIJHnOiYnp/uja00=;
        b=M/dnkGOKSpZPIPn0U0rHnLaOK9AXPBM4VQY0LvJT6QktPKQZLxH/j/Z/9OF1it83Yn8EbQ
        4GIp+Tyewr/w7BBaB8l5/WP19JYSGgWysqUlfKzCXFYSrKOGCLdwPWsuIFW3RsXQfpwn4v
        w2AaAVc4vU2PSV6Z/pGySjh8ClgXEtw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-JMGT3bwZPEqkQQ7kWieR5Q-1; Wed, 09 Dec 2020 05:48:11 -0500
X-MC-Unique: JMGT3bwZPEqkQQ7kWieR5Q-1
Received: by mail-wm1-f71.google.com with SMTP id l5so229597wmi.4
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 02:48:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zl3ySWzgSqoKQsP+hNncCyo05eryIJHnOiYnp/uja00=;
        b=bXoiCLaMrOW0ov08JSMCjLtjVOu10P0NbsSqFUqt5b3a/Wt2WwvW4Wogc7peui1804
         hdhQphlB0ilQmfAdGMpiTKkY1AE68v2Wxh+kzBc7bxLb9Q9i/8u48fDrbYM3gWI76rYK
         X4oNhyE3TVTPSSfwZfdO1yxibDYogTvEGalPEh0PRyS9NZemefq+UNgcz3pr91jRwdew
         8O+35AxgiskyfDshTii4xYDjeS4WxGmJbCt3qFTKteRPZgG24k1gkaNt7qXG+zhxm8yl
         diB6RdGsu78oSkvZgeTHDDS4Zcel97nW2Jlf6R3wVr3nfycXDndcNDlhjvSn31lLJiYj
         NN0g==
X-Gm-Message-State: AOAM533bkvb4iFf/BZjO08EzkKWchr5MEVWKPywDvVLrOONm2U6FzUR8
        ZF9/lDSfXNiUqf7z+9XaEYV6OnDnCKsSblIZBQRS3wiFfLa2MOUtPMDhVlKyQzcUtC5dfAzZwWr
        rS4TxsR80BYkA1fs5
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr2084718wma.22.1607510890009;
        Wed, 09 Dec 2020 02:48:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyK8P8FxB2rYCIKQU4GEANRcP1ahuTFv3qx/pMjPuBEThdz0uts6Oskds/80xP/YhHVfyJTZw==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr2084699wma.22.1607510889707;
        Wed, 09 Dec 2020 02:48:09 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id e17sm2389291wrw.84.2020.12.09.02.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:48:09 -0800 (PST)
Date:   Wed, 9 Dec 2020 11:48:06 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
Message-ID: <20201209104806.qbuemoz3oy6d3v3b@steredhat>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-2-andraprs@amazon.com>
 <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <73ff948f-f455-7205-bfaa-5b468b2528c2@amazon.com>
 <20201208104222.605bb669@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201208104222.605bb669@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:42:22AM -0800, Jakub Kicinski wrote:
>On Tue, 8 Dec 2020 20:23:24 +0200 Paraschiv, Andra-Irina wrote:
>> >> --- a/include/uapi/linux/vm_sockets.h
>> >> +++ b/include/uapi/linux/vm_sockets.h
>> >> @@ -145,7 +145,7 @@
>> >>
>> >>   struct sockaddr_vm {
>> >>        __kernel_sa_family_t svm_family;
>> >> -     unsigned short svm_reserved1;
>> >> +     unsigned short svm_flags;
>> >>        unsigned int svm_port;
>> >>        unsigned int svm_cid;
>> >>        unsigned char svm_zero[sizeof(struct sockaddr) -
>> > Since this is a uAPI header I gotta ask - are you 100% sure that it's
>> > okay to rename this field?
>> >
>> > I didn't grasp from just reading the patches whether this is a uAPI or
>> > just internal kernel flag, seems like the former from the reading of
>> > the comment in patch 2. In which case what guarantees that existing
>> > users don't pass in garbage since the kernel doesn't check it was 0?
>>
>> That's always good to double-check the uapi changes don't break / assume
>> something, thanks for bringing this up. :)
>>
>> Sure, let's go through the possible options step by step. Let me know if
>> I get anything wrong and if I can help with clarifications.
>>
>> There is the "svm_reserved1" field that is not used in the kernel
>> codebase. It is set to 0 on the receive (listen) path as part of the
>> vsock address initialization [1][2]. The "svm_family" and "svm_zero"
>> fields are checked as part of the address validation [3].
>>
>> Now, with the current change to "svm_flags", the flow is the following:
>>
>> * On the receive (listen) path, the remote address structure is
>> initialized as part of the vsock address init logic [2]. Then patch 3/4
>> of this series sets the "VMADDR_FLAG_TO_HOST" flag given a set of
>> conditions (local and remote CID > VMADDR_CID_HOST).
>>
>> * On the connect path, the userspace logic can set the "svm_flags"
>> field. It can be set to 0 or 1 (VMADDR_FLAG_TO_HOST); or any other value
>> greater than 1. If the "VMADDR_FLAG_TO_HOST" flag is set, all the vsock
>> packets are then forwarded to the host.
>>
>> * When the vsock transport is assigned, the "svm_flags" field is
>> checked, and if it has the "VMADDR_FLAG_TO_HOST" flag set, it goes on
>> with a guest->host transport (patch 4/4 of this series). Otherwise,
>> other specific flag value is not currently used.
>>
>> Given all these points, the question remains what happens if the
>> "svm_flags" field is set on the connect path to a value higher than 1
>> (maybe a bogus one, not intended so). And it includes the
>> "VMADDR_FLAG_TO_HOST" value (the single flag set and specifically used
>> for now, but we should also account for any further possible flags). In
>> this case, all the vsock packets would be forwarded to the host and
>> maybe not intended so, having a bogus value for the flags field. Is this
>> possible case what you are referring to?
>
>Correct. What if user basically declared the structure on the stack,
>and only initialized the fields the kernel used to check?
>
>This problem needs to be at the very least discussed in the commit
>message.
>

I agree that could be a problem, but here some considerations:
- I checked some applications (qemu-guest-agent, ncat, iperf-vsock) and 
   all use the same pattern: allocate memory, initialize all the 
   sockaddr_vm to zero (to be sure to initialize the svm_zero), set the 
   cid and port fields.
   So we should be safe, but of course it may not always be true.

- For now the issue could affect only nested VMs. We introduced this 
   support one year ago, so it's something new and maybe we don't cause 
   too many problems.

As an alternative, what about using 1 or 2 bytes from svm_zero[]?
These must be set at zero, even if we only check the first byte in the 
kernel.

Thanks,
Stefano

