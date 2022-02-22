Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E084BFB02
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 15:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiBVOkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 09:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiBVOkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 09:40:19 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B934EA20;
        Tue, 22 Feb 2022 06:39:53 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id x6-20020a4a4106000000b003193022319cso17812904ooa.4;
        Tue, 22 Feb 2022 06:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8HtKvgP9c8lj3jdXox7eFQAQfru0ANSsDmI/ula35HM=;
        b=K1/FSrEvZlwbJ/z/izSGBjxSvAz+Ov/+WhAFdL0w2lu4DckhJQcJhyo+hPTDyiwcc/
         6qj6gB6J2nMVKk/7KxNqTYYy1FcIT8xa/7TiT41wajv1mkgbQ+ZjthPuABl0O3JgLvbr
         tw/7E89yOgxYPJv4fT7de76OWEndbpyy5TnG9Y/35mQzoeuvWlXQ71Ut1jNmmiIKsg3h
         tE/0BsFC2O4c5qhxej0N92XVW4bJd3rH7Y/ajPByTETe5hQ1Pkyxt2k7l37nbnZAn5Mj
         lCthilDQc+vJwXzZOUhwpo8aIp6dYcsgEb92l9V16l87XkjVPBWU7eXqXvc2Nk4Ezn5n
         62Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8HtKvgP9c8lj3jdXox7eFQAQfru0ANSsDmI/ula35HM=;
        b=5i1u5bqbLl3DvOR4UaBtecsdMGDdtlau2EZra+QFZlIw8eE9+/tdyw4mlqpHhcvzSx
         55zUQwtAHnZ+0K+8nCZsAcoOyJC1IUS9cggkzta81EWOOoY3vvyIYON3PSD2hegpHtew
         8fBaRtjB3XjSDpAYnJdgt5VXtvnytSeJqqh+CHGeHkXKUCPY6R1rxJJJOXltteU8rMwO
         lfI/FHur7mC/9lLFZHdPuuJsKETvytztzU7tkPKXCvyYHrh8jR7uBe/T9O1mu5hKR9pl
         SX4+f79vuBqsZ/vEd1AGHbYwUXXEBpP3L7gKArAGvpdIj+82DZtNR9GPIm+7kiJhOdNi
         LhdQ==
X-Gm-Message-State: AOAM532HIwSRQndfYbjIx6bKSu0CZutS2h+JzR0mZ2QytJMmmcnLur95
        TQ9RnNboWKidaDap8olsaEpA8AtaGgDKsw==
X-Google-Smtp-Source: ABdhPJzfy25BuAvr3cX+8+YLBL3ixm9jGl9YvPyO8dvdhgtGhb51HzuTSioLS1yWrFonG9T3BjKq5g==
X-Received: by 2002:a05:6870:a702:b0:d3:5740:1d61 with SMTP id g2-20020a056870a70200b000d357401d61mr1813353oam.340.1645540792919;
        Tue, 22 Feb 2022 06:39:52 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:fc7f:e53f:676e:280d? ([2601:284:8200:b700:fc7f:e53f:676e:280d])
        by smtp.googlemail.com with ESMTPSA id r131sm6241358oor.7.2022.02.22.06.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 06:39:52 -0800 (PST)
Message-ID: <c25691a0-96ab-34de-4739-524cd3ab1875@gmail.com>
Date:   Tue, 22 Feb 2022 07:39:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-5-dongli.zhang@oracle.com>
 <877dfc5d-c3a1-463f-3abc-15e5827cfdb6@gmail.com>
 <6eab223b-028d-c822-01ad-47e5869e0fe8@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <6eab223b-028d-c822-01ad-47e5869e0fe8@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/22 9:45 PM, Dongli Zhang wrote:
> Hi David,
> 
> On 2/21/22 7:28 PM, David Ahern wrote:
>> On 2/20/22 10:34 PM, Dongli Zhang wrote:
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>> index aa27268..bf7d8cd 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>  	struct netdev_queue *queue;
>>>  	struct tun_file *tfile;
>>>  	int len = skb->len;
>>> +	enum skb_drop_reason drop_reason;
>>
>> this function is already honoring reverse xmas tree style, so this needs
>> to be moved up.
> 
> I will move this up to before "int txq = skb->queue_mapping;".
> 
>>
>>>  
>>>  	rcu_read_lock();
>>>  	tfile = rcu_dereference(tun->tfiles[txq]);
>>>  
>>>  	/* Drop packet if interface is not attached */
>>> -	if (!tfile)
>>> +	if (!tfile) {
>>> +		drop_reason = SKB_DROP_REASON_DEV_READY;
>>>  		goto drop;
>>> +	}
>>>  
>>>  	if (!rcu_dereference(tun->steering_prog))
>>>  		tun_automq_xmit(tun, skb);
>>> @@ -1078,22 +1081,32 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>  	/* Drop if the filter does not like it.
>>>  	 * This is a noop if the filter is disabled.
>>>  	 * Filter can be enabled only for the TAP devices. */
>>> -	if (!check_filter(&tun->txflt, skb))
>>> +	if (!check_filter(&tun->txflt, skb)) {
>>> +		drop_reason = SKB_DROP_REASON_DEV_FILTER;
>>>  		goto drop;
>>> +	}
>>>  
>>>  	if (tfile->socket.sk->sk_filter &&
>>> -	    sk_filter(tfile->socket.sk, skb))
>>> +	    sk_filter(tfile->socket.sk, skb)) {
>>> +		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
>>>  		goto drop;
>>> +	}
>>>  
>>>  	len = run_ebpf_filter(tun, skb, len);
>>> -	if (len == 0)
>>> +	if (len == 0) {
>>> +		drop_reason = SKB_DROP_REASON_BPF_FILTER;
>>
>> how does this bpf filter differ from SKB_DROP_REASON_SOCKET_FILTER? I
>> think the reason code needs to be a little clearer on the distinction.
>>
> 
> 
> While there is a diff between BPF_FILTER (here) and SOCKET_FILTER ...
> 
> ... indeed the issue is: there is NO diff between BPF_FILTER (here) and
> DEV_FILTER (introduced by the patch).
> 
> 
> The run_ebpf_filter() is to run the bpf filter attached to the TUN device (not
> socket). This is similar to DEV_FILTER, which is to run a device specific filter.
> 
> Initially, I would use DEV_FILTER at both locations. This makes trouble to me as
> there would be two places with same reason=DEV_FILTER. I will not be able to
> tell where the skb is dropped.
> 
> 
> I was thinking about to introduce a SKB_DROP_REASON_DEV_BPF. While I have
> limited experience in device specific bpf, the TUN is the only device I know
> that has a device specific ebpf filter (by commit aff3d70a07ff ("tun: allow to
> attach ebpf socket filter")). The SKB_DROP_REASON_DEV_BPF is not generic enough
> to be re-used by other drivers.
> 
> 
> Would you mind sharing your suggestion if I would re-use (1)
> SKB_DROP_REASON_DEV_FILTER or (2) introduce a new SKB_DROP_REASON_DEV_BPF, which
> is for sk_buff dropped by ebpf attached to device (not socket).
> 
> 
> To answer your question, the SOCKET_FILTER is for filter attached to socket, the
> BPF_FILTER was supposed for ebpf filter attached to device (tun->filter_prog).
> 
> 

tun/tap does have some unique filtering options. The other sets focused
on the core networking stack is adding a drop reason of
SKB_DROP_REASON_BPF_CGROUP_EGRESS for cgroup based egress filters.

For tun unique filters, how about using a shortened version of the ioctl
name used to set the filter.
