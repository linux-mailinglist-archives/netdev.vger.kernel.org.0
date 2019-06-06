Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2FD37FDF
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfFFVsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:48:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:51212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfFFVsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:48:31 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZ0FG-00034C-A2; Thu, 06 Jun 2019 23:48:26 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZ0FG-000AWZ-3A; Thu, 06 Jun 2019 23:48:26 +0200
Subject: Re: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
To:     Andrey Ignatov <rdna@fb.com>
Cc:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        Martin Lau <kafai@fb.com>, "m@lambda.lt" <m@lambda.lt>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190606143517.25710-1-daniel@iogearbox.net>
 <20190606204554.GA50385@rdna-mbp.dhcp.thefacebook.com>
 <20190606205148.GB50385@rdna-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b966c6df-a4f4-e83d-f012-16b337aff97d@iogearbox.net>
Date:   Thu, 6 Jun 2019 23:48:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190606205148.GB50385@rdna-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25472/Thu Jun  6 10:09:59 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/06/2019 10:51 PM, Andrey Ignatov wrote:
> Andrey Ignatov <rdna@fb.com> [Thu, 2019-06-06 13:45 -0700]:
>> Daniel Borkmann <daniel@iogearbox.net> [Thu, 2019-06-06 07:36 -0700]:
>>> Please refer to the patch 1/4 as the main patch with the details
>>> on the current sendmsg hook API limitations and proposal to fix
>>> it in order to work with basic applications like DNS. Remaining
>>> patches are the usual uapi and tooling updates as well as test
>>> cases. Thanks a lot!
>>>
>>> v1 -> v2:
>>>   - Split off uapi header sync and bpftool bits (Martin, Alexei)
>>>   - Added missing bpftool doc and bash completion as well
>>>
>>> Daniel Borkmann (4):
>>>   bpf: fix unconnected udp hooks
>>>   bpf: sync tooling uapi header
>>>   bpf, bpftool: enable recvmsg attach types
>>>   bpf: add further msg_name rewrite tests to test_sock_addr
>>>
>>>  include/linux/bpf-cgroup.h                    |   8 +
>>>  include/uapi/linux/bpf.h                      |   2 +
>>>  kernel/bpf/syscall.c                          |   8 +
>>>  kernel/bpf/verifier.c                         |  12 +-
>>>  net/core/filter.c                             |   2 +
>>>  net/ipv4/udp.c                                |   4 +
>>>  net/ipv6/udp.c                                |   4 +
>>>  .../bpftool/Documentation/bpftool-cgroup.rst  |   6 +-
>>>  .../bpftool/Documentation/bpftool-prog.rst    |   2 +-
>>>  tools/bpf/bpftool/bash-completion/bpftool     |   5 +-
>>>  tools/bpf/bpftool/cgroup.c                    |   5 +-
>>>  tools/bpf/bpftool/prog.c                      |   3 +-
>>>  tools/include/uapi/linux/bpf.h                |   2 +
>>>  tools/testing/selftests/bpf/test_sock_addr.c  | 213 ++++++++++++++++--
>>>  14 files changed, 250 insertions(+), 26 deletions(-)
>>
>> tools/lib/bpf/libbpf.c should also be updated: section_names and
> 
> And tools/testing/selftests/bpf/test_section_names.c as well.
> 
>> bpf_prog_type__needs_kver. Please either follow-up separately or send

Sigh, yes, makes sense, I'll fold these in for a final v3. Thanks for
spotting!

>> v3. Other than this LGMT.
>>
>> Acked-by: Andrey Ignatov <rdna@fb.com>
>>
>> -- 
>> Andrey Ignatov
> 

