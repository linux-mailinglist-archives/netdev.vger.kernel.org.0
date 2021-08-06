Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437A33E23E1
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbhHFHUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:20:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241509AbhHFHUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628234429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HTm9fbXgLtcZGdGW/3I21kvZ1VGYI5U7k0mhmEpEDg0=;
        b=FSTa0CY5QWVMGSAhJkJC7vjnuHrBQCQfqwkY3HEfrr+B3P9NL1ZZzdAfJtB+3FwPXwV1nx
        2WS96G0N6qoKpi1YBaXeve/LdBjuzFszM7dgnpn9eUQH9IyYQFj5DsxiApY/6bHmjiEmYU
        bWdDXK9GSg1mp+a/TUA8U1aSU2vMsns=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Yj1TCEtcMxS3Wn2loY3zPw-1; Fri, 06 Aug 2021 03:20:28 -0400
X-MC-Unique: Yj1TCEtcMxS3Wn2loY3zPw-1
Received: by mail-ed1-f69.google.com with SMTP id x1-20020a05640218c1b02903bc7f97f858so4443095edy.2
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 00:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HTm9fbXgLtcZGdGW/3I21kvZ1VGYI5U7k0mhmEpEDg0=;
        b=exD9npFzyXGxuq2hkBDFHtp8zdIPTHDyk6qY6dFeQxdR191iUxT14ohKYaxsjzRtk3
         vxhU/xdFIpfelswhBGNwSQexmI5auJfQdW0DZvPT8/NX7tEK9LYaL1bzZmZUB0orfZ7l
         rQv4hLT9bnYFE4U3GDP6frRgNPTIEObvVxhoI2Ny4TcIAuXwo7IVZ8kkxgBkbIv0kpVn
         WzaCuouymhX9ZQiCubNypsgBolPThFA9CvsQXzEyAbOFbB0IP+Qh7Rp+FV0hmpCDHO6m
         1ku19khqo5umUgDjhT8+UMlf4plT1i7qJfqxO2P7ktNCIknV3CuxjpZBw1Sb8/bf6Sms
         S9TQ==
X-Gm-Message-State: AOAM5325TYs4ps6PqOcwBNiQV60HXfaeyJKQ71GbpIBUUzVZCwGbakQX
        MrPs/dpEo/DBotvc6gEjWiTjF9oUCkcFdA580d1+QsZhh5H8lxXP3Yp4WMs2XAhEVwe2fEi8gLn
        KY/qHenyulQMtr7QB
X-Received: by 2002:a05:6402:361:: with SMTP id s1mr11209647edw.172.1628234427597;
        Fri, 06 Aug 2021 00:20:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuVKndM6vRqX10g0DMF+zN0NMme5c3sOtXbrtFonOTm7kn0n+W/NJwkU2ojVAcnd/691RvGg==
X-Received: by 2002:a05:6402:361:: with SMTP id s1mr11209627edw.172.1628234427450;
        Fri, 06 Aug 2021 00:20:27 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id p16sm3396595eds.73.2021.08.06.00.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:20:27 -0700 (PDT)
Date:   Fri, 6 Aug 2021 09:20:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/7] vsock: rename implementation from 'record' to
 'message'
Message-ID: <20210806072024.ejp2d5sgfatga6oz@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210726163328.2589649-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163328.2589649-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 07:33:25PM +0300, Arseny Krasnov wrote:
>As 'record' is not same as 'message', rename current variables,
>comments and defines from 'record' concept to 'message'.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c                   | 18 +++++++++---------
> net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
> 2 files changed, 16 insertions(+), 16 deletions(-)


This patch is fine, I think you can move here the renaming of the flag 
too.

Stefano

