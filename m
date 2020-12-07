Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630742D0DC6
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgLGKG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:06:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgLGKG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zJ0EqwVdDcSntQ8HHIG1G0YXEUcwMRTK4xGx14tFFhk=;
        b=LsY7DDwlzrJC/7Z7O1uuazGnwlTLtAf46XTHCAP6XDl5BtAG5XcdARJ3I5tdBBRBER/dWF
        7gJFV9dgU1mgJtkgAShaI0wOkDkdeefTfF5jmRSiw+W47h704v5AmJodAZ+uCq4ZNiBNQg
        aJmRD3aImMBR3zXvnRA9QAOGmAlxfsk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-evcy2sjlN5m6nPQ0R5SZcA-1; Mon, 07 Dec 2020 05:05:30 -0500
X-MC-Unique: evcy2sjlN5m6nPQ0R5SZcA-1
Received: by mail-wr1-f71.google.com with SMTP id r11so2763560wrs.23
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 02:05:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zJ0EqwVdDcSntQ8HHIG1G0YXEUcwMRTK4xGx14tFFhk=;
        b=q+xzi4AnWfHctwR6XBqj/5q5QgmjzJGKxhMDT6om/nK2YtC0nKMEXhPt50LBVPudDN
         zapj50dVogHV+t0PmzPxYfHaUcM3RDFWxV4IEi8/TdUpkG/sln0EqdEzBNqAIudBAA1m
         l+fd7xRvztgeseDbERWbmC3SqUN1VRIpxsjKQlvLjObLxTy4K5em6wrvLcLstsbSsZDa
         YckBg2KOnKWGR3EsddqfAL8IkkME1Cz2Ab3pKZfhvhrhHJMKtj+l7tmMbbr2iQz1RV8f
         vKxTUwto4XnUh98pf63R0lcnL9kLDnTaGw50L6EjjEmudP5gIBqj6qF+91K1Da6yDlMR
         85xg==
X-Gm-Message-State: AOAM5332OrxNrAJLvbz4BiQxXQgUgGn1h7G2lhnWWzcniqLF0dnDsx3n
        CdUaJVYlP6ZJgNWvCwXYjauOhvBm9ij1LqDJZxWRM6O0iWuWhOTs9h4rd23uZRBMJZN5+ivRPEy
        Vs8EbOcD8n3w09eUf
X-Received: by 2002:adf:c648:: with SMTP id u8mr18813368wrg.215.1607335529589;
        Mon, 07 Dec 2020 02:05:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEvKRq05zARKT0OZk4hTLsHMCiWEUHbPzqlj0RKIysUDlMJ2QNt6WpHWi+m/kYzmty+3DFWg==
X-Received: by 2002:adf:c648:: with SMTP id u8mr18813341wrg.215.1607335529355;
        Mon, 07 Dec 2020 02:05:29 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id m4sm13423080wmi.41.2020.12.07.02.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 02:05:28 -0800 (PST)
Date:   Mon, 7 Dec 2020 11:05:25 +0100
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
Subject: Re: [PATCH net-next v2 0/4] vsock: Add flags field in the vsock
 address
Message-ID: <20201207100525.v4z7rlewnwubjphu@steredhat>
References: <20201204170235.84387-1-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201204170235.84387-1-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andra,

On Fri, Dec 04, 2020 at 07:02:31PM +0200, Andra Paraschiv wrote:
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
>add a flags field in the vsock address data structure. The "svm_reserved1" field
>has been repurposed to be the flags field. The value of the flags will then be
>taken into consideration when the vsock transport is assigned. This way can
>distinguish between different use cases, such as nested VMs / local communication
>and sibling VMs.

the series seems in a good shape, I left some minor comments.
I run my test suite (vsock_test, iperf3, nc) with nested VMs (QEMU/KVM), 
and everything looks good.

Note: I'll be offline today and tomorrow, so I may miss followups.

Thanks,
Stefano

