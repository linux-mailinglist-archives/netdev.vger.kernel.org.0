Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E97112BBDC
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfL1AQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:16:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33730 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfL1AQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:16:00 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so15450423pfk.0
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 16:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=99N+yR1cfD0P9OQYJA1WztSX568I6VoZyEvLlFg1qSc=;
        b=Z3FU+vOYCY85L0feBpgWqT/kkKkrTf0peHuhO6qd6ix68KLiLomVzt0uKJTCzvOlrp
         TxxEkGwipsGIEu8lhEH0GfXt2Yk2gxw6jAy19rRlr/EvJjz3WDt4pVdfhdXoOPHVso5s
         KO96BU7RauEdalM7kn3+xdQKs0mMUVSiPc3p9mnOUbFQIkiTh8J2uVMuBw5J6f26tbIN
         c6woHpOW8So6oAyvZExHzyXDxvWnhFNR2KwZHx6A9YKTKkpfN/1S40EGDgtMzWIhX+qK
         GgP47QKeJQ410UJ0TSCwk88jo5dBbcBdWIDQYJ0FvIxtnQEeb75RCSyPaFiJOkgiKdc9
         YewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=99N+yR1cfD0P9OQYJA1WztSX568I6VoZyEvLlFg1qSc=;
        b=FGKXldGjiB9f/V7GMVmpSmRZ0csBWDAsMEwfEANaFIAtba388wcLWVtczAABU2rNLr
         dGoC8HK8KpuGGqkSqFQFyqP1INzQeiOzxgctb+7j+lgPPKvmqMmU3A+o+vpZMlUqtyy5
         VDoFKCMuOoecJsrozwJqTAKRD2zh0yqgrFG3vv4Vw2OR+SufTn9U1z8DjVWXukY4Ji2U
         aek1UeAVHw1OR5XC+HOrLfCkeBdFeiEKoTDF6xpBVTK65HUj5ZRM2iZZyMyAwsr4cY69
         Z+k+Y32C4ScG0B3Rk01zYF9zHc5dJujzBYZgDDoXlwIIFN2bcdKVAXsWhbJwnEjJdEsw
         39Eg==
X-Gm-Message-State: APjAAAVXXM2ddHgEjATKjJZkTCrRYrX+KBfCUwQYG4Ug1tqXealNCQ6+
        3Y2B/vp9W3VKoNPl+fviCwasNJmE
X-Google-Smtp-Source: APXvYqyzZ3qvYYfpg0tNJ7tlGkpmCrTv2yasnyRXg0L+WqXogmls+xyqWRygtmAJCFCVN+rmPDD7bQ==
X-Received: by 2002:a63:9d4e:: with SMTP id i75mr56591088pgd.231.1577492159543;
        Fri, 27 Dec 2019 16:15:59 -0800 (PST)
Received: from [192.168.1.236] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id e1sm43085868pfl.98.2019.12.27.16.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 16:15:59 -0800 (PST)
Subject: Re: [RFC v2 net-next 01/12] net: introduce BPF_XDP_EGRESS attach type
 for XDP
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
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
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <a479866f-c8c8-27a4-ea1b-23132494b0ba@gmail.com>
Date:   Sat, 28 Dec 2019 09:15:54 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191227152752.6b04c562@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/27/2019 11:27 PM, Jesper Dangaard Brouer wrote:
> On Thu, 26 Dec 2019 11:31:49 +0900
> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
> 
>> This patch introduces a new bpf attach type BPF_XDP_EGRESS. Programs
>> having this attach type will be allowed to run in the tx path. It is
>> because we need to prevent the programs from accessing rxq info when
>> they are running in tx path. Verifier can reject the programs those
>> have this attach type and trying to access rxq info.
>>
>> Patch also introduces a new netlink attribute IFLA_XDP_TX which can
>> be used for setting XDP program in tx path and to get information of
>> such programs.
>>
>> Drivers those want to support tx path XDP needs to handle
>> XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX cases in their ndo_bpf.
> 
> Why do you keep the "TX" names, when you introduce the "EGRESS"
> attachment type?
> 
> Netlink attribute IFLA_XDP_TX is particularly confusing.
> 
> I personally like that this is called "*_XDP_EGRESS" to avoid confusing
> with XDP_TX action.

It's been named like that because it is likely that a new program
type tx path will be introduced later. It can re-use IFLA_XDP_TX
XDP_SETUP_PROG_TX, XDP_QUERY_PROG_TX. Do think that it should not
be shared by two different type of programs?

> 
> BTW, should the XDP_EGRESS program also inspect XDP_TX packets?

Yes, makes sense. But I missed to handle this case in tun driver
changes.

Thanks

> 
> 
>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>> Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   include/linux/netdevice.h      |   4 +-
>>   include/uapi/linux/bpf.h       |   1 +
>>   include/uapi/linux/if_link.h   |   1 +
>>   net/core/dev.c                 |  34 +++++++---
>>   net/core/filter.c              |   8 +++
>>   net/core/rtnetlink.c           | 112 ++++++++++++++++++++++++++++++++-
>>   tools/include/uapi/linux/bpf.h |   1 +
>>   7 files changed, 150 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 469a297b58c0..ac3e88d86581 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -865,8 +865,10 @@ enum bpf_netdev_command {
>>   	 */
>>   	XDP_SETUP_PROG,
>>   	XDP_SETUP_PROG_HW,
>> +	XDP_SETUP_PROG_TX,
>>   	XDP_QUERY_PROG,
>>   	XDP_QUERY_PROG_HW,
>> +	XDP_QUERY_PROG_TX,
>>   	/* BPF program for offload callbacks, invoked at program load time. */
>>   	BPF_OFFLOAD_MAP_ALLOC,
>>   	BPF_OFFLOAD_MAP_FREE,
>> @@ -3725,7 +3727,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
>>   
>>   typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
>>   int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>> -		      int fd, u32 flags);
>> +		      int fd, u32 flags, bool tx);
>>   u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
>>   		    enum bpf_netdev_command cmd);
>>   int xdp_umem_query(struct net_device *dev, u16 queue_id);
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index dbbcf0b02970..23c1841c8086 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -203,6 +203,7 @@ enum bpf_attach_type {
>>   	BPF_TRACE_RAW_TP,
>>   	BPF_TRACE_FENTRY,
>>   	BPF_TRACE_FEXIT,
>> +	BPF_XDP_EGRESS,
>>   	__MAX_BPF_ATTACH_TYPE
>>   };
>>   
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index 1d69f637c5d6..be97c9787140 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -170,6 +170,7 @@ enum {
>>   	IFLA_PROP_LIST,
>>   	IFLA_ALT_IFNAME, /* Alternative ifname */
>>   	IFLA_PERM_ADDRESS,
>> +	IFLA_XDP_TX,
>>   	__IFLA_MAX
>>   };
> 
> 
> 
