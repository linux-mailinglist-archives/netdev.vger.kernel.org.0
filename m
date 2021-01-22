Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105C3300406
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbhAVNUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:20:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727527AbhAVNUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 08:20:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611321546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajrcjZSXYbphZhLIHkDbpT3A7Qd/RhwY5MvS/IAJ0sk=;
        b=A6yFUvANGxV7s0vGvUzMNYnqtHRy2imdptLKZlFak+G7jpQkIcY/Mx2H2gZe0/iehBbnws
        FTV3vLYETAv3QcDBN+sCnymA+1mDPv3euXcru7PJDZF1GxXDH+rTI5FMSsnUijJvPh+hrc
        0Td8ral/uxcRjmmKt/fL02nB2YTC7aw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-78pE5nFfMG6ywf5Oaix1fQ-1; Fri, 22 Jan 2021 08:19:05 -0500
X-MC-Unique: 78pE5nFfMG6ywf5Oaix1fQ-1
Received: by mail-ed1-f71.google.com with SMTP id f4so2908357eds.5
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 05:19:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ajrcjZSXYbphZhLIHkDbpT3A7Qd/RhwY5MvS/IAJ0sk=;
        b=oBSutqjiQjn1ICKm2MXLr7FaxdHNNg5bYYO6ETJCLcQIKLfq6xwTJOu4c6Frelb0D0
         pmP+YpWZLbKInSbQEupYMhiXUgEkDb1Di6q0RRZ7kMZMhjXbVvwbWawctIt3i3mWpnnA
         V5D5XulcaXxGPBpNUQkE4lgT9nbltYS1Fgs8MXoVabIwhQ03i6/PgjKhVP5cAmKFVsWb
         nVZsgaIKaaGi1fsqb9w4xo2hysK70hkrG698Gs5QoKJpZub1hW2KJLz5H2O137R9IMCR
         +XNgu7CX3IOEs8jI6453LDX7d0AfywMbQUgeuOHh4mon9LT0pzuCht0qI9C3t9ATltN4
         AZaA==
X-Gm-Message-State: AOAM533IJatjnS7+sFd5e6PlJ1xlM0L9xeb8+BIWjYCtma2vFNnhFlb0
        wxj8NbuFpFuj6EwJYwSndSVscCWXGph2kvyyHPu8ZpZ1IbbLkR3rrR8ROaPaocaRY8kIaZ6iQC1
        HZtx536GXFJGsp5Sy
X-Received: by 2002:aa7:c399:: with SMTP id k25mr3263704edq.305.1611321543696;
        Fri, 22 Jan 2021 05:19:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJze3yW4jxiIucsDmQVMb0vzqBT/oSpb57JwvYmgoPntZ0zyCLk4iWsdLV5gEux9HwT5oyd68g==
X-Received: by 2002:aa7:c399:: with SMTP id k25mr3263669edq.305.1611321543363;
        Fri, 22 Jan 2021 05:19:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s2sm569729edx.77.2021.01.22.05.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 05:19:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 78AF1180338; Fri, 22 Jan 2021 14:19:02 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next 0/3] AF_XDP clean up/perf improvements
In-Reply-To: <20210122105351.11751-1-bjorn.topel@gmail.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 Jan 2021 14:19:02 +0100
Message-ID: <877do56reh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> This series has some clean up/performance improvements for XDP
> sockets.
>
> The first two patches are cleanups for the AF_XDP core, and the
> restructure actually give a little performance boost.
>
> The last patch adds support for selecting AF_XDP BPF program, based on
> what the running kernel supports.
>
> The patches were earlier part of the bigger "bpf_redirect_xsk()"
> series [1]. I pulled out the non-controversial parts into this series.

What about the first patch from that series, refactoring the existing
bpf_redirect_map() handling? I think that would be eligible for sending
on its own as well :)

-Toke

