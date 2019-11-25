Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 584EF108CCA
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 12:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfKYLSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 06:18:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727680AbfKYLSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 06:18:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574680709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+QkeoDi6C/s/Wai3VV/W5MpT3HON3m8Sc3jHubbJpA=;
        b=ak/8MEcdr+Xn21JXu1fq7jcbTrO/tl9upUweXSe7UEIAoDDi1kFvXh1uZnXRiEOEmz8FRw
        njyhHZWutueTOvEqQyAQwL0qffSkUQJUvb3tkb3dd8MpV62RdhLhG9bslGUX1M0ykLnDRy
        lHvdIK5lQNdNcwBvlUDw7iZsBvxRTaI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-2DJFgo2jPvW2_FwSQ1rIHA-1; Mon, 25 Nov 2019 06:18:23 -0500
Received: by mail-lj1-f200.google.com with SMTP id k14so2837305ljh.14
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 03:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9+QkeoDi6C/s/Wai3VV/W5MpT3HON3m8Sc3jHubbJpA=;
        b=Yx8k3uGhfHwuNR6LNdgh8EvBdVOXiSWRpGbI0f+8QzkgyEa5Po2t7BjUJn5BLlHHvw
         WowoiIc26wsWl1O1PYwuMtxMx4rA/RGaMHWEaWPF3vBgdcyApPcbM/V2YYx3Ycjmvk1r
         XhJLjCWZGWFKRO9oRajtPZVkdrcu7pTTO4wPIRcEgbOnYSM/OmqE3/TGEyQm3+AHlQBF
         d1F/mqObvIF1//rGn54C2RSNZqXHT2sx/Me+S0hC8gMLTuWA9dVDH7q/3W410yex7AoV
         TOZYEuto4zPiYZa4LRyWzf0Y8Vyaj400H4GzMGle/kWTYlIvsDKx1lSBMJ5qr4Zv4K6O
         jhLQ==
X-Gm-Message-State: APjAAAUdbQ8lxYXI5T77dlPDB6MWv4BOEdsCfgkYE81W8crfL8pasNrD
        F4bKSJdUrGhboaLoKxb3ikoN0qzSn8dyXzfvO8FJ8kaeNKnfBjUQRvE3znI8K8RhxC/mBx/8Ybt
        BAIz6hIr7/6P3OVye
X-Received: by 2002:a05:651c:1109:: with SMTP id d9mr21442559ljo.192.1574680701857;
        Mon, 25 Nov 2019 03:18:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPy6wOmF2LQfj4FWc7dYOJYb1RomfucBYVY3QWXT0HGuhI9i+7oRdd07Y61ojInXNFry/Bxw==
X-Received: by 2002:a05:651c:1109:: with SMTP id d9mr21442543ljo.192.1574680701665;
        Mon, 25 Nov 2019 03:18:21 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z19sm3730033ljk.66.2019.11.25.03.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 03:18:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2DB371818BF; Mon, 25 Nov 2019 12:18:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, andrii.nakryiko@gmail.com,
        tariqt@mellanox.com, saeedm@mellanox.com, maximmi@mellanox.com
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
In-Reply-To: <20191123071226.6501-3-bjorn.topel@gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-3-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Nov 2019 12:18:19 +0100
Message-ID: <875zj82ohw.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 2DJFgo2jPvW2_FwSQ1rIHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The xdp_call.h header wraps a more user-friendly API around the BPF
> dispatcher. A user adds a trampoline/XDP caller using the
> DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
> xdp_call_update(). The actual dispatch is done via xdp_call().
>
> Note that xdp_call() is only supported for builtin drivers. Module
> builds will fallback to bpf_prog_run_xdp().

I don't like this restriction. Distro kernels are not likely to start
shipping all the network drivers builtin, so they won't benefit from the
performance benefits from this dispatcher.

What is the reason these dispatcher blocks have to reside in the driver?
Couldn't we just allocate one system-wide, and then simply change
bpf_prog_run_xdp() to make use of it transparently (from the driver
PoV)? That would also remove the need to modify every driver...

-Toke

