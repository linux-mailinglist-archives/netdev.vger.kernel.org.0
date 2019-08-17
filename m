Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0B5911C3
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfHQPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 11:44:55 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39702 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfHQPoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 11:44:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so3717926pln.6
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=R2/VJq6nrOFMWOBOgnh5HWjyHIE/BDqFX+S1CeV3qAs=;
        b=WaP7COrr+38AIFHTYCbpqcx3jLbdYVTtlCWA+1q5UPdXIiVAPDyvZf9DznDc9S8c2u
         J2urZpD3/44z3m341acVQM9Fd6YpoHb6MV0OC587gacLZPxksqSGGC5P18a+s9X4DrC5
         glswsfCwPe1MCUkV9D77l52MeDoV/odb8e7K4nf++wuk6JbknP2w+WFaswPoGL/LA1Ea
         k/enOTcOZq7XAVufNnZKXMAJcjpbnfTcyP/psfuUKkaAKPmN8RMT03nLb++aubNbv05Q
         PcFbzZBJWsHQEEzMKpsLM2OgRqPkqlP5hVihi3lo369sVowoeJmpga1fVTtsowuIKZZe
         dmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=R2/VJq6nrOFMWOBOgnh5HWjyHIE/BDqFX+S1CeV3qAs=;
        b=rGnufN1GChaaE18QdiSlhfeQ+eKF8Ex2rbmLe0uTgvITA3uw9aNgPYfsnbAJeygE1z
         eUv5o+F9iUbt/PePI8IzhaDntEtzEXIO0/B+kUJIcbktfdv+8w3vWp2hLfw1r0XKhPcJ
         ppY9AKBc0t8uLW09jekMhemKY+5ZW+xQImug1w/Mm3bp8955mVDGYHRGXWQoTrJqHP2x
         L/XoRCvXsXO46aYedJAiCZW2gNS5Af3BU0aJ3+aT5f9fRQlGBYR+n0UWGR7x+SCPmDHd
         mcT3egJaDDI7+aqVUK6khLuL7PIN1qMBdHlOaW/Ui2VRjxM6zXVLHuT3uP1fKvR8MgTk
         YiNQ==
X-Gm-Message-State: APjAAAUZQ3tmpCPavnUWx5Qxn05o9fvlTFMy70JMq8R//b9shCYaESqx
        lg3YM9uooq0Cuiutn7a5mTVutA==
X-Google-Smtp-Source: APXvYqxGPZQ32jm+v1QngNi4NkhKo4BrhhWdQ6WcwGGei+2UBkhZw6dczbdrutxMwyo4yOE9YZomEQ==
X-Received: by 2002:a17:902:2bc8:: with SMTP id l66mr14790994plb.222.1566056694423;
        Sat, 17 Aug 2019 08:44:54 -0700 (PDT)
Received: from ?IPv6:2600:1010:b04e:b450:b585:791c:ba5c:79b4? ([2600:1010:b04e:b450:b585:791c:ba5c:79b4])
        by smtp.gmail.com with ESMTPSA id m13sm9400788pgn.57.2019.08.17.08.44.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 08:44:53 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <20190817150245.xxzxqjpvgqsxmloe@ast-mbp>
Date:   Sat, 17 Aug 2019 08:44:52 -0700
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jordan Glover <Golden_Miller83@protonmail.ch>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <959BAF9B-F2A2-4187-A2A7-C64D675F537B@amacapital.net>
References: <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com> <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch> <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com> <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com> <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com> <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch> <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de> <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch> <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com> <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de> <20190817150245.xxzxqjpvgqsxmloe@ast-mbp>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 17, 2019, at 8:02 AM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:

>=20
> Can any of the mechanisms 1/2/3 address the concern in mds.rst?
>=20

seccomp() can. It=E2=80=99s straightforward to use seccomp to disable bpf() o=
utright for a process tree.  In this regard, bpf() isn=E2=80=99t particularl=
y unique =E2=80=94 it=E2=80=99s a system call that exposes some attack surfa=
ce and that isn=E2=80=99t required by most programs for basic functionality.=


At LPC this year, there will be a discussion about seccomp improvements that=
 will, among other things, offer fiber-grained control. It=E2=80=99s quite l=
ikely, for example, that seccomp will soon be able to enable and disable spe=
cific map types or attach types.  The exact mechanism isn=E2=80=99t decided y=
et,  but I think everyone expects that this is mostly a design problem, not a=
n implementation problem.

This is off topic for the current thread, but it could be useful to allow bp=
f programs to be loaded from files directly (i.e. pass an fd to a file into b=
pf() to load the program), which would enable LSMs to check that the file is=
 appropriately labeled. This would dramatically raise the bar for exploitati=
on of verifier bugs or speculation attacks, since anyone trying to exploit i=
t would need to get the bpf payload through LSM policy first.

> I believe Andy wants to expand the attack surface when
> kernel.unprivileged_bpf_disabled=3D0
> Before that happens I'd like the community to work on addressing the text a=
bove.
>=20

Not by much. BPF maps are already largely exposed to unprivileged code (when=
 unprivileged_bpf_disabled=3D0).  The attack surface is there, and they=E2=80=
=99re arguably even more exposed than they should be.  My patch 1 earlier wa=
s about locking these interfaces down.

Similarly, my suggestions about reworking cgroup attach and program load don=
=E2=80=99t actually allow fully unprivileged users to run arbitrary bpf() pr=
ograms [0] =E2=80=94 under my proposal, to attach a bpf cgroup program, you n=
eed a delegated cgroup. The mechanism could be extended by a requirement tha=
t a privileged cgroup manager explicitly enable certain attach types for a d=
elegated subtree.

A cgroup knob to turn unprivileged bpf on and off for tasks in the cgroup mi=
ght actually be quite useful.

[0] on some thought, the test run mechanism should probably remain root-only=
.

