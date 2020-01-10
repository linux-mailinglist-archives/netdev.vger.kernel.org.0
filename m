Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778E21379D9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgAJWqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:46:38 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51123 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgAJWqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 17:46:38 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so1550066pjb.0;
        Fri, 10 Jan 2020 14:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+OLp0QtxzXBBYlNPV6bo8uFPoHa3icg6W3AmvWCQ1Cs=;
        b=jkyKKzz5nEOgJiQOctFDWi70OLEX1sgFL/eb6P2LEuv9d4jMBG00OlTzhnc9FkgFGb
         CxZEeKJoftEXF1xvSVz4VbTXhodHl4Kz8ZffPYzT8Rv2yXYolL9y/hpZg5+o9Lpum+ww
         hTEOLk6dQnBfELlTqb7CcfhgdPVvD7dmMf4rfELwWYcaUaGbFcysRF8CEbsVOKPLSKi0
         ntbkme511hVitlL20R1AB5SWU9/0o+DA3edLmqn216T+3Zq6zKFGd2CgLjkeEGGwSclL
         TcznSB/psaaYIRoHdwaIW/rudprmpfYK2irmMqLIbegSToI1bA/Q+2mO6xnz5vBtdYIz
         Edhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+OLp0QtxzXBBYlNPV6bo8uFPoHa3icg6W3AmvWCQ1Cs=;
        b=mZdQzBLtIIi9Vd3PXUIHKGNfW4RAKrykRmIywF2ILfhWxKR/soluoaih1TTMpeacM0
         IA+V/5bi5zPKtlgbS9o8Db4At/mtjmXrjBO7RVqYFnGypfg0g58PxU2ELXx9dkXhK9Im
         6Sgx9AWPLDFhHVEIro5gKvYJOqYW/XhufQFeDKbU7K0AQbe7jbKzhC4D0ZXovrAV7QXK
         RzoEth/SF5RCnt6n8lQHPaT+7npOAUwVFYzswz8BTn8XimWntJt9PE4G2TOh5CVDEbDj
         0ydmDViDO49qJX0/laIiv/qp/A/wej3+01S1garUJUAD2u9/IxsskDu4Ic78K0oHnFVQ
         sHBQ==
X-Gm-Message-State: APjAAAWJyZ2mXKKb5QQBr5tMJ1+7PjQ+7cyVf9Exvi0WICiBzKWfQCub
        R7ifD7PhuDWNmujTE6rWlkI=
X-Google-Smtp-Source: APXvYqz0n7qPspTHpcisZwCCz/CR8pmMSNBz6UG/gkVWAF0P7pRpuB9iohzRinsWst4B2ger/8rPeQ==
X-Received: by 2002:a17:902:341:: with SMTP id 59mr1056971pld.29.1578696397279;
        Fri, 10 Jan 2020 14:46:37 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q199sm4350999pfq.163.2020.01.10.14.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 14:46:36 -0800 (PST)
Subject: Re: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct
 net_device
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk>
 <157866612285.432695.6722430952732620313.stgit@toke.dk>
 <20200110170824.7379adbf@carbon> <871rs7x7nc.fsf@toke.dk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <968491aa-01c7-ae8d-4e7f-8ec58f1750b1@gmail.com>
Date:   Fri, 10 Jan 2020 14:46:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <871rs7x7nc.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/10/20 2:34 PM, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
>> On Fri, 10 Jan 2020 15:22:02 +0100
>> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index 2741aa35bec6..1b2bc2a7522e 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>> [...]
>>> @@ -1993,6 +1994,8 @@ struct net_device {
>>>  	spinlock_t		tx_global_lock;
>>>  	int			watchdog_timeo;
>>>  
>>> +	struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
>>> +
>>>  #ifdef CONFIG_XPS
>>>  	struct xps_dev_maps __rcu *xps_cpus_map;
>>>  	struct xps_dev_maps __rcu *xps_rxqs_map;
>>
>> We need to check that the cache-line for this location in struct
>> net_device is not getting updated (write operation) from different CPUs.
>>
>> The test you ran was a single queue single CPU test, which will not
>> show any regression for that case.
> 
> Well, pahole says:
> 
> 	/* --- cacheline 14 boundary (896 bytes) --- */
> 	struct netdev_queue *      _tx __attribute__((__aligned__(64))); /*   896     8 */
> 	unsigned int               num_tx_queues;        /*   904     4 */
> 	unsigned int               real_num_tx_queues;   /*   908     4 */
> 	struct Qdisc *             qdisc;                /*   912     8 */
> 	struct hlist_head  qdisc_hash[16];               /*   920   128 */
> 	/* --- cacheline 16 boundary (1024 bytes) was 24 bytes ago --- */
> 	unsigned int               tx_queue_len;         /*  1048     4 */
> 	spinlock_t                 tx_global_lock;       /*  1052     4 */
> 	int                        watchdog_timeo;       /*  1056     4 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	struct xdp_dev_bulk_queue * xdp_bulkq;           /*  1064     8 */
> 	struct xps_dev_maps *      xps_cpus_map;         /*  1072     8 */
> 	struct xps_dev_maps *      xps_rxqs_map;         /*  1080     8 */
> 	/* --- cacheline 17 boundary (1088 bytes) --- */
> 
> 
> of those, tx_queue_len is the max queue len (so only set on init),
> tx_global_lock is not used by multi-queue devices, watchdog_timeo also
> seems to be a static value thats set on init, and the xps* pointers also
> only seems to be set once on init. So I think we're fine?
> 
> I can run a multi-CPU test just to be sure, but I really don't see which
> of those fields might be updated on TX...
> 

Note that another interesting field is miniq_egress, your patch
moves it to another cache line.

We probably should move qdisc_hash array elsewhere.


