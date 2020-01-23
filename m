Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1A0146E13
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgAWQOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:14:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727278AbgAWQOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:14:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579796075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPCOhfNr7QfLjOnMQwcPLRghzYFzYVjn4FigKa7gvN8=;
        b=LwCXhFi+2RbWbSbFsBqk5/DmAwLA0Rky1k6EmopRKeu/mtcrrNXO3i0YL/EkmIxmOFEXOt
        g0Xsq4SnhYDHdahHy2uiCeNyS3hkxvsHKbPH9k/lYZ3wbu4RJnfe6bA1PkH4o10nrDrX1u
        117DFq+Hqsl6VOr4YxvBxi4t/UN/CBE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-yHAJeeAROJ-qhxuMCLvF2A-1; Thu, 23 Jan 2020 11:14:33 -0500
X-MC-Unique: yHAJeeAROJ-qhxuMCLvF2A-1
Received: by mail-lf1-f69.google.com with SMTP id a21so561959lfg.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:14:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pPCOhfNr7QfLjOnMQwcPLRghzYFzYVjn4FigKa7gvN8=;
        b=SufkWZyzgr4v7Z3DJ3w/ZAlpUxxreeW3fLhJwM3cex7K0Vhip1oypH6O35inSyEmVO
         c5Q0mdcLB0JQ6zoz34Bg+rs95iGvnhZqjKqZJpRo/x3USMamz+uIeg0lMtRgmwrXYo00
         4WBPPNxjF60Zz+YBXDszU9y0hf5iNi4wIZXOYfsd9j/H5GUPW2QXDzPQi7XY11NzScm6
         BKp1QG9XpkaEnlGMCjovDCzo0Fn499B9l/3NGMs5K57ikRAzoK04CrVhqzaH3VQ3ZW+x
         rbPvUFdEtHMiNkfxoNJw+wcm7pxxt6vNrT+DAMEw9lpIj4oVRqA+JSe4XQKZTIFegvvn
         /vpw==
X-Gm-Message-State: APjAAAXm3Y9zV+wlmXOrhM6O8MgQc/UnxyjSpQmPpz2PmjuIhTCYVAzf
        k0ujlvmFwSfoROPDmyxxEQhwWyzYx37ppGXT0RzT8EVlaOPxLaJKR9HhmmgI1i9+3CR29YQQOMa
        O2g4X6Et6Dp6QtlKt
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr9745926ljj.253.1579796072087;
        Thu, 23 Jan 2020 08:14:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzaGsiLbEUcyG7DNUTz6xIqgIgPQ+HrYrLIlE/TolXzSxZY4cSPye57105pbbXWjJwn71oETw==
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr9745919ljj.253.1579796071951;
        Thu, 23 Jan 2020 08:14:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y14sm1529815ljk.46.2020.01.23.08.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 08:14:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0ADCE18006C; Thu, 23 Jan 2020 17:14:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 17:14:29 +0100
Message-ID: <87blqui1zu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Luigi Rizzo <lrizzo@google.com> writes:
>>=20
>>> Add a netdevice flag to control skb linearization in generic xdp mode.
>>> Among the various mechanism to control the flag, the sysfs
>>> interface seems sufficiently simple and self-contained.
>>> The attribute can be modified through
>>> 	/sys/class/net/<DEVICE>/xdp_linearize
>>> The default is 1 (on)
>
> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>
>> Erm, won't turning off linearization break the XDP program's ability to
>> do direct packet access?
>
> Yes, in the worst case you only have eth header pulled into linear
> section. :/

In which case an eBPF program could read/write out of bounds since the
verifier only verifies checks against xdp->data_end. Right?

> In tc/BPF for direct packet access we have bpf_skb_pull_data() helper
> which can pull in up to X bytes into linear section on demand. I guess
> something like this could be done for XDP context as well, e.g.
> generic XDP would pull when non-linear and native XDP would have
> nothing todo (though in this case you end up writing the prog
> specifically for generic XDP with slowdown when you'd load it on
> native XDP where it's linear anyway, but that could/should be
> documented if so).

Yeah, I really don't think this is a good idea; there are enough gotchas
with the difference between generic and native XDP as it is... :/

-Toke

