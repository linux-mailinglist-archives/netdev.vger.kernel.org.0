Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF931E6D9A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436559AbgE1V1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436519AbgE1V1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:27:06 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC36C08C5C6;
        Thu, 28 May 2020 14:27:06 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ci23so147629pjb.5;
        Thu, 28 May 2020 14:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AeK2+WIEfEwLtUDVbsBEaZ7tfHtM9zDOtrpFji4wsek=;
        b=RyATqq7bbugKuEEPBIvRZsJSAYH/Oi5bi+puZfsWlM7SyKPsPNyddahSiTVhO4nySL
         xVf4m/uaP0nr9NT44oTJl4M/qkuexLA/cw8I7+5YLndJs5KdIL6IfZf4pUIc/VBGB0rK
         QcsnowxPpWBBo7Zl36eod04l3NI3U5UXaMOc90J70FIg9h/s4Gx1P4OUsBekzl6LZz/A
         iT5TeFL5H7hhyu0xZBt9+jltNbbmzKIkoZ2qpkrpYaVqSdvSv2N5dYMTH+tNCWuP3zjM
         GSY1KXGkhWfzQIJk75UOMoXwRHHhn1SP0XRoBM+R245SjHFqXJ76ZxsgLaFoa/jDcdcu
         lhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AeK2+WIEfEwLtUDVbsBEaZ7tfHtM9zDOtrpFji4wsek=;
        b=gqr9ex+X7cps9ik4A1LYGNY3OoAAgNh723Na7TCWWzQZvyxwTMGAHj58qSZof8JC7d
         nuqgWuReojTK2MSJwM8bwEbGUgQNP73fKkPsLTBTwEWZnfSK89tM+EOT7TX/M2ktuCrV
         UbVzV9mrEDiEzzjhK+pmaw1QI9LSqgRLlATIYo35BOo/oZlilO12yHYufVWecuoy7mYN
         v0RVKx4qcDJ0g8rZZPLin0uKSqOHsoEqjoaRRKFJmOi3d/mlLxAV3paZ+0Rmw4Fc3L/S
         h/HtCVu5Q+LuYn00yjhhwekGozMixUvgtKpKF5f36jcNXD2rAl9Hr9cHqfLIICaFIQ4W
         xNFQ==
X-Gm-Message-State: AOAM530qJt4VPPvJH2zw/NIx/Q3Pxt7czz21ZMOXZLAsoy+MtBvVsGOV
        VoNQL6eThQ3e6Ae3aValDepfk73P
X-Google-Smtp-Source: ABdhPJxfsaV6eq2MYqpZPxDziZG9PWhwu9Oe5jM5l5/Kovw7Yh6786TB1q+xYJXYAYB9+B0jWmk15Q==
X-Received: by 2002:a17:902:70c1:: with SMTP id l1mr5452023plt.178.1590701225469;
        Thu, 28 May 2020 14:27:05 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p8sm5235525pgs.29.2020.05.28.14.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 14:27:04 -0700 (PDT)
Subject: Re: general protection fault in inet_unhash
To:     Andrii Nakryiko <andriin@fb.com>,
        syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        ast@kernel.org, davem@davemloft.net, guro@fb.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org, eric.dumazet@gmail.com
References: <00000000000018e1d305a6b80a73@google.com>
 <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <342a5525-e821-5cdd-487b-da6b5278a344@gmail.com>
Date:   Thu, 28 May 2020 14:27:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/20 2:01 PM, Andrii Nakryiko wrote:
> On 5/28/20 9:44 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    dc0f3ed1 net: phy: at803x: add cable diagnostics support f..
>> git tree:       net-next
>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17289cd2100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=t1v5ZakZM9Aw_9u_I6FbFZ28U0GFs0e9dMMUOyiDxO4&e=
>> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D7e1bc97341edbea6&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=yeXCTODuJF6ExmCJ-ppqMHsfvMCbCQ9zkmZi3W6NGHo&e=
>> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D3610d489778b57cc8031&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=8fAJHh81yojiinnGJzTw6hN4w4A6XRZST4463CWL9Y8&e=
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D15f237aa100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=cPv-hQsGYs0CVz3I26BmauS0hQ8_YTWHeH5p-U5ElWY&e=
>> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D1553834a100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=r6sGJDOgosZDE9sRxqFnVibDNJFt_6IteSWeqEQLbNE&e=
>>
>> The bug was bisected to:
>>
>> commit af6eea57437a830293eab56246b6025cc7d46ee7
>> Author: Andrii Nakryiko <andriin@fb.com>
>> Date:   Mon Mar 30 02:59:58 2020 +0000
>>
>>      bpf: Implement bpf_link-based cgroup BPF program attachment
>>
>> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D1173cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=rJIpYFSAMRfea3349dd7PhmLD_hriVwq8ZtTHcSagBA&e=
>> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D1373cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=TWpx5JNdxKiKPABUScn8WB7u3fXueCp7BXwQHg4Unz0&e=
>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1573cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=-SMhn-dVZI4W51EZQ8Im0sdThgwt9M6fxUt3_bcYvk8&e=
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
>> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
>>
>> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>> CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
> 
> No idea why it was bisected to bpf_link change. It seems completely struct sock-related. Seems like
> 
> struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
> 
> ends up being NULL.
> 
> Can some more networking-savvy people help with investigating this, please?

Well, the repro definitely uses BPF

On the following run, my kernel does not have L2TP, so does not crash.

[pid 817013] bpf(BPF_TASK_FD_QUERY, {task_fd_query={pid=0, fd=-1, flags=0, buf_len=7, buf="cgroup", prog_id=0, fd_type=BPF_FD_TYPE_RAW_TRACEPOINT, probe_offset=0, probe_addr=0}}, 48) = -1 ENOENT (No such file or directory)
[pid 817013] openat(AT_FDCWD, "cgroup", O_RDWR|O_PATH) = 3
[pid 817013] bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=4, insns=0x20000000, license="GPL", log_level=0, log_size=0, log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0, prog_name="", prog_ifindex=0, expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=-1, func_info_rec_size=8, func_info=NULL, func_info_cnt=0, line_info_rec_size=16, line_info=NULL, line_info_cnt=0, attach_btf_id=0}, 112) = -1 EPERM (Operation not permitted)
[pid 817013] bpf(BPF_LINK_CREATE, {link_create={prog_fd=-1, target_fd=3, attach_type=BPF_CGROUP_INET_SOCK_CREATE, flags=0}}, 16) = -1 EBADF (Bad file descriptor)
[pid 817013] socket(AF_INET, SOCK_DGRAM, IPPROTO_L2TP <unfinished ...>
[pid 816180] <... nanosleep resumed>NULL) = 0
[pid 816180] wait4(-1, 0x7fffa59867cc, WNOHANG|__WALL, NULL) = 0
[pid 816180] nanosleep({tv_sec=0, tv_nsec=1000000},  <unfinished ...>
[pid 817013] <... socket resumed>)      = -1 EPROTONOSUPPORT (Protocol not supported)
