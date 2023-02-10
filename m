Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738F8692333
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjBJQWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjBJQWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:22:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134471EFF6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 08:22:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ud5so17284935ejc.4
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KEhwVLBjChhK6i3IlnyyjqYdz5D+IzhEfJKipY92B1A=;
        b=jMNSSl9HoLF2U+Rkdua5iPXAikFU6kD5x7p8DIl6052ZPjbONJtjeLwSw5aTXJbbwG
         GZ3iBVMEz1V8c0r3ARAZhMl6KBVGbFIoS2oA3K53FyblmcJZDqEMsLiLNBWD3TPzqO/P
         7uoMMm5X1/V4UWFRVh5gVLkjFHfnWD0RYKzkYPc00ZqVvAPPj2ipuj62Xne4UCS+La+V
         V2v5XtDFPGxWUUOCv+UnuLLb72IX/u6OUskRqMCsT4ot1xMLWPbPgUYci7HLXYGicg9b
         qeTtitDzt/D1Djbz18M7gbyy/t9Y0RMk3+KwrSa1XgyH6An6C7KvIrWGGq87RF7AvPMU
         v8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEhwVLBjChhK6i3IlnyyjqYdz5D+IzhEfJKipY92B1A=;
        b=FYQerV4x4N+gVdHc9NuwFFdsPJ3LQM7pn4fNEbnNMMbQTguGmFwu96Qc/G6kXcd3bq
         cGPavGCe+BVNp5mbIpw0mD2ToCb8VVyt4JvCgRIyFnFwYOihp7mdI4xlYzCj6/5ZBOk+
         vdgZSvAXX7jteRzsWIIaZWlFOle2ap9uaXbVMZd6vBeYEL80hwv9NxXB97yjVHzEvCj6
         l89SW3zVeLwvYglQoMBLI6T+/xW3VKa7opkaXvH9Sw533p0B3dlT5oZkmJB9uzRJcAQf
         pc+vxWV9+Q7KSEbwfw/JJDBxUwueCnVGc4mOTUPS9wm2DV3NpxjgXanPmJKlh12cxHG0
         xM3g==
X-Gm-Message-State: AO0yUKU8kjG9uNJxyruiRiq/fce3ZQgzJXo+toojrtbRFRoaXRGvKNDs
        Lxw8d7zIZG/YlFEyppnqYN8GSA==
X-Google-Smtp-Source: AK7set+3YfULw1kTxf3qFffGXDUDjZkeoUSY2n9ekPb7p7FzKfdw74DFAmWrrWeD3RSVbwRNEh3pmg==
X-Received: by 2002:a17:906:c310:b0:86a:833d:e7d8 with SMTP id s16-20020a170906c31000b0086a833de7d8mr14833032ejz.17.1676046145572;
        Fri, 10 Feb 2023 08:22:25 -0800 (PST)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id n8-20020a1709065e0800b0087fa83790d8sm2613656eju.13.2023.02.10.08.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 08:22:25 -0800 (PST)
Message-ID: <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
Date:   Fri, 10 Feb 2023 17:22:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Davide Caratti <dcaratti@redhat.com>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230210093205.1378597-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin Liu,

On 10/02/2023 10:32, Hangbin Liu wrote:
> Some distros may not enable mptcp by default. Enable it before start the
> mptcp server. To use the {read/write}_int_sysctl() functions, I moved
> them to test_progs.c
> 
> Fixes: 8039d353217c ("selftests/bpf: Add MPTCP test base")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 15 ++++++-

Thank you for the patch!

The modifications linked to MPTCP look good to me.

But I don't think it is needed here: I maybe didn't look properly at
'bpf/test_progs.c' file but I think each program from 'prog_tests'
directory is executed in a dedicated netns, no?

I don't have an environment ready to validate that but if yes, it means
that on a "vanilla" kernel, net.mptcp.enabled sysctl knob should be set
to 1. In this case, this modification would be specific to these distros
patching MPTCP code to disable it by default. It might then be better to
add this patch next to the one disabling MPTCP by default, no? (or
revert it to have MPTCP available by default for the applications asking
for it :) )

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
