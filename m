Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB04598A76
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbiHRRbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiHRRa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:30:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66679C2EC;
        Thu, 18 Aug 2022 10:30:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z2so2764116edc.1;
        Thu, 18 Aug 2022 10:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=erWfx2JL8VWK/Fye7TEq9V21Uimrc0ebZ49GLDL2zgo=;
        b=Lz2iNaQP2P0Z6N2IOph6qWi1Zxr2Wk+aNsIAu4DHI96Idb2HK2EYVji9rPh1UZ2m86
         kQgUgs5De791SDHluwVuxaNRYPvXlHmnO44ZXI/9K+HJt2VTCaHkEZO0FCmEFvH7hI+0
         brnFtbsQB3eCUJOhrb2WRjmM+G8N7bonDL1bSlEnVaKrsHMa0hkaOcIh/MfGl8AVe9CZ
         Bd6VB5Ja0Y6kphczVBVOwpTmbgFLKDYcFjP+Zs2w5pwz6JDYnut4Z3SCRMqIr8gRSUsJ
         ZT4mX2cvVpT4iXV0YwY0N0PloTD7IhJonTfNn5D29rqawzXVHarkLx2vNNL59pndJ1uL
         urHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=erWfx2JL8VWK/Fye7TEq9V21Uimrc0ebZ49GLDL2zgo=;
        b=x0brWVHbDxf3z8kHnbKYXeUIZVssXmfB1P0BDgK+EutqWWkT/5m0gXJBfrks2Np2Dh
         9Yl/RuKbQyFKdwC1Aml+FCthm4Kekj090VUKEi/RYY1KvEz1dnSTK+eL35hV3iTtEwRV
         3C3gOKs/kfb6RMQx0DsAaSbl02IoE+BbbYK4xQ5TtXXMRfcfiVX2RgtTn56h7687gGc3
         guuAHtZQWTv9AA3ST1VgMwL9mRkB9cdwJ2BfQEdVUGD8IGNg21X/CYDfn1CWgGrNoSD7
         +3iQyCRmcl27x4CdvgnPyPnoLIYn4GhHezvaKFqqGsLlNcWjOcxns3K/jtVLdVtQj74l
         ru3g==
X-Gm-Message-State: ACgBeo3OvYeDG3KwhoLfCglh2AC5D+dKCmHA3XXksJiGXV70YxMK+DTD
        zX/s6z/PloD0MQueyPV/moUvWt/p33QeCMMWaFQ=
X-Google-Smtp-Source: AA6agR73spocumYGQcOQpcTXHqFeVLgovu5/02VF4b82mQEK8vuHOUDcMnSTLOchQ7KFX/R0+Ee3vWDHGtPvtToCOtI=
X-Received: by 2002:aa7:de8c:0:b0:440:3516:1813 with SMTP id
 j12-20020aa7de8c000000b0044035161813mr3125797edv.260.1660843856121; Thu, 18
 Aug 2022 10:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <20220818143118.17733-8-laoar.shao@gmail.com>
In-Reply-To: <20220818143118.17733-8-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Aug 2022 10:30:44 -0700
Message-ID: <CAEf4Bzbcs_k-NBgO7tky3brTraHFKLwEg1RQrhZNJVY7Tsbz7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/12] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
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

On Thu, Aug 18, 2022 at 7:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Allocate pages related memory into the new helper
> bpf_ringbuf_pages_alloc(), then it can be handled as a single unit.
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/bpf/ringbuf.c | 80 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 56 insertions(+), 24 deletions(-)
>

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index 5eb7820..1e7284c 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -59,6 +59,57 @@ struct bpf_ringbuf_hdr {
>         u32 pg_off;
>  };
>

[...]
