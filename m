Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A174B124599
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfLRLT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:19:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45212 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726682AbfLRLTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:19:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tGaENIXVL4R5jkagyaHEkiUhgqCbNBAQnfNq8HfjrSk=;
        b=EUbkoUw/srDtSYMmoNVZ0a/4bPZLRMCffk9wKsKuIXBudwQk4tGq26OgKPuBLbhn1XsFB0
        GHZl0m3ds7ZdkkczKvZYz/bmuyianuFK/iYoYVMKMCurGv9ot3cS/61d3P4Ux/+pIE40ir
        4hQAP7kiL5OChqWAftUxRmC8HRe9j4o=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-KTQl99TPO5GgzkcBBarJbQ-1; Wed, 18 Dec 2019 06:19:51 -0500
X-MC-Unique: KTQl99TPO5GgzkcBBarJbQ-1
Received: by mail-lj1-f198.google.com with SMTP id g28so586906lja.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:19:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tGaENIXVL4R5jkagyaHEkiUhgqCbNBAQnfNq8HfjrSk=;
        b=IVrMTU9To+Cp91eoRFQ7T60eVRDix8Fe9/yRAjd+85Cw12mJl5xUekLcxJPb+9WOH1
         eP/8Vv/9Oq5slj3pVpMr4XlKc34UatpyI8j7NzYA51FAkrjxQerSZxLig1LMfbspv4U/
         cd0Hnll378Kd2Mlgymgklz4Lz5/Z0FHRcLRNQp10/uza6J3GrLLuMhF8NeCrAD7Gnwfi
         DG7RygesdSB3cpOdxe19qVzmwcaXn1gfhmrAvOs5ub7IOBXR1p+iNQodg/aC0INLx1Wh
         ZigMl2njpO9rNSGkfd1w/H1JlzTK2PbPBOIJXmczBQG+QfhQVVY5ElEbydfzejglyaBE
         4UYw==
X-Gm-Message-State: APjAAAUCvdBLa1tcK5f5gS91O6Hgqibn+aOKnYR3I8dEc0RW8cFe1oW3
        bkZ5d1J9esTskYYWHF1RRmujX2FBcw/AnGvnoV5mjxJUP/CWOWtI5WUtNr5gqcOJdtTwzOXaVir
        Ut/toM6cVKMud90GG
X-Received: by 2002:a2e:90da:: with SMTP id o26mr1337953ljg.25.1576667990213;
        Wed, 18 Dec 2019 03:19:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqxSjOukFg+meWtIM98dabrAAHbQKcIr84NUTloWwJlMSxMnFMKgCYamMRQpHy8VhsK4mKNHxw==
X-Received: by 2002:a2e:90da:: with SMTP id o26mr1337946ljg.25.1576667990095;
        Wed, 18 Dec 2019 03:19:50 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z7sm967741lji.30.2019.12.18.03.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:19:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F2EC5180969; Wed, 18 Dec 2019 12:19:48 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 5/8] xdp: make devmap flush_list common for all map instances
In-Reply-To: <20191218105400.2895-6-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-6-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:19:48 +0100
Message-ID: <87r2116fu3.fsf@toke.dk>
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
> The devmap flush list is used to track entries that need to flushed
> from via the xdp_do_flush_map() function. This list used to be
> per-map, but there is really no reason for that. Instead make the
> flush list global for all devmaps, which simplifies __dev_map_flush()
> and dev_map_init_map().
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

