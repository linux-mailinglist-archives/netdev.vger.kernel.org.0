Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2262D1448C1
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 01:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAVAKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 19:10:40 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40378 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 19:10:40 -0500
Received: by mail-lf1-f68.google.com with SMTP id i23so3864381lfo.7;
        Tue, 21 Jan 2020 16:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nal9yB7kJdeVk99Y/sDFy1uRo1yz7MQUPvmQCEZ0ElM=;
        b=Giz2AQrCksTENgILThu/eIDptpz5MHByvJtnNtPpgbusYplW7OpyyfqVXKnuEwb/Yx
         zNJXCwlm+zD5NcS/pkho4i/RdpYATPfsSrxUtqKS+Cn/Ietp7Yg/ImAgQnYKT4N6geyo
         Oyr7luiMt9eqZAv8y1lIJMEhz6U5jID6G+xQUiCB+d4BSz9WFRP6WauG22EVX9ZFe2cA
         D4l6vnCRLyIh9owO4n2Ztr8Puoea6qV1sGfKOTvlalD9HgOK5HkWfEPmgvRf6u23IbD/
         3ic/cJ9Wn8PSEKENkM/cLnHcmVk5XXHFgw5lG0wLqN3psUnVWjIF5wDIo21WMiZgv+5P
         +NTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nal9yB7kJdeVk99Y/sDFy1uRo1yz7MQUPvmQCEZ0ElM=;
        b=Nda5oWuKWXhS7qZJVf1NkeUYQmGKViegAXZsGhoo0JBsCL3BwNlX9FRRYRO+OdK0U8
         horVp1oYEwfNcyIS957xwSA2dXvrEZtSraeqWeEaqUGDPqlpyys0d1fYC9jtwshZ//O6
         7yV7SiNi49AYXAUyTtHdZtJuwfCtueeULyqe31Bly2KtM2b34iIXiv1pxXEednGEOpuV
         QlYQENQLhdE/6JHdsnElqCP7m3PrhccwsFIWIwt2hDOjalNUcdJ7oawGb1hVJ80Z+SME
         7neNnfakMMPU4IL+3JBb8LrdJE3dd260uS1FNWs1x97+f93nRmk1fAIx2hwuYbSITcMg
         xTZQ==
X-Gm-Message-State: APjAAAWI3XF8SQS44PGQ1KHYZlg7bw/dCcZ40tob0gbZGEOceu/3PyAM
        jeRz+GbPEeQr7MhcX50kqv4IiUOh2I1bEOHqwOwnI+28y8A=
X-Google-Smtp-Source: APXvYqymnQKgwkPlRb6K55b1YURfAkzYb2cdFDS+SI/kLRf4TPiacfhHblMLiqUcF1u+UO4D0SlhHAzQ40X7zRgnXiM=
X-Received: by 2002:ac2:592e:: with SMTP id v14mr175421lfi.73.1579651837910;
 Tue, 21 Jan 2020 16:10:37 -0800 (PST)
MIME-Version: 1.0
References: <20200121120512.758929-1-jolsa@kernel.org> <20200121120512.758929-7-jolsa@kernel.org>
In-Reply-To: <20200121120512.758929-7-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jan 2020 16:10:26 -0800
Message-ID: <CAADnVQJO7cObUhqLbEB6+hKaPj1SStNfuhzXShC1XmAt217y8g@mail.gmail.com>
Subject: Re: [PATCH 6/6] selftest/bpf: Add test for allowed trampolines count
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 4:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> There's limit of 40 programs tht can be attached
> to trampoline for one function. Adding test that
> tries to attach that many plus one extra that needs
> to fail.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

I don't mind another test. Just pointing out that there is one
for this purpose already :)
prog_tests/fexit_stress.c
Yours is better. Mine wasn't that sophisticated. :)
