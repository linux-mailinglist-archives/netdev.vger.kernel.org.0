Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16AB3AC812
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhFRJ42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232676AbhFRJ41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624010057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y0YXDU9YxlQ+hNYdZgdqLVuT+mH4+43SSYjLUVicsFM=;
        b=TbOvBev+vxhKFZjuvvxvg+Fbs3Sji4FwvtwsR1U0wrBtCmmypgqSn/F1jh4olx6j6K86r8
        MQnEOxQfpPVErFzmN7GzMG2KfQ/nQNCgb1ldlvUb23foQZjGjbSEjpU3y0gp/A53dd3XuC
        j5kCR0GcqrMalSAQC7dYSTSTXJoY/T0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-axzjFqy-MI25POr0S6aILw-1; Fri, 18 Jun 2021 05:54:16 -0400
X-MC-Unique: axzjFqy-MI25POr0S6aILw-1
Received: by mail-ej1-f69.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso3701516ejc.7
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y0YXDU9YxlQ+hNYdZgdqLVuT+mH4+43SSYjLUVicsFM=;
        b=jtGL+batP2hbMkk4P+dC2Wsl0KhZfei7KSQMncP9r261GAbQ7f3yeWbQzU4yfTrgd1
         D2+5/RkUcuP7mdTRn8z3wsIghSs6yymdGXMjSQKdUEHAnzFk8zl4fjw6LiQljARCacD8
         QoM4G0Tn1FSoe+Ijkac78GzdklGDZ5mZiAFvANgqAlEiUS1bL2Dg542B6ExJSSpBD59+
         EG9S+sGvmx1HuukXj6yElm4gworZ6wky/IvKCENx026YHTVYA8StcmQ2otQeg0LEcp7v
         Q0okSsxymh9gor+ItFSgBq3H2h3iFEWtWWMXD1YzDL4K4A7G8V0uXmrL443iZQYj2QNL
         z/9Q==
X-Gm-Message-State: AOAM532429v6V7WdpE4gSzb2rHIWs4SrTokg9UJIntKnM+w5Vfj8wwIh
        QVgyLg1G6967e6xY5J9pp4zyW1A9s5YIJVfLP37hXi0fdhbX7izkjZvH5tmrc4+oho8c4tXltpR
        Z5UZZVpgWXz7xNymX
X-Received: by 2002:a50:c344:: with SMTP id q4mr813937edb.197.1624010055206;
        Fri, 18 Jun 2021 02:54:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWMR1bJzOfZ97L3/bNEKDwZD9gm2Oo2XE369CjGC2l9w0RaUVQn+dQb1wcWVE0CXQxEAZmHA==
X-Received: by 2002:a50:c344:: with SMTP id q4mr813911edb.197.1624010055087;
        Fri, 18 Jun 2021 02:54:15 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.252])
        by smtp.gmail.com with ESMTPSA id n23sm6101995edr.87.2021.06.18.02.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 02:54:14 -0700 (PDT)
Date:   Fri, 18 Jun 2021 11:54:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 5/6] vhost/vsock: add kconfig for vhost dgram support
Message-ID: <20210618095409.q6s3knm2m4u7lezd@steredhat.lan>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-6-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210609232501.171257-6-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 11:24:57PM +0000, Jiang Wang wrote:
>Also change number of vqs according to the config
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>---
> drivers/vhost/Kconfig |  8 ++++++++
> drivers/vhost/vsock.c | 11 ++++++++---
> 2 files changed, 16 insertions(+), 3 deletions(-)

As we already discussed, I think we don't need this patch.

Thanks,
Stefano

