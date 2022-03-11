Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B123D4D56EB
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbiCKAre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiCKArd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:47:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046211A2726;
        Thu, 10 Mar 2022 16:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C24661DED;
        Fri, 11 Mar 2022 00:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED507C36AE2;
        Fri, 11 Mar 2022 00:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646959590;
        bh=z4PBUXUf97IEqo5TmTB3f5LWOKqJlW54EZ7PXln0eZM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PX6k1L5s+p98QZGYkwnhIE4SXxnO02U7VG8T1P91HFaNN+gVx8naoi8E5wH2a0jiZ
         kqhxq4Yk79KPzfTjDmua43R5CS80I+OX9Igyi/N7FPIH1ejrPeDaEzjmLae8wjDMFY
         sVU7QmUr3ArT/hQD/pTsLQUt5UnbglPRWRkW4s+FtazApzizr/B2L5tUvfjbRU5uzv
         L2jb8z/kXDwvnNSj9bhcVT/V4PdJ+47wTzewKs26G7TEGV9PpX0O6rOxMCW/jTW28x
         4RELUwiOZw9Og22S0DitLXRPEfFg/rsNrFq5jCeeH3zSSAJ/3zXL9SsZTZWfTHik3n
         qsZSZsCWOVZYA==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2db569555d6so77374107b3.12;
        Thu, 10 Mar 2022 16:46:29 -0800 (PST)
X-Gm-Message-State: AOAM531e/V9SJNg8f9nr5M48mLi1ZUsh2MwLX5V29sVPSY1M9d41MhRH
        qy6cwBReX2P6NL2Mz99preqKjWN5gcaO75w8k80=
X-Google-Smtp-Source: ABdhPJyfQM69lufi0dTFnrThI9Ob3S0QI7NA4OP7txcvqgwPrQuHWgj+7AApmk4fM289NRs8ZCLrVDFOPWKqs39z/M4=
X-Received: by 2002:a0d:fb45:0:b0:2d0:d09a:576c with SMTP id
 l66-20020a0dfb45000000b002d0d09a576cmr6506977ywf.447.1646959588931; Thu, 10
 Mar 2022 16:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-16-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-16-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 16:46:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7Gzr4d=2joK=+BRgyEBQGauo3+-z0=8nZtEKCC22f49A@mail.gmail.com>
Message-ID: <CAPhsuW7Gzr4d=2joK=+BRgyEBQGauo3+-z0=8nZtEKCC22f49A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 15/28] bpf/hid: add new BPF type to trigger
 commands from userspace
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:33 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Given that we can not call bpf_hid_raw_request() from within an IRQ,
> userspace needs to have a way to communicate with the device when
> it needs.
>
> Implement a new type that the caller can run at will without being in
> an IRQ context.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
[...]

> +       if (user_size_out && data_out) {
> +               user_size_out = min3(user_size_out, (u32)ctx->size, (u32)ctx->allocated_size);
> +
> +               if (copy_to_user(data_out, ctx->data, user_size_out)) {
> +                       ret = -EFAULT;
> +                       goto unlock;
> +               }
> +
> +               if (copy_to_user(&uattr->test.data_size_out,
> +                                &user_size_out,
> +                                sizeof(user_size_out))) {
> +                       ret = -EFAULT;
> +                       goto unlock;
> +               }
> +       }
> +
> +       if (copy_to_user(&uattr->test.retval, &ctx->u.user.retval, sizeof(ctx->u.user.retval))) {
> +               ret = -EFAULT;
> +               goto unlock;

nit: this goto is not really needed.

> +       }
> +
> +unlock:
> +       kfree(ctx);
> +
> +       mutex_unlock(&bpf_hid_mutex);
> +       return ret;
> +}
[...]
