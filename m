Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675D034CCA9
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhC2JF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:05:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237095AbhC2JD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 05:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617008608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qfJKuBiP8cW5TzuCwHMaB1aBCPmPhLpTWgfDVeoZziY=;
        b=O33QxifumEwshkew4mIKlfz+5h7YHy2S0eAgjxfyn08EE/72dG9GYJEPm3iNELTKhd7xwT
        RGLWLmWHQ+FnU2ExdRgcQEOfblxS4G9179v48hwjFxWg5sNa73FEeegERue8yRM+r0RCTE
        3zv1LHWDITzbjCWA4oeEYXKDiJ5HwG0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-5OtKyYsdMZOpP9W6fePehw-1; Mon, 29 Mar 2021 05:03:26 -0400
X-MC-Unique: 5OtKyYsdMZOpP9W6fePehw-1
Received: by mail-ed1-f72.google.com with SMTP id i6so8338452edq.12
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 02:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qfJKuBiP8cW5TzuCwHMaB1aBCPmPhLpTWgfDVeoZziY=;
        b=hcyXpfjlsyBPdOAUYDeRfobTPVyuuJQmfC+SMvHEwLfUXZU5q/a37WxdXUeOHeKyth
         YMKZg36KwCoDTOt1yBk+t/a+SAEzXLN2NY4woEA/N5GY/8Xwa5tyayhu6n/vkXI0OGVa
         3OXtBLQaex+6Bw5dm73XsnVU4VXRUNcscQPsx3UdTcG6pDTOkatl5SLtu8M3p/pqaQac
         KBv4td9VqjwnQxklOOIeU4wcfjodUO70DgQu770UNOYXYDYZZPmxt+Scg7+a+PyTRQx6
         QJOnJHiYyg68hf20+FieWLNL13NtJvCuRa0VRyuUO06oT7beruFG3J83rOQRvCEEhHLt
         A+aw==
X-Gm-Message-State: AOAM533JJGtFTibcHOh5AjrGGrUjoa4LY1j/ntCmyTPVxLysR+gbLzdQ
        IRG2n4aP1fzG+2TYxu1RYpXKWMyojkAWhCJsSUTNRoT6cZHChX8pYBpe/Y+ws2Um/Rid0CxO3uS
        fAGv1rZnZfiGeliLs
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr16998132ejc.292.1617008605603;
        Mon, 29 Mar 2021 02:03:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuwNrq13J78tieTP2BJYkMofD/nbOMfwgH8PqYRkXIogPkNryTSx0PAH5Bk9iCUlfOdQYAig==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr16998115ejc.292.1617008605454;
        Mon, 29 Mar 2021 02:03:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q19sm7778286ejy.50.2021.03.29.02.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 02:03:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D8F11801A3; Mon, 29 Mar 2021 11:03:24 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 2/2] selftests: forwarding: vxlan_bridge_1d: Add
 more ECN decap test cases
In-Reply-To: <20210329082927.347631-3-idosch@idosch.org>
References: <20210329082927.347631-1-idosch@idosch.org>
 <20210329082927.347631-3-idosch@idosch.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 11:03:24 +0200
Message-ID: <87y2e68h7n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> From: Ido Schimmel <idosch@nvidia.com>
>
> Test that all possible combinations of inner and outer ECN bits result
> in the correct inner ECN marking according to RFC 6040 4.2.
>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

