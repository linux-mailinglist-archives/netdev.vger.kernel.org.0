Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56B15E945B
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 18:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiIYQ3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 12:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiIYQ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 12:29:08 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8859C2CCA8
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 09:29:05 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 126so5604889ybw.3
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 09:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=aBqJlL/02oBSrti+6d3L04f/LaPwYB+ZmoE/wMNY/eU=;
        b=bf6sS35YmcXV5zSC1/hE5asbL/mes1Lxc4P4Mq/uFPvPTk5UYP3XWw6hFQ80W59GO+
         pc/zM9ZxTrLgz3wy63F6fQpXXf+xSHgDI0kLWlZUkPpGXBpIVw8IUySs2qKyA0aAY6cH
         bT2Rzune1FY3tbOUwvKSLTuD8ByxzkOtzImN7TF2vjoF1opSiH99vT5gWGzdVlRSfd5g
         xzcngRqcd2qkAHHg9RTX5B6iWe+c/SDmC6r+0ZpOCA6RK1Vp2TwO7V2wJCazJYtlcrYR
         7XgUo7Zu2s18p5ao3qD2lBUj2AWaepMN8gDnQFYrxeU+dEw5zyDTZmcf0wFnn3S1V92/
         KaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aBqJlL/02oBSrti+6d3L04f/LaPwYB+ZmoE/wMNY/eU=;
        b=QNjFPffO/ocEn0gdyMdx/FTOxVDFH/ntGh+EUHR5R/rQbEOa/uU5F4EXcm2aVj4IJh
         LSLffm3lpOnceu1MP35tpxNPwY5zb/n9BV/n+fKAYt3sVyz/oDQJIzZ6nkxYGj2N+c+o
         qtUyzFYWoG+xvNBKTLbNYf3/JoJfGLLJ+AxajUKUiRXmtofpVuJOIdVZl9kWDIwtPv1b
         Avm9YBaDsKFjDRXZ99m4Dsn0kACmWZEn5crCj/dA3I6qXUwy4r1qql/c0pWCtwEIL1E8
         o6Y55bbxGjRel9gxg1oSKJZQB2P7t8imXULi+uJDZ7n7QMRtZcNjCdmuDLLor8HwfBgD
         jsDA==
X-Gm-Message-State: ACrzQf2+RHSASQjIoigVJf3SbsZO7Z7ePQBKd+aqS9w0H/kwc1aVMGQD
        uHXQmkgkrHetspsfCeS98rdCmJ0Qj8BJkcZG4f4Hqw==
X-Google-Smtp-Source: AMsMyM7LZRKjut7bA4rjDYiurDKc7/Bej35g4U4mOAWNa/UZDWJ2aBjzNFcwCWStg1DrQnvxCJr7CvxoYqU7memIn94=
X-Received: by 2002:a05:6902:10c3:b0:6ae:98b0:b8b1 with SMTP id
 w3-20020a05690210c300b006ae98b0b8b1mr18621750ybu.231.1664123344367; Sun, 25
 Sep 2022 09:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a96c0b05e97f0444@google.com> <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
In-Reply-To: <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 25 Sep 2022 09:28:53 -0700
Message-ID: <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com>
Subject: Re: [syzbot] WARNING in u32_change
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 9:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On Sun, Sep 25, 2022 at 11:38 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > Is there a way to tell the boat "looking into it?"
>
>
> I guess I have to swim across to it to get the message;->
>
> I couldnt see the warning message  but it is obvious by inspection that
> the memcpy is broken. We should add more test coverage.
> This should fix it. Will send a formal patch later:
>
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4d27300c2..591cbbf27 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -1019,7 +1019,7 @@ static int u32_change(struct net *net, struct
> sk_buff *in_skb,
>         }
>
>         s = nla_data(tb[TCA_U32_SEL]);
> -       sel_size = struct_size(s, keys, s->nkeys);
> +       sel_size = struct_size(s, keys, s->nkeys) + sizeof(n->sel);
>         if (nla_len(tb[TCA_U32_SEL]) < sel_size) {
>                 err = -EINVAL;
>                 goto erridr;

This patch is not needed, please look at struct_size() definition.

Here, we might switch to unsafe_memcpy() instead of memcpy()
