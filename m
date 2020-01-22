Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A781452D6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgAVKpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:45:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727453AbgAVKpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579689909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+qR5+2XnS/Jvtx+SCAflUuxRNQSv388iVEOgrKyFko=;
        b=SEpzPEQ3BkeRmKI+Z3vCsK5Pb5QdDy6qoezuH6DWpWZSRmtIqekqR5EqKE5/cLzwfrDhOr
        PoE0t26K9LEpizOjdR+9QdTYQsHd/FoEpY0TdBwVF3hvO8iZToLWZBji6jknp1cj5QOwDM
        80PdAf6Ol2QGFS6FhN2ZNHd8ivUFJA4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-ppr4N5DZPiSROf-AX0pwFA-1; Wed, 22 Jan 2020 05:45:07 -0500
X-MC-Unique: ppr4N5DZPiSROf-AX0pwFA-1
Received: by mail-lf1-f69.google.com with SMTP id b22so2012333lfa.16
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 02:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7+qR5+2XnS/Jvtx+SCAflUuxRNQSv388iVEOgrKyFko=;
        b=ndv3aXcT+wUk5cGvPVQeObtJI8awCy663x2QRP47gMDP72kflJTKfvghXPiJGuIQF8
         tADt7mIt/0/m3vEYMmIEZf7QHYVeiofgapjp+q00jIP4xdJYcOesHF5uC8p6cOsusS4F
         fqHonMQ3auL8Fd2fLKS8IrbsLvKn4Dl17KqVDnq4QjC5ToFP8zWi281vXG5XMWJ8KZB9
         yEdpJdRaH6eZ2ITbKTN4YvWKNS+5980fvxXu7niIVROxIe1xJ07M7jiPbHoEsGdu7N3D
         dq04yHZEH596NNBEGeRz4OONfYF2rnd0J8BOsfdc1wMTbjeLtZ+pdQ2jf2f0MxCjsUmn
         OfMA==
X-Gm-Message-State: APjAAAUak5Cxlx8frup3+RZ5TN8mn2m1SNAq8df9bqigH2jl7a8lr2PE
        1bG2xcxPk2EEAKCPlyV8xBAJ6SVVu8t2PJgh5xdadlNvrp2Sv/9gBWUncg+R6FhOLB2sPry1sbh
        x+PAdQaECSXpUif6h
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr19902709lji.274.1579689905176;
        Wed, 22 Jan 2020 02:45:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzoqSkStv/Ank9kut/W15i+iPFFZac/FxhESW/HCEnKQJ2MEbh0ocOFsM0TBUJACkC692mEVg==
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr19902684lji.274.1579689904736;
        Wed, 22 Jan 2020 02:45:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d24sm19936365lja.82.2020.01.22.02.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 498AE180075; Wed, 22 Jan 2020 11:45:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Program extensions or dynamic re-linking
In-Reply-To: <20200121165958.zfpvsz7kdcx2dotr@ast-mbp.dhcp.thefacebook.com>
References: <20200121005348.2769920-1-ast@kernel.org> <87k15kbz2c.fsf@toke.dk> <20200121165958.zfpvsz7kdcx2dotr@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Jan 2020 11:45:03 +0100
Message-ID: <87blqvbwi8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Jan 21, 2020 at 04:37:31PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Alexei Starovoitov <ast@kernel.org> writes:
>>=20
>> > The last few month BPF community has been discussing an approach to ca=
ll
>> > chaining, since exiting bpt_tail_call() mechanism used in production X=
DP
>> > programs has plenty of downsides. The outcome of these discussion was a
>> > conclusion to implement dynamic re-linking of BPF programs. Where root=
let XDP
>> > program attached to a netdevice can programmatically define a policy of
>> > execution of other XDP programs. Such rootlet would be compiled as nor=
mal XDP
>> > program and provide a number of placeholder global functions which lat=
er can be
>> > replaced with future XDP programs. BPF trampoline, function by function
>> > verification were building blocks towards that goal. The patch 1 is a =
final
>> > building block. It introduces dynamic program extensions. A number of
>> > improvements like more flexible function by function verification and =
better
>> > libbpf api will be implemented in future patches.
>>=20
>> This is great, thank you! I'll go play around with it; couldn't spot
>> anything obvious from eye-balling the code, except that yeah, it does
>> need a more flexible libbpf api :)
>>=20
>> One thing that's not obvious to me: How can userspace tell which
>> programs replace which functions after they are loaded? Is this put into
>> prog_tags in struct bpf_prog_info, or?
>
> good point. Would be good to extend bpf_prog_info. Since prog-to-prog
> connection is unidirectional the bpf_prog_info of extension prog will be =
able
> to say which original program it's replacing.

Yeah, that'll do. I can live with having to enumerate all programs and
backtrack to the attached XDP program to figure out its component parts.

> bpftool prog show will be able to print all this data. I think
> fenry/fexit progs would need the same bpf_prog_info extension.
> attach_prog_id + attach_btf_id would be enough.

Yes, please. I actually assumed this was already there for fentry/fexit,
which is why I was puzzled I couldn't find where this series hooked into
that. I'll just wait for such an extension to show up, then :)

> In the mean time I can try to hack drgn script to do the same.

That would be great, thanks!

-Toke

