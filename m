Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E7F230E52
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgG1Pqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730856AbgG1Pqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:46:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C613C0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:46:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a5so8800745wrm.6
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=XD0d5QXUUCCiQ17DpKpOOhwkA33fTfUA3cnj8lk2NFs=;
        b=uh5iUc77TzpEs7ounoSkOWoiFdepboC/+V80joyNUwB55VH9k0mS2aQTUeGlqk2Qut
         E7awvEAFZy/95XoLs5k1ErFsuKzCUIe9jw+t23bspMzOw78BdXrQoNlmDtOg5zx1Crm6
         vWcvLYLNwxu13TntZ929XjV1/y86xUveSeXU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=XD0d5QXUUCCiQ17DpKpOOhwkA33fTfUA3cnj8lk2NFs=;
        b=BM1ESxbeQ2whxjr6pVpZ8NzBGqdKnp/vjV7NNvDSFN+g6GLRCKAdIBm697IQXDpOpG
         mLmLcT46117CzuncApv/ZXrpoZXT07ZGxUdhRJqAxd0mBbH8hrIJx+r/y5GfHT0DcvjT
         useFSzFHkoQJZX+Sox0L1pVp+rOdS8Bfmu/dD3EDOsqLSNXTJYOck9Mu/ntKyteptbB8
         Xy5Wia4JALJ2QndRnRKEeL3n3O/KinKSViXuNjSMGgeUi/vh3h0i2S5qEWCEut9ZvB5s
         al3UkMvevt/2+Heimn65gwuk9JuvpHzWc4fbXv6Jst7DGKgCaTCIH75DMiQFaUGb/1dY
         ncrA==
X-Gm-Message-State: AOAM531/dY3cnu4DdUpzSWqcb4kq4e69841/vbn4KXrc8XJG6mtDg1tf
        lA8+C0TNDNn1ZA1bCGfH16F6r/jEJgw=
X-Google-Smtp-Source: ABdhPJxcE+SjAxPp+DvLZHhVL84pPZ81MseMNMQrmffv3jEeS5zhzMbLmBwaXepQN0ytxT02T/690A==
X-Received: by 2002:a5d:66c7:: with SMTP id k7mr25049396wrw.290.1595951192156;
        Tue, 28 Jul 2020 08:46:32 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q4sm5084982wme.31.2020.07.28.08.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 08:46:30 -0700 (PDT)
References: <20200726120228.1414348-1-jakub@cloudflare.com> <20200728012042.r3gkkeg6ib3r2diy@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] udp, bpf: Ignore connections in reuseport group after BPF sk lookup
In-reply-to: <20200728012042.r3gkkeg6ib3r2diy@kafai-mbp>
Date:   Tue, 28 Jul 2020 17:46:29 +0200
Message-ID: <87pn8fwskq.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 03:20 AM CEST, Martin KaFai Lau wrote:
> On Sun, Jul 26, 2020 at 02:02:28PM +0200, Jakub Sitnicki wrote:
>> When BPF sk lookup invokes reuseport handling for the selected socket, it
>> should ignore the fact that reuseport group can contain connected UDP
>> sockets. With BPF sk lookup this is not relevant as we are not scoring
>> sockets to find the best match, which might be a connected UDP socket.
>>
>> Fix it by unconditionally accepting the socket selected by reuseport.
>>
>> This fixes the following two failures reported by test_progs.
>>
>>   # ./test_progs -t sk_lookup
>>   ...
>>   #73/14 UDP IPv4 redir and reuseport with conns:FAIL
>>   ...
>>   #73/20 UDP IPv6 redir and reuseport with conns:FAIL
>>   ...
>>
>> Fixes: a57066b1a019 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>> Cc: David S. Miller <davem@davemloft.net>
>> Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  net/ipv4/udp.c | 2 +-
>>  net/ipv6/udp.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> index 7ce31beccfc2..e88efba07551 100644
>> --- a/net/ipv4/udp.c
>> +++ b/net/ipv4/udp.c
>> @@ -473,7 +473,7 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
>>  		return sk;
>>
>>  	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
>> -	if (reuse_sk && !reuseport_has_conns(sk, false))
>> +	if (reuse_sk)
>>  		sk = reuse_sk;
>>  	return sk;
>>  }
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index c394e674f486..29d9691359b9 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -208,7 +208,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
>>  		return sk;
>>
>>  	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
>> -	if (reuse_sk && !reuseport_has_conns(sk, false))
>> +	if (reuse_sk)
> From __udp[46]_lib_lookup,
> 1. The connected udp is picked by the kernel first.
>    If a 4-tuple-matched connected udp is found.  It should have already
>    been returned there.
>
> 2. If kernel cannot find a connected udp, the sk-lookup bpf prog can
>    get a chance to pick another socket (likely bound to a different
>    IP/PORT that the packet is destinated to) by bpf_sk_lookup_assign().
>    However, bpf_sk_lookup_assign() does not allow TCP_ESTABLISHED.
>
>    With the change in this patch, it then allows the reuseport-bpf-prog
>    to pick a connected udp which cannot be found in step (1).  Can you
>    explain a use case for this?

It is not intentional. It should not allow reuseport to pick a connected
udp socket to be consistent with what sk-lookup prog can select. Thanks
for pointing it out.

I've incorrectly assumed that after acdcecc61285 ("udp: correct
reuseport selection with connected sockets") reuseport returns only
unconnected udp sockets, but thats not true for bpf reuseport.

So this patch fixes one corner base, but breaks another one.

I'll change the check to the below and respin:

-	if (reuse_sk && !reuseport_has_conns(sk, false))
+	if (reuse_sk && reuse_sk->sk_state != TCP_ESTABLISHED)

Thanks,
-jkbs
