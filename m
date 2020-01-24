Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEE614864F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390011AbgAXNov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:44:51 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42800 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387812AbgAXNou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:44:50 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so1067054pgb.9
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 05:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s6PxGpsdei4mPSsKIa+9lDhkJAUuwFK7YQ3iWXGAzYk=;
        b=G0LzhxHaiiOVSEMdMyzTAdyeor3HVzhIkykf4d0umLakriDN5Dq8U/c22Zg0CpKccx
         LHe1uuZl5rXSGXkeQsMMFM5s6hZ0t9bcMrURwIdHElIBC3FxoUJ9T2HdKx6MEyJbJ88b
         HIZ9t51c+zGvMOIlJ0VDDLbdoCI+91UqDRjn3sh4yw9xFFhIXDgygzjyjz/ARLtq7lUI
         EhPv83kqn21kDDSgsNiegM1wtqfRfn/D3frw76lI5n1+NGRQ27k3ogaa21kvnpKpyKJn
         yHMTta8cThsq/JbK+u6FkWuhb7UBWearBxNiAq9KOW/ZN6nHdQ3PQe2mgsKAMpkB2prn
         Ytig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6PxGpsdei4mPSsKIa+9lDhkJAUuwFK7YQ3iWXGAzYk=;
        b=DurWWm9KhN396aaBLzIrTAZxEc8OhJe22vIi54LVZOtOjnGIQinvi6xoPEsau+bopw
         k7BF6zdMGPS7PgirKdYzz72R1LnYTkqyxGKEMGgXifn3UXWHUWeb3tFBX+myrSHu0hKX
         Rr+9xwwhe8H/4iCBOgo+Dym7tJPaXoDS1IoPh88DkyhvuXO53LRHyRLHfV0uGNr09kA7
         R4ieWIeorpgXw0K1tyvazgEIGPTlAhXrD/C0GlZDIo2+nDK25VYJHXirFOl2fuBO8f48
         U94nhf0NPBd+TmH7xjBhSOPXeI/L7ruMOOze4j1VcbHY8q6fHafRk/OEwJwJy0nL+n+q
         Ql1A==
X-Gm-Message-State: APjAAAU+NeCSyulaLb8cbx7BN2qXCcFHbljWGup5SaBLs6m69sdjawS7
        UNoadjmI8Ah17Mi1gOHFGow=
X-Google-Smtp-Source: APXvYqxYcdZclbMiDnscuxt3jznPM9Z1acVIuR6pApoa/GEO6d5JslsPqlElABCdCOclWkw6OGL82A==
X-Received: by 2002:a63:cf14:: with SMTP id j20mr4145897pgg.430.1579873490195;
        Fri, 24 Jan 2020 05:44:50 -0800 (PST)
Received: from [192.168.1.56] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id j14sm6668124pgs.57.2020.01.24.05.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 05:44:49 -0800 (PST)
Subject: Re: [PATCH bpf-next 10/12] tun: run XDP program in tx path
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, jbrouer@redhat.com, toke@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-11-dsahern@kernel.org>
 <20200123032154-mutt-send-email-mst@kernel.org>
From:   Prashant Bhole <bholeprashant.oss@gmail.com>
Message-ID: <7b57f755-604a-5e23-0c83-6b80cd913b3c@gmail.com>
Date:   Fri, 24 Jan 2020 22:44:43 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123032154-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2020 5:23 PM, Michael S. Tsirkin wrote:
> On Wed, Jan 22, 2020 at 06:42:08PM -0700, David Ahern wrote:
>> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>>
>> Run the XDP program as soon as packet is removed from the ptr
>> ring. Since this is XDP in tx path, the traditional handling of
>> XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
>> do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
>> just runs the program and leaves the action handling to us.
>>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   drivers/net/tun.c | 153 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 150 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c

[...]

>> +static int tun_consume_packets(struct tun_file *tfile, void **ptr_array, int n)
>> +{
>> +	void **pkts = tfile->pkt_ptrs;
>> +	struct xdp_frame *frame;
>> +	struct tun_struct *tun;
>> +	int i, num_ptrs;
>> +	int pkt_cnt = 0;
>> +	void *ptr;
>> +	u32 act;
>> +	int batchsz;
>> +
>> +	if (unlikely(!tfile))
>> +		return 0;
>> +
>> +	rcu_read_lock();
>> +	tun = rcu_dereference(tfile->tun);
>> +	if (unlikely(!tun)) {
>> +		rcu_read_unlock();
>> +		return 0;
>> +	}
>> +
>> +	while (n) {
>> +		batchsz = (n > MAX_TAP_BATCH) ? MAX_TAP_BATCH : n;
>> +		n -= batchsz;
>> +		num_ptrs = ptr_ring_consume_batched(&tfile->tx_ring, pkts,
>> +						    batchsz);
>> +		if (!num_ptrs)
>> +			break;
> 
> Can't we avoid looping over the packets in the current case
> where there are no xdp programs at all?

That's doable. Thanks.

Prashant
