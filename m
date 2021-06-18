Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D983ACDC0
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbhFROrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:47:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234548AbhFROrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624027499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V/WnAvrrvHUpmCgAw99j9Kec2UebwacAruxQ8zG2B7M=;
        b=HT/1qc79JJhwxg1eyPIDD8eAEH4x9FW/mGHmz1SMLECqj33avFExyGg7kGRifrERlwP9mo
        0n0xoz+5JU+e5LdFdXi3zpNyQzYHuy0lMtycLO00V2StWH/yxbm7jCIyJ3nTwoceJGymNe
        aYfQjiJWtSbOVY6w5gQzgDVRFxanuPs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-wpzoaTCcOrGfKMxAvalj3Q-1; Fri, 18 Jun 2021 10:44:57 -0400
X-MC-Unique: wpzoaTCcOrGfKMxAvalj3Q-1
Received: by mail-ej1-f71.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so4092967ejc.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 07:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V/WnAvrrvHUpmCgAw99j9Kec2UebwacAruxQ8zG2B7M=;
        b=VdXfavao7m5xOy81kKpevmUK0yQsA/c1bH5ZsVpBNDgKMPhYYdZbfDUHYcPxNnRtwa
         LFZ+JsO+C5AHmZMqePp/A59zn9/ELmvAiCHzdNUSd4t72SmQhfdYBLsq9op9lJRK1XaV
         w40mx9QozYfPH5jPDJiKowJ1gzMe7T0XoGj75P90L8lBcL6mfP4MSDGw4wHAH4n/WE6P
         v4xgRyac8a37jyFxLHLCW8wV2q/lmEl/Vw9B2GR03WaUEwZRY6cQZ3AxOTI6HQCd4/ZG
         +N/uuAVBcXx13HV+krbEjbZL3Js8W1T9EQ7q31Kr9Yj+l0oGmR/aFT4oHtMy0NsMpDtw
         cGUA==
X-Gm-Message-State: AOAM530jARmTnUVoPkrY0aqyD79tYnkS3+xVJ2CHt7u7YXtw7m4iuWKP
        yRwTJS1Av6NqhvlBF8HGgQlbiKDd/umuNG05Lpfuf32XpSh/Thx0V6G0V+hPPJ3Fw9+fysGWp7F
        pubnEMEM4T6FNcsAB
X-Received: by 2002:a50:fe84:: with SMTP id d4mr3407527edt.204.1624027496833;
        Fri, 18 Jun 2021 07:44:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK4Z8Hr0HyQjHs6Puo8AmSdgMXl6TuIWEB1lOjBOybncOitI6nTXoOqO4csz4fz/xLxynwbg==
X-Received: by 2002:a50:fe84:: with SMTP id d4mr3407501edt.204.1624027496686;
        Fri, 18 Jun 2021 07:44:56 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.175])
        by smtp.gmail.com with ESMTPSA id c18sm6178818edt.97.2021.06.18.07.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 07:44:56 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:44:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210618144451.6gmeqtfawdjpvgkv@steredhat.lan>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
 <20210618095006-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210618095006-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 09:51:44AM -0400, Michael S. Tsirkin wrote:
>On Fri, Jun 18, 2021 at 03:44:23PM +0200, Stefano Garzarella wrote:
>> Hi Arseny,
>> the series looks great, I have just a question below about
>> seqpacket_dequeue.
>>
>> I also sent a couple a simple fixes, it would be great if you can review
>> them:
>> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>
>So given this was picked into net next, what's the plan? Just make spec
>follow code? We can wait and see, if there are issues with the spec just
>remember to mask the feature before release.

Yep, the spec patches was already posted, but not merged yet: 
https://lists.oasis-open.org/archives/virtio-comment/202105/msg00017.html

The changes are quite small and they are aligned with the current 
implementation.

Anyway, I perfectly agree with you about waiting and mask it before 
v5.14 release if there are any issue.

Thanks,
Stefano

