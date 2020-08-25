Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E63250CBB
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHYAFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgHYAFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:05:36 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9002C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 17:05:35 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id b17so5876294ejq.8
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 17:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qSJ3hn6SwlvnIDydC8UlMXM4TqY2oPyCDRxRi3ibWKE=;
        b=QApUvtXGB19mVLe2YJN+0fc/ADwHcSDUAddvOk2oAlHGx94SRMwAiMJTJvczmY5/LJ
         5H8+z7s7ZKd4wBvGD40WowzmVgvVsHC7ykBwWbntxs+LCdWQ0VlGq5aJy0tz0qdKFdin
         uqbcvQg3gw5dEsFtO/tv+zUPbf76fN0Xd+WIdO2tZWQV+cPBuKHwpaS0iqoIazyjb0WC
         0VZo8VziYEC6cUStvp9KOD1OLo0QqjVFLoqT/QcWYj/HyXpaO7wUMO/DhvkzYkOkf+Q8
         50J2vA7dD1LC81Uhbyha05eeIKaAFh7rlFdSCBn2tV5rFA3cEm13F4JrxvRfM0oeesYi
         BmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qSJ3hn6SwlvnIDydC8UlMXM4TqY2oPyCDRxRi3ibWKE=;
        b=tjD6OR02e3dryPyVZVnmIUfkz5asYsFSlANb8SF3ns50CM0XmRX+19tfyKSCUG4Nmv
         Ez8EIEFTEKr30f57uoE6DywR+N6N7R2cg6gomCfIUtT9AEBkcMp6No2QMQAPm1IbKh0u
         nQL7f6NDcCG5iGBebDcx2Ar1K0ycOnQP1DhD17p0XyTkH2BpPLn6o/wwpqABNnooYNgW
         qBhTbE2E83u9g13S+UI3Jj3gIq8W8UsHzBkttt6zmsfvFqDN8x2spVxf4dSfsZGtAiBT
         RJcetUWaB1w9hi+LECnKLfI5MVSKI9hDlgKEbzPeCthSSQA7SdFvFAqUeDaZCPx3eL+h
         WsTQ==
X-Gm-Message-State: AOAM530/OovUYr99/w567y38/rCf9Zrj2MKY4wdapNzLgvf+6vleQJ8a
        Kw+adDDPSQFpWRRBfW3uSY1FH5o6dcmUPDUioW1HZA==
X-Google-Smtp-Source: ABdhPJwq7yY0fgxViANrAk7HQzEo+kQDYpeeuJOcuEDl5RbeTE9wZIRWTSGvgD/2fC4+y7BPhunkS6W3JpETlvNIrSg=
X-Received: by 2002:a17:906:a085:: with SMTP id q5mr7825181ejy.136.1598313933985;
 Mon, 24 Aug 2020 17:05:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-2-haoluo@google.com>
 <35519fec-754c-0a17-4f01-9d6e39a8a7e8@fb.com>
In-Reply-To: <35519fec-754c-0a17-4f01-9d6e39a8a7e8@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 24 Aug 2020 17:05:22 -0700
Message-ID: <CA+khW7iGs=tN2FT=rEiPZMQ_Z9=sqhRe4dY7dKbVoViwX666BQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
To:     Yonghong Song <yhs@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong,

An update on this thread. I successfully reproduced this issue on a
8.2.0 gcc compiler, It looks like gcc 4.9 did not have this issue. I
was also using clang which did not show this bug.

It seems having a DW_AT_specification that refers to another
DW_TAG_variable isn't handled in pahole. I have a (maybe hacky) pahole
patch as fix and let me clean it up and post for review soon.

Hao
