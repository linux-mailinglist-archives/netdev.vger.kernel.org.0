Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5366E6A1A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjDRQsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjDRQsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:48:22 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DFED31D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:48:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b5465fb62so1696007b3a.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681836469; x=1684428469;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5rSxGUFrAmISVwIuFMTX0Aaejk/CKt02QLw7n2d5NOs=;
        b=PfoljIC5AZgXfIxDU8fcFKkh+Ai7eQzzLzicR4jBjiom7LEoYDZGvTMDGrbG1Z4Ud7
         uMFVTAK+JTtzoS0MKvtPGWwdSGtIBD8kbc4SfLXHCjA0I+SdKKcDb46CvxZO4RN+QKcr
         4hGNVdTIfrAcrWEkQiQ8/3e7ZlrlhVk194MVJD6NQvH/IjLipRSf4B0QGnTZ6j+s3rfO
         FoaxHebR4VegmT9yDpEETwUTkmKAd4ZKG8Yfxznn/n4SwSaLHbnH7ecVFw7Uf6szdwMe
         597Gvj4Ii7piDYSmLzXGyGrd1L9thTQGMBdxwypwEggoGYj/8WHWeiNd3wF6/PVMsJk1
         sufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681836469; x=1684428469;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5rSxGUFrAmISVwIuFMTX0Aaejk/CKt02QLw7n2d5NOs=;
        b=fW9odBWUi3ky2CBP0y2ihqSuw6SWKlP4q55G0d319ARZF5DbvLp4z0p0p6pDVqUI+F
         /Jcb/s8PEtEnEBg2se+KZq+fA59PfrqVFnpSdFs9LwbZyD+JJ8CpsL8athhVDgOQSmSU
         YEwmhnZeqai4K/lkikjJ5GOCBkvDvIoWSOkBuQRrUPjFrR1gwLuukrvs3SoY+6065ASZ
         3NxUzK4I5GNVZDGbIV5Qr/nUZXQWN6RR+oYY+uArHmsWMJONXRo2vPxiFYn5rCPY+zWE
         NvFQR/kw2VEc0H/JqhHUk6YhYx8h4iDK2TecsFDXLu+85WX3qkFK4ca+7QJuQix4zTbt
         7jdQ==
X-Gm-Message-State: AAQBX9eB4GjPy09qLgn5hoMNgN7qfnFMosu0WXR0bFaOJ2fAp/ZzCzsq
        lhzZMOh+YJVJ6Y7JAxxDBMK61o0=
X-Google-Smtp-Source: AKy350ZqYBxtk9IGpUQI+ESsiEZ06M7bEzkTzb5twCE4jk0SIv/hlG6z2jLAoF7+l4gdKxwicmpHmjg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:17a0:b0:63b:8778:99e5 with SMTP id
 s32-20020a056a0017a000b0063b877899e5mr195402pfg.5.1681836468849; Tue, 18 Apr
 2023 09:47:48 -0700 (PDT)
Date:   Tue, 18 Apr 2023 09:47:47 -0700
In-Reply-To: <a4591e85-d58b-0efd-c8a4-2652dc69ff68@linux.dev>
Mime-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com> <a4591e85-d58b-0efd-c8a4-2652dc69ff68@linux.dev>
Message-ID: <ZD7Js4fj5YyI2oLd@google.com>
Subject: Re: handling unsupported optlen in cgroup bpf getsockopt: (was [PATCH
 net-next v4 2/4] net: socket: add sockopts blacklist for BPF cgroup hook)
From:   Stanislav Fomichev <sdf@google.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/17, Martin KaFai Lau wrote:
> On 4/14/23 6:55 PM, Stanislav Fomichev wrote:
> > On 04/13, Stanislav Fomichev wrote:
> > > On Thu, Apr 13, 2023 at 7:38=E2=80=AFAM Aleksandr Mikhalitsyn
> > > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > > >=20
> > > > On Thu, Apr 13, 2023 at 4:22=E2=80=AFPM Eric Dumazet <edumazet@goog=
le.com> wrote:
> > > > >=20
> > > > > On Thu, Apr 13, 2023 at 3:35=E2=80=AFPM Alexander Mikhalitsyn
> > > > > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > > > > >=20
> > > > > > During work on SO_PEERPIDFD, it was discovered (thanks to Chris=
tian),
> > > > > > that bpf cgroup hook can cause FD leaks when used with sockopts=
 which
> > > > > > install FDs into the process fdtable.
> > > > > >=20
> > > > > > After some offlist discussion it was proposed to add a blacklis=
t of
> > > > >=20
> > > > > We try to replace this word by either denylist or blocklist, even=
 in changelogs.
> > > >=20
> > > > Hi Eric,
> > > >=20
> > > > Oh, I'm sorry about that. :( Sure.
> > > >=20
> > > > >=20
> > > > > > socket options those can cause troubles when BPF cgroup hook is=
 enabled.
> > > > > >=20
> > > > >=20
> > > > > Can we find the appropriate Fixes: tag to help stable teams ?
> > > >=20
> > > > Sure, I will add next time.
> > > >=20
> > > > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hook=
s")
> > > >=20
> > > > I think it's better to add Stanislav Fomichev to CC.
> > >=20
> > > Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
> > > use it for tcp zerocopy, I'm assuming it should work in this case as
> > > well?
> >=20
> > Jakub reminded me of the other things I wanted to ask here bug forgot:
> >=20
> > - setsockopt is probably not needed, right? setsockopt hook triggers
> >    before the kernel and shouldn't leak anything
> > - for getsockopt, instead of bypassing bpf completely, should we instea=
d
> >    ignore the error from the bpf program? that would still preserve
> >    the observability aspect
>=20
> stealing this thread to discuss the optlen issue which may make sense to
> bypass also.
>=20
> There has been issue with optlen. Other than this older post related to
> optlen > PAGE_SIZE:
> https://lore.kernel.org/bpf/5c8b7d59-1f28-2284-f7b9-49d946f2e982@linux.de=
v/,
> the recent one related to optlen that we have seen is
> NETLINK_LIST_MEMBERSHIPS. The userspace passed in optlen =3D=3D 0 and the=
 kernel
> put the expected optlen (> 0) and 'return 0;' to userspace. The userspace
> intention is to learn the expected optlen. This makes 'ctx.optlen >
> max_optlen' and __cgroup_bpf_run_filter_getsockopt() ends up returning
> -EFAULT to the userspace even the bpf prog has not changed anything.

(ignoring -EFAULT issue) this seems like it needs to be

	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
		/* error */
	}

?

> Does it make sense to also bypass the bpf prog when 'ctx.optlen >
> max_optlen' for now (and this can use a separate patch which as usual
> requires a bpf selftests)?

Yeah, makes sense. Replacing this -EFAULT with WARN_ON_ONCE or something
seems like the way to go. It caused too much trouble already :-(

Should I prepare a patch or do you want to take a stab at it?

> In the future, does it make sense to have a specific cgroup-bpf-prog (a
> specific attach type?) that only uses bpf_dynptr kfunc to access the optv=
al
> such that it can enforce read-only for some optname and potentially also
> track if bpf-prog has written a new optval? The bpf-prog can only return =
1
> (OK) and only allows using bpf_set_retval() instead. Likely there is stil=
l
> holes but could be a seed of thought to continue polishing the idea.

Ack, let's think about it.

Maybe we should re-evaluate 'getsockopt-happens-after-the-kernel' idea
as well? If we can have a sleepable hook that can copy_from_user/copy_to_us=
er,
and we have a mostly working bpf_getsockopt (after your refactoring),
I don't see why we need to continue the current scheme of triggering
after the kernel?

> > - or maybe we can even have a per-proto bpf_getsockopt_cleanup call tha=
t
> >    gets called whenever bpf returns an error to make sure protocols hav=
e
> >    a chance to handle that condition (and free the fd)
> >=20
>=20
>=20
