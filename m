Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2CA2D9D4E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408364AbgLNRLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:11:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408343AbgLNRKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 12:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607965754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IkmRUwZkoKac7j9Lc1ZXrNGcPMOHDTcvYr7T0GXLDnU=;
        b=LAL9exUw8jOb382KcRloFua+P6lvayBo//9bXualFG6BEogspJ81i9+ETBzt6T0NBIenXj
        JZF2bs/UJ8oNWVSFv7FaecJnxWnInpEA4sjCFWV5rd9wo3dHvA2Mr2iq3F3zEQSrPjh7XJ
        hRfLLpjJweaxIUpCuSt+Zw31S3pxcug=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-_mj6AGhcMQuEcZrKSWMV8A-1; Mon, 14 Dec 2020 12:09:10 -0500
X-MC-Unique: _mj6AGhcMQuEcZrKSWMV8A-1
Received: by mail-wm1-f70.google.com with SMTP id w204so6234614wmb.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:09:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IkmRUwZkoKac7j9Lc1ZXrNGcPMOHDTcvYr7T0GXLDnU=;
        b=uLAEzKzWntysTTlQUrnCbhB4oiM5ntVw5WQ56ieEasF+Iafw+XPouX0nDopSwy3hRR
         gnMZ5kpcTprIE18M4aKb2Pi253lkt7T7Ikmh3pQStHFPlTfv+2pUpEFsG3+M9ZQUp5Ld
         OciVo+SgiRE1RqS4ZqMMx8LqdVqn7UEdhUgelvzZTxTWqxP5YJiSEtegW/LlfvphDTTP
         TDPFXL8IGCKX7AoefxWpjUvamSgrMufLGC1bL2ecsJvpC1zDPC43ysyPXtYDRVbCynin
         ME5xqQg2SuGtqrc+frZmi/NQ4fcJNZICloQNhZSErqmVN7wp2NQibURPofHi2LGmFKYG
         Wa7w==
X-Gm-Message-State: AOAM531pqVKcohVNiTVQ0lt7qDE3vd8Jc//JX3GK7cTKHMoOTWW0mmPL
        YWJ6d/iVHqS7HtVzMn4L9DEuQbcJU3CycPW3DOLjjVRoUzCwBtwqtDyUesjb3SfCsAnwoLhuOhq
        fSpQOxr9/PbBufXod
X-Received: by 2002:adf:decb:: with SMTP id i11mr9158214wrn.26.1607965749314;
        Mon, 14 Dec 2020 09:09:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYDD9g1nTbZzKv9XgeGtvqcR1Qu1XGxdSb++vsOVou/vm9BP1hzrCmM4+KZX55whhKotKJmw==
X-Received: by 2002:adf:decb:: with SMTP id i11mr9158191wrn.26.1607965749103;
        Mon, 14 Dec 2020 09:09:09 -0800 (PST)
Received: from steredhat (host-79-13-204-15.retail.telecomitalia.it. [79.13.204.15])
        by smtp.gmail.com with ESMTPSA id u85sm30786999wmu.43.2020.12.14.09.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 09:09:08 -0800 (PST)
Date:   Mon, 14 Dec 2020 18:09:04 +0100
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
Subject: Re: [PATCH net-next v4 0/5] vsock: Add flags field in the vsock
 address
Message-ID: <20201214170904.wwirjp7ujxrast43@steredhat>
References: <20201214161122.37717-1-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201214161122.37717-1-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 06:11:17PM +0200, Andra Paraschiv wrote:
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

I reviewed and tested all the patches, great job!

Thanks,
Stefano

>
>Thank you.
>
>Andra
>
>---
>
>Patch Series Changelog
>
>The patch series is built on top of v5.10.
>
>GitHub repo branch for the latest version of the patch series:
>
>* https://github.com/andraprs/linux/tree/vsock-flag-sibling-comm-v4
>
>v3 -> v4
>
>* Rebase on top of v5.10.
>* Add check for supported flag values.
>* Update the "svm_flags" field to be 1 byte instead of 2 bytes.
>* v3: https://lore.kernel.org/lkml/20201211103241.17751-1-andraprs@amazon.com/
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
>Andra Paraschiv (5):
>  vm_sockets: Add flags field in the vsock address data structure
>  vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
>  vsock_addr: Check for supported flag values
>  af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
>  af_vsock: Assign the vsock transport considering the vsock address
>    flags
>
> include/uapi/linux/vm_sockets.h | 26 +++++++++++++++++++++++++-
> net/vmw_vsock/af_vsock.c        | 21 +++++++++++++++++++--
> net/vmw_vsock/vsock_addr.c      |  4 +++-
> 3 files changed, 47 insertions(+), 4 deletions(-)
>
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

