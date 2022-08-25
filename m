Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1381D5A0746
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbiHYC3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbiHYC3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:29:37 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADB8923CC;
        Wed, 24 Aug 2022 19:29:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f4so14818503pgc.12;
        Wed, 24 Aug 2022 19:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=WBu8LmrRIK+SDkVgV6rJt4O1S6Q3tUu803Yb2Y/vIow=;
        b=a0FyiuDPR7RV5jJ9oRUOpgFn1LmdXdCeo0MVMd+Oh6mv8pV0QmkkFNjOCEQXwVgWQ3
         vvFRAyTxKm/MeBKl3h7oMlkZgtAjqAtwLCn/SguIxamHqHzl8HJ0Ncmps6RZzttUUicm
         q9eGpJiZDNkuwpUQY0fZ2NnOU8bPM2YTszpf3Gjwero7TBf/sN9jQi806jzl8Y3QnVUT
         17cKHqlWU3FajGbk4nq4sq1ABlxNv7u8AFUv6JLyK8K+iHLiS5Uk4ShttSBeHpHQnd58
         cHotG1udn/Q/1Su5bJOFzBgToOUzdjckTra/ApNZgeQTceIbCc3smxJjeM4SiYSr8cg9
         MyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=WBu8LmrRIK+SDkVgV6rJt4O1S6Q3tUu803Yb2Y/vIow=;
        b=VP17OATRdQoQWFDoEygk8QT9+vQqeze9GcZfLCeUPxQb21BSuIQ+CdnflGrkjVB/on
         0Lmx9PqfLuZ0XUQbKTmKNdD/Tkl9aEG+f3O/GfpV3MtFzsfKt1jwuyxlhWcuMP5YXJjd
         iKiTsfhQOx8b4qDjMnl34vwKQ6AOOD+xwIYY+yTo309eDeZ+EfocpuoYe28Tqm6uVNVf
         I9BQYmBEONq3/vZku43DGgSBz3gzq/zQfF5FQgzYmU923+GGSipZ+h7NIA6Z9DWJzk4r
         IZmaxcij1fuDaeJU7SiHDh7CaDJec1o87KYsS7JTLOw46bAr6gdT7MobOCzaNfljOkQd
         kRig==
X-Gm-Message-State: ACgBeo0TGT8Te8axPTTEfB0lvD+2DcPU4J+p0yB/49Uk69tD0NP4L1H2
        ilE9e/J67iW4Z7KlsY01mZzEvQhBze/9BDZoaDk=
X-Google-Smtp-Source: AA6agR4YLgnYTXuG0xNeI1QEYwv15AKD5FH1WMvHRYSMEzxLBwlSug14r2fpyI94iip/mFs/hevvNr+qgHSxAYu69ds=
X-Received: by 2002:a05:6a00:a05:b0:534:b1ad:cfac with SMTP id
 p5-20020a056a000a0500b00534b1adcfacmr1938835pfh.35.1661394576605; Wed, 24 Aug
 2022 19:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220606022436.331005-1-imagedong@tencent.com>
 <20220606022436.331005-3-imagedong@tencent.com> <CANn89i+bx0ybvE55iMYf5GJM48WwV1HNpdm9Q6t-HaEstqpCSA@mail.gmail.com>
 <20220824181040.57ec009e@kernel.org>
In-Reply-To: <20220824181040.57ec009e@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 25 Aug 2022 10:29:25 +0800
Message-ID: <CADxym3bC8=cLp4_n9OTQpV_Hw=XuTZySr96RrahQXfAKt0q2=g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: skb: use auto-generation to convert
 skb drop reason to string
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Thu, Aug 25, 2022 at 9:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Aug 2022 17:45:15 -0700 Eric Dumazet wrote:
> > After this patch, I no longer have strings added after the reason: tag
>
> Hm, using a kernel address (drop_reasons) as an argument to TP_printk()
> definitely does not look right, but how to tickle whatever magic
> __print_symbolic was providing I do not know :S
>
>         TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
>                   __entry->skbaddr, __entry->protocol, __entry->location,
> -                 __print_symbolic(__entry->reason,
> -                                  TRACE_SKB_DROP_REASON))
> +                 drop_reasons[__entry->reason])

it seems that TP_printk is not as simple as I thought.......

Sorry for the problem I brought, I'm looking for a solution.

Thanks!
Menglong Dong
