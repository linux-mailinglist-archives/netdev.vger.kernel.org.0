Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D80E558F4
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFYUhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:37:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38589 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYUhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:37:04 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so75509ioa.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iz9QqIRl3NKWFxev6hrKNReyFYhXPl2VMi+frpGjJ2g=;
        b=Nzz6IYKfzcDtXCsQRMhBzibXOQyHn7/rjYtbKwIaJqIPhK7Ymabrmy2X2ovjhOv9gu
         ELd8cyFfYY0nCiihDxEhHIbjOc6zUM81CQ6Hc1kSDOmpMSWZpjb/A49q/CK9gp+iobql
         Z+kCkelENiMaV3kUx6EnCpURwIQfh/jqnYPOuq91j2zXOBEEQJvNp+2gneNjrwlBlWIG
         dhpgxv/HsVlixQs10M1hjLLujNHYPCyJowXfeYBGARreYTBGd1vajpgJL1bTL3eqH/Qw
         p2v3WIBzvFHVUR4ON2eD8GfF55gDfVLoQDSgsywkgf3qN7xJw/HT+G/aWa8+oNgRdMO3
         l7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iz9QqIRl3NKWFxev6hrKNReyFYhXPl2VMi+frpGjJ2g=;
        b=lMzbX/5SQTaxMz3f9YLTurXGRXJLAmA6uZkAQ4tbDqtxc5F1fgJ1yiZqg9wEsfd/4k
         /O+tuAS6QIQR9YHiFktdvfybC8lTThf+bVP4uetBwIw0PY5qmeKNb5gyieYzMj5GCyeP
         1UTkHUlY4w4Mzg6aObNwM3JCdTjCSX4Tbu+tDcuKcrd5Zsf9Ndm5guKYK/ZFd26t35tg
         znxEK+yR22E3gfm59/KkdsNDjmQ2BdR6zSVe8PkJI4JeWigQxNaKLATPJZ9vovJlQmn+
         ID3POrx+u1I1qAfLAn+b0x064jihauVSwNryW3i9Wc2I60+lmg1Vl19E4KPS6ocq5oWo
         QTZA==
X-Gm-Message-State: APjAAAX2NhX8MZXhE9EAej97+kq8G/FbmT5NSJ+gTSEGdLXSsGlS5yA+
        Yg9zS72V/ykJpDwVLNv0kTC5GKvy
X-Google-Smtp-Source: APXvYqxErYWFr16AyHCGxKYqPjELiKLql4t+5mHT/kPP0zno2U3hiFlURtJ/JJyCd+x/6960uxPuIQ==
X-Received: by 2002:a5e:9308:: with SMTP id k8mr651333iom.143.1561495023473;
        Tue, 25 Jun 2019 13:37:03 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:15b9:c7c8:5be8:b2c9? ([2601:282:800:fd80:15b9:c7c8:5be8:b2c9])
        by smtp.googlemail.com with ESMTPSA id r139sm31713229iod.61.2019.06.25.13.37.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 13:37:02 -0700 (PDT)
Subject: Re: [PATCH net] vrf: reset rt_iif for recirculated mcast out pkts
From:   David Ahern <dsahern@gmail.com>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190625103359.31102-1-ssuryaextr@gmail.com>
 <f0a47b5d-6477-9a6a-cf5d-6e13f0b4acdc@gmail.com>
Message-ID: <e5813b87-51c7-d24f-94ec-c18c2bbe6599@gmail.com>
Date:   Tue, 25 Jun 2019 14:36:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f0a47b5d-6477-9a6a-cf5d-6e13f0b4acdc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 2:22 PM, David Ahern wrote:
> On 6/25/19 4:33 AM, Stephen Suryaputra wrote:
>> @@ -363,10 +376,20 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>>  #endif
>>  		   ) {
>>  			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
>> -			if (newskb)
>> +			if (newskb) {
>> +				/* Reset rt_iif so that inet_iif() will return
>> +				 * skb->dev->ifIndex which is the VRF device for
>> +				 * socket lookup. Setting this to VRF ifindex
>> +				 * causes ipi_ifindex in in_pktinfo to be
>> +				 * overwritten, see ipv4_pktinfo_prepare().
>> +				 */
>> +				if (netif_is_l3_slave(dev))
> 
> seems like the rt_iif is a problem for recirculated mcast packets in
> general, not just ones tied to a VRF.
> 
>> +					ip_mc_reset_rt_iif(net, rt, newskb);
>> +
>>  				NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING,
>>  					net, sk, newskb, NULL, newskb->dev,
>>  					ip_mc_finish_output);
>> +			}
>>  		}
>>  
>>  		/* Multicasts with ttl 0 must not go beyond the host */

Also, wouldn't this problem apply to broadcast packets as well if they
get recirculated back up the stack? Maybe then the reset_rt_iif needs to
be done in ip_mc_finish_output.
