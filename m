Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D58F95B6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfKLQco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:32:44 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39306 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbfKLQco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:32:44 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5E1BC80083;
        Tue, 12 Nov 2019 16:32:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 Nov
 2019 16:32:30 +0000
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
 <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk>
 <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c1ef53cc-2877-2ae1-b003-7e30596d5df1@solarflare.com>
Date:   Tue, 12 Nov 2019 16:32:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25038.003
X-TM-AS-Result: No-0.670100-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9B4Id7CiQcz8QjsHZD9zVXvmB
        zpqQiI1Nu/qspqV62H89vUc08rywOgML7je50JKE4qCB2ZT6yAxSL7MLcz37wU0SXxd4W9zIXEL
        8JW7sdCNDE3gwgXa3fL/Cve01/XYWxGSfUEm6OV3OeIV+MVeoznIFLjP03wGMuU98jGdvYMtU7b
        LqnQz/DB4ymOiBXHkaVjENcDpuoDMM8jMXjBF+sIMbH85DUZXyYxU/PH+vZxv6C0ePs7A07Y6HM
        5rqDwqtcB/GDRtDsouO3TWMVpAYDE+NDoYyXXaI5W7wnxiRGDEeIIC+gtyz9HJEyDpPULR7Lp4R
        jrKxjAFdnZkuyPr7rlO7JFF+mf7u4vn0zMfSmjYrbLOj1GuP3A+hgLflG6KEo9QjuF9BKnm9EgI
        V0R0692cjFnImzvyS
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.670100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25038.003
X-MDID: 1573576360-k4m46YBXRlEx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2019 02:51, Alexei Starovoitov wrote:
> There
> could be a 'root' bpf program (let's call it rootlet.o) that looks like:
This looks a lot like what I had in mind...
> We can introduce dynamic linking. The second part of 'BPF trampoline' patches
> allows tracing programs to attach to other BPF programs. The idea of dynamic
> linking is to replace a program or subprogram instead of attaching to it.
... as does this, particularly the "partial verification" / verify a subprog
 as a separate unit with its own contract.
> The rootlet.o calls into firewall1.o directly. So no retpoline to worry about
> and firewall1.o can use bpf_tail_call() if it wants so. That tail_call will
> still return back to rootlet.o
Yep, that's a really nice gain that comes out of partial verification.

+1 to this whole proposal.

-Ed
