Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6D4154EE
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 22:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfEFUdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 16:33:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42201 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfEFUdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 16:33:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id x15so6930731pln.9
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 13:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yjl1KXv0T5t2RZ00/XS/lIv0N4pyeYDknilHu7JOb+I=;
        b=NmHUquKkeBhT13kLGiRxG+dHj2xrDWf0MEZ4bDefrpUQcnrHT+TMzANKtBov/K4jIl
         /VPesUhQqYjtvezwI8GLO90IOcT7hVuoERXr6iAaUxW1Ub8WxjgCYaAM+AigUXhZbcpA
         gGn7MU8wfD+sG+vK3+33L9MYWnCJZceekAwHzk/umYGN8ZyP50c/AdopAOLrBNrVmNWn
         NpPeeqwqMM6Znvnm0ixfrePud0+ViMzLM4mpd6a6PX9qOCjQSAFVYIpKZsjBpi/txTrp
         n79B5uUaNb354MlBec/7EFV7/XAJbzRFiweV0TiZWWZ2UUKJ9dE6IR/XT+Q3X5pNwRzk
         cHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yjl1KXv0T5t2RZ00/XS/lIv0N4pyeYDknilHu7JOb+I=;
        b=bgBNqahlc3cZ41cnYIjDJWjJFGd4rNwIFR48uxpF/2gIs3doDbInjKC6xgIQMSXYQi
         0Nf9fTY7PD7vXKbJ0DshxSMqV3QuNBBx044JE/cbwB1lcuXR0Pi3ncpDm+RjReNL6dDv
         /cpe9Q3J9n6YF/JPN2mAPhihm3U9T83meQynWAN45XIYgMa3j28/4WkwFG3sO3SPILA4
         K2xoadi64OP0lSQPaRxkpN6ENnbbBiKG2qrcv/lHIWSrej+K7aeN73tNcXq0WIqn62Z5
         B5kWbZk7KFwlJsJvuGieaC77xwzo3pOOXM0B8vrSD6/HY5bkCRaWI9X4BwBB55ESpXc+
         N+5A==
X-Gm-Message-State: APjAAAXay29VnPw45W9gOfk1Enoh7nXQeeBD9g2GBwx1ddk7fSa38hk3
        ygST6GnHski/lyDZk65YkQp7Zsc1
X-Google-Smtp-Source: APXvYqw3NpJFY44IY0qeSINpaPJtQOyknm+P8zMca2N1ILnOHIdy9k3BDPe4kZ9RpTd6NY8PTY2++Q==
X-Received: by 2002:a17:902:7c93:: with SMTP id y19mr35127646pll.55.1557174793232;
        Mon, 06 May 2019 13:33:13 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:80c3:e1ec:92e3:5225? ([2601:282:800:fd80:80c3:e1ec:92e3:5225])
        by smtp.googlemail.com with ESMTPSA id g23sm13377994pfi.119.2019.05.06.13.33.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 13:33:12 -0700 (PDT)
Subject: Re: [PATCH net] vrf: sit mtu should not be updated when vrf netdev is
 the link
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20190506190001.6567-1-ssuryaextr@gmail.com>
 <667fd9b5-6122-bd9f-e6ae-e08d82197ef9@gmail.com>
 <20190506202848.GA19038@ubuntu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8a6d2af5-51b6-0315-5fc5-e5f7fe24e2de@gmail.com>
Date:   Mon, 6 May 2019 14:33:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190506202848.GA19038@ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/19 2:28 PM, Stephen Suryaputra wrote:
> On Mon, May 06, 2019 at 01:54:16PM -0600, David Ahern wrote:
>> On 5/6/19 1:00 PM, Stephen Suryaputra wrote:
>>> VRF netdev mtu isn't typically set and have an mtu of 65536. When the
>>> link of a tunnel is set, the tunnel mtu is changed from 1480 to the link
>>> mtu minus tunnel header. In the case of VRF netdev is the link, then the
>>> tunnel mtu becomes 65516. So, fix it by not setting the tunnel mtu in
>>> this case.
>>>
>>> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
>>> ---
>>>  net/ipv6/sit.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
>>> index b2109b74857d..971d60bf9640 100644
>>> --- a/net/ipv6/sit.c
>>> +++ b/net/ipv6/sit.c
>>> @@ -1084,7 +1084,7 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
>>>  	if (!tdev && tunnel->parms.link)
>>>  		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
>>>  
>>> -	if (tdev) {
>>> +	if (tdev && !netif_is_l3_master(tdev)) {
>>>  		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
>>>  
>>>  		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
>>>
>>
>> can you explain how tdev is a VRF device? What's the config setup for
>> this case?
> 
> Hi David,
> 
> tdev is set to VRF device per your suggestion to my colleague back in
> 2017:
> 	https://www.spinics.net/lists/netdev/msg462706.html.
> Specifically this on this follow up:
> 	https://www.spinics.net/lists/netdev/msg463287.html
> 
> His basic config before your suggestion is available in:
> 	https://www.spinics.net/lists/netdev/msg462770.html
> 
> He and I had a refresher discussion this am trying to figure out if tdev
> should be a slave device. This is true if the local addr is specified.
> In this case the addr has to bound to a slave device. Then the underlay
> VRF can be derived from it. But if only remote is specified, then there
> isn't a straightforward way to associate the remote with a VRF unless
> tdev is set to a VRF device.
> 

Right. Thanks for the reminder.

Reviewed-by: David Ahern <dsahern@gmail.com>
