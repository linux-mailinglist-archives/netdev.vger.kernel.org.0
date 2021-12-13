Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C2A47332B
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 18:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhLMRpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 12:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbhLMRpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 12:45:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA30C061574;
        Mon, 13 Dec 2021 09:45:44 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 8so15585566pfo.4;
        Mon, 13 Dec 2021 09:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDIg8qQRsEJurGSar8uWJNI5AIPO1TB677IfJiB2JGs=;
        b=a5hHhpMm3L5KN8vrmdGqTWjYLGdS3MK/iUdPjdkCB7C56avfxhBUtdt1uNnugpmc1a
         AgPmWsi30t1e1MXy9PXGXr9za3huxZgxksRX61ifXCe83SCkenkFd/+EeeyPjekeFJSF
         qhNv79gxk7SldsMXLLVEt8lo/ADtFKZQX+2FEfUQZCUmIQbrAkci9/OKO/xiRdhb3PWi
         N9mOBkKAx49/R6dv8AxfXo0DJjBHzZAChPIn4pHXySPuMf8m5ivd7T03BzDir1lobI3R
         H1V6G7mw+hGEQx2oVEKIZvS4B0HpqsGnihjEnp8Z7Qa3ek4jIiwXIXbnS8I8CfygOYBR
         BXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDIg8qQRsEJurGSar8uWJNI5AIPO1TB677IfJiB2JGs=;
        b=o15yQnJl4OoIqjIT1Z5xZF5l9tBpTnBm/2mkFJ+zb33C39Ln9IaOdqtc9rSoU+pe8J
         VeHCPcXcOvrChl0frfW/wBsyujnJ1NdPZt+fAdrB2nUWx4UR8j6/dvCg9SlyVpmCEtV8
         M/vttmUPBN49T8nH4JLZx+lFEhRZYi0x395nBRGPfTODyZjKQCrEotwgOXHbl1ocAHdI
         RpFcrz0u2GBdIhNfdK0CjBdmgURYyYSFJbTToZilOuOBw6v4txsKlb8yQ67TdQRM/I1n
         CrXqqhgGTklWpQRN0pYffzDNV9CqrpHyPNjQsbrcAzmx3jM0rgNp/I1sOr5ioVXl8bTM
         o/9Q==
X-Gm-Message-State: AOAM531+Acvz2mH+AqvcNVTUtjaS+uIwNClmdxHpfV6l7y9vWXZ+W+/i
        4cN5WTEc+X9vb7IShxQRToN+C+/jhUs4zxHLZqGsbIKD
X-Google-Smtp-Source: ABdhPJyYks0ELsrjgOHk4iKKv8dU9Wwv0CW588z3Xyz/czzNXgzI+SpCijJSNNRI8aKAV9V9B1n0Pfhl+jQbUVEcUxg=
X-Received: by 2002:a63:6881:: with SMTP id d123mr8585pgc.497.1639417543778;
 Mon, 13 Dec 2021 09:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20211208193245.172141-1-jolsa@kernel.org> <20211208193245.172141-5-jolsa@kernel.org>
In-Reply-To: <20211208193245.172141-5-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Dec 2021 09:45:32 -0800
Message-ID: <CAADnVQ+pKwpYJS-isP6zzybGbXc1rLTD0UqvJEUSWodqnGNJcQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 4/5] bpf: Add get_func_[arg|ret|arg_cnt] helpers
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 11:33 AM Jiri Olsa <jolsa@redhat.com> wrote:
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5167,6 +5192,9 @@ union bpf_attr {
>         FN(kallsyms_lookup_name),       \
>         FN(find_vma),                   \
>         FN(loop),                       \
> +       FN(get_func_arg),               \
> +       FN(get_func_ret),               \
> +       FN(get_func_arg_cnt),           \
>         /* */

I manually resolved conflicts and pushed to bpf-next.
Thanks!
