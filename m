Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05E53646C5
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhDSPKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:10:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232546AbhDSPKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618845017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hI87sxdqJ16RBIdh2vHXEls0wMx3i8lFsif1UQW1tq0=;
        b=cPLBv8c8IIrToH8kY08EneGPcgHlxmFpgAOFHe1+E7ziAIWKIpdfdJNDoXaoEh853SKWeL
        c41oQw6x8FJ2rQfYEO7xOokabjiG/MyhnhsviWxFvbgW7nxmSBCAZGpMXzGbocbVh/uBt4
        lJdyBwO+fyaqFDMU9s7G4R3ep586HGg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-YBnNbhlRMb287yBggDRJww-1; Mon, 19 Apr 2021 11:10:15 -0400
X-MC-Unique: YBnNbhlRMb287yBggDRJww-1
Received: by mail-ej1-f72.google.com with SMTP id re9-20020a170906d8c9b029037ca22d6744so3752518ejb.0
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 08:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hI87sxdqJ16RBIdh2vHXEls0wMx3i8lFsif1UQW1tq0=;
        b=bsNycApJ9YvTSktCvtAaoppocO9dXl//ewD7xDiY5bqkYdfH3qlhoCRvKMu9e4aOTy
         9bcAcBbhvDwe7rRDlMXmxCdEgjvjJWrSNR0M2QXHnzaNC0lmNoz+7OTnZWUtoKEgRz4T
         thMVcmftCEJkxQAe0vx+QzX+L2CSwIZz/9LI0cNUiM/ZB+d/EVq7gw/JWm42+bvLOjRK
         +3+h7xXscXGoynEshI7H28v6+Zvqlf7js7z8pUQVD0ZwLXNkQ2XNtnBLq+LvIPRVAdMj
         dOru5X+mHiil6jhA4KZjj/hj9LUY5Z6RnHYYOY7yoK1AgDBCBRvBI36Rk5Tam00/G3Q3
         Mu8g==
X-Gm-Message-State: AOAM530P98MlWe3QwoMbOUaBIGbvb15F/6PEB6BKy9DdkXJvredXq0sJ
        nINyrNK8MF3WA2mEQXOv8gbVsriFJFwCKJKCPylKUYUBTgOMo0aq0T7PcLRBokO4ya9+AuREhsK
        ezG+HJEnkJ8QmzBjL
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr22774819ejz.318.1618845013582;
        Mon, 19 Apr 2021 08:10:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ1I7YAcUkAcUeW3VvI6Nfwos1rSwmYuqT8hvgJUrALLpnVMjlixToES3p/bGy6wencJmMCA==
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr22774799ejz.318.1618845013404;
        Mon, 19 Apr 2021 08:10:13 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id w6sm10589579eje.107.2021.04.19.08.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:10:12 -0700 (PDT)
Date:   Mon, 19 Apr 2021 17:10:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] vsock/vmci: log once the failed queue pair allocation
Message-ID: <20210419151010.7r52ckkxptiaa5gr@steredhat>
References: <20210416104416.88997-1-sgarzare@redhat.com>
 <5096E853-EB1A-40C0-B0E5-BDF2F8431998@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5096E853-EB1A-40C0-B0E5-BDF2F8431998@vmware.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:06:18PM +0000, Jorgen Hansen wrote:
>
>
>On 16 Apr 2021, at 12:44, Stefano Garzarella <sgarzare@redhat.com<mailto:sgarzare@redhat.com>> wrote:
>
>VMCI feature is not supported in conjunction with the vSphere Fault
>Tolerance (FT) feature.
>
>VMware Tools can repeatedly try to create a vsock connection. If FT is
>enabled the kernel logs is flooded with the following messages:
>
>   qp_alloc_hypercall result = -20
>   Could not attach to queue pair with -20
>
>"qp_alloc_hypercall result = -20" was hidden by commit e8266c4c3307
>("VMCI: Stop log spew when qp allocation isn't possible"), but "Could
>not attach to queue pair with -20" is still there flooding the log.
>
>Since the error message can be useful in some cases, print it only once.
>
>Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com<mailto:sgarzare@redhat.com>>
>---
>net/vmw_vsock/vmci_transport.c | 3 +--
>1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index 8b65323207db..1c9ecb18b8e6 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -568,8 +568,7 @@ vmci_transport_queue_pair_alloc(struct vmci_qp **qpair,
>      peer, flags, VMCI_NO_PRIVILEGE_FLAGS);
>out:
>if (err < 0) {
>- pr_err("Could not attach to queue pair with %d\n",
>-       err);
>+ pr_err_once("Could not attach to queue pair with %d\n", err);
>err = vmci_transport_error_to_vsock_error(err);
>}
>
>—
>2.30.2
>
>
>Thanks a lot for fixing this.

You're welcome!

>
>Reviewed-by: Jorgen Hansen <jhansen@vmware.com<mailto:jhansen@vmware.com>>
>

Thanks for the review!
Patchwork didn't like it, I think there was some problem with your email 
client putting `<mailto:...>` links.

I think it had to be:

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>

Thanks,
Stefano

