Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C05D106059
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfKVFm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:42:26 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:45424 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVFm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 00:42:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id m71so2554610pjb.12;
        Thu, 21 Nov 2019 21:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N/xq13vGXiWvpwA7o5ubr/SQv5Qk0ryWNspqTCcKzVM=;
        b=mk7ReanpUIZYts/l/C999xuOMmVLfqqzs0MpoR1zuoQN4LC7IuYHBNOcQffZo+nuMQ
         fRs/cK/UpvkfmuoHbuGFfAnNKWuiT+iuA6g7M50zlj0RGROMEm5LYaGI7UrWsfeIX+zz
         YQ9WC9D724dm4b6uLIGELStgYrnN+0l/SFokEmWU9OrWdVFGfCA9zXm9MDdEbdbBll/X
         7+Hfo6naCHP0RniKY+2ayyh5FwQFI0xZpO/xSAv4J7JhKa3PE8qcjL3DdWmdpBX5zRXh
         HFV/Tv8vj6OlvGMU0scc67F/g3qnIMOtk15cT7x2PvYdL58bCt+VZEPiUi6mqWXBDwnM
         D+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/xq13vGXiWvpwA7o5ubr/SQv5Qk0ryWNspqTCcKzVM=;
        b=UzpWvSC8a8GfTkJlxcuaa27DmVuY2KEDMAD4cKB90qzOlGcWfUb+YR234l8yC4B6uK
         SAGr4jiREUZhcuMDPNIPCx2EoiIkZ5ecgm/lM9zWeY6d9nYUe57zteyXEL1xbYRnv2mc
         O+REBCyGb36XBHmX2/rK/FCSURckKhMsRunNBop9HU/NP1yKlt5bAEL9kwC0bkGQOX7g
         qSqc7tMDjEOt2CECSM5kg5f3eyRL/sKImJkg9Cnr0O0KQ28oYqmjfQmBv7v4KOh8aljq
         RB5Yh1qrRGZey/Yc8VbPoNpbkzaZ2vynj2Iu6/2eLsG/f9OGKW1Em9mP0ZJUq/SzKqXO
         U2lw==
X-Gm-Message-State: APjAAAWvuPtUny7QFUg86fMOgSvvSJnK0ltZzw5yv9xTKk6sn7kVRfi4
        U/nKYyN9ntgh6jLhyPyljQ4=
X-Google-Smtp-Source: APXvYqzstknxYzuGGKrXO06rsnCSJWi/aaRPTCAyTjuLKgzAc1ojp7WXFsQTvtnVoYwtnpeRtGrRRQ==
X-Received: by 2002:a17:90b:300c:: with SMTP id hg12mr16713316pjb.75.1574401345200;
        Thu, 21 Nov 2019 21:42:25 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h9sm5010634pgk.84.2019.11.21.21.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 21:42:24 -0800 (PST)
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
 <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com>
 <87zhhhnmg8.fsf@toke.dk> <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com>
 <87blthox30.fsf@toke.dk> <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com>
 <87lfsiocj5.fsf@toke.dk> <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com>
 <87k17xcwoq.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <db38dee6-1db9-85f3-7a0c-0bcee13b12ea@gmail.com>
Date:   Fri, 22 Nov 2019 14:42:18 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87k17xcwoq.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/18 19:20, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
> 
> [... trimming the context a bit ...]
> 
>>>>> Take your example of TC rules: You were proposing a flow like this:
>>>>>
>>>>> Userspace TC rule -> kernel rule table -> eBPF map -> generated XDP
>>>>> program
>>>>>
>>>>> Whereas what I mean is that we could do this instead:
>>>>>
>>>>> Userspace TC rule -> kernel rule table
>>>>>
>>>>> and separately
>>>>>
>>>>> XDP program -> bpf helper -> lookup in kernel rule table
>>>>
>>>> Thanks, now I see what you mean.
>>>> You expect an XDP program like this, right?
>>>>
>>>> int xdp_tc(struct xdp_md *ctx)
>>>> {
>>>> 	int act = bpf_xdp_tc_filter(ctx);
>>>> 	return act;
>>>> }
>>>
>>> Yes, basically, except that the XDP program would need to parse the
>>> packet first, and bpf_xdp_tc_filter() would take a parameter struct with
>>> the parsed values. See the usage of bpf_fib_lookup() in
>>> bpf/samples/xdp_fwd_kern.c
>>>
>>>> But doesn't this way lose a chance to reduce/minimize the program to
>>>> only use necessary features for this device?
>>>
>>> Not necessarily. Since the BPF program does the packet parsing and fills
>>> in the TC filter lookup data structure, it can limit what features are
>>> used that way (e.g., if I only want to do IPv6, I just parse the v6
>>> header, ignore TCP/UDP, and drop everything that's not IPv6). The lookup
>>> helper could also have a flag argument to disable some of the lookup
>>> features.
>>
>> It's unclear to me how to configure that.
>> Use options when attaching the program? Something like
>> $ xdp_tc attach eth0 --only-with ipv6
>> But can users always determine their necessary features in advance?
> 
> That's what I'm doing with xdp-filter now. But the answer to your second
> question is likely to be 'probably not', so it would be good to not have
> to do this :)
> 
>> Frequent manual reconfiguration when TC rules frequently changes does
>> not sound nice. Or, add hook to kernel to listen any TC filter event
>> on some daemon and automatically reload the attached program?
> 
> Doesn't have to be a kernel hook; we could enhance the userspace tooling
> to do it. Say we integrate it into 'tc':
> 
> - Add a new command 'tc xdp_accel enable <iface> --features [ipv6,etc]'
> - When adding new rules, add the following logic:
>    - Check if XDP acceleration is enabled
>    - If it is, check whether the rule being added fits into the current
>      'feature set' loaded on that interface.
>      - If the rule needs more features, reload the XDP program to one
>        with the needed additional features.
>      - Or, alternatively, just warn the user and let them manually
>        replace it?

Ok, but there are other userspace tools to configure tc in wild.
python and golang have their own netlink library project.
OVS embeds TC netlink handling code in itself. There may be more tools like this.
I think at least we should have rtnl notification about TC and monitor it
from daemon, if we want to reload the program from userspace tools.

Toshiaki Makita
