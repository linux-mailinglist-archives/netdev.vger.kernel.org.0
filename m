Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5429E66D1E7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbjAPWsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbjAPWsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:48:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D59244BC;
        Mon, 16 Jan 2023 14:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32CB5B810FA;
        Mon, 16 Jan 2023 22:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C480C433D2;
        Mon, 16 Jan 2023 22:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673909305;
        bh=+bDd6/11WLq9Gs/S0t1fODiOuR7pY8zbaqW3ec4v6N4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=A2/tiou8IupPh/TFtL9XiEdgqP7dyrhEcnqKZlyaVfeZ+nNJWIBfKOCFhVbo6SR+C
         W1k9N1UpGKQ3qLLeOKyabzQSfGiTMGvILzkHH3cXKN2yAqA38qZlAUYl5xGUNCL7Hd
         oWZL96n9ofEL5adPIWXpP6SUbS5WazF8bFX4uYb8GdYk8OjIVX7elYFtFPLJ/a+Qe3
         /HYf+dUfyDyPqhpEl6gdNji7eiOrXdN9fbZ11r8c7Bl2Icp/MalbQgK8wD4SG+XO4j
         dSEp5ilp9NSdHAICeXjvd1Hzg1xd8PNobDeyAPw7fEcKZKiRzvslXLxmOQed3lvR5Z
         q+CaqzZbIeflA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 96BF3900FC1; Mon, 16 Jan 2023 23:48:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [bpf-next 00/10] samples/bpf: modernize BPF functionality test
 programs
In-Reply-To: <ccc12280-4e00-ab23-d948-05c7db8b8da1@iogearbox.net>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
 <CAADnVQ+zP5bkjkSa97k+dK7=NabkdoLWQtZ1qRwRTUQgGdqhVA@mail.gmail.com>
 <CAEKGpzgzxabXqUKXz4A-dYx6B05vbDkGELadRDBnbCF_hLxMAQ@mail.gmail.com>
 <87ilh6eh51.fsf@toke.dk>
 <ccc12280-4e00-ab23-d948-05c7db8b8da1@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 16 Jan 2023 23:48:22 +0100
Message-ID: <87a62idrk9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 1/16/23 2:35 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> "Daniel T. Lee" <danieltimlee@gmail.com> writes:
>>> On Mon, Jan 16, 2023 at 6:38 AM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>> On Sat, Jan 14, 2023 at 11:16 PM Daniel T. Lee <danieltimlee@gmail.com=
> wrote:
>>>>>
>>>>> Currently, there are many programs under samples/bpf to test the
>>>>> various functionality of BPF that have been developed for a long time.
>>>>> However, the kernel (BPF) has changed a lot compared to the 2016 when
>>>>> some of these test programs were first introduced.
>>>>>
>>>>> Therefore, some of these programs use the deprecated function of BPF,
>>>>> and some programs no longer work normally due to changes in the API.
>>>>>
>>>>> To list some of the kernel changes that this patch set is focusing on,
>>>>> - legacy BPF map declaration syntax support had been dropped [1]
>>>>> - bpf_trace_printk() always append newline at the end [2]
>>>>> - deprecated styled BPF section header (bpf_load style) [3]
>>>>> - urandom_read tracepoint is removed (used for testing overhead) [4]
>>>>> - ping sends packet with SOCK_DGRAM instead of SOCK_RAW [5]*
>>>>> - use "vmlinux.h" instead of including individual headers
>>>>>
>>>>> In addition to this, this patchset tries to modernize the existing
>>>>> testing scripts a bit. And for network-related testing programs,
>>>>> a separate header file was created and applied. (To use the
>>>>> Endianness conversion function from xdp_sample and bunch of constants)
>>>>
>>>> Nice set of cleanups. Applied.
>>>> As a follow up could you convert some of them to proper selftests/bpf ?
>>>> Unfortunately samples/bpf will keep bit rotting despite your herculean=
 efforts.
>>>
>>> I really appreciate for your compliment!
>>> I'll try to convert the existing sample to selftest in the next patch.
>
> This would be awesome, thanks a lot Daniel!
>
>> Maybe this is a good time to mention that we recently ported some of the
>> XDP utilities from samples/bpf to xdp-tools, in the form of the
>> 'xdp-bench' utility:
>> https://github.com/xdp-project/xdp-tools/tree/master/xdp-bench
>>=20
>> It's basically a combination of all the xdp_redirect* samples, but also
>> includes the functionality from the xdp_rxq_info sample program (i.e.,
>> the ability to monitor RXQs and use other return codes).
>>=20
>> I'm planning to submit a patch to remove those utilities from
>> samples/bpf after we tag the next release of xdp-tools (have one or two
>> outstanding issues to clear before we do that), but wanted to give you a
>> head's up so you don't spend any time on those particular utilities when
>> you're cleaning up samples :)
>
> Nice! Once we're through with most relevant ones from samples/bpf, it wou=
ld
> be great to only have a readme in that dir (and that's really all) with p=
ointers
> for developers on how to get started.. including BPF selftests, xdp tools=
, links
> to ebpf.io/applications and ebpf.io/infrastructure, etc where more resour=
ces
> can be found, essentially a small getting started doc for BPF devs.

Yeah, good point! Will keep that in mind :)

-Toke
