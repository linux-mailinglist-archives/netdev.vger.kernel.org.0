Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA1EEA828
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfJaASY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:18:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37615 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfJaASY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:18:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so2697922pgi.4;
        Wed, 30 Oct 2019 17:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0kmTHfPFpdbOZHtCWVJhYouNhiCuWxfHJlg7g7Dc/aw=;
        b=UFuu+8oSWz405Kyrf092ZtZFnHK1Dw3xd/PDalFkq02Bt4TsHHOpAGrF4Dg6SU+4/Q
         lqhH7Vof2c7J+jJofpjDtcSV4Pwo+uXkiwzyWtkzpDfhstt7q6+wpuLcD6GnFBlWlOfb
         i4rf6BPsJ8vwJM6Y+32uJzIdOe8gvLl9sXlnhD6437SCC6WM8nuHZwUbGyUfQDE6oM5x
         2MjYAQIeLCe1m2Jq1xDwa91tx5dzW2oSf1qgjnmjdKJljLAnKuwRfbebsccfx3xkzMwH
         Z4ER7zCqH9yuzHcxekPiKtI1uNRBqoyARyc7GNEZWDQ+pYErBbBLsM3rW3WaZS9peNuH
         aI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0kmTHfPFpdbOZHtCWVJhYouNhiCuWxfHJlg7g7Dc/aw=;
        b=hvDFhqAQWrC03f6rp/2lmYjdfZi2Z6Xv59ZWPzzV2EXR3JWPurmH4gCZUQvVL1Jjwx
         lxjMPNR+N9RbzLEEOkfEwPQTS65YNm8SeqWvn7aisasluAZXJOp40DpO3PQMlJJ6174X
         NbkLpfpm5ACjPOLuL+WMj8hnQvvUGLFvcD1YpOMORuXhCkqHVJVN345KAycQ3EEObtLp
         C8gcQDLR1ye/FJ8UCg44yK6ZfekL6Qqlk49TVzl97ytpzS79t9UCMG+8ynMap685qccP
         5eG47CqmLHOMNnXL5JBIBDKewI0FV8bLZnyIgsbGNdNsVA9obTd+BhTmpcrZlSnvOZUg
         mQ5Q==
X-Gm-Message-State: APjAAAVk5p01IzvIQ3ahv81+/DenfR7wzyoQjRjECnZ0G5YmfNfF4225
        Iq0fl+hSyvL6LVeYzxFNXfw=
X-Google-Smtp-Source: APXvYqwXZ+ZeJuZCoj4Hnc/1lmA055V+hPN+9gnmslT/Ux9RrqDDSW5rlrAn+LI4kJxRMEa3YtBXfQ==
X-Received: by 2002:a17:90a:f00b:: with SMTP id bt11mr2667937pjb.47.1572481103933;
        Wed, 30 Oct 2019 17:18:23 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id y129sm1022329pgb.28.2019.10.30.17.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 17:18:22 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk>
 <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch>
 <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
 <87zhhmrz7w.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com>
Date:   Thu, 31 Oct 2019 09:18:15 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87zhhmrz7w.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/28 0:21, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>> Yeah, you are right that it's something we're thinking about. I'm not
>>> sure we'll actually have the bandwidth to implement a complete solution
>>> ourselves, but we are very much interested in helping others do this,
>>> including smoothing out any rough edges (or adding missing features) in
>>> the core XDP feature set that is needed to achieve this :)
>>
>> I'm very interested in general usability solutions.
>> I'd appreciate if you could join the discussion.
>>
>> Here the basic idea of my approach is to reuse HW-offload infrastructure
>> in kernel.
>> Typical networking features in kernel have offload mechanism (TC flower,
>> nftables, bridge, routing, and so on).
>> In general these are what users want to accelerate, so easy XDP use also
>> should support these features IMO. With this idea, reusing existing
>> HW-offload mechanism is a natural way to me. OVS uses TC to offload
>> flows, then use TC for XDP as well...
> 
> I agree that XDP should be able to accelerate existing kernel
> functionality. However, this does not necessarily mean that the kernel
> has to generate an XDP program and install it, like your patch does.
> Rather, what we should be doing is exposing the functionality through
> helpers so XDP can hook into the data structures already present in the
> kernel and make decisions based on what is contained there. We already
> have that for routing; L2 bridging, and some kind of connection
> tracking, are obvious contenders for similar additions.

Thanks, adding helpers itself should be good, but how does this let users
start using XDP without having them write their own BPF code?

Toshiaki Makita
