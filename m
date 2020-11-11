Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34F32AEFA5
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgKKLcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:32:13 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54214 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgKKLcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:32:02 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5584A20065;
        Wed, 11 Nov 2020 11:32:00 +0000 (UTC)
Received: from us4-mdac16-18.at1.mdlocal (unknown [10.110.49.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 539006009B;
        Wed, 11 Nov 2020 11:32:00 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.105])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E9F48220070;
        Wed, 11 Nov 2020 11:31:59 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8868A9C005B;
        Wed, 11 Nov 2020 11:31:59 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Nov
 2020 11:31:50 +0000
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <haliu@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
References: <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
 <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
 <11c18a26-72af-2e0d-a411-3148cfbc91be@solarflare.com>
 <20201111005348.v3dtugzstf6ofnqi@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <fcd907f2-3f1d-473b-1d07-2803606005c9@solarflare.com>
Date:   Wed, 11 Nov 2020 11:31:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201111005348.v3dtugzstf6ofnqi@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25780.000
X-TM-AS-Result: No-4.757500-8.000000-10
X-TMASE-MatchedRID: 6otD/cJAac3mLzc6AOD8DfHkpkyUphL9WDtrCb/B2hAZSz1vvG+0mlOq
        /cczpG/Oo1u23BvqbUZjEidB1gLMtzQMujIArt56zooWLKUUzyUzrYUXu/POGEvxNNr2jHqdGNt
        H9cKwddboE4yIMM6cXxUH2eFp9rioGpeG8FcDvBvBjbyj5wYDmn5Lmbb/xUuab/1uHmr1EmooqL
        1chlV2xdWPOUApGUbObYTvhIisEc9cZf+58nGW2nTzPL3sqyAmDvc/j9oMIgWA6UrbM3j3qY5/d
        k+4oD9rsY13QE5gfKHRRjITm+/ALP3R19qvLSMoN19PjPJahlKL/MoUdwG/+y6fyVZ0s4RNo8WM
        kQWv6iVJeFvFlVDkf46HM5rqDwqtytx0x5OBfpnm1SItoDVN9e1TiiCZeh5LRN8ApEONP6vK91f
        wfzrifP9RNwWD7vq3OSp5klpbHDBDM/rPD19uBdo9oF5O8Kif4vn0zMfSmjYrbLOj1GuP3A+hgL
        flG6KEo9QjuF9BKnnfMd6s6DDccQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.757500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25780.000
X-MDID: 1605094320-NtySaK4iwvrJ
X-PPE-DISP: 1605094320;NtySaK4iwvrJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2020 00:53, Alexei Starovoitov wrote:
> On Tue, Nov 10, 2020 at 12:47:28PM +0000, Edward Cree wrote:
>> But I think it illustrates why having to
>>  interoperate with systems outside their control and mix-and-match
>>  versioning of various components provides external discipline that
>>  is sorely needed if the BPF ecosystem is to remain healthy.
> 
> I think thriving public bpf projects, startups and established companies
> that are obviously outside of control of few people that argue here
> would disagree with your assessment.

Correct me if I'm wrong, but aren't those bpf projects and companies
 _things that are written in BPF_, rather than alternative toolchain
 components for compiling, loading and otherwise wrangling BPF once
 it's been written?
It is the latter that I am saying is needed in order to keep BPF
 infrastructure development "honest", rather than treating the clang
 frontend as The API and all layers below it as undocumented internal
 implementation details.
In a healthy ecosystem, it should be possible to use a compiler,
 assembler, linker and loader developed separately by four projects
 unrelated to each other and to the kernel and runtime.  Thanks to
 well-specified ABIs and file formats, in the C ecosystem this is
 actually possible, despite the existence of some projects that
 bundle together multiple components.
In the BPF ecosystem, instead, it seems like the only toolchain
 anyone cares to support is latest clang + latest libbpf, and if you
 try to replace any component of the toolchain with something else,
 the spec you have to program against is "Go and read the LLVM
 source code, figure out what it does, and copy that".
That is not sustainable in the long term.

-ed
