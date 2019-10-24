Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5227CE394F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410206AbfJXRF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:05:58 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36753 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407852AbfJXRF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:05:57 -0400
Received: by mail-io1-f66.google.com with SMTP id c16so10538112ioc.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n+BAD0h+2m9ghDa8apTuj0rUSTohoj4vxAV8IE+BE8s=;
        b=yn7iaPcxEgyTOND0CygF5E+xOCohTH1XDONEat+tPjHUb4T+mJpzY1A6FXb0DBvTma
         UabG3wBeirVLrW8M90GexcxMvpeDCEglAeOD42oU4iqQ82sinRoHmqtShLoxqn8Ybin7
         +N6ZR66+O5lUVQjhiDVv3uJlpoTZNnt6BIxcPw0x4C2JNshEHtNj3h5XdNVukS64Ak59
         ftbsKKRX6h0q6xnJLBhiCV7g7T5EGaTFPKXbDvXjWAF9cCwPNln2MEWs016EBNDjSKTJ
         8vQKjF8AP73nkTY2esBnBbZXPE3naGaQXH7jzkvz2Er0N+75RWvhGy5U0cdy9swgnWwr
         lN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n+BAD0h+2m9ghDa8apTuj0rUSTohoj4vxAV8IE+BE8s=;
        b=njwiwcEz2aUwck+UGrSHxoEM0/UUWN0Xp8K94DeAZ9KNRsW5zbIsqHMSqtPBlZeaLz
         Z98aK0IgUTK1FwDpUD2gnKYkyUi2jcmRb0kzDB6DC1ndVfOKmKq5AmrEySEY9WGdWXgG
         5iPgXMF1/UuGBfxJgrIew+OfUcd3VA6V1wCRMwAdGkXCTQtEXHbQm0TEV/X5z+BWplkc
         nAOYKe5F0a/nTSdn5GyaMEkgDBh5IpZY9K4vFDFEdU3tzGarQjfaA0uRuSlxCWvsegr4
         isI4MMz49fAy1y5y2fxOtW9nhuRSrSHen27MqndRhmfvOAjkVp9VtBJw3Kho5wDTZ+3d
         Lvkg==
X-Gm-Message-State: APjAAAWkU5PoGVoh5A2KfmbNC//4wJbOn63pzmWnrN/yYFcxhZus0lqZ
        e7jVM7SeFSabGov1cgJbOXRkWQ==
X-Google-Smtp-Source: APXvYqzfvJqYcLpSXuFKirV6I2UXXMzVDyniAQXnRne68iKA8Mk5nge2jlsV6kD97XqRYf02EmUoTA==
X-Received: by 2002:a02:ad1a:: with SMTP id s26mr15760423jan.61.1571936756506;
        Thu, 24 Oct 2019 10:05:56 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id e15sm6614384ilq.45.2019.10.24.10.05.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 10:05:55 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
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
 <1c794797-db6f-83a7-30b4-aa864f798e5b@mojatatu.com>
 <5db12ac278d9f_549d2affde7825b85c@john-XPS-13-9370.notmuch>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ff34648b-3c12-7a8c-381a-6f4838a202f4@mojatatu.com>
Date:   Thu, 24 Oct 2019 13:05:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5db12ac278d9f_549d2affde7825b85c@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-24 12:38 a.m., John Fastabend wrote:
> Jamal Hadi Salim wrote:
>>

[..]
> Correct, sorry was not entirely precise. I've written tooling on top of
> the netlink API to do what is needed and it worked out just fine.
> 
> I think it would be interesting (in this context of flower vs XDP vs
> u32, etc.) to build a flow API that abstracts tc vs XDP away and leverages
> the correct lower level mechanics as needed. Easier said than done
> of course.


So, IMO, the choice is usability vs performance vs expressability.
Pick 2 of 3.
Some context..

Usability:
Flower is intended for humans, so usability is higher priority.
Somewhere along that journey we lost track of reality - now all the
freaking drivers are exposing very highly perfomant interfaces
abstracted as flower. I was worried this is where this XDP interface
was heading when i saw this.

Expressability:
Flower: You want to add another tuple, sure change kernel
code, user code, driver code. Wait 3 years before the rest
of the world catches up.
u32: none of the above. Infact i can express flower using
u32.

performance:
I think flower does well on egress when the flow cache
is already collected; on ingress those memcmps are
not cheap.
u32: you can organize your tables to make it performant
for your traffic patterns.

Back to your comment:
XDP should make choices that prioritize expressability and performance.

u32 will be a good choice because of its use of hierachies of
tables for expression (and tables being close relatives of ebpf maps).
The embedded parse/match in u32 could use some refinements. Maybe in
modern machines we should work on 64 bit words instead of 32, etc.
Note: it doesnt have to be u32  _as long as the two requirements
are met_.
A human friendly "wrapper" API (if you want your 15 tuples by all means)
can be made on top. For machines give them the power to do more.

The third requirement i would have is to allow for other ways of
doing these classification/actions; sort of what tc does - allowing
many different implementations for different classifiers to coexist.
It may u64 today but for some other use case you may need a different
classifier (and yes OVS can move theirs down there too).

> But flower itself is not so old.

It is out in the wild already.

>>
>> Summary: there is value in what Toshiaki is doing.
>>
>> I am disappointed that given a flexible canvas like XDP, we are still
>> going after something like flower... if someone was using u32 as the
>> abstraction it will justify it a lot more in my mind.
>> Tying it to OVS as well is not doing it justice.
> 
> William Tu worked on doing OVS natively in XDP at one point and
> could provide more input on the pain points. But seems easier to just
> modify OVS vs adding kernel shim code to take tc to xdp IMO.
> 

Will be good to hear Williams pain points (there may be a paper out
there).

I dont think any of this should be done to cater for OVS. We need
a low level interface that is both expressive and performant.
OVS can ride on top of it. Human friendly interfaces can be
written on top.

Note also ebpf maps can be shared between tc and XDP.

> Agree but still first packets happen and introducing latency spikes
> when we have a better solution around should be avoided.
> 

Certainly susceptible to attacks (re: old route cache)

But:
If you want to allow for people for choice - then we cant put
obstacles for people who want to do silly things. Just dont
force everyone else to use your shit.

>> Hashes are good for datapath use cases but not when you consider
>> a holistic access where you have to worry about control aspect.
> 
> Whats the "right" data structure?

 From a datapath perspective, hash tables are fine. You can shard
them by having hierarchies, give them more buckets, use some clever
traffic specific keying algorithm etc.
 From a control path perspective, there are challenges. If i want
to (for example) dump based on a partial key filter - that interface
becomes a linked list (i.e i iterate the whole hash table matching
things). A trie would be better in that case.
In my world, when you have hundreds of thousands or millions of
flow entries that you need to retrieve for whatever reasons
every few seconds - this is a big deal.

> We can build it in XDP if
> its useful/generic. tc flower doesn't implement the saem data
> structures as ovs kmod as far as I know.

Generic is key. Freedom is key. OVS is not that. If someone wants
to do a performant 2 tuple hardcoded classifier, let it be.
Let 1000 flowers (garden variety, not tc variety) bloom.

cheers,
jamal
