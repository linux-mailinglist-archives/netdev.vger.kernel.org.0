Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EF13F5B68
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhHXJxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235658AbhHXJxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629798736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kg6z7dt36I6LiVKwFciZ2psrGVbf2/o69+fbyjnvf4U=;
        b=UnzAdDBmFgkC3bDaCapP8/ePkUIbFgvAZ2ioAXqjAnEPMhjkeavPA9VwPJ8dppKxgDfjYW
        sbNhXBs8Jiuv4TGkDLNz2BBnOjyj2Ar+jwWoSKc6S/fwYyPuFgMj1k/jOl4zfSPtYMsuXb
        z6QLLWLckuGBwJJDe8eRJVUsfp26ubM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-UBT7aMItOougrHAmxttbbA-1; Tue, 24 Aug 2021 05:52:14 -0400
X-MC-Unique: UBT7aMItOougrHAmxttbbA-1
Received: by mail-ed1-f69.google.com with SMTP id h4-20020aa7c604000000b003c423efb7efso1711176edq.12
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kg6z7dt36I6LiVKwFciZ2psrGVbf2/o69+fbyjnvf4U=;
        b=t/JdzyJp5HI5PnZ4v0qbFCafQ6L8ePbs3TqmAkI5X2vx7DQidiFxaZIiDqLu8LxBb/
         DqyYZw8VI4OpTuswlrF/K2gd/d0/29aKFQrVLVyvgPHTuaW1EhMmkre9MTz/LSsJVYrv
         swsEWoZ4l/3FoOI99IRieq/eUYUPFuIwrGLaIGQjyBDMymayDFl6ZyEvLJVICJ+sup+O
         suJ66qz6W/MOvcqB+Bp8pJFvIXVk1IFS4Stp3kj5XqIDCcDDwZZhcNm/QVqvFMb5pVVu
         qmNkz8oz7e31kRS6BaAPscbM3uKQEzRS5WGntOxxQrGQWEDsCEsipvITXwzXgM2ZuP/a
         HBAg==
X-Gm-Message-State: AOAM5319vXx713oQ3HlvQJWW4jds5BTDJrApKBff/cda73a5Pf9Io0za
        pvQSvqBD6I9cqhZduqsznhcaBgeemm44v8NI7UNzvTmNe/KtQNCAIlabieJ0m9mjcsyeNnrXCMp
        gTEtQJVrb6S3BGcMG
X-Received: by 2002:a05:6402:358d:: with SMTP id y13mr42408325edc.300.1629798733738;
        Tue, 24 Aug 2021 02:52:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4YQVPnF4P439rZmYEXIkrS86lreoMk06pzGCFXpJnDrLV059NdnDnDKyu+XUq3zGXCMLhIw==
X-Received: by 2002:a05:6402:358d:: with SMTP id y13mr42408309edc.300.1629798733637;
        Tue, 24 Aug 2021 02:52:13 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id h8sm9152292ejj.22.2021.08.24.02.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:52:13 -0700 (PDT)
Date:   Tue, 24 Aug 2021 11:52:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.co
Subject: Re: [RFC PATCH v3 1/6] virtio/vsock: rename 'EOR' to 'EOM' bit.
Message-ID: <20210824095210.z3iwnjmyztys3yja@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <20210816085112.4173869-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210816085112.4173869-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 11:51:09AM +0300, Arseny Krasnov wrote:
>This current implemented bit is used to mark end of messages
>('EOM' - end of message), not records('EOR' - end of record).
>Also rename 'record' to 'message' in implementation as it is
>different things.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c                   | 12 ++++++------
> include/uapi/linux/virtio_vsock.h       |  2 +-
> net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
> 3 files changed, 14 insertions(+), 14 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

