Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B9FC391
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKNKGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:06:25 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37086 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfKNKGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:06:24 -0500
Received: by mail-pl1-f196.google.com with SMTP id bb5so2427955plb.4;
        Thu, 14 Nov 2019 02:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Bhp32x9nbhbHPEsHoRljvbfBFxqqECYxc/2+4xNP+Y=;
        b=n+HU8ootEZcSjKfuXZDVTK2E1l7WsBgD5gegRDywmpXI91mO123mr+yThqCnWtDHu3
         M65MPz0sTM2WVrTLGFLHSqgZsQHAJt2XQoRzySutzHzwrnhmXhlX93b/QLZ+4oS2PCML
         pq2F1kGOyT9R3466JBB+G/xmWuX2kH5tfSi0Y0F4dR1e2Axo+R6QCT4ojI3kvfrCqBMm
         NDM2XNPgmq9MAtPrMxsQoRvmFhyotE/jkknTErUvd3YEZNfvRONTrriID2QpwgmA30JP
         e4bE+yQuGoPU1VKCfkIN9Pkwhiuqh4ESQ+IwZEvOUyrQAtJU+ysD8KUmEXEdJQNdu/vY
         IV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Bhp32x9nbhbHPEsHoRljvbfBFxqqECYxc/2+4xNP+Y=;
        b=rI9sPFmtV9D2pr5sbc+yK0rmop9G7LZXZPzBx+jbZEALxR1vqMxYZ9gHtLzf9IicQv
         QjVD8CM3b49WEuGLoy0/aUbGNLx5Z4B3MwWlXjL43Au8Buy104Y16P+6pdZihu0jR9ve
         ertFhk9y4fmMWWZlGXiVwQ2m4uj1BcEuHfkbfKn5FJmE3Gvwcwe+L8haz6wswVZ75L5i
         O11RQySYRcIplaXxx9jbbsylmXypvCIWfZNdwzEiCPh4eoVsbIiRgNfTbKLlRPt8wyQd
         Wap9CUqbwClwAjLfLYDhmuu7bB4DZv1fQeYUI9WPvQP0tT26ZCY0xLtPyRwhu7UkjPVY
         6c8Q==
X-Gm-Message-State: APjAAAXUR6rtquviD5fd3jW033eGn9A2xywu0MVNj27dARCDgJof+zQI
        jaKeiy2L0Hdy2wccLPqcbOk=
X-Google-Smtp-Source: APXvYqwFygG08OeujADoSgPCyKexfUWd4nQJWwDCr3nRX2qQ9KiOuXjcsfPfbXb6LYm7VkM3VjawCA==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr8553127plk.24.1573725983927;
        Thu, 14 Nov 2019 02:06:23 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id r68sm6417614pfr.78.2019.11.14.02.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 02:06:23 -0800 (PST)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     William Tu <u9012063@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        pravin shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>
References: <87h840oese.fsf@toke.dk>
 <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com> <87wocqrz2v.fsf@toke.dk>
 <20191027.121727.1776345635168200501.davem@davemloft.net>
 <09817958-e331-63e9-efbf-05341623a006@gmail.com>
 <CALDO+SaxbNpON+=3zA4r4k6BE7UhbGU1WovW8Owyi8-9J_Wbkw@mail.gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <53538a02-e6d3-5443-8251-bef381c691a0@gmail.com>
Date:   Thu, 14 Nov 2019 19:06:16 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALDO+SaxbNpON+=3zA4r4k6BE7UhbGU1WovW8Owyi8-9J_Wbkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/13 2:50, William Tu wrote:
> On Wed, Oct 30, 2019 at 5:32 PM Toshiaki Makita
> <toshiaki.makita1@gmail.com> wrote:
>>
>> On 2019/10/28 4:17, David Miller wrote:
>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>> Date: Sun, 27 Oct 2019 16:24:24 +0100
>>>
>>>> The results in the paper also shows somewhat disappointing performance
>>>> for the eBPF implementation, but that is not too surprising given that
>>>> it's implemented as a TC eBPF hook, not an XDP program. I seem to recall
>>>> that this was also one of the things puzzling to me back when this was
>>>> presented...
>>>
>>> Also, no attempt was made to dyanamically optimize the data structures
>>> and code generated in response to features actually used.
>>>
>>> That's the big error.
>>>
>>> The full OVS key is huge, OVS is really quite a monster.
>>>
>>> But people don't use the entire key, nor do they use the totality of
>>> the data paths.
>>>
>>> So just doing a 1-to-1 translation of the OVS datapath into BPF makes
>>> absolutely no sense whatsoever and it is guaranteed to have worse
>>> performance.
> 
> 1-to-1 translation has nothing to do with performance.

I think at least key size matters.
One big part of hot spots in xdp_flow bpf program is hash table lookup.
Especially hash calculation by jhash and key comparison are heavy.
The computational cost heavily depends on key size.

If umh can determine some keys won't be used in some way (not sure if it's
practical though), umh can load an XDP program which uses less sized
key. Also it can remove unnecessary key parser routines.
If it's possible, the performance will increase.

Toshiaki Makita

> 
> eBPF/XDP is faster only when you can by-pass/shortcut some code.
> If the number of features required are the same, then an eBPF
> implementation should be less than or equal to a kernel module's
> performance. "less than" because eBPF usually has some limitations
> so you have to redesign the data structure.
> 
> It's possible that after redesigning your data structure to eBPF,
> it becomes faster. But there is no such case in my experience.
> 
> Regards,
> William
> 
