Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5DE2BC53A
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 12:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgKVLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 06:01:50 -0500
Received: from correo.us.es ([193.147.175.20]:51592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727424AbgKVLBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 06:01:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B5CA508CE4
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 12:01:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DC40DA8FB
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 12:01:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 26794DA903; Sun, 22 Nov 2020 12:01:48 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5A19DA72F;
        Sun, 22 Nov 2020 12:01:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Nov 2020 12:01:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A3D6B4265A5A;
        Sun, 22 Nov 2020 12:01:45 +0100 (CET)
Date:   Sun, 22 Nov 2020 12:01:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20201122110145.GB26512@salvia>
References: <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
 <20201011082657.GB15225@wunner.de>
 <20201121185922.GA23266@salvia>
 <CAADnVQK8qHwdZrqMzQ+4Q9Cg589xLX5zTve92ZKN_zftJg_WHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQK8qHwdZrqMzQ+4Q9Cg589xLX5zTve92ZKN_zftJg_WHw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Sat, Nov 21, 2020 at 07:24:24PM -0800, Alexei Starovoitov wrote:
> On Sat, Nov 21, 2020 at 10:59 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > We're lately discussing more and more usecases in the NFWS meetings
> > where the egress can get really useful.
> 
> We also discussed in the meeting XYZ that this hook is completely pointless.
> Got the hint?

No need to use irony.

OK, so at this point it's basically a bunch of BPF core developers
that is pushing back on these egress support series.

The BPF project is moving on and making progress. Why don't you just
keep convincing more users to adopt your solution? You can just
provide incentives for them to adopt your software, make more
benchmarks, more documentation and so on. That's all perfectly fine
and you are making a great job on that field.

But why you do not just let us move ahead?

If you, the BPF team and your users, do not want to use Netfilter,
that's perfectly fine. Why don't you let users choose what subsystem
of choice that they like for packet filtering?

I already made my own mistakes in the past when I pushed back for BPF
work, that was wrong. It's time to make peace and take this to an end.

Thank you.
