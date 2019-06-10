Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E93B41F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389067AbfFJLl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:41:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40352 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388453AbfFJLl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:41:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so1866684pfp.7;
        Mon, 10 Jun 2019 04:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L4AlfmLwBFZZOdcgZsTQ5atOdp5qnYtX3LhUVSPdmCc=;
        b=Vp/JNUXerYMyXz/41OibUTg13ONS3djMgugJ/IOKH8KDXuD6V+oa0hgdKxNr6gVSZ2
         POTkDQhxi/G9vKOmJCX4ju+09NbDxbmBJTZSX2qGWez7IYk6odiZC+Hx0C+zwJDdLZMU
         ILYUcs8m9m7FQBNNlRNYj7PL830JyIDpMUvWLdigLKXplALTEwwXmO8vUfi4uJnStJic
         fG8Vf6tC9GdGiWhz8+smPeOFxng96HT4Vb/rUzodzpvJ6YOcEeyir3tZpiXKJZVmeB5w
         cOXKsjA6OIH8qWhfAnf2jVEJ1YNkcMqhUAi6dywn1kZN7g3oCfiLot9V12w+3hDX/78V
         TTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4AlfmLwBFZZOdcgZsTQ5atOdp5qnYtX3LhUVSPdmCc=;
        b=ZWXc4L8q8kjvQx7zEu5HDHUimTZhKojdLoTz+83zg9dzm88qh0Pq7yaSXMmVnCV6Ty
         E6U23fIIiIdqV41EDCZg5g5a70iiXEdax46Qno90eZJF1yoSlwCLICiUT2+Mi7RCwNpd
         53cU5DM97cyB+ArzOeL/A0VLN1XgaCZV6n3pHcV5s/VXrqFC1WFyl2JCbDYes4YQvsFP
         ILvpYhlKjCk68jP/D+NASDUyo/1mYfTJCickQwCu6P46iXACdHm6sr3hm/9NcVV8M+op
         KTam1sDFu7v++kzUT7JxQKzAGKNwyZmSt2NUv+iB/AbGgI0Ls0qgo4xp1PQOxUnao24D
         y/uQ==
X-Gm-Message-State: APjAAAXtSIYHTJlmojteig4ehiWt9eSsgZqoXerLT74U6lbuki74I8o/
        N/YQGnR6GW57r30swWszLkWnoGrB
X-Google-Smtp-Source: APXvYqy+rP/vKEbQ1X011iDahbdEBxPlZug6tj6euYiNTm6eB9W3piJgML2XvSkdXH9DtaiMaUXjpA==
X-Received: by 2002:a17:90a:2446:: with SMTP id h64mr21795406pje.0.1560166885281;
        Mon, 10 Jun 2019 04:41:25 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id 188sm20817875pfe.30.2019.06.10.04.41.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 04:41:23 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
 <20190605053613.22888-2-toshiaki.makita1@gmail.com>
 <20190605095931.5d90b69c@carbon>
 <abd43c39-afb7-acd4-688a-553cec76f55c@gmail.com>
 <20190606214105.6bf2f873@carbon>
 <e0266202-5db6-123c-eba6-33e5c5c4ba6d@gmail.com>
 <20190607113220.1ea4093a@carbon>
Message-ID: <cf0bed1c-aa70-7c67-3735-c0137f0fbc5d@gmail.com>
Date:   Mon, 10 Jun 2019 20:41:16 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607113220.1ea4093a@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/07 18:32, Jesper Dangaard Brouer wrote:
> On Fri, 7 Jun 2019 11:22:00 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> On 2019/06/07 4:41, Jesper Dangaard Brouer wrote:
>>> On Thu, 6 Jun 2019 20:04:20 +0900
>>> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
>>>    
>>>> On 2019/06/05 16:59, Jesper Dangaard Brouer wrote:
>>>>> On Wed,  5 Jun 2019 14:36:12 +0900
>>>>> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
>>>>>       
> [...]
>>>>
>>>> So... prog_id is the problem. The program can be changed while we are
>>>> enqueueing packets to the bulk queue, so the prog_id at flush may be an
>>>> unexpected one.
>>>
>>> Hmmm... that sounds problematic, if the XDP bpf_prog for veth can
>>> change underneath, before the flush.  Our redirect system, depend on
>>> things being stable until the xdp_do_flush_map() operation, as will
>>> e.g. set per-CPU (bpf_redirect_info) map_to_flush pointer (which depend
>>> on XDP prog), and expect it to be correct/valid.
>>
>> Sorry, I don't get how maps depend on programs.
> 
> BPF/XDP programs have a reference count on the map (e.g. used for
> redirect) and when the XDP is removed, and last refcnt for the map is
> reached, then the map is also removed (redirect maps does a call_rcu
> when shutdown).

Thanks, now I understand what you mean.

>> At least xdp_do_redirect_map() handles map_to_flush change during NAPI.
>> Is there a problem when the map is not changed but the program is changed?
>> Also I believe this is not veth-specific behavior. Looking at tun and
>> i40e, they seem to change xdp_prog without stopping data path.
>   
> I guess this could actually happen, but we are "saved" by the
> 'map_to_flush' (pointer) is still valid due to RCU protection.
> 
> But it does look fishy, as our rcu_read_lock's does not encapsulation
> this. There is RCU-read-section in veth_xdp_rcv_skb(), which via can
> call xdp_do_redirect() which set per-CPU ri->map_to_flush.
> 
> Do we get this protection by running under softirq, and does this
> prevent an RCU grace-period (call_rcu callbacks) from happening?
> (between veth_xdp_rcv_skb() and xdp_do_flush_map() in veth_poll())

We are trying to avoid the problem in dev_map_free()?

	/* To ensure all pending flush operations have completed wait for flush
	 * bitmap to indicate all flush_needed bits to be zero on _all_ cpus.
	 * Because the above synchronize_rcu() ensures the map is disconnected
	 * from the program we can assume no new bits will be set.
	 */
	for_each_online_cpu(cpu) {
		unsigned long *bitmap = per_cpu_ptr(dtab->flush_needed, cpu);

		while (!bitmap_empty(bitmap, dtab->map.max_entries))
			cond_resched();
	}

Not sure if this is working as expected.

> 
> 
> To Toshiaki, regarding your patch 2/2, you are not affected by this
> per-CPU map storing, as you pass along the bulk-queue.  I do see you
> point, with prog_id could change.  Could you change the tracepoint to
> include the 'act' and place 'ifindex' above this in the struct, this way
> the 'act' member is in the same location/offset as other XDP
> tracepoints.  I see the 'ifindex' as the identifier for this tracepoint
> (other have map_id or prog_id in this location).

Sure, thanks.

Toshiaki Makita
