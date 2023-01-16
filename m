Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C266BFE2
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjAPNgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjAPNgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:36:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2FB1E1C3;
        Mon, 16 Jan 2023 05:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43D7160FB8;
        Mon, 16 Jan 2023 13:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78513C433D2;
        Mon, 16 Jan 2023 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673876157;
        bh=VGDHasLw5K/OcysDOXC+d/X98n+wpKKIJ36v49TyMnE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=W85pTBDdk1gqnpNirDMTKNhWQkLWGQf29BfgmNk1ToLV6m7kMwJCj/LEYojADGN4B
         yFAlTjHrwRM2gLCnoRRrYBxHciel39gv3i207ub2cr5ZiSacR1XduAJKE+qz8o7Q55
         Cn9I3En77pt/kkAXUvLEe/o4JIexLY4rzDI0pAHzkaIhcV7YIMvkLNotb44Bea60vA
         eW9Ej6L+gX5mJOQKKGQGFNfraGJB/+Fypp1SbyBTu3aS983ohKazvgOXgKfYTPFkse
         zxb38g9ITiWwgLEKiIacP+P1PJoQLQ7WD7S6zI/U7KjLHdEiOqykq3+dNiSzauzEuh
         MPoEzSPPCXbIg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 756B7900F2D; Mon, 16 Jan 2023 14:35:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
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
In-Reply-To: <CAEKGpzgzxabXqUKXz4A-dYx6B05vbDkGELadRDBnbCF_hLxMAQ@mail.gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
 <CAADnVQ+zP5bkjkSa97k+dK7=NabkdoLWQtZ1qRwRTUQgGdqhVA@mail.gmail.com>
 <CAEKGpzgzxabXqUKXz4A-dYx6B05vbDkGELadRDBnbCF_hLxMAQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 16 Jan 2023 14:35:54 +0100
Message-ID: <87ilh6eh51.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Daniel T. Lee" <danieltimlee@gmail.com> writes:

> On Mon, Jan 16, 2023 at 6:38 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Sat, Jan 14, 2023 at 11:16 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>> >
>> > Currently, there are many programs under samples/bpf to test the
>> > various functionality of BPF that have been developed for a long time.
>> > However, the kernel (BPF) has changed a lot compared to the 2016 when
>> > some of these test programs were first introduced.
>> >
>> > Therefore, some of these programs use the deprecated function of BPF,
>> > and some programs no longer work normally due to changes in the API.
>> >
>> > To list some of the kernel changes that this patch set is focusing on,
>> > - legacy BPF map declaration syntax support had been dropped [1]
>> > - bpf_trace_printk() always append newline at the end [2]
>> > - deprecated styled BPF section header (bpf_load style) [3]
>> > - urandom_read tracepoint is removed (used for testing overhead) [4]
>> > - ping sends packet with SOCK_DGRAM instead of SOCK_RAW [5]*
>> > - use "vmlinux.h" instead of including individual headers
>> >
>> > In addition to this, this patchset tries to modernize the existing
>> > testing scripts a bit. And for network-related testing programs,
>> > a separate header file was created and applied. (To use the
>> > Endianness conversion function from xdp_sample and bunch of constants)
>>
>> Nice set of cleanups. Applied.
>> As a follow up could you convert some of them to proper selftests/bpf ?
>> Unfortunately samples/bpf will keep bit rotting despite your herculean efforts.
>
> I really appreciate for your compliment!
> I'll try to convert the existing sample to selftest in the next patch.

Maybe this is a good time to mention that we recently ported some of the
XDP utilities from samples/bpf to xdp-tools, in the form of the
'xdp-bench' utility:
https://github.com/xdp-project/xdp-tools/tree/master/xdp-bench

It's basically a combination of all the xdp_redirect* samples, but also
includes the functionality from the xdp_rxq_info sample program (i.e.,
the ability to monitor RXQs and use other return codes).

I'm planning to submit a patch to remove those utilities from
samples/bpf after we tag the next release of xdp-tools (have one or two
outstanding issues to clear before we do that), but wanted to give you a
head's up so you don't spend any time on those particular utilities when
you're cleaning up samples :)

-Toke
