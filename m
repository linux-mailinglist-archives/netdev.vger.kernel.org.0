Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354431B9C2
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfEMPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:18:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34198 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbfEMPSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:18:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id f8so6098100wrt.1
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 08:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BmhxQNuSyPhIHXrARlq+upGWYI5zm+ec4g30ZG7wXkk=;
        b=Q491sy/VNOMPegVg8LsyKHt2roAQG1KoOrbMxmNJ4AYmgO0MKMbLcqNOZMlIDFaboZ
         /SFouNURfkDSmi0P5Wq6R6cJkgTVr+WxOe7wsnuDfZBd+aOT3Rx6u89764mx4GLnVxCA
         1S+WapGSXD1BgpimxtxpgH1tQ8NHDnX99Nfz9tEeOePkGfyMhH0U/BqZoxNzKpqtQxiW
         1S245M1Xxlw7y9O0xrApcIBBAlSsuPATNmvPDrvlhClWcWHkbAojyyyPSKbOlZ6X/Gvp
         PC1+p48Z3vluSk78kO2coaUMU3ji/PEh1JnOywp6k2BphAAf55pz2Om5dXVxkFzQCtWv
         r9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BmhxQNuSyPhIHXrARlq+upGWYI5zm+ec4g30ZG7wXkk=;
        b=WLmRclXd+UZMv7CAmx6pdqdQTr17l/oLUY4cT6v+9i91zPLrefiBAKrpD2gcYrLKbc
         1VvkycPpqPR8xLe31dczAuAWWpxrd8rr5J8hFmqjYn8v2nUdqK8kbjh2soqS1YZ8aFzb
         FIz8jzYnkmYH2jiFpaCKvLgd/cAMeNseeBumR/rCQ/A+ebafq7UUb9Q3k/jSUx8cYnWY
         7FAzrZJLV76o7ticGhA70IvXC0qHXpoxVfyeQFqcbUIZhu6QpoIjEV93THJZp7/Lgw9Z
         kGpWh1YLunl/YQP8uXLNBA64DfRnd2YMY0HPYromcc+bUgFdCYwQ2pYSsT7G4TleXJis
         slCA==
X-Gm-Message-State: APjAAAVA3BG+1NgCbC6yVfRPGxDT8xl8n27maqT+4gzTqJIqkEDSc4VD
        olyn/3Gmj79MJrh5MSdpafSwAg==
X-Google-Smtp-Source: APXvYqxbu4XRyKNukMSF3Ysac3eRXA1be7QLdHx9GNgwEzLr1/aaQmmvVBeFcwxAHHZvNPPZ4yZ6RA==
X-Received: by 2002:adf:8306:: with SMTP id 6mr6412616wrd.155.1557760710090;
        Mon, 13 May 2019 08:18:30 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d07d:5e75:4e14:205c? ([2a01:e35:8b63:dc30:d07d:5e75:4e14:205c])
        by smtp.gmail.com with ESMTPSA id w7sm17929516wmm.16.2019.05.13.08.18.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 08:18:29 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <9974090c-5124-b3a1-1290-ac9efc4569c4@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <83ffac16-f03a-acd7-815a-0b952c0ef951@6wind.com>
Date:   Mon, 13 May 2019 17:18:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9974090c-5124-b3a1-1290-ac9efc4569c4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/05/2019 à 17:07, David Ahern a écrit :
> On 5/13/19 7:47 AM, Sabrina Dubroca wrote:
>> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
>> iflink == ifindex.
>>
>> In some cases, a device can be created in a different netns with the
>> same ifindex as its parent. That device will not dump its IFLA_LINK
>> attribute, which can confuse some userspace software that expects it.
>> For example, if the last ifindex created in init_net and foo are both
>> 8, these commands will trigger the issue:
>>
>>     ip link add parent type dummy                   # ifindex 9
>>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
>>
>> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
>> always put the IFLA_LINK attribute as well.
>>
>> Thanks to Dan Winship for analyzing the original OpenShift bug down to
>> the missing netlink attribute.
>>
>> Analyzed-by: Dan Winship <danw@redhat.com>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
>> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>> v2: change Fixes tag, it's been here forever as Nicolas said, and add his Ack
>>
>>  net/core/rtnetlink.c | 16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 2bd12afb9297..adcc045952c2 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1496,14 +1496,15 @@ static int put_master_ifindex(struct sk_buff *skb, struct net_device *dev)
>>  	return ret;
>>  }
>>  
>> -static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev)
>> +static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev,
>> +			  bool force)
>>  {
>>  	int ifindex = dev_get_iflink(dev);
>>  
>> -	if (dev->ifindex == ifindex)
>> -		return 0;
>> +	if (force || dev->ifindex != ifindex)
>> +		return nla_put_u32(skb, IFLA_LINK, ifindex);
>>  
>> -	return nla_put_u32(skb, IFLA_LINK, ifindex);
>> +	return 0;
>>  }
>>  
>>  static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
> 
> why not always adding the attribute?
> 
Adding this attribute may change the output of 'ip link'.
See this patch for example:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=95ec655bc465


Nicolas
