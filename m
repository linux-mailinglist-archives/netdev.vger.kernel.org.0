Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783C7109A65
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 09:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKZIsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 03:48:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36385 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbfKZIsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 03:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574758121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+vAl+TxBygEbMzVjqAzgD09l6qu3wJILYvBBhQlKaQ=;
        b=LTZsL8fUN+E/Yoq9pJGibas9sX3zORaaK2qrmfcrybcd4z54kOfO3tuB/p5nkxeX5EuUiL
        BFZshxfaT6hz746/Xg0g2tJ1816OXEj7j4H8JvSbaBJEv3RMeqPYXdkigZcCAayUV64bXo
        V/SKLTFjxyNiVg94TqWIBsJezJ8orqo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-D2o4_gGsNTm1h00YcDYALA-1; Tue, 26 Nov 2019 03:48:40 -0500
Received: by mail-lf1-f71.google.com with SMTP id w24so3737099lfa.11
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 00:48:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Z6W0LOas1d7f7fbz4EfEJlECwRizVLgD3BkR//u8jUc=;
        b=bs5c37Bfq4S6Z1bdtfBnbZ6a6r7NtFQBh6X4GqQ5zK+1TS378SLDQvvbRuySwHk/8c
         8WN57dSFd1AWUakyvNdchWghyqPgDvbN1ZtNmJcAiq9o/n+XS9GJRWGthAWzN9wwlnUK
         OA//bDS5u0Rop8KeRKE1bKnMQVqv9EB0r3BAfqHakCNF6QcicaQ7E1Utoh8zsI9nGHv1
         LjgmBSsqGHxYNgrKDaFeMcgANKpeRqv6/hJuigbKLZqP3A3Wl2Qv+g5Q78GCnkUDpxuJ
         hHVSZSlZPe0vSZAUYUbtLXitL3w2i+OvV4urVoSwkxCsMb5RvZyJF5K8nnry9wxv29Yl
         L7Cg==
X-Gm-Message-State: APjAAAW2zpKbVVOYd1UMTFSTzln4il9ngOajQh10k7jcoESrFVkTT5D3
        ikPfZYHHsKgnehk7Fw+YMDp2bmjj1AJutkYbPY0StOlIpA0Z++Bw2QsaVc/+LtEKDjZKqhj1pdO
        Lu2d/6kpgt1r7zjD0
X-Received: by 2002:a2e:9b5a:: with SMTP id o26mr24785988ljj.174.1574758118720;
        Tue, 26 Nov 2019 00:48:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzGVPGyuHsocjkpaLBBMTgS6QJm2V9DwHzGCJCJkLMmaJrv7Nkr/dGjmyvWTm/tNdleIRPnw==
X-Received: by 2002:a2e:9b5a:: with SMTP id o26mr24785977ljj.174.1574758118563;
        Tue, 26 Nov 2019 00:48:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a9sm422802lfi.50.2019.11.26.00.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 00:48:37 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 288171818BF; Tue, 26 Nov 2019 09:48:37 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
In-Reply-To: <b64cb1b5-f9be-27ab-76e8-4fe84b947114@gmail.com>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com> <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com> <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com> <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com> <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com> <fb74534d-f5e8-7b9b-b8c0-b6d6e718a275@gmail.com> <3daeee00-317a-1f82-648e-80ec14cfed22@candelatech.com> <b64cb1b5-f9be-27ab-76e8-4fe84b947114@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 26 Nov 2019 09:48:37 +0100
Message-ID: <87lfs3yqe2.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: D2o4_gGsNTm1h00YcDYALA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 11/25/19 10:35 AM, Ben Greear wrote:
>>>> And surely 'ip' could output a better error than just 'permission
>>>> denied' for
>>>> this error case?=C2=A0 Or even something that would show up in dmesg t=
o give
>>>> a clue?
>>>
>>> That error comes from the bpf syscall:
>>>
>>> bpf(BPF_PROG_LOAD, {prog_type=3DBPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=3D6=
,
>>> insns=3D0x7ffc8e5d1e00, license=3D"GPL", log_level=3D1, log_size=3D2621=
44,
>>> log_buf=3D"", kern_version=3DKERNEL_VERSION(0, 0, 0), prog_flags=3D0,
>>> prog_name=3D"", prog_ifindex=3D0,
>>> expected_attach_type=3DBPF_CGROUP_INET_INGRESS, prog_btf_fd=3D0,
>>> func_info_rec_size=3D0, func_info=3DNULL, func_info_cnt=3D0,
>>> line_info_rec_size=3D0, line_info=3DNULL, line_info_cnt=3D0}, 112) =3D =
-1 EPERM
>>> (Operation not permitted)
>>=20
>> So, we can change iproute/lib/bpf.c to print a suggestion to increase
>> locked memory
>> if this returns EPERM?
>>=20
>
> looks like SYS_ADMIN and locked memory are the -EPERM failures.
>
> I do not see any API that returns user->locked_vm, only per-task
> locked_vm. Knowing that number would help a lot in understanding proper
> system settings.

Yes! Having a way to see the current amount of locked memory is sorely
needed. Absent this, the application basically has to do one of:

- Throw up its hands and tell the user to increase ulimit (not terribly
  user-friendly)
- Just set the limit to infinity (this is what iproute2 does; works, but
  defeats the whole purpose of having a limit in the first place)
- Keep retrying while gradually increasing the limit (inefficient, and
  annoying to have to implement everywhere)

-Toke

