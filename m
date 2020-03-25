Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3A5192EA3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgCYQtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:49:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35066 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727485AbgCYQtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585154941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSNffCegIAa0r5cwxDsmvZyHncBXBHagI0mZqVnMmls=;
        b=LatJOnRBpF0ytsnqVnBvt8DjbFoEqKIQEjfnxR+/Ljcd2JQwh064GN+sKaUklrz0ZAfVG6
        EE6rhnlvMBOryESf7D1X3XUV+1foJrcxDGN1L/BY+idXeUqcAY9ME+pysJyVhr+jAwlRVh
        rc0nmo4ZR6ELNKDl78g7Qb2Qxuk3Gfw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-xPneALFzMVmM7kZkicz0ow-1; Wed, 25 Mar 2020 12:49:00 -0400
X-MC-Unique: xPneALFzMVmM7kZkicz0ow-1
Received: by mail-lf1-f69.google.com with SMTP id p6so1065973lfc.14
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:48:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oSNffCegIAa0r5cwxDsmvZyHncBXBHagI0mZqVnMmls=;
        b=DCPoTPdAygWUvpyLbep/N32HuuVQB20E4b43gqT7JAuCQkXNN8aP35GLVFeodKHfht
         PL48CFqzWCc63lGoOUBEj449WY4YBBPYvJYCJajqxO3nDFPi6Q/pllWrjGvagtTpf/Gh
         +849E1WBJ7FT71LJiYrM5HDnBrxWU6qSgABV39aAm9nSx3duXjoFK+4RmA9/MMJE6mxM
         BH26bAKM25Bt6x5UujwcwP8ZLjeGDg6Gom0Uqr0lXkakrDgdqtfySFU14n2hFHj+SYmU
         EfqCQIp+RShK9MPIeBfYN0Levf2Dm0MLfDuTnTha1cfGPsfG+IL5Z6dVfyzeKB20a81s
         VUcg==
X-Gm-Message-State: ANhLgQ3g5BDXQRdG1vuRMEZVfqRm+BJg4c51HOmalprjnkH4RZ8I6ocn
        ve7Kv4JkZllu+8BrxyuBHjr8br2Wa5v64qbwoDn6vAo3r74oZ4sSmwv2m6kOYd0sXAFNa0kFf6f
        +PIoZUYoKSU049br/
X-Received: by 2002:ac2:41c9:: with SMTP id d9mr2906234lfi.41.1585154938728;
        Wed, 25 Mar 2020 09:48:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsw9b0sr2q8OZ8fR9fcBtts3cA716jYVHxjS+REE+/XtuYbJ/ogZHn3dF68ukjmqeWK/mAhVw==
X-Received: by 2002:ac2:41c9:: with SMTP id d9mr2906222lfi.41.1585154938537;
        Wed, 25 Mar 2020 09:48:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v22sm4389527ljc.79.2020.03.25.09.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:48:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 623F318158B; Wed, 25 Mar 2020 17:48:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200324184311.4cfb4911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk> <158507357313.6925.9859587430926258691.stgit@toke.dk> <CAEf4BzaXvTx5-bp8QygxScwEKjq8LYZqU4dgxo2C9USqHpGxKg@mail.gmail.com> <20200324184311.4cfb4911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 Mar 2020 17:48:57 +0100
Message-ID: <877dz8peh2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 24 Mar 2020 17:54:07 -0700 Andrii Nakryiko wrote:
>> On Tue, Mar 24, 2020 at 11:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >
>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
>> > While it is currently possible for userspace to specify that an existi=
ng
>> > XDP program should not be replaced when attaching to an interface, the=
re is
>> > no mechanism to safely replace a specific XDP program with another.
>> >
>> > This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which c=
an be
>> > set along with IFLA_XDP_FD. If set, the kernel will check that the pro=
gram
>> > currently loaded on the interface matches the expected one, and fail t=
he
>> > operation if it does not. This corresponds to a 'cmpxchg' memory opera=
tion.
>> > Setting the new attribute with a negative value means that no program =
is
>> > expected to be attached, which corresponds to setting the UPDATE_IF_NO=
EXIST
>> > flag.
>> >
>> > A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
>> > request checking of the EXPECTED_ID attribute. This is needed for user=
space
>> > to discover whether the kernel supports the new attribute.=20=20
>>=20
>> Doesn't it feel inconsistent in UAPI that FD is used to specify XDP
>> program to be attached, but ID is used to specify expected XDP
>> program? Especially that the same cgroup use case is using
>> (consistently) prog FDs. Or is it another case where XDP needs its own
>> special way?
>
> There was a comment during review of v1, I wish you spoke up then.
>
> The prog ID is what dump returns, so the consistency can go either way
> (note that this API predates object IDs). Since XDP uses IDs internally
> it's just simpler to take prog ID.
>
> But it's a detail, so if you feel strongly I don't really mind.

Using an FD instead of an ID does make this more extensible (such as
supporting bpf_link FDs in the future; see my other reply to Alexei). So
I'll respin this, and switch it back to EXPECTED_FD.

-Toke

