Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2E9413128
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhIUKFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:05:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231617AbhIUKFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 06:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632218656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7yJCQdijetLtHnZ7urCRUsTvPhfYVH0W87rIumdFV4=;
        b=izKvwbEI6Q0b1gwN3q60WDCwgQ56I5euMCOumsHAjkbNS9HcB/yYO+Z1DHdKzc6o8v4DWm
        NgDT57cGNQJWeZJ9n1lGGXHtrHMxk7KvzMoLK1biRPoUyE5dcwEZriL727WN6+XGhTxNjL
        4dau+76+c+sWpClc8hWAd58qCjFlbwQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-ou0bP5SiPGa9ZYz33gmYPw-1; Tue, 21 Sep 2021 06:04:15 -0400
X-MC-Unique: ou0bP5SiPGa9ZYz33gmYPw-1
Received: by mail-ed1-f71.google.com with SMTP id n5-20020a05640206c500b003cf53f7cef2so15790177edy.12
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 03:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=y7yJCQdijetLtHnZ7urCRUsTvPhfYVH0W87rIumdFV4=;
        b=bjAFDch3wOwC/6mq449WDz0FSMPkNbvAiGgtNh78MWLPzE4uj5mTloY7h2FegM+hAM
         eRR7WLVpCvAYos94uclCxEb+Kp/MAFiT0CGi1bd0bvjLXRwNyv0/2RTiWdeyCqWpreue
         FYNOdrYAJg+40rce8Oc6RtxN7sAEW9+4aJTOMUP5NfCjAaB2p4R+MxQ9ICkLE0Asw8Ai
         u531Edw1LqMDSJsgUZSS21O84nbga9e5OATQZljNauUe3qXbKJ+dyp73Kis/U0pM7oJ1
         qs2AOxEgRCgRmfHKCx+U7LtxzBcol9X9Yw1h/y1fuauUgIEThhN9BNC3SEWj2MiXUxdD
         kXGg==
X-Gm-Message-State: AOAM532kp2pM10jbdizOGGTxdRjCE2Lm0LlGxLImDrSfH++Pks1O4WZU
        qwZYI0T9vjCH1QUr7TrZAGqjoeDuOn6aXiK4ZSMsoWYBofMDX/P4hKypzebGKp7gu6lyo964273
        Kc69rvNeN2KHIEHx+
X-Received: by 2002:a17:906:2ec5:: with SMTP id s5mr32136248eji.192.1632218653922;
        Tue, 21 Sep 2021 03:04:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD2j4Pl/KyHPDo4gsfxiAP1KDP7mj+s3vYfgNVUeHEO43O84s3qTCxKRKPsE53jI+KSEu0cQ==
X-Received: by 2002:a17:906:2ec5:: with SMTP id s5mr32136236eji.192.1632218653673;
        Tue, 21 Sep 2021 03:04:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w9sm8129992edr.20.2021.09.21.03.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 03:04:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9F50418034A; Tue, 21 Sep 2021 12:04:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2] lib: bpf_legacy: fix bpffs mount when
 /sys/fs/bpf exists
In-Reply-To: <617d61727a8c73fd28a1eb4136f8159f7f6779d9.1632216695.git.aclaudi@redhat.com>
References: <617d61727a8c73fd28a1eb4136f8159f7f6779d9.1632216695.git.aclaudi@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Sep 2021 12:04:12 +0200
Message-ID: <87czp24543.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrea Claudi <aclaudi@redhat.com> writes:

> bpf selftests using iproute2 fails with:
>
> $ ip link set dev veth0 xdp object ../bpf/xdp_dummy.o section xdp_dummy
> Continuing without mounted eBPF fs. Too old kernel?
> mkdir (null)/globals failed: No such file or directory
> Unable to load program
>
> This happens when the /sys/fs/bpf directory exists. In this case, mkdir
> in bpf_mnt_check_target() fails with errno =3D=3D EEXIST, and the function
> returns -1. Thus bpf_get_work_dir() does not call bpf_mnt_fs() and the
> bpffs is not mounted.
>
> Fix this in bpf_mnt_check_target(), returning 0 when the mountpoint
> exists.
>
> Fixes: d4fcdbbec9df ("lib/bpf: Fix and simplify bpf_mnt_check_target()")
> Reported-by: Mingyu Shi <mshi@redhat.com>
> Reported-by: Jiri Benc <jbenc@redhat.com>
> Suggested-by: Jiri Benc <jbenc@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

