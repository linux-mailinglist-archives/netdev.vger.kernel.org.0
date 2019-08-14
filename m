Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1408E0B0
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 00:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfHNWay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 18:30:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41988 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbfHNWay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 18:30:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id i30so208665pfk.9
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 15:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yFT0DexMwrpcpBksqM27vWgfwGLdGdnJxoa44QNbmXc=;
        b=mdyzDvu42tTkOsWy6oTPXu18OkStVhbhSoIT/SQap4fGl7XOdtBH5ZFB0bHDYa1y/z
         nIG/PUjvCypqMuWoHSfsttI9fau5EVlapKeEuOV2JM9Xu7BhrYnpIqEeq9aUx5/xcZv8
         mEi6tWij5/6vd9gQGKGUeUwwC7mnS84sZfs6oiOuZx90z/9scFOevardh43fJcAjndhO
         7XbOPsnwVlU9htX6OWr4qG5AYWLTeQjQeYSRqO1jVj5ihkf/BawHcc1xYEe1FGXuxL2y
         L2Zc2Lh1QA2T7+ehxuiCBbV/8RfmubBfWt8kIW5Kkl4xy5rSfi3onKqL1VkYlha0+6h9
         qNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yFT0DexMwrpcpBksqM27vWgfwGLdGdnJxoa44QNbmXc=;
        b=GVcoNladGYnO50fNWuXmTfIOn9pyhd4pDjP06P1uJjBwkdB1lQPQtM+eopCrlH8aPc
         cQLJdCsPPAoeD5u4+wjLZrNlknuUxZWyy25XtUlSSvicwbs+ntV0iuPsVkdIvWU34qFa
         dHsx3EMKKXtNqv1SzJeJnB74ZqAQbIJJ6cVRukBs4K9ZMvIpkx2Djg1sJJAp3vAy0Gj3
         IkW7YiHpCMUrgOIVtF7Pj85QIbxpvEJpbVL5aq147ubksuv33M7rOGAqUeGZqN+K7kEk
         fa1lJY8PRAsWIEEsoXjDYizOwgQf5YCCW47iJxDs5dWO4uD7zVrszpQluX4boO1ae47w
         dcWQ==
X-Gm-Message-State: APjAAAVoEpXFlJn1FPXO7Iv4Lu9rWwK9ReRCeeSHB6Cri0BvNg5YsVk4
        Ei497VxHTuEt1zxSLv2S8j533eqyZsA=
X-Google-Smtp-Source: APXvYqzJ31qf7hxB+vYykfcoT3+2aPYGmhoqmEYaHxavvuZTHNyJQKWgpyrk5FWfjptWB1rUiqJeVg==
X-Received: by 2002:a63:5d54:: with SMTP id o20mr1120079pgm.413.1565821853550;
        Wed, 14 Aug 2019 15:30:53 -0700 (PDT)
Received: from ?IPv6:2600:1010:b04e:b450:9121:34aa:70f4:e97c? ([2600:1010:b04e:b450:9121:34aa:70f4:e97c])
        by smtp.gmail.com with ESMTPSA id 4sm917288pfc.92.2019.08.14.15.30.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 15:30:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
Date:   Wed, 14 Aug 2019 15:30:51 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
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
Message-Id: <AD211133-EA60-4B91-AB1B-201713F50AB2@amacapital.net>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com> <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com> <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com> <20190813215823.3sfbakzzjjykyng2@ast-mbp> <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com> <20190814005737.4qg6wh4a53vmso2v@ast-mbp> <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com> <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 14, 2019, at 3:05 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
>> On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
>>=20
>> If eBPF is genuinely not usable by programs that are not fully trusted
>> by the admin, then no kernel changes at all are needed.  Programs that
>> want to reduce their own privileges can easily fork() a privileged
>> subprocess or run a little helper to which they delegate BPF
>> operations.  This is far more flexible than anything that will ever be
>> in the kernel because it allows the helper to verify that the rest of
>> the program is doing exactly what it's supposed to and restrict eBPF
>> operations to exactly the subset that is needed.  So a container
>> manager or network manager that drops some provilege could have a
>> little bpf-helper that manages its BPF XDP, firewalling, etc
>> configuration.  The two processes would talk over a socketpair.
>=20
> there were three projects that tried to delegate bpf operations.
> All of them failed.
> bpf operational workflow is much more complex than you're imagining.
> fork() also doesn't work for all cases.
> I gave this example before: consider multiple systemd-like deamons
> that need to do bpf operations that want to pass this 'bpf capability'
> to other deamons written by other teams. Some of them will start
> non-root, but still need to do bpf. They will be rpm installed
> and live upgraded while running.
> We considered to make systemd such centralized bpf delegation
> authority too. It didn't work. bpf in kernel grows quickly.
> libbpf part grows independently. llvm keeps evolving.
> All of them are being changed while system overall has to stay
> operational. Centralized approach breaks apart.
>=20
>> The interesting cases you're talking about really *do* involved
>> unprivileged or less privileged eBPF, though.  Let's see:
>>=20
>> systemd --user: systemd --user *is not privileged at all*.  There's no
>> issue of reducing privilege, since systemd --user doesn't have any
>> privilege to begin with.  But systemd supports some eBPF features, and
>> presumably it would like to support them in the systemd --user case.
>> This is unprivileged eBPF.
>=20
> Let's disambiguate the terminology.
> This /dev/bpf patch set started as describing the feature as 'unprivileged=
 bpf'.
> I think that was a mistake.
> Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
> This is not unprivileged.
> 'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled control=
s.
>=20
> There is a huge difference between the two.
> I'm against extending 'unprivileged bpf' even a bit more than what it is
> today for many reasons mentioned earlier.
> The /dev/bpf is about 'less privileged'.
> Less privileged than root. We need to split part of full root capability
> into bpf capability. So that most of the root can be dropped.
> This is very similar to what cap_net_admin does.
> cap_net_amdin can bring down eth0 which is just as bad as crashing the box=
.
> cap_net_admin is very much privileged. Just 'less privileged' than root.
> Same thing for cap_bpf.

The new pseudo-capability in this patch set is absurdly broad. I=E2=80=99ve p=
roposed some finer-grained divisions in this thread. Do you have comments on=
 them?

>=20
> May be we should do both cap_bpf and /dev/bpf to make it clear that
> this is the same thing. Two interfaces to achieve the same result.

What for?  If there=E2=80=99s a CAP_BPF, then why do you want /dev/bpf? Espe=
cially if you define it to do the same thing.

>=20
>> Seccomp.  Seccomp already uses cBPF, which is a form of BPF although
>> it doesn't involve the bpf() syscall.  There are some seccomp
>> proposals in the works that will want some stuff from eBPF.  In
>=20
> I'm afraid these proposals won't go anywhere.

Can you explain why?

>=20
>> So it's a bit of a chicken-and-egg situation.  There aren't major
>> unprivileged eBPF users because the kernel support isn't there.
>=20
> As I said before there are zero known use cases of 'unprivileged bpf'.
>=20
> If I understand you correctly you're refusing to accept that
> 'less privileged bpf' is a valid use case while pushing for extending
> scope of 'unprivileged'.

No, I=E2=80=99m not.  I have no objection at all if you try to come up with a=
 clear definition of what the capability checks do and what it means to gran=
t a new permission to a task.  Changing *all* of the capable checks is needl=
essly broad.=
