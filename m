Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF0626A9B3
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgIOQZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 12:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbgIOQXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:23:05 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F345C061A29;
        Tue, 15 Sep 2020 09:12:17 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id x69so4469970oia.8;
        Tue, 15 Sep 2020 09:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/3iUUyja5lm+/6wa/aCVVpjhqWNR9WtKq3mlGRCh/FI=;
        b=WlfnMRq8mnwhrnShfwfJDHHVmHnFoDXkxBIpCXd1gu4g53sNXTRmBOIDtQQ1gbfZED
         3qI8Z30KD8GeNLe/obUqGTrKUXp1IOlb07oajviyyaqxe3dmjXzAL7LMZcC1mXHs6Bsr
         hd/K+1n/BEteaHcslaVJBY7Xjm3AS5zuTs+JtKJWbSeC+hAx/uI4tUDa6uBDSEzAmaJQ
         cE+PSg+0IRpOTMEqB6wo1nyQ90mHKxScvoTJfNAzcpUVW1P50TV+CqDA6MQcpmNyQ3bo
         IRuJGrUuvi9bZliD/xvKaFWMIK9TtTGcxOtgHBNDsfBP2jj8mVTyemXBh3HeS3xdNqq9
         xF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/3iUUyja5lm+/6wa/aCVVpjhqWNR9WtKq3mlGRCh/FI=;
        b=j3mOc3pX5+slNAdrkdl7QqlYGqGJmJ0C3wf27ygJofIJQgxHsN6Icp/unYuRVyfAOR
         nzocKIRcM1oOJAbK4cdjgp8RcbhMBDy1IOlpnxarZ7Rx2tQzWTI3mAdSy3bp7WO4ADU0
         0pG7VKg8mDzv9FS4iBC6SOSI31ePRLfyFtK1lV0Aote0LFmZ5oaCxqpWC/017ph502Vs
         aDHmHA3jGBhLtaD1unqnGMcgWyHuGc4ik+EY4CfcsS5BtduKIVOoXvLkbb6gcCB8dF3N
         34OjDSzZvPXANDk/xPeIdZb/EXpt3SVazNDfMRvupDaGr/TEXF2SZFQrYYFBgQ1HZRMZ
         uhdQ==
X-Gm-Message-State: AOAM530V3782P+soh1ShqNwcoTPC7cXIy9yCL4GsahIm600QAVt7brcM
        t3iralz2oiUt2g8sAYfuESM=
X-Google-Smtp-Source: ABdhPJyeJ5lyHlqHThrax8EkokWoY/miEpBMV7UkK3kdf+uMj+cu8FhyZiUpQLKEB8oFCRsz/fKdhQ==
X-Received: by 2002:a05:6808:14f:: with SMTP id h15mr81756oie.119.1600186336591;
        Tue, 15 Sep 2020 09:12:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e439:1090:4bf9:75b6])
        by smtp.googlemail.com with ESMTPSA id b79sm6733752oii.33.2020.09.15.09.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 09:12:11 -0700 (PDT)
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
 <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
 <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
 <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
 <87o8mearu5.fsf@toke.dk> <20200910195014.13ff24e4@carbon>
 <47566856-75e2-8f2b-4347-f03a7cb5493b@gmail.com>
 <20200911095820.304d9877@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3b498f73-0a0c-bd25-d1a1-b1098ed403e2@gmail.com>
Date:   Tue, 15 Sep 2020 10:12:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911095820.304d9877@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/20 1:58 AM, Jesper Dangaard Brouer wrote:
> On Thu, 10 Sep 2020 12:35:33 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 9/10/20 11:50 AM, Jesper Dangaard Brouer wrote:
>>> Maybe we should change the devmap-prog approach, and run this on the
>>> xdp_frame's (in bq_xmit_all() to be precise) .  Hangbin's patchset
>>> clearly shows that we need this "layer" between running the xdp_prog and
>>> the devmap-prog.   
>>
>> I would prefer to leave it in dev_map_enqueue.
>>
>> The main premise at the moment is that the program attached to the
>> DEVMAP entry is an ACL specific to that dev. If the program is going to
>> drop the packet, then no sense queueing it.
>>
>> I also expect a follow on feature will be useful to allow the DEVMAP
>> program to do another REDIRECT (e.g., potentially after modifying). It
>> is not handled at the moment as it needs thought - e.g., limiting the
>> number of iterative redirects. If such a feature does happen, then no
>> sense queueing it to the current device.
> 
> It makes a lot of sense to do queuing before redirecting again.  The
> (hidden) bulking we do at XDP redirect is the primary reason for the
> performance boost. We all remember performance difference between
> non-map version of redirect (which Toke fixed via always having the
> bulking available in net_device->xdp_bulkq).
> 
> In a simple micro-benchmark I bet it will look better running the
> devmap-prog right after the xdp_prog (which is what we have today). But
> I claim this is the wrong approach, as soon as (1) traffic is more
> intermixed, and (2) devmap-prog gets bigger and becomes more specific
> to the egress-device (e.g. BPF update constants per egress-device).
> When this happens performance suffers, as I-cache and data-access to
> each egress-device gets pushed out of cache. (Hint VPP/fd.io approach)
> 
> Queuing xdp_frames up for your devmap-prog makes sense, as these share
> common properties.  With intermix traffic the first xdp_prog will sort
> packets into egress-devices, and then the devmap-prog can operate on
> these.  The best illustration[1] of this sorting I saw in a Netflix
> blogpost[2] about FreeBSD, section "RSS Assisted LRO" (not directly
> related, but illustration was good).
> 
> 
> [1] https://miro.medium.com/max/700/1%2alTGL1_D6hTMEMa7EDV8yZA.png
> [2] https://netflixtechblog.com/serving-100-gbps-from-an-open-connect-appliance-cdb51dda3b99
> 

I understand the theory and testing will need to bear that out. There is
a bit of distance (code wise) between where the program is run now and
where you want to put it - the conversion from xdp_buff
to xdp_frame, the enqueue, and what it means to do a redirect to another
device in bq_xmit_all.

More importantly though for a redirect is the current xdp_ok_fwd_dev
check in __xdp_enqueue which for a redirect could be doing the wrong
checks for the wrong device.
