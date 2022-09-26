Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06085E9815
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 04:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiIZCw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 22:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiIZCwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 22:52:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE35F27FEE
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 19:52:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w10so4970303pll.11
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 19:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ymDx1RK1IZPwG4FtzrCjNQCVValjUzUP4YDsHPOQBNw=;
        b=NqQCR177uun7WuAmSlElKYS/S2MAwbvxqlraXbT3atsMNak+h1X5jIvRn9RvyWsTtI
         /JsQCsZjLjbGNWflkWIX/2v/cqo0B0dvAoJxFI0rl8hjUPJ5tzO3rmdvCGVz6qBdjdUr
         TMupY6qwk6T3DBFDCn7qzHXBAqywOTzpEioLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ymDx1RK1IZPwG4FtzrCjNQCVValjUzUP4YDsHPOQBNw=;
        b=oKBeVxZTx1ZiCECH/9u31gB84B3oFfv61AfXZjLneOSUxQRM4gRpCw1TydEOx5MoXY
         azPNb/0Y6eSabNIGde5VtjmOYxoKHgLDTdGu/Ds+jy0Mp0EjC0+9rnTp9/Ol9G9tmpth
         ybBVU5MaPjvUdMCmn813riAPQTdk7G670+0PgfSvnWlGB2O/1wmXhrToLeEQdgkhWpq/
         OvNgJ9KPDlX+nmKCdUb8a+e3l9vZAnp98zkIx4Tjfmn5NiuhfBd2NW4TuQ67fb8v5Vsg
         PbF2/+emt0QZ3CZpX6+cR18hmCWlCqnm4MLDA7gbyTPiXEgnQ9fYCrZo8MfrJNSUZ9Jh
         hM4g==
X-Gm-Message-State: ACrzQf1UBvFMj8nFfPVLENgDm2K+w5bHwxeUyOD1f5EXnP2dLUjwrLbq
        6O7dp2G/63uD+3YzGNCJ4L+plA==
X-Google-Smtp-Source: AMsMyM6me/0F0RPlksRz0s+JiR5OlMjXJ9ZiEetQNHnEHPZVgEKzVbCOzJspeqfbuLPUExLHsaNZfw==
X-Received: by 2002:a17:903:4ca:b0:179:d21f:f04b with SMTP id jm10-20020a17090304ca00b00179d21ff04bmr7520625plb.7.1664160744246;
        Sun, 25 Sep 2022 19:52:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902da8600b00176acc23a73sm9984869plx.281.2022.09.25.19.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 19:52:23 -0700 (PDT)
Date:   Sun, 25 Sep 2022 19:52:22 -0700
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
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [syzbot] WARNING in u32_change
Message-ID: <202209251949.D718072@keescook>
References: <000000000000a96c0b05e97f0444@google.com>
 <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
 <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com>
 <CAM0EoMkLdOUQ3yrBuYsLdZvqniZ_r0VoACzOzKCo1VVzYeyPbw@mail.gmail.com>
 <CAM0EoMmr8trH0EOtOfvTpYiTq1tt7RUamf1u_R0+USOU_gYUVg@mail.gmail.com>
 <CANn89i+6NpmCyGdicmv+BiQqhUZ71TfN+P4=9NGpV4GxOba1Cw@mail.gmail.com>
 <202209251935.0469930C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202209251935.0469930C@keescook>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 07:39:23PM -0700, Kees Cook wrote:
> On Sun, Sep 25, 2022 at 10:34:37AM -0700, Eric Dumazet wrote:
> > Sure, please look at:
> > 
> > commit 54d9469bc515dc5fcbc20eecbe19cea868b70d68
> > Author: Kees Cook <keescook@chromium.org>
> > Date:   Thu Jun 24 15:39:26 2021 -0700
> > 
> >     fortify: Add run-time WARN for cross-field memcpy()
> > [...]
> > Here, we might switch to unsafe_memcpy() instead of memcpy()
> 
> I would tend to agree. Something like:
> 
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4d27300c287c..21e0e6206ecc 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -1040,7 +1040,9 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>  	}
>  #endif
>  
> -	memcpy(&n->sel, s, sel_size);
> +	unsafe_memcpy(&n->sel, s, sel_size,
> +		      /* A composite flex-array structure destination,
> +		       * which was correctly sized and allocated above. */);
>  	RCU_INIT_POINTER(n->ht_up, ht);
>  	n->handle = handle;
>  	n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;

Ah, there is another in the same source file, in u32_init_knode():

        memcpy(&new->sel, s, struct_size(s, keys, s->nkeys));

(I've been trying to convince Coccinelle to produce a list of all the
composite structure targets, but I keep running into weird glitches.
That it hadn't found this one let me track down the latest issue, so now
I should be able to find more! Whew.)

-- 
Kees Cook
