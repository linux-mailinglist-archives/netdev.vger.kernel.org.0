Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8B767ED0A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbjA0SHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjA0SHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:07:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD317267F;
        Fri, 27 Jan 2023 10:07:44 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id b1so6935601ybn.11;
        Fri, 27 Jan 2023 10:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sf82n+izpIJKBQxJedZVX24g+s7pQRjuMEenUmEJthA=;
        b=IX5kAK6U9Dl/zlwIewK7wbuw3Ubs4kOd3pbYRQpA63taLnwLgTCvqW2CPc8C5OAC/O
         gPHnOmx/faOKpNriZm9rB70i2HSp71BVvr5n/B4O2tHbbTH0h47F8D8lmkEn2jV+hLT1
         C3Og8XBxRRWlsoy5UXgcmt+xdA0GZiveM5DGYYhSe9gKj23yzAwMbbJ6Ml/ZUlRQej4i
         3B6yxsKaNBIdrK72O+siuE+x9QLK1bTXIXGBOdblsGikjGfnFloaXbxXmCUSRmZ/HGe6
         2Cw7acKXyItujaEo4UcX0DAM89BiL69R8TO0jraJSzBrTndwxf2NnXg7sr+utKnNRMCx
         /2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sf82n+izpIJKBQxJedZVX24g+s7pQRjuMEenUmEJthA=;
        b=U26Z4WTWd84tVxklO1IjkJQjH7VC78NDldQvvjzoAJUMyqqlGkFwLp05PRyOnpuRm0
         L6jq4hsJaqckFiXBwXJ9CbJYQ+Tt3B5ih8SFFrWCFY0D74nv2OuNFRiWxlFtYi8KlFhr
         nChqbGT1hmHaPbRuaY7K+DEcvQereg2BYihk2hKEd3nmyyljNH9I3KVadU6+PgS+cwKc
         CxRhVc9jXi2NC9pJV0+LlUOcCELd04xxBL+9XQlXmy68Lkp0Ak2q9Mey/XOoySc39Qry
         0DgFslRo6MjLfxVkGN0+ywQEL6qmn4a70LGBfD7rODOulJ+PUVAmmFnld8vx1UymJJOB
         EXNQ==
X-Gm-Message-State: AFqh2kpCHvSSNbz6oCvQ0OLA4bPU5WCbGw5hkE0bdZl1bfFDOgYp6zh6
        CqJv9yhH4g7od8dmhrcklnEI5JKCIn35MqbJ/Co=
X-Google-Smtp-Source: AMrXdXvfVsAbExg0+yKavFvLhZVMM5Tfpjn/9Yp4SruH+d4+nnYpQses2jeMyNNh8d9lcYg/wn4Xl5P9xdwo6oLQW8c=
X-Received: by 2002:a25:fe08:0:b0:7c8:6d8c:350a with SMTP id
 k8-20020a25fe08000000b007c86d8c350amr3609126ybe.11.1674842863350; Fri, 27 Jan
 2023 10:07:43 -0800 (PST)
MIME-Version: 1.0
References: <20230126233439.3739120-1-joannelkoong@gmail.com>
 <20230126233439.3739120-4-joannelkoong@gmail.com> <befb819f-abc4-c7a1-1f82-9559542f9138@linux.dev>
In-Reply-To: <befb819f-abc4-c7a1-1f82-9559542f9138@linux.dev>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 27 Jan 2023 10:07:32 -0800
Message-ID: <CAJnrk1bs5y_XDTHYzha_fNVQSbHF6hguewHOd=vm5cnimGTtOw@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 3/5] bpf: Add skb dynptrs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 11:58 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 1/26/23 3:34 PM, Joanne Koong wrote:
> > +static enum bpf_dynptr_type dynptr_get_type(struct bpf_verifier_env *env,
> > +                                         struct bpf_reg_state *reg)
> > +{
> > +     struct bpf_func_state *state = func(env, reg);
> > +     int spi = __get_spi(reg->off);
> > +
> > +     if (spi < 0) {
> > +             verbose(env, "verifier internal error: invalid spi when querying dynptr type\n");
> > +             return BPF_DYNPTR_TYPE_INVALID;
> > +     }
> > +
> > +     return state->stack[spi].spilled_ptr.dynptr.type;
> > +}
>
> CI fails:
> https://github.com/kernel-patches/bpf/actions/runs/4020275998/jobs/6908210555
>
> My local KASAN also reports the error.

Ooh thanks for flagging. user_ringbuf() test was failing because
dynptr_get_type didn't account for CONST_PTR_TO_DYNPTR type. This
fixes it:

@@ -6644,8 +6644,12 @@ static enum bpf_dynptr_type
dynptr_get_type(struct bpf_verifier_env *env,
                                            struct bpf_reg_state *reg)
 {
        struct bpf_func_state *state = func(env, reg);
-       int spi = __get_spi(reg->off);
+       int spi;
+
+       if (reg->type == CONST_PTR_TO_DYNPTR)
+               return reg->dynptr.type;

+       spi = __get_spi(reg->off);
        if (spi < 0) {
                verbose(env, "verifier internal error: invalid spi
when querying dynptr type\n");

I will add this and respin v9.
