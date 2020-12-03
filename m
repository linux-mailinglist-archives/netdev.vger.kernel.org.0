Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DAA2CD814
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgLCNjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:39:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730506AbgLCNjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607002693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z1KKOKeD8FSQgeNHhs8tw5ZNkxzG3hIsrQPw3IYMYMk=;
        b=TNq/QM89Ffiw35MfmpyV1BZMCN8LSfjny8josYUtpnzgijo936QSqoahZ2x7PnRsGDlb/K
        8qBK7vAbBDeBe73sioILepegChJmCGLQKMNn4XnTS6lILVJX0yO3HXw5FK5afjIWqzTiGh
        j8EcjNo/aYkoFb2smDWnc4ncE6hvKWY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-Jby65AvUMSq4CdoTbiBCgA-1; Thu, 03 Dec 2020 08:38:12 -0500
X-MC-Unique: Jby65AvUMSq4CdoTbiBCgA-1
Received: by mail-wm1-f69.google.com with SMTP id z16so5180633wma.1
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z1KKOKeD8FSQgeNHhs8tw5ZNkxzG3hIsrQPw3IYMYMk=;
        b=KiH9Iy3fDNEX9U0CePXhZipi6/Q2oE3bhRQha5NN2gfCfk/3xCIvoAClNoIqDl4blJ
         wYhkz33VuQiuZVmO/4NQNPzp2MxcyUt9ORFqeiEg91gGldeyYS/rLwy6/ABImTuR455I
         0OjaXSIcVSt0Ryh/x5/epiAIJW23K0anr4adRGGisscI6bx+I4mr8BZloRpry56PRIwR
         r5Mv3Nqgt9x8t4QvMToscID36EKVIbpmEUui/MI26+pc0QIMKVL2Gloi5ChfzdM5KpaJ
         R6ldUVbP6oIftnNnkV7XtBsaAYTKkYStpDe+NQERe5xCmX2eF1V6As39C6R1gXhGS2xo
         nbwA==
X-Gm-Message-State: AOAM533thO6iN9Ii9ceRp/lgRYe61hg4fKbFHFZUFR4KcFIo/Z8jckBw
        cTBrmtBh2ntkhfEXMEUYpivPULM0V+t4NcRCLEJZ5Hr3xjdrKfwYD6DBVPno3HNJf4OZbltQdyH
        Sa1kWdgqirWlUo2tE
X-Received: by 2002:a7b:c5c6:: with SMTP id n6mr3299579wmk.131.1607002690858;
        Thu, 03 Dec 2020 05:38:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyg6H2V5t9tmBzfJFjm4InbiCbVIJp+VQ0VfDfx/g9hJiR71wxqmzxajZTbL1cQptwUEM1BQw==
X-Received: by 2002:a7b:c5c6:: with SMTP id n6mr3299555wmk.131.1607002690596;
        Thu, 03 Dec 2020 05:38:10 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id l14sm1455476wmi.33.2020.12.03.05.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:38:09 -0800 (PST)
Date:   Thu, 3 Dec 2020 14:38:07 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the
 vsock address data structure
Message-ID: <20201203133807.36t235yemt5f2j4t@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-2-andraprs@amazon.com>
 <20201203092155.GB687169@stefanha-x1.localdomain>
 <8fcc1daa-4f03-0240-1dda-4daf2e1f7c44@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fcc1daa-4f03-0240-1dda-4daf2e1f7c44@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 12:32:08PM +0200, Paraschiv, Andra-Irina wrote:
>
>
>On 03/12/2020 11:21, Stefan Hajnoczi wrote:
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
>>>
>>>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>>---
>>>  include/uapi/linux/vm_sockets.h | 18 +++++++++++++++++-
>>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>>
>>>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>>>index fd0ed7221645d..58da5a91413ac 100644
>>>--- a/include/uapi/linux/vm_sockets.h
>>>+++ b/include/uapi/linux/vm_sockets.h
>>>@@ -114,6 +114,22 @@
>>>  #define VMADDR_CID_HOST 2
>>>+/* This sockaddr_vm flag value covers the current default use case:
>>>+ * local vsock communication between guest and host and nested VMs setup.
>>>+ * In addition to this, implicitly, the vsock packets are forwarded to the host
>>>+ * if no host->guest vsock transport is set.
>>>+ */
>>>+#define VMADDR_FLAG_DEFAULT_COMMUNICATION	0x0000
>>>+
>>>+/* Set this flag value in the sockaddr_vm corresponding field if the vsock
>>>+ * channel needs to be setup between two sibling VMs running on the same host.
>>>+ * This way can explicitly distinguish between vsock channels created for nested
>>>+ * VMs (or local communication between guest and host) and the ones created for
>>>+ * sibling VMs. And vsock channels for multiple use cases (nested / sibling VMs)
>>>+ * can be setup at the same time.
>>>+ */
>>>+#define VMADDR_FLAG_SIBLING_VMS_COMMUNICATION	0x0001
>>vsock has the h2g and g2h concept. It would be more general to call this
>>flag VMADDR_FLAG_G2H or less cryptically VMADDR_FLAG_TO_HOST.

I agree, VMADDR_FLAG_TO_HOST is more general and it's clearer that is up 
to the host where to forward the packet (sibling if supported, or 
whatever).

Thanks,
Stefano

>
>Thanks for the feedback, Stefan.
>
>I can update the naming to be more general, such as  "_TO_HOST", and 
>keep the use cases (e.g. guest <-> host / nested / sibling VMs 
>communication) mention in the comments so that would relate more to 
>the motivation behind it.
>
>Andra
>
>>
>>That way it just tells the driver in which direction to send packets
>>without implying that sibling communication is possible (it's not
>>allowed by default on any transport).
>>
>>I don't have a strong opinion on this but wanted to suggest the idea.
>>
>>Stefan
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

