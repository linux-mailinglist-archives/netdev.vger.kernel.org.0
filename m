Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435B340B864
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhINTy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 15:54:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhINTy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 15:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631649218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dkmQm8W6bvbG86Wt4h4OqHW+/RRUFwTqElupwuosMGw=;
        b=QSUOfjXgROxrJ6QbPez4RTDfcz2IZfZEUz0MIme2TT8xt9X44VTyxWSKtYcaGAoAh8slmx
        nkOavWcHj9npvNDoR7gIpN5IpA9+5nncvjr2eBuirnOwFKpyPZuhReykc8jnAMsZJwVa6+
        rg+0thLsgol+PiH7+WnbLPmGqORTI8M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-HINcNMKQNj6ce9ZKWgL4Nw-1; Tue, 14 Sep 2021 15:53:36 -0400
X-MC-Unique: HINcNMKQNj6ce9ZKWgL4Nw-1
Received: by mail-ej1-f71.google.com with SMTP id dt18-20020a170907729200b005c701c9b87cso196404ejc.8
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 12:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dkmQm8W6bvbG86Wt4h4OqHW+/RRUFwTqElupwuosMGw=;
        b=XTBNMCS05BNH1lvGeF1cZAUU4PZ50yC+4Vm/SsoJQqrmYNYC6DrlI+GvjpKynWr9LQ
         VTNZqNn6G0efOT5SBpvPfb3Agf1x72A5GvfQtMFJZmSXp5gPLOEpeKILM31ndRxxi22H
         pwtPr6CNt0m8BGl1BtryjQHy+w1yZ8I1PqWcRNlt3RiKoWoZo6rfEDZwSGE3jYERtpt+
         v0EeRjozZ6qIAk06FJqLmmqxXj9iVAgU8xldCVG7kZnukBn/I6nkGEB7Fvpe29fEnn5I
         vZ0v64Ptm9YGpL0KBxiwJI639qB/5mx6QRWt3Y+YgZjY9cibQUFGoLDkCLiCCJxT2sYH
         ip3Q==
X-Gm-Message-State: AOAM530xSgp43VYIHvC75yN4JWR36Vkzq+kfhWDExlh4YLnSbxzgA3xY
        9uIp1co8OLim5XHu4BQjymjP748EjRiWPFKZvou2yBv9sBWCKokhN1eOYHc+dsiPYeaG/JYHNgC
        k4I2DjQfeJnS9AJ0Y
X-Received: by 2002:a17:906:31ca:: with SMTP id f10mr20060770ejf.73.1631649215721;
        Tue, 14 Sep 2021 12:53:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM/UIv4EzPb+rSyq8EubqXE2rc9ZXZPKXWi2tuR39YigTtmGpcgA9b+50W9qR7lb08qZkbcg==
X-Received: by 2002:a17:906:31ca:: with SMTP id f10mr20060745ejf.73.1631649215382;
        Tue, 14 Sep 2021 12:53:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gc19sm2566172ejb.35.2021.09.14.12.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 12:53:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 21A8118033D; Tue, 14 Sep 2021 21:53:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ath9k: interrupt fixes on queue reset
In-Reply-To: <20210914192515.9273-1-linus.luessing@c0d3.blue>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Sep 2021 21:53:34 +0200
Message-ID: <87a6kf6iip.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus L=C3=BCssing <linus.luessing@c0d3.blue> writes:

> Hi,
>
> The following are two patches for ath9k to fix a potential interrupt
> storm (PATCH 2/3) and to fix potentially resetting the wifi chip while
> its interrupts were accidentally reenabled (PATCH 3/3).

Uhh, interesting - nice debugging work! What's the user-level symptom of
this? I.e., when this triggers does the device just appear to hang, or
does it cause reboots, or?

-Toke

