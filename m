Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8F190A76
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCXKQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:16:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58419 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727152AbgCXKQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:16:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585044971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1wY4En0yDB+cGvUu+J0YQ/O0nGvtOSgxUaiPAKKcj4=;
        b=OEvILK6vglIlkeFk2jW8z+5SeqPqXG5Ipe/NVtyH3H+ZO2jNytwWkGKpYi6KWIUluFQDdz
        qpXv8uEnLlGlISdGHG00HQ16dj7YLYqZuq4Eh+JuVKmWxohm7dMLqo9QKy7AnMuETeD3jC
        aFbAjf512cwYe/TzT4Ni//4du64DZcg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-shpClZs6OQWnYImXPnQNzg-1; Tue, 24 Mar 2020 06:16:10 -0400
X-MC-Unique: shpClZs6OQWnYImXPnQNzg-1
Received: by mail-wm1-f70.google.com with SMTP id w9so1098731wmi.2
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 03:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/1wY4En0yDB+cGvUu+J0YQ/O0nGvtOSgxUaiPAKKcj4=;
        b=n2PaH5PE2qR0yWX6hOXch473Jiut8SwVtwsPx2xQLyjFi93pdg6w/afX5HQSTNXZRx
         6PyqHYrKsyo1WWnjdx10W31bMm1lOozUn3+FPpigJv0viAQ9xWzTJBJUhWwpyaRJVqhw
         lIn1PKseOAt4htsc3mKOdHIKEMJjDzJDzvit90QjRSbre48FLb21Lk2AXtxV/2Su9lDl
         56oEzMeL3OAc59gEHWjlDFZtD42VdBdPM/9MZnIQ2h3ytdzkV1m4a0OdL3yLhawyBtEm
         mwGb15FqsVyQyek8qInWhuRRaq7m0+aNWyLHLD5CJqv8dwAhypQARqQnCJJZNng4D1CE
         pLww==
X-Gm-Message-State: ANhLgQ0shgUIWkg9M1uJRks84fQU5D+jVfcsgr9uGWHsLL4/x0KKg4WS
        y8gE7B3OIPkf+pRndWjEYY/+CtScn3eZdMfVReLj+2xBG2S8ohVnVOYO9VriM9ZR8KRf18CPJn0
        bhY9TfwmLHkeu1lhZ
X-Received: by 2002:a5d:6045:: with SMTP id j5mr34114905wrt.401.1585044969082;
        Tue, 24 Mar 2020 03:16:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt4fxw3WQlcrSpfYVY6EUzmKWp+2/hFVX/ZlQ7yZFHspc85MIgrLtEPxWoN8Rr5x79q54R6OQ==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr34114878wrt.401.1585044968861;
        Tue, 24 Mar 2020 03:16:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u13sm11839118wru.88.2020.03.24.03.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 03:16:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 29A13180371; Tue, 24 Mar 2020 11:16:06 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200323235441.GA33093@rdna-mbp>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <CAEf4BzYGZz7hdd-_x+uyE0OF8h_3vJxNjF-Qkd5QhOWpaB8bbQ@mail.gmail.com> <87r1xj48ko.fsf@toke.dk> <20200323235441.GA33093@rdna-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 24 Mar 2020 11:16:06 +0100
Message-ID: <87369y2h3t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Ignatov <rdna@fb.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> [Mon, 2020-03-23 04:25=
 -0700]:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>=20
>> > On Fri, Mar 20, 2020 at 1:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Jakub Kicinski <kuba@kernel.org> writes:
>> >>
>> >> > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen=
 wrote:
>> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> >>
>> >> >> While it is currently possible for userspace to specify that an ex=
isting
>> >> >> XDP program should not be replaced when attaching to an interface,=
 there is
>> >> >> no mechanism to safely replace a specific XDP program with another.
>> >> >>
>> >> >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, whi=
ch can be
>> >> >> set along with IFLA_XDP_FD. If set, the kernel will check that the=
 program
>> >> >> currently loaded on the interface matches the expected one, and fa=
il the
>> >> >> operation if it does not. This corresponds to a 'cmpxchg' memory o=
peration.
>> >> >>
>> >> >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explic=
itly
>> >> >> request checking of the EXPECTED_FD attribute. This is needed for =
userspace
>> >> >> to discover whether the kernel supports the new attribute.
>> >> >>
>> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> >
>> >> > I didn't know we wanted to go ahead with this...
>> >>
>> >> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
>> >> happening with that, though. So since this is a straight-forward
>> >> extension of the existing API, that doesn't carry a high implementati=
on
>> >> cost, I figured I'd just go ahead with this. Doesn't mean we can't ha=
ve
>> >> something similar in bpf_link as well, of course.
>> >>
>> >> > If we do please run this thru checkpatch, set .strict_start_type,
>> >>
>> >> Will do.
>> >>
>> >> > and make the expected fd unsigned. A negative expected fd makes no
>> >> > sense.
>> >>
>> >> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
>> >> flag. I guess you could argue that since we have that flag, setting a
>> >> negative expected_fd is not strictly needed. However, I thought it was
>> >> weird to have a "this is what I expect" API that did not support
>> >> expressing "I expect no program to be attached".
>> >
>> > For BPF syscall it seems the typical approach when optional FD is
>> > needed is to have extra flag (e.g., BPF_F_REPLACE for cgroups) and if
>> > it's not specified - enforce zero for that optional fd. That handles
>> > backwards compatibility cases well as well.
>>=20
>> Never did understand how that is supposed to square with 0 being a valid
>> fd number?
>
> In BPF_F_REPLACE case (since it was used as an example in this thread)
> it's all pretty clear:
>
> * if the flag is set, use fd from attr.replace_bpf_fd that can be anything
>   (incl. zero, since indeed it's valid fd) no problem with that;
> * if flag is not set, ignore replace_bpf_fd completely.
>
> It's descirbed in commit log in 7dd68b3279f1:
>
>     ...
>
>     BPF_F_REPLACE is introduced to make the user intent clear, since
>     replace_bpf_fd alone can't be used for this (its default value, 0, is=
 a
>     valid fd). BPF_F_REPLACE also makes it possible to extend the API in =
the
>     future (e.g. add BPF_F_BEFORE and BPF_F_AFTER if needed).
>
>     ...
>
> , i.e. flag presense is important, not the fd attribute being zero.
>
> Hope it clarifies.

Yup, it does, thanks! My confusion stemmed from having seen '!=3D 0' tests
for FDs in various places and wondered how that was supposed to work.
Didn't realise this was handled by way of an accompanying flag, that
does make sense :)

-Toke

