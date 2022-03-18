Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D04DE374
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiCRVW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiCRVW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC421FC6F;
        Fri, 18 Mar 2022 14:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE6B612AC;
        Fri, 18 Mar 2022 21:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EF4C36AE3;
        Fri, 18 Mar 2022 21:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647638467;
        bh=Vk5mzHbIg17vZ6G2aaaTRJ/qc3wtRp4U3dpTA+mQTzk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ELbYGJ5s13fJLbEKv95M5pVw7hO7DtSYZ0YpTw3usN05tXHbv2RI/LMOrZ9RvazFC
         LKvWI9DHFrTXTdQ5NF2TNzFoQuiFV6G24Br9GEyC8hQHayVOTzJDPf+w1s2IMdy6yU
         wqF+2/LEOGg59KR03baTx/feAPOiwR72Cu1smHzVen/JSY4ll7IJwKloDR1RUnuTLT
         VhrSdPTUQt8lLE52izSQjSw/0mKq7ehBlQSqMiyXv70d3eNWHEPv3ZQT6CKSIbG/Sj
         DYF2fr/vqXxhPOxtVSzMbHqaZm5yjFlwapmRWSrtHJHkI9yDBsyOZH82JGzw9qNIDQ
         B+0vj43BUdwXQ==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2e5a8a8c1cdso95489317b3.3;
        Fri, 18 Mar 2022 14:21:07 -0700 (PDT)
X-Gm-Message-State: AOAM533GGYVhVaqQnOb4korkjuBryjjBMfznHfUsdMGF1bnP4djVeMdf
        ZLWUzWnKjaszKkuxcQGEnm4POyxOMHcn3X9XavU=
X-Google-Smtp-Source: ABdhPJy9p6xLR9FKRtMxw8beAYraAaLqJ52YfwUWGPSjxPQqNRKqdW6sylYGLO220Y1ivS1CkbruJKJ4SGRK3Hm/jho=
X-Received: by 2002:a81:a006:0:b0:2e5:963a:4c42 with SMTP id
 x6-20020a81a006000000b002e5963a4c42mr12976417ywg.73.1647638466787; Fri, 18
 Mar 2022 14:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-14-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-14-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 14:20:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5mKPT+Vw4FVFBokwnY1kkCm9i_HA3Pd2DUznHJfqV+4A@mail.gmail.com>
Message-ID: <CAPhsuW5mKPT+Vw4FVFBokwnY1kkCm9i_HA3Pd2DUznHJfqV+4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 13/17] HID: bpf: implement hid_bpf_get|set_bits
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
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
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

On Fri, Mar 18, 2022 at 9:18 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Export implement() outside of hid-core.c and use this and

Maybe rename implement() to something that makes sense?

> hid_field_extract() to implement the helprs for hid-bpf.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v3:
> - renamed hid_{get|set}_data into hid_{get|set}_bits
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> - allow for n > 32, by relying on memcpy
> ---
>  drivers/hid/hid-bpf.c  | 29 +++++++++++++++++++++++++++++
>  drivers/hid/hid-core.c |  4 ++--
>  include/linux/hid.h    |  2 ++
>  3 files changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
> index 45c87ff47324..650dd5e54919 100644
> --- a/drivers/hid/hid-bpf.c
> +++ b/drivers/hid/hid-bpf.c
> @@ -122,6 +122,33 @@ static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_ty
>         }
>  }
>
> +static int hid_bpf_get_bits(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offset, u32 n,
> +                           u32 *data)
> +{
> +       if (n > 32)
> +               return -EINVAL;
> +
> +       if (((offset + n) >> 3) >= buf_size)
> +               return -E2BIG;
> +
> +       *data = hid_field_extract(hdev, buf, offset, n);
> +       return n;
> +}
> +
> +static int hid_bpf_set_bits(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offset, u32 n,
> +                           u32 data)
> +{
> +       if (n > 32)
> +               return -EINVAL;
> +
> +       if (((offset + n) >> 3) >= buf_size)
> +               return -E2BIG;
> +
> +       /* data must be a pointer to a u32 */
> +       implement(hdev, buf, offset, n, data);
> +       return n;
> +}
> +
>  static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *ctx)
>  {
>         enum bpf_hid_attach_type type;
> @@ -223,6 +250,8 @@ int __init hid_bpf_module_init(void)
>                 .pre_link_attach = hid_bpf_pre_link_attach,
>                 .post_link_attach = hid_bpf_post_link_attach,
>                 .array_detach = hid_bpf_array_detach,
> +               .hid_get_bits = hid_bpf_get_bits,
> +               .hid_set_bits = hid_bpf_set_bits,
>         };
>
>         bpf_hid_set_hooks(&hooks);
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 3182c39db006..4f669dcddc08 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1416,8 +1416,8 @@ static void __implement(u8 *report, unsigned offset, int n, u32 value)
>         }
>  }
>
> -static void implement(const struct hid_device *hid, u8 *report,
> -                     unsigned offset, unsigned n, u32 value)
> +void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
> +              u32 value)
>  {
>         if (unlikely(n > 32)) {
>                 hid_warn(hid, "%s() called with n (%d) > 32! (%s)\n",
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 66d949d10b78..7454e844324c 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -944,6 +944,8 @@ bool hid_compare_device_paths(struct hid_device *hdev_a,
>  s32 hid_snto32(__u32 value, unsigned n);
>  __u32 hid_field_extract(const struct hid_device *hid, __u8 *report,
>                      unsigned offset, unsigned n);
> +void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
> +              u32 value);
>
>  #ifdef CONFIG_PM
>  int hid_driver_suspend(struct hid_device *hdev, pm_message_t state);
> --
> 2.35.1
>
