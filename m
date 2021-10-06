Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1504239E2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhJFInm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237689AbhJFInl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633509709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=kCM5Cd96ErOWY02ACkCheEUVdabLFYsQ9bA/skAUy2g=;
        b=DFaFj5dhMPlLF+p+CGAa804WKn+u7Xfd/ecAYNtePPw8KuApWovJ9T1EUDRodllzbYcn5h
        zomTRZrc/XM7cwUEUVCHrpPv2MoMZHqGKKOW6b9vflC5E+Om3A79RcCGsS0qL6f6rlFdhQ
        qGdmT+mlhsX0OS1bYEEchyCOCOmxdK4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-PWQqdehvMiyAInJeDghw_w-1; Wed, 06 Oct 2021 04:41:46 -0400
X-MC-Unique: PWQqdehvMiyAInJeDghw_w-1
Received: by mail-wr1-f69.google.com with SMTP id n18-20020adff092000000b001609d9081d4so1411877wro.18
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 01:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=kCM5Cd96ErOWY02ACkCheEUVdabLFYsQ9bA/skAUy2g=;
        b=gB+Ag+itZUcfkdvw6Gm9PrPSxlVEuNJtpZmX/Cz3W5njqhoXByn6NXZyt+x70au9ve
         vCYS3o8f/zb4NI+W4wklvmM0vtL5W8WxVDl06ptvLKA070G+HVkVl8jAzsja8w58Hjcm
         Rd7B4NNuYt+9Bp/IuXK8d8vF0IJcc8KFk07xJX6y273GS7PHzwmjzVEz/THEIn/DFT4j
         ZWo6452/6AtKLIMZk65NnEzsTrs+ow0tU0u1wXg96tZHl1lXZtWH8gPExWR4TZaj/eRt
         k81wEfyGDUUUYKXeQxStiavkYVvWqY3ICRhOEB+3HnsZjJsUCrQnl5mN3RRdfYxIe5UN
         ZEJQ==
X-Gm-Message-State: AOAM530oz16TFeUeUE4J1XnXlJa07F8yfMqhFvMGu918avV5OVSu2Pwa
        oW+IOtnbKxPcRccsgz3RQsXBKiTlmbMZj6pdCMvj/pRmD+YAvNSk+zPAf7ea3wHGAddBwhcb4Vf
        Tq6IO6McJ81ZtHZyU
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr26820124wrz.29.1633509704958;
        Wed, 06 Oct 2021 01:41:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJazLLM1necO1ye/IiTmHNlGHLpHbFM5oSXAMFwHCqJbSbwa09gbfnF4TukdWCIjeWX0UvvQ==
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr26820099wrz.29.1633509704757;
        Wed, 06 Oct 2021 01:41:44 -0700 (PDT)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d3sm23167544wrb.36.2021.10.06.01.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 01:41:43 -0700 (PDT)
Date:   Wed, 6 Oct 2021 10:41:41 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [RFC] store function address in BTF
Message-ID: <YV1hRboJopUBLm3H@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
I'm hitting performance issue and soft lock ups with the new version
of the patchset and the reason seems to be kallsyms lookup that we
need to do for each btf id we want to attach

I tried to change kallsyms_lookup_name linear search into rbtree search,
but it has its own pitfalls like duplicate function names and it still
seems not to be fast enough when you want to attach like 30k functions

so I wonder we could 'fix this' by storing function address in BTF,
which would cut kallsyms lookup completely, because it'd be done in
compile time

my first thought was to add extra BTF section for that, after discussion
with Arnaldo perhaps we could be able to store extra 8 bytes after
BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
indicate that? or new BTF_KIND_FUNC2 type?

thoughts?

thanks,
jirka

