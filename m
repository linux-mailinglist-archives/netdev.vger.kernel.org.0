Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D76EF7F6
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241399AbjDZPv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241244AbjDZPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:51:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF435FDB
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:51:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a6bc48aec8so55719695ad.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682524269; x=1685116269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAZt4SwBq0kzUhXCO374DApwwiCqj65AMLJ7jYfFhVY=;
        b=wONEkvpfq/eASdg9qtRBkCqKPWIGN7jF9+5WyNuWNLb/Jtu4Y/jEn/IxoxPGIXv9Q5
         Ev3gX0JaGekf02cXAI9Sibu8PvQhanwkfz/r4trzy0QIwtNaVcyGLkEu5mKrgf7rHtfk
         ca3DM0w8EIe0xAXzP4z7TNHaDXKrQCBk4fkg6CHLtiNb3pA7w+Bt6m4X6/hK+WyatIgR
         LFv463ZxN9D6wwr9/ammqIwg/pkcWmkuEHiOKhI7km6/JPefaTB/eiw/Foiq3GOdVAcV
         R2nCBd4tyihhOPhTwbaeyKwuwaVEZ3Cxw3xx9qpE9jrlV5kvsg4rRVqSlrR6dPF9+/zX
         kSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682524269; x=1685116269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAZt4SwBq0kzUhXCO374DApwwiCqj65AMLJ7jYfFhVY=;
        b=lOm7u+KeOFzBm1cQCeG3lha/jSLQe6GOidSxilp5Ewo0VG/9DZa8ZuMpPACHhYyruD
         rjEn4pEmS4O2HMBzC6O4RdJ5v5OJIZ1lbUgJxq4QWP36asQmFlWyMBcTZD1hqjMyEtX0
         lbxyt9xcPxTJEPP+PwH0uzPOl03/bHaLr8yNPtE47AYK+G27THJ3FrRN43RU0l/MPjq6
         MvIJJmuDcfnoz9WDz0l4H5hkS2h6/fjwvzrepyhL1exnEJ1kwlij7Nk39GVNV0iKGKu+
         1i4XIgWkSTeW0WGkNRHKxsZJKp/D9w2Y/gWLVPZm3NQtLJ49TD86REH62mU5+uRseB1k
         sNqw==
X-Gm-Message-State: AAQBX9dMGs0ZcAqHOJtO8fxzJj9i20N3IcPh9xBI50L1YXZRDq3ZyccH
        WLQA5+NjR/V23y7z/+/Xzpjg6Af02aQ013MVXuMCHA==
X-Google-Smtp-Source: AKy350ZHHrz8NBOxCi4LboZHUxE7CP1TxQqDc8DjZYCaDw4hQPwaGjWQZ+1aaUgkQ7SKzFENBcL2UkIDr/m4KoG2S0A=
X-Received: by 2002:a17:902:d582:b0:1a9:20ea:f49b with SMTP id
 k2-20020a170902d58200b001a920eaf49bmr22387086plh.24.1682524269347; Wed, 26
 Apr 2023 08:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com> <a4591e85-d58b-0efd-c8a4-2652dc69ff68@linux.dev>
 <ZD7Js4fj5YyI2oLd@google.com> <b453462a-3d98-8d0f-9cc0-543032de5a5f@gmail.com>
 <CAKH8qBusi0AWpo_iDaFkLFPUhgZy7-p6JwhimCkpYMhWnToE7g@mail.gmail.com> <4e177291-0f94-ab71-a982-f3e9f1f64280@gmail.com>
In-Reply-To: <4e177291-0f94-ab71-a982-f3e9f1f64280@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 26 Apr 2023 08:50:58 -0700
Message-ID: <CAKH8qBs=JeNRGkGi6hCEoc+50bKS1h1LMsex_T+dDk0c7s1OQg@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 2:11=E2=80=AFPM Kui-Feng Lee <sinquersw@gmail.com> =
wrote:
>
>
>
> On 4/25/23 11:42, Stanislav Fomichev wrote:
> > On Tue, Apr 25, 2023 at 10:59=E2=80=AFAM Kui-Feng Lee <sinquersw@gmail.=
com> wrote:
> >>
> >>
> >>
> >> On 4/18/23 09:47, Stanislav Fomichev wrote:
> >>> On 04/17, Martin KaFai Lau wrote:
> >>>> On 4/14/23 6:55 PM, Stanislav Fomichev wrote:
> >>>>> On 04/13, Stanislav Fomichev wrote:
> >>>>>> On Thu, Apr 13, 2023 at 7:38=E2=80=AFAM Aleksandr Mikhalitsyn
> >>>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >>>>>>>
> >>>>>>> On Thu, Apr 13, 2023 at 4:22=E2=80=AFPM Eric Dumazet <edumazet@go=
ogle.com> wrote:
> >>>>>>>>
> >>>>>>>> On Thu, Apr 13, 2023 at 3:35=E2=80=AFPM Alexander Mikhalitsyn
> >>>>>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >>>>>>>>>
> >>>>>>>>> During work on SO_PEERPIDFD, it was discovered (thanks to Chris=
tian),
> >>>>>>>>> that bpf cgroup hook can cause FD leaks when used with sockopts=
 which
> >>>>>>>>> install FDs into the process fdtable.
> >>>>>>>>>
> >>>>>>>>> After some offlist discussion it was proposed to add a blacklis=
t of
> >>>>>>>>
> >>>>>>>> We try to replace this word by either denylist or blocklist, eve=
n in changelogs.
> >>>>>>>
> >>>>>>> Hi Eric,
> >>>>>>>
> >>>>>>> Oh, I'm sorry about that. :( Sure.
> >>>>>>>
> >>>>>>>>
> >>>>>>>>> socket options those can cause troubles when BPF cgroup hook is=
 enabled.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> Can we find the appropriate Fixes: tag to help stable teams ?
> >>>>>>>
> >>>>>>> Sure, I will add next time.
> >>>>>>>
> >>>>>>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt ho=
oks")
> >>>>>>>
> >>>>>>> I think it's better to add Stanislav Fomichev to CC.
> >>>>>>
> >>>>>> Can we use 'struct proto' bpf_bypass_getsockopt instead? We alread=
y
> >>>>>> use it for tcp zerocopy, I'm assuming it should work in this case =
as
> >>>>>> well?
> >>>>>
> >>>>> Jakub reminded me of the other things I wanted to ask here bug forg=
ot:
> >>>>>
> >>>>> - setsockopt is probably not needed, right? setsockopt hook trigger=
s
> >>>>>      before the kernel and shouldn't leak anything
> >>>>> - for getsockopt, instead of bypassing bpf completely, should we in=
stead
> >>>>>      ignore the error from the bpf program? that would still preser=
ve
> >>>>>      the observability aspect
> >>>>
> >>>> stealing this thread to discuss the optlen issue which may make sens=
e to
> >>>> bypass also.
> >>>>
> >>>> There has been issue with optlen. Other than this older post related=
 to
> >>>> optlen > PAGE_SIZE:
> >>>> https://lore.kernel.org/bpf/5c8b7d59-1f28-2284-f7b9-49d946f2e982@lin=
ux.dev/,
> >>>> the recent one related to optlen that we have seen is
> >>>> NETLINK_LIST_MEMBERSHIPS. The userspace passed in optlen =3D=3D 0 an=
d the kernel
> >>>> put the expected optlen (> 0) and 'return 0;' to userspace. The user=
space
> >>>> intention is to learn the expected optlen. This makes 'ctx.optlen >
> >>>> max_optlen' and __cgroup_bpf_run_filter_getsockopt() ends up returni=
ng
> >>>> -EFAULT to the userspace even the bpf prog has not changed anything.
> >>>
> >>> (ignoring -EFAULT issue) this seems like it needs to be
> >>>
> >>>        if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
> >>>                /* error */
> >>>        }
> >>>
> >>> ?
> >>>
> >>>> Does it make sense to also bypass the bpf prog when 'ctx.optlen >
> >>>> max_optlen' for now (and this can use a separate patch which as usua=
l
> >>>> requires a bpf selftests)?
> >>>
> >>> Yeah, makes sense. Replacing this -EFAULT with WARN_ON_ONCE or someth=
ing
> >>> seems like the way to go. It caused too much trouble already :-(
> >>>
> >>> Should I prepare a patch or do you want to take a stab at it?
> >>>
> >>>> In the future, does it make sense to have a specific cgroup-bpf-prog=
 (a
> >>>> specific attach type?) that only uses bpf_dynptr kfunc to access the=
 optval
> >>>> such that it can enforce read-only for some optname and potentially =
also
> >>>> track if bpf-prog has written a new optval? The bpf-prog can only re=
turn 1
> >>>> (OK) and only allows using bpf_set_retval() instead. Likely there is=
 still
> >>>> holes but could be a seed of thought to continue polishing the idea.
> >>>
> >>> Ack, let's think about it.
> >>>
> >>> Maybe we should re-evaluate 'getsockopt-happens-after-the-kernel' ide=
a
> >>> as well? If we can have a sleepable hook that can copy_from_user/copy=
_to_user,
> >>> and we have a mostly working bpf_getsockopt (after your refactoring),
> >>> I don't see why we need to continue the current scheme of triggering
> >>> after the kernel?
> >>
> >> Since a sleepable hook would cause some restrictions, perhaps, we coul=
d
> >> introduce something like the promise pattern.  In our case here, BPF
> >> program call an async version of copy_from_user()/copy_to_user() to
> >> return a promise.
> >
> > Having a promise might work. This is essentially what we already do
> > with sockets/etc with acquire/release pattern.
> >
> > What are the sleepable restrictions you're hinting about? I feel like
> AFAIK, a sleepable program can use only some types of maps; for example,
> array, hash, ringbuf,... etc.  Other types of maps are unavailable to
> sleepable programs; for example, sockmap, sockhash.

Sure, but it doesn't have to stay that way. (hypothetically) If we
think that sleepable makes sense, we can try to expand the scope.

> > with the sleepable bpf, we can also remove all the temporary buffer
> > management / extra copies which sounds like a win to me. (we have this
> > ugly heuristics with BPF_SOCKOPT_KERN_BUF_SIZE) The program can
> > allocate temporary buffers if needed..
> Agree!
>
>
> >
> >>>>> - or maybe we can even have a per-proto bpf_getsockopt_cleanup call=
 that
> >>>>>      gets called whenever bpf returns an error to make sure protoco=
ls have
> >>>>>      a chance to handle that condition (and free the fd)
> >>>>>
> >>>>
> >>>>
