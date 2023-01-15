Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F216D66B43A
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 22:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbjAOVip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 16:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjAOVid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 16:38:33 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCA71816F;
        Sun, 15 Jan 2023 13:38:26 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s5so38385651edc.12;
        Sun, 15 Jan 2023 13:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=57kdqOuHYhDuUykoWeKC7s2qeEWqbE2Ut7XWjHRvhF0=;
        b=RrRMnrXYth8fjdxYLSDF4gGhWcZmgAPtzF/Eyk1IOAJyodqKBB3HjK4W9TFDoFQ9e0
         cmY37ezVjZa34BnunJsTjDmzGA8MHHXGGc9a0jgQIroLBEr3FgiDBInCUtXxR5ejMvq/
         fRUc8+QyVeGIbR3A25St0BRGQE2YXUYD5io5Cu4diI3uF91KmIVZYe1EUEsSR2DbCAde
         Xf6HWBIdnaX0ebGso/5/IXdZw1LeoiWLXh0gTAT5ztWhmqsPgYzzaMvpBSqyLgPAFn/1
         ufL+YNwpufUZ35Frfz1vMwejQqXjyApNpCFFKz/e7wDTn6DNgOf9mju1M5G2eFY1jtA5
         hu6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57kdqOuHYhDuUykoWeKC7s2qeEWqbE2Ut7XWjHRvhF0=;
        b=Pdf+ZxSQYUf60RznkY9ckGoMrUdJidXSymfuxc3VT/IzCRJrv24PlkPZ333HJGySp4
         kmbCpZoJZL3w16/lXjE+Z73L3hNfX9T/APt1yGr5Fl/MfcgVlV7ci+bG47eex1fOToFJ
         azEVb2Z3QKNh3+bsc1KYAcBqwPCFk0LZJP6E4YvVLpn0VqUsIC/nAbpnAt+InxQDHsT6
         YTaTQebkjSvHQTePjfzgZvnLpjIewM9KtfdISU3F9o8BagWc8ODB/tAWnmVhnheKWFtP
         gIaWrtG+kVR82ehWpeUuFdujcOLImxMlWEg64tDgD8J4AXKJ9dg2RvbyX+zih2r0x10h
         0MyQ==
X-Gm-Message-State: AFqh2kpQhhMUtbok4X2kFuRRj8lP3hQ57DNHrT29mqG3WNQyaJWaPaKB
        PYQlYOszzr24VXBfGudxhZSVhgqmI451ewZsipA=
X-Google-Smtp-Source: AMrXdXtAygATLaDTW3nC5zGdOBYmLQijWgsrg34pGrvmgqQoQD1dBWfG9X/Qrby6TVGMDHm4SIsq5pGo81pKh8Pk/nk=
X-Received: by 2002:aa7:db4e:0:b0:49e:1e:14b1 with SMTP id n14-20020aa7db4e000000b0049e001e14b1mr322202edt.6.1673818705066;
 Sun, 15 Jan 2023 13:38:25 -0800 (PST)
MIME-Version: 1.0
References: <20230115071613.125791-1-danieltimlee@gmail.com>
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 15 Jan 2023 13:38:13 -0800
Message-ID: <CAADnVQ+zP5bkjkSa97k+dK7=NabkdoLWQtZ1qRwRTUQgGdqhVA@mail.gmail.com>
Subject: Re: [bpf-next 00/10] samples/bpf: modernize BPF functionality test programs
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
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

On Sat, Jan 14, 2023 at 11:16 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, there are many programs under samples/bpf to test the
> various functionality of BPF that have been developed for a long time.
> However, the kernel (BPF) has changed a lot compared to the 2016 when
> some of these test programs were first introduced.
>
> Therefore, some of these programs use the deprecated function of BPF,
> and some programs no longer work normally due to changes in the API.
>
> To list some of the kernel changes that this patch set is focusing on,
> - legacy BPF map declaration syntax support had been dropped [1]
> - bpf_trace_printk() always append newline at the end [2]
> - deprecated styled BPF section header (bpf_load style) [3]
> - urandom_read tracepoint is removed (used for testing overhead) [4]
> - ping sends packet with SOCK_DGRAM instead of SOCK_RAW [5]*
> - use "vmlinux.h" instead of including individual headers
>
> In addition to this, this patchset tries to modernize the existing
> testing scripts a bit. And for network-related testing programs,
> a separate header file was created and applied. (To use the
> Endianness conversion function from xdp_sample and bunch of constants)

Nice set of cleanups. Applied.
As a follow up could you convert some of them to proper selftests/bpf ?
Unfortunately samples/bpf will keep bit rotting despite your herculean efforts.
