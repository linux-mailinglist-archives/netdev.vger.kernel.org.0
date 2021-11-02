Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFF6443149
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhKBPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhKBPM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 11:12:56 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92EFC061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 08:10:21 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id i6so24317149uae.6
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5qc+0ImKvujrx420tDdh73T5aJXncmnoefjmMnw9HL8=;
        b=kE7ANGhNFYhBqNyhiLO26HqcZ5qo6r8X0OijlOefYHHdqp2tCixK6pX+n4qRnOSvx0
         tr7YfVKOsi3SJ+pxQE8TitxN41tolTo8YfFc3PPfAkX0Wl0J79CdVhUr8sMyf09zdJ0j
         VE4G19VhSi69izxT2UVvvsmoJK5rxZ3DXjbNXGM2Za6XqAwIAvrjADMgSlQXB9k0jGqG
         sd/NfINk2krv6ODyOlVrn/ubI+n1kNjhJ/KfEZ9S49GSlMhX8/X6QpiIQg8oPZ5BOnlZ
         FSj7ZenhfZlwOCnxzm/q4yAXs8GssdPOiEPDzmrZs4HJx9kxogiri2YHMd4xL8BiVK0c
         2apg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5qc+0ImKvujrx420tDdh73T5aJXncmnoefjmMnw9HL8=;
        b=6fFxFc0sDcGwcpTfEarPOZOp7lfZgEcVT4tLu4mwJLl9n0tbYFPjy9w/1CXfRo5cJ7
         cV4ZlVP74vAju8GuygGQ0MRlw9jX85byhcFVcYmhqz0gGncE3kKI3vvNROvAuMx5SohT
         r7TsFeMy7pczIPQFcohG+53OzneuQIBr+rvkdH77+9rM+6A72X8S8vngOgaLy03py0u4
         w1TTIKWwaRqjvGF5S6Va1fD4D4gr+sCbvuz0r8zLK0Pmi1KlZLJHyEpa8XnZI6Z16twK
         jBsCDhh36Otuf8aAT2xsjIEjzxDQsPqXpaQwkAnUpYZXrwxM+Wn4Ap52ar4FgcKmQnoC
         9bSA==
X-Gm-Message-State: AOAM533Vhccb3PNB0XInJsNAXFSyElK5huVHWf6GkjW/KbV+Gz7jUiVo
        LYwjqe7kCYiAe+pubKuxdBH0mnbyxDA=
X-Google-Smtp-Source: ABdhPJx2v2lgG3pgdj9AJU7uTUXzs6BX0juhpOR6S8OGBGiHInsZCpawPvVmgZvdR2PeLh4t3SfcHw==
X-Received: by 2002:a67:ab48:: with SMTP id k8mr41401698vsh.30.1635865820886;
        Tue, 02 Nov 2021 08:10:20 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id p69sm2533046uap.1.2021.11.02.08.10.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 08:10:20 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id b17so28444023uas.0
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 08:10:20 -0700 (PDT)
X-Received: by 2002:ab0:15a1:: with SMTP id i30mr26858363uae.122.1635865819917;
 Tue, 02 Nov 2021 08:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211102013636.177411-1-liuhangbin@gmail.com> <20211102013636.177411-6-liuhangbin@gmail.com>
In-Reply-To: <20211102013636.177411-6-liuhangbin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Nov 2021 11:09:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeS2s7czeAASfz9qep06gdUKVHD8bhiqtEOS1w82-JR7Q@mail.gmail.com>
Message-ID: <CA+FuTSeS2s7czeAASfz9qep06gdUKVHD8bhiqtEOS1w82-JR7Q@mail.gmail.com>
Subject: Re: [PATCHv2 net 5/5] kselftests/net: add missed toeplitz.sh/toeplitz_client.sh
 to Makefile
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 9:37 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> When generating the selftests to another folder, the toeplitz.sh
> and toeplitz_client.sh are missing as they are not in Makefile, e.g.
>
>   make -C tools/testing/selftests/ install \
>       TARGETS="net" INSTALL_PATH=/tmp/kselftests
>
> Making them under TEST_PROGS_EXTENDED as they test NIC hardware features
> and are not intended to be run from kselftests.
>
> Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

The same might apply to the icmp and vrf tests? I am not familiar with those.
