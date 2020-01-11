Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14357137ACD
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgAKAxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:53:34 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37122 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbgAKAxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:53:33 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so1943526pfn.4
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 16:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ORBnjEdyVIu5Q3VmiIaS1XPBQw4X5dt+uVeEvysi7kY=;
        b=UHLoKTH52r6CVQb0KWatMAQu5W1fvOBlK1O55RKGdFtoyPURktqQutGaMUlbmHedxP
         dx5UVlBDai2T/cCZNw9Rt5pqy7VW0Wuqig0PJ4m2Oc0tsAQRCuVzkM49L06X4/AH6+L8
         DOUrs3x8OCHWGX9Cdrs+VGnhp1oDyiPaLKOu0Vzb/yYHB9PHXbRBitoS5Yjc5wtMrgNO
         LxaByd2OhToAuSVQRS4KaxG7x2qQsa7UWJqxO6dY3jh3KotIcdGx2vhLpmmI1+rf+Xh9
         1/R0KZeTGb9gEAKlAUPpG8zsmVaY2CbOs+a/Q+lmNqsydqNjYEeQ150tj5ockOZxRlxH
         A2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ORBnjEdyVIu5Q3VmiIaS1XPBQw4X5dt+uVeEvysi7kY=;
        b=HoylvNqVP+tJICR/EfQ2Mkkit1ATSioIuvY+G3NNRqsPdlMtOjzSa7DTPm0qa7NxFE
         WCO2if9IjcSiPenKn00vqL2NVbLIW5NgD9+iBi9Y6qwGIDMpiD2kOJiwVbaR7HLG0qKX
         UZ33PwJC2NorXDNZRtZZAXw5Oco7VVTuWMOuA785woyCNqUDysAdixnGdRJ8ucZr/0WX
         BJNbks6frt6jKb9IFXmH/lYAAwvhYIXb5fssw8eVRW/0sLvWF1ruTWGv4L9haKUkrVcD
         F8u5PrV7Hmj5ojv5HQfG6ModETR/IdEwd+5GA+XHVgb2NsLP0YwDrBXnnGLZorl+e37r
         7Glw==
X-Gm-Message-State: APjAAAVQrxPQ4g7cjiP3iuHi+nJn1rq0BMqi9JgJwKxYGduqG/zfCfR1
        Nn9QV6FJmbU/dsNSCNsEqwLuF3W/
X-Google-Smtp-Source: APXvYqyxHFAh4xOzEtK2P7zUL+dBceVVHg60wzrIVnMJcJinNlX8gVZWJiyCIG2aSkeJa3AV72CJnQ==
X-Received: by 2002:a65:4587:: with SMTP id o7mr7638530pgq.303.1578704013117;
        Fri, 10 Jan 2020 16:53:33 -0800 (PST)
Received: from [192.168.1.236] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id k21sm4503365pfa.63.2020.01.10.16.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 16:53:32 -0800 (PST)
Subject: Re: [RFC v2 net-next 01/12] net: introduce BPF_XDP_EGRESS attach type
 for XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
 <20191226023200.21389-2-prashantbhole.linux@gmail.com>
 <20191227152752.6b04c562@carbon>
 <a479866f-c8c8-27a4-ea1b-23132494b0ba@gmail.com> <87woa3ijo7.fsf@toke.dk>
From:   Prashant Bhole <bholeprashant.oss@gmail.com>
Message-ID: <d486397d-9934-2530-ac6a-7fe41b166428@gmail.com>
Date:   Sat, 11 Jan 2020 09:53:26 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <87woa3ijo7.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/2020 8:35 PM, Toke Høiland-Jørgensen wrote:
> Prashant Bhole <prashantbhole.linux@gmail.com> writes:
> 
>> On 12/27/2019 11:27 PM, Jesper Dangaard Brouer wrote:
>>> On Thu, 26 Dec 2019 11:31:49 +0900
>>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>>
>>>> This patch introduces a new bpf attach type BPF_XDP_EGRESS. Programs
>>>> having this attach type will be allowed to run in the tx path. It is
>>>> because we need to prevent the programs from accessing rxq info when
>>>> they are running in tx path. Verifier can reject the programs those
>>>> have this attach type and trying to access rxq info.
>>>>
>>>> Patch also introduces a new netlink attribute IFLA_XDP_TX which can
>>>> be used for setting XDP program in tx path and to get information of
>>>> such programs.
>>>>
>>>> Drivers those want to support tx path XDP needs to handle
>>>> XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX cases in their ndo_bpf.
>>>
>>> Why do you keep the "TX" names, when you introduce the "EGRESS"
>>> attachment type?
>>>
>>> Netlink attribute IFLA_XDP_TX is particularly confusing.
>>>
>>> I personally like that this is called "*_XDP_EGRESS" to avoid confusing
>>> with XDP_TX action.
>>
>> It's been named like that because it is likely that a new program
>> type tx path will be introduced later. It can re-use IFLA_XDP_TX
>> XDP_SETUP_PROG_TX, XDP_QUERY_PROG_TX. Do think that it should not
>> be shared by two different type of programs?
> 
> I agree that the *PROG_TX stuff is confusing.

Ok. It seems s/TX/EGRESS is good for now.

> 
> Why not just keep the same XDP attach command, and just make this a new
> attach mode? I.e., today you can do
> 
> bpf_set_link_xdp_fd(ifindex, prog_fd, XDP_FLAGS_DRV_MODE);
> 
> so for this, just add support for:
> 
> bpf_set_link_xdp_fd(ifindex, prog_fd, XDP_FLAGS_EGRESS_MODE);
> 
> No need for a new command/netlink attribute. We already support multiple
> attach modes (HW+DRV), so this should be a straight-forward extension,
> no?

Initially we had implemented it the same way. I am ok with this way too.
- new attachment flag BPF_XDP_EGRESS for verifier purpose
- new xdp flag XDP_FLAGS_EGRESS for libbpf


Thanks
