Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0F576625
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiGORfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiGORfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:35:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C9F52FF8;
        Fri, 15 Jul 2022 10:35:09 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h145so4371254iof.9;
        Fri, 15 Jul 2022 10:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4PyeC7DknSEozr2Rop+Ti8Cfi6yj/0ATtSdVUySwnQ=;
        b=J1aj53+wNAbEw+IHLK8Z72Y/0Gb/enxKDEJoJCi4kEwUPHNRFo1YVnepiO7k9zjt0O
         XHj/bdo8LBMk4vsZSQCkVyZLljQkF9AJ5WZNAUlNeAbOWqnC7NE7Ig1U0k5XSWExGfcp
         KTbUI0jK/K60oYXEtB0xjO2Xgsc1ZwN52sJBRBqM2mjIYxC04NpLbVRz0Wipph4hVYjh
         KmTDvSI/H1NUeQ6Rp/UrbYqXkCPmifNCWfHwBJP4lDUS8G0fZLZ3a23QFbjrUy5K2xUw
         jCw2h1G86t5Rsy5e8H6ztxYSpGBE9pc6bA14zrda8bPbR2rDcjfadcynVp+5sLL9xHDQ
         Wz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4PyeC7DknSEozr2Rop+Ti8Cfi6yj/0ATtSdVUySwnQ=;
        b=sOa+sAk9v9E6m9IH8Mhml8EWLiZtYHLpFSvh5QX9FQ/hpyAHEw0pyE8bzViZIv1S8c
         HVw3k2gSYnfGIMdhImDfl8YT+1/VYqybOrRGrq4bypp6qKKMqXlA6m5BFdLn6daRAjky
         1tcAekFGNeSJww6xarRFYWLR6fMAGb9i1uQzmUHefhtF2ZElNohIrOHxEmoWaMbefa+F
         vMBbNI9KF0E17nrLbFa8WcbvgBnbmQNvBUYsP4vFzhJPW8dEuC7UOcneJb7/osP2nmX7
         p7p32C+OW7q60L4MeDI/PxHq+YjAOFiYYX0q18orVx+IgDCH9H0C006QcLbfu9uCKH7m
         Al6Q==
X-Gm-Message-State: AJIora9gJD/H6DRUVXZpYQAYQWTUcDR6C3fq5AIy4AiGPUl44digTrv3
        5E0Ia+AcwnGjY1pEXoqLgcyqmzeE6A+dSKIKAqkj90wg/9g=
X-Google-Smtp-Source: AGRyM1vXy8j20gHUEsoo8QWPuQvHey3I1meuQx56FZHopAnVEj3jwYjJHzssCdwlGyl/uj0ZRucTt5XsKmZhobZWFis=
X-Received: by 2002:a05:6602:2e8d:b0:64f:b683:c70d with SMTP id
 m13-20020a0566022e8d00b0064fb683c70dmr7236737iow.62.1657906508386; Fri, 15
 Jul 2022 10:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com> <20220714213912.zrotlequhpgxzdl4@MacBook-Pro-3.local>
In-Reply-To: <20220714213912.zrotlequhpgxzdl4@MacBook-Pro-3.local>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 15 Jul 2022 19:34:32 +0200
Message-ID: <CAP01T746cSrRgYME75O-NZvf+4NQNvtU8ZhGf5XGmXRqY6jQzQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 00/23] Introduce eBPF support for HID devices
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 at 23:39, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 12, 2022 at 04:58:27PM +0200, Benjamin Tissoires wrote:
> > Hi,
> >
> > and after a little bit of time, here comes the v6 of the HID-BPF series.
> >
> > Again, for a full explanation of HID-BPF, please refer to the last patch
> > in this series (23/23).
> >
> > This version sees some improvements compared to v5 on top of the
> > usual addressing of the previous comments:
> > - now I think every eBPF core change has a matching selftest added
> > - the kfuncs declared in syscall can now actually access the memory of
> >   the context
> > - the code to retrieve the BTF ID of the various HID hooks is much
> >   simpler (just a plain use of the BTF_ID() API instead of
> >   loading/unloading of a tracing program)
> > - I also added my HID Surface Dial example that I use locally to provide
> >   a fuller example to users
>
> Looking great.
> Before another respin to address bits in patch 12 let's land the first ~8 patches,
> since they're generic useful improvements.
>
> Kumar, could you please help review the verifier bits?

Sure, I'll take a look.
