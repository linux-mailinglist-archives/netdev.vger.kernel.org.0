Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE37F33913C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhCLP2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:28:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230443AbhCLP2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615562917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xKPy1yb09Ec6cKP/VPrLjTlUwinW20mVG1mfvMCm7HE=;
        b=KREKELFTH/UeB1sy+k58A4PvCYH7zkAPfXeBtYSAEXQbvjNA4HGjBBGKnx4vyVKd04p3Z5
        Gu6UXK+vzHrNJZEKAQl/11P2pwBMNwjAkztxp3tgdkSZb2QrRfgnYAFOjSC1DIWEtoQGOS
        xDNWEpmDL34SyaJPV4P9t1lQzltU9Tk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-KTwfwfcFOqqQrQy_bu7sZg-1; Fri, 12 Mar 2021 10:28:36 -0500
X-MC-Unique: KTwfwfcFOqqQrQy_bu7sZg-1
Received: by mail-wm1-f71.google.com with SMTP id n2so5499012wmi.2
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xKPy1yb09Ec6cKP/VPrLjTlUwinW20mVG1mfvMCm7HE=;
        b=VIFsvl6mQFxS3v5pm/NH4WL8QhfmF1mTY0JC/TVHWX0Uv7YvVAYJ3Y3DTSevZqbvGw
         Z/9DvxuAQphlo4UkUBCuUi7t0ZTpU/9x1gzaKp8Dt7ftORaU1C1uHXF8WgEs+0ZIEDS4
         vCaD2tuBA0sIzjju/RO1TgVjn5PrssXQdrjHXNQaycEAJwVRiOm+EzPJAgJ9FP50Sxa2
         6h8jRpft+kwQTIXR9XEGDQDAqRuPcTEiUKhIAIkZTkPGpxsZp/4DA2qHmB0ssokH/R+Y
         T3G7DxFt3FcO/xbMQYCacyV3/HGMfhHd4YEpNbCicUhn8BcLaNe+D4J2cUI40Tg7jNPO
         dVRQ==
X-Gm-Message-State: AOAM530WhkO8+nSRf8sEWsyJoZwCDt57KIr9nMWN4BXy4g6SimBfGAHW
        lY8MSnACRMZCtDRDat1uTWntfxaK2Mw7oZipbm/Mtp8MMy0hDZG197+WDo3kPnHUKZ7pmGk1Tsy
        /7iAx8FU3vGdlZTRA
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr14224665wru.78.1615562914639;
        Fri, 12 Mar 2021 07:28:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSyMjIqtO+O1pkI/8s/85VaB5c4FEE2zwfH7noDtmrtsh2lsPEfFCvmwaYBZB8Js/rymbJRQ==
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr14224645wru.78.1615562914451;
        Fri, 12 Mar 2021 07:28:34 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id p17sm2337705wmd.42.2021.03.12.07.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:28:34 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:28:31 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 07/22] af_vsock: rest of SEQPACKET support
Message-ID: <20210312152831.f37oxryffuohai3r@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180050.3465297-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180050.3465297-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:00:47PM +0300, Arseny Krasnov wrote:
>This does rest of SOCK_SEQPACKET support:
>1) Adds socket ops for SEQPACKET type.
>2) Allows to create socket with SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
> 2 files changed, 36 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

