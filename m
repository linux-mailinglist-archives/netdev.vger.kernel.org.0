Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97FB32419A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhBXQCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:02:50 -0500
Received: from www62.your-server.de ([213.133.104.62]:60988 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhBXP4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 10:56:14 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lEwVD-0003kV-91; Wed, 24 Feb 2021 16:55:03 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lEwVD-0001V7-2g; Wed, 24 Feb 2021 16:55:03 +0100
Subject: Re: [PATCH bpf-next] bpf: fix missing * in bpf.h
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        andrii.nakryiko@gmail.com
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
 <20210223154327.6011b5ee@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2b917326-3a63-035e-39e9-f63fe3315432@iogearbox.net>
Date:   Wed, 24 Feb 2021 16:55:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210223154327.6011b5ee@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26090/Wed Feb 24 13:09:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/21 3:43 PM, Jesper Dangaard Brouer wrote:
> On Tue, 23 Feb 2021 20:45:54 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
>> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
>> in bpf.h. This will make bpf_helpers_doc.py stop building
>> bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
>> future add functions.
>>
>> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>>   include/uapi/linux/bpf.h       | 2 +-
>>   tools/include/uapi/linux/bpf.h | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Thanks for fixing that!
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks guys, applied!

> I though I had already fix that, but I must have missed or reintroduced
> this, when I rolling back broken ideas in V13.
> 
> I usually run this command to check the man-page (before submitting):
> 
>   ./scripts/bpf_helpers_doc.py | rst2man | man -l -

[+ Andrii] maybe this could be included to run as part of CI to catch such
things in advance?

>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 4c24daa43bac..46248f8e024b 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3850,7 +3850,7 @@ union bpf_attr {
>>    *
>>    * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>>    *	Description
>> -
>> + *
>>    *		Check ctx packet size against exceeding MTU of net device (based
>>    *		on *ifindex*).  This helper will likely be used in combination
>>    *		with helpers that adjust/change the packet size.
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index 4c24daa43bac..46248f8e024b 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -3850,7 +3850,7 @@ union bpf_attr {
>>    *
>>    * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>>    *	Description
>> -
>> + *
>>    *		Check ctx packet size against exceeding MTU of net device (based
>>    *		on *ifindex*).  This helper will likely be used in combination
>>    *		with helpers that adjust/change the packet size.
> 
> 
> 

