Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550C010F30B
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 23:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLBW6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 17:58:54 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:39765 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfLBW6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 17:58:54 -0500
Received: by mail-qv1-f67.google.com with SMTP id y8so649570qvk.6;
        Mon, 02 Dec 2019 14:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0qnWSxRRAXLp5G5QvipAnlqLWrSW9gEmrB/VVz4a0Ig=;
        b=QHdkbEp23x0rVpagGKosMguQgVm67PxekkCIBfekExh9iYgTwcoO2lhyGF3H1kDvgc
         9a1leDZEEEYiXOudkTwCnNMC/KrFVE9hRAXLAcOX+k5mjw7kDlBRRqFhfTUMvEGagBeN
         55xk0irdxDb3ZuIpyCE9TFKGiBGF27ot9joJw30aHR6z9Rp0viy5RiOFpqH8gjQrHsfv
         0zyxeevQt6wThvbNNFlAQIVQu9RCpTmZ8Y5oT6mGutB0X6HHEykdwJIm6OzOnjhkxB9+
         wjtNTX3JFJlbVpDxUXJvhDQTMAni/ZzH4Eg1YPlf9mvomGH10PzbIm1vEIcXLjk8cTbu
         gshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0qnWSxRRAXLp5G5QvipAnlqLWrSW9gEmrB/VVz4a0Ig=;
        b=l+O8wctFwfUlsJ2/d8Fgdc66FH5me+hUPQSeA1mkuCTktcosgggE3U4BKV5BSJZeed
         4hQJ2ptSOBmmRuO8rlIIzhnwwelTfxowwQ5XMJk1GUUR/sc+S4La4f6g+CdiFKtTpzXE
         ohFh86spDiKHtM34SHppKetlfSY6mdD7qB1DM2ieTzuGAgcSW/6+iyxxZLLDW+o2WQKF
         rrXRdyRKxTo6AUdyZOygQtKFM/1WNuzsNoYyF5QtWO5f9nLdJ8g9Af9v+/PwVU5+VnJ/
         WiyBm3TZA2LWhF8ZP8etmZ0nCWbpIk6UOUxGRCN4OE0gnsBEAPFzO0TjFUPeOX1fbB1M
         42uA==
X-Gm-Message-State: APjAAAXq79cb47Atj6ddiIXe36YsbQob8beIgdUT5yXFXcjwRUK29afF
        zTy7eTU2AdmoqqA81PWx7nSeSxpmQJzr1Ed1LOI=
X-Google-Smtp-Source: APXvYqwpU2a085eDgk4vIJTDm9ndMGggaHA2LJbe5C/5SNiwTgpgNWMn7XPz5r2p6AdiJcVBepIdi6HDdt6cW2uner4=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr1904987qvq.196.1575327533175;
 Mon, 02 Dec 2019 14:58:53 -0800 (PST)
MIME-Version: 1.0
References: <20191202215931.248178-1-sdf@google.com>
In-Reply-To: <20191202215931.248178-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 14:58:42 -0800
Message-ID: <CAEf4BzbYk3Wd5mPeFRbFCfFZ4sz4E4BcCO48G6LkiACHt9BBXw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests/bpf: bring back c++ include/link test
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 1:59 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
> converted existing c++ test to c. We still want to include and
> link against libbpf from c++ code, so reinstate this test back,
> this time in a form of a selftest with a clear comment about
> its purpose.
>
> v2:
> * -lelf -> $(LDLIBS) (Andrii Nakryiko)
>
> Fixes: 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/.gitignore                                    | 1 -
>  tools/lib/bpf/Makefile                                      | 5 +----
>  tools/testing/selftests/bpf/.gitignore                      | 1 +
>  tools/testing/selftests/bpf/Makefile                        | 6 +++++-
>  .../test_libbpf.c => testing/selftests/bpf/test_cpp.cpp}    | 0
>  5 files changed, 7 insertions(+), 6 deletions(-)
>  rename tools/{lib/bpf/test_libbpf.c => testing/selftests/bpf/test_cpp.cpp} (100%)
>

[...]
