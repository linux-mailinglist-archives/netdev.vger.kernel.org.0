Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6993DE7EB
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhHCIJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:09:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:44598 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbhHCIJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:09:19 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mApTi-0001E5-4G; Tue, 03 Aug 2021 10:08:46 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mApTh-000HvD-J6; Tue, 03 Aug 2021 10:08:45 +0200
Subject: Re: [PATCH net-next 1/2] net/sched: sch_ingress: Support clsact
 egress mini-Qdisc option
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
 <672e6f13-bf58-d542-6712-e6f803286373@iogearbox.net>
 <CAM_iQpUb-zbBUGdYxCwxBJSKJ=6Gm3hFwFP+nc+43E_hofuK1w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e2a8ac28-f6ee-25e7-6cb9-cc28369b030a@iogearbox.net>
Date:   Tue, 3 Aug 2021 10:08:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUb-zbBUGdYxCwxBJSKJ=6Gm3hFwFP+nc+43E_hofuK1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26251/Mon Aug  2 10:18:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 2:08 AM, Cong Wang wrote:
> On Mon, Aug 2, 2021 at 2:11 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> NAK, just use clsact qdisc in the first place which has both ingress and egress
>> support instead of adding such hack. You already need to change your scripts for
>> clsact-on, so just swap 'tc qdisc add dev eth0 ingress' to 'tc qdisc add dev eth0
>> clsact' w/o needing to change kernel.
> 
> If we were able to change the "script" as easily as you described,
> you would not even see such a patch. The fact is it is not under
> our control, the most we can do is change the qdisc after it is
> created by the "script", ideally without interfering its traffic,
> hence we have such a patch.
> 
> (BTW, it is actually not a script, it is a cloud platform.)

Sigh, so you're trying to solve a non-technical issue with one cloud provider by
taking a detour for unnecessarily extending the kernel instead with functionality
that already exists in another qdisc (and potentially waiting few years until they
eventually upgrade). I presume Bytedance should be a big enough entity to make a
case for that provider to change it. After all swapping ingress with clsact for
such script is completely transparent and there is nothing that would break. (Fwiw,
from all the major cloud providers we have never seen such issue in our deployments.)

Thanks,
Daniel
