Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1211D38E273
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 10:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhEXIo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 04:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhEXIoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 04:44:24 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4959EC061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 01:42:56 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i9so39558344lfe.13
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 01:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2MagAsqzQek4RfZIbzihBJ/AzdlKDWN0pczixUAk4k=;
        b=tuIFNpzC9jLms5dbs5QZzBpxUDBVkTZeQznojy2iUxzHuA/VqdRvv8KlAVBamdXkyQ
         Uzp7DTSR7Wd5NV5vs0zpAQpJ6Ao2K84Jn5zYdm6bGxV+4OiN9GK2MTia5PNFcX6y7WkY
         Tpo+YifiOcjlXZgnnn6M9I+GClyx8ljOcogjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2MagAsqzQek4RfZIbzihBJ/AzdlKDWN0pczixUAk4k=;
        b=VmyUubzoSQuny5Xxvk72a7ru4MNcOAjMjAhzMg2kHSxDb3+JwXgJY1ElZS2pR4al/0
         5Z9NNiGc4REOea8UdCTdDgo89TXCJns2PAXvrpP3vYQ5420r7gekL9Gllq9XgfuxNoRr
         Xm0yHInLArNonI6mo6c51KrrOg2/pgx8YgpfYJTgIQhB/J8HHJop6OPObLwRIf4R3GyK
         XeMECQtA7tYaWZ6hE220iJrFREaIAlWCTar00Ux2eJHVoptDqNWXydFBfvTGS2mqDhLc
         dDOvtUXaGKCFTuvlrByezdg1kD92oyCiJoDnvW1lfQaoKrVgzhAdxs1I8SWzUSrFrcnk
         V5oA==
X-Gm-Message-State: AOAM531Ip4TtkFfkJeC7q+vOUnO1gQG7PrgHhppNCBgvpPb5Zrco0Y2G
        suFfyNXePvKS3Gz9OX0BdNKI7gwx7XJmKMWttsl84Q==
X-Google-Smtp-Source: ABdhPJwDAJhJQ/AhvOx9lYi+OPMvHK3iBM6jwUMxjxkbO6Ny09AsZUdSaXH2I1z/XzdfkApRy31G4ouZTtt4UKdCYAE=
X-Received: by 2002:a19:7416:: with SMTP id v22mr9995140lfe.13.1621845774673;
 Mon, 24 May 2021 01:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <87o8d1zn59.fsf@toke.dk> <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
In-Reply-To: <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 24 May 2021 09:42:43 +0100
Message-ID: <CACAyw9_Vq6f7neqrgw6AjJBw7ELa+s7u12Vnt5Ueh49gaE2PQg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 May 2021 at 16:58, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:

...

>
> msecs are used to avoid exposing jiffies to bpf prog, since msec_to_jiffies
> isn't trivial to do in the bpf prog unlike the kernel.

Isn't that already the case with bpf_jiffies64?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
