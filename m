Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0CB41A74B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhI1FyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhI1FyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 01:54:05 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0CCC061575;
        Mon, 27 Sep 2021 22:52:26 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id m132so9200947ybf.8;
        Mon, 27 Sep 2021 22:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6RSWnN6k15haSaDV0km0zLY/zU+uT+FyT3eyQ+b4io=;
        b=G44Q7JX6YuthrhC0K0mE/YTtXYTVmb2FA1ig1zH/MFG6LKYrsfBNvgGqs/kS8lxUt1
         RSJxL0E6KdksGvLZ64Ita57Q/iLYqlUAybcXihGsMii2oZsr5YyS2jvnvDnE8tAa14v/
         pTM8nODn9GjskSmsTdvN5onNlNdIFBBT51YKdkQhZFToTA8SwGwC/2PfxR+aJ+5b57HQ
         SQngWtwW2+Kf26+JACZ2PKKWO5Qxe+W9XdqEfI2dQdU0xH0awkU6jpYrrOJgImpyVxdZ
         lrEYG/chJ80n67VbTC7eWZDf3dEql/xvxyOd0DpTjcm0aljTSMdKexu5C80KyGbcyAB4
         VY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6RSWnN6k15haSaDV0km0zLY/zU+uT+FyT3eyQ+b4io=;
        b=r4CoVb4deAb5qLq+duaqVNf/Dkec7/EvdrFGDARUXi9Q4i1Sw2pK6PN/F8rf6RjSJF
         chF7ojmDea0juQfMto209SLz+yKC29ZRnbvn5KABur3sLdGvLohMu1g+fr9XjenIbBu3
         rzVY0ecGyOrBc4PahwllG95YU+gnP0apB/fZoEzWb0N6Y0Ex7nkW1RnJ8CuU4O9VxfCn
         DYv+j4DVriPv0BwWcs4H7eNkOFz9nqzUDQc1lC8mGWoKN7iWhYLR30ipvmrhbXdBe1bu
         eLoGcwMni57C3qfWjVpCS/7nWVPngZ/j8FL8wM/wCgzx2js55ksjWO6Zf7jG5M2GZges
         YvhQ==
X-Gm-Message-State: AOAM531bOjn248iOTkvh3Zs1fTgeyhxu36K+BmOdnUIJ5gPELpht6fo8
        hc/xdE+WaER4MYRPX1MrVQ0t6NNHSL29H0nY+lg=
X-Google-Smtp-Source: ABdhPJydKeMVM2mv8SaG1jgR/LtJ0SI70OGzxsTvbSnxqgeZKbAEO6xhWDHjRB5gax9+HSazl27WVAlkKUZWk0f1HoE=
X-Received: by 2002:a25:af4a:: with SMTP id c10mr4634454ybj.482.1632808345815;
 Mon, 27 Sep 2021 22:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210922093259.164013-1-liujian56@huawei.com>
In-Reply-To: <20210922093259.164013-1-liujian56@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Sep 2021 22:52:14 -0700
Message-ID: <CAM_iQpVDiA8-GHXYrNs8A4gBaDioWMPeQR=2u4OKn2ZCyzu8Lg@mail.gmail.com>
Subject: Re: [PATCH v3] skmsg: lose offset info in sk_psock_skb_ingress
To:     Liu Jian <liujian56@huawei.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 2:32 AM Liu Jian <liujian56@huawei.com> wrote:
>  static void sk_psock_skb_state(struct sk_psock *psock,
> @@ -604,6 +608,9 @@ static void sk_psock_backlog(struct work_struct *work)
>  {
>         struct sk_psock *psock = container_of(work, struct sk_psock, work);
>         struct sk_psock_work_state *state = &psock->work_state;
> +#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> +       struct strp_msg *stm = NULL;
> +#endif
>         struct sk_buff *skb = NULL;
>         bool ingress;
>         u32 len, off;
> @@ -624,6 +631,13 @@ static void sk_psock_backlog(struct work_struct *work)
>         while ((skb = skb_dequeue(&psock->ingress_skb))) {
>                 len = skb->len;
>                 off = 0;
> +#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> +               if (skb_bpf_strparser(skb)) {

If CONFIG_BPF_STREAM_PARSER is disabled, this
should always return false, hence you don't need this #ifdef.
Or alternatively, you can at least define for nop for
skb_bpf_strparser() if !CONFIG_BPF_STREAM_PARSER.
And you can move the above "stm" down here too.

(Ditto for the other place below.)

Thanks.
