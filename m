Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2212D0DA8
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgLGKAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:00:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726491AbgLGKAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZ6b7tmrNj+Z3UgMZscrtE7hUQNOmYAzTygWMxGHxZE=;
        b=J39gPqRfjDKxV7Q23VRfwrY+hCeBFPbbk7VvwGfHhqGNPAtNrpDpl/Rk9bHUDQBZawptqJ
        0R/+6wYH8OPnPwrJGDBdCkyrtB6lS7mVzdFDliPk2BwLAX7BsqhDVU5Om6I+jdLZRv/l6w
        acgok4PGXdRzL4znMoIBBvESJAfK3jU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-41mSVes6MbmlbX0OHA_ArA-1; Mon, 07 Dec 2020 04:59:10 -0500
X-MC-Unique: 41mSVes6MbmlbX0OHA_ArA-1
Received: by mail-wm1-f72.google.com with SMTP id h68so5169002wme.5
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 01:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZ6b7tmrNj+Z3UgMZscrtE7hUQNOmYAzTygWMxGHxZE=;
        b=ZdOh9K8kMyaKBvtzcRpxkGobIJcMgnYDhGwDmlIfYAAfveAIcBywwUtDJcsBEVtH21
         OKfnOobk5UjTNtmM6e7S0EdNhQstMsjQqimqsmucgyHn1ZzRHtjJ0ixwJsM+UPd22mGm
         ppoB8/YT27tOySKuN3jSqLTS+HATZHbDDVAbU0kKA4K+5h43QgFfd7etgz0dGNxHpu1t
         aN2XJWmOkwXC55wgV75yZeSPhIysKBHv4s3NKoRXYy+O1Aax1HBuBb6uI+U9a5sTxtk0
         KyNYffI6G/OMRUlxn5/9tX5mYdDs7wfRb3tKYm+HGY1MuTmdleVc5SHmJCMmmd9+td9z
         djBA==
X-Gm-Message-State: AOAM532t8IUQvRWGlwG6ZffLZqMtG8ydZE2HAva4DzedzjmeKVJANt8k
        Bon6UZ8kS0jYdlgj5wtBkqODIIZBXm8tDNRRZbJhwyoaJOEvHv4ThTwTlvqq8pOEBoy8gftzsbc
        WoO3cCuKAacGFcRHZ
X-Received: by 2002:a1c:b657:: with SMTP id g84mr17392378wmf.181.1607335149352;
        Mon, 07 Dec 2020 01:59:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCFQaeUZVyXJgZGAWNTmlrtXNDqvE9bdYCTsRkM15YEqF3CEjIzOf1fKC8mI/ujuq8ZgeFaw==
X-Received: by 2002:a1c:b657:: with SMTP id g84mr17392365wmf.181.1607335149141;
        Mon, 07 Dec 2020 01:59:09 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id h98sm15379928wrh.69.2020.12.07.01.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:59:08 -0800 (PST)
Date:   Mon, 7 Dec 2020 10:59:05 +0100
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
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
Message-ID: <20201207095905.q7rczeh54n2zy7fo@steredhat>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201204170235.84387-2-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 07:02:32PM +0200, Andra Paraschiv wrote:
>vsock enables communication between virtual machines and the host they
>are running on. With the multi transport support (guest->host and
>host->guest), nested VMs can also use vsock channels for communication.
>
>In addition to this, by default, all the vsock packets are forwarded to
>the host, if no host->guest transport is loaded. This behavior can be
>implicitly used for enabling vsock communication between sibling VMs.
>
>Add a flags field in the vsock address data structure that can be used
>to explicitly mark the vsock connection as being targeted for a certain
>type of communication. This way, can distinguish between different use
>cases such as nested VMs and sibling VMs.
>
>Use the already available "svm_reserved1" field and mark it as a flags
>field instead. This field can be set when initializing the vsock address
>variable used for the connect() call.
>
>Changelog
>
>v1 -> v2
>
>* Update the field name to "svm_flags".
>* Split the current patch in 2 patches.

Usually the changelog goes after the 3 dashes, but I'm not sure there is 
a strict rule :-)

Anyway the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> include/uapi/linux/vm_sockets.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index fd0ed7221645d..46735376a57a8 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -145,7 +145,7 @@
>
> struct sockaddr_vm {
> 	__kernel_sa_family_t svm_family;
>-	unsigned short svm_reserved1;
>+	unsigned short svm_flags;
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

