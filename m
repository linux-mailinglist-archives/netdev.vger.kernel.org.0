Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7A64C46CD
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbiBYNm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbiBYNm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:42:27 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C6F49F2B
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:41:55 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id n185so4476075qke.5
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=V83goiqYyGQpz53d+mmf7MQS3t+Z9Y1WIlxPTksW/2k=;
        b=WQEzx7ZUuhLiVdKdscZ2OVoRp/gF9KV90HiAYBYkFxtrc4+qo1zPxqpp2n5/peQNH+
         8SkkGiKjue3ggp58s5Nb3rw27XIvQkSWKALxbMwwU3idTf1Xd5/40YISHMa9UuVNGvWM
         bmbjYM82MkK9MuZteqwkCE3+9ytILhrBhwmVeI785OnfCZA5ThH/IKCKncDn87nQFITB
         46y15sY6Xh5ta89t5QGVkqXrzj1pYAD1FDK0WaqZmhUMVsv8UgS/QsobddgMjOD6YLpJ
         dCqXlMQ6K2PrrqR/S8PIIgZAhp3Y9Z9MYL2kbAvuRj7mAEYuU1/4tXl0hvYnYRIRZOtJ
         huAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=V83goiqYyGQpz53d+mmf7MQS3t+Z9Y1WIlxPTksW/2k=;
        b=OTx3+RfssfM0elgET+LjTy/9DLFa93k+xZiBcNdywM0gkuxuhEuffEey0rrO8vUM6n
         2F+s7Ui48BbtQEdFU6CHj54dI8Bbw+R4QzD1cSxH0Ke/0TLabO4BWaZxNT7nPLAkq0CH
         RaUHpLLk8kCsjxtdc/EGh2kT6EVTPC5H57l2CFiGM73ODpEQL9Vx8wT/FAmR7y28yp3c
         /3JFiwrhPxvf1nSHJo3RyzW5G8SgnbPgVaqPkef6ATlVb3lCK7TTx64pV8g4p+hiPF67
         G910H97iYcyDCQPbfoZXJp6EJ1BtvbkjKxQToBOQNOnwhCI0cWx87/wqOFQwbGCo09se
         jhXg==
X-Gm-Message-State: AOAM532llKBrMT4i5zz6Bqaj+aRylgRNKg0zhepK+bfBpM4mXZnL0uor
        Dt/Q63R2ri+H+y8UVvZkNDlkgcioQRXLksn0
X-Google-Smtp-Source: ABdhPJxhj+4Ta8cKetNhte+HxrNPD8zFxBlshZu89PiwziIqhFgzma7NtqO/yve/DOoELRIHSAGclw==
X-Received: by 2002:a37:a38b:0:b0:506:bebf:f51b with SMTP id m133-20020a37a38b000000b00506bebff51bmr4709794qke.280.1645796514287;
        Fri, 25 Feb 2022 05:41:54 -0800 (PST)
Received: from sevai ([74.127.202.66])
        by smtp.gmail.com with ESMTPSA id g1-20020ac87d01000000b002d5c8226f17sm1548447qtb.7.2022.02.25.05.41.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 05:41:53 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, paulb@nvidia.com,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        flyingpeng@tencent.com, Mengen Sun <mengensun@tencent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: ip: add skb drop reasons for ip egress path
References: <20220220155705.194266-1-imagedong@tencent.com>
        <20220220155705.194266-2-imagedong@tencent.com>
        <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
        <CADxym3apww2XEeTX=kU7gW5mbQ9STwVyQypK4Xbsmgid9s+2og@mail.gmail.com>
Date:   Fri, 25 Feb 2022 08:41:28 -0500
In-Reply-To: <CADxym3apww2XEeTX=kU7gW5mbQ9STwVyQypK4Xbsmgid9s+2og@mail.gmail.com>
        (Menglong Dong's message of "Fri, 25 Feb 2022 14:05:08 +0800")
Message-ID: <85v8x3xdvb.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Menglong Dong <menglong8.dong@gmail.com> writes:

> On Tue, Feb 22, 2022 at 11:13 AM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
>> > From: Menglong Dong <imagedong@tencent.com>
>> >
>> > Replace kfree_skb() with kfree_skb_reason() in the packet egress path of
>> > IP layer (both IPv4 and IPv6 are considered).
>> >
>> > Following functions are involved:
>> >
>> > __ip_queue_xmit()
>> > ip_finish_output()
>> > ip_mc_finish_output()
>> > ip6_output()
>> > ip6_finish_output()
>> > ip6_finish_output2()
>> >
>> > Following new drop reasons are introduced:
>> >
>> > SKB_DROP_REASON_IP_OUTNOROUTES
>> > SKB_DROP_REASON_BPF_CGROUP_EGRESS
>> > SKB_DROP_REASON_IPV6DSIABLED

Is this a typo and should be SKB_DROP_REASON_IPV6DISABLED ?

[...]

