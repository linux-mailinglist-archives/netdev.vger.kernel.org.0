Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29276397367
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhFAMjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:39:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232965AbhFAMjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622551089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BCmvmDvbA5Cyjt1llzDXopdRXRvPCz7n+zowurOsi2I=;
        b=UsCFNvmTEhZ+QNALNHRenTpaQZiML7YNn21PwmaQF41c/BiUacqUgHO9K/4U0vjtdk1qFS
        27GCTtdTC7SYTQF2l1sbG3vDjcMtnHIvPvWMFTRZjd1DuUBx+1JsIDmh+UrbuaMifCUXph
        FIgaMKarzPocqlK+M++r/MFWXFgoZv8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-cLoZZgrVO5-rIxJsJUwigg-1; Tue, 01 Jun 2021 08:38:07 -0400
X-MC-Unique: cLoZZgrVO5-rIxJsJUwigg-1
Received: by mail-ed1-f70.google.com with SMTP id s18-20020a0564020372b029038febc2d475so2078530edw.3
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 05:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BCmvmDvbA5Cyjt1llzDXopdRXRvPCz7n+zowurOsi2I=;
        b=OAHmfurYcTq/1VWGhX8UvkWKRM0hPqqElU7+iKdEFh1gdPOQHuoiXx4pSGws1CViiI
         HttZiLFbf6M4n5iGOnTYvxbLznF6+jkOj5bioQQr5gd6aluAFrX3JQxX5t3+OJm8ZhYP
         psDuM+TClWyhEK8Ev3F4jEcWtVW0d+dfaWA4KipqibCxrVeC4VrI2pZEqJr3XUOy5YDX
         Kt2NmhfGpVhduvo0QMOintS+c7J9KlGYw9T3lOJxaiOEyuazGfLOuz3YYUsh8JRyvL06
         /UOZVOPpOkEqLczw+ShuTVFmH9+4Fc43/3dE3eYtjEg+YL1dBYgQVUxWuV7TwVsEVbPB
         Va8w==
X-Gm-Message-State: AOAM532ybvwO0hOR4iQDIw9xaoPH1F8nE1I2rqOWDdUTaCt1O/ryBake
        WXBymtNDXMhGejkctkx7jajLTEDjvrlBknbiza+Mhi2cViQZbEV5Soc/IvfBB1QbXh+ygNaOZOB
        kFKKdB2m9bo1NqQzq
X-Received: by 2002:aa7:c042:: with SMTP id k2mr22837696edo.21.1622551086352;
        Tue, 01 Jun 2021 05:38:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpB7ZQLhNrH3+kWIY4bBsxg5zjVbHaf8cT7e/xnmNqf1H54zyNXW9g9eVDMYuc9d3PO/JS6g==
X-Received: by 2002:aa7:c042:: with SMTP id k2mr22837659edo.21.1622551086016;
        Tue, 01 Jun 2021 05:38:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y25sm5008801edt.17.2021.06.01.05.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 05:38:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EA801180726; Tue,  1 Jun 2021 14:38:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH intel-next 2/2] ice: introduce XDP Tx fallback path
In-Reply-To: <20210601113236.42651-3-maciej.fijalkowski@intel.com>
References: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
 <20210601113236.42651-3-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Jun 2021 14:38:03 +0200
Message-ID: <87czt5dal0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> Under rare circumstances there might be a situation where a requirement
> of having a XDP Tx queue per core could not be fulfilled and some of the
> Tx resources would have to be shared between cores. This yields a need
> for placing accesses to xdp_rings array onto critical section protected
> by spinlock.
>
> Design of handling such scenario is to at first find out how many queues
> are there that XDP could use. Any number that is not less than the half
> of a count of cores of platform is allowed. XDP queue count < cpu count
> is signalled via new VSI state ICE_VSI_XDP_FALLBACK which carries the
> information further down to Rx rings where new ICE_TX_XDP_LOCKED is set
> based on the mentioned VSI state. This ring flag indicates that locking
> variants for getting/putting xdp_ring need to be used in fast path.
>
> For XDP_REDIRECT the impact on standard case (one XDP ring per CPU) can
> be reduced a bit by providing a separate ndo_xdp_xmit and swap it at
> configuration time. However, due to the fact that net_device_ops struct
> is a const, it is not possible to replace a single ndo, so for the
> locking variant of ndo_xdp_xmit, whole net_device_ops needs to be
> replayed.
>
> It has an impact on performance (1-2 %) of a non-fallback path as
> branches are introduced.

I generally feel this is the right approach, although the performance
impact is a bit unfortunately, obviously. Maybe it could be avoided by
the use of static_branch? I.e., keep a global refcount of how many
netdevs are using the locked path and only activate the check in the
fast path while that refcount is >0?

-Toke

