Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D675D3B45C2
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 16:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhFYOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 10:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhFYOjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 10:39:20 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12704C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 07:36:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d11so10908055wrm.0
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 07:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A0E3pSDkLfYCboHxYqwHDLZbIFP5PlugYpHieNhdQAw=;
        b=FAIHhdKKllJHF5CshRRd+lsMpyhAG7TeyTCYuMCvkqmjBWVoi2euN/tlC/ArjQhKNa
         7eulQw4HwBy3vtlPHwyadqmTdXSqcgAJfsXBBwXSWEwYFxyEdINgIivH30iwPGTHmjFE
         D2qWvr0Fzhh+f7oEUHYMIgl2ctvmGz5r2q+6Ced0VBma9Q42UsUcpKXTUhqv3n9rmeOZ
         tocPpxr+qRKzR4fGDh6dl4huIio30g645eAJGJu9fMt8sqqTOxOtw4NwWljGS0evYK7y
         +Lw0XFkwTHby0XS1/Gw0nCEtLtGJr0QdEcfWs8LaSpflHbUBCdXsHaBbptqaS/cGHvy8
         AB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=A0E3pSDkLfYCboHxYqwHDLZbIFP5PlugYpHieNhdQAw=;
        b=Z/65NTrR2b3u198Pub3u5WPaEid+otIBKl9kZ4S/auKcFmuEwOoKL8KWHyI5ADg0Yz
         bSbz/xDml6R+o9Yyr4zTy91JQaU0E2hB2s+wS1lqdsMZniZF7pD1hkP+CQ3Wz6nmLjfW
         yoCRUJF88YtcQgawEOPSPd7hKn4ya/nATkhuKQmYWQlPfC+aFQmh7RPUnGkVR+9J84Hg
         cHiTlXYrLG9tchDd8E0jIKFxf+sY7wh3IgQU+70oaIt8WW9+FFqNo0BiuJ17jKQb1o93
         Tk5LHDD00b8bsqK9nm6b+yKwjDBKIHbktsNL8EK8ksU21lSttqlbkxXSww8kV/qCCZXe
         0ddA==
X-Gm-Message-State: AOAM532XBBDl2MHBi06VU0aZQOqPd1ENj1gr5ZP95y7WdEpTw+NAe8eS
        0z3OujbQUBjZTOy3OmCCr4WNxA==
X-Google-Smtp-Source: ABdhPJxgmB1hKi7at4a1wWrHxkfFUKkEdc50d0LpApqWj3IQWDKcKikPTtl1IcarNjmfTAkDAMQU/g==
X-Received: by 2002:a5d:6d8b:: with SMTP id l11mr11335816wrs.21.1624631817553;
        Fri, 25 Jun 2021 07:36:57 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:48d1:d5b6:5b87:8a6e? ([2a01:e0a:410:bb00:48d1:d5b6:5b87:8a6e])
        by smtp.gmail.com with ESMTPSA id o203sm6586361wmo.36.2021.06.25.07.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 07:36:56 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] dev_forward_skb: do not scrub skb mark within the
 same name space
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        liran.alon@oracle.com, shmulik.ladkani@gmail.com,
        daniel@iogearbox.net
References: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
 <ad019c34-6b18-9bd8-047f-6688cc4a3b8b@gmail.com>
 <773bae50-3bd6-00bc-7cc6-f5eec510f0b8@6wind.com>
 <2b01ec85-216a-2785-fd1c-42c38ad30c9d@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6e28a019-db7c-1916-2842-cae9bc249872@6wind.com>
Date:   Fri, 25 Jun 2021 16:36:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2b01ec85-216a-2785-fd1c-42c38ad30c9d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/06/2021 à 10:45, Eyal Birger a écrit :
> 
> 
> On 24/06/2021 18:26, Nicolas Dichtel wrote:
>> Hi Eyal,
>>
>> Le 24/06/2021 à 14:16, Eyal Birger a écrit :
>>> Hi Nicholas,
>>>
>>> On 24/06/2021 11:05, Nicolas Dichtel wrote:
>>>> The goal is to keep the mark during a bpf_redirect(), like it is done for
>>>> legacy encapsulation / decapsulation, when there is no x-netns.
>>>> This was initially done in commit 213dd74aee76 ("skbuff: Do not scrub skb
>>>> mark within the same name space").
>>>>
>>>> When the call to skb_scrub_packet() was added in dev_forward_skb() (commit
>>>> 8b27f27797ca ("skb: allow skb_scrub_packet() to be used by tunnels")), the
>>>> second argument (xnet) was set to true to force a call to skb_orphan(). At
>>>> this time, the mark was always cleanned up by skb_scrub_packet(), whatever
>>>> xnet value was.
>>>> This call to skb_orphan() was removed later in commit
>>>> 9c4c325252c5 ("skbuff: preserve sock reference when scrubbing the skb.").
>>>> But this 'true' stayed here without any real reason.
>>>>
>>>> Let's correctly set xnet in ____dev_forward_skb(), this function has access
>>>> to the previous interface and to the new interface.
>>>
>>> This change was suggested in the past [1] and I think one of the main concerns
>>> was breaking existing callers which assume the mark would be cleared [2].
>> Thank you for the pointers!
>>
>>>
>>> Personally, I think the suggestion made in [3] adding a flag to bpf_redirect()
>>> makes a lot of sense for this use case.
>> I began with this approach, but actually, as I tried to explain in the commit
>> log, this looks more like a bug. This function is called almost everywhere in
>> the kernel (except for openvswitch and wireguard) with the xnet argument
>> reflecting a netns change. In other words, the behavior is different between
>> legacy encapsulation and the one made with ebpf :/
>>
> 
> I agree, and was also surprised that ebpf redirection scrubs the mark in the
> same ns - and only on ingress! - so I think keeping the mark should have been
Yes, there is also this asymmetry :/

> the default behavior. As noted in the thread though it is not clear whether this
> would break existing deployments both for ebpf and veth pairs on the same ns.
To summarize:
 - it's not consistent between legacy tunnels and ebpf;
 - it's not consistent between ingress and egress;
 - it was already fixed in the past for legacy tunnel (commit 213dd74aee76);
 - this kind of patch has already been done in the past, see commit
   + 963a88b31ddb ("tunnels: harmonize cleanup done on skb on xmit path");
   + ea23192e8e57 ("tunnels: harmonize cleanup done on skb on rx path");
 - nobody stated (on netdev at least) that he relied on this behavior.

For all those reasons, I'm inclined to think that this patch is acceptable.
Obviously, it's not my decision ;-)

Note also that clearing the mark is possible directly in the ebpf prog,
preserving it not. It means that, in the worst case of someone relying on this,
the bug can be fixed without patching the kernel. A trade-off could be to reset
the mark in the veth case only.

Side note: the mark was not cleared (for veth) between 2.6.34 and 3.4, see
commit 59b9997baba5 ("Revert "net: maintain namespace isolation between vlan and
real device"") and the revert was not done due to this ;-)

Comments are welcomed.

Regards,
Nicolas
