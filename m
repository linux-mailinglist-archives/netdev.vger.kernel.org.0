Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1523F84A
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgHHRHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 13:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHRHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 13:07:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49704C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 10:07:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ha11so2578429pjb.1
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 10:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=S3FPkAzJHtEanLLjXRCiC1bew611PHRkwn8W0WBq8J0=;
        b=LGPOOFl3O+JzI7Z8C7run5ZlIun+5EEs3mPitA2r/0YFIuE9tsv4nPfRVCBsS6xeDZ
         AzS0hP+UtVvodU3/GJhjolKR1z2hNT5mQ8GcQLIZKbkV2v4e76zKROLFZFq+KnzQl0IR
         2LtxRfEhZ523nzIPlr52FT4rbXKSugs+DIOkr4BijfLnplaI5hF5N0xt/S7x/JMh5qqv
         4yTpyq6PWSkMRz30QcaniDcgi3Q69KyHID0cpTfafxVdL0Ca/F0jo2EmIKvBaUBJkE5W
         PQSYt6CGRX8YiV7WaLxBZIvFWnl7Y9SPqJWAuXN7ZaEPFxL22h5Q/EdxnOjPzZolHWMl
         mvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=S3FPkAzJHtEanLLjXRCiC1bew611PHRkwn8W0WBq8J0=;
        b=W8CVkwRFrm4oZbx68xGcVtaSiAwy0pYMqfmXNIUqzOZcsfuYR2GKTiJQP6ENG0Tfxj
         d7Fp3BxpPiHPIslHp3fBc8cUzZ5xtn23vrmmKhRbuhYTyH1QjodWYYJ3SHLEkI/yQ4uU
         PHK8H0FRi145GPJWkiHNF4HvdJbM1WN+pNo75RpOiWEgrTJAkIaZWHEfVqEp3qvWRx2O
         F78lQ9HAscx4npcLQeYLQSCozvcU0/VeO0Hl2LLmAdJi6mA46T9tspRoyt9H6fr71x+X
         xLdmO3Uwh6AqYTUJxC41JL8erbUMB3gNxyZ9Qi2duDP7T14hXgAgo7/yfTkcFAYeOw8G
         LHtw==
X-Gm-Message-State: AOAM532N7VBGIP3jR+Zys44RLMmUmJbJNtg7Q8pVnB9mKVzxtdODExIp
        mI0qVdSPuoPycKO0qWOhywzuUA==
X-Google-Smtp-Source: ABdhPJyVBmg90q9R0CEtT9ll9UvXH8Pg1QrPMYE5kNDnA84vAkvV7G3XsMqF/1dENlfPNwk9tSQsqQ==
X-Received: by 2002:a17:902:d30a:: with SMTP id b10mr1234673plc.217.1596906473828;
        Sat, 08 Aug 2020 10:07:53 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:4031:e222:9f1a:e214? ([2601:646:c200:1ef2:4031:e222:9f1a:e214])
        by smtp.gmail.com with ESMTPSA id 7sm16866443pff.78.2020.08.08.10.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 10:07:52 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
Date:   Sat, 8 Aug 2020 10:07:51 -0700
Message-Id: <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
References: <20200808152628.GA27941@SDF.ORG>
Cc:     netdev@vger.kernel.org, w@1wt.eu, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org
In-Reply-To: <20200808152628.GA27941@SDF.ORG>
To:     George Spelvin <lkml@sdf.org>
X-Mailer: iPhone Mail (17G68)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 8, 2020, at 8:29 AM, George Spelvin <lkml@sdf.org> wrote:
>=20

> And apparently switching to the fastest secure PRNG currently
> in the kernel (get_random_u32() using ChaCha + per-CPU buffers)
> would cause too much performance penalty.

Can someone explain *why* the slow path latency is particularly relevant her=
e?  What workload has the net code generating random numbers in a place wher=
e even a whole microsecond is a problem as long as the amortized cost is low=
?  (I=E2=80=99m not saying I won=E2=80=99t believe this matters, but it=E2=80=
=99s not obvious to me that it matters.)

>    - Cryptographically strong ChaCha, batched
>    - Cryptographically strong ChaCha, with anti-backtracking.

I think we should just anti-backtrack everything.  With the =E2=80=9Cfast ke=
y erasure=E2=80=9D construction, already implemented in my patchset for the b=
uffered bytes, this is extremely fast.=
