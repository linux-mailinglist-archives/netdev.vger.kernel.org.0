Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E93366254
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 00:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhDTW6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbhDTW6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 18:58:39 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18931C06174A;
        Tue, 20 Apr 2021 15:58:06 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id k73so38671052ybf.3;
        Tue, 20 Apr 2021 15:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RkDuC1Dr9J18+9eBYWIaxeIrmVv0oQ39iP9/w0aGwI0=;
        b=rSTUaJOqTKQ0k3Xy2fzNitQEnGvrkz6SKoqc+Dj1La3K+ghbFAGgLGJpfltyKFP1Jk
         Oy/u++v11zOtugul3vOguGBl+G4TGp4M/Ybatq/Se+E4x+8MNYhDzaOcrwD1eaalzc1c
         N6Qj5oOTw5O8UAoGUv4ApJmNyB+nBRmeky2joYtneRxCo3iNVhWIEWH2Op+TDiTi8ks6
         3fSWfRRpWyeTmRoIzsAi0oa2g5/iaVm8YkrzACOgTBaKoqeuJ083SKN/+lfvQZLN80Ey
         geNOcKRzcX/77A8Qd8oEdPk4wwYNcVR3/yDbC463iB2lURfSdeatNlh7aQXvjtb7EfGv
         efEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RkDuC1Dr9J18+9eBYWIaxeIrmVv0oQ39iP9/w0aGwI0=;
        b=si+HsPMzIzhViBkIYxOMzdWn+DgT0XvMzQ2S8AMORF+kVd+wgHO7RDTHCFylDWoAUr
         gH7ZQbwNJYJ90Y77h2TypiZMgb5DTkdBDIeDdW+sOBYAa18KQfKo/n2WwKRSoPG6M+8U
         e9o92v8/oF5qVX3/l79fheKKYywUb7J9jTY9Oqe9lCu9g2WiV/Ch7mLv7W0LrUTDMhff
         1Cwj0zsJZKerqgCUozqBskRBMxtQ5En8T+c74n+HeoMsvvDyZ1zBZ4CRl0EAXh/fqdwH
         glRBvYuX4AabaptsnnltHXokf+bHpP4zJ0TGZx3ixtgVZGUkojCzm+OaBpwUxm8TpSCf
         bhJQ==
X-Gm-Message-State: AOAM531vmIF9WtS/8KSCXWx7dWv9YwLh+zTcEtWaXG3ydr72O5/F79uz
        qfSCHV3pKpcipgvHFEdxvslh6xAFbR1oRzcamccLipQRaQM=
X-Google-Smtp-Source: ABdhPJymh8dGWWEF8fb1R6OHxqVVFyd4G+xnBKN4a5IoDbpIwipxiouMhJQreNaaPDnxMTP0Td+sN3fhWghHXPAl03g=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr19867701ybg.459.1618959485359;
 Tue, 20 Apr 2021 15:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210420154140.80034-1-kuniyu@amazon.co.jp> <20210420154140.80034-12-kuniyu@amazon.co.jp>
In-Reply-To: <20210420154140.80034-12-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Apr 2021 15:57:54 -0700
Message-ID: <CAEf4BzZ_=K6Yfg5VfCXAY9mA=+xArgBbtMW+31f8dwtc7QjP5w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 8:45 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE and
> removes 'static' from settimeo() in network_helpers.c.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---

Almost everything in prog_tests/migrate_reuseport.c should be static,
functions and variables. Except the test_migrate_reuseport, of course.

But thank you for using ASSERT_xxx()! :)

>  tools/testing/selftests/bpf/network_helpers.c |   2 +-
>  tools/testing/selftests/bpf/network_helpers.h |   1 +
>  .../bpf/prog_tests/migrate_reuseport.c        | 483 ++++++++++++++++++
>  .../bpf/progs/test_migrate_reuseport.c        |  51 ++
>  4 files changed, 536 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
>

[...]
