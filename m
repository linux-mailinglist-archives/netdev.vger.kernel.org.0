Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25ED5594
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 12:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfJMKBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 06:01:20 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:56143 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbfJMKBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 06:01:20 -0400
X-Originating-IP: 90.177.210.238
Received: from [192.168.1.110] (238.210.broadband10.iol.cz [90.177.210.238])
        (Authenticated sender: i.maximets@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 0E1731BF209;
        Sun, 13 Oct 2019 10:01:15 +0000 (UTC)
Subject: Re: [PATCH bpf] libbpf: fix passing uninitialized bytes to setsockopt
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <5da2ad7f.1c69fb81.2ed87.f547SMTPIN_ADDED_BROKEN@mx.google.com>
 <CAADnVQLczRWyWa44+ogr1UkcOObA40zurwxMY=0hO9_1Y1yeDA@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <50f76b97-2be6-6976-36ec-bfb88afc6009@ovn.org>
Date:   Sun, 13 Oct 2019 12:01:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQLczRWyWa44+ogr1UkcOObA40zurwxMY=0hO9_1Y1yeDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.10.2019 6:59, Alexei Starovoitov wrote:
> On Sat, Oct 12, 2019 at 9:52 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>>
>> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
>> valgrind complain about passing uninitialized stack memory to the
>> syscall:
>>
>>    Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>>      at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>>      by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>>    Uninitialised value was created by a stack allocation
>>      at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>>
>> Padding bytes appeared after introducing of a new 'flags' field.
>>
>> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> 
> Something is not right with (e|g)mail.
> This is 3rd email I got with the same patch.
> First one (the one that was applied) was 3 days ago.
> 

I'm sorry.  I don't know why the mail server started re-sending
these e-mails.  I'm receiving them too.

That is strange.

Best regards, Ilya Maximets.
