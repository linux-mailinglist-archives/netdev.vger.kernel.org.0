Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF26E4FE9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjDQSKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjDQSKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:10:31 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2E91FDB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 11:10:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a67d2601b3so8973245ad.0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 11:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681755029; x=1684347029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sl9ziKyZqPoy8aLo+Gl92oC/7FehXmT2AIhyqndHBY=;
        b=nJVr4FILdu5bU4E72aAnZSynAvymUqegXgB59klqsogKC7WJxtqSYGYUybck5xKIH8
         FYb5pFzFqkrQKBvl0P66732MQeRjhzSHNoNRtH37Ux2NmgsVxlSiENHCrExCzd+Q/0DR
         P82BdWDMQ50B64/Fc5K+e6vFzUY2y4oCaiEmdabrVXF1FvQ0qlwDMuEjqHcDN7nlGtLd
         58Di7uv/E/K9O6RuLskhxGsDbekYPJZZMQdoDqUfR08+O8D5PYUCEBiYV+RGHRbCcIGH
         bYphFSe5O4b/Hc3hl9lI8jUMn0LhPWi2SeLRu6Tb4So5ZljeCMNqhtLGOvfpjjTLGz/j
         W/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681755029; x=1684347029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sl9ziKyZqPoy8aLo+Gl92oC/7FehXmT2AIhyqndHBY=;
        b=XzjOARcK6vTIbvGEsENMmTN5w4avE/Z1d17sfyB/t03YPIVrlPtdgIlmV4OgBJifxB
         33CsVXIKdP/iuKgoiEWSiJ8YmuldYffVNEP366hedlxSyR3/dWS3EaWYdDmtilaqx0Oq
         Y1toq+YOKCkxxZQfrw79ADKsi7sTfgUfBMGTH8zFHkEpYpzCC/S3oJn8mp9ZLmGVT+Ar
         EJcg3msOau7obXxsrKI4KoZxVBZ2BWE6Jpt+dNmi0EwUaaOhwjRdGVfpss7sTgX9qLVJ
         0DRfZmqsd52bDMzZ1XEavv1DxVEG2e3h8YtgTzSU7U+uz4jPH0L5dwHDx3oy665YggHt
         WzhA==
X-Gm-Message-State: AAQBX9dgGzNENI+/6l8B3eqwyvS7DRbn/LCkT9nHRzHihCNV+MfThRxo
        qMMitXFQYgSB5eXuWcmZ8/pMPtByYD8p4Gf1gGaNHQ==
X-Google-Smtp-Source: AKy350agKI3IJEia6GE10oRHfJ2yBUf/emYDmwLibiytnwVpTiKZKIXteccNnA4CKimextC1Abl3uVyOBTN12S3XK2g=
X-Received: by 2002:a05:6a00:1a43:b0:62e:154e:d6be with SMTP id
 h3-20020a056a001a4300b0062e154ed6bemr7839056pfv.5.1681755028758; Mon, 17 Apr
 2023 11:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com> <20230417-wellblech-zoodirektor-76a80f7763ab@brauner>
In-Reply-To: <20230417-wellblech-zoodirektor-76a80f7763ab@brauner>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 17 Apr 2023 11:10:17 -0700
Message-ID: <CAKH8qBuW+T23ZvvYf4-MPc-S+ChSOARPWpTnLqTEQmF-p_3F6w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/4] net: socket: add sockopts blacklist for
 BPF cgroup hook
To:     Christian Brauner <brauner@kernel.org>
Cc:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org
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

On Mon, Apr 17, 2023 at 7:42=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Fri, Apr 14, 2023 at 06:55:39PM -0700, Stanislav Fomichev wrote:
> > On 04/13, Stanislav Fomichev wrote:
> > > On Thu, Apr 13, 2023 at 7:38=E2=80=AFAM Aleksandr Mikhalitsyn
> > > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > > >
> > > > On Thu, Apr 13, 2023 at 4:22=E2=80=AFPM Eric Dumazet <edumazet@goog=
le.com> wrote:
> > > > >
> > > > > On Thu, Apr 13, 2023 at 3:35=E2=80=AFPM Alexander Mikhalitsyn
> > > > > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > > > > >
> > > > > > During work on SO_PEERPIDFD, it was discovered (thanks to Chris=
tian),
> > > > > > that bpf cgroup hook can cause FD leaks when used with sockopts=
 which
> > > > > > install FDs into the process fdtable.
> > > > > >
> > > > > > After some offlist discussion it was proposed to add a blacklis=
t of
> > > > >
> > > > > We try to replace this word by either denylist or blocklist, even=
 in changelogs.
> > > >
> > > > Hi Eric,
> > > >
> > > > Oh, I'm sorry about that. :( Sure.
> > > >
> > > > >
> > > > > > socket options those can cause troubles when BPF cgroup hook is=
 enabled.
> > > > > >
> > > > >
> > > > > Can we find the appropriate Fixes: tag to help stable teams ?
> > > >
> > > > Sure, I will add next time.
> > > >
> > > > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hook=
s")
> > > >
> > > > I think it's better to add Stanislav Fomichev to CC.
> > >
> > > Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
> > > use it for tcp zerocopy, I'm assuming it should work in this case as
> > > well?
> >
> > Jakub reminded me of the other things I wanted to ask here bug forgot:
> >
> > - setsockopt is probably not needed, right? setsockopt hook triggers
> >   before the kernel and shouldn't leak anything
> > - for getsockopt, instead of bypassing bpf completely, should we instea=
d
> >   ignore the error from the bpf program? that would still preserve
>
> That's fine by me as well.
>
> It'd be great if the net folks could tell Alex how they would want this
> handled.

Doing the bypass seems fine with me for now. If we ever decide that
fd-based optvals are worth inspecting in bpf, we can lift that bypass.

> >   the observability aspect
>
> Please see for more details
> https://lore.kernel.org/lkml/20230411-nudelsalat-spreu-3038458f25c4@braun=
er

Thanks for the context. Yeah, sockopts are being used for a lot of
interesting things :-(

> > - or maybe we can even have a per-proto bpf_getsockopt_cleanup call tha=
t
> >   gets called whenever bpf returns an error to make sure protocols have
> >   a chance to handle that condition (and free the fd)
>
> Installing an fd into an fdtable makes it visible to userspace at which
> point calling close_fd() is doable but an absolute last resort and
> generally a good indicator of misdesign. If the bpf hook wants to make
> decisions based on the file then it should receive a struct
> file, not an fd.

SG! Then let's not over-complicate it for now and do a simple bypass.
