Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADA497556
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 10:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfHUItk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 04:49:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44606 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfHUItj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 04:49:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so912854pgl.11;
        Wed, 21 Aug 2019 01:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5H8yxlWflNf32/es+Dro2IiovtqE5FGqEuiX13BlX/k=;
        b=i0E9zZNB8cWFSiabZWuw5ffOBAjHn7D9ZmOIann/kQLlgkmwHXUIGv4b59ZKeG6yDN
         9MT/IycpPvypusN8AiSdxFFzESLbfZ6ab9HAJXxmsvVJdfNR2vSV+OIOUyC6hTVPr0ef
         /y8WcL2QTr6g2tM6IeKkpGLjrplknhqDpUj+Hfy0DdlkFuoWG0+JJUdY4hZ61cnWBUR9
         8ywgnlmLeHD9DcgC5rJnle0/q3w4JjnTHF1T5S3gsZpAo42/g7xy7TRBUvoSX7+2aaWi
         538hSuKz7PaOmuLPr38basL3p4Dw/DmGqm1ENA7VFsVEW4ophWWukM2LoNMWllkl9lJ9
         h9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5H8yxlWflNf32/es+Dro2IiovtqE5FGqEuiX13BlX/k=;
        b=ptKK6jOeISXOFJ1WeAnwudplXpGQ801aX2DFtVbMHyN+Dv92meTOpJPAHPv47v5Cfl
         sgABW1bChV6W1SHGtEfY8CgJUsx/wrT8lMOyf4+zV2QXh1R8EWMFS0F8tUXJDTrpLBxh
         WwYJHoqZOWu3UcG68HJO1hW22gxuw2T+nTfmqoCf68x+0gSbYdg4s0YbcxLpm33pkK/p
         oKUsfP6Vj4sVHzg0BFIAwXuWwZQ03ZJBYYngoMlKQVhLrlrHPEmPHaFOTqFuUPC+6Zc2
         jMgtEnJ/3hGVzoYoz8fjrAvjgi95Snatr3FFnb2m0Fn9tNiNxOXy2ppahiTq28k5NY4D
         UFww==
X-Gm-Message-State: APjAAAWpvKTADfWgo+d4vGWLkdYgkIfxlm4D+hnZQnI3pSe26tgC9G7t
        BehlfzkPI8ZEMdsSPUAsrqg=
X-Google-Smtp-Source: APXvYqygYWSWvOT0aZq36xJv1lERrPKjUSchdvMPwqcT0xjg1M5VxBp0c2VK/0Ayhf/GK9+OLacY4w==
X-Received: by 2002:a17:90a:cd03:: with SMTP id d3mr4168178pju.117.1566377378819;
        Wed, 21 Aug 2019 01:49:38 -0700 (PDT)
Received: from ?IPv6:240d:2:6b22:5500:ad97:b2ea:4b4b:d354? ([240d:2:6b22:5500:ad97:b2ea:4b4b:d354])
        by smtp.googlemail.com with ESMTPSA id ay7sm2146116pjb.4.2019.08.21.01.49.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 01:49:37 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
 <20190815152100.GN2820@mini-arch>
 <20190815122232.4b1fa01c@cakuba.netronome.com>
 <da840b14-ab5b-91f1-df2f-6bdd0ed41173@gmail.com>
 <20190816115224.6aafd4ee@cakuba.netronome.com>
 <5e9bee13-a746-f148-00de-feb7cb7b1403@gmail.com>
 <20190819111546.35a8ed76@cakuba.netronome.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <250f99fd-7289-a8e2-a710-560305e2d17d@gmail.com>
Date:   Wed, 21 Aug 2019 17:49:33 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819111546.35a8ed76@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/20 (火) 3:15:46, Jakub Kicinski wrote:

I'm on vacation and replying slowly. Sorry for any inconvenience.

> On Sat, 17 Aug 2019 23:01:59 +0900, Toshiaki Makita wrote:
>> On 19/08/17 (土) 3:52:24, Jakub Kicinski wrote:
>>> On Fri, 16 Aug 2019 10:28:10 +0900, Toshiaki Makita wrote:
>>>> On 2019/08/16 4:22, Jakub Kicinski wrote:
>>>>> There's a certain allure in bringing the in-kernel BPF translation
>>>>> infrastructure forward. OTOH from system architecture perspective IMHO
>>>>> it does seem like a task best handed in user space. bpfilter can replace
>>>>> iptables completely, here we're looking at an acceleration relatively
>>>>> loosely coupled with flower.
>>>>
>>>> I don't think it's loosely coupled. Emulating TC behavior in userspace
>>>> is not so easy.
>>>>
>>>> Think about recent multi-mask support in flower. Previously userspace could
>>>> assume there is one mask and hash table for each preference in TC. After the
>>>> change TC accepts different masks with the same pref. Such a change tends to
>>>> break userspace emulation. It may ignore masks passed from flow insertion
>>>> and use the mask remembered when the first flow of the pref is inserted. It
>>>> may override the mask of all existing flows with the pref. It may fail to
>>>> insert such flows. Any of them would result in unexpected wrong datapath
>>>> handling which is critical.
>>>> I think such an emulation layer needs to be updated in sync with TC.
>>>
>>> Oh, so you're saying that if xdp_flow is merged all patches to
>>> cls_flower and netfilter which affect flow offload will be required
>>> to update xdp_flow as well?
>>
>> Hmm... you are saying that we are allowed to break other in-kernel
>> subsystem by some change? Sounds strange...
> 
> No I'm not saying that, please don't put words in my mouth.

If we ignore xdp_flow when modifying something which affects flow 
offload, that may cause breakage. I showed such an example using 
multi-mask support. So I just wondered what you mean and guessed you 
think we can break other subsystem in some situation.

I admit I should not have used the wording "you are saying...?". If it 
was not unpleasant to you I'm sorry about that. But I think you should 
not use it as well. I did not say "cls_flower and netfilter which affect 
flow offload will be required to update xdp_flow". I guess most patches 
which affect flow offload core will not break xdp_flow. In some cases 
breakage may happen. In that case we need to fix xdp_flow as well.

> I'm asking you if that's your intention.
> 
> Having an implementation nor support a feature of another implementation
> and degrade gracefully to the slower one is not necessarily breakage.
> We need to make a concious decision here, hence the clarifying question.

As I described above, breakage can happen in some case, and if the patch 
breaks xdp_flow I think we need to fix xdp_flow at the same time. If 
xdp_flow does not support newly added features but it works for existing 
ones, it is OK. In the first place not all features can be offloaded to 
xdp_flow. I think this is the same as HW-offload.

>>> That's a question of policy. Technically the implementation in user
>>> space is equivalent.
>>>
>>> The advantage of user space implementation is that you can add more
>>> to it and explore use cases which do not fit in the flow offload API,
>>> but are trivial for BPF. Not to mention the obvious advantage of
>>> decoupling the upgrade path.
>>
>> I understand the advantage, but I can't trust such a third-party kernel
>> emulation solution for this kind of thing which handles critical data path.
> 
> That's a strange argument to make. All production data path BPF today
> comes from user space.

Probably my explanation was not sufficient. What I'm concerned about is 
that this needs to emulate kernel behavior, and it is difficult.
I don't think userspace-defined datapath itself is not reliable, nor 
eBPF ecosystem.

Toshiaki Makita
