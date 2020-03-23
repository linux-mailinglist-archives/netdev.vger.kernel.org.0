Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6016C18FC57
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCWSHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:07:34 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44867 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgCWSHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:07:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id x16so3382678qts.11;
        Mon, 23 Mar 2020 11:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kOsRiKjpptFAdIZHzpHJNAGbMzG9PVI3Hv5yCOEdurg=;
        b=SUCIMgpug6bL+XXTANt7qiSXkktjdYRu+UZr82h5bJ9W53FfSR+y2Ht+Hl+I2loWzn
         xu5hDprpBuJ4SOdzlvyKICUrSrsS6PYYZkMKSrcFoqmfVrF03zVPmpf/T2KhgRa2KgZI
         QD5/JVqh6TSq6BAYUpq8QmDju0wS4EecObdmyz416aIfqn7mOpkSyT7WmzGX+KDb4OhP
         tjofUKki7sA9ynf+EoEIyJ8mluO2szxl5Qrp1wnJa7QRLebysUC7Z7yVI7qWj1OqLi2z
         FAHsefoyesnsiMXE5d88+ryWgOJIf+KB+lJsl3dQkAWJzt8WUdsi1IrE8rxlSzBByXZU
         0jbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kOsRiKjpptFAdIZHzpHJNAGbMzG9PVI3Hv5yCOEdurg=;
        b=rb6O3QNOP14J2wqrYL6yhciwzUeb6jAIc7cSIdfaKrzASkgn7+X5gzL7Qjv8JqvUD2
         8qLaIffFII0UM2nbVWylQCcA7GjA1IWH8vNfSzXTtnRVVRizHjTUW+3UYnmJ8gbsfDo0
         0CkONJYVr7zqCNcmy/r++rUhgzei7qualy7FWq1TOj2lxWyxKYp9cfRZqCV4Ty7aRYcF
         JIxjNQrERQ4OeOdFy1V9MeK/whSv4yKJEaifP1ACQ/646eCcwadROV7K4TV5SfOeIK12
         58mYb9aJKwmLm2Xpj32uRXw/5gXPJbl9kV9p1eBZW2yhOmta4nGu9vyC1q3KUIE8Eu3c
         n9DQ==
X-Gm-Message-State: ANhLgQ0HvUuhI8wsGp4FogCiU5MdPSVMbg/uo7x0GaHw+W2Py6JTmKEW
        gqtYnGL20q8CmZSs6OqrlNwpNAaOSBlSHT77BkI=
X-Google-Smtp-Source: ADFU+vsVGxEG+qd5/OdKi0rVqCDEUxcJblLJibNzjVgCnpJpG8amI4a5Q8uN6H8+wiLOI5EUmiEz1rdOXcKQ4qjjyTk=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr22106931qtk.171.1584986852257;
 Mon, 23 Mar 2020 11:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <CAEf4BzYGZz7hdd-_x+uyE0OF8h_3vJxNjF-Qkd5QhOWpaB8bbQ@mail.gmail.com>
 <87r1xj48ko.fsf@toke.dk>
In-Reply-To: <87r1xj48ko.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Mar 2020 11:07:20 -0700
Message-ID: <CAEf4BzZOfJVV+032pmaKTzCrpgX3mufBvVfwOhLcM1YPMDTOow@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 4:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Mar 20, 2020 at 1:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Jakub Kicinski <kuba@kernel.org> writes:
> >>
> >> > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >>
> >> >> While it is currently possible for userspace to specify that an exi=
sting
> >> >> XDP program should not be replaced when attaching to an interface, =
there is
> >> >> no mechanism to safely replace a specific XDP program with another.
> >> >>
> >> >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, whic=
h can be
> >> >> set along with IFLA_XDP_FD. If set, the kernel will check that the =
program
> >> >> currently loaded on the interface matches the expected one, and fai=
l the
> >> >> operation if it does not. This corresponds to a 'cmpxchg' memory op=
eration.
> >> >>
> >> >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explici=
tly
> >> >> request checking of the EXPECTED_FD attribute. This is needed for u=
serspace
> >> >> to discover whether the kernel supports the new attribute.
> >> >>
> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >
> >> > I didn't know we wanted to go ahead with this...
> >>
> >> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
> >> happening with that, though. So since this is a straight-forward
> >> extension of the existing API, that doesn't carry a high implementatio=
n
> >> cost, I figured I'd just go ahead with this. Doesn't mean we can't hav=
e
> >> something similar in bpf_link as well, of course.
> >>
> >> > If we do please run this thru checkpatch, set .strict_start_type,
> >>
> >> Will do.
> >>
> >> > and make the expected fd unsigned. A negative expected fd makes no
> >> > sense.
> >>
> >> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
> >> flag. I guess you could argue that since we have that flag, setting a
> >> negative expected_fd is not strictly needed. However, I thought it was
> >> weird to have a "this is what I expect" API that did not support
> >> expressing "I expect no program to be attached".
> >
> > For BPF syscall it seems the typical approach when optional FD is
> > needed is to have extra flag (e.g., BPF_F_REPLACE for cgroups) and if
> > it's not specified - enforce zero for that optional fd. That handles
> > backwards compatibility cases well as well.
>
> Never did understand how that is supposed to square with 0 being a valid
> fd number?

You mean a tiny chance that given invalid userspace program behavior
(setting valid FD 0 without specifying BPF_F_REPLACE or not setting
FD, but FD=3D0 being a valid program FD) it might succeed accidentally?
Sure it's theoretically possible, but highly unlikely and in any case
it's an invalid userspace behavior. So I guess it was deemed
acceptable for the sake of backwards compatibility?

>
> -Toke
>
