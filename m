Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4073FE78EE
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfJ1TH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:07:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34806 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfJ1TH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:07:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id b128so7548000pfa.1;
        Mon, 28 Oct 2019 12:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sWlJ7B/9Vfh+xQYxGKKS4F2uqwdNOzC/mhNw49wSeZA=;
        b=LwNpyX6nS4G0f1n0NT4S7E9jMRR5sxZSi4tQK7RiCEM6QViBr/3E1kMT8EvIZToFhi
         pCs7hC6+iY/di/OgWaKjzx9dzouoR4CBxuU/flV9T9MU1imhuV5WnYwy9Xa2jpOD6XkX
         dlXKdK8kaUCmJ3W1fh3YT7rlUYNNn93++wdfKjq0j5zYDkvAntHEwXnnx9wYUfZ5bM1d
         iwqT/KlUDSrEL8lMDdoL8GIFVLFbGaqSIAVm2aq9nrdi92MGy5szfUfdZWwSue5wD+4p
         A7fBIEXM/2l9NrE+KWREnuy/ZkrDJRPehURLsYx1+eUa4khlj11R9LGMG21QwjVjZtQp
         thyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWlJ7B/9Vfh+xQYxGKKS4F2uqwdNOzC/mhNw49wSeZA=;
        b=YOdD5f6MCCFfzgJYhXGxWg/y0CicUnhL4SE/XRzcVCsv3tI0GhFHYtjLYXx3ynPXne
         ftvfmZ0pHRLyZtc/cimsHNAlpppONmj/viJSQ9WjnfEWGwd5f/rLYhVYku/wMGk2ToIS
         X2rojV6kf91u1bwW+7O0cZQPuPhuRkvWWNTXAWhr6S5p3rhcazLJP7tihhK9SIPWkZAG
         CQuFdICAxwC/Vamhqj5nUBKeZyZaPOWlll7mhZp3GyzR6Zxl+MMkfUanApwftVtceGZ/
         F55Zjw5OK/wGdOsnZo5eDpdGWb1yZaKW8xjOCTpDakPCGXTKZZ8pTH7Z12acUajnFnbl
         qHvw==
X-Gm-Message-State: APjAAAVjWDQ97Elm0UpZFq6JUBF+cC3ridLLSk02kdG6U/G9V8xLqh9n
        HZ7k0VR2gYszNzfCOWfI5LA=
X-Google-Smtp-Source: APXvYqx4MSKJ70mZgf/paKh3ZbYyC5V9YY0iuNKWHOA2FjWmakMhBkoQmVsAYoWoq2/qrArg8RugxQ==
X-Received: by 2002:a63:a5b:: with SMTP id z27mr19262444pgk.416.1572289677196;
        Mon, 28 Oct 2019 12:07:57 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:284:8202:10b0:9e2:b1b6:1e7e:b71e])
        by smtp.googlemail.com with ESMTPSA id x190sm12799777pfc.89.2019.10.28.12.07.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:07:56 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
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
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk>
 <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch>
 <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
 <87zhhmrz7w.fsf@toke.dk> <47f1a7e2-0d3a-e324-20c5-ba3aed216ddf@gmail.com>
 <87o8y1s1vn.fsf@toke.dk> <20191028110828.512eb99c@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8b23e06d-f3b3-65b3-2aa6-363812e71817@gmail.com>
Date:   Mon, 28 Oct 2019 13:07:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028110828.512eb99c@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/19 4:08 AM, Jesper Dangaard Brouer wrote:
>>> Either way, bypassing the bridge has mixed results: latency improves
>>> but throughput takes a hit (no GRO).  
>>
>> Well, for some traffic mixes XDP should be able to keep up without GRO.
>> And longer term, we probably want to support GRO with XDP anyway
> 
> Do you have any numbers to back up your expected throughput decrease,
> due to lack of GRO?  Or is it a theory?
> 

of course. I'll start a new thread about this rather than go too far
down this tangent relative to the current patches.
