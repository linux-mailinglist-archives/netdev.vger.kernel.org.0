Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C97952F794
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354311AbiEUCeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiEUCed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:34:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0746CAAA;
        Fri, 20 May 2022 19:34:31 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gi33so10096184ejc.3;
        Fri, 20 May 2022 19:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OmUAeDR0TRV7SxilODIYAOrku1SUUUQv1Du25gnTb+Y=;
        b=ENS0qiDkwFBU3jh3VmJQbyVywG3fnDR0qv6NRFLsNfagC28/lj9E3LMiZK1Ec20BmI
         VtiBNgZw/mbAqvIsJ3IOOE0IyafDvr5xm0FikzAYWGu2cHnGafihMpM2dzNiPSH8q9yz
         Z360XBNeAARFJEP4ChWyCxnQ6p3yyCG8sjEVszXsO7xEVb6jDyWk5+NawpQafN4UuV/M
         gNPK61hgXDc8kxnJJTq33vb1YZV7SJdr/mnWGP5ajFx6vjxuVCMFJVlFmc1lq4RhPOgH
         GGvyN5EymkqbRslO7Z6E2KO8D94kDrPpHWryq3rht1trscCsJdHJBfXj9GYTQhBQRRHG
         2P9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OmUAeDR0TRV7SxilODIYAOrku1SUUUQv1Du25gnTb+Y=;
        b=OoFSZ38b1omQ31LhjY8S+Ss0Ja3OlyEmF0XoVUogbHv9JzbTvDpec2FzH+W5ZKPDVp
         gwrY1Vm0Ws15DOfXkF/oQCdOyBQfsR3zteqQ1nvc+Zo41HVdA9XnebnLJTTdqCnHB0Sn
         tJ8lxAUTDemtcGCA7uK01SynnPqXEZ+ZRuJQTEkthph8XGwoPLNfUlEj2o86Z817rk12
         3BYCyy7IZetynQRKQmj3nvBS6R9lQbYZ/8JI4p8sz5yMHGePfITDZyNs94k7XTefaD7B
         0Pi4KTIqhtOxtFIX1KIlK6ko1XbVdEyfWocIMyYeSET2NnVa8LUp/j2CKhEzlidjFyL9
         blPg==
X-Gm-Message-State: AOAM533Lsgc+M36eMCgJ6R2PE6ZuUhBUN68NIlJDag8wPe7mEM66/BQY
        lHG4NERkQatXG+iN0oqWSvcO1xjvsikl+JD2lWY=
X-Google-Smtp-Source: ABdhPJxUJ4Hs4KtFPNK+nVHlP9YeOQiBBFdsY9AbeuIzhgzFhLcpinJL9jfVK8/LuWijMuOZJ+J4ofnL7JmcGLIfBRg=
X-Received: by 2002:a17:907:1b1c:b0:6f0:10e2:7a9b with SMTP id
 mp28-20020a1709071b1c00b006f010e27a9bmr11413890ejc.58.1653100469907; Fri, 20
 May 2022 19:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com> <20220518205924.399291-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220518205924.399291-2-benjamin.tissoires@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 May 2022 19:34:17 -0700
Message-ID: <CAADnVQJi_g7geapPLAWkg1Fy+sNvhRNATE1enGT9F11cqdPeLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 01/17] bpf/btf: also allow kfunc in tracing
 and syscall programs
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
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 1:59 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Tracing and syscall BPF program types are very convenient to add BPF
> capabilities to subsystem otherwise not BPF capable.
> When we add kfuncs capabilities to those program types, we can add
> BPF features to subsystems without having to touch BPF core.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied this patch, since Yosry's work needs it too.
