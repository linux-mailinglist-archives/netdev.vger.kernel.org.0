Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F364DE0C1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240017AbiCRSId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbiCRSIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98B02F09D5;
        Fri, 18 Mar 2022 11:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5396361AE9;
        Fri, 18 Mar 2022 18:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6959C36AE3;
        Fri, 18 Mar 2022 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647626832;
        bh=2+jsyRzao3o9WqKhy3sPHH79gWwA1AmH0Ljrc3xGYps=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FxdY0uf2aTo/9OTbQ2nuqPXBXSGi+OpNSaZfBRBCqdMverR/XfOdmayWYJN8tRrVb
         bymIWfTHgeJ8gKC7K1Hw/VYUgfek7YRHUQX2SoDU/rwPKmdc/DGvZPIOaPOMtzDq+l
         xdaWCA7M3NzGHzB0gzHiUP4YQWVnwHIu5JTILICMiVssJc9dyj6fJDOIEuyhEpUPYN
         p3GyYiKwaKEQtE4FfOUjyL/5jagvZrEkcSNgOMJhZC1JdVT7BIRHOHKkNNNTguQD2h
         SO1avJVQqhG71QZtlYCc/D0qvQRjIO5jNFXCkdINRmP/ZIxxPP59FwUhXNkvzaQvYN
         qUG9I9B/rMsZQ==
Received: by mail-yb1-f171.google.com with SMTP id t11so17208272ybi.6;
        Fri, 18 Mar 2022 11:07:12 -0700 (PDT)
X-Gm-Message-State: AOAM531oy7TYd8FkzOrzfy1i3VmUDwtEWOzGNbVHX3cS1kyayZm5gfDC
        hFRZBx2K9m7DlANaFCe6ws8XdVQtAc8DPYG8gCw=
X-Google-Smtp-Source: ABdhPJzGdHJloFcUCWqzD16w/I7Nedej9Z6/WpiREx002wPoJlh8OLXEYVGHTutGJHWXCZrrkvCKTuAilALRRAq0aXI=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr10898086ybl.449.1647626831812; Fri, 18
 Mar 2022 11:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-2-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 11:07:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5QMRrvJ_8=RpOv09je180PUHDDy_BciqCKhhKz0Utfsw@mail.gmail.com>
Message-ID: <CAPhsuW5QMRrvJ_8=RpOv09je180PUHDDy_BciqCKhhKz0Utfsw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 01/17] bpf: add new is_sys_admin_prog_type() helper
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sean Young <sean@mess.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> LIRC_MODE2 does not really need net_admin capability, but only sys_admin.
>
> Extract a new helper for it, it will be also used for the HID bpf
> implementation.
>
> Cc: Sean Young <sean@mess.org>
> Acked-by: Sean Young <sean@mess.org>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>

>
> ---
>
> changes in v3:
> - dropped BPF_PROG_TYPE_EXT from the new helper
>
> new in v2
> ---
>  kernel/bpf/syscall.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 9beb585be5a6..b88688264ad0 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2165,7 +2165,6 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
>         case BPF_PROG_TYPE_LWT_SEG6LOCAL:
>         case BPF_PROG_TYPE_SK_SKB:
>         case BPF_PROG_TYPE_SK_MSG:
> -       case BPF_PROG_TYPE_LIRC_MODE2:
>         case BPF_PROG_TYPE_FLOW_DISSECTOR:
>         case BPF_PROG_TYPE_CGROUP_DEVICE:
>         case BPF_PROG_TYPE_CGROUP_SOCK:
> @@ -2202,6 +2201,16 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
>         }
>  }
>
> +static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
> +{
> +       switch (prog_type) {
> +       case BPF_PROG_TYPE_LIRC_MODE2:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
>  /* last field in 'union bpf_attr' used by this command */
>  #define        BPF_PROG_LOAD_LAST_FIELD core_relo_rec_size
>
> @@ -2252,6 +2261,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>                 return -EPERM;
>         if (is_perfmon_prog_type(type) && !perfmon_capable())
>                 return -EPERM;
> +       if (is_sys_admin_prog_type(type) && !capable(CAP_SYS_ADMIN))
> +               return -EPERM;
>
>         /* attach_prog_fd/attach_btf_obj_fd can specify fd of either bpf_prog
>          * or btf, we need to check which one it is
> --
> 2.35.1
>
