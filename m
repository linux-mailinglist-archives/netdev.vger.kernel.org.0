Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEBB129629
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLWMyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:54:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49909 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726691AbfLWMyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577105650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5cCaDQq8qftgZrhzoIg1xkFR5ZFmPM72Ud6lVvdAOY=;
        b=c9aKX8cs8wS+OgF/Y18aix0kt95WOO1AhopB16Tf+B4bx8pMZt5AV1vm2UDB8CcUEhWTVz
        yMRR52/ND329ZkEf8YcS5Vn6l30hoTJrxfCSgbJT8nZM+SMd5NDNIpzUQVHQ71f5WyGdPs
        9V5+KRHI7yO0RIupqG9v3LyyEkrFtj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-0BB99bblPpGfRkNfeXmXVg-1; Mon, 23 Dec 2019 07:54:04 -0500
X-MC-Unique: 0BB99bblPpGfRkNfeXmXVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B406FDB20;
        Mon, 23 Dec 2019 12:54:02 +0000 (UTC)
Received: from [10.36.116.219] (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B36610840E0;
        Mon, 23 Dec 2019 12:54:01 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
Date:   Mon, 23 Dec 2019 13:53:59 +0100
Message-ID: <FE4A1C64-70CF-4831-922C-F3992C40E57B@redhat.com>
In-Reply-To: <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com>
References: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
 <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Dec 2019, at 0:02, Andrii Nakryiko wrote:

> On Thu, Dec 19, 2019 at 3:04 AM Eelco Chaudron <echaudro@redhat.com>=20
> wrote:
>>
>> Add a test that will attach a FENTRY and FEXIT program to the XDP=20
>> test
>> program. It will also verify data from the XDP context on FENTRY and
>> verifies the return code on exit.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   95=20
>> ++++++++++++++++++++
>>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++
>>  2 files changed, 139 insertions(+)
>>  create mode 100644=20
>> tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>>  create mode 100644=20
>> tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>>
>
> [...]

Thanks for the review, updated my kernel to the latest bfp-next, but now=20
I get the following build issue for the test suite:

    GEN-SKEL [test_progs] loop3.skel.h
    GEN-SKEL [test_progs] test_skeleton.skel.h
libbpf: failed to find BTF for extern 'CONFIG_BPF_SYSCALL': -2
Error: failed to open BPF object file: 0
make: *** [Makefile:333:=20
/data/linux_kernel/tools/testing/selftests/bpf/test_skeleton.skel.h]=20
Error 255
make: *** Deleting file=20
'/data/linux_kernel/tools/testing/selftests/bpf/test_skeleton.skel.h'

Verified, and I still have all the correct config and CLANG version.=20
Something else I need to update?
I have pahole v1.15 in my search path=E2=80=A6

>
>> +       /* Load XDP program to introspect */
>> +       err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd)=
;
>
> Please use BPF skeleton for this test. It will make it significantly
> shorter and clearer. See other fentry_fexit selftest for example.
>
>> +       if (CHECK_FAIL(err))
>> +               return;
>> +
>
> [...]
>
>> +
>> +static volatile __u64 test_result_fentry;
>
> no need for static volatile anymore, just use global var
>
>> +BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
>> +           struct xdp_buff *, xdp)
>> +{
>> +       test_result_fentry =3D xdp->rxq->dev->ifindex;
>> +       return 0;
>> +}
>> +
>> +static volatile __u64 test_result_fexit;
>
> same here
>
>> +BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
>> +           struct xdp_buff*, xdp, int, ret)
>> +{
>> +       test_result_fexit =3D ret;
>> +       return 0;
>> +}
>>

