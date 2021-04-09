Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDA935A198
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhDIO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 10:59:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233541AbhDIO7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617980340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UPN2O1msfhHkY5x4/EOapjyJPdwcgrWUqHspwp62y8A=;
        b=S6UUUGieavHeViO/sKCp+WKLPg7h5uAyunS46GtMG6qbaPCrfJ19jznie/nSRe4VfpMsEl
        KdK+jL+4uw01ooV3+9czwwjcMYPJdZFr4vaikw0hJHj86qglR/d59jz8fPcpurBEMB7Iqf
        v3hmGW/Zx3xjeYo55AXz0zZzxkW0QBY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-QfW3ZB1AOkOPQKCSGMeVxQ-1; Fri, 09 Apr 2021 10:58:58 -0400
X-MC-Unique: QfW3ZB1AOkOPQKCSGMeVxQ-1
Received: by mail-ej1-f72.google.com with SMTP id k26so2294094ejs.5
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 07:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UPN2O1msfhHkY5x4/EOapjyJPdwcgrWUqHspwp62y8A=;
        b=ucU2GYLwnC10N5iJJMB/ZqvbK3TPjPS10hTHszEG+a98cBzK+qlOBS06+Ae7Q+4tcZ
         hwlv7CeSipXMoWN4pOF9FBFLZTb/0k8WcnrekNtEITQl6EYLemLXQNt1h6eqwbx2ZRCb
         WjgRJgzGV0eWeKK5hz0FmxQXijvWtqnRYPZe/WlcEMix22iO1aazOhSX74t1J7xamYqh
         XzMQY7sCVQ9tvMrb/Ura5V7UPlfhgE8rE8SlD8kcacdZk2a4YIKe12GkFfeq3gJ8stgP
         7zZZHYStVWy+7pDfwWcu/hRQg7WaiKcFNfEvvInGsn0nSD4h7vGpBRhwUYF/Gc6S6R6F
         A1Nw==
X-Gm-Message-State: AOAM532w25DawedMqKxQhG2mAbhS7QMMoi6S9tBaibuKrcfOdDY3m+8e
        4KssPwBT7QzukM61NHCUiYq5BoINtMHD7lX8YJsG8RaWxe/avFiPP8KIJ10pUvVkppwWSOT5anz
        2rULSuakahhByq78t
X-Received: by 2002:a17:906:2307:: with SMTP id l7mr16867258eja.27.1617980337032;
        Fri, 09 Apr 2021 07:58:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+Qyz8EddDJZw0/1QXHOgvIkH6WVjxZRm+5FjOVA55C1iAZt+i4rfmJvTNh29vddlaE1fznQ==
X-Received: by 2002:a17:906:2307:: with SMTP id l7mr16867246eja.27.1617980336656;
        Fri, 09 Apr 2021 07:58:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j16sm587051ejk.53.2021.04.09.07.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 07:58:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 77D4C1802F9; Fri,  9 Apr 2021 16:58:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next 2/4] veth: allow enabling NAPI even without XDP
In-Reply-To: <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
 <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Apr 2021 16:58:55 +0200
Message-ID: <87v98vtsgg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> Currently the veth device has the GRO feature bit set, even if
> no GRO aggregation is possible with the default configuration,
> as the veth device does not hook into the GRO engine.
>
> Flipping the GRO feature bit from user-space is a no-op, unless
> XDP is enabled. In such scenario GRO could actually take place, but
> TSO is forced to off on the peer device.
>
> This change allow user-space to really control the GRO feature, with
> no need for an XDP program.
>
> The GRO feature bit is now cleared by default - so that there are no
> user-visible behavior changes with the default configuration.
>
> When the GRO bit is set, the per-queue NAPI instances are initialized
> and registered. On xmit, when napi instances are available, we try
> to use them.

Am I mistaken in thinking that this also makes XDP redirect into a veth
work without having to load an XDP program on the peer device? That's
been a long-outstanding thing we've been meaning to fix, so that would
be awesome! :)

-Toke

