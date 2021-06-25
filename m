Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F8C3B3FAE
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFYIsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 04:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhFYIsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 04:48:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3672C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 01:45:57 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nb6so13902403ejc.10
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 01:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L+fZ++Ii8xUgIpqpH4J9mAyKQUaB3fQTBVLV3ismZgA=;
        b=WKaspDNVhkQAO97eRQbEZkXEqtcwZ79UWNqcVp87C94soOIc4KwxzoAJJjXTWSe+6Z
         viGmrA7RGXvXNOC4ofstOh4VvJWoFXLxaL8yFSf00JE1SOmgb1vYJZK1zYl1BPZUtF3W
         P9KTpYo+sk+RBeUI4wJNQnyEc/LulM5i4RlrxWUiFxlshbzT5XDpoyOpX2JdUVANpVAN
         fOatw0jk6U6+TrZJ7iRjoIQj3iGL0D5P56p2ogUwHbwU79/yA56Yk6ZqpynnDPnzI3/m
         Kl+ktv0wc4BZWlCNO6xe7hxqvc29s9v2oPV7roTsFZ6nUo/inPzt4geUH2uptEbi2KX5
         feRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L+fZ++Ii8xUgIpqpH4J9mAyKQUaB3fQTBVLV3ismZgA=;
        b=LL8gSGskYnleOgDYkLv8DaUEVtsmh4+fjX7wDvL8RMhLZq9mRQuUVnPc1GvSpOHCb1
         70orwK7HiJN+dFEVDEJyvG4iLJvjjny6Mio859QnCtXKGZPK5O1jlQ6jf8dODo4y9r3v
         l699p4/MCCjxgAzyySIKaGLb29jTKiayj1Hb1y168dQAd4NlU6sslKYfpuNULm8MSWzq
         GZa4uaOj7ER9D9blt8WRZiWAkzb4MBHXEAPPmPpSAMPqGPPZu7cz/hpSebS4r1HVeMlW
         wCvMdFwscS++WGkjPn/r8rXtdUVKHoj+OJD6nxXOJRhD0jIrzpOAP96veuSo7cs8LH1Z
         IJFQ==
X-Gm-Message-State: AOAM533bL4vGKO/2Lyp87neknkgfed9kyYw85/+j36Cl7MHajpvB6UNS
        Ac0Dmf87a0P6xmEFwc+PO9I=
X-Google-Smtp-Source: ABdhPJyZ96e8zpj4kOaEc/E07jEV//ysJqWAkb7rIyTl9LDUGeU4ukX3m+abAwMBJ/rTXQlchNDS4g==
X-Received: by 2002:a17:906:2b0a:: with SMTP id a10mr9614393ejg.521.1624610756360;
        Fri, 25 Jun 2021 01:45:56 -0700 (PDT)
Received: from [192.168.1.24] ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id l7sm3500212edc.78.2021.06.25.01.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 01:45:56 -0700 (PDT)
Subject: Re: [PATCH net] dev_forward_skb: do not scrub skb mark within the
 same name space
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        liran.alon@oracle.com, shmulik.ladkani@gmail.com,
        daniel@iogearbox.net
References: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
 <ad019c34-6b18-9bd8-047f-6688cc4a3b8b@gmail.com>
 <773bae50-3bd6-00bc-7cc6-f5eec510f0b8@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Message-ID: <2b01ec85-216a-2785-fd1c-42c38ad30c9d@gmail.com>
Date:   Fri, 25 Jun 2021 11:45:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <773bae50-3bd6-00bc-7cc6-f5eec510f0b8@6wind.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/06/2021 18:26, Nicolas Dichtel wrote:
> Hi Eyal,
> 
> Le 24/06/2021 à 14:16, Eyal Birger a écrit :
>> Hi Nicholas,
>>
>> On 24/06/2021 11:05, Nicolas Dichtel wrote:
>>> The goal is to keep the mark during a bpf_redirect(), like it is done for
>>> legacy encapsulation / decapsulation, when there is no x-netns.
>>> This was initially done in commit 213dd74aee76 ("skbuff: Do not scrub skb
>>> mark within the same name space").
>>>
>>> When the call to skb_scrub_packet() was added in dev_forward_skb() (commit
>>> 8b27f27797ca ("skb: allow skb_scrub_packet() to be used by tunnels")), the
>>> second argument (xnet) was set to true to force a call to skb_orphan(). At
>>> this time, the mark was always cleanned up by skb_scrub_packet(), whatever
>>> xnet value was.
>>> This call to skb_orphan() was removed later in commit
>>> 9c4c325252c5 ("skbuff: preserve sock reference when scrubbing the skb.").
>>> But this 'true' stayed here without any real reason.
>>>
>>> Let's correctly set xnet in ____dev_forward_skb(), this function has access
>>> to the previous interface and to the new interface.
>>
>> This change was suggested in the past [1] and I think one of the main concerns
>> was breaking existing callers which assume the mark would be cleared [2].
> Thank you for the pointers!
> 
>>
>> Personally, I think the suggestion made in [3] adding a flag to bpf_redirect()
>> makes a lot of sense for this use case.
> I began with this approach, but actually, as I tried to explain in the commit
> log, this looks more like a bug. This function is called almost everywhere in
> the kernel (except for openvswitch and wireguard) with the xnet argument
> reflecting a netns change. In other words, the behavior is different between
> legacy encapsulation and the one made with ebpf :/
> 

I agree, and was also surprised that ebpf redirection scrubs the mark in 
the same ns - and only on ingress! - so I think keeping the mark should 
have been the default behavior. As noted in the thread though it is not 
clear whether this would break existing deployments both for ebpf and 
veth pairs on the same ns.

Eyal.
