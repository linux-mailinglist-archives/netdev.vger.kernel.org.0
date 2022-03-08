Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462EC4D0D7A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344247AbiCHBYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244440AbiCHBYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:24:42 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECBD36B74;
        Mon,  7 Mar 2022 17:23:46 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 195so19366684iou.0;
        Mon, 07 Mar 2022 17:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T43xTctFC06+IvvNRgWW3jUe2sO2yp0ufRBV/py3MXw=;
        b=kiKcK2YpfvFn3oO0o40P1uMFgki9KGMM3dZiID8QamCI3VezliGDzOMmQhEQO1XlL7
         5BJqXmiRlReKajJFgTGSK87t5cNHpglDfxbaLJlcs2hehRRsAwNT0G19e7vKwKVaEkYS
         JilFIW1znWBXPk7U7XLiEr4bVrPxxXu6x+cJs5r4VAv1EFdN0T5i5oWkhFpFcdz0M952
         oprbIM+s/sBmFEDGeP+T75nJDh06sYPi3So70LizG9nwphtqGOeE8QNBmWmm0zOE5lGB
         /5U4YP89Hc/12yFKO0EyoCqyfP2kDq0w1/M5MHECoaAmdcfkM/zd/8RvYYZZ0RufeWsd
         Doqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T43xTctFC06+IvvNRgWW3jUe2sO2yp0ufRBV/py3MXw=;
        b=6EnTCDcdHGCbt2ESRc6yfCFINWvTJipV9H/Z1ueYqanE7cN2SzBJhsoNQsXRHfQ/0x
         OWtMgUUW/6oQV90gC/XLCQiDTMbiX14lT4lojeZ10cS7YQBZmninI8Tq+9edTAi82j9b
         zSeDN+pDvnjdGwU5cgatnKPRR+KKthP8Fdxueb2PaWXclW7OINvIrHMkvW/goVHJNGOf
         auCylJc6E4osVsu78h6Gd8EC3BP22XkDWtCo12KaarsXr6NIJZO1bGRBjCvOqJBHrr3B
         8PyxxicWOec3SkP5WLcF7By/g9JMYzeSAEKrBgs7WxWMh94uhH607G+fKFUufx+0XqcP
         5QBg==
X-Gm-Message-State: AOAM530prUSf1iYxrK2OjOoq/0bHHGV0aOJfFUCC9QZX/cHGIGGFIPUE
        ZEgKOxVMuOrhJrs6bsti6mG97de0hw+mGikOvUobAkCg3Uw=
X-Google-Smtp-Source: ABdhPJwhIcqMKpNylL3zv3XM9W73cQYDRf3dSJNxea+E5pT7H54YUued6xDDoel51h0vn23YJKQnUEJfU91gaqYVc+w=
X-Received: by 2002:a02:aa85:0:b0:314:c152:4c89 with SMTP id
 u5-20020a02aa85000000b00314c1524c89mr13094712jai.93.1646702626158; Mon, 07
 Mar 2022 17:23:46 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-3-jolsa@kernel.org>
 <CAEf4BzadsmOTas7BdF-J+de7AqsoccY1o6e0pUBkRuWH+53DiQ@mail.gmail.com> <YiTvT0nyWLDvFya+@krava>
In-Reply-To: <YiTvT0nyWLDvFya+@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 17:23:34 -0800
Message-ID: <CAEf4BzaJoa=N4LgT55oraJkJtBds4BmKBCpJ1wmyqZCfjdo3Pw@mail.gmail.com>
Subject: Re: [PATCH 02/10] bpf: Add multi kprobe link
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Sun, Mar 6, 2022 at 9:28 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Mar 04, 2022 at 03:11:01PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > > +static int
> > > +kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
> > > +                         unsigned long *addrs)
> > > +{
> > > +       unsigned long addr, size;
> > > +       const char **syms;
> > > +       int err = -ENOMEM;
> > > +       unsigned int i;
> > > +       char *func;
> > > +
> > > +       size = cnt * sizeof(*syms);
> > > +       syms = kvzalloc(size, GFP_KERNEL);
> > > +       if (!syms)
> > > +               return -ENOMEM;
> > > +
> > > +       func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
> > > +       if (!func)
> > > +               goto error;
> > > +
> > > +       if (copy_from_user(syms, usyms, size)) {
> > > +               err = -EFAULT;
> > > +               goto error;
> > > +       }
> > > +
> > > +       for (i = 0; i < cnt; i++) {
> > > +               err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
> > > +               if (err == KSYM_NAME_LEN)
> > > +                       err = -E2BIG;
> > > +               if (err < 0)
> > > +                       goto error;
> > > +
> > > +               err = -EINVAL;
> > > +               if (func[0] == '\0')
> > > +                       goto error;
> >
> > wouldn't empty string be handled by kallsyms_lookup_name?
>
> it would scan and compare all symbols with empty string,
> so it's better to test for it

I don't mind, but it seems like kallsyms_lookup_name() should be made
smarter than that instead, no?


>
> jirka
>
> >
> > > +               addr = kallsyms_lookup_name(func);
> > > +               if (!addr)
> > > +                       goto error;
> > > +               if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> > > +                       size = MCOUNT_INSN_SIZE;
> > > +               addr = ftrace_location_range(addr, addr + size - 1);
> > > +               if (!addr)
> > > +                       goto error;
> > > +               addrs[i] = addr;
> > > +       }
> > > +
> > > +       err = 0;
> > > +error:
> > > +       kvfree(syms);
> > > +       kfree(func);
> > > +       return err;
> > > +}
> > > +
> >
> > [...]
