Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19F4194845
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgCZUGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:06:06 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46770 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbgCZUGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 16:06:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1DFC1600FE;
        Thu, 26 Mar 2020 20:06:05 +0000 (UTC)
Received: from us4-mdac16-37.ut7.mdlocal (unknown [10.7.66.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1ADD52009A;
        Thu, 26 Mar 2020 20:06:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 91DE01C0052;
        Thu, 26 Mar 2020 20:06:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 00A2CB4007D;
        Thu, 26 Mar 2020 20:06:02 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 26 Mar
 2020 20:05:54 +0000
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326194050.d5cjetvhzlhyiesb@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <042eca2c-b0c1-b20f-7636-eaa6156cd464@solarflare.com>
Date:   Thu, 26 Mar 2020 20:05:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200326194050.d5cjetvhzlhyiesb@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25314.003
X-TM-AS-Result: No-1.099900-8.000000-10
X-TMASE-MatchedRID: csPTYAMX1+HmLzc6AOD8DfHkpkyUphL9vMRNh9hLjFl0Tsch72XSbGRW
        ePusFQaM5s1otBC8xHkXC2iWp7Ivyh8a27oj+G8+WYCA1t8hlcs6En2bnefhoOdQPw86uR12gqI
        7yjbVyzTnEL+ol7gM64eieUG1ENTlLIgrJoe5B7cK4MBRf7I7ppzipwKe4Je16J/GTpdIYCjYiz
        h88Z/Oq+fOVcxjDhcwIC0OoeD/hCaJhnKtQtAvVtmzcdRxL+xwKrauXd3MZDWhz7yVilwuBcOPh
        BUFA6FXB3rIv92E3Y7jGsVMK6ZBAE83Gm2uZmpcoxgy4cSARIn532oiAhuuAxB6k0iRGuvKQeqd
        hJJ1Z9/FMeIvMXhsZwbEQIfFpkwHBtlgFh29qnpKzBwu5JpklnOUuoTXM7r4QwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.099900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25314.003
X-MDID: 1585253164-sv073K3buUa3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/03/2020 19:40, Alexei Starovoitov wrote:
> At this point I don't believe in your good intent.
> Your repeated attacks on BPF in every thread are out of control.
> I kept ignoring your insults for long time, but I cannot do this anymore.
> Please find other threads to contribute your opinions.
> They are not welcomed here.
Given that this clearly won't land in this cycle (and neither will bpf_link
 for XDP), can I suggest thateveryone involved steps back from the subject
 for a few days to let tempers cool?  It's getting to the point where people
 are burning bridges and saying things they might regret.
I know everyone is under a lot of stress right now.
