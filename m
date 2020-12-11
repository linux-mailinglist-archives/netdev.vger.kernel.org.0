Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C714F2D7928
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437894AbgLKP0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:26:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437885AbgLKPZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607700262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2l0yo4Ve96F2WJkNXwsNtdTN0rO8FOX7fNOyad9ivX0=;
        b=FRqVkaJ27k+WLyApn3qi7/se+lLWSNvEGB0O1AuqA0/uNLjrXn4kAZDbrAHk5hKVDXRICJ
        R05sPZs30TCETtzK5MIw5rEHz7wdEhGVXuqWoX+cTwd2qemh1sryxLicxqZx18++c1ucMq
        WUTfGJeX2kJ2H07Tp9YMnrnBYYRURA4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-HnkQ5oolOBODnCadSLUPAg-1; Fri, 11 Dec 2020 10:24:19 -0500
X-MC-Unique: HnkQ5oolOBODnCadSLUPAg-1
Received: by mail-wr1-f71.google.com with SMTP id r11so3428856wrs.23
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 07:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2l0yo4Ve96F2WJkNXwsNtdTN0rO8FOX7fNOyad9ivX0=;
        b=F4Zvb5Fn/AXYnKsxURRsWUUR0X3+g2/IGpSBP455welodcVcRDwDval8MCPkwk9PX8
         2qglKNYtwIYbO4xBnMPJPAXtBpPr+00yWeOSPGfUwWdjhxgOdd8oatGVfJFxBFe3Hdo4
         xvW2L1lN1UcXZSJ6h7LxDu52n0RrHmKbL3kcmKN1h1molsCm1ST2MDqGl+cuAqTLZmO0
         qxyZj+hpGh2xs/tFeLfrYJPb3wcgZm6e5jKR6R9qrKZOA1WOZkxDuco8SSUkfZJ3UbYo
         SwooKMDNg/pzSTDqDduaqesRE/KL/mrLfckBrlbTKKCzl/VislFlWFTvXOAezTWpQgEf
         rnTw==
X-Gm-Message-State: AOAM533rOfRWBEcNMHMZcJ3UU8wCoFNFq2FirOllqNRn9FFWUCIUEVV1
        aXciKOZkilihemygeoGwFWLvhcEWulecCiXwnlukcLcrt87/ccVmKmWoy8pw7f+V9ZFQbLRNOR5
        PcitMATL3Fbl+eoLR
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr12841930wmh.101.1607700258019;
        Fri, 11 Dec 2020 07:24:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlkr7lm/rjDqcXSluftB1dUd04oIqadtRuWETjuJ4LyoMBCXprY6aihhsdTh9Gb+amV61dbQ==
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr12841911wmh.101.1607700257769;
        Fri, 11 Dec 2020 07:24:17 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id c10sm14946349wrb.92.2020.12.11.07.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:24:17 -0800 (PST)
Date:   Fri, 11 Dec 2020 16:24:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v3 0/4] vsock: Add flags field in the vsock
 address
Message-ID: <20201211152413.iezrw6qswzhpfa3j@steredhat>
References: <20201211103241.17751-1-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201211103241.17751-1-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andra,

On Fri, Dec 11, 2020 at 12:32:37PM +0200, Andra Paraschiv wrote:
>vsock enables communication between virtual machines and the host they are
>running on. Nested VMs can be setup to use vsock channels, as the multi
>transport support has been available in the mainline since the v5.5 Linux kernel
>has been released.
>
>Implicitly, if no host->guest vsock transport is loaded, all the vsock packets
>are forwarded to the host. This behavior can be used to setup communication
>channels between sibling VMs that are running on the same host. One example can
>be the vsock channels that can be established within AWS Nitro Enclaves
>(see Documentation/virt/ne_overview.rst).
>
>To be able to explicitly mark a connection as being used for a certain use case,
>add a flags field in the vsock address data structure. The value of the flags
>field is taken into consideration when the vsock transport is assigned. This way
>can distinguish between different use cases, such as nested VMs / local
>communication and sibling VMs.
>
>The flags field can be set in the user space application connect logic. On the
>listen path, the field can be set in the kernel space logic.
>

I reviewed all the patches and they are in a good shape!

Maybe the last thing to add is a flags check in the 
vsock_addr_validate(), to avoid that flags that we don't know how to 
handle are specified.
For example if in the future we add new flags that this version of the 
kernel is not able to satisfy, we should return an error to the 
application.

I mean something like this:

     diff --git a/net/vmw_vsock/vsock_addr.c b/net/vmw_vsock/vsock_addr.c
     index 909de26cb0e7..73bb1d2fa526 100644
     --- a/net/vmw_vsock/vsock_addr.c
     +++ b/net/vmw_vsock/vsock_addr.c
     @@ -22,6 +22,8 @@ EXPORT_SYMBOL_GPL(vsock_addr_init);
      
      int vsock_addr_validate(const struct sockaddr_vm *addr)
      {
     +       unsigned short svm_valid_flags = VMADDR_FLAG_TO_HOST;
     +
             if (!addr)
                     return -EFAULT;
      
     @@ -31,6 +33,9 @@ int vsock_addr_validate(const struct sockaddr_vm *addr)
             if (addr->svm_zero[0] != 0)
                     return -EINVAL;
      
     +       if (addr->svm_flags & ~svm_valid_flags)
     +               return -EINVAL;
     +
             return 0;
      }
      EXPORT_SYMBOL_GPL(vsock_addr_validate);


Thanks,
Stefano

>Thank you.
>
>Andra
>
>---
>
>Patch Series Changelog
>
>The patch series is built on top of v5.10-rc7.
>
>GitHub repo branch for the latest version of the patch series:
>
>* https://github.com/andraprs/linux/tree/vsock-flag-sibling-comm-v3
>
>v2 -> v3
>
>* Rebase on top of v5.10-rc7.
>* Add "svm_flags" as a new field, not reusing "svm_reserved1".
>* Update comments to mention when the "VMADDR_FLAG_TO_HOST" flag is set in the
>  connect and listen paths.
>* Update bitwise check logic to not compare result to the flag value.
>* v2: https://lore.kernel.org/lkml/20201204170235.84387-1-andraprs@amazon.com/
>
>v1 -> v2
>
>* Update the vsock flag naming to "VMADDR_FLAG_TO_HOST".
>* Use bitwise operators to setup and check the vsock flag.
>* Set the vsock flag on the receive path in the vsock transport assignment
>  logic.
>* Merge the checks for the g2h transport assignment in one "if" block.
>* v1: https://lore.kernel.org/lkml/20201201152505.19445-1-andraprs@amazon.com/
>
>---
>
>Andra Paraschiv (4):
>  vm_sockets: Add flags field in the vsock address data structure
>  vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
>  af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
>  af_vsock: Assign the vsock transport considering the vsock address
>    flags
>
> include/uapi/linux/vm_sockets.h | 25 ++++++++++++++++++++++++-
> net/vmw_vsock/af_vsock.c        | 21 +++++++++++++++++++--
> 2 files changed, 43 insertions(+), 3 deletions(-)
>
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

