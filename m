Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52AE52F7B7
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354385AbiEUCrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351151AbiEUCq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:46:57 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E8B6353F;
        Fri, 20 May 2022 19:46:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id bo5so9149868pfb.4;
        Fri, 20 May 2022 19:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hlMWsJTCZidavUuAPKzwU9yhf4WgPtPDAYKHfwZT1Kk=;
        b=QI24hacwG+UXk14hfyOzgbyuqZGE9Jc+lSW/TFk5ve7qn3j3BS7C46wRq/kvQhwyov
         TdX+YRaN4v9iAuPnq13vnHilN0DUGkdqFAO2gjar0TcABj9t0chpVmJdxhmle8Jk7IRK
         QGnEXhQFcfZoBp3mFCsxiovbDAmb/1pFKIAQSyciyQFI0cQY5GD85QkOt3len3rHA+ik
         OKjuE2i+HUW3llK+C6bAtaExagW+4HhCx9KW977jPnoFPu9us8CrdaSZ0CRT57E3TQFl
         DM/F5ro7O+Cq4In1Yeej8/kKHTBWYdL/CTC6IkCE1XQg/KT3rip9v/DKWq/QpKIOt+FW
         O6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hlMWsJTCZidavUuAPKzwU9yhf4WgPtPDAYKHfwZT1Kk=;
        b=7V7z3oHhL4u+jClR4q6LmIQzihMYVU9zbdp42U9iuxDDAVla8dayTzIAvSAFJI04Nh
         yY/kSKBfJWqi7M4Mlwh/8B6FHadaihOEvuOtCBpDUJ5rtkBrrs4cPumQ1iJWlVyjvdvA
         IqZ1fjObMUrjbQR9OOnBuJbXchPS/eoGeziII2mNg4lzVTnco/T/awn0Gkv43mcRexD8
         kS9/NkGtMny+IWGN4htOW6ouqf+hYisLiGWcc3kDOB77rVLQnsWI4ALZ1PEzeK1Owa/j
         In+tIHhW3dCU1qdBQHcJbK0wGeIp9ueSMyCNOSHZghSY+kdBs1IioDxedELymXHoJ1LV
         IXIw==
X-Gm-Message-State: AOAM533MRcMmh4Zo2R+ZQQ3CkGAewgxcHU+kovqCnVkUKRTXzuE0U7T8
        Hr7spXrco0udq9hYBf0au8Q=
X-Google-Smtp-Source: ABdhPJxTMM/zJvD/ZsVF7ArHkK+UgEQYH2UcY6QfJhpPSJ8N2T5v3ir2qxN5yEPI61s0GafkZ4S5Xw==
X-Received: by 2002:a63:f255:0:b0:3c6:afc0:56b4 with SMTP id d21-20020a63f255000000b003c6afc056b4mr11017538pgk.407.1653101216241;
        Fri, 20 May 2022 19:46:56 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::4:d798])
        by smtp.gmail.com with ESMTPSA id d19-20020a170902c19300b00161947ecc82sm403281pld.199.2022.05.20.19.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 19:46:55 -0700 (PDT)
Date:   Fri, 20 May 2022 19:46:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 13/17] HID: bpf: allow to change the report
 descriptor
Message-ID: <20220521024651.ngjv52kk7jrkt6mo@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <20220518205924.399291-14-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518205924.399291-14-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 10:59:20PM +0200, Benjamin Tissoires wrote:
> Add a new tracepoint hid_bpf_rdesc_fixup() so we can trigger a
> report descriptor fixup in the bpf world.
> 
> Whenever the program gets attached/detached, the device is reconnected
> meaning that userspace will see it disappearing and reappearing with
> the new report descriptor.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v5:
> - adapted for new API
> 
> not in v4
> 
> changes in v3:
> - ensure the ctx.size is properly bounded by allocated size
> - s/link_attached/post_link_attach/
> - removed the switch statement with only one case
> 
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  drivers/hid/bpf/entrypoints/entrypoints.bpf.c |   6 +
>  .../hid/bpf/entrypoints/entrypoints.lskel.h   | 965 +++++++++---------

Probably add the lskel once in the series to avoid the churn.
It's not reviewable anyway.

>  drivers/hid/bpf/hid_bpf_dispatch.c            |  77 +-
>  drivers/hid/bpf/hid_bpf_dispatch.h            |   1 +
>  drivers/hid/bpf/hid_bpf_jmp_table.c           |   8 +

I'll take a close look at dispatch logic next week.
