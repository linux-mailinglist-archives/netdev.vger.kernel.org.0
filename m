Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E166627A
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 01:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfGKXrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 19:47:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40059 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfGKXrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 19:47:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so6294417qtn.7;
        Thu, 11 Jul 2019 16:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9mOzCmWu7iP2cO6YA87BG1jCD7rtcJcCtL3+itxwnEQ=;
        b=DUKjSbuz4ZX9Efg/TfgRHhsM/7Mh1MYSAsvORQnwkxK5y/Muv4jwNrXTdin2IrZQ3k
         wutgC/VJ+vDaojIy5zRaWnFwDMv4BJqsb2qKOjg5sSC7MaYFLpC5F6VEn7aOFH+U4UQJ
         CWHeVauQaueQjDyqtWKhixGMTO/fWkv71C6C5aXW2VvcYVyscv0/a22XGdqj0wY5jdh8
         Zo6ruAIrntyA6cPjSnl3WrnCqVCNg0BQY4zAqzQwaMhrcXMglj0RIGoWHZN9PFWBK0WI
         CIVQGcAidUYQxEVByoarA09NA3yMnNPYInFPpMex4h8WWHgGCXHjsg2AaqKS9ao90cXn
         jEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9mOzCmWu7iP2cO6YA87BG1jCD7rtcJcCtL3+itxwnEQ=;
        b=tHOZrykSrJrUzLdC8wXmDy2IjzjyGNCphImLDFwle2dJ1JIxVibVdlWOeZXW3r40NB
         0IzkUSXEWrFIbjwAooc/XTGzw3MpJzcSXnMChl2z+jkS1F+QmXqqYpNOkd610f96UA8g
         MQjNw6qJHgXB4Tn/goqrI8GFsVCxYiS4Cfe9NlJdzbpH6bWYrjaDjHpHI8FrlHcVP0kJ
         7mVad/KO6X+uD8EOEHSYIxZDQ8MCPheRKpgy9Sc0huli7wfHkMRXfUvAS1H1Tk8QqtxR
         quCRsTGEkjLoPj+3bN3Odh1XKD9cHQLiE2YSYSGzvq2YNBptxfI3lMx6TAU67HSM5A4X
         QwSg==
X-Gm-Message-State: APjAAAW1dN4QsJab81zR5BFLhXc5zvdYw4nZR0bhYp9vKFibHWTDYdsV
        2hS14N5UBfSGnogne1ydbYT2DJ68emWw24ZzH3E=
X-Google-Smtp-Source: APXvYqwKrsSTIoIu312DM1OogO+Nt/7ng/6mozD5/JRx0tp1Wn7qacQRTEQMza7ICvZz3sOS3tE77a3A+izfO/l5gnI=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr4043423qta.117.1562888841104;
 Thu, 11 Jul 2019 16:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190710231439.GD32439@tassilo.jf.intel.com> <1562838037-1884-1-git-send-email-p.pisati@gmail.com>
 <1562838037-1884-3-git-send-email-p.pisati@gmail.com>
In-Reply-To: <1562838037-1884-3-git-send-email-p.pisati@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 16:47:10 -0700
Message-ID: <CAEf4BzZ13GoSgSrLc3KBhcUO4Aa0V+6kHZMhVgGqr2Mz0iVsyA@mail.gmail.com>
Subject: Re: [PATCH 2/2] bpf, selftest: fix checksum value for test #13
To:     Paolo Pisati <p.pisati@gmail.com>
Cc:     "--to=Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 2:41 AM Paolo Pisati <p.pisati@gmail.com> wrote:
>
> From: Paolo Pisati <paolo.pisati@canonical.com>
>

Please include description, in addition to subject.

Also, when submitting patches, please add bpf or bpf-next (e.g.,
[PATCH bpf 2/2] to indicate which tree it's supposed to go into). For
this one it's probably bpf.


> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> ---
>  tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
> index bcb83196e459..4698f560d756 100644
> --- a/tools/testing/selftests/bpf/verifier/array_access.c
> +++ b/tools/testing/selftests/bpf/verifier/array_access.c
> @@ -255,7 +255,7 @@
>         .prog_type = BPF_PROG_TYPE_SCHED_CLS,
>         .fixup_map_array_ro = { 3 },
>         .result = ACCEPT,
> -       .retval = -29,
> +       .retval = 28,
>  },
>  {
>         "invalid write map access into a read-only array 1",
> --
> 2.17.1
>
