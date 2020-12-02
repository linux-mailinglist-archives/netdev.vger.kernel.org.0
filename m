Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41472CB74D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 09:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgLBIdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 03:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728989AbgLBIdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 03:33:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606897936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdS5Ozk3yDJPMYRuoyTOIqVIvgy0FiikSyg8r+DUlWg=;
        b=hkHmA9nCuJOb/vtzD/jkQyfwkDe2HyDPlXzWMPxg37WuntSjus6VBI6wIy7tQowyRUzh6G
        Jz1QcwSwofWXlzyQn42+G5yLRIkHl3T0+fh3uS50l5u2lA4VedbIMzpMIM8Z3G1U3Y/O/q
        oqNys8kzZDXTGw+yxib1BCXrkyIBqqs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-PGYtQ49-M6-W2Q65M-bf6Q-1; Wed, 02 Dec 2020 03:32:15 -0500
X-MC-Unique: PGYtQ49-M6-W2Q65M-bf6Q-1
Received: by mail-wr1-f69.google.com with SMTP id b12so2175620wru.15
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 00:32:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EdS5Ozk3yDJPMYRuoyTOIqVIvgy0FiikSyg8r+DUlWg=;
        b=sJVRiQejTBlJCr+OG1XS9i1qpHrr7OTcgdZcLDvxjU1N75+rJfJYXLI9A9gRrckZyj
         yCOEo1RpUlatrInnmfq8JdojYEaWnFuLDNfaUUDEEtVe4wPRd26MLJNXtfYoRuSY0XS+
         119xbE3mvYVdnzomVGlSSzHmlT+9aIMdBEK0DYXfcTMg3NzudKye2XZMam60PoIRzkxx
         HVdjGAWNEVP1D2tlMgZNvnprgKXLY9UUTHnDDHNOWCd0CpbirGDdhGc/RA+PWAUOexf9
         UBAbA01dSDiGR/Kh3F5y3mw+eZPwLr0t9tYKlien00S3I0W1yUmBICINAtTCtCEWppY7
         wruw==
X-Gm-Message-State: AOAM532MtQuXY90KMAvHuXGqVUCpPYTl7V8uaFKxWYoipaEqOop/o+Bt
        AH4p5bk3lyxDOFhSd8w5gp+nsjRK+jix/nj7Q7jNlFhW1xe9wOh8mRWXTTlPfzppSUF54LC3OS7
        rLjnNRPvh8Eo/NKg/
X-Received: by 2002:a7b:c770:: with SMTP id x16mr1820571wmk.139.1606897932573;
        Wed, 02 Dec 2020 00:32:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEVrZqUYCHneGWRpBo4BPzO4zbn5YVkR2h8CaciENRh8epL6dSk21IVODbgmXJbqr9E+jhAw==
X-Received: by 2002:a7b:c770:: with SMTP id x16mr1820554wmk.139.1606897932361;
        Wed, 02 Dec 2020 00:32:12 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id j8sm1123684wrx.11.2020.12.02.00.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 00:32:11 -0800 (PST)
Date:   Wed, 2 Dec 2020 09:32:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
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
Message-ID: <20201202083209.ex5do3dqekfkj5as@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-2-andraprs@amazon.com>
 <20201201160937.sswd3prfn6r52ihc@steredhat>
 <70d9868a-c883-d823-abf8-7e77ea4c933c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70d9868a-c883-d823-abf8-7e77ea4c933c@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 08:15:04PM +0200, Paraschiv, Andra-Irina wrote:
>
>
>On 01/12/2020 18:09, Stefano Garzarella wrote:
>>
>>On Tue, Dec 01, 2020 at 05:25:03PM +0200, Andra Paraschiv wrote:
>>>vsock enables communication between virtual machines and the host they
>>>are running on. With the multi transport support (guest->host and
>>>host->guest), nested VMs can also use vsock channels for communication.
>>>
>>>In addition to this, by default, all the vsock packets are forwarded to
>>>the host, if no host->guest transport is loaded. This behavior can be
>>>implicitly used for enabling vsock communication between sibling VMs.
>>>
>>>Add a flag field in the vsock address data structure that can be used to
>>>explicitly mark the vsock connection as being targeted for a certain
>>>type of communication. This way, can distinguish between nested VMs and
>>>sibling VMs use cases and can also setup them at the same time. Till
>>>now, could either have nested VMs or sibling VMs at a time using the
>>>vsock communication stack.
>>>
>>>Use the already available "svm_reserved1" field and mark it as a flag
>>>field instead. This flag can be set when initializing the vsock address
>>>variable used for the connect() call.
>>
>>Maybe we can split this patch in 2 patches, one to rename the svm_flag
>>and one to add the new flags.
>
>Sure, I can split this in 2 patches, to have a bit more separation of 
>duties.
>
>>
>>>
>>>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>>---
>>>include/uapi/linux/vm_sockets.h | 18 +++++++++++++++++-
>>>1 file changed, 17 insertions(+), 1 deletion(-)
>>>
>>>diff --git a/include/uapi/linux/vm_sockets.h 
>>>b/include/uapi/linux/vm_sockets.h
>>>index fd0ed7221645d..58da5a91413ac 100644
>>>--- a/include/uapi/linux/vm_sockets.h
>>>+++ b/include/uapi/linux/vm_sockets.h
>>>@@ -114,6 +114,22 @@
>>>
>>>#define VMADDR_CID_HOST 2
>>>
>>>+/* This sockaddr_vm flag value covers the current default use case:
>>>+ * local vsock communication between guest and host and nested 
>>>VMs setup.
>>>+ * In addition to this, implicitly, the vsock packets are 
>>>forwarded to the host
>>>+ * if no host->guest vsock transport is set.
>>>+ */
>>>+#define VMADDR_FLAG_DEFAULT_COMMUNICATION     0x0000
>>
>>I think we don't need this macro, since the next one can be used to
>>check if it a sibling communication (flag 0x1 set) or not (flag 0x1
>>not set).
>
>Right, that's not particularly the use of the flag value, as by 
>default comes as 0. It was more for sharing the cases this covers. But 
>I can remove the define and keep this kind of info, with regard to the 
>default case, in the commit message / comments.
>

Agree, you can add few lines in the comment block of VMADDR_FLAG_SIBLING 
describing the default case when it is not set.

>>
>>>+
>>>+/* Set this flag value in the sockaddr_vm corresponding field if 
>>>the vsock
>>>+ * channel needs to be setup between two sibling VMs running on 
>>>the same host.
>>>+ * This way can explicitly distinguish between vsock channels 
>>>created for nested
>>>+ * VMs (or local communication between guest and host) and the 
>>>ones created for
>>>+ * sibling VMs. And vsock channels for multiple use cases (nested 
>>>/ sibling VMs)
>>>+ * can be setup at the same time.
>>>+ */
>>>+#define VMADDR_FLAG_SIBLING_VMS_COMMUNICATION 0x0001
>>
>>What do you think if we shorten in VMADDR_FLAG_SIBLING?
>>
>
>Yup, this seems ok as well for me. I'll update the naming.
>

Thanks,
Stefano

