Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAF92929B6
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgJSOsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:48:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729433AbgJSOsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603118925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWWutcR5pVHVHTyCCwcpQfBRR/x2k81YN4WOt/E6KKs=;
        b=R0N2ZLCOt1svik8cwMGgjAtInDKWFoUI5xz3Ec1VPbWTps6yHjsa0T070m2Ripx6vf4Hlt
        VSpIktL5T2Bs4k/vbgUXq/CInOC3wXdVttrI9B0So2S2JtOd/VlXsEDCsSoXb/VG3z4VUN
        Mb4a9b4eaevI4dduPgh4GAz/EltUQko=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-WM-Zg9tkOn--6f8phFI9xg-1; Mon, 19 Oct 2020 10:48:43 -0400
X-MC-Unique: WM-Zg9tkOn--6f8phFI9xg-1
Received: by mail-vs1-f71.google.com with SMTP id h5so2043072vsr.6
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 07:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MWWutcR5pVHVHTyCCwcpQfBRR/x2k81YN4WOt/E6KKs=;
        b=Ynk3RYpBUDUoX0GSlkoJcosAVNU86AaKMgwh8IgwFxGg8Pu69i1UrSE/H8cYfss2/A
         33nQriv09QhrxdALCPJxAaOR3QXnIrfEbxljSf3eq1nc+Bxi5CaLGbHG3yOg+hDMRVhe
         GAjm2/Cp+6NiNO5l8yCbsjNpCtzBUddZr/7vtduFgJ8WxHOPgV6YEarLeqkaJ3atD7mr
         j+3XJLAyuoHQJW1a85L4su9MpeCJl3tkDnjgQL1Wbn2PLe5HMQcTNJfYPjHdT0W4tKWP
         /KTCE0qTiW8DD5Y26QHax6j5wZZ3Llj5yPEbOqbkyxhCi4Yce2Orjt/imEHThtqg2OfC
         AxzQ==
X-Gm-Message-State: AOAM530lrSQ4MSd+rqi4JhF3rkI1nRAG71VZkKOwomEUlrs92eluuUJ2
        SQvME1FmDDWhuV86j/0koNEJGixIs91UX0SgpuAsZifnpbglVbrBBjXQSg/4U1k5wkGxfC5xn4e
        2gJW2zudL4A8ah2Kc
X-Received: by 2002:a67:ff91:: with SMTP id v17mr41315vsq.11.1603118922715;
        Mon, 19 Oct 2020 07:48:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQYxHsxPa+COy4XaT/QpPe/wGt+h15wvCwAlfp7G5CNMN5qA7gNDKdrcbgfyacivpdTETe3w==
X-Received: by 2002:a67:ff91:: with SMTP id v17mr41294vsq.11.1603118922321;
        Mon, 19 Oct 2020 07:48:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v68sm19547vsb.32.2020.10.19.07.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 07:48:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EFB641837DD; Mon, 19 Oct 2020 16:48:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next 2/2] selftests: Update test_tc_neigh to use
 the modified bpf_redirect_neigh()
In-Reply-To: <684a0bd5-b131-c620-ed5e-d1ea7d151ae1@iogearbox.net>
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680973.157904.15451524562795164056.stgit@toke.dk>
 <684a0bd5-b131-c620-ed5e-d1ea7d151ae1@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 19 Oct 2020 16:48:39 +0200
Message-ID: <87wnzme0fs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/15/20 5:46 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> This updates the test_tc_neigh selftest to use the new syntax of
>> bpf_redirect_neigh(). To exercise the helper both with and without the
>> optional parameter, one forwarding direction is changed to do a
>> bpf_fib_lookup() followed by a call to bpf_redirect_neigh(), while the
>> other direction is using the map-based ifindex lookup letting the redire=
ct
>> helper resolve the nexthop from the FIB.
>>=20
>> This also fixes the test_tc_redirect.sh script to work on systems that h=
ave
>> a consolidated dual-stack 'ping' binary instead of separate ping/ping6
>> versions.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> I would prefer if you could not mix the two tests, meaning, one complete =
test
> case is only with bpf_redirect_neigh(get_dev_ifindex(xxx), NULL, 0, 0) fo=
r both
> directions, and another self-contained one is with fib lookup + bpf_redir=
ect_neigh
> with params, even if it means we duplicate test_tc_neigh.c slighly, but I=
 think
> that's fine for sake of test coverage.

Sure, can do :)

-Toke

