Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5237260
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfFFLE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:04:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33952 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFFLE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:04:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id h2so1170722pgg.1;
        Thu, 06 Jun 2019 04:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eAj3SnZRkW/hXNaSdkScPU0gjqHplVwGdOnKTnZJG2k=;
        b=FOzoj+uFS7UehWdhfR6caDG/Q/BS+VKaqYdw27JVx7yDvG2AW0FLiIDPG6zltyLsY2
         6BQ5p/dSFZ061NPJok7WN8nnpYuIMkBN8GEHiS7xor08t3XkhZ5RhIvgCqvIR1YHvCFM
         VHqH/pg2+l52dPahAJIsMs/f+AMV4oiDKH6TwE18Fy/gQInVFDg5MrD9Z9DNMpdN8PO3
         MbTavQnLbbngW0YeaUZxXRlaxwoyS2zyesnnhdlbK0DtDlf/OQ0od/5OzDfe4VkxbMDL
         ZuIJbMZRzgp/bGxNwDDFhxSEm/ooEDhHBqdfkB66pFG26Fb7tZFRRnjKumEj3aiUJE0D
         Wwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eAj3SnZRkW/hXNaSdkScPU0gjqHplVwGdOnKTnZJG2k=;
        b=Mu0iVajVGRrhFHsm6PHTBgP+Qb4X4Mk2pzbM8iEvk5ti+J/jOF+zxQvPWxO634I1dC
         TlnF484Q04xlMJPrvm8JUf7ccUyHeTQYKN9M9DICBPfig2CEnHZfzjO8BEATiOJ9W+Hx
         yTa76IcQTOo6Ji5o22pH/QTFMHkb0YZL/cBtMCb8IKKUcHRM/R4Q0CbLyx4LHYKRFFdw
         C84iz35somcu9g4z3FfC7//9IlukOsRaw0dy5RrfTrowvuojyBdeLcj8TZfaE8UqJCPz
         EoZcGu2cLrvB+gyjeNpa5WsgWgz6/U0nIKc87m7LLf/xcbqaJZeaP/tVq2tnXsdqpbk5
         6uJg==
X-Gm-Message-State: APjAAAWwdN9r9bkQqO32u0CroTvuhw/MTjH14ZADELoXlER763KPoFP6
        UCFpwNhcxO7WBigBJ3KUmYk=
X-Google-Smtp-Source: APXvYqw9v3ZVhjYSDVWSg1mMuSD87K1bpEtsLwy70Mgsd3A0NfAGE4satNKSc2YfU3/xV9ZOMRWPOw==
X-Received: by 2002:a65:638e:: with SMTP id h14mr2823334pgv.209.1559819066466;
        Thu, 06 Jun 2019 04:04:26 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id t124sm2116575pfb.80.2019.06.06.04.04.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 04:04:25 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
 <20190605053613.22888-2-toshiaki.makita1@gmail.com>
 <20190605095931.5d90b69c@carbon>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <abd43c39-afb7-acd4-688a-553cec76f55c@gmail.com>
Date:   Thu, 6 Jun 2019 20:04:20 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190605095931.5d90b69c@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/05 16:59, Jesper Dangaard Brouer wrote:
> On Wed,  5 Jun 2019 14:36:12 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> This is introduced for admins to check what is happening on XDP_TX when
>> bulk XDP_TX is in use, which will be first introduced in veth in next
>> commit.
> 
> Is the plan that this tracepoint 'xdp:xdp_bulk_tx' should be used by
> all drivers?

I guess you mean all drivers that implement similar mechanism should use 
this? Then yes.
(I don't think all drivers needs bulk tx mechanism though)

> (more below)
> 
>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>> ---
>>   include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
>>   kernel/bpf/core.c          |  1 +
>>   2 files changed, 26 insertions(+)
>>
>> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
>> index e95cb86..e06ea65 100644
>> --- a/include/trace/events/xdp.h
>> +++ b/include/trace/events/xdp.h
>> @@ -50,6 +50,31 @@
>>   		  __entry->ifindex)
>>   );
>>   
>> +TRACE_EVENT(xdp_bulk_tx,
>> +
>> +	TP_PROTO(const struct net_device *dev,
>> +		 int sent, int drops, int err),
>> +
>> +	TP_ARGS(dev, sent, drops, err),
>> +
>> +	TP_STRUCT__entry(
> 
> All other tracepoints in this file starts with:
> 
> 		__field(int, prog_id)
> 		__field(u32, act)
> or
> 		__field(int, map_id)
> 		__field(u32, act)
> 
> Could you please add those?

So... prog_id is the problem. The program can be changed while we are 
enqueueing packets to the bulk queue, so the prog_id at flush may be an 
unexpected one.

It can be fixed by disabling NAPI when changing XDP programs. This stops 
packet processing while changing XDP programs, but I guess it is an 
acceptable compromise. Having said that, I'm honestly not so eager to 
make this change, since this will require refurbishment of one of the 
most delicate part of veth XDP, NAPI disabling/enabling mechanism.

WDYT?

>> +		__field(int, ifindex)
>> +		__field(int, drops)
>> +		__field(int, sent)
>> +		__field(int, err)
>> +	),
> 
> The reason is that this make is easier to attach to multiple
> tracepoints, and extract the same value.
> 
> Example with bpftrace oneliner:
> 
> $ sudo bpftrace -e 'tracepoint:xdp:xdp_* { @action[args->act] = count(); }'
> Attaching 8 probes...
> ^C
> 
> @action[4]: 30259246
> @action[0]: 34489024
> 
> XDP_ABORTED = 0 	
> XDP_REDIRECT= 4
> 
> 
>> +
>> +	TP_fast_assign(
> 
> 		__entry->act		= XDP_TX;

OK

> 
>> +		__entry->ifindex	= dev->ifindex;
>> +		__entry->drops		= drops;
>> +		__entry->sent		= sent;
>> +		__entry->err		= err;
>> +	),
>> +
>> +	TP_printk("ifindex=%d sent=%d drops=%d err=%d",
>> +		  __entry->ifindex, __entry->sent, __entry->drops, __entry->err)
>> +);
>> +
> 
> Other fun bpftrace stuff:
> 
> sudo bpftrace -e 'tracepoint:xdp:xdp_*map* { @map_id[comm, args->map_id] = count(); }'
> Attaching 5 probes...
> ^C
> 
> @map_id[swapper/2, 113]: 1428
> @map_id[swapper/0, 113]: 2085
> @map_id[ksoftirqd/4, 113]: 2253491
> @map_id[ksoftirqd/2, 113]: 25677560
> @map_id[ksoftirqd/0, 113]: 29004338
> @map_id[ksoftirqd/3, 113]: 31034885
> 
> 
> $ bpftool map list id 113
> 113: devmap  name tx_port  flags 0x0
> 	key 4B  value 4B  max_entries 100  memlock 4096B
> 
> 
> p.s. People should look out for Brendan Gregg's upcoming book on BPF
> performance tools, from which I learned to use bpftrace :-)

Where can I get information on the book?

--
Toshiaki Makita
