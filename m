Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDB866EDE
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfGLMlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:41:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:45856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGLMlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:41:44 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hluru-0003xC-Pc; Fri, 12 Jul 2019 14:41:42 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hluru-000BPz-Jf; Fri, 12 Jul 2019 14:41:42 +0200
Subject: Re: [PATCH v6 bpf-next 0/3] bpf: add bpf_descendant_of helper
To:     Javier Honduvilla Coto <javierhonduco@fb.com>,
        netdev@vger.kernel.org
Cc:     yhs@fb.com, kernel-team@fb.com, jonhaslam@fb.com
References: <20190410203631.1576576-1-javierhonduco@fb.com>
 <20190710180025.94726-1-javierhonduco@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a3784df6-851e-e829-57f4-740af000a58f@iogearbox.net>
Date:   Fri, 12 Jul 2019 14:41:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190710180025.94726-1-javierhonduco@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2019 08:00 PM, Javier Honduvilla Coto wrote:
> Hi all,
> 
> This patch adds the bpf_descendant_of helper which accepts a PID and
> returns 1 if the PID of the process currently being executed is a
> descendant of it or if it's itself. Returns 0 otherwise. The passed
> PID should be the one as seen from the "global" pid namespace as the
> processes' PIDs in the hierarchy are resolved using the context of said
> initial namespace.
> 
> This is very useful in tracing programs when we want to filter by a
> given PID and all the children it might spawn. The current workarounds
> most people implement for this purpose have issues:
> 
> - Attaching to process spawning syscalls and dynamically add those PIDs
> to some bpf map that would be used to filter is cumbersome and
> potentially racy.
> - Unrolling some loop to perform what this helper is doing consumes lots
> of instructions. That and the impossibility to jump backwards makes it
> really hard to be correct in really large process chains.
> 
> 
> Let me know what do you think!
> 
> Thanks,
> 
> ---
> Changes in V6:
>         - Small style fix
>         - Clarify in the docs that we are resolving PIDs using the global,
> initial PID namespace, and the provided *pid* argument should be global, too
>         - Changed the way we assert on the helper return value
> 
> Changes in V5:
>         - Addressed code review feedback
>         - Renamed from progenyof => descendant_of as suggested by Jon Haslam
> and Brendan Gregg
> 
> Changes in V4:
>         - Rebased on latest bpf-next after merge window
> 
> Changes in V3:
>         - Removed RCU read (un)locking as BPF programs alredy run in RCU locked
>                 context
>         - progenyof(0) now returns 1, which, semantically makes more sense
>         - Added new test case for PID 0 and changed sentinel value for errors
>         - Rebase on latest bpf-next/master
>         - Used my work email as somehow I accidentally used my personal one in v2
> 
> Changes in V2:
>         - Adding missing docs in include/uapi/linux/bpf.h
> 

bpf-next is currently closed due to merge window, please resubmit once it reopens.

Thanks,
Daniel
