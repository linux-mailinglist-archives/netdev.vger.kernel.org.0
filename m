Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889B557004E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiGKLXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiGKLXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:23:07 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914D237FA8;
        Mon, 11 Jul 2022 03:51:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w12so4988016edd.13;
        Mon, 11 Jul 2022 03:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VK08yQTJ99mufpNp27xubsdOIIjMExE65sg5hpJC6W8=;
        b=iZzvVctewcKQocbxZXTD2xaYK71jGE8DBwGmiIb7/RjBQGsQAP2re8q9deGfdCBYPM
         q45s+T/m6yLcGhYjLphHnlB1HcFU0reX2CLEqA4HLzFlklecDyYu9OiCkuyCLTWj+ELS
         KkS73iukQ+5Bv8yXy3Uv2AkPoxkBKiKlgmFv8odpUX2hN0vIAj9IgGcN/fsPhVJtoOq6
         zmn3kBYgbIFHg06ZWrQuOK1PhxmSDLzTpx21+9thhv0J0P457fwqlG8kiCGzgT5BEM9b
         3lCtwNC3dL39cY9COM1weGQMOjVM0vNavUrUKe3MXRELxtirtC8QX+cbYc5RxXwCBguX
         j+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VK08yQTJ99mufpNp27xubsdOIIjMExE65sg5hpJC6W8=;
        b=QxoJJMhD1GwmkadlY49FXT1ROiNT+/hMTFDy6KHW0hRXq/tOxMKtGWeqYFqIrHj4B0
         CDfkQuz+IuBw4VvziD+29qVfzS1Z9AJdJmqNVawm12mKbuWuO4NlF5QBeykkWtElVa3a
         nl87ZaYGWhhhraCQWHLkQRmLoeXywHocnB9uhaAJyU9cRsrHKA5dYQckLmKeXcneC5tC
         ivFdaL3RrIWVuxx/iRJRKT2uO4fzMV2lwG8ZiHCCnSTn1OodGjRz2p94D4RNcxdtfwIp
         AwypqrIYpNQQkhjeH5JiflKkgKsZVC4UXx7gWKzQnwdCHvbRvf9Cfu6pFIw4GYZwikRp
         kVrA==
X-Gm-Message-State: AJIora9XRXcSM6QMcVfJQI33rhk0s19V6GVwM84+YYcs50Rz0E895CVB
        RCSCnbldGFMT2y5LK+5kikc=
X-Google-Smtp-Source: AGRyM1t03riDeHSSHc5gIxP5aK4wSoVRCftx91lEkKDrESYg55vCCJalA11JLAomTLJTSjy4CieWWg==
X-Received: by 2002:a05:6402:d0a:b0:437:66ca:c211 with SMTP id eb10-20020a0564020d0a00b0043766cac211mr24216273edb.29.1657536687051;
        Mon, 11 Jul 2022 03:51:27 -0700 (PDT)
Received: from krava ([151.14.22.253])
        by smtp.gmail.com with ESMTPSA id g12-20020aa7d1cc000000b00435726bd375sm4121080edp.57.2022.07.11.03.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 03:51:26 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 11 Jul 2022 12:51:22 +0200
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>, dvacek@redhat.com
Subject: Re: [RFC PATCH bpf-next 0/4] bpf_panic() helper
Message-ID: <YswAqrJrMKIZPpcz@krava>
References: <20220711083220.2175036-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711083220.2175036-1-asavkov@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:32:16AM +0200, Artem Savkov wrote:
> eBPF is often used for kernel debugging, and one of the widely used and
> powerful debugging techniques is post-mortem debugging with a full memory dump.
> Triggering a panic at exactly the right moment allows the user to get such a
> dump and thus a better view at the system's state. This patchset adds
> bpf_panic() helper to do exactly that.

FWIW I was asked for such helper some time ago from Daniel Vacek, cc-ed

jirka

> 
> I realize that even though there are multiple guards present, a helper like
> this is contrary to BPF being "safe", so this is sent as RFC to have a
> discussion on whether adding destructive capabilities is deemed acceptable.
> 
> Artem Savkov (4):
>   bpf: add a sysctl to enable destructive bpf helpers
>   bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
>   bpf: add bpf_panic() helper
>   selftests/bpf: bpf_panic selftest
> 
>  include/linux/bpf.h                           |   8 +
>  include/uapi/linux/bpf.h                      |  13 ++
>  kernel/bpf/core.c                             |   1 +
>  kernel/bpf/helpers.c                          |  13 ++
>  kernel/bpf/syscall.c                          |  33 +++-
>  kernel/bpf/verifier.c                         |   7 +
>  kernel/trace/bpf_trace.c                      |   2 +
>  tools/include/uapi/linux/bpf.h                |  13 ++
>  .../selftests/bpf/prog_tests/bpf_panic.c      | 144 ++++++++++++++++++
>  9 files changed, 233 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_panic.c
> 
> -- 
> 2.35.3
> 
