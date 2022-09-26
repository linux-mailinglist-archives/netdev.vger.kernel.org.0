Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F735E97F9
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 04:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiIZCja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 22:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiIZCj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 22:39:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A73338
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 19:39:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fv3so5041787pjb.0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 19:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rNfKV091B020Efc+YRWSdOa5mhQUV0Kl4OyiKcHkZ9Q=;
        b=kh1BUFDjkrLOhsENJ07K39+e7g1gEH4tc3sMPWx+sF3myjmnrJjs/Tx3sY8M4PaCUo
         oIJmzH7gjKTkasxkN/feO5ML/XlyTNFcju7NaZmfuNzK0D6eW02grt1GrxXFVe5OEnGE
         mm0bEdnQTbysRH54a1XnMMvqrTSmMCwvKJuao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rNfKV091B020Efc+YRWSdOa5mhQUV0Kl4OyiKcHkZ9Q=;
        b=graSu/Uvxbh2u9uqRT0SvUFQ9xz9p/dZwgkbFfM2ius5+MjbvFT2AsTzhQw/2L7OhX
         itU0Xo/7d8cwreS/uVCCqA7KyvOA0ErgD7J26IFcX5jnJFK6/KYKY44skcpK9K4A8DyC
         dGiGKdpv71h/5pqzVT4PVbPCzGCwWS6gEB98hjdzY8JT28i9h0uuTITPMZfgioRMhuDV
         hh7bW59FCY7WTTJkgvM432HKToyVFJQoKBNTbKEbEpM/bKXTjsi3ufzRwL6xVzML3EyY
         QK+N5JiKhVK6lXGq3TgrhtoZwI/aaSf2fFykzx4CajOKW9JjX4f8t1RL3ZqLbj274MrD
         xzEA==
X-Gm-Message-State: ACrzQf1JRAw/Viy3HdwvQCncUps/C64lTFROyEW90Io1sDX8xIyQDqGh
        da0amhLJxj/GlQS3Ml42LJG9hw==
X-Google-Smtp-Source: AMsMyM6BbKHm0noocBjB++zZR9GVYSdMb3IIGaKOhSxMq5KaQdZv9li5+4eICtAO3wxttWksScUPuw==
X-Received: by 2002:a17:902:f389:b0:178:9bd4:b72e with SMTP id f9-20020a170902f38900b001789bd4b72emr19464384ple.140.1664159965206;
        Sun, 25 Sep 2022 19:39:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p4-20020a622904000000b0054d1a2ee8cfsm10666756pfp.103.2022.09.25.19.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 19:39:24 -0700 (PDT)
Date:   Sun, 25 Sep 2022 19:39:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [syzbot] WARNING in u32_change
Message-ID: <202209251935.0469930C@keescook>
References: <000000000000a96c0b05e97f0444@google.com>
 <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
 <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com>
 <CAM0EoMkLdOUQ3yrBuYsLdZvqniZ_r0VoACzOzKCo1VVzYeyPbw@mail.gmail.com>
 <CAM0EoMmr8trH0EOtOfvTpYiTq1tt7RUamf1u_R0+USOU_gYUVg@mail.gmail.com>
 <CANn89i+6NpmCyGdicmv+BiQqhUZ71TfN+P4=9NGpV4GxOba1Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+6NpmCyGdicmv+BiQqhUZ71TfN+P4=9NGpV4GxOba1Cw@mail.gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 10:34:37AM -0700, Eric Dumazet wrote:
> Sure, please look at:
> 
> commit 54d9469bc515dc5fcbc20eecbe19cea868b70d68
> Author: Kees Cook <keescook@chromium.org>
> Date:   Thu Jun 24 15:39:26 2021 -0700
> 
>     fortify: Add run-time WARN for cross-field memcpy()
> [...]
> Here, we might switch to unsafe_memcpy() instead of memcpy()

I would tend to agree. Something like:

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4d27300c287c..21e0e6206ecc 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1040,7 +1040,9 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	memcpy(&n->sel, s, sel_size);
+	unsafe_memcpy(&n->sel, s, sel_size,
+		      /* A composite flex-array structure destination,
+		       * which was correctly sized and allocated above. */);
 	RCU_INIT_POINTER(n->ht_up, ht);
 	n->handle = handle;
 	n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;

This alloc/partial-copy pattern is relatively common in the kernel, so
I've been considering adding a helper for it. It'd be like kmemdup(),
but more like kmemdup_offset(), which only the object from a certainly
point is copied.

-- 
Kees Cook
