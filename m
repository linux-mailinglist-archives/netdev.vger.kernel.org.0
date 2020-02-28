Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250141735F8
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgB1LUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:20:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725802AbgB1LUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582888838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JwHjZB5Q4dc3T+wcDE5rzrvHt7xSnx1p8Z0SDiY1kIk=;
        b=c0HdOOIi8e1qJlfHLzO6srhTaV2HhFSHlSO/Wadj6jT7m9LgFxofDgenzOfFC8+BTMSl4D
        16sIiTbzLd+0A9xZ9+j7Q53SSow0kFXSoPQIguepyq/+k2rSsJc3nI5JiOatN2zWnkCnKm
        yQKeeCOjLHHfTr1FGuqVfcfV+d1LcO4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-9XZG7IMSNuq45kX1OQtDsA-1; Fri, 28 Feb 2020 06:20:36 -0500
X-MC-Unique: 9XZG7IMSNuq45kX1OQtDsA-1
Received: by mail-lj1-f198.google.com with SMTP id s15so809571ljp.14
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:20:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JwHjZB5Q4dc3T+wcDE5rzrvHt7xSnx1p8Z0SDiY1kIk=;
        b=Z0vkfcddu7Y9ZiBQHQXis85101r0aYWj+Nfhum9VqD4hf6EPPUkvomwWqYRbag4TH1
         eqBiKyA2SmmJGWbeZlI59J+2tuJsUFEeaAr9/HaTcSMhwRBbkICFXrvefQXqs6Ka+XOd
         LYhqH+Wj6Ml+eiJaz6xqGjTIdtflYWiFdnl9YSbxYF2jjQXXpijHC4i7poC/lKoelWOX
         lpgOs89cldOEdYhQaSRyaq/KhakDSfEtWIjehedynufu1pRlWFMLJGoqKJrPfsz1Cgnx
         cjBED6ml9hNSxqOG6hri213T7kojh4EgXpCNN/iS/Y9uYxbuyGAp8gaF7TK0jIWGFfVv
         wJ3A==
X-Gm-Message-State: ANhLgQ1tZP7LdvIqZ+lgMEQXPkmdW7zeZkMio3zY5num6z5SWgwdcpki
        arK60T+GFkue7Lq0tzZUpozRbI1f1/6hYenACK7EBbnPQCPAqJYTorrxf7Bdxjwq/+rxRsHvWHV
        wan86Posiz7aeFCZe
X-Received: by 2002:a19:3fc7:: with SMTP id m190mr1451722lfa.102.1582888834997;
        Fri, 28 Feb 2020 03:20:34 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtI5wLvOQGFZRXtz+6/xGXuDpaXgvo5ohMGmXLtvABy0daimE/d6cqn/rcnriOUuWqv4Jz45g==
X-Received: by 2002:a19:3fc7:: with SMTP id m190mr1451710lfa.102.1582888834787;
        Fri, 28 Feb 2020 03:20:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q16sm4676857lfd.83.2020.02.28.03.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:20:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2F8EF180362; Fri, 28 Feb 2020 12:20:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, sameehj@amazon.com
Cc:     linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <20200228105435.75298-1-lrizzo@google.com>
References: <20200228105435.75298-1-lrizzo@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Feb 2020 12:20:33 +0100
Message-ID: <875zfrufem.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> Add a netdevice flag to control skb linearization in generic xdp mode.
>
> The attribute can be modified through
> 	/sys/class/net/<DEVICE>/xdpgeneric_linearize
> The default is 1 (on)
>
> Motivation: xdp expects linear skbs with some minimum headroom, and
> generic xdp calls skb_linearize() if needed. The linearization is
> expensive, and may be unnecessary e.g. when the xdp program does
> not need access to the whole payload.
> This sysfs entry allows users to opt out of linearization on a
> per-device basis (linearization is still performed on cloned skbs).
>
> On a kernel instrumented to grab timestamps around the linearization
> code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
> mtu, I see the following times (nanoseconds/pkt)
>
> The receiver generally sees larger packets so the difference is more
> significant.
>
> ns/pkt                   RECEIVER                 SENDER
>
>                     p50     p90     p99       p50   p90    p99
>
> LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
> NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
>
> v1 --> v2 : added Documentation
> v2 --> v3 : adjusted for skb_cloned
> v3 --> v4 : renamed to xdpgeneric_linearize, documentation
>
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

