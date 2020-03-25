Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5EC192E9C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCYQsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:48:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47351 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgCYQsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585154892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FKa2lX1L38RL5H2RKwW0wIx/XRCDkdOLD3HB0+C1FNo=;
        b=BlWxQw2tlxqs+mA2aB7XJbLGrIswNVjAHeU2Xiy5snXw0Fdd2V/KmU3eMcgp53lVacFyNd
        ZjfO9fJjtCtkch1KpwfsL9l43h5bAKXxtwbxTUPlEUtpQbPdEDJe/96QKIG2cWH3eW1bnH
        XxQaigPgOkSf/7FMzlLLK4t9msWkqd0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-6uI5ZsZ0MzCpk0fuO1SzUw-1; Wed, 25 Mar 2020 12:48:09 -0400
X-MC-Unique: 6uI5ZsZ0MzCpk0fuO1SzUw-1
Received: by mail-lj1-f198.google.com with SMTP id u25so333611ljo.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FKa2lX1L38RL5H2RKwW0wIx/XRCDkdOLD3HB0+C1FNo=;
        b=dzDnwwIn0vyh60HO/rzFFnxikRfV/jUk4GX5t2NiT6z0ctlyekoQ02M2W6SSKWGSlA
         +21cgUOWsxk6MV5t2+m3OAlDs2LDa/ycRXgw46WUpoHo/co5MQblHjsdHs1x35UfhJv6
         5P1x5xp6F+q6LjMZgA2Fk/CCgP4cQJ0q9SLCGnBIo9SjCVIl0XbN92D2ouK7/iPhGmag
         aD+KovIf3woiBDd/HAMVONrZ3WQNpCjBCwdD0/F/ePjgt9E4skFftOsy4Cq6NGVc1l+R
         Bzd2etOUwgqL/otucts/69/i/yyssEChlB9rmJ6ouxsmgnmd5aC1tNbzCPtpE08K5Q3F
         LnvQ==
X-Gm-Message-State: ANhLgQ2SjcLQewbwL4d9I0LS+DyKlbePihg6XWnzCTg38P2R2A3JwcVE
        VEARsMzFCljgpJ221PJOOXGTXP+MeHqUkw8JbUcb18Q9YHgfsQS5JMzRUPwtd2xFFV+YDgdHpLC
        4OTi6MhbFDW5hu7EG
X-Received: by 2002:ac2:5608:: with SMTP id v8mr2866155lfd.189.1585154887182;
        Wed, 25 Mar 2020 09:48:07 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsUdNx8CBGnc45Um+S+H/GMPmDdUz+N+CNcpuLwbfbFJUot0EC4BziGeUZOBojNkL9LSPP+bQ==
X-Received: by 2002:ac2:5608:: with SMTP id v8mr2866134lfd.189.1585154886848;
        Wed, 25 Mar 2020 09:48:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 18sm12093403ljv.30.2020.03.25.09.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:48:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5B05B18158B; Wed, 25 Mar 2020 17:48:04 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200325014622.ilhqpfdwgb65jpnq@ast-mbp>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk> <158507357313.6925.9859587430926258691.stgit@toke.dk> <20200325014622.ilhqpfdwgb65jpnq@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 Mar 2020 17:48:04 +0100
Message-ID: <87a744peij.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Mar 24, 2020 at 07:12:53PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> While it is currently possible for userspace to specify that an existing
>> XDP program should not be replaced when attaching to an interface, there=
 is
>> no mechanism to safely replace a specific XDP program with another.
>>=20
>> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which can=
 be
>> set along with IFLA_XDP_FD. If set, the kernel will check that the progr=
am
>> currently loaded on the interface matches the expected one, and fail the
>> operation if it does not. This corresponds to a 'cmpxchg' memory operati=
on.
>> Setting the new attribute with a negative value means that no program is
>> expected to be attached, which corresponds to setting the UPDATE_IF_NOEX=
IST
>> flag.
>>=20
>> A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
>> request checking of the EXPECTED_ID attribute. This is needed for usersp=
ace
>> to discover whether the kernel supports the new attribute.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Over the years of defining apis to attach bpf progs to different kernel
> components the key mistake we made is that we tried to use corresponding
> subsystem way of doing thing and it failed every time. What made the prob=
lem
> worse that this failure we only learned after many years. Attaching xdp v=
ia
> netlink felt great back then. Attaching clsbpf via tc felt awesome too. D=
oing
> cgroup-bpf via bpf syscall with three different attaching ways also felt =
great.
> All of these attaching things turned out to be broken because all of them
> failed to provide the concept of ownership of the attachment. Which cause=
d 10k
> clsbpf progs on one netdev, 64 cgroup-bpf progs in one cgroup, nuked xdp =
progs.
> Hence we have to add the ownership model first. Doing mini extensions to
> existing apis is not addressing the giant issue of existing apis.
>
> The idea of this patch is to do atomic replacement of xdp prog. It's a go=
od
> idea and useful feature, but I don't want to extend existing broken apis =
to do
> add this feature. atomic replacement has to come with thought through own=
er
> model first.

Setting aside the question of which is the best abstraction to represent
an attachment, it seems to me that the actual behavioural problem (XDP
programs being overridden by mistake) would be solvable by this patch,
assuming well-behaved userspace applications.

If you do need kernel support, we could extend the netlink API to accept
bpf_link FDs in addition to prog FDs. Then applications that fit the
bpf_link model could use netlink to setup the initial link (and any
other device configuration they need to do anyway), and any subsequent
replacements would be done by LINK_UPDATE bpf() operations. The lack of
CAP_NET_ADMIN could even restrict applications from removing the
bpf_link attachment from the netdev, without preventing them from
swapping out the bpf_prog attached to it.

This would also keep netlink solely in charge of netdev configuration,
and prevent any issues with a netdev being locked due to a bpf_link
attachment.

-Toke

