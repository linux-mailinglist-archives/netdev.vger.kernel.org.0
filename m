Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3711E629F
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 14:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJ0NTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 09:19:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37481 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfJ0NT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 09:19:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id p13so3980914pll.4;
        Sun, 27 Oct 2019 06:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aqiPAQOQdhVbPzRrIVxnYSbImQng6lfDfF1oCvH5oYg=;
        b=IVXKSePxzJ1AjT1zoV9GLId9GJlxFy+W1Z/7LUjDXMBUJ0/bQxQx6lE4CqhPy2dOo1
         eR9YFSVukFk0BPWCCPP3JuDDOuEMOlWlERpZ/KoMfdatHHDcMZstsCIO7EtkGPSCs1Br
         WOLZRJdsSTtHI6jYGFk0iMp9KVkOzIdAKxk03VFZUFgDwDuRpB0F7aKbty+0licDEe59
         bglKotw2vFVzRQcFJNEfApEVqia0/WMsTGF2DSnAlHurf1JjXR3DK3KGsWEut3t82hvO
         vwAux1ZWr1JjylImNvLEMSGJXcRou6LhowIHXfZzjx4S9J8M9/i8wX15EYYj6V0XBelx
         j//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqiPAQOQdhVbPzRrIVxnYSbImQng6lfDfF1oCvH5oYg=;
        b=Tcvo6H9jPou4rXg/y1JlMXxM3/liOfllHEs5BhkYl1xmd+zY2XqLRpYzaWVzJKB/Bd
         VbmW5aq3SDi3rhMXRRkZDmwgHVjENB10MEh7pk5Q9yKFyPO9vDCDi9mhapHbyRHUW4FZ
         wPzdBrMCe1ii8N0WCPl7a3VYzEU9tRd/nu7NSAWxR6sGeAa1V1umgQa7mA95WZj4UCBA
         vu3RGeZSsQ1pEQUwJhXQW2i+bIStPBjZK438S7xR8muCSpFCkduncxaVvOwNJp+nn359
         TSe+OlfrI4v6lRJp/fqTLl0HDU/kFOPp5SqRhm+6+uQsTXwRnBuff3O917alOhrn+io/
         s68A==
X-Gm-Message-State: APjAAAVysq0NDl5ZQ4/psC+4g5Gj2RMwW5DXvEQdZUIioJL33Aud42HM
        zXmjbh6ieqr1uzO1B1zM+fk=
X-Google-Smtp-Source: APXvYqwKwykv6CN/6bn3KQnNaNVokMtRB+BjV4mtu8tMvc5lHSqX096tnSYLJXDbRbOsd2uRcQ0rvA==
X-Received: by 2002:a17:902:ba8f:: with SMTP id k15mr13996732pls.93.1572182369249;
        Sun, 27 Oct 2019 06:19:29 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id b17sm9318209pfr.17.2019.10.27.06.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 06:19:28 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
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
 <87sgniladm.fsf@toke.dk>
Message-ID: <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
Date:   Sun, 27 Oct 2019 22:19:24 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87sgniladm.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/24 (木) 19:13:09, Toke Høiland-Jørgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> 
>> Toke Høiland-Jørgensen wrote:
>>> John Fastabend <john.fastabend@gmail.com> writes:
>>>
>>>> I think for sysadmins in general (not OVS) use case I would work
>>>> with Jesper and Toke. They seem to be working on this specific
>>>> problem.
>>>
>>> We're definitely thinking about how we can make "XDP magically speeds up
>>> my network stack" a reality, if that's what you mean. Not that we have
>>> arrived at anything specific yet...
>>
>> There seemed to be two thoughts in the cover letter one how to make
>> OVS flow tc path faster via XDP. And the other how to make other users
>> of tc flower software stack faster.
>>
>> For the OVS case seems to me that OVS should create its own XDP
>> datapath if its 5x faster than the tc flower datapath. Although
>> missing from the data was comparing against ovs kmod so that

In the cover letter there is

  xdp_flow  TC        ovs kmod
  --------  --------  --------
  5.2 Mpps  1.2 Mpps  1.1 Mpps

Or are you talking about something different?

>> comparison would also be interesting. This way OVS could customize
>> things and create only what they need.
>>
>> But the other case for a transparent tc flower XDP a set of user tools
>> could let users start using XDP for this use case without having to
>> write their own BPF code. Anyways I had the impression that might be
>> something you and Jesper are thinking about, general usability for
>> users that are not necessarily writing their own network.
> 
> Yeah, you are right that it's something we're thinking about. I'm not
> sure we'll actually have the bandwidth to implement a complete solution
> ourselves, but we are very much interested in helping others do this,
> including smoothing out any rough edges (or adding missing features) in
> the core XDP feature set that is needed to achieve this :)

I'm very interested in general usability solutions.
I'd appreciate if you could join the discussion.

Here the basic idea of my approach is to reuse HW-offload infrastructure 
in kernel.
Typical networking features in kernel have offload mechanism (TC flower, 
nftables, bridge, routing, and so on).
In general these are what users want to accelerate, so easy XDP use also 
should support these features IMO. With this idea, reusing existing 
HW-offload mechanism is a natural way to me. OVS uses TC to offload 
flows, then use TC for XDP as well...
Of course as John suggested there are other ways to do that. Probably we 
should compare them more thoroughly to discuss it more?

Toshiaki Makita
