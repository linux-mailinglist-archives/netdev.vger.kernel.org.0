Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484D536CEAB
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhD0Wkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 18:40:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:40282 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhD0Wkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 18:40:52 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbWND-0001UZ-8p; Wed, 28 Apr 2021 00:40:07 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbWNC-000TPD-W2; Wed, 28 Apr 2021 00:40:07 +0200
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
 <20210427180202.pepa2wdbhhap3vyg@apollo>
 <9985fe91-76ea-7c09-c285-1006168f1c27@iogearbox.net>
 <7a75062e-b439-68b3-afa3-44ea519624c7@iogearbox.net> <87sg3b8idy.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8e6d24fa-d3ef-af20-b2a5-dbdc9a284f6d@iogearbox.net>
Date:   Wed, 28 Apr 2021 00:40:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87sg3b8idy.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26153/Tue Apr 27 13:09:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 12:36 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
[...]
>> Small addendum:
>>
>>       DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = 42, .which = BPF_TC_INGRESS|BPF_TC_EGRESS);
>>
>>       err = bpf_tc_hook_create(&hook);
>>       [...]
>>
>> ... is also possible, of course, and then both bpf_tc_hook_{create,destroy}() are symmetric.
> 
> It should be allowed, but it wouldn't actually make any difference which
> combination of TC_INGRESS and TC_EGRESS you specify, as long as one of
> them is set, right? I.e., we just attach the clsact qdisc in both
> cases...

Yes, that is correct, for the bpf_tc_hook_create() whether you pass in BPF_TC_INGRESS,
BPF_TC_EGRESS or BPF_TC_INGRESS|BPF_TC_EGRESS, you'll end up creating clsact qdisc in
either of the three cases. Only the bpf_tc_hook_destroy() differs between all of them.

Thanks,
Daniel
