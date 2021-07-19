Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F333CD4DD
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhGSL57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 07:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhGSL56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626698318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9xnPevyU/vinvxm9fpLnz13ttiz6/qE1ToIVXogNE+c=;
        b=VW52XsGHspD7Ve7HsS06gP2L8giQ3TxY+Lz61oZ3kynuBr4TDdTGj4x/J+Fzdc2wzznZVw
        9aYc7ALau2nEFk/bJ9MCDYW4p5IAmkfxbd0HQgKxoiff6wYEyil6QR+2KaMp4RB+GABhKD
        WKtJwjyeiv315pQ0rND4x9BogsCgC4I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-kfRVjhe_PMuSIeo8Xv6daA-1; Mon, 19 Jul 2021 08:38:35 -0400
X-MC-Unique: kfRVjhe_PMuSIeo8Xv6daA-1
Received: by mail-ed1-f70.google.com with SMTP id e3-20020a0564020883b029039ef9536577so9201161edy.5
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 05:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9xnPevyU/vinvxm9fpLnz13ttiz6/qE1ToIVXogNE+c=;
        b=HY75voa5PpJzrz99WxUOcR8iGwwuv1Q8vAOLh6jDcpeBVaLBVEGpHFEOHu0sdoVUP3
         SYELsiS7RmGvkP2OR2Ctd/ZyMmDya4tc3MfTKQoWo+87EjJ4U+sgrdm1fgqr3d1oSelf
         36YMX7Mc1DCddL51NpwIx/eIBg6ZDByhYgfGacyf7ut89tVAPhtmT1C9YlDk6kXoz21Z
         51Ksx/7n8MeAlMnY5FaGZVO0cQFENGOeHuRXicrqDGUSW3T8gs3prTQGVE+aCyDV4VfG
         8aDMKpzk7fx90HVi6xrmZMX8NrHxuZIAQR46HVFpKdsLtWTjg7SzKumZEUGmg6+COutX
         OCdw==
X-Gm-Message-State: AOAM5335cpIm/QCpxDlhhW525tmZigRX7NAT8yp382KJ1x5dqyMkC74y
        CVuwLeUd9K1QCjb6853W1V/TyAdFFlxfYSK3qEEdE/WunNYCoIfI7jKCu429wjVOyYCGxgmGLRm
        oMuCjtqQkT1KAx6B0
X-Received: by 2002:a05:6402:692:: with SMTP id f18mr34700412edy.327.1626698313963;
        Mon, 19 Jul 2021 05:38:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnczeyvEpOgLXM/x4GwI3PK+KqvUJeavIe9mVLcwzRkXbCNtd51hBnv/Dbxxr24TjaxK5HTQ==
X-Received: by 2002:a05:6402:692:: with SMTP id f18mr34700397edy.327.1626698313850;
        Mon, 19 Jul 2021 05:38:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d18sm5856039ejr.50.2021.07.19.05.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:38:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 506F7180065; Mon, 19 Jul 2021 14:38:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "luwei (O)" <luwei32@huawei.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dahern@digitalocean.com>
Subject: Re: Ask for help about bpf map
In-Reply-To: <6b659192-5133-981e-0c43-7ca1120edd9c@huawei.com>
References: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
 <CAEf4BzZpSo8Kqz8mgPdbWTTVLqJ1AgE429_KHTiXgEVpbT97Yw@mail.gmail.com>
 <8735sidtwe.fsf@toke.dk> <d1f47a24-6328-5121-3a1f-5a102444e50c@huawei.com>
 <26db412c-a8b7-6d37-844f-7909a0c5744b@huawei.com>
 <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
 <CAADnVQJYhtpEcvvYfozxiPdUJqcZiJxbmT2KuOC6uQdC1VWZVw@mail.gmail.com>
 <6b659192-5133-981e-0c43-7ca1120edd9c@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 19 Jul 2021 14:38:32 +0200
Message-ID: <87wnpmtr5j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"luwei (O)" <luwei32@huawei.com> writes:

> Andrii and Toke inspired me. You are right, the libbpf version should be included in -V output
> , but not mine. I searched google and found this page: https://www.spinics.net/lists/netdev/msg700482.html
> , according which I re-compiled iproute2 and it works.

Did the libbpf version appear in the output of 'ip -V' after you
recompiled and enabled it? It does in mine:

$ ./ip/ip -V
ip utility, iproute2-5.13.0, libbpf 0.4.0

-Toke

