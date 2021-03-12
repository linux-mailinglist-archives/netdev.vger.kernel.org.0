Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5043733909A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhCLPBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:01:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231654AbhCLPBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615561278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dY5uAwZg117bNtRKEEBL+2LzAlswxrz2wq+X03tujc0=;
        b=JEeTbA6By4XWaZx1QdaKzfo5BYObUTmamFvTGEIu5cKyfREBVPs/4EWZBmFq5ab+1EBFka
        SnH+PzY6GPvq2HIokAp0+6Y+O3b8m+g95cknBmU16BTPaBWvBzex7T8ElfaNwikD45MttK
        JuHEkWNHhHT755u63d5PW1s56dEnU3w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-cTf-UCD2OeKuvt54NfsU6w-1; Fri, 12 Mar 2021 10:01:17 -0500
X-MC-Unique: cTf-UCD2OeKuvt54NfsU6w-1
Received: by mail-wm1-f69.google.com with SMTP id y9so2142657wma.4
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dY5uAwZg117bNtRKEEBL+2LzAlswxrz2wq+X03tujc0=;
        b=O5BKxMmGyQe/6JGN13GAtjK1RBqlu/nvDueXQBHVCbPxFg3Dsq0QT3mnUeHRDWHSkL
         nZoXN8RZTCrfQStKMpQsr2aMTR4qjD2UDv59Is1+gXOZAFlibwHAxKJEjQ9A3geImBZl
         V+EOtQBbBkJ38vDPQ1zlHRwQL4LDxPgSO7VPvlbrwjGydrAO3wp5C6YeIWw+aB24lHge
         4ueQUJBJCbIUqs8x/wKyerMr0a62RlsZUL6AdRrtdKzL4wNjaKt3dOqiMcqHWBU0LYCq
         ZbL0m+PE4ZJjLbEvx7rhzRvCFhPw7aNT/Q5qH/QoAhUxNByX8gZCvsfGHf4TWS3VSeVm
         SUuA==
X-Gm-Message-State: AOAM531Q30LU8mpolE8/dY8hmYlwohB3eVhMOPjEw3LT3k6cHdqjUFjj
        a1OxBq9y32SOfA35faJZqFU8EeVZvc0cCYqUt5OYs6+bESR8CFUlueKtNx3c/E56W7PIRSOiRNW
        +fAbFb3oeYVHwHUxG
X-Received: by 2002:a1c:195:: with SMTP id 143mr13139929wmb.81.1615561275942;
        Fri, 12 Mar 2021 07:01:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwU/+j7YIHGGD7r2/oDTZXMPTuZH3Lx7EWKi5joHVZyKzFAUrs1mT0L3T9QcEyLqXmzz7K7Aw==
X-Received: by 2002:a1c:195:: with SMTP id 143mr13139730wmb.81.1615561274237;
        Fri, 12 Mar 2021 07:01:14 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id c8sm691886wmb.34.2021.03.12.07.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:01:13 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:01:10 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 04/22] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210312150110.344tr3wgz5cwruzz@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 08:59:45PM +0300, Arseny Krasnov wrote:
>This adds receive loop for SEQPACKET. It looks like receive loop for
>STREAM, but there is a little bit difference:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside one loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  5 +++
> net/vmw_vsock/af_vsock.c | 95 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 99 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

