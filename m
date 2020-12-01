Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2453A2CA844
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgLAQ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgLAQ24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606840050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XyWjps8tzjgTT01ktwpVftfAs1XpUw8uGrEPLgazA70=;
        b=BsjPpzadSzHTxJhBgbcVS3r2I2TnpiI0kYwt8ybs8Khnew3PgygIXL6c1BpfRnIHFfPKdr
        RuJoGHMqoXl0mmgp4MglcJ4Ht/QL/agqFhdjODhhw4Z6C/NShAlzIbQSyn4NBd5FQrnQbM
        EalSHshxqEPi8g+ElQTZ7tdLUnybvZU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-mpeaSATCP9GScdIjyqW01A-1; Tue, 01 Dec 2020 11:27:27 -0500
X-MC-Unique: mpeaSATCP9GScdIjyqW01A-1
Received: by mail-wm1-f72.google.com with SMTP id k128so1142727wme.7
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 08:27:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XyWjps8tzjgTT01ktwpVftfAs1XpUw8uGrEPLgazA70=;
        b=isZoCVbLBU91/i+45nAjjNyl4OpdAmzCq3Cc+a9ApZGhNS3zyWKDjF2k0QJSHWgrgx
         jpInoKqVX69oUk27CfoFPk+U95r+DjCv072e019n/yAmpolDaLoRy6pwVSUwNLvmYlQ5
         sULHLTGwezbUU3hRdC43hHv5lWppHWGRCNyjqm5B4JAqkXU7j/V9iuEJPjPVj7midWVB
         2JgH9jmd2CurCJcINSstLRRB74ngtyqPWYQ2Cr8rEBkHhD01B4+m9k0pjJw7jbDOvYSt
         byGCjtFhq8ik8QxGYTuYo6LsDU7LvIXkE6X2GM1Uoi2i6e9+33UoNvwEBM+zxrid/Z24
         ur/w==
X-Gm-Message-State: AOAM5334o9dYPQuxDIOA6iQw8MZrZfdfV5rY1Pxkg0ImaSaDFQSZXJbQ
        Yy7T5qpNOLWrsig7wagSvRJRb85eYRrQIZwjx1tliZWVeWKcdAQR8tmEkeK/VDtQ47D/UXPG5yy
        Bl6WnHjFA2eNa1qB3
X-Received: by 2002:adf:e9c9:: with SMTP id l9mr4976981wrn.124.1606840045016;
        Tue, 01 Dec 2020 08:27:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdDqJt6fveHVsoUSo1PtynWnxeDkOhF4Sr6xztn3/Nuu9uQkO1f1rAWY9/Z2ilme4hq+2iDA==
X-Received: by 2002:adf:e9c9:: with SMTP id l9mr4976947wrn.124.1606840044789;
        Tue, 01 Dec 2020 08:27:24 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id n10sm46507wrv.77.2020.12.01.08.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 08:27:24 -0800 (PST)
Date:   Tue, 1 Dec 2020 17:27:21 +0100
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
Subject: Re: [PATCH net-next v1 0/3] vsock: Add flag field in the vsock
 address
Message-ID: <20201201162721.lbngjzofyk3bad5b@steredhat>
References: <20201201152505.19445-1-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201201152505.19445-1-andraprs@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andra,

On Tue, Dec 01, 2020 at 05:25:02PM +0200, Andra Paraschiv wrote:
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
>add a flag field in the vsock address data structure. The "svm_reserved1" field
>has been repurposed to be the flag field. The value of the flag will then be
>taken into consideration when the vsock transport is assigned.
>
>This way can distinguish between nested VMs / local communication and sibling
>VMs use cases. And can also setup one or more types of communication at the same
>time.

Thanks to work on this, I've left you a few comments, but I think this 
is the right way to support nested and sibling communication together.

Thank you,
Stefano

