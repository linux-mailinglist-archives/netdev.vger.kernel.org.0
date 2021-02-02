Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64E030B92F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhBBIEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhBBIEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:04:16 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEECC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 00:03:36 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id e18so22858878lja.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 00:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1DmTUhYyRw1sPWNcRsynKKhC37FeKaREjN5Ap8/YwMc=;
        b=Bn9cry7JvZMNFSPv+uHKkt2IDsHbgZ6YzN0tJIhL5Xa+SehemsM5tLSWdL8bCl1BKw
         1AvT13fArkdVwOdXQhR0xrLQvPeqfLO3C1vS2C8avSqrj2yIO6lj71YWkqblm55r7Qyh
         Tx+nHeORt7OjnVHHOKhcFNnuWJziG1fYdeQQw7grTLtCHXtOq7XJbqm/SBJ4gBouNkdC
         9gfDuu09JJMobdVlFncwBpBenmzMOLtT7YIQJEsOAQXF2KdMQhT+WrFLLDD4fO4T5Iy6
         Wc9dgMR5X/9VxazJo3YATHiho9NPN6qfKIh8i/U9Xtj1RHVdkigz0NdYHl1Zept3kMOc
         DF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1DmTUhYyRw1sPWNcRsynKKhC37FeKaREjN5Ap8/YwMc=;
        b=EvOLcFGGUN5A8mMEL77wtVXWlbYy/I/vCbnWRjcBPFnKKqjsd++b3VPrW2tbfwXICz
         uw22h2lqoCUsRLHdYu7kQCBMiGHT371Ei9K2be+a6jvUncqSrpSzoe3cM9y1lSEv7HUJ
         gfPR0NXoL/9+zgEMBM35uLbpHBrsYqycbXV/MHRWOQOu+A9YCp+TUCrm1SObLnl4h3IC
         G5aURKa4mUWF6bUzK9UTa7teeTO2uoAC+neSusBNRfoSuPyDumO4xh9vYRVDzonyJ+OL
         7YW4GwPJulxc4OuXgJgMCepAyZI2J8MVSYobYMyjoBytqEQfnJWnRsNgINgWvBRYb+kL
         UFOw==
X-Gm-Message-State: AOAM530i5MeTawgSZ/MKBQdMsYWIYqQR8GPJiOwHzeRK2S1O7MNwPBT+
        kRJdpEUAlJYQyBhm1szHfFD9RQ==
X-Google-Smtp-Source: ABdhPJzzyc1p6weWxbwJIJkGAyMPTVurqSicshozW3cJEVy6bVuCUCXtAeU+/4C7rsy4m62ig1Xbgg==
X-Received: by 2002:a2e:7819:: with SMTP id t25mr12096358ljc.300.1612253014548;
        Tue, 02 Feb 2021 00:03:34 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f20sm3223822lfm.71.2021.02.02.00.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 00:03:34 -0800 (PST)
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
 <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
 <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se>
 <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
 <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
 <20210201124414.21466bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <03621476-ed9b-a186-3b9a-774c703c207a@norrbonn.se>
 <CAOrHB_D101x6H3U1e0gUZZd5-VqmPMbaczPwJY1GA=6LXGafDw@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <6abf8cac-becf-de6c-acf2-1c8e0c7376ca@norrbonn.se>
Date:   Tue, 2 Feb 2021 09:03:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAOrHB_D101x6H3U1e0gUZZd5-VqmPMbaczPwJY1GA=6LXGafDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/02/2021 07:56, Pravin Shelar wrote:
> On Mon, Feb 1, 2021 at 9:24 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>> Hi Jakub,
>>
>> On 01/02/2021 21:44, Jakub Kicinski wrote:
>>> On Sat, 30 Jan 2021 12:05:40 -0800 Pravin Shelar wrote:
>>>> On Sat, Jan 30, 2021 at 10:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>> On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:
>>>>>> On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>>>>> Following are the reasons for extracting the header and populating metadata.
>>>>>> 1. That is the design used by other tunneling protocols
>>>>>> implementations for handling optional headers. We need to have a
>>>>>> consistent model across all tunnel devices for upper layers.
>>>>>
>>>>> Could you clarify with some examples? This does not match intuition,
>>>>> I must be missing something.
>>>>
>>>> You can look at geneve_rx() or vxlan_rcv() that extracts optional
>>>> headers in ip_tunnel_info opts.
>>>
>>> Okay, I got confused what Jonas was inquiring about. I thought that the
>>> extension headers were not pulled, rather than not parsed. Copying them
>>> as-is to info->opts is right, thanks!
>>>
>>
>> No, you're not confused.  The extension headers are not being pulled in
>> the current patchset.
>>
>> Incoming packet:
>>
>> ---------------------------------------------------------------------
>> | flags | type | len | TEID | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
>> ---------------------------------------------------------------------
>> <--------- GTP header ------<<Optional GTP elements>>-----><- Pkt --->
>>
>> The "collect metadata" path of the patchset copies 'flags' and 'type' to
>> info->opts, but leaves the following:
>>
>> -----------------------------------------
>> | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
>> -----------------------------------------
>> <--------- GTP header -------><- Pkt --->
>>
>> So it's leaving _half_ the header and making it a requirement that there
>> be further intelligence down the line that can handle this.  This is far
>> from intuitive.
>>
> 
> The patch supports Echo, Echo response and End marker packet.
> Issue with pulling the entire extension header is that it would result
> in zero length skb, such packets can not be passed on to the upper
> layer. That is the reason I kept the extension header in skb and added
> indication in tunnel metadata that it is not a IP packet. so that
> upper layer can process the packet.
> IP packet without an extension header would be handled in a fast path
> without any special handling.
> 
> Obviously In case of PDU session container extension header GTP driver
> would need to process the entire extension header in the module. This
> way we can handle these user data packets in fastpath.
> I can make changes to use the same method for all extension headers if needed.
> 

The most disturbing bit is the fact that the upper layer needs to 
understand that part of the header info is in info->opts whereas the 
remainder is on the SKB itself.  If it is going to access the SKB 
anyway, why not just leave the entire GTP header in place and let the 
upper layer just get all the information from there?  What's the 
advantage of info->opts in this case?

Normally, the gtp module extracts T-PDU's from the GTP packet and passes 
them on (after validating their IP address) to the network stack.  For 
_everything else_, it just passes them along the socket for handling 
elsewhere.

It sounds like you are trying to do exactly the same thing:  extract 
T-PDU and inject into network stack for T-PDU's, and pass everything
else to another handler.

So what is different in your case from the normal case?
- there's metadata on the packet... can't we detect this and set the 
tunnel ID from the TEID in that case?  Or can't we just always have 
metadata on the packet?
- the upper layer handler is in kernel space instead of userspace; but 
they are doing pretty much the same thing, right?  why does the kernel 
space variant need something (info->opts) that userspace can get by without?

It would be seriously good to see a _real_ example of how you intend to 
use this.  Isn't the PDP context mechanism already sufficient to do all 
of the above?  What's missing?

ip route 192.168.99.0/24 encap gtp id 100 dst 172.99.0.2 dev gtp1

is roughly equivalent to:

gtp-tunnel add gtp1 v1 [LOCAL_TEID] 100 172.99.0.2 [UE_IP]

/Jonas


