Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4337DFC66
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 05:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387555AbfJVD5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 23:57:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39056 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbfJVD5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 23:57:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so9102924pgn.6
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 20:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Xqw9jIzdr9kEmlP6Qa1vP520SJNgASJ1uJrEUIyd2zM=;
        b=KHpvr9zNYR3qWg8QnGO5oksDmaa7lZKdg+//l8kLO0fCy6ozbifZa6jp2X+selSH0U
         GEP3ufGxW6PHGYI+1QS1x7A+vCkOhovbSuj6ETFsbIaVdXzNlCNPkE/k0V+rR2+n1sUu
         jk0T0dUDglZStMf2QT78LOBPgu9iTshSScJo1eiDuZSVrA2vR5cptNJi4nYVMuNqFHL6
         FqW57cUwrERns8meAfaR2atjr9CkNDhwiMkyRDdeUUWF50oF3ce2/qtju7UX6TcDRdxW
         +8MkgZ2bfpPJrrDFEtpI8NY/geiAkbQ99Occf5ap92inVlOXWX1wSfF4MfuuQExiekJf
         KQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xqw9jIzdr9kEmlP6Qa1vP520SJNgASJ1uJrEUIyd2zM=;
        b=C8l2hjiqcmOFViW8R97yfZP1otiS8XCQ9678DE/WzxIl/t0h/4cCdeH3D6q2jG8LJA
         kp+asnjHbuLgFoCYEyqEIy+8tc78wPf5QEWiZo4fxvFI9gULvrts3sPMkKk0eGfgPmV8
         LuYyUhZSFtWlEK8fL6hKXAuiydgz0FFtsarXEUk53P4ZcwuQGYYzFhjAA+8qIJiSc65n
         iY0o9AOSXKf3UAuf/acmdxuRhixAGxndh8zW/JXtY0Q08uGXwQhkoB05zebQFDJjm2uy
         szRNsikVVQ8xZjC4DTa8y7xRQxEcd1QIe1cuk0/hqMKGeXnvktr+W5bmN4OpcQVcTw2S
         BxIQ==
X-Gm-Message-State: APjAAAXSHXX4fRYHY2mk4SHpuPip9MjtPSOAM6TCmUSDY7gohcNIAOFU
        JvXN+Hyjsje5gPuzxBEJrHckB6RY
X-Google-Smtp-Source: APXvYqxozpnihMww9wjWrDJd4U0rNyITGA2JDBhGZdXC/ZubP/4aOUfLQdFYJ6+zb+YOc2s4oMJFZg==
X-Received: by 2002:a63:6f02:: with SMTP id k2mr1446900pgc.163.1571716672167;
        Mon, 21 Oct 2019 20:57:52 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id i1sm17538192pfg.2.2019.10.21.20.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 20:57:51 -0700 (PDT)
Subject: Re: [net-next] tipc: improve throughput between nodes in netns
To:     Hoang Le <hoang.h.le@dektech.com.au>,
        'Eric Dumazet' <eric.dumazet@gmail.com>,
        jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
References: <20191022022036.19961-1-hoang.h.le@dektech.com.au>
 <88e00511-ae7f-cbd3-46b1-df0f0509c04e@gmail.com>
 <004401d58889$8a3ba740$9eb2f5c0$@dektech.com.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3380c6dc-9988-9c67-261a-d6f7d68c7cc7@gmail.com>
Date:   Mon, 21 Oct 2019 20:57:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <004401d58889$8a3ba740$9eb2f5c0$@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/19 8:33 PM, Hoang Le wrote:
> Hi Eric,
> 
> Thanks for quick feedback.
> See my inline answer.
> 
> Regards,
> Hoang
> -----Original Message-----
> From: Eric Dumazet <eric.dumazet@gmail.com> 
> Sent: Tuesday, October 22, 2019 9:41 AM
> To: Hoang Le <hoang.h.le@dektech.com.au>; jon.maloy@ericsson.com; maloy@donjonn.com; tipc-discussion@lists.sourceforge.net; netdev@vger.kernel.org
> Subject: Re: [net-next] tipc: improve throughput between nodes in netns
> 
> 
> On 10/21/19 7:20 PM, Hoang Le wrote:
>>  	n->net = net;
>>  	n->capabilities = capabilities;
>> +	n->pnet = NULL;
>> +	for_each_net_rcu(tmp) {
> 
> This does not scale well, if say you have a thousand netns ?
> [Hoang] This check execs only once at setup step. So we get no problem with huge namespaces.
> 
>> +		tn_peer = net_generic(tmp, tipc_net_id);
>> +		if (!tn_peer)
>> +			continue;
>> +		/* Integrity checking whether node exists in namespace or not */
>> +		if (tn_peer->net_id != tn->net_id)
>> +			continue;
>> +		if (memcmp(peer_id, tn_peer->node_id, NODE_ID_LEN))
>> +			continue;
>> +
>> +		hash_chk = tn_peer->random;
>> +		hash_chk ^= net_hash_mix(&init_net);
> 
> Why the xor with net_hash_mix(&init_net) is needed ?
> [Hoang] We're trying to eliminate a sniff at injectable discovery message. 
> Building hash-mixes as much as possible is to prevent fake discovery messages.
> 
>> +		hash_chk ^= net_hash_mix(tmp);
>> +		if (hash_chk ^ hash_mixes)
>> +			continue;
>> +		n->pnet = tmp;
>> +		break;
>> +	}
> 
> 
> How can we set n->pnet without increasing netns ->count ?
> Using check_net() later might trigger an use-after-free.
> 
> [Hoang] In this case, peer node is down. I assume the tipc xmit function already bypassed these lines.
> 

I assume nothing. I prefer evidences :)

It seems that the netns could go down later, you need some
kind of notifier to be able to purge queues/objects having a pointer to a dismantling netns.

Keeping pointers without proper refcount (get_net() or maybe_get_net()) is a recipe for disasters.
