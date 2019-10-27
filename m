Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF13E62A5
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 14:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfJ0N1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 09:27:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37621 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfJ0N1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 09:27:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so4699989pgi.4;
        Sun, 27 Oct 2019 06:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J1bavfccI2qFKVkTh17EGAGauWkdAR0kG7npyThEbQA=;
        b=IXBKIR77NygY3MN/M63mJS8qMbO2u7ftIJ63oF7/zhsMuhx2YKxkhZuz+IvH1+LYo4
         jvnd0WpXqhPFsPGZbFmjQ7aSYebDN4+ym82I3nRijvViX1MT9pXDHoWw61HUHMhsVUd/
         MNY/2fnTlp4u3zma3eZKscrgZRNj3Vp6Sz7k7bpPBFVCskFp10ovhjDwitwX1AYwcH7t
         wbiKEGNnEGtMPcfk7pan6EYXSWFLHzXL4wC5zJvY5jKttK1EpbyUUF36gc92X0duxpAu
         AtGD+9TlJ7ZPq9vgSY+W7uNuAOuUj30nxeOj2GRTbOBD68FVwDuPMJWqb9XDFJor3MGn
         l8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J1bavfccI2qFKVkTh17EGAGauWkdAR0kG7npyThEbQA=;
        b=s9db8UbQ9stNAEcoDC1cC8vA+THUO0iLgeQ10KM4cNf8NBMQ26NjaVWAnbcGvffAxB
         WVQOzqOSIG/LJjPVGaKPVq9HbeKrBDHn1g4ExX5h5Ct1bcUs6ZLVHA7kfUDrn8j5oxFm
         uI4IdlIFddovZxwwkRAR+9lKkskhU0ILW4oU10i95UABProPKYYA6X9k/S2cLwI1N7/D
         f0Kmckz46hCDv2okmrwOMN6fjMo/+pqVQLJ8hZJSs9/3YGdo5XxxH5F96SLUcaUTChzd
         1eWWM8j4GMuq6js83W8xEI4W6WDpzY7d3ZkxubvFPAt4sFH/JMiJax/ovNSe+61Q9nZW
         YhQQ==
X-Gm-Message-State: APjAAAUCJhGpRH21r63CF28ljIjxNRzWibYJQ0IQjM+Vh4vNz2qrrne1
        pbHu21ZIFa9/uFoFB9FE0VQX+z+1
X-Google-Smtp-Source: APXvYqzDglLsf2WK3oHUFRdRjnbFS3wno+tLLSa6SYq2vhkhObUC8TjTrOrVqYuV7jnKuqbJIqnIRQ==
X-Received: by 2002:a63:c446:: with SMTP id m6mr15477221pgg.136.1572182826253;
        Sun, 27 Oct 2019 06:27:06 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id q6sm10418678pgn.44.2019.10.27.06.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 06:27:05 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <421d6fa7-487a-f653-f520-7050a7892ab9@gmail.com>
Date:   Sun, 27 Oct 2019 22:27:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1c794797-db6f-83a7-30b4-aa864f798e5b@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/23 (水) 23:11:25, Jamal Hadi Salim wrote:
> 
> Sorry - didnt read every detail of this thread so i may
> be missing something.
> 
> On 2019-10-22 12:54 p.m., John Fastabend wrote:
>> Toshiaki Makita wrote:
>>> On 2019/10/19 0:22, John Fastabend wrote:
>>>> Toshiaki Makita wrote:
>>>>> This is a PoC for an idea to offload flow, i.e. TC flower and 
>>>>> nftables,
>>>>> to XDP.
>>>>>
> 
>>
>> I don't know who this "someone" is that wants to use XDP through TC
>> flower or nftables transparently. TC at least is not known for a
>> great uapi. 
> 
> 
> The uapi is netlink. You may be talking about lack of a friendly
> application library that abstracts out concepts?
> 
>> It seems to me that it would be a relatively small project
>> to write a uapi that ran on top of a canned XDP program to add
>> flow rules. This could match tc cli if you wanted but why not take
>> the opportunity to write a UAPI that does flow management well.
>>
> 
> Disagreement:
> Unfortunately legacy utilities and apps cant just be magically wished
> away. There's a lot of value in transparently making them work with
> new infrastructure. My usual exaggerated pitch: 1000 books have been
> written on this stuff, 100K people have RH certificates which entitle
> them to be "experts"; dinasour kernels exist in data centres and
> (/giggle) "enteprise". You cant just ignore all that.
> 
> Summary: there is value in what Toshiaki is doing.
> 
> I am disappointed that given a flexible canvas like XDP, we are still
> going after something like flower... if someone was using u32 as the
> abstraction it will justify it a lot more in my mind.
> Tying it to OVS as well is not doing it justice.

Flexibility is good for the time when very complicated or unusual flow 
handling is needed. OTOH, good flexibility often sacrifices good 
usability IMO. Configuration tends to be difficult.

What I want to do here is to make XDP easy for sysadmins for typical 
use-cases. u32 is good for flexibility, but to me flower is easier to 
use. Using flower fits better in my intention.

> 
> Agreement:
> Having said that I dont think that flower/OVS should be the interface
> that XDP should be aware of. Neither do i agree that kernel "real
> estate" should belong to Oneway(TM) of doing things (we are still stuck
> with netfilter planting the columbus flag on all networking hooks).
> Let 1000 flowers bloom.
> So: couldnt Toshiaki's requirement be met with writting a user space
> daemon that trampolines flower to "XDP format" flow transforms? That way
> in the future someone could add a u32->XDP format flow definition and we
> are not doomed to forever just use flower.

Userspace daemon is possible. Do you mean adding notification points in 
TC and listen filter modification events from userspace? If so, I'm not 
so positive about this, as it seems difficult to emulate TC/kernel 
behavior from userspace.
Note that I think u32 offload can be added in the future even with 
current xdp_flow implementation.

Toshiaki Makita
