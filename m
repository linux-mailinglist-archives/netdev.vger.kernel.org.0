Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1334FD91E7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393410AbfJPNCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:02:36 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:52841 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728878AbfJPNCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 09:02:36 -0400
Received: from [167.98.27.226] (helo=[10.35.5.173])
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKiwi-00004r-5P; Wed, 16 Oct 2019 14:02:32 +0100
Subject: Re: [PATCH] net: bpf: add static in net/core/filter.c
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     linux-kernel@lists.codethink.co.uk,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191016110446.24622-1-ben.dooks@codethink.co.uk>
 <20191016122605.GC21367@pc-63.home>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <e947b15d-1d70-39d9-3b28-0367a3f0f4c0@codethink.co.uk>
Date:   Wed, 16 Oct 2019 14:02:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016122605.GC21367@pc-63.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/10/2019 13:26, Daniel Borkmann wrote:
> On Wed, Oct 16, 2019 at 12:04:46PM +0100, Ben Dooks (Codethink) wrote:
>> There are a number of structs in net/core/filter.c
>> that are not exported or declared outside of the
>> file. Fix the following warnings by making these
>> all static:
>>
>> net/core/filter.c:8465:31: warning: symbol 'sk_filter_verifier_ops' was not declared. Should it be static?
>> net/core/filter.c:8472:27: warning: symbol 'sk_filter_prog_ops' was not declared. Should it be static?
> [...]
>> net/core/filter.c:8935:27: warning: symbol 'sk_reuseport_prog_ops' was not declared. Should it be static?
>>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Martin KaFai Lau <kafai@fb.com>
>> Cc: Song Liu <songliubraving@fb.com>
>> Cc: Yonghong Song <yhs@fb.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
>> Cc: John Fastabend <john.fastabend@gmail.com>
>> Cc: netdev@vger.kernel.org
>> Cc: bpf@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   net/core/filter.c | 60 +++++++++++++++++++++++------------------------
>>   1 file changed, 30 insertions(+), 30 deletions(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index ed6563622ce3..f7338fee41f8 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -8462,18 +8462,18 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
>>   	return insn - insn_buf;
>>   }
>>   
>> -const struct bpf_verifier_ops sk_filter_verifier_ops = {
>> +static const struct bpf_verifier_ops sk_filter_verifier_ops = {
>>   	.get_func_proto		= sk_filter_func_proto,
>>   	.is_valid_access	= sk_filter_is_valid_access,
>>   	.convert_ctx_access	= bpf_convert_ctx_access,
>>   	.gen_ld_abs		= bpf_gen_ld_abs,
>>   };
> 
> Big obvious NAK. I'm puzzled that you try to fix a compile warning, but without
> even bothering to compile the result after your patch ...

builds fine. maybe some effort to stop this happening again should be made.

> Seen BPF_PROG_TYPE() ?




-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
