Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18AE120ED4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfLPQIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:08:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726133AbfLPQIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:08:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576512518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJFNFTYus131wY/x9jHRX7vgYg0Fp1HJyonMa/UF2qc=;
        b=OtK4Cx5pSPY+5enErVs6PpEfLLXl0p3zJ15QFYWUo9HP2sc7lcObLBMT8gC7mAULgDqbso
        xu87m/0kRGuO2MU+ney0nMRp7d/V1Y+BKV+O3Kmnl4qOGxfxClpMbo6Jl6bKMWfpYAgc8+
        5Oako/+uaSgzxnlkEMIhnlQbzRGpA10=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-6q3k0eKZOZGnmudYidbMOA-1; Mon, 16 Dec 2019 11:08:34 -0500
X-MC-Unique: 6q3k0eKZOZGnmudYidbMOA-1
Received: by mail-lj1-f200.google.com with SMTP id z17so2290793ljz.2
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:08:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WJFNFTYus131wY/x9jHRX7vgYg0Fp1HJyonMa/UF2qc=;
        b=HqzXOYv9RDGKuyQttWVuNWG4i+zE3I2E938HcbVLgjmRdzFSs0pxx5JpmyJZ5lQFkk
         kclgWk8b0quhZYE5W0Bwx/vO/T3UUiN9LM+oo5URU6ZsbtI+pT0LSLY44LPqMH5zWMmh
         +C8rqd0TDw1uWqSHdEYDeg9TfqtikExu3fm8XZ+c/3QvjtUfXbLy49bzoJyPeg+6l9so
         JalSzj3i2jGQeG2i1E2AQKxwZZgvJjjj5MjMMl0ffrpW94JNN/c9CW0OEBIVDvcHTg5t
         gl2ilthJPmWE6DFXlA8O5GSbI4iTB5f/SCKfpNEkMjZ3VtOLuXReEY2U/YQwNSmlBR3n
         Dl+Q==
X-Gm-Message-State: APjAAAWaCmVop/QVPzt1XhxhWjAumqp8vB7ObqSkozdsq9yN0BVKQFm3
        jnX6N8x+j3fHdTg/+0QlCGDNQoXv4EXBsKVoShbumX7uCbcF6SrzyyVUXjvgnM+wyYC+4maUBXf
        YervSYuKZIapd+kbC
X-Received: by 2002:ac2:4212:: with SMTP id y18mr17158265lfh.2.1576512510903;
        Mon, 16 Dec 2019 08:08:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6B3M33nH8IIoV5WUjlsvpxTy5Ng5N5Mpg7cNDSOfojhgbdGyLJ3wml64C/rrsAPMvKmCc/w==
X-Received: by 2002:ac2:4212:: with SMTP id y18mr17158244lfh.2.1576512510673;
        Mon, 16 Dec 2019 08:08:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g24sm4105982lfb.85.2019.12.16.08.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:08:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 496DA180960; Mon, 16 Dec 2019 17:08:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: Print hint about ulimit when getting permission denied error
In-Reply-To: <20191216155336.GA28925@linux.fritz.box>
References: <20191216124031.371482-1-toke@redhat.com> <20191216145230.103c1f46@carbon> <20191216155336.GA28925@linux.fritz.box>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 16 Dec 2019 17:08:29 +0100
Message-ID: <87y2vc8d8i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On Mon, Dec 16, 2019 at 02:52:30PM +0100, Jesper Dangaard Brouer wrote:
>> On Mon, 16 Dec 2019 13:40:31 +0100
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>>=20
>> > Probably the single most common error newcomers to XDP are stumped by =
is
>> > the 'permission denied' error they get when trying to load their progr=
am
>> > and 'ulimit -r' is set too low. For examples, see [0], [1].
>> >=20
>> > Since the error code is UAPI, we can't change that. Instead, this patch
>> > adds a few heuristics in libbpf and outputs an additional hint if they=
 are
>> > met: If an EPERM is returned on map create or program load, and geteui=
d()
>> > shows we are root, and the current RLIMIT_MEMLOCK is not infinity, we
>> > output a hint about raising 'ulimit -r' as an additional log line.
>> >=20
>> > [0] https://marc.info/?l=3Dxdp-newbies&m=3D157043612505624&w=3D2
>> > [1] https://github.com/xdp-project/xdp-tutorial/issues/86
>> >=20
>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>=20
>> This is the top #1 issue users hit again-and-again, too bad we cannot
>> change the return code as it is UAPI now.  Thanks for taking care of
>> this mitigation.
>
> It's an annoying error that comes up very often, agree, and tooling then
> sets it to a high value / inf anyway as next step if it has the rights
> to do so. Probably time to revisit the idea that if the user has the same
> rights as being able to set setrlimit() anyway, we should just not account
> for it ... incomplete hack:

It did always seem a bit odd to me that there was this limit that was
setable by the user it was supposed to limit (for XDP anyway). So I
would totally be in favour of fixing it in the kernel; but probably a
good idea to put the hint into libbpf anyway, for those with older
kernels...

-Toke

