Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62416EE7A2
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 20:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjDYSnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 14:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjDYSnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 14:43:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA51161A1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 11:43:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-247122e9845so4287082a91.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 11:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682448190; x=1685040190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9r/LuIGjx8rrrWo+CZqGbK9n/EXyber61jogDduPh4o=;
        b=vtV3wBJHtnKPGsYJrJ8ojlk7oCjHxAwyeJoQso+XJ1HTkxl9SS8nngqu1iHr1vfdP2
         R3hRjAdY2OQfQiKy374/JzF7Y0XSJ37LKrieQ9Y6Q7SBCTdIakL2XCmgkZm7qmx1OcGG
         fY4LGcT/oF+mD8dF+Hi1CLdE5RunYO4WaESN791EbrObQovyaFkdTFYCQ5rDJLX3Vpxb
         3Xmlhbc+hAyhEkRu9tTUv+tvqMQjYUJQRqVMTCvJ6qcSzozx46V5+mTJpG3EeNgGp74x
         mj6FjWzyDNfbb+39wnYn/4Tj+FQIwqm8cPDSqVGWDqkmnfJU6mxjZn4aBhOity0+Y0BE
         CZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682448190; x=1685040190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9r/LuIGjx8rrrWo+CZqGbK9n/EXyber61jogDduPh4o=;
        b=Dot7mL1708zIZdu9tCp5sqj1hdfTLHKNxslAnaqOkE6PGprv7FqMPufkLNUOSqxsJQ
         Zo0S+aJi0O4fCJGZU2ASxaD1PN3pJ72Uffm5wkDtCWznwZInHpn7P6TlIMaTYXjYBPvg
         O4KVROqsNaVJYQjLHZxGUZM88Zd3KAoCb079BN6es0JSZ3m/g7K35nZK6jbT7QTgLUyO
         K3QeWBQ95jhaY8P8gKcQRhyNm0dzy90cJA3PU/kFy+MPFZYKvaVy9DClFf2iNFL56HV7
         a5r3CeMp9p23JFNUk0GujohiqCiDdUP+spPrSVgzi5Ob2/4OA7nWpPD9WFNp1K82gGub
         tbKw==
X-Gm-Message-State: AAQBX9eZWivaPGRcNCzwG6vGGn7j6f6KzYofvYOlq0D3yoBe6Je2vv+X
        20j8HVg0fyTxEoPNhq+j3iwJR6q7trpTWIdY0lhTGQ==
X-Google-Smtp-Source: AKy350ZZPv49tW4jIrpNQbuGE03auCjlVZ5DpZtvMTqVnf3KdZs/jN0kTN73n6FbKawjFqKNlE6RRmAV2mthsoE4Jcs=
X-Received: by 2002:a17:90b:1642:b0:247:6c78:6c3f with SMTP id
 il2-20020a17090b164200b002476c786c3fmr19434427pjb.29.1682448189925; Tue, 25
 Apr 2023 11:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com> <a4591e85-d58b-0efd-c8a4-2652dc69ff68@linux.dev>
 <ZD7Js4fj5YyI2oLd@google.com> <b453462a-3d98-8d0f-9cc0-543032de5a5f@gmail.com>
In-Reply-To: <b453462a-3d98-8d0f-9cc0-543032de5a5f@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 25 Apr 2023 11:42:58 -0700
Message-ID: <CAKH8qBusi0AWpo_iDaFkLFPUhgZy7-p6JwhimCkpYMhWnToE7g@mail.gmail.com>
Subject: Re: handling unsupported optlen in cgroup bpf getsockopt: (was [PATCH
 net-next v4 2/4] net: socket: add sockopts blacklist for BPF cgroup hook)
To:     Kui-Feng Lee <sinquersw@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:59=E2=80=AFAM Kui-Feng Lee <sinquersw@gmail.com>=
 wrote:
>
>
>
> On 4/18/23 09:47, Stanislav Fomichev wrote:
> > On 04/17, Martin KaFai Lau wrote:
> >> On 4/14/23 6:55 PM, Stanislav Fomichev wrote:
> >>> On 04/13, Stanislav Fomichev wrote:
> >>>> On Thu, Apr 13, 2023 at 7:38=E2=80=AFAM Aleksandr Mikhalitsyn
> >>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >>>>>
> >>>>> On Thu, Apr 13, 2023 at 4:22=E2=80=AFPM Eric Dumazet <edumazet@goog=
le.com> wrote:
> >>>>>>
> >>>>>> On Thu, Apr 13, 2023 at 3:35=E2=80=AFPM Alexander Mikhalitsyn
> >>>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >>>>>>>
> >>>>>>> During work on SO_PEERPIDFD, it was discovered (thanks to Christi=
an),
> >>>>>>> that bpf cgroup hook can cause FD leaks when used with sockopts w=
hich
> >>>>>>> install FDs into the process fdtable.
> >>>>>>>
> >>>>>>> After some offlist discussion it was proposed to add a blacklist =
of
> >>>>>>
> >>>>>> We try to replace this word by either denylist or blocklist, even =
in changelogs.
> >>>>>
> >>>>> Hi Eric,
> >>>>>
> >>>>> Oh, I'm sorry about that. :( Sure.
> >>>>>
> >>>>>>
> >>>>>>> socket options those can cause troubles when BPF cgroup hook is e=
nabled.
> >>>>>>>
> >>>>>>
> >>>>>> Can we find the appropriate Fixes: tag to help stable teams ?
> >>>>>
> >>>>> Sure, I will add next time.
> >>>>>
> >>>>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hook=
s")
> >>>>>
> >>>>> I think it's better to add Stanislav Fomichev to CC.
> >>>>
> >>>> Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
> >>>> use it for tcp zerocopy, I'm assuming it should work in this case as
> >>>> well?
> >>>
> >>> Jakub reminded me of the other things I wanted to ask here bug forgot=
:
> >>>
> >>> - setsockopt is probably not needed, right? setsockopt hook triggers
> >>>     before the kernel and shouldn't leak anything
> >>> - for getsockopt, instead of bypassing bpf completely, should we inst=
ead
> >>>     ignore the error from the bpf program? that would still preserve
> >>>     the observability aspect
> >>
> >> stealing this thread to discuss the optlen issue which may make sense =
to
> >> bypass also.
> >>
> >> There has been issue with optlen. Other than this older post related t=
o
> >> optlen > PAGE_SIZE:
> >> https://lore.kernel.org/bpf/5c8b7d59-1f28-2284-f7b9-49d946f2e982@linux=
.dev/,
> >> the recent one related to optlen that we have seen is
> >> NETLINK_LIST_MEMBERSHIPS. The userspace passed in optlen =3D=3D 0 and =
the kernel
> >> put the expected optlen (> 0) and 'return 0;' to userspace. The usersp=
ace
> >> intention is to learn the expected optlen. This makes 'ctx.optlen >
> >> max_optlen' and __cgroup_bpf_run_filter_getsockopt() ends up returning
> >> -EFAULT to the userspace even the bpf prog has not changed anything.
> >
> > (ignoring -EFAULT issue) this seems like it needs to be
> >
> >       if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
> >               /* error */
> >       }
> >
> > ?
> >
> >> Does it make sense to also bypass the bpf prog when 'ctx.optlen >
> >> max_optlen' for now (and this can use a separate patch which as usual
> >> requires a bpf selftests)?
> >
> > Yeah, makes sense. Replacing this -EFAULT with WARN_ON_ONCE or somethin=
g
> > seems like the way to go. It caused too much trouble already :-(
> >
> > Should I prepare a patch or do you want to take a stab at it?
> >
> >> In the future, does it make sense to have a specific cgroup-bpf-prog (=
a
> >> specific attach type?) that only uses bpf_dynptr kfunc to access the o=
ptval
> >> such that it can enforce read-only for some optname and potentially al=
so
> >> track if bpf-prog has written a new optval? The bpf-prog can only retu=
rn 1
> >> (OK) and only allows using bpf_set_retval() instead. Likely there is s=
till
> >> holes but could be a seed of thought to continue polishing the idea.
> >
> > Ack, let's think about it.
> >
> > Maybe we should re-evaluate 'getsockopt-happens-after-the-kernel' idea
> > as well? If we can have a sleepable hook that can copy_from_user/copy_t=
o_user,
> > and we have a mostly working bpf_getsockopt (after your refactoring),
> > I don't see why we need to continue the current scheme of triggering
> > after the kernel?
>
> Since a sleepable hook would cause some restrictions, perhaps, we could
> introduce something like the promise pattern.  In our case here, BPF
> program call an async version of copy_from_user()/copy_to_user() to
> return a promise.

Having a promise might work. This is essentially what we already do
with sockets/etc with acquire/release pattern.

What are the sleepable restrictions you're hinting about? I feel like
with the sleepable bpf, we can also remove all the temporary buffer
management / extra copies which sounds like a win to me. (we have this
ugly heuristics with BPF_SOCKOPT_KERN_BUF_SIZE) The program can
allocate temporary buffers if needed..

> >>> - or maybe we can even have a per-proto bpf_getsockopt_cleanup call t=
hat
> >>>     gets called whenever bpf returns an error to make sure protocols =
have
> >>>     a chance to handle that condition (and free the fd)
> >>>
> >>
> >>
