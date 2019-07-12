Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4106759C
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfGLT4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:56:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33073 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfGLT4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:56:08 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so7367301qkc.0;
        Fri, 12 Jul 2019 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BiVOpMp9PmQRZZxt9vvKVwu3GHw4fqIIIVHz7shKlKU=;
        b=rN4bIeBdWam08fPCsLy9tDhZ6kV9nPTjUIV51bVFnygYpPNXEfODoDTyo+fCCjLJaR
         V4PEFIQWnYdNbmIASjAodVu0O/qqviUXZJWNezVBjVUMplqPdHnxmMTZ4njboLVXIdu2
         9rdCJB2uW/bM2Qb5/5GyTtnelhFh3VKMEmsn7TTwl0DjCGTtJg69j2YnYp0q8f/aMBwq
         YLLgJSJtMOAzsIR0e5+UdaFP6+sN/W7iIl6MA5IZFDCRu+9luz6QQbhJuPC3dQ2ndbOW
         C/8JkKfkxQGKzRrosfXfTwEXuf7kfqPhGRoaCJexocow5q1oaOk3RrmjJ4KPkh9fOi6D
         72pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BiVOpMp9PmQRZZxt9vvKVwu3GHw4fqIIIVHz7shKlKU=;
        b=jwjuhy5MtDtKZjf7ZhBymeDk4zEnBXkzw6u+zgSi81elhZ2Yq7QKwhK+Ahj+5/IppB
         g7e5qrOeF1fVwwyyRxq+egTDIuSzN5LfejS2HLWX8LUG6QbaSxLEnwn3W5RvlwyuYAl5
         bZ6oSCROWFUzv72tfybRID7Rw4ZsbTlJv7P5gCfgBFBFQXlURM6gmh0F7mXwc4gU/I4U
         B6k6zqkylIMitZVgSnFPEkyPApQOxt42GpHrn+GAS1jMOHL2E3hxX/wUb55v4qm5EPct
         qVg32dLW6XhZP4UspFLeukJs44Fq5UO/aYtAHv0kM+TdntxURSLBjjRH6a9VR0bOEWvR
         k/ug==
X-Gm-Message-State: APjAAAVorzij4H3X9zYNDy7S7YXB0MsDpjL4LDVSbPspIe1rNEHiZ5Cy
        Jf0TCJ4Tzm+AwQ7z/9isTjtQWtJLetVoMHBrHHE=
X-Google-Smtp-Source: APXvYqwH/1SnGn64dtLmZ1/7EegVqIYpUDGdsTu3Nqa/n0jG2F/AUg6MVyJtxB5mZ691kT2q6fajpU9MMijlo7SwlHA=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr7940943qkf.437.1562961367447;
 Fri, 12 Jul 2019 12:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190712134142.90668-1-iii@linux.ibm.com>
In-Reply-To: <20190712134142.90668-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 12:55:56 -0700
Message-ID: <CAEf4BzbQRNo5-=VK1odKSaKp9avumpz06xr4zBNzhkE+KPpd2w@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix attach_probe on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 6:42 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> attach_probe test fails, because it cannot install a kprobe on a
> non-existent sys_nanosleep symbol.
>
> Use the correct symbol name for the nanosleep syscall on 64-bit s390.
> Don't bother adding one for 31-bit mode, since tests are compiled only
> in 64-bit mode.
>
> Fixes: 1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

This arch-specific naming is very unfortunate. I'm thinking of doing
this automatically in libbpf to help usability.


>  tools/testing/selftests/bpf/prog_tests/attach_probe.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index a4686395522c..47af4afc5013 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -23,6 +23,8 @@ ssize_t get_base_addr() {
>
>  #ifdef __x86_64__
>  #define SYS_KPROBE_NAME "__x64_sys_nanosleep"
> +#elif defined(__s390x__)
> +#define SYS_KPROBE_NAME "__s390x_sys_nanosleep"
>  #else
>  #define SYS_KPROBE_NAME "sys_nanosleep"
>  #endif
> --
> 2.21.0
>
