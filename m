Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9118A4BA861
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244352AbiBQSgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:36:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiBQSgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:36:31 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0EF38BE
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:36:16 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d61f6c1877so19990997b3.15
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6Lsp7FlapadhdH1wOBRbRlUuGM8Y5XYTfld2Xsf/MHQ=;
        b=NWEKxLoYxKR83vPwqaj94BPp4XeWLNRuYQkJrlY1+TaNY8F65Vnx/Xq2AvFe2aox4S
         9FIK893wrF2Y6UjpzZ6PEEZjiHNj82ksJ29EfHYYr4loikvHbhCBgvT9TCaf/KbHKHSM
         7UVfF5yWa51fuKhjCYQ/rf2pGeVPsEtyAWq/ALwKIw4ctgpeRBAVF1mrzWmOGXvuN/fz
         4bsJ6qXdHCoGf2auGyJNNpeAvfyCs6lGAcF/uksh95RCyXl2CGF8m2k0MvoTxfKFykXO
         uFYb5g5ydG0vmHMtc+5asSYnVYMjgbFM75dObo/9jMAefeltJ7rRM3XjX5qA6RDWKjhR
         TmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6Lsp7FlapadhdH1wOBRbRlUuGM8Y5XYTfld2Xsf/MHQ=;
        b=xVNenbrsO1SR1WXah6FKyhxiXMZ8a6lWqLKUDBvfKbQK3C2Lr1DByCGYcJHOxscP1s
         Bu3sKRQghY1bmflUTUdYx4fttCpYLa3AXkSlIWhWG2/MWkcIDePy0TSVPOVp0P62JHQq
         a9vqp94AffkI2km9D8OieuEgx672lj4mVqcsTNBbmYQ3RcR334DXX9169t5Ct2kiVQVH
         d9GUfTMal5pbNVvrXbBRtbabyVnbwST0ynZrUn4l73gKPJdoJy/pQgGGUMhAD59424rB
         3rxP108t+obol4sMPR3vOMcdJDqOWT5yfxhUz6MHyNQdTeteY80rpuNBKipzwtq0G8oz
         lTwg==
X-Gm-Message-State: AOAM533IvUkn72b9r06H2x6IOX0P4g/M40vkwpKKtI0fXO0ZGhrMhMit
        mDJe4kRKOnjDyd7UjlcoLasf+mA=
X-Google-Smtp-Source: ABdhPJyRxHhskWuW/CBOAI8gWW2FZMAD9pw3Z/+GP9xgEovW/ldcVZeL5j6mCvG4YM1PhAMfizDb20E=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:2e4c:d90d:2d44:5aaf])
 (user=sdf job=sendgmr) by 2002:a25:23d4:0:b0:621:c46d:5011 with SMTP id
 j203-20020a2523d4000000b00621c46d5011mr3706746ybj.172.1645122975685; Thu, 17
 Feb 2022 10:36:15 -0800 (PST)
Date:   Thu, 17 Feb 2022 10:36:13 -0800
In-Reply-To: <20220217181902.808742-1-eric.dumazet@gmail.com>
Message-Id: <Yg6VneDwR9su3D4u@google.com>
Mime-Version: 1.0
References: <20220217181902.808742-1-eric.dumazet@gmail.com>
Subject: Re: [PATCH bpf] bpf: add schedule points in batch ops
From:   sdf@google.com
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/17, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>

> syzbot reported various soft lockups caused by bpf batch operations.

>   INFO: task kworker/1:1:27 blocked for more than 140 seconds.
>   INFO: task hung in rcu_barrier

> Nothing prevents batch ops to process huge amount of data,
> we need to add schedule points in them.

> Note that maybe_wait_bpf_programs(map) calls from
> generic_map_delete_batch() can be factorized by moving
> the call after the loop.

> This will be done later in -next tree once we get this fix merged,
> unless there is strong opinion doing this optimization sooner.

> Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete  
> batch ops")
> Fixes: cb4d03ab499d ("bpf: Add generic support for lookup batch op")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Brian Vazquez <brianvv@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>

Looks good, thank you!

Reviewed-by: Stanislav Fomichev <sdf@google.com>

> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>   kernel/bpf/syscall.c | 3 +++
>   1 file changed, 3 insertions(+)

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index  
> fa4505f9b6119bcb219ab9733847a98da65d1b21..ca70fe6fba387937dfb54f10826f19ac55a8a8e7  
> 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1355,6 +1355,7 @@ int generic_map_delete_batch(struct bpf_map *map,
>   		maybe_wait_bpf_programs(map);
>   		if (err)
>   			break;
> +		cond_resched();
>   	}
>   	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
>   		err = -EFAULT;
> @@ -1412,6 +1413,7 @@ int generic_map_update_batch(struct bpf_map *map,

>   		if (err)
>   			break;
> +		cond_resched();
>   	}

>   	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
> @@ -1509,6 +1511,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
>   		swap(prev_key, key);
>   		retry = MAP_LOOKUP_RETRIES;
>   		cp++;
> +		cond_resched();
>   	}

>   	if (err == -EFAULT)
> --
> 2.35.1.265.g69c8d7142f-goog

