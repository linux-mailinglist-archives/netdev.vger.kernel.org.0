Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4444C32833B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbhCAQOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:14:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237504AbhCAQMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614615033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8c36pkCtyN4CLfbJiUbjXLv8s76s8DQupsd9r9qB1M=;
        b=e3IehxZBk7NvTQd29o2J9Y7Tx4bRz+NGflWHTPJ2RUBUaiPXWVa0xf6xo789jfMCTMtrxm
        hQ0o1TY6Du+tFXSWOSpO9Nb6auguNu3ujODhWyBOtP5adbMNze3cr2cLZHRKj9yqH7alOQ
        qRr2Ut3eRtQHmQP5pp/XGuhi3HNj7IA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-iVNFtA5cMPOhlkfGSVBWGQ-1; Mon, 01 Mar 2021 11:10:31 -0500
X-MC-Unique: iVNFtA5cMPOhlkfGSVBWGQ-1
Received: by mail-ej1-f69.google.com with SMTP id 7so6830197ejh.10
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 08:10:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=I8c36pkCtyN4CLfbJiUbjXLv8s76s8DQupsd9r9qB1M=;
        b=Ms3ZjxhXeVk+RJjwngN5eUVf8jRBoMvMCi1vzUTmUmaIqYVIpINcwZ5McI8nRFANBH
         7yzWmhYtxj2OozUzrRc4FOP+UFz/UXEXuOZ0ICF+TtJ+H1W/hfnBJlnSnYwyVTF9rvkv
         jjoATmvahh49hvoGrJIKOmRWahcjrihxz6K0bWb8Q8n7RnddHT7rBR4gnG7+VhS25kqo
         mevPwoGxQSB8aNPY+llrWanbLCG7o5bEdrxzqSlGTfzWS3CPYTRdE5xZUHoIeE0eOztC
         2E+WCJ3JUTGoPKIck3hrB6PRf4PTlm5Np6ZKsGGJWQty8FjAkY8GYOC8AlRUOicjv6Ou
         j1gA==
X-Gm-Message-State: AOAM532li/bthiQBQM6vgd0Tg/3d///c1TY9hMoDv0T+e7+k61bXzuck
        XRQuU7323Vywhpc5gKE6Vnq7mTkf4mzhLllKAebqEBRGI7aSZG2yPnVbAsGFuLW5OoZs0Z23+CP
        Dnjws91zvRnO1KxUH
X-Received: by 2002:a17:906:4d18:: with SMTP id r24mr13286015eju.493.1614615030180;
        Mon, 01 Mar 2021 08:10:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg0VI0o+9gqz8X/y2IF8Ux4tSftLQrrJu2j8l6qUsTwkeFP33V3tzX4SUGPpcbw2CJOtYR/A==
X-Received: by 2002:a17:906:4d18:: with SMTP id r24mr13285999eju.493.1614615030016;
        Mon, 01 Mar 2021 08:10:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v11sm15125001eds.14.2021.03.01.08.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:10:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1571C1800F1; Mon,  1 Mar 2021 17:10:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
In-Reply-To: <20210301104318.263262-3-bjorn.topel@gmail.com>
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 01 Mar 2021 17:10:29 +0100
Message-ID: <87k0qqx3be.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Now that the AF_XDP rings have load-acquire/store-release semantics,
> move libbpf to that as well.
>
> The library-internal libbpf_smp_{load_acquire,store_release} are only
> valid for 32-bit words on ARM64.
>
> Also, remove the barriers that are no longer in use.

So what happens if an updated libbpf is paired with an older kernel (or
vice versa)?

-Toke

