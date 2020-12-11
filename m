Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7FC2D791C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437830AbgLKPX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:23:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393039AbgLKPXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:23:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607700093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H2JL8gdYFvxAcjiuHF47Jvj6sREU3Hka+W7jAm2IWls=;
        b=RFdCQ9KkDh1/qXy3U7JMdB6lN7uJblmKLx7+yk/4KAd8WKFY09mqLBlF+829KD4VoLt4s/
        Tai5vDWbTd7VhJbzSh4rluZ51X0GGuApIYrkWE8p04wnOCaCvJ1pix6UeisxOA7AmsMshF
        jgp6woPOMhufX4qWB44FyLhKU15K56E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-fzZDOzk0PTa-WgTn1vcNtQ-1; Fri, 11 Dec 2020 10:21:32 -0500
X-MC-Unique: fzZDOzk0PTa-WgTn1vcNtQ-1
Received: by mail-wm1-f69.google.com with SMTP id f12so3406638wmf.6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 07:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H2JL8gdYFvxAcjiuHF47Jvj6sREU3Hka+W7jAm2IWls=;
        b=fMrnq+VDd8UFRUDK0+5DiFIRpfC+R0BYqaYBJo6+2NX0rhn1duui/5UyiVvKIpQjea
         2wJ2DOWSsPt9LZLg4/pAJ7Z6v5Iw29yb1L5kMX4r7/oAmOe1FhQcq3x4bKnnjWbjzaoc
         Zy5cPB2h/nTggqTZwGnYsb3HIyAFgX8shYfS7EGTvTLRblj8DTtXVqEwA9zDkYcgBv1d
         Z7PVd3a3KRprdEWn8InC/RcWs9ocovWxzDdkzsX6eqye9ZZvHOsfRIQJtGEzj3Imgq0n
         xWs1Ckha+l4/3/Y5iu6IGjstIOH6hCw93ZIs+mBU0naDx95YmugrA/bGdQfym2Jz8/2u
         COLg==
X-Gm-Message-State: AOAM533/pvdRoRGJank0J9OP3UGf0/DUO7RjJrI+gBwIpZdSJNfKSmLZ
        4RH5MoIknQ0Q2U1Ea4SVm3uIRUSI1v7YDzZCPdNkC7XRqgTzQgSHEXhO0HjIxfZ3Qak3Nf1FN7B
        w3kNOFof1wgRAfG5a
X-Received: by 2002:a7b:c7d3:: with SMTP id z19mr3221281wmk.31.1607700091088;
        Fri, 11 Dec 2020 07:21:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGOY59qMEPEBkq+rmwi3sMncPUysDnrHss6YgDgKzFjRisRhWcm7UCEKETYDhF70hrORnRkg==
X-Received: by 2002:a7b:c7d3:: with SMTP id z19mr3221266wmk.31.1607700090901;
        Fri, 11 Dec 2020 07:21:30 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id u85sm14350188wmu.43.2020.12.11.07.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:21:30 -0800 (PST)
Date:   Fri, 11 Dec 2020 16:21:27 +0100
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
Subject: Re: [PATCH net-next v3 1/4] vm_sockets: Add flags field in the vsock
 address data structure
Message-ID: <20201211152127.jfst6qfwc663ft7c@steredhat>
References: <20201211103241.17751-1-andraprs@amazon.com>
 <20201211103241.17751-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201211103241.17751-2-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 12:32:38PM +0200, Andra Paraschiv wrote:
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
>This field can be set when initializing the vsock address variable used
>for the connect() call.
>
>Changelog
>
>v2 -> v3
>
>* Add "svm_flags" as a new field, not reusing "svm_reserved1".

Using the previous 'svn_zero[0]' for the new 'svn_flags' field make sure 
that if an application sets a flag and runs on an older kernel, it will 
receive an error and I think it's perfect, since that kernel is not able 
to handle the flag.

So I think is okay and I confirm my R-b tag ;-)

>
>v1 -> v2
>
>* Update the field name to "svm_flags".
>* Split the current patch in 2 patches.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> include/uapi/linux/vm_sockets.h | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index fd0ed7221645d..619f8e9d55ca4 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -148,10 +148,13 @@ struct sockaddr_vm {
> 	unsigned short svm_reserved1;
> 	unsigned int svm_port;
> 	unsigned int svm_cid;
>+	unsigned short svm_flags;
> 	unsigned char svm_zero[sizeof(struct sockaddr) -
> 			       sizeof(sa_family_t) -
> 			       sizeof(unsigned short) -
>-			       sizeof(unsigned int) - sizeof(unsigned int)];
>+			       sizeof(unsigned int) -
>+			       sizeof(unsigned int) -
>+			       sizeof(unsigned short)];
> };
>
> #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

