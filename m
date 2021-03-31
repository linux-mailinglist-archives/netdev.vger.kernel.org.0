Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C83500FF
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhCaNKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:10:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235754AbhCaNKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617196220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJ1v/ByVz0LVci4ZFy2wRr2g5wKarpHLC+9VqsIXhEI=;
        b=TpFYf0hY0VP/lNtAdWZ38nuf4eruW2SYIEWGb68iZ7wMX0Gljv3bh0lWergeZN0GirLxOs
        C6EY4ZGNgAxFfpaKhI60pD8F7zbhrFZ7KdBMO5HZh/ehLQilvTCvWrjiKZYJwHxY2tnG/1
        84zrUMGld58IoCexAYwAUakWIT4mp3g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-X46pb9X9OdmxlcrL57QOBA-1; Wed, 31 Mar 2021 09:10:18 -0400
X-MC-Unique: X46pb9X9OdmxlcrL57QOBA-1
Received: by mail-ej1-f72.google.com with SMTP id fy8so758789ejb.19
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 06:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zJ1v/ByVz0LVci4ZFy2wRr2g5wKarpHLC+9VqsIXhEI=;
        b=J4PVaiMIwQN02sEVckk7PXjZcHTN5QGAvVm0429WzQmRml93GhxKczqfEy0qJHrx1l
         1GBeKnc3mf8TfaTvf7lWK2GH6D5okstc3ZC4xds59Wd11Ilfal7vtsPIwUzgiU2+wRsa
         YbMklLiohg951jbDcmmBFpEWwUZx0x27NIkmYsM0yiwfOgwlm8IWZOCUYoymT6tGWR4y
         tZ67tYdNzdJHKv6IyA+o3mEfLCjfKJO6UMIL/gwUPya0O6maZMPt1RjAS12dKSt6eRVW
         0HzoOc8ICd3ij5WLY+esbpSirBH6qSv1lt6S+TLIIOWvG2mwU7VSZC9lCW4ouunMGaG2
         EFhg==
X-Gm-Message-State: AOAM532XwFYjMzQElOWVoD2AQIxQH5MknvTg6QRFZ3gN5pwjwH/Cxk9R
        IR3sntYR4O2BNrhzwLkjgHBI7C6ZXqqe9S4eCe3IrCIBNZym8vVx+9vYhNY06EczrxBgpmENYZR
        HdY3i3RYEJwaPmxWn
X-Received: by 2002:a17:907:7014:: with SMTP id wr20mr3429173ejb.179.1617196216995;
        Wed, 31 Mar 2021 06:10:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxz44gLfORHkiMvrYcdGjX+JWgs3nM3kvEs0NV1oSesnPwMj1FMJD9FAf+k5cktLYImXhxLIA==
X-Received: by 2002:a17:907:7014:: with SMTP id wr20mr3429118ejb.179.1617196216561;
        Wed, 31 Mar 2021 06:10:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s13sm1621718edr.86.2021.03.31.06.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 06:10:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2A8A51801A8; Wed, 31 Mar 2021 15:10:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH v5 bpf-next 06/17] libbpf: xsk: use bpf_link
In-Reply-To: <20210329224316.17793-7-maciej.fijalkowski@intel.com>
References: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
 <20210329224316.17793-7-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 31 Mar 2021 15:10:14 +0200
Message-ID: <87o8ezpiyx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> Currently, if there are multiple xdpsock instances running on a single
> interface and in case one of the instances is terminated, the rest of
> them are left in an inoperable state due to the fact of unloaded XDP
> prog from interface.
>
> Consider the scenario below:
>
> // load xdp prog and xskmap and add entry to xskmap at idx 10
> $ sudo ./xdpsock -i ens801f0 -t -q 10
>
> // add entry to xskmap at idx 11
> $ sudo ./xdpsock -i ens801f0 -t -q 11
>
> terminate one of the processes and another one is unable to work due to
> the fact that the XDP prog was unloaded from interface.
>
> To address that, step away from setting bpf prog in favour of bpf_link.
> This means that refcounting of BPF resources will be done automatically
> by bpf_link itself.
>
> Provide backward compatibility by checking if underlying system is
> bpf_link capable. Do this by looking up/creating bpf_link on loopback
> device. If it failed in any way, stick with netlink-based XDP prog.
> therwise, use bpf_link-based logic.
>
> When setting up BPF resources during xsk socket creation, check whether
> bpf_link for a given ifindex already exists via set of calls to
> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> and comparing the ifindexes from bpf_link and xsk socket.
>
> For case where resources exist but they are not AF_XDP related, bail out
> and ask user to remove existing prog and then retry.
>
> Lastly, do a bit of refactoring within __xsk_setup_xdp_prog and pull out
> existing code branches based on prog_id value onto separate functions
> that are responsible for resource initialization if prog_id was 0 and
> for lookup existing resources for non-zero prog_id as that implies that
> XDP program is present on the underlying net device. This in turn makes
> it easier to follow, especially the teardown part of both branches.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

