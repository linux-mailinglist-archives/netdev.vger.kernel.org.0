Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300229EC05
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbfH0PJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:09:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36139 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbfH0PJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:09:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so1336304wrd.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 08:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DMZGJAwNwAX8535R0QCgIYQTSaOGxf6RD2QAMRLxdQY=;
        b=eewJUspCA3HDtR5KizGmFgT01tk2N7+qgpvJpOMgz0CxorOWblCVFy6ZDNDqxPlvn7
         MvuZPPkk+Kphzps5JFkYa9KzXkz/uYTjS47mECdg0593oqW8BgC/PRkyPjnJS2zZcuTg
         rErtFWE/gXL9opR2PvnjAZAAOTtObO/0JMiBL5t7cUziHaY9TIDUMJ8Pv4g93CS+ko0e
         O3L5xjCdbja1AI5nhq9tPZ8wfCV7C/X+Nes4wTUmL2904nsxBABR+p/JbX36BlVDtUCX
         gsELfk6DpU/uq7Yd7IKKvHj/UCSA/prZai7fd3LKbGsAtIiFMIHWGrqDgoNtOzuH0vdV
         aCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DMZGJAwNwAX8535R0QCgIYQTSaOGxf6RD2QAMRLxdQY=;
        b=mYA0XnVlJTiEpRkaW7Pxemet9pz9y4bYuDL80asK+KN3jlbif3gPUakt0UIj+OGvOS
         yCM7hpp9AOHZ5HUaKvsapDHDHu1SD1AyFYkLzwsjF5Bb/xqQ1hw/mRT+Gg4gRcuHgTPU
         wliUg9w9wWCQCnM0l2p7zo6IqZrsMMsRAaPNmpfUswoHwERspH4HEFfNRjAG9Dl+pMvM
         xaI6ZHE8yT0wgU4M2ooCQVmKZ3TjBjDmGsy3P7Y6hHSx0KKFyaScpf1pHHOZYwTLmDnU
         PQ3KPhHOEGBM9yv//Gf9VoY40+QqGX52pybn/Il8e4e1Z5g0Jdy43m1pMoaSmzZg+7yD
         VFWQ==
X-Gm-Message-State: APjAAAVuu0lWwu0zNQ1WKsJa6Ilkmblx4XI/G0JM+o6Kt8nJSfQ2fJtl
        YiIC5zLp5kEcVeHcsBhqpvI=
X-Google-Smtp-Source: APXvYqwWiqqA0q60m8uF+h7bv4mqZiZ2oAmA93IyroKodbjnN+Aw+lS25iJjSKo1+cVU7ZOZJjDW5A==
X-Received: by 2002:a5d:4250:: with SMTP id s16mr29892253wrr.318.1566918561299;
        Tue, 27 Aug 2019 08:09:21 -0700 (PDT)
Received: from [192.168.8.147] (212.160.185.81.rev.sfr.net. [81.185.160.212])
        by smtp.gmail.com with ESMTPSA id e15sm14703163wrj.74.2019.08.27.08.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 08:09:20 -0700 (PDT)
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
To:     Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
References: <20190826170724.25ff616f@pixies>
 <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
 <20190827144218.5b098eac@pixies>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c1f23529-2481-62fd-ba08-34df8368a95c@gmail.com>
Date:   Tue, 27 Aug 2019 17:09:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827144218.5b098eac@pixies>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/19 1:42 PM, Shmulik Ladkani wrote:
> On Mon, 26 Aug 2019 19:47:40 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> On 8/26/19 4:07 PM, Shmulik Ladkani wrote:
>>>   - ipv4 forwarding to dummy1, where eBPF nat4-to-6 program is attached
>>>     at TC Egress (calls 'bpf_skb_change_proto()'), then redirect to ingress
>>>     on same device.
>>>     NOTE: 'bpf_skb_proto_4_to_6()' mangles 'shinfo->gso_size'  
>>
>> Doing this on an skb with a frag_list is doomed, in current gso_segment() state.
>>
>> A rewrite  would be needed (I believe I did so at some point, but Herbert Xu fought hard against it)
> 
> Thanks Eric,
> 
> - If a rewrite is still considered out of the question, how can one use
>   eBPF's bpf_skb_change_proto() safely without disabling GRO completely?
>   - e.g. is there a way to force the GROed skbs to fit into a layout that is
>     tolerated by skb_segment?
>   - alternatively can eBPF layer somehow enforce segmentation of the
>     original GROed skb before mangling the gso_size?
> 
> - Another thing that puzzles me is that we hit the BUG_ON rather rarely
>   and cannot yet reproduce synthetically. If skb_segment's handling of
>   skbs with a frag_list (that have gso_size mangled) is broken, I'd expect
>   to hit this more often... Any ideas?

skb_segment of a gro packet (especially with frag_list) is only supported 
if the geometry of the individual segments is not changed,
meaning that gso_size must remain the same.

> 
> - Suppose going for a rewrite, care to elaborate what's exactly missing
>   in skb_segment's logic?
>   I must admit I do not fully understand all the different code flows in
>   this function, it seems to support many different input skbs - any
>   assistance is highly appreciated.

Well, this is the point really.
The complexity of this function is so high that very few of us dare to touch it.
