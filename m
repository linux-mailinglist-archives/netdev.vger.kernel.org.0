Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B9821B324
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 12:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgGJKZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 06:25:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44644 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726369AbgGJKZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 06:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594376698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=EdeAaKTgChoVakQaH9ioQmoteP6GoARZY0ssosn9JtQ=;
        b=JhtyPbNceaMTwWK7pMdJu94OD1TiuceF4ENWBOwPllYkDfa3aAqT9YE8oaj0lSLZrozRTE
        PCct+4AefLy/y7BkDHGzeXGLJhfT1+mdcREBH7jjwcuHhpGL7XijUaC8CNA6B5o8+ZYNRN
        WD/z11rtAMO++R8QsE85CHIcqQM64hk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-9-kqJUafMjSMWD7CBRPCIg-1; Fri, 10 Jul 2020 06:24:57 -0400
X-MC-Unique: 9-kqJUafMjSMWD7CBRPCIg-1
Received: by mail-wr1-f72.google.com with SMTP id o12so5564262wrj.23
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 03:24:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=EdeAaKTgChoVakQaH9ioQmoteP6GoARZY0ssosn9JtQ=;
        b=OR3qmIvE8wE+Mg3m9vIkMO258BONG+ZYaw1gtnbOvo4FEgMxWxUE0QIIUNr4PS8QjS
         p/1Qzho7ZH9VDRmzawhDztht/bTlvWXHrDjFCZ5H5id8dBp5AG8+i2OljbCW6HOKICF7
         HV0xo5k9OziDZJ8xiOa85RbnlunJzQuMxl0sjs9wuO7YcwX/dS7z9Olej8pAFViwBg3j
         ZfI6jj26bz5+w5nedC7kzIj0oWuz5WQuc8qRa6ojiE5FEhS9O9sKettxKe5/aQF1mVI8
         2J/IAvsKIL3mDyQWf6cvP0fVoIKl47vBYyCruxBrfBFcd3GWXsFNhodpf+uNchXqvNr5
         6aRA==
X-Gm-Message-State: AOAM532SFy0UrL5Pq0kOmnPOsa5EkY9/bT2ydYL0sO/WPbiJZ6nFJOVm
        xpmuXYnTmBh2BPT0BYN43l3c2VDxpwjPbL1sbQUxRyMh18km3OzaFAjnFYX4vSsa2jcD8AonWuW
        BvIug8kThbEIlEZXu
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr4736807wmc.51.1594376696271;
        Fri, 10 Jul 2020 03:24:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykWL23cX3nQ0MBbqN4BbE0cmuQxQQP9+yT7FJe28AgN0uaIkr9RSYEjSnIicZ6QvahSf2thA==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr4736796wmc.51.1594376696112;
        Fri, 10 Jul 2020 03:24:56 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id r11sm8228480wmh.1.2020.07.10.03.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 03:24:54 -0700 (PDT)
Date:   Fri, 10 Jul 2020 06:24:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     stefanha@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: sparse warnings in net/vmw_vsock/virtio_transport.c
Message-ID: <20200710062421-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RCU trickery:

net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in comparison expression (different address spaces):
net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noderef] __rcu *
net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in comparison expression (different address spaces):
net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [noderef] __rcu *
net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in comparison expression (different address spaces):
net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [noderef] __rcu *
net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in comparison expression (different address spaces):
net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [noderef] __rcu *
net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in comparison expression (different address spaces):
net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noderef] __rcu *
net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in comparison expression (different address spaces):
net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noderef] __rcu *
net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *
  CC [M]  net/vmw_vsock/virtio_transport.o

can you take a look at fixing this pls?

-- 
MST

