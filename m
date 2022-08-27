Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9D25A397D
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiH0SdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiH0SdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:33:01 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA555B797;
        Sat, 27 Aug 2022 11:33:00 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y187so3633566iof.0;
        Sat, 27 Aug 2022 11:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/N/ezHxVsgAfcCGDG1F+RCyeREMqFYLP8sDRw+OOlHc=;
        b=c+/M4a3l2qPAtYKWa+kRSLpp7qucNcXwq4w0i1NFWQ1EGqv2fvmIX9ekmKEDzep4as
         68ZDV0vWLemZj7I4wy7Q+X7+fzKS/jJQUISza2UZXq15h412qypxKCHeA5FGBH0gjyUF
         QUrkS2oJTthgv7R91BToE7/OLfNw/BiQ2DGrP1sp5zUWagpDaSMejpvtttbHghCwvCy7
         kEfMe8hR3BXi18XH7QF+nYMfe8FIM8KK3fr0VDerLOxkyCYcULuzC6Mf6w4FuHzllFYj
         MlJH7eFzdylilRfa88YlnVYSBGTCi1MVem/TJ5uQI38Lad5mwSGHwGcdYuzqIWKsR+JX
         lGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/N/ezHxVsgAfcCGDG1F+RCyeREMqFYLP8sDRw+OOlHc=;
        b=LatVRKbkHSzsP8kqIfofcsXYJQPMDk74CyFPqJFUuKl1OrE4BsvnrFfX8TjEe3e9FC
         fIQ0tlwn5sEK4vkrfCm6SMp8wSPjXEKta/CTbSAJRZVGg0nufpnf3HsCGtD/xglTAR9S
         C+mL94ssp0Lx9n93UtxbM0BgYy0RV8DQDxg8dzp8U0FbTYGdTq3L+/zGphH7NnjHz+ut
         /4CTQpjA1JaZqE+yeIT9dS5TmhTekTJTMDDHN/tWWdAkEX9yg9Hw4++Lr+bkqgzQy0Im
         ValHjA/MSNG2ZSaMmrRVsahtU6kENHcCiW226PGTBa8r30QPx+Qsn6cKsd6qjGmOk4QK
         dTNw==
X-Gm-Message-State: ACgBeo0TC8lqkEdIPRYLCto96bYebe9OJZOkgh//MUWrncMnzPrxJiO7
        YkznDo2Cad2QwvidDGmJiygnr87ep0OqLg3faMY=
X-Google-Smtp-Source: AA6agR4kUp8prdndg4QMweWeWgAgVLQpL77+1q1gn7CI+ksKj0ebVI32qiq/owr45wPiV5maep8CIHyRMaM9u++KQ0Y=
X-Received: by 2002:a05:6638:3828:b0:349:e863:f16c with SMTP id
 i40-20020a056638382800b00349e863f16cmr6763738jav.206.1661625179745; Sat, 27
 Aug 2022 11:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
 <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
 <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
 <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com>
 <CAJnrk1Zmne1uDn8EKdNKJe6O-k_moU9Sryfws_J-TF2BvX2QMg@mail.gmail.com>
 <CAP01T746gvoOM7DuWY-3N2xJbEainTinTPhyqHki2Ms6E0Dk_A@mail.gmail.com>
 <CAEf4BzZYTN=gGsc88jetv-SSMBy78P7w7Y08zfwGR7cCenJPiQ@mail.gmail.com>
 <CAP01T74mbnYJkq0CfknZBqYg4T5B-OenB+SB6=gc24GvpVxA8g@mail.gmail.com> <CAEf4BzYpV-RJ456n0UQFPXSG6SvUPK5=jM4nS+x25z7pTkfMGQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYpV-RJ456n0UQFPXSG6SvUPK5=jM4nS+x25z7pTkfMGQ@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sat, 27 Aug 2022 20:32:23 +0200
Message-ID: <CAP01T74UojWGWk=1nbE8N=fM9-vzyJJv=qNMM5dJO7A5qO7S6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org
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

On Sat, 27 Aug 2022 at 19:22, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Aug 27, 2022 at 12:12 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> > [...]
> > >
> > > I think the right answer here is to not make bpf_dynptr_data() return
> > > direct pointer of changing read-only-ness. Maybe the right answer here
> > > is another helper, bpf_dynptr_data_rdonly(), that will return NULL for
> > > non-read-only dynptr and PTR_TO_MEM | MEM_RDONLY if dynptr is indeed
> > > read-only?
> >
> > Shouldn't it be the other way around? bpf_dynptr_data_rdonly() should
> > work for both ro and rw dynptrs, and bpf_dynptr_data() only for rw
> > dynptr?
>
> Right, that's what I proposed:
>
>   "bpf_dynptr_data_rdonly(), that will return NULL for non-read-only dynptr"
>
> so if you pass read-write dynptr, it will return NULL (because it's
> unsafe to take writable direct pointer).
>
> bpf_dynptr_data_rdonly() should still work fine with both rdonly and
> read-write dynptr.
> bpf_dynptr_data() only works (in the sense returns non-NULL) for
> read-write dynptr only.
>
>
> >
> > And yes, you're kind of painting yourself in a corner if you allow
> > dynptr_data to work with statically ro dynptrs now, ascertaining the
> > ro bit for the returned slice, and then later you plan to add dynptrs
> > whose ro vs rw is not known to the verifier statically. Then it works
> > well for statically known ones (returning both ro and rw slices), but
> > has to return NULL at runtime for statically unknown read only ones,
> > and always rw slice in verifier state for them.
>
> Right, will be both inconsistent and puzzling.
>
> >
> > >
> > > By saying that read-only-ness of dynptr should be statically known and
> > > rejecting some dynptr functions at load time places us at the mercy of
> > > verifier's complete knowledge of application logic, which is exactly
> > > against the spirit of dynptr.
> > >
> >
> > Right, that might be too restrictive if we require them to be
> > statically read only.
> >
> > But it's not about forcing it to be statically ro, it is more about
> > rejecting load when we know the program is incorrect (e.g. the types
> > are incorrect when passed to helpers), otherwise we throw the error at
> > runtime anyway, which seems to be the convention afaicu. But maybe I
> > missed the memo and we gradually want to move away from such strict
> > static checks.
> >
> > I view the situation here similar to if we were rejecting direct
> > writes to PTR_TO_MEM | MEM_RDONLY at load time, but offloading as
> > runtime check in the helper writing to it as rw memory arg. It's as if
> > we pretend it's part of the 'type' of the register when doing direct
> > writes, but then ignore it while matching it against the said helper's
> > argument type.
>
> I disagree, it's not the same. bpf_dynptr_data/bpf_dynptr_data_rdonly
> turns completely dynamic dynptr into static slice of memory. Only
> after that point it makes sense for BPF verifier to reject something.
> Until then it's not incorrect. BPF program will always have to deal
> with some dynptr operations potentially failing. dynptr can always be
> NULL internally, you can still call bpf_dynptr_xxx() operations on it,
> they will just do nothing and return error. That doesn't make BPF
> program incorrect.

Let me just explain one last time why I'm unable to swallow this
'completely dynamic dynptr' explanation, because it is not treated as
completely dynamic by all dynptr helpers.

No pushback, but it would be great if you could further help me wrap
my head around this, so that we're in sync for future discussions.

So you say you may not know the type of dynptr (read-only, rw, local,
ringbuf, etc.). Hence you want to treat every dynptr as 'dynamic
dynptr' you know nothing about even when you do know some information
about it statically (e.g. if it's on stack). You don't want to reject
things early at load even if you have all the info to do so. You want
operations on it to fail at runtime instead.

If you cannot track ro vs rw in the future statically, you won't be be
able to track local or ringbuf or skb either (since both are part of
the type of the dynptr). If you can, you can just as well encode
const-ness as part of the type where you declare it (e.g. in a map
field where the value is assigned dynamically, where you say
dynptr_ringbuf etc.). Type comprises local vs skb vs ringbuf | ro vs
rw for me. But maybe I could be wrong.

So following this line of reasoning, will you be relaxing the argument
type of helpers like bpf_ringbuf_submit_dynptr? Right now they take
'dynamic dynptr' as arg, but also expect DYNPTR_TYPE_RINGBUF, so you
reject load when it's not a ringbuf dynptr. Will it then fallback to
checking the type at runtime when the type will not be known? But then
it will also permit passing local or skb dynptr in the future which it
rejects right now.

I'm just hoping you are able to see why it's looking a bit
inconsistent to me. If DYNPTR_TYPE_RINGBUF has to be checked, it felt
to me like DYNPTR_RDONLY is as much part of that kind of type safety
wrt helpers. It would be set on the dynptr when skb passed to
dynptr_from_skb is rdonly in some program types, along with
DYNPTR_TYPE_SKB, and expect to be matched when invoking helpers on
such dynptrs.

It is fine to push checks to runtime, especially when you won't know
the type, because verifier cannot reasonably track the dynptr type
then.

But right now there's still some level of state you maintain in the
verifier about dynptrs (like it's type), and it seems to me like some
helpers are using that state to reject things at load time, while some
other helper will ignore it and fallback to runtime checks.

I hope this is a clear enough description to atleast justify why I'm
(still) a bit confused.
