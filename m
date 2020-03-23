Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96FE718F39F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 12:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgCWLZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 07:25:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54792 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728144AbgCWLZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 07:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584962716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NkOzQ0Lm6JD+3vnDgmPOk+vF8klB5Wrutp7Pc3/EkJc=;
        b=fiIbX10ocVtaW8deQdlyKA/k+JB6vnKp2sahMyufBp5vNXmrHYUunV4k+8HdsrwHlKvUpr
        lupc88PFEN1Zg96mEKvkmZ4I3DWcAFxHLX1q87b4VGYTnQyvsIHaKliVLraj9LI6RZZtlm
        2pNc329ygMYP34AgAQZVPC4E2+kL3Wg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-m9-UbHz8OhGRO6r0z4u49Q-1; Mon, 23 Mar 2020 07:25:14 -0400
X-MC-Unique: m9-UbHz8OhGRO6r0z4u49Q-1
Received: by mail-wm1-f71.google.com with SMTP id g9so1822377wmh.1
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 04:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NkOzQ0Lm6JD+3vnDgmPOk+vF8klB5Wrutp7Pc3/EkJc=;
        b=QRLdgv4EkqNqEX3Wlc6s5kin2Am2gnWKJ0y/Od2ygGZpzFKKe/5bkS8NovHf8vPt+O
         xJ+UkUmdiAx/v/PU9/FRD7cFpqAGDTT3ZjFh5Vtk0hEbNL5A5rfBcYxl9iGf3/LV+v2d
         CFpERC4AcPl/l2E9jus9xmLAeEJPTmvtf3Z4hDhOfgshdfa8qK54G/DLmK1lI+/p0iec
         okY/NrB7ZviTnoCe/qxsrPodavu/4ZselT8Wg/F8miQpiXHemM3WKZ/kASUZd/dhodGF
         L15k8Pu2Aw3kE9Fkxt8kGUN5LUsTtMiPgtgRzDO5suiduRVdQ3YBKueIXY03D1DImw+Y
         zN/A==
X-Gm-Message-State: ANhLgQ3go1KFsYtqXd46P1RMKaOVNpSiWW/a2i51du65f4oeGghfaT7J
        ZfkZMdDZCyuo+l9id0hAssyn+iOpOZDtq45t/mhy+5PfkghlvL3+jhYL7IPXhMidGltp22psYsY
        hai06r306JvLtY6sM
X-Received: by 2002:a1c:b4c6:: with SMTP id d189mr26048310wmf.132.1584962713012;
        Mon, 23 Mar 2020 04:25:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu5ov3mONinCTT+0IBhzZe8O4MnJVIH80fczhlLpQ0vcBuvDocja2CduSTvLfSzGaC6WcNVRQ==
X-Received: by 2002:a1c:b4c6:: with SMTP id d189mr26048290wmf.132.1584962712771;
        Mon, 23 Mar 2020 04:25:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b202sm22990499wmd.15.2020.03.23.04.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 04:25:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9AB2B180371; Mon, 23 Mar 2020 12:25:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4BzYGZz7hdd-_x+uyE0OF8h_3vJxNjF-Qkd5QhOWpaB8bbQ@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <CAEf4BzYGZz7hdd-_x+uyE0OF8h_3vJxNjF-Qkd5QhOWpaB8bbQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Mar 2020 12:25:11 +0100
Message-ID: <87r1xj48ko.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Mar 20, 2020 at 1:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Jakub Kicinski <kuba@kernel.org> writes:
>>
>> > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> While it is currently possible for userspace to specify that an exist=
ing
>> >> XDP program should not be replaced when attaching to an interface, th=
ere is
>> >> no mechanism to safely replace a specific XDP program with another.
>> >>
>> >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which =
can be
>> >> set along with IFLA_XDP_FD. If set, the kernel will check that the pr=
ogram
>> >> currently loaded on the interface matches the expected one, and fail =
the
>> >> operation if it does not. This corresponds to a 'cmpxchg' memory oper=
ation.
>> >>
>> >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
>> >> request checking of the EXPECTED_FD attribute. This is needed for use=
rspace
>> >> to discover whether the kernel supports the new attribute.
>> >>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
>> > I didn't know we wanted to go ahead with this...
>>
>> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
>> happening with that, though. So since this is a straight-forward
>> extension of the existing API, that doesn't carry a high implementation
>> cost, I figured I'd just go ahead with this. Doesn't mean we can't have
>> something similar in bpf_link as well, of course.
>>
>> > If we do please run this thru checkpatch, set .strict_start_type,
>>
>> Will do.
>>
>> > and make the expected fd unsigned. A negative expected fd makes no
>> > sense.
>>
>> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
>> flag. I guess you could argue that since we have that flag, setting a
>> negative expected_fd is not strictly needed. However, I thought it was
>> weird to have a "this is what I expect" API that did not support
>> expressing "I expect no program to be attached".
>
> For BPF syscall it seems the typical approach when optional FD is
> needed is to have extra flag (e.g., BPF_F_REPLACE for cgroups) and if
> it's not specified - enforce zero for that optional fd. That handles
> backwards compatibility cases well as well.

Never did understand how that is supposed to square with 0 being a valid
fd number?

-Toke

