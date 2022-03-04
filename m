Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C554CE0C6
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiCDXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiCDXN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:13:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C96140D3;
        Fri,  4 Mar 2022 15:12:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47699B82C59;
        Fri,  4 Mar 2022 23:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D599C340F6;
        Fri,  4 Mar 2022 23:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646435547;
        bh=M3M7GJjFihvbF6LifpyP35fxlg6/lZjmcYRAbzOnZbo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NsylDpV6b5BkXIQ+41uIxXt7r8IzhnLnT0Whk6slypqhNBevXpEbQ6JXr9D+dNqLa
         R2hJ0IWoVyKjXxHA7DD8jjqM2mY+9WTVrAtNX8l2uX4mMcUWN0l5eWGuVP05mOqW8O
         ME/VDDsiVDY/qCQaHf6OeN8TrFIGQHKYzvL4Mlmu+3OwCrPmh2gpeESHxecTB9s8Ec
         zYy7cGyC1DkDKPvZDruV2W5v+0Vn5lH06ISAcxMWJR6kr7K9LAwEzN1Es2QjqBGQC0
         BbVnWnEsZI2aJGOmkCTaGbxdSzWMDdBYTKLL33M4Y51oqoH0FTToX9NsPflLRZSNVd
         c4zv/mU4KHpaw==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2d07ae0b1c4so107811627b3.11;
        Fri, 04 Mar 2022 15:12:27 -0800 (PST)
X-Gm-Message-State: AOAM530vvux3MzkcG7/Fh8LoCZ5OOgToDdzIGl0NXeWlYcz4bk8RuRn4
        dD1D5/rFLuAR8Wag/xHnJqElGIxtMFkBiUrr1U8=
X-Google-Smtp-Source: ABdhPJyD5AyWaVis15UM4vQetP8SZNvLJ6HXwhIUgeoXJY9Qtzn1r8n4U2fqSed+i6ZqaHaxN8sw9D3lULdz5Nsvous=
X-Received: by 2002:a81:10cc:0:b0:2dc:24f7:7dd3 with SMTP id
 195-20020a8110cc000000b002dc24f77dd3mr898510ywq.460.1646435546021; Fri, 04
 Mar 2022 15:12:26 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-2-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 15:12:14 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4otgwwDN6+xcjPXmZyUDiynEKFtXjaFb-=kjz7HzUmZw@mail.gmail.com>
Message-ID: <CAPhsuW4otgwwDN6+xcjPXmZyUDiynEKFtXjaFb-=kjz7HzUmZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 01/28] bpf: add new is_sys_admin_prog_type() helper
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
        linux-kselftest@vger.kernel.org, Sean Young <sean@mess.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:30 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> LIRC_MODE2 does not really need net_admin capability, but only sys_admin.
>
> Extract a new helper for it, it will be also used for the HID bpf
> implementation.
>
> Cc: Sean Young <sean@mess.org>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> new in v2
> ---
>  kernel/bpf/syscall.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index db402ebc5570..cc570891322b 100644
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
> @@ -2202,6 +2201,17 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
>         }
>  }
>
> +static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
> +{
> +       switch (prog_type) {
> +       case BPF_PROG_TYPE_LIRC_MODE2:
> +       case BPF_PROG_TYPE_EXT: /* extends any prog */
> +               return true;
> +       default:
> +               return false;
> +       }
> +}

I am not sure whether we should do this. This is a behavior change, that may
break some user space. Also, BPF_PROG_TYPE_EXT is checked in
is_perfmon_prog_type(), and this change will make that case useless.

Thanks,
Song

[...]
