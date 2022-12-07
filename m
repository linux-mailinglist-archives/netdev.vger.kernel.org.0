Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB82645D27
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiLGPBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiLGPBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:01:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F87463D55
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670425116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=81tx4Qu/i7V9KBQ9lAK66Q8QPlDEub1zKKTdHJd3xZc=;
        b=NRDB5J4/KN3bL98sP1WSVkkjOrOmtZR+tNJsU1Rg2qzsZPLWtXWV/G2XzgMty4uMcAftFi
        POgs5wUz16wskmtwtf9Fn/0xwMfJZRL8V4kia28T8JkecZSr/fVwkI9AYxg80qUk+namda
        KxbIW2A9pDx5uJbm6GrTpt5SRAWpZRs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-srFW8NbDMYe1DypeWLZtsw-1; Wed, 07 Dec 2022 09:58:33 -0500
X-MC-Unique: srFW8NbDMYe1DypeWLZtsw-1
Received: by mail-il1-f197.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so9814521ilh.22
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:58:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81tx4Qu/i7V9KBQ9lAK66Q8QPlDEub1zKKTdHJd3xZc=;
        b=tT6xkCYKZ0HHnyEX/+d3+IDdshANaCkSvAHIGPlgwHxJcqYUVYYFQGFGQelsBSrFQX
         DGy+zSIszbuIroU+h9fVBZwxOaXrgKx2ReWy5M6CdOrps7eU0iDPyZJHnqnxIY+U4BLZ
         MY+hsH3VMghiPBkD7oUFo4pqDCRAFgTVHrnEia2nnYa1LA+JXwKIdSzC+plbDCbArUbw
         xpFg2wp65Bv0+AcaD3tW7HS7LuMzQuRzVpq1ArKXdcpZxzL+LXalJFtrYSwRZI0749Tj
         CqqtbZQMq3eHl3woBkxHco5W+y7fbrH/sve3oUZC86wdlGXZuNpGilU1SLG7MC2sDJsC
         Tm0A==
X-Gm-Message-State: ANoB5pm3sLJsrvOWy2BTTzcbkvHEiYHSLahR2Gq4S5vNN2Ur5GRygIpc
        kvdbWCgQ6YIcOeTKgIQgGe/6HfqOM2g72vfqxuyNXbWCTY8TLyYKbCubPcIX5wk9w3pNJ9reFHf
        l2dZbu4+ZfkjK5kWTyXzWPsWG+BhLM6l/
X-Received: by 2002:a02:cc31:0:b0:389:f21d:ec44 with SMTP id o17-20020a02cc31000000b00389f21dec44mr16621885jap.106.1670425112455;
        Wed, 07 Dec 2022 06:58:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4kM7WVmrniMvBfEcxbq+UC0cEZ9wYd5nOJPAwF5eggKPwWUOBHz/nl3G5o4x/8P8WXHDfEVEplpo9f2kjZxWE=
X-Received: by 2002:a02:cc31:0:b0:389:f21d:ec44 with SMTP id
 o17-20020a02cc31000000b00389f21dec44mr16621879jap.106.1670425112254; Wed, 07
 Dec 2022 06:58:32 -0800 (PST)
MIME-Version: 1.0
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com> <20221206145936.922196-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20221206145936.922196-4-benjamin.tissoires@redhat.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Wed, 7 Dec 2022 15:58:21 +0100
Message-ID: <CAO-hwJJq23V+ceJvX8zz-wGB6VgByuMY-xGu8VukiOmP+FfXHA@mail.gmail.com>
Subject: Re: [PATCH HID for-next v3 3/5] HID: bpf: enforce HID_BPF dependencies
To:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 3:59 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> As mentioned in the link below, having JIT and BPF is not enough to
> have fentry/fexit/fmod_ret APIs. This resolves the error that
> happens on a system without tracing enabled when hid-bpf tries to
> load itself.
>
> Link: https://lore.kernel.org/r/CABRcYmKyRchQhabi1Vd9RcMQFCcb=EtWyEbFDFRTc-L-U8WhgA@mail.gmail.com
> Fixes: f5c27da4e3c8 ("HID: initial BPF implementation")
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> no changes in v3
>
> changes in v2:
> - dropped ALLOW_ERROR_INJECTION requirement

Florent, can I keep your reviewed-by on this patch?

Jon, may I ask you to do one more testing with the full v3 applied on
top of for-next?

Cheers,
Benjamin

> ---
>  drivers/hid/bpf/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
> index 298634fc3335..03f52145b83b 100644
> --- a/drivers/hid/bpf/Kconfig
> +++ b/drivers/hid/bpf/Kconfig
> @@ -4,7 +4,8 @@ menu "HID-BPF support"
>  config HID_BPF
>         bool "HID-BPF support"
>         default HID_SUPPORT
> -       depends on BPF && BPF_SYSCALL
> +       depends on BPF && BPF_SYSCALL && \
> +                  DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>         help
>         This option allows to support eBPF programs on the HID subsystem.
>         eBPF programs can fix HID devices in a lighter way than a full
> --
> 2.38.1
>

