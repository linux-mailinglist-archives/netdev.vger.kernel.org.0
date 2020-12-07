Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4441C2D0DAB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgLGKBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:01:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgLGKBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wjEi7P6hfgHyVnloaZRqgJjDDglMZbfIlgcOGjdp8xA=;
        b=MootowQjVTnZejB48I+AD0oHUcDYdUdRpVDdjAn8zu5AORZjHA7HuiZ3OQwSuRBDqeTsJl
        uOhr31osRbvlV+uVFvwytG/PcV5mMNY9bda4CxfeELToVl6A23Bc/DaQwYm/6SrnAeUuAv
        vOlm0g88hZhyeJtsO47p7FODwU0jXtI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-QEfiDeLXMDGXasegCTmV2Q-1; Mon, 07 Dec 2020 04:59:41 -0500
X-MC-Unique: QEfiDeLXMDGXasegCTmV2Q-1
Received: by mail-wm1-f71.google.com with SMTP id j62so5163685wma.4
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 01:59:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjEi7P6hfgHyVnloaZRqgJjDDglMZbfIlgcOGjdp8xA=;
        b=pZZm0i2B+t7BLtyCXfq8SWP7vL7C5x0RwStdwRdTWN6dHySlt8B0RkniaONnM67Ajt
         Oy9pc7kFTfY/P5ASI1AY3/spSkPXbB0InaHKPoLd1sZWPsbwyC7/45G+c95BkXRuxQ+J
         viT/U6jGfbGv4zph+Fnk7Wwz2KmlSyth+hhNSbRnM3TR/HOBk+pVpU3vEvtC4hcyrmEn
         puOvFCrJQ9cDGIE9s/EW4amRJ984DC91URs/KX4Bhspaiw86e5jnBy9wr2l0hNm5ITGC
         Wef/l4c6B/TX41U5f+NEWT4K0SoSaT4l6FbzFnVLSZuMo28QHmEw/wldm8tc2UNwYL4c
         OfBA==
X-Gm-Message-State: AOAM530kvcaDK7+LuXBcowlX4rzF/zC2ya8An4fSuxKiQcjt9Eb1msqJ
        cnSSLaR1pOEmGa65wgFlgk9z8l5A9h4P4ZLva4AI/NOPGE37efXRFKQGTwo7VkhyQkwyDlmMS1L
        Tfiq72F3v8KVTsqgB
X-Received: by 2002:a1c:dfd7:: with SMTP id w206mr6173166wmg.48.1607335178828;
        Mon, 07 Dec 2020 01:59:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFiS5PYUNMXq2Bt6vvLeQpbyZVXsYBq9dEWjw2Fu3EpywNW0qYSK/GmgwEO8IbbiPHcS7Y7w==
X-Received: by 2002:a1c:dfd7:: with SMTP id w206mr6173151wmg.48.1607335178631;
        Mon, 07 Dec 2020 01:59:38 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id p11sm15094191wrj.14.2020.12.07.01.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:59:37 -0800 (PST)
Date:   Mon, 7 Dec 2020 10:59:35 +0100
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
Subject: Re: [PATCH net-next v2 2/4] vm_sockets: Add VMADDR_FLAG_TO_HOST
 vsock flag
Message-ID: <20201207095935.um2aafhvoikwy5xr@steredhat>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201204170235.84387-3-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 07:02:33PM +0200, Andra Paraschiv wrote:
>Add VMADDR_FLAG_TO_HOST vsock flag that is used to setup a vsock
>connection where all the packets are forwarded to the host.
>
>Then, using this type of vsock channel, vsock communication between
>sibling VMs can be built on top of it.
>
>Changelog
>
>v1 -> v2
>
>* New patch in v2, it was split from the first patch in the series.
>* Remove the default value for the vsock flags field.
>* Update the naming for the vsock flag to "VMADDR_FLAG_TO_HOST".
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> include/uapi/linux/vm_sockets.h | 15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index 46735376a57a8..72e1a3d05682d 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -114,6 +114,21 @@
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

Maybe we can add a sentence saying that this flag is set on the remote 
peer address for an incoming connection when it is routed from the host 
(local CID and remote CID > VMADDR_CID_HOST).

>+ *
>+ * This way can explicitly distinguish between vsock channels created for
>+ * different use cases, such as nested VMs (or local communication between
>+ * guest and host) and sibling VMs.
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

