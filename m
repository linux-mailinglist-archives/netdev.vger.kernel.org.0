Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647C35754D8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbiGNSWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiGNSWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:22:33 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA0E691D1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:22:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o18so2301455pgu.9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5zPRWQ1A3HhjiHH3r95abd4aE/ZbONHHNX3GXYIirVo=;
        b=APDVKU6bfSUHJjV5BEp6HqxSVjmCoxgT1bxWYDDWducYmhZp8+T7ej/Vm2zsL3LsS3
         m7a8CkFrBhJI+T4YqANO/L2rJWu7Ik2GIR1/aXd6+/V3P9aDBPkFXhciUAfqQH3hL181
         SO/otGibcY9hrJvMTbBQNyDTk3ncy1KwxfH93v9pLGUv9t3ph2MzYn+aLHZ8H/S3KH3I
         Vc6+O4rtoz6LSlEhsIxLUyDIRSI21QnMUpPHZKZYNGqnSEV/p8NXVFD4j+aDz0hmiey/
         uo3VwNjg9IHqxooQVo6h5GsB6S3zaU59jCilN5lrbneKJuKX+N4tnjf8pH/M9wO3nsMl
         drkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5zPRWQ1A3HhjiHH3r95abd4aE/ZbONHHNX3GXYIirVo=;
        b=hukLVrfrP9dvSRPqFOQa5jdrRzsMbK2HlDoAdDvpsfdYAjSREplTU0RDSrksnv7RxG
         1ibuMC1yquOcDDZJWp4onpaWeMjebMrVIKk2l+R2Y/0m8CuUmQ6DEGO4SGeJJoq65eWT
         EQn1AtgYmXXGgyV+fYlAk1luS+139CtOUbI5bHQAwCTNaFcgB+xQSfGr8nL2F9ZSbGbE
         BbVDTwPrRfOzLrFv0hz9igweO5JN7553/n0fr1zXIelfuFPRaTenhvWWqoM6En9bXELr
         qQvtF9L7ssj0kUYV5wuGV1uKfExVN8O/e1Ey+kW0ES8+kHHjsPfqN8hNzjR/uP6p6ikQ
         lXuw==
X-Gm-Message-State: AJIora9l4R9aNelexpNyrpZyH8xGuhKNHmL9wtNtAOlsa+X/ZTKjmFJN
        dY21HptFxmVm9FGH2qonxRO4IZeNCKRZFVIpRSdVHw==
X-Google-Smtp-Source: AGRyM1ubCAbKNQQNejRE37scb5N4g9UCmG2711DuCHlweThIxvaS406NX5VL4fAk3zfPnsbRFIqaVUSOxjoV6taZPz4=
X-Received: by 2002:a63:85c6:0:b0:412:a94c:16d0 with SMTP id
 u189-20020a6385c6000000b00412a94c16d0mr8834610pgd.253.1657822951249; Thu, 14
 Jul 2022 11:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220714060959.25232-1-shaozhengchao@huawei.com>
In-Reply-To: <20220714060959.25232-1-shaozhengchao@huawei.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 14 Jul 2022 11:22:20 -0700
Message-ID: <CAKH8qBtxJOCWoON6QXygOTD7AqjF+k=-4JWPHXEAQh-TO+W54A@mail.gmail.com>
Subject: Re: [PATCH v2,bpf-next] bpf: Don't redirect packets with invalid pkt_len
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 11:05 PM Zhengchao Shao
<shaozhengchao@huawei.com> wrote:
>
> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> skbs, that is, the flow->head is null.
> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
> run a bpf prog which redirects empty skbs.
> So we should determine whether the length of the packet modified by bpf
> prog is valid before forwarding it directly.
>
> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
> LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html
>
> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Stanislav Fomichev <sdf@google.com>

Daniel, do you see any issues with this approach?

I wonder if we might also want to add some WARN_ON to the
__bpf_redirect_common routine gated by #ifdef CONFIG_DEBUG_NET ?
In case syscaller manages to hit similar issues elsewhere..

> ---
> v1: should not check len in fast path
>
>  net/bpf/test_run.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 2ca96acbc50a..750d7d173a20 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -1152,6 +1152,12 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>         ret = convert___skb_to_skb(skb, ctx);
>         if (ret)
>                 goto out;
> +
> +       if (skb->len == 0) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
>         ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
>         if (ret)
>                 goto out;
> --
> 2.17.1
>
