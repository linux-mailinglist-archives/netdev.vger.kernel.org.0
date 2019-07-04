Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DEE5FC83
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfGDR3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:29:34 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34330 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGDR3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:29:34 -0400
Received: by mail-io1-f65.google.com with SMTP id k8so14235589iot.1;
        Thu, 04 Jul 2019 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lLCSF8cfSBS06fyUsvl3Ma9Eka4rupliBxowIgB3I+c=;
        b=aT6zFgCwCjsjhmnqPbNhGoACjZclPbULGwzOG1i/I+A8GqBMtzkgwssOPTvBA0QODu
         +0AhuXYTBXnXEUInKegtWIRN3mn0FbA4D08XinGOxsVO5GCY9nQmH9qBn0dLJ/Gfm7xy
         3QdJ4oseNpbycdvm/EPumdd2jrv3icVlcKFYf2MnklLmPdUVhMQTesg8WwrEkWR5erx7
         ohX0Vj0ZuABkrUNg8V9Trl8RgbPUWTUCfFskfC0jOrDWIhRBz+mLxKgzArneePz81QzU
         dEc7BIBUBUnbetDWcqSad2sUrTYUt++wcaxXy2RL4eXDRvEc4m54ggWnA8PefCTZa11q
         rtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lLCSF8cfSBS06fyUsvl3Ma9Eka4rupliBxowIgB3I+c=;
        b=JA6SPfZCpO+i0exy+Vb/9RxZXbaLo9YJkL1ovXBIDo7kBMPa7JAsUHYEZXwJW5Zahx
         2RGfwv8Z6mzF1fBgDYUMYh7G9cTCgxW+FcFNBqyOgRT5pYoZHutv/aEPcJucQ87A2RQH
         o8B7B6LA+e47crIYhhXAQMBnEomB3r+g8I4UupF80IqPO9oRZXm/G0wEs1nK9MPnbVjv
         80RMFz8dAsl30TJkWNwabqNyMZ/GhnDEDnSHNq9hbCqeChZCrLG//aJ+++BTBfZcHoIy
         mzpLqBmVmxZB8fkHDDHvJzaBQWpp6cW4vp/D88T7Eyx6RWwY6kTINR2WtDCWr/P+17PF
         3b9A==
X-Gm-Message-State: APjAAAXUugg+rYB+t1BrdIh9PDsAgyS8KpEigM6ZULh7JL3M92ZCX1LD
        oA2ZXZr3y+hdWvdQ4kKYUlkQOiGZ3+DmTXLLSzg2fWKq
X-Google-Smtp-Source: APXvYqzTsNDZYFlm/oOaf4pJhy/vccK7B9WZebiuSX+/tsMaLp4DoqKquNyj6voUzwdeQ2zPMgd/fa3zhkjJF3WbSH4=
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr5923306iom.287.1562261373359;
 Thu, 04 Jul 2019 10:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190704085224.65223-1-iii@linux.ibm.com>
In-Reply-To: <20190704085224.65223-1-iii@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 4 Jul 2019 10:28:57 -0700
Message-ID: <CAH3MdRUWzvSFx2+1Qsd0hty8=Tb71t9nCg872a5-dtvh8DKDLA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix "alu with different
 scalars 1" on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 1:52 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> BPF_LDX_MEM is used to load the least significant byte of the retrieved
> test_val.index, however, on big-endian machines it ends up retrieving
> the most significant byte.
>
> Use the correct least significant byte offset on big-endian machines.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>
> v1->v2:
> - use __BYTE_ORDER instead of __BYTE_ORDER__.
>
>  tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> index c3de1a2c9dc5..e5940c4e8b8f 100644
> --- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> +++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> @@ -183,7 +183,11 @@
>         BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>         BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
>         BPF_EXIT_INSN(),
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>         BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
> +#else
> +       BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, sizeof(int) - 1),
> +#endif
>         BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 3),
>         BPF_MOV64_IMM(BPF_REG_2, 0),
>         BPF_MOV64_IMM(BPF_REG_3, 0x100000),
> --
> 2.21.0
>
