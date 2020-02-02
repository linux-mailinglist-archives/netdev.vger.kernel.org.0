Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90AB14FEA8
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgBBRoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 12:44:02 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44013 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgBBRoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 12:44:02 -0500
Received: by mail-il1-f195.google.com with SMTP id o13so10628214ilg.10
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 09:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X9Bzxi78KuroggKIkCWwqPOlae+7gqbtQfDV8S6QaP0=;
        b=Tqq/8mLtdZIDC1aV5hQKvl4K2ZjM3BFaUtiH14amA64/YH04mvykuzAzwcsuVj2A+l
         9EC9ilkU1CT8LxKFKq8GH/t57PMKGwK43jtsY6UFjkB+4tVPUEPUan49NJYfxrKxX8uR
         6ryliGffQ57PIk8IhcPNevnv5jP7UTInqE0CdRCt/rbYP6UsMC+wZ4K/y8/VOukF3QSL
         Pd5Sw6L9LP6YuiSEailvKXPjnGnha5SOTvcK27Rsv3fHK2p7SjNpe6Viurx1C0veYcPw
         mqnzSxINAqXf2gYvl3HV7U+toJf/UVscvUzpAZFcnUZ6Uf5KcahnAfalkMIZJVRxinxB
         IklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X9Bzxi78KuroggKIkCWwqPOlae+7gqbtQfDV8S6QaP0=;
        b=BzvvqhPYbyQ1Nc5cCoJtcXynYHlHstNrn0dgsctIoid8o01coYYH8UjXLDwo57kKd8
         JHQLyrNcAq8OUwogbW+ZRmIYaRLkzuOYgvjPEXob8ruRCmHfL0vxkwIGxu6sGg7lQAGz
         JBNjPu7hTzxEKOiHi9wuoDQ6GIVCghXZ1PeFXM5g0Q57L9nBLkbVLXiAo+Q9jgSDqLzW
         lCdd/f1wftzriTe6ku6OftuPg16f8v4NGem+C25toiK/xaJHWdqDLO9ocbEVdTe704bZ
         kpwUPzClie201/5AAzWp26EzQjNWo6RIH8BHrNGrlIWSrN0UuoUQgffzi1Bu766ARKHd
         FsAQ==
X-Gm-Message-State: APjAAAVycr+IKaIReQbkVSyNPmRkwaQfXjszEV0YrgaCt/vilP2BkbQF
        eyqdWDwkG0+vqVu3Vw3QbrE=
X-Google-Smtp-Source: APXvYqwLYHZtGOrEngrIQi9YgEBJu+O5Kt2KfyQ4TWZgVrYdpht7fGIsRVAkcfmTvdicfAIwthBZ8A==
X-Received: by 2002:a92:860a:: with SMTP id g10mr18068349ild.280.1580665441721;
        Sun, 02 Feb 2020 09:44:01 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id w5sm4656204iob.26.2020.02.02.09.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 09:44:00 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126141141.0b773aba@cakuba>
 <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
 <20200127061623.1cf42cd0@cakuba>
 <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
 <20200128055752.617aebc7@cakuba>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e3f52be9-e5c8-ba4f-dd99-ddcc5d13bc91@gmail.com>
Date:   Sun, 2 Feb 2020 10:43:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200128055752.617aebc7@cakuba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/20 6:57 AM, Jakub Kicinski wrote:
> On Mon, 27 Jan 2020 20:43:09 -0700, David Ahern wrote:
>>> end of whatever is doing the redirect (especially with Alexei's work   
>>
>> There are use cases where they may make sense, but this is not one.
>>
>>> on linking) and from cls_bpf 🤷‍♂️
>>
>> cls_bpf is tc based == skb, no? I want to handle any packet, regardless
>> of how it arrived at the device's xmit function.
> 
> Yes, that's why I said you need the same rules in XDP before REDIRECT
> and cls_bpf. Sure it's more complex, but (1) it's faster to drop in
> the ingress prog before going though the entire redirect code and
> without parsing the packet twice and (2) no extra kernel code necessary.

you are making a lot of assumptions and frankly it's the 'c' word
(complex) that I want to avoid. I do not believe in the OVS style of
packet processing - one gigantic program with a bunch of logic and data
driven flow lookups that affect every packet. I prefer simple, singly
focused programs logically concatenated to make decisions. Simpler
management, simpler lifecycle. The scope, scale and lifecycle management
of VMs/containers is just as important as minimizing the cycles spent
per packet. XDP in the Tx path is a missing primitive to make life simple.

As an example, the program on the ingress NICs to the host can be
nothing more than a demux'er - use the ethernet header and vlan
(preferably with vlan offload enabled) to do a <vlan,mac> lookup. No
packet parsing at all at this level. The lookup returns an index of
where to redirect the packet (e.g., the tap device of a VM). At the same
time, packets can hit the "slow path" - processing support from the full
stack when it is needed and still packets end up at the tap device. *IF*
there is an ingress ACL for that tap device managed by the host, it can
exist in 1 place - a program and map attached to the tap device limited
to that tap device's networking function (VMs can have multiple
connections to different networks with different needs at this point),
and the program gets run for both XDP fast path and skb slow path.
