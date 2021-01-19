Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19732FC1BE
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbhASU7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbhASUy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:54:59 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A46DC061575;
        Tue, 19 Jan 2021 12:54:19 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id v24so24420144lfr.7;
        Tue, 19 Jan 2021 12:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tq6XGOe+hkhz7vgQz8TvtHNk9IhOBKLE3tUZ5x4o9Xs=;
        b=LRGbJtSB9JWJKJSjAP+Yw9gAqIxTHG3RYmrD+RZaB2Zuq8Ujh00kZZvrtpyLG2srCC
         YqTywARBIcanCATZz9fd2+UytoHP3nkQ4OP5GZpjXxKCsuzFJyJiqdTYZQJZovsUm9Xk
         +PxvQN1FZxb0IpdG22DQ9jBbEdb+q6M4ujGXsFb6c3KmQQeOdCdPvNc42ysreWvuSS9a
         ASU0BK9SqlNrD+c92MsLvVNeFy7uEcrZH9HhheiCWbvXnF4cAYVzm3Cq8uZj2EIfBrVw
         FCvQi/CXWQRVksVvg9klEv0MvlcwpYt1qqaQc3W1lgyGsHnuGvN+Ne7qsM8tbXW8Y18Q
         rN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tq6XGOe+hkhz7vgQz8TvtHNk9IhOBKLE3tUZ5x4o9Xs=;
        b=qSDb86YrBhPOPhktecnAF4T85PsmSDwGpx+Tit+DXbHVKIYHkjGNTIhFAuAlOnHAJN
         rh3QR9KVGh2u+jur15B5IgZKJGqTJSdf2+A9t6LUTk7SwdYTX91geWJ00xlrmCcv0Hkj
         NSQBzSDN6vr3FuEskhDx7uZtOwhv2/Z8vOZRkykmLIblHjXYA68Spt+kgK7pOilPz4P3
         WkJj7aOVQx1Z9ohWz/FOu7LAxb5TaNM24IS3VEq6eP/RYno/WOpX58RqkINE3UWg2R/f
         BadX/48/aXvn5Fw0qp8a3b1oGJVBzuuXyPCdE73eaftN8SlFe0xhl1Dn6P6fFYLr8h9M
         wSwA==
X-Gm-Message-State: AOAM532eLXx/WTvrzVno8sVopEdfTPqpxeOfTh1qOkC6bVFPU6cAj9gK
        kYC14hWQh0J4dhXZT3ec23g6O6ypiuq2V0v1XQA=
X-Google-Smtp-Source: ABdhPJxS/Z+apTdE0WQ6bPYGw6++qlGcLnKdz7x21L/EzsLZbWrHnjX3I5xtwTqUPWm4nP5ujlndUqAZNv9u8jVBwXo=
X-Received: by 2002:ac2:43c1:: with SMTP id u1mr2721801lfl.38.1611089657945;
 Tue, 19 Jan 2021 12:54:17 -0800 (PST)
MIME-Version: 1.0
References: <20210119102501.511-1-glin@suse.com>
In-Reply-To: <20210119102501.511-1-glin@suse.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Jan 2021 12:54:06 -0800
Message-ID: <CAADnVQLx3cEBNYPHtjE1Hpz393U8R_2xkgzF4Fsm8iNd7GguUw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] bpf,x64: implement jump padding in jit
To:     Gary Lin <glin@suse.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 2:25 AM Gary Lin <glin@suse.com> wrote:
>
> This patch series implements jump padding to x64 jit to cover some
> corner cases that used to consume more than 20 jit passes and caused
> failure.
>
> v4:
>   - Add the detailed comments about the possible padding bytes
>   - Add the second test case which triggers jmp_cond padding and imm32 nop
>     jmp padding.
>   - Add the new test case as another subprog

Applied. Thanks a ton for all the hard work you put into it.
