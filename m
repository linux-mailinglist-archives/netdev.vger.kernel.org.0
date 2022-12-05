Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADCB642613
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiLEJss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiLEJsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:48:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C5A55A6
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670233665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IcvnyLKDgnT5EwGdRxoCJ/l5uFVnluQmDLioHt8iGWE=;
        b=M4MoF8Zih7RlM/aZzhWm4NqAFN+GciVNM44hmiVPBTKUXuN5yF91olQn4pGNzTRbS+OWpi
        R8Gl4Kk+tgpUcQKUxHbnnA702JXGPvi6XGshvHXQ6XdcEVaKaMfsHkLOt3ZRL8fU3we+1L
        +HBT6tkypR2Rx5cGRuK4Gcipf1nxAfE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-91-O0dZbCmOMDqBMDcRQA1VsA-1; Mon, 05 Dec 2022 04:47:44 -0500
X-MC-Unique: O0dZbCmOMDqBMDcRQA1VsA-1
Received: by mail-qv1-f69.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso30541978qvb.23
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcvnyLKDgnT5EwGdRxoCJ/l5uFVnluQmDLioHt8iGWE=;
        b=Klcrpl7nviHyqh9GlKH9NuADz3oNMxwcOrs5L+CMVdymjCQJCR8WGU0YmbR3HBbev4
         xgojIemNN0zax9FZjXbIAfVxUCxkuERQ03ynnNZBQiOiprRCw7tTgwl+K7UhvnPdBdMg
         QQMRYmQjUGADR+EpnM5zbu9NgGrAEWwBBin1UWH0nPKYbCis7Zi25fdQiBUc/3068luP
         HGwA+GMreNFHW2dnbJ7ie8K0CBfC5Kzrsho4O3MQdXwJOFTdnroC2VkncRvEi6vzh4D+
         xBMOUbxfNahBmO2bV+PeFOi14MnsoUrc5QQCnzgE+SzGoYUVDvSPXt5D8i7ecjaymVq6
         +hpA==
X-Gm-Message-State: ANoB5pk6SPTgjJ/mIL9QYMkbcHHkzBDS4D5dFq7SBbyGz+UYed2jELgm
        ORVRgpeGpqAXjJh+erHbWAdEspBK4ELlAo4UKf6229v7Oo/aAodegcLxIJ196Z6rYH6bcGf22fO
        yVv3aJZNZWA/VSwiu
X-Received: by 2002:a05:620a:13ab:b0:6fe:b81b:b34d with SMTP id m11-20020a05620a13ab00b006feb81bb34dmr3591728qki.670.1670233663913;
        Mon, 05 Dec 2022 01:47:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf45OxZ8+RfdMfmhJecYJujPPz1Wg0eh2+1ixtUFNzLbxhTUqg3CfNjhGJz5ohM76/NfGk6Qbw==
X-Received: by 2002:a05:620a:13ab:b0:6fe:b81b:b34d with SMTP id m11-20020a05620a13ab00b006feb81bb34dmr3591720qki.670.1670233663688;
        Mon, 05 Dec 2022 01:47:43 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id ay40-20020a05622a22a800b003a57a317c17sm9285578qtb.74.2022.12.05.01.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:47:43 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:47:36 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     Vishnu Dasa <vdasa@vmware.com>, Bryan Tan <bryantan@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] net: vmw_vsock: vmci: Check memcpy_from_msg()
Message-ID: <20221205094736.k3yuwk7emijpitvw@sgarzare-redhat>
References: <702BBCBE-6E80-4B12-A996-4A2CB7C66D70@vmware.com>
 <20221203083312.923029-1-artem.chernyshev@red-soft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221203083312.923029-1-artem.chernyshev@red-soft.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 03, 2022 at 11:33:12AM +0300, Artem Chernyshev wrote:
>vmci_transport_dgram_enqueue() does not check the return value
>of memcpy_from_msg(). Return with an error if the memcpy fails.
>
>Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
>Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
>Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
>---
>V1->V2 Fix memory leaking and updates for description
>
> net/vmw_vsock/vmci_transport.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index 842c94286d31..c94c3deaa09d 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -1711,7 +1711,10 @@ static int vmci_transport_dgram_enqueue(
> 	if (!dg)
> 		return -ENOMEM;
>
>-	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
>+	if (memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len)) {
>+		kfree(dg);
>+		return -EFAULT;

Since memcpy_from_msg() is a wrapper of copy_from_iter_full() that 
simply returns -EFAULT in case of an error, perhaps it would be better 
here to return the value of memcpy_from_msg() instead of wiring the 
error.

However in the end the behavior is the same, so even if you don't want 
to change it I'll leave my R-b:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

