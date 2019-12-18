Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0E512459D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfLRLUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:20:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726682AbfLRLUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576668015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ut+xo9ffqp7U2w/m4MeHwCHpEskA84eDk3YygkoZgLQ=;
        b=MwZRhvTWhPbrRZxtJqLkIYHyd6ja+eqDB3sBsLUgvyov213odpzaPBfvup86KcqQIxMKCW
        Y9qbC6Iq15ihuwgnTvinB3nn0D0obTEcu8/mDY4dWCuRgApviETLBN9ro3jqvzxYpmVNCA
        xuwfUAO5CVrajxVWZdKFjitMct90pMo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-GOKukzd8Pc-tdpFNPJ5JOA-1; Wed, 18 Dec 2019 06:20:14 -0500
X-MC-Unique: GOKukzd8Pc-tdpFNPJ5JOA-1
Received: by mail-lf1-f71.google.com with SMTP id f18so188591lfm.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:20:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ut+xo9ffqp7U2w/m4MeHwCHpEskA84eDk3YygkoZgLQ=;
        b=nWTOG5WmIpKhFN3qgTccLwqhxGvnTfrH93K9RMljd9AzTu4ppz6nH6s9Ec8YHMaHhi
         Uj5bzlaAv3PXAJOS8fu0PkB5cukn/4lRxl7wKIu1OkkGlWqpiScgf0jSu+Xt/uPkSRwg
         NpBkG+gCHKwCTvSdLa8NpCbdQiAZoia3QwkAXI9gqholCbK8Wnb8rfZmFr/6AW+mC0ix
         NkxBRk5p3vGfoNrqUSz528yx/i0LNrV0Fjv7552hnKmSSL4Na15ZnkirZ593dhXAtTtw
         PiprB0eifvTOYcZzbC24bOoasWPISOgKwcsXX32X6S480LJtDRWMxUUOodvZiABUHsED
         hlXA==
X-Gm-Message-State: APjAAAXotIFktWtOkogNruqZJGohVdEHhr3ot5WQhTEi5fLTtElztcxm
        NKLkJ2HNhppKeyxiUcMCEaqfAcAMW0Pd+npJDoq4CBr0nG9eB831Ud6TGFH9V+g6E38h0bTyOXO
        OhtZM2W6P2CUSSrYe
X-Received: by 2002:a19:4f46:: with SMTP id a6mr1404250lfk.143.1576668013032;
        Wed, 18 Dec 2019 03:20:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqyqlaCqKGYD7S5dXgPmnjBqGrEvYVNkoqtJrsUhaWjfIlY5zrdjeCx/y7G5k+BDdHM6r+iZvg==
X-Received: by 2002:a19:4f46:: with SMTP id a6mr1404240lfk.143.1576668012891;
        Wed, 18 Dec 2019 03:20:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 2sm941321ljq.38.2019.12.18.03.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:20:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9C922180969; Wed, 18 Dec 2019 12:20:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 7/8] xdp: remove map_to_flush and map swap detection
In-Reply-To: <20191218105400.2895-8-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-8-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:20:11 +0100
Message-ID: <87lfr96ftg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Now that all XDP maps that can be used with bpf_redirect_map() tracks
> entries to be flushed in a global fashion, there is not need to track
> that the map has changed and flush from xdp_do_generic_map()
> anymore. All entries will be flushed in xdp_do_flush_map().
>
> This means that the map_to_flush can be removed, and the corresponding
> checks. Moving the flush logic to one place, xdp_do_flush_map(), give
> a bulking behavior and performance boost.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

