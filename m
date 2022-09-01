Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742AB5AA1D5
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiIAV7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiIAV7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:59:13 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43668B2F0;
        Thu,  1 Sep 2022 14:59:11 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lx1so177914ejb.12;
        Thu, 01 Sep 2022 14:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6nRTNwES/TP25PkA4VNbYU0TCi+KaNu8gfRomvbkU4o=;
        b=UUgdzrmBcX+jlf8KsQgJkO1M1b1asLxY52gnRqxWBKMUPwLpBSdxaBtDgklBXNLyx2
         /KhbghDF+ypVNKiYrMxfzdoG/lFyQO95Mz+N6AwZ4uKU8jWCBBXfwXIxPZIyKcObWm3+
         Nwkc3tMVfXH1MjRtejOs4bs3z10Hn0rm9o7LE/sFb7hMMcYE8T5ao/1+5nQ6x3eUePGR
         lno1Q5Me7UXeEYANBTYwGut4Dx3F09yHYR6I00+hr0lKdFscqMummzQuHTUdkvx3qFUC
         7Hb1pqXHot9bcnaqxNTCmBSfW2jJXPx+b/GqgqAuZ6L2jjIgjaTvOMddUxYjtkmzsEnR
         ltXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6nRTNwES/TP25PkA4VNbYU0TCi+KaNu8gfRomvbkU4o=;
        b=O3Uzf8tW/3u0ISLflWR29qfx87G8U1sdqlyE9mk6uPkINWdxMEqAhb565n3u+J7NWE
         NfrgXsrYHufUCvTI871No4+plrrbeRCF2KrSGpDq2QesMNkKnF+6pdiR7Dr0pBv11Vgg
         UNxJvCr1L/R3Nld23cM9DJDz6Gk0pyBmF71MK7LCLwxJ2bhs4e56sZl3cp2kbq3sJGUn
         UF4yxmGLG56D+PPNquDRPrfx5b1iQ++yrrCV++iBkcqGUVENTT8X0J66KJubLgATt/QQ
         dQUlCrs/iQG9Ne1mll5qiq1uIt8u3mmEHYxWtJaEOQICy+ce3O5E9qsOOBBixrLBxiJo
         IwMw==
X-Gm-Message-State: ACgBeo2NmkSGTL4V0b/2ZNv3cqzoNdYBYZ0PPfAqhTvkbmg/vdfMRclb
        QoH3AodG68Xo5NFGC4hqROhDHdhijuQf53euyZM=
X-Google-Smtp-Source: AA6agR41ZrDbt+/0ndt4nmpxwr3F3hVBJAniQXt6ez/iEHaAW6jIk+tGpXaGl9lIn9vO8Lw4WxNlXfmfnlJNbyWRQVs=
X-Received: by 2002:a17:907:3f15:b0:741:7ab9:1c5a with SMTP id
 hq21-20020a1709073f1500b007417ab91c5amr15271308ejc.369.1662069550326; Thu, 01
 Sep 2022 14:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220831183224.3754305-1-joannelkoong@gmail.com>
 <20220831183224.3754305-2-joannelkoong@gmail.com> <20220901195917.2ho5g5hqsaidzadd@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220901195917.2ho5g5hqsaidzadd@kafai-mbp.dhcp.thefacebook.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 1 Sep 2022 14:58:59 -0700
Message-ID: <CAJnrk1ZiYWu1R+mK5_OCZRBGLPx+_bE-fon30zDwSmrcxAxZQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: Add skb dynptrs
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, memxor@gmail.com, toke@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org
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

On Thu, Sep 1, 2022 at 12:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Aug 31, 2022 at 11:32:22AM -0700, Joanne Koong wrote:
> > +#ifdef CONFIG_NET
> > +int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
> > +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> > +                       u32 len, u64 flags);
> > +#else /* CONFIG_NET */
> > +int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
> static inline
>
> This should address the build issue reported by the test bot.

Awesome, I will add this in for v6. Thanks!
>
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> > +                       u32 len, u64 flags)
> Same here.
>
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +#endif /* CONFIG_NET */
