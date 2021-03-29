Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7BA34CCA4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhC2JE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:04:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237067AbhC2JD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 05:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617008607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYRQDK5TB3GDw3EeFksTqu+rDS+GYppmZXTm7P6BiBQ=;
        b=gKSUyvbxKp9GL/WiVcUothLgdfp53keUZgJh5/uYrE2l2fkWbmROn/El65+RzmLY/r3UQK
        ost4IaQDz/SKeFctzYiFzpJVrQTSx0RAafXD0K+jBxlyqlyOkoQwKvqb+AtyTlg/6zs6i2
        MHe69hq4mgGLq/Fd8Zq2PvXzPBcEIkY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-kSuV7iWHNKmASV5-y0GxZQ-1; Mon, 29 Mar 2021 05:03:21 -0400
X-MC-Unique: kSuV7iWHNKmASV5-y0GxZQ-1
Received: by mail-ej1-f71.google.com with SMTP id li22so5535429ejb.18
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 02:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nYRQDK5TB3GDw3EeFksTqu+rDS+GYppmZXTm7P6BiBQ=;
        b=l0rxDfF6dY629B8u7DqRbCOsXSA/wjuPdmVNNt+O0HUjGRB7PlPFjizt09tzIQTVv8
         aA2kFxmU5QE4iz67gXSqAVUV7j9hzPo5dfacgJ7yCTp2iN8UOakYkHBUIzXrJfL70WsT
         ckFWqgtFJ8vJFBGJMWqoyLdDb5cjXN8bi/aHwE4S/dvYQ4X6JNgXegSqeBBm82Q+7OeH
         APsPvK/YjaFisdM2IJga3TPP/PPMW8nAQ5uv0fMs0Nh5vmOYs/+FwiXJjw+6KNUhvY0F
         YNzjb7c9tbEz6p0sfB+Zbvkr8yIVgvjrlWtWlNOWtGVzUeDdy3xJNOqQ91eLgUitKddw
         bkGw==
X-Gm-Message-State: AOAM533tRksyz7z/g506lSJbUgkZ6l8AvrCDqKKrHAOPavKIu3MGkUtX
        Dgyk2usikXEz6Xd5fqXG2dCqOsmydPQ78NpNE6GXfxXyvWFgdH/soHkXl6Krn1KaeMdIWsDRU2u
        U/s7doG8wMt+Found
X-Received: by 2002:aa7:d484:: with SMTP id b4mr27572006edr.63.1617008600125;
        Mon, 29 Mar 2021 02:03:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCMXlcNEWqa5ECyymYJ2jBBo8WRBqJJcn8AwOI45Y7HwRA3BQISATTsFISLZjkNRoD48RfsQ==
X-Received: by 2002:aa7:d484:: with SMTP id b4mr27571977edr.63.1617008599905;
        Mon, 29 Mar 2021 02:03:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u24sm8525819edt.85.2021.03.29.02.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 02:03:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D66C71801A3; Mon, 29 Mar 2021 11:03:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 1/2] mlxsw: spectrum: Fix ECN marking in tunnel
 decapsulation
In-Reply-To: <20210329082927.347631-2-idosch@idosch.org>
References: <20210329082927.347631-1-idosch@idosch.org>
 <20210329082927.347631-2-idosch@idosch.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 11:03:17 +0200
Message-ID: <871rby9vsa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> From: Ido Schimmel <idosch@nvidia.com>
>
> Cited commit changed the behavior of the software data path with regards
> to the ECN marking of decapsulated packets. However, the commit did not
> change other callers of __INET_ECN_decapsulate(), namely mlxsw. The
> driver is using the function in order to ensure that the hardware and
> software data paths act the same with regards to the ECN marking of
> decapsulated packets.
>
> The discrepancy was uncovered by commit 5aa3c334a449 ("selftests:
> forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value") that
> aligned the selftest to the new behavior. Without this patch the
> selftest passes when used with veth pairs, but fails when used with
> mlxsw netdevs.
>
> Fix this by instructing the device to propagate the ECT(1) mark from the
> outer header to the inner header when the inner header is ECT(0), for
> both NVE and IP-in-IP tunnels.
>
> A helper is added in order not to duplicate the code between both tunnel
> types.
>
> Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as reco=
mmended by RFC6040")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>

Huh, I had no idea there was a caller in the driver - thanks for fixing
that!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

