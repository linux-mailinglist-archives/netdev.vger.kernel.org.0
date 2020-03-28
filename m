Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9521D1962FC
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgC1B4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:56:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:58472 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgC1B4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 21:56:42 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jI0iE-00048d-1u; Sat, 28 Mar 2020 02:56:38 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jI0iD-000Xx6-Py; Sat, 28 Mar 2020 02:56:37 +0100
Subject: Re: [PATCH bpf-next 4/7] bpf: allow to retrieve cgroup v1 classid
 from v2 hooks
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <cover.1585323121.git.daniel@iogearbox.net>
 <555e1c69db7376c0947007b4951c260e1074efc3.1585323121.git.daniel@iogearbox.net>
 <CAEf4BzY5dd-wXbLziCQJOgikY-qvD+GQC=9HHZGCqmM_R-2mJA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3e519e0e-aa52-67a5-98f6-0e259745e400@iogearbox.net>
Date:   Sat, 28 Mar 2020 02:56:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY5dd-wXbLziCQJOgikY-qvD+GQC=9HHZGCqmM_R-2mJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 1:41 AM, Andrii Nakryiko wrote:
> On Fri, Mar 27, 2020 at 9:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Today, Kubernetes is still operating on cgroups v1, however, it is
>> possible to retrieve the task's classid based on 'current' out of
>> connect(), sendmsg(), recvmsg() and bind-related hooks for orchestrators
>> which attach to the root cgroup v2 hook in a mixed env like in case
>> of Cilium, for example, in order to then correlate certain pod traffic
>> and use it as part of the key for BPF map lookups.
> 
> Have you tried getting this classid directly from task_struct in your
> BPF program with vmlinux.h and CO-RE? Seems like it should be pretty
> straightforward and not requiring a special BPF handler just for that?

To answer both questions (5/7 and this one) in the same mail here: my
understanding is that this would require to install additional tracing
programs on these hooks instead of being able to integrate them into [0]
for usage out of sock_addr and sock progs (similar as they are available
as well from tc from skb)?

Thanks,
Daniel

   [0] https://github.com/cilium/cilium/blob/master/bpf/bpf_sock.c
