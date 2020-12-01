Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAF12CA7D3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392134AbgLAQLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:11:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392123AbgLAQLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:11:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606838985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FmeUIl5gKiTi3zNwJ/hCxS5K2ryAZ0zswO+YxWmjOmo=;
        b=Bu03HYNpBt9219IsMF9Iwf0/Wn+B6ELNSIFEqVwnT9GK847KgaK3zeDYpfCTOakumqH52j
        op6bkzZw8J0aAQVZC9zrPufzK0znrlqs1S7oQ1+0GFaHz9+r7YsfkBbeITk6mL5H67mEVq
        1hz7/YVttFXAXOa+DGgbO37oGzUX7ko=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-20XsHScJNpePRFzjZbLuqg-1; Tue, 01 Dec 2020 11:09:43 -0500
X-MC-Unique: 20XsHScJNpePRFzjZbLuqg-1
Received: by mail-wr1-f69.google.com with SMTP id c11so1206338wrt.12
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 08:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FmeUIl5gKiTi3zNwJ/hCxS5K2ryAZ0zswO+YxWmjOmo=;
        b=QnyrLAby//FbPE6UJIBQK1pVJ5764OIF22MSwL+2IyYjCmdilE02SBZt16ndNfW+w2
         4SCyxk1VQ/j0E+gmjNcT3S0Sr3trQPSxHI5Nfz75SHEZMgozaQVROBduqmqsK19xUKKR
         6xIAiXjSvFy+/L/MJLhU6H3Zm/QsTWN7TZ2AWWie5GMHr1XavXODEZIk0KfxPW7tnh8F
         HEWTX5KOgncW6pUC0T8jf91IvRWPp6NSh1UwnfMe9U+XM+gKOH4YQrK5WT+GQPBVw13F
         cXvtM7e4HRE8mAQRcGO1CwzMpDVe37/arsVB0fH6q1RL2khUBosVu2Q0vAAgb98k3wf9
         ubQA==
X-Gm-Message-State: AOAM5317VZfmGmu8nW56vNHOT86qwc9oYimpWZp4zo7Eg2AzoYsWsZI/
        MjTTtkl7zZ9UX7i4BjbMRlqfCSaw1poKWvS5pVGYiATl04nxTngP5q5o5APvhjLpQzPUp9svNR2
        s+f3I3kIC33a2wYV5
X-Received: by 2002:a7b:c015:: with SMTP id c21mr3377373wmb.79.1606838981799;
        Tue, 01 Dec 2020 08:09:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPVt1eahGleV7/m/61AodRx9ufD5CueGJuH+1j+yzVjP58dGrebIJ7Cg7HtKEs90D7L+R+lQ==
X-Received: by 2002:a7b:c015:: with SMTP id c21mr3377336wmb.79.1606838981480;
        Tue, 01 Dec 2020 08:09:41 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id g11sm38598wrq.7.2020.12.01.08.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 08:09:40 -0800 (PST)
Date:   Tue, 1 Dec 2020 17:09:37 +0100
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
Subject: Re: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the
 vsock address data structure
Message-ID: <20201201160937.sswd3prfn6r52ihc@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201201152505.19445-2-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 05:25:03PM +0200, Andra Paraschiv wrote:
>vsock enables communication between virtual machines and the host they
>are running on. With the multi transport support (guest->host and
>host->guest), nested VMs can also use vsock channels for communication.
>
>In addition to this, by default, all the vsock packets are forwarded to
>the host, if no host->guest transport is loaded. This behavior can be
>implicitly used for enabling vsock communication between sibling VMs.
>
>Add a flag field in the vsock address data structure that can be used to
>explicitly mark the vsock connection as being targeted for a certain
>type of communication. This way, can distinguish between nested VMs and
>sibling VMs use cases and can also setup them at the same time. Till
>now, could either have nested VMs or sibling VMs at a time using the
>vsock communication stack.
>
>Use the already available "svm_reserved1" field and mark it as a flag
>field instead. This flag can be set when initializing the vsock address
>variable used for the connect() call.

Maybe we can split this patch in 2 patches, one to rename the svm_flag 
and one to add the new flags.

>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> include/uapi/linux/vm_sockets.h | 18 +++++++++++++++++-
> 1 file changed, 17 insertions(+), 1 deletion(-)
>
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index fd0ed7221645d..58da5a91413ac 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -114,6 +114,22 @@
>
> #define VMADDR_CID_HOST 2
>
>+/* This sockaddr_vm flag value covers the current default use case:
>+ * local vsock communication between guest and host and nested VMs setup.
>+ * In addition to this, implicitly, the vsock packets are forwarded to the host
>+ * if no host->guest vsock transport is set.
>+ */
>+#define VMADDR_FLAG_DEFAULT_COMMUNICATION	0x0000

I think we don't need this macro, since the next one can be used to 
check if it a sibling communication (flag 0x1 set) or not (flag 0x1 
not set).

>+
>+/* Set this flag value in the sockaddr_vm corresponding field if the vsock
>+ * channel needs to be setup between two sibling VMs running on the same host.
>+ * This way can explicitly distinguish between vsock channels created for nested
>+ * VMs (or local communication between guest and host) and the ones created for
>+ * sibling VMs. And vsock channels for multiple use cases (nested / sibling VMs)
>+ * can be setup at the same time.
>+ */
>+#define VMADDR_FLAG_SIBLING_VMS_COMMUNICATION	0x0001

What do you think if we shorten in VMADDR_FLAG_SIBLING?

Thanks,
Stefano

>+
> /* Invalid vSockets version. */
>
> #define VM_SOCKETS_INVALID_VERSION -1U
>@@ -145,7 +161,7 @@
>
> struct sockaddr_vm {
> 	__kernel_sa_family_t svm_family;
>-	unsigned short svm_reserved1;
>+	unsigned short svm_flag;
> 	unsigned int svm_port;
> 	unsigned int svm_cid;
> 	unsigned char svm_zero[sizeof(struct sockaddr) -
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

