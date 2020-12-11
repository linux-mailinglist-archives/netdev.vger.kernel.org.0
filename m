Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E5C2D7920
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437787AbgLKPYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:24:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437836AbgLKPXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607700125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2kjpk2RbhIA1YYkgV9aHcKnu44Ila9jeMA1cZc9PaxI=;
        b=cMsflJUvE+JQSt+QzA+ZI6kyb2Wwi4D2895vtE+C0X0g/lx+503+BdblK0IptTOVP6Y20Z
        DzVvbJyNOjEcA4sqYlhjhP2pKMPPECn5fO7dw5+gt7oYGZhjgqhmGBNkJXtnqPAUFfoGiI
        TPiEhkwLpEgVHApQZcFtpfh4bfr3K0s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-62NzId8HMpKvi2bvCYzZRA-1; Fri, 11 Dec 2020 10:22:03 -0500
X-MC-Unique: 62NzId8HMpKvi2bvCYzZRA-1
Received: by mail-wm1-f71.google.com with SMTP id w204so2605975wmb.1
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 07:22:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2kjpk2RbhIA1YYkgV9aHcKnu44Ila9jeMA1cZc9PaxI=;
        b=MPr6d9yUudS7xSg5lWGTwkt6eeYRNd3v2q/96EQmxmd22ai57kZiVddOHWFkYmTGRf
         rZGrEchstRXvc3l++MtxW1Ure2osHHVsG0FTIJBOjMUxD2WdCGIyLuNYrgJI9vkiBFIx
         vsJqr+bqBAz++CVCPuPqfAhRZIQZKtSRcWm+hg0GMhnbaqUsy44lyKN1cTzqCEXg6YgN
         aA3cRCUQQUTLBFfdWYKx/fdZYXWYT4lkTWcl9UnhYpITm1vqEqz2ZxYNE1tQgn+mw3s4
         0mloMa97a8WN1IQ+6XDUCfiOIABgCFOA/xXSxb/jd/FWayq56VSuDnBFchwoMdTt1K7E
         EenA==
X-Gm-Message-State: AOAM531rcooXL/iztX2xzDWum6oXYuHcQ9NzosLtog1dWgcDIFo56Dg5
        ktZK7QmTGqsUXiKuwLgqnnxKPw/3SlqCN40qFbBCvuOvG/1/jmchiTxWvgIZWOZP2m8lRMn4i9l
        VFl7fagsGRGIQ9nR4
X-Received: by 2002:a5d:620e:: with SMTP id y14mr15016569wru.111.1607700122648;
        Fri, 11 Dec 2020 07:22:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2/c4amUxO6yiVGaE6UpZHCLxu+13pZQkjX7jCgTLw7r3kRk4v6rC3eMS0oH2I4Jy+g+zPzg==
X-Received: by 2002:a5d:620e:: with SMTP id y14mr15016543wru.111.1607700122480;
        Fri, 11 Dec 2020 07:22:02 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id a21sm14267289wmb.38.2020.12.11.07.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:22:01 -0800 (PST)
Date:   Fri, 11 Dec 2020 16:21:59 +0100
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
Subject: Re: [PATCH net-next v3 2/4] vm_sockets: Add VMADDR_FLAG_TO_HOST
 vsock flag
Message-ID: <20201211152159.lndvshjrr5zqzzdt@steredhat>
References: <20201211103241.17751-1-andraprs@amazon.com>
 <20201211103241.17751-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201211103241.17751-3-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 12:32:39PM +0200, Andra Paraschiv wrote:
>Add VMADDR_FLAG_TO_HOST vsock flag that is used to setup a vsock
>connection where all the packets are forwarded to the host.
>
>Then, using this type of vsock channel, vsock communication between
>sibling VMs can be built on top of it.
>
>Changelog
>
>v2 -> v3
>
>* Update comments to mention when the flag is set in the connect and
>  listen paths.
>
>v1 -> v2
>
>* New patch in v2, it was split from the first patch in the series.
>* Remove the default value for the vsock flags field.
>* Update the naming for the vsock flag to "VMADDR_FLAG_TO_HOST".
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> include/uapi/linux/vm_sockets.h | 20 ++++++++++++++++++++
> 1 file changed, 20 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index 619f8e9d55ca4..c99ed29602345 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -114,6 +114,26 @@
>
> #define VMADDR_CID_HOST 2
>
>+/* The current default use case for the vsock channel is the following:
>+ * local vsock communication between guest and host and nested VMs setup.
>+ * In addition to this, implicitly, the vsock packets are forwarded to the host
>+ * if no host->guest vsock transport is set.
>+ *
>+ * Set this flag value in the sockaddr_vm corresponding field if the vsock
>+ * packets need to be always forwarded to the host. Using this behavior,
>+ * vsock communication between sibling VMs can be setup.
>+ *
>+ * This way can explicitly distinguish between vsock channels created for
>+ * different use cases, such as nested VMs (or local communication between
>+ * guest and host) and sibling VMs.
>+ *
>+ * The flag can be set in the connect logic in the user space application flow.
>+ * In the listen logic (from kernel space) the flag is set on the remote peer
>+ * address. This happens for an incoming connection when it is routed from the
>+ * host and comes from the guest (local CID and remote CID > VMADDR_CID_HOST).
>+ */
>+#define VMADDR_FLAG_TO_HOST 0x0001
>+
> /* Invalid vSockets version. */
>
> #define VM_SOCKETS_INVALID_VERSION -1U
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

