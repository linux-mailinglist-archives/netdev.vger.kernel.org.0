Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F210555382
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376717AbiFVSsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376899AbiFVSs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 14:48:29 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E562FE6C;
        Wed, 22 Jun 2022 11:48:27 -0700 (PDT)
Received: from SPMA-04.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 9FD91974E0F_2B363F9B;
        Wed, 22 Jun 2022 18:48:25 +0000 (GMT)
Received: from mail.tu-berlin.de (postcard.tu-berlin.de [141.23.12.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by SPMA-04.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id E4518977B76_2B363F8F;
        Wed, 22 Jun 2022 18:48:24 +0000 (GMT)
Received: from [192.168.178.14] (77.191.241.175) by ex-06.svc.tu-berlin.de
 (10.150.18.10) with Microsoft SMTP Server id 15.2.986.22; Wed, 22 Jun 2022
 20:48:24 +0200
Message-ID: <6b91a269d8201435c07df44dc267c98dbd552c75.camel@mailbox.tu-berlin.de>
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: Test a BPF CC writing
 sk_pacing_*
From:   =?ISO-8859-1?Q?J=F6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
To:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
Date:   Wed, 22 Jun 2022 20:48:22 +0200
In-Reply-To: <20220620180808.4a3saky4pd7ge7zn@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
         <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
         <20220617210425.xpeyxd4ahnudxnxb@kafai-mbp>
         <629bc069dd807d7ac646f836e9dca28bbc1108e2.camel@mailbox.tu-berlin.de>
         <e4390345-df3b-5ece-3464-83ff8c1992ce@fb.com>
         <20220620180808.4a3saky4pd7ge7zn@kafai-mbp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=message-id:subject:from:to:cc:date:in-reply-to:references:content-type:mime-version:content-transfer-encoding; s=dkim-tub; bh=gB7WqdEijdKTTGN3M9ydRI43QPzSrKqSQCWtnUkM0Y8=; b=MYsff7R0Yzj7SCNwmLWLYwuLRy3zYQShxEEhxFnvuhUhXlk+RwhTNj5oqf6U6IxS1hWYfWzbWeLoxj8m37LnJaXlv29exPUTjd37XClLie/6eNtEh6H1VdBxYbx22mEeQIhgb66MUVqeEtlVLjohVRQgS4o0ABQRaJDU1DdELDw=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-20 at 11:08 -0700, Martin KaFai Lau wrote:
> On Mon, Jun 20, 2022 at 09:06:13AM -0700, Yonghong Song wrote:
> [ ... ]
> > > > > a/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > > > > b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > > > > new file mode 100644
> > > > > index 000000000000..43447704cf0e
> > > > > --- /dev/null
> > > > > +++
> > > > > b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > > > > @@ -0,0 +1,60 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > +
> > > > > +#include "vmlinux.h"
> > > > > +
> > > > > +#include <bpf/bpf_helpers.h>
> > > > > +#include <bpf/bpf_tracing.h>
> > > > > +
> > > > > +char _license[] SEC("license") = "GPL";
> > > > > +
> > > > > +#define USEC_PER_SEC 1000000UL
> > > > > +
> > > > > +#define min(a, b) ((a) < (b) ? (a) : (b))
> > > > > +
> > > > > +static inline struct tcp_sock *tcp_sk(const struct sock *sk)
> > > > > +{
> > > > This helper is already available in bpf_tcp_helpers.h.
> > > > Is there a reason not to use that one and redefine
> > > > it in both patch 3 and 4?  The mss_cache and srtt_us can be
> > > > added
> > > > to bpf_tcp_helpers.h.  It will need another effort to move
> > > > all selftest's bpf-cc to vmlinux.h.
> > > I fully agree it’s not elegant to redefine tcp_sk() twice more.
> > > 
> > > It was between either using bpf_tcp_helpers.h and adding and
> > > maintaining additional struct members there. Or using the (as I
> > > understood it) more “modern” approach with vmlinux.h and
> > > redefining the
> > > trivial tcp_sk(). I chose the later. Didn’t see a reason not to
> > > slowly
> > > introduce vmlinux.h into the CA tests.
> > > 
> > > I had the same dilemma for the algorithm I’m implementing: Reuse
> > > bpf_tcp_helpers.h from the kernel tree and extend it. Or use
> > > vmlinux.h
> > > and copy only some of the (mostly trivial) helper functions. Also
> > > chose
> > > the later here.
> > > 
> > > While doing the above, I also considered extracting the type
> > > declarations from bpf_tcp_helpers.h into an, e.g.,
> > > bpf_tcp_types_helper.h, keeping only the functions in
> > > bpf_tcp_helpers.h. bpf_tcp_helpers.h could have been a base
> > > helper for
> > > any BPF CA implementation then and used with either vmlinux.h or
> > > the
> > > “old-school” includes. Similar to the way bpf_helpers.h is used.
> > > But at
> > > that point, a bpf_tcp_types_helper.h could have probably just
> > > been
> > > dropped for good and in favor of vmlinux.h. So I didn’t continue
> > > with
> > > that.
> I think a trimmed down bpf_tcp_helpers.h + vmlinux.h is good. 
> Basically
> what Yonghong has suggested.  Not sure what you meant by 'old-school'
> includes.
That was badly worded by me. I was referring to linux/types.h and co.

> I don't think it needs a new bpf_tcp_types_helper.h also. 
I thought that might be helpful as a first step towards using
vmlinux.h, without fully migrating all the users of bpf_tcp_helpers.h.
But that’s probably unnecessary.

> 
> I think it makes sense to remove everything from bpf_tcp_helpers.h
> that is already available from vmlinux.h.  bpf_tcp_helpers.h
> should only have some macros and helpers left.  Then move
> bpf_dctcp.c, bpf_cubic.c, and a few others under progs/ to
> use vmlinux.h.  I haven't tried but it should be doable
> from a quick look at bpf_cubic.c and bpf_dctcp.c.
> 
> I agree it is better to directly use the struct tcp_sock,
> inet_connection_sock,
> inet_sock... from the vmlinux.h.  However, bpf_tcp_helpers.h does not
> only have the struct and enum defined in the kernel.  It has some
> helpers and macros (e.g. TCP_CONG_NEEDS_ECN, TCP_ECN_*) that are
> missing
> from vmlinux.h.
It’s unfortunate that especially those many, tiny non-macro helpers
like tcp_sk() and e.g. tcp_stamp_us_delta() still have to be redefined.
Could it make sense to provide those, in the same way tcp_slow_start(),
tcp_cong_avoid_ai(), and tcp_reno_*() are “exported” as kfuncs by
bpf_tcp_ca.c (if I read that correctly)? Even though the list of these
functions could grow quickly.


> These are actually used by the realistic bpf-tcp-cc like
> bpf_cubic.c and bpf_dctcp.c.
> 
> The simple test in this patch is not a fully implemented bpf-tcp-cc
> and
> it only needs to duplicate the tcp_sk() helper which looks ok at the
> beginning.
> Later, this simple test will be copied-and-pasted to create another
> test.
> These new tests may then need to duplicate more helpers and macros.
> It was what I meant it needs separate patches to migrate all bpf-tcp-
> cc
> tests to vmlinux.h.  Otherwise, when they are migrated to vmlinux.h
> later,
> we have another pattern of tests that can be cleared up to remove
> these helpers/macros duplication.
I agree with you there and also don’t favor copying stuff around. Only
did it here, since something had to be copied: either a field into one
of the structs in bpf_tcp_helpers or tcp_sk.

> 
> I don't mind to keep a duplicate tcp_sk() in this set for now
> if you can do a follow up to move all bpf-tcp-cc tests
> to this path (vmlinux.h + a trimmed down bpf_tcp_helpers.h) and then
> remove the tcp_sk() duplication here.  This will be very useful.
Took a look at this over the last few days, see [1]. Happy about
feedback.

[1]
https://lore.kernel.org/bpf/20220622181015.892445-1-jthinz@mailbox.tu-berlin.de/

> 
> > > 
> > > Do you insist to use bpf_tcp_helpers.h instead of vmlinux.h? Or
> > > could
> > > the described split into two headers make sense after all?
> > 
> > I prefer to use vmlinux.h. Eventually we would like to use
> > vmlinux.h
> > for progs which include bpf_tcp_healpers.h. Basically remove the
> > struct
> > definitions in bpf_tcp_helpers.h and replacing "bpf.h, stddef.h,
> > tcp.h ..."
> > with vmlinux.h. We may not be there yet, but that is the goal.
> > 
> > > 
> > > (Will wait for your reply here before sending a v4.)


