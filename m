Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9062AD6C6
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgKJMrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:47:43 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.49]:52104 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgKJMrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 07:47:43 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8502960090;
        Tue, 10 Nov 2020 12:47:42 +0000 (UTC)
Received: from us4-mdac16-46.ut7.mdlocal (unknown [10.7.66.13])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 835728009E;
        Tue, 10 Nov 2020 12:47:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.91])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ED16580056;
        Tue, 10 Nov 2020 12:47:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4D99CBC0061;
        Tue, 10 Nov 2020 12:47:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 12:47:32 +0000
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
 <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <11c18a26-72af-2e0d-a411-3148cfbc91be@solarflare.com>
Date:   Tue, 10 Nov 2020 12:47:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25778.003
X-TM-AS-Result: No-7.626800-8.000000-10
X-TMASE-MatchedRID: 1GZI+iG+MtfmLzc6AOD8DfHkpkyUphL9mIYIWwCrtbDfUZT83lbkEBbC
        99SYja1g08KOouRPweXpA9zAtoTtQbwGAZ9mF4+tbMGKOuLn5FU2vbWaKPnQ20+86maMM3aSoqR
        TS3ju9kjL1YnN80IdgfrX3HUSpSJtbWU+hmLYQb30VCHd+VQiHsuCYrT3WeZNI0YrtQLsSUx/HZ
        ivtns2jCoEdDLq/Jx9DebCA+2uaihMi6dAAjypoo6MisxJraxHZAGtCJE23YjlhO+RZsN0Zgzha
        8w4PtmsDbQK46q0MoVIK8AsRmtEnbRnkHe8f3Wi1ilQ4KKAwrcfqkfNzTRFSkvEK4FMJdoqFxHJ
        /PgKcF7XbjtE3SWl31+24nCsUSFNjaPj0W1qn0Q7AFczfjr/7EBUz7fy5vxHDt1tO/HyQLI3c0D
        GoeWQNPu3cx2BXcvV7l6uq4rmU/w=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.626800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25778.003
X-MDID: 1605012462-t_ROz6fajzuV
X-PPE-DISP: 1605012462;t_ROz6fajzuV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11/2020 14:05, Jamal Hadi Salim wrote:
> On 2020-11-04 10:19 p.m., David Ahern wrote:
>
> [..]
>> Similarly, it is not realistic or user friendly to *require* general
>> Linux users to constantly chase latest versions of llvm, clang, dwarves,
>> bcc, bpftool, libbpf, (I am sure I am missing more)
>
> 2cents feedback from a dabbler in ebpf on user experience:
>
> What David described above *has held me back*.
If we're doing 2¢... I gave up on trying to keep ebpf_asmabreast
 of all the latest BPF and BTF features quite some time ago, since
 there was rarely any documentation and the specifications for BPF
 elves were basically "whatever latest clang does".
The bpf developers seem to have taken the position that since
 they're in control of clang, libbpf and the kernel, they can make
 their changes across all three and not bother with the specs that
 would allow other toolchains to interoperate.  As a result of
 which, that belief has now become true — while ebpf_asm will
 still work for what it always did (simple XDP programs), it is
 unlikely ever to gain CO-RE support so is no longer a live
 alternative to clang for BPF in general.
Of course the bpf developers are well within their rights to not
 care about that.  But I think it illustrates why having to
 interoperate with systems outside their control and mix-and-match
 versioning of various components provides external discipline that
 is sorely needed if the BPF ecosystem is to remain healthy.
That is why I am opposed to iproute2 'vendoring' libbpf.

-ed
