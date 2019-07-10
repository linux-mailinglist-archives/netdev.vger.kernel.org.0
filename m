Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AD664DF5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfGJVTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:19:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:45558 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfGJVTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:19:52 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlK08-0002zM-9q; Wed, 10 Jul 2019 23:19:44 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlK08-00021W-2p; Wed, 10 Jul 2019 23:19:44 +0200
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>, brendan.d.gregg@gmail.com,
        davem@davemloft.net
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
 <201907101542.x6AFgOO9012232@userv0121.oracle.com>
 <20190710181227.GA9925@oracle.com>
 <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
 <20190710143048.3923d1d9@lwn.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1de27d29-65bb-89d3-9fca-7c452cd66934@iogearbox.net>
Date:   Wed, 10 Jul 2019 23:19:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190710143048.3923d1d9@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25506/Wed Jul 10 10:11:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2019 10:30 PM, Jonathan Corbet wrote:
> On Wed, 10 Jul 2019 21:32:25 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>> Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
>> seen a strong compelling argument for why this needs to reside in the kernel
>> tree given we also have all the other tracing tools and many of which also
>> rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
>> a few.
> 
> So I'm just watching from the sidelines here, but I do feel the need to
> point out that Kris appears to be trying to follow the previous feedback
> he got from Alexei, where creating tools/dtrace is exactly what he was
> told to do:
> 
>   https://lwn.net/ml/netdev/20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com/
> 
> Now he's being told the exact opposite.  Not the best experience for
> somebody who is trying to make the kernel better.

Ugh, agree, sorry for the misleading direction. Alexei is currently offgrid
this week, he might comment later.

It has nothing to do with making the _kernel_ better, it's a /user space/ front
end for the existing kernel infrastructure like many of the other tracers out
there. Don't get me wrong, adding the missing /kernel parts/ for it is a totally
different subject [and _that_ is what is making the kernel better, not the former].
Hypothetical question: does it make the _kernel_ better if we suddenly add a huge
and complex project like tools/mysql/ to the kernel tree? Nope.

> There are still people interested in DTrace out there.  How would you
> recommend that Kris proceed at this point?

My recommendation to proceed is to maintain the dtrace user space tooling in
its own separate project like the vast majority of all the other tracing projects
(see also the other advantages that Steven pointed out from his experience), and
extend the kernel bits whenever needed.

Thanks,
Daniel
