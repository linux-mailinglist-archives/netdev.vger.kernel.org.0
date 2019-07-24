Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF1723D2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfGXBkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:40:33 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36408 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfGXBkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:40:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so21321443plt.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 18:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fugMyQialasQg77i1MwbSB/hy058oIuvmQv9Y6tRr8I=;
        b=hferate5+QJcLPj2tAGig4LvzjyxwA7qbAq+ZZYnyGQsHCf0vtfGC2nYAcoCq/ubtt
         g9J065NnEX5JYfhjXkzw+JksQc3nSV+fUISqXdOjqNIM3o471s6CIOD9nN4ZqmuCv+t2
         cjKhj4jA4OBb6VxlsCkziQ99TueAg0cXav6rh6Eqemal0op1Ua63R+nYU0R66gL+T7Z4
         3te++RkMDL0hFZf8QI6GQvddpT14rjbTeLdK/zad5CMPRrVpqaMGl08KZnhsi7ap41u9
         w28qSz8DnrLLiG25UPaQtkN5trn9t4tnn8TyXb5Crr+/S6JgBin4OpZnVE7+UFZZZOnX
         rWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fugMyQialasQg77i1MwbSB/hy058oIuvmQv9Y6tRr8I=;
        b=s6FRsSaNLIHPVGNnHfOzUQDK/4AdSe/3Wd+uFzPFvIBBr9n9OBn7GPPLvXbceFkoKb
         C7xrT/du7qLJfp/dM6vY9HPRLSsQ09f/4yaTmRo5vl5CatfNqE32XLnjgTv+NGQ9oQLv
         SEnl6FCgvgSetWBOfsHdfzkvC+wuiup/njM7j0GylO+1M9YXhjO2dXk8riamwqm5cs3u
         nMOHasLt8CL62gSr6oXgyVeC4UJcyrQ7P9sDg+nHp1UKffGunAiOfysm4BUSYMvSC+tc
         QedTs1l/9lOgHr92l1pZ3I9AtFA2GSxMtS4zR5M/hZX7+haz6B+S51rJ6wE+d8eaALOo
         bFGQ==
X-Gm-Message-State: APjAAAWxlPbhqBOHG+hn69dlIjBKSgzLKEjeoH3NPwuQPlHdHTCVaQmR
        eTFjMLldGHAJI4Vnnl44StyFiw==
X-Google-Smtp-Source: APXvYqxDgG1VQC8Z4Kl+Efc0w8MxVrAvet4CeE5c0galulRK0so/jOD5qMSdZrhm0Y2qhb3f7NJ4QA==
X-Received: by 2002:a17:902:1486:: with SMTP id k6mr81977059pla.177.1563932431622;
        Tue, 23 Jul 2019 18:40:31 -0700 (PDT)
Received: from ?IPv6:2600:1010:b055:19e0:81e6:db78:9a51:8f05? ([2600:1010:b055:19e0:81e6:db78:9a51:8f05])
        by smtp.gmail.com with ESMTPSA id t8sm48118442pfq.31.2019.07.23.18.40.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 18:40:30 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
Date:   Tue, 23 Jul 2019 18:40:28 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
References: <20190627201923.2589391-1-songliubraving@fb.com> <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org> <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com> <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com> <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com> <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com> <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com> <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
To:     Song Liu <songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 23, 2019, at 3:56 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Jul 23, 2019, at 8:11 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>=20
>> On Mon, Jul 22, 2019 at 1:54 PM Song Liu <songliubraving@fb.com> wrote:
>>>=20
>>> Hi Andy, Lorenz, and all,
>>>=20
>>>> On Jul 2, 2019, at 2:32 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>=20
>>>> On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:=

>>>>>=20
>>>>>> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
>>>>>> I think I'm understanding your motivation.  You're not trying to make=

>>>>>> bpf() generically usable without privilege -- you're trying to create=

>>>>>> a way to allow certain users to access dangerous bpf functionality
>>>>>> within some limits.
>>>>>>=20
>>>>>> That's a perfectly fine goal, but I think you're reinventing the
>>>>>> wheel, and the wheel you're reinventing is quite complicated and
>>>>>> already exists.  I think you should teach bpftool to be secure when
>>>>>> installed setuid root or with fscaps enabled and put your policy in
>>>>>> bpftool.  If you want to harden this a little bit, it would seem
>>>>>> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
>>>>>> not all, of the capable() checks to check CAP_BPF_ADMIN instead of th=
e
>>>>>> capabilities that they currently check.
>>>>>=20
>>>>> If finer grained controls are wanted, it does seem like the /dev/bpf
>>>>> path makes the most sense. open, request abilities, use fd. The open c=
an
>>>>> be mediated by DAC and LSM. The request can be mediated by LSM. This
>>>>> provides a way to add policy at the LSM level and at the tool level.
>>>>> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owne=
d
>>>>> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
>>>>> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
>>>>>=20
>>>>> With only a new CAP, you don't get the fine-grained controls. (The
>>>>> "request abilities" part is the key there.)
>>>>=20
>>>> Sure you do: the effective set.  It has somewhat bizarre defaults, but
>>>> I don't think that's a real problem.  Also, this wouldn't be like
>>>> CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.
>>>>=20
>>>> I think that a /dev capability-like object isn't totally nuts, but I
>>>> think we should do it well, and this patch doesn't really achieve
>>>> that.  But I don't think bpf wants fine-grained controls like this at
>>>> all -- as I pointed upthread, a fine-grained solution really wants
>>>> different treatment for the different capable() checks, and a bunch of
>>>> them won't resemble capabilities or /dev/bpf at all.
>>>=20
>>> With 5.3-rc1 out, I am back on this. :)
>>>=20
>>> How about we modify the set as:
>>> 1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.
>>=20
>> I'm fine with this in principle, but:
>>=20
>>> 2. Better handling of capable() calls through bpf code. I guess the
>>>    biggest problem here is is_priv in verifier.c:bpf_check().
>>=20
>> I think it would be good to understand exactly what /dev/bpf will
>> enable one to do.  Without some care, it would just become the next
>> CAP_SYS_ADMIN: if you can open it, sure, you're not root, but you can
>> intercept network traffic, modify cgroup behavior, and do plenty of
>> other things, any of which can probably be used to completely take
>> over the system.
>=20
> Well, yes. sys_bpf() is pretty powerful.=20
>=20
> The goal of /dev/bpf is to enable special users to call sys_bpf(). In=20
> the meanwhile, such users should not take down the whole system easily
> by accident, e.g., with rm -rf /.

That=E2=80=99s easy, though =E2=80=94 bpftool could learn to read /etc/bpfus=
ers before allowing ruid !=3D 0.

>=20
> It is similar to CAP_BPF_ADMIN, without really adding the CAP_. =20
>=20
> I think adding new CAP_ requires much more effort.=20
>=20

A new CAP_ is straightforward =E2=80=94 add the definition and change the ma=
x cap.

>>=20
>> It would also be nice to understand why you can't do what you need to
>> do entirely in user code using setuid or fscaps.
>=20
> It is not very easy to achieve the same control: only certain users can
> run certain tools (bpftool, etc.).=20
>=20
> The closest approach I can find is:
>  1. use libcap (pam_cap) to give CAP_SETUID to certain users;
>  2. add setuid(0) to bpftool.
>=20
> The difference between this approach and /dev/bpf is that certain users
> would be able to run other tools that call setuid(). Though I am not=20
> sure how many tools call setuid(), and how risky they are.=20

I think you=E2=80=99re misunderstanding me. Install bpftool with either the s=
etuid (S_ISUID) mode or with an appropriate fscap bit =E2=80=94 see the setc=
ap(8) manpage.

The downside of this approach is that it won=E2=80=99t work well in a contai=
ner, and containers are cool these days :)

>=20
>>=20
>> Finally, at risk of rehashing some old arguments, I'll point out that
>> the bpf() syscall is an unusual design to begin with.  As an example,
>> consider bpf_prog_attach().  Outside of bpf(), if I want to change the
>> behavior of a cgroup, I would write to a file in
>> /sys/kernel/cgroup/unified/whatever/, and normal DAC and MAC rules
>> apply.  With bpf(), however, I just call bpf() to attach a program to
>> the cgroup.  bpf() says "oh, you are capable(CAP_NET_ADMIN) -- go for
>> it!".  Unless I missed something major, and I just re-read the code,
>> there is no check that the caller has write or LSM permission to
>> anything at all in cgroupfs, and the existing API would make it very
>> awkward to impose any kind of DAC rules here.
>>=20
>> So I think it might actually be time to repay some techincal debt and
>> come up with a real fix.  As a less intrusive approach, you could see
>> about requiring ownership of the cgroup directory instead of
>> CAP_NET_ADMIN.  As a more intrusive but perhaps better approach, you
>> could invert the logic to to make it work like everything outside of
>> cgroup: add pseudo-files like bpf.inet_ingress to the cgroup
>> directories, and require a writable fd to *that* to a new improved
>> attach API.  If a user could do:
>>=20
>> int fd =3D open("/sys/fs/cgroup/.../bpf.inet_attach", O_RDWR);  /* usual
>> DAC and MAC policy applies */
>> int bpf_fd =3D setup the bpf stuff;  /* no privilege required, unless
>> the program is huge or needs is_priv */
>> bpf(BPF_IMPROVED_ATTACH, target =3D fd, program =3D bpf_fd);
>>=20
>> there would be no capabilities or global privilege at all required for
>> this.  It would just work with cgroup delegation, containers, etc.
>>=20
>> I think you could even pull off this type of API change with only
>> libbpf changes.  In particular, there's this code:
>>=20
>> int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type=
,
>>                   unsigned int flags)
>> {
>>       union bpf_attr attr;
>>=20
>>       memset(&attr, 0, sizeof(attr));
>>       attr.target_fd     =3D target_fd;
>>       attr.attach_bpf_fd =3D prog_fd;
>>       attr.attach_type   =3D type;
>>       attr.attach_flags  =3D flags;
>>=20
>>       return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
>> }
>>=20
>> This would instead do something like:
>>=20
>> int specific_target_fd =3D openat(target_fd, bpf_type_to_target[type], O_=
RDWR);
>> attr.target_fd =3D specific_target_fd;
>> ...
>>=20
>> return sys_bpf(BPF_PROG_IMPROVED_ATTACH, &attr, sizeof(attr));
>>=20
>> Would this solve your problem without needing /dev/bpf at all?
>=20
> This gives fine grain access control. I think it solves the problem.=20
> But it also requires a lot of rework to sys_bpf(). And it may also=20
> break backward/forward compatibility?
>=20

I think the compatibility issue is manageable. The current bpf() interface w=
ould be supported for at least several years, and libbpf could detect that t=
he new interface isn=E2=80=99t supported and fall back the old interface

> Personally, I think it is an overkill for the original motivation:=20
> call sys_bpf() with special user instead of root.=20

It=E2=80=99s overkill for your specific use case, but I=E2=80=99m trying to e=
ncourage you to either solve your problem entirely in userspace or to solve a=
 more general problem in the kernel :)

In furtherance of bpf=E2=80=99s goal of world domination, I think it would b=
e great if it Just Worked in a container. My proposal does this.
