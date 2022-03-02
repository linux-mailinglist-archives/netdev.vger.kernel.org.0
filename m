Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3D4C9DC7
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiCBG2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbiCBG2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:28:13 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C819D2DF2
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:27:28 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id y24so802077ljh.11
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 22:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qBZxaZD1TVDWUxUi3X7N5DxR6Dzxnkxer0dGSM9gAQQ=;
        b=qX9IvHd6MeBl7rB0DhDPtLPwcHC1BQjzGSVuJ6X8rSRLU09BdeoUTwBiARn59fDfBf
         k56Qh87kWqJEAHQ/pQCL40MOO/o4FseHjwR6WK8p76jM1hwisfYwiY4a0VdYx34m9+xV
         BRh86byIthzvBgQyKrjsqEHfo7usAMulagUXaYe8qG6cghZkrN3UP6rmNEuylHTpiCYu
         sC4/RHDJF/969Xv5rnra6QJdZcVt2PZ/LypEhjMOB9gjBg5uic+chH3o8hQLL7L04xNN
         bkJjLIkQ89yfK82dQd3fvoslZuWABB+YRRLDXbjRU0gXIPVWVfZOmuJS5N1F6Szr790C
         Eopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qBZxaZD1TVDWUxUi3X7N5DxR6Dzxnkxer0dGSM9gAQQ=;
        b=dRadN4wYyFq2NfcsgVwiqIsy+vmMDszt2l8H+q/IJPkk4USL0zXgDANy5Lc1ZUefE6
         vYiIjvCOASeLWUTOE8vOYA8aSrNWbg3NLtJ4KAyGTu/tBldhq/fmVwuloOdmXcxvwY7r
         lKtL+vCgQToYNlxlNdPOSXbchkcKHlJW502v5B6usWuMkuAZd49/fsUxgv+Nk4i7JFAM
         rRtt7a/SLu8Ago6yEz89yMoD1Qe50vwDNeC5S2zstcIXUJZzs0E4FPSvZw55DEN/8u4w
         XaLEtgTZtGL+9MW3d6I4x9RuARl+tYhPksfX8DwnV7locRPD5EoGDMhCVROwtgKqfH6f
         wjCw==
X-Gm-Message-State: AOAM53367z4W7/rxlnHJqWh2ZSZJ7M6pMbvN8aXdbIn4NUVKNpUR+S9U
        2bYHQTlhBx+7FlWo41r6j8BoeaJvZHegZRop2jk=
X-Google-Smtp-Source: ABdhPJzKgwOExM/I3Mac2FH8mCoKb+EW8R25M2CHkSPW29XDVPlWanz4XQgx6a3O+uMTfrl5DCBlkQ==
X-Received: by 2002:a2e:9919:0:b0:244:b934:aa36 with SMTP id v25-20020a2e9919000000b00244b934aa36mr19379252lji.388.1646202447001;
        Tue, 01 Mar 2022 22:27:27 -0800 (PST)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id t6-20020a056512068600b004437f8e83edsm1877808lfe.255.2022.03.01.22.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 22:27:26 -0800 (PST)
Message-ID: <96845833-8c17-04ab-2586-5005d27e1077@gmail.com>
Date:   Wed, 2 Mar 2022 07:27:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: mattias.forsblad+netdev@gmail.com
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <Yh5NL1SY7+3rLW5O@shredder>
 <EE0F5EE3-C6EA-4618-BBA2-3527C7DB88B4@blackwall.org>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <EE0F5EE3-C6EA-4618-BBA2-3527C7DB88B4@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-01 23:36, Nikolay Aleksandrov wrote:
> On 1 March 2022 17:43:27 CET, Ido Schimmel <idosch@idosch.org> wrote:
>> On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
>>> This patch implements the bridge flag local_receive. When this
>>> flag is cleared packets received on bridge ports will not be forwarded up.
>>> This makes is possible to only forward traffic between the port members
>>> of the bridge.
>>>
>>> Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
>>> ---
>>>  include/linux/if_bridge.h      |  6 ++++++
>>>  include/net/switchdev.h        |  2 ++
>>
>> Nik might ask you to split the offload part from the bridge
>> implementation. Please wait for his feedback as he might be AFK right
>> now
>>
> 
> Indeed, I'm traveling and won't have pc access until end of week (Sun). 
> I'll try to review the patches through my phoneas much as I can.
> Ack on the split.
> 

I'll split the patch, thanks!

>>>  include/uapi/linux/if_bridge.h |  1 +
>>>  include/uapi/linux/if_link.h   |  1 +
>>>  net/bridge/br.c                | 18 ++++++++++++++++++
>>>  net/bridge/br_device.c         |  1 +
>>>  net/bridge/br_input.c          |  3 +++
>>>  net/bridge/br_ioctl.c          |  1 +
>>>  net/bridge/br_netlink.c        | 14 +++++++++++++-
>>>  net/bridge/br_private.h        |  2 ++
>>>  net/bridge/br_sysfs_br.c       | 23 +++++++++++++++++++++++
>>
>> I believe the bridge doesn't implement sysfs for new attributes
>>
> 
> Right, no new sysfs please.
> 

Ok, I wasn't aware of that. I'll drop that part, thanks!

>>>  net/bridge/br_vlan.c           |  8 ++++++++
>>>  12 files changed, 79 insertions(+), 1 deletion(-)
>>
>> [...]
>>
>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>> index e0c13fcc50ed..5864b61157d3 100644
>>> --- a/net/bridge/br_input.c
>>> +++ b/net/bridge/br_input.c
>>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  		break;
>>>  	}
>>>  
>>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
>>> +		local_rcv = false;
>>> +
>>
>> I don't think the description in the commit message is accurate:
>> "packets received on bridge ports will not be forwarded up". From the
>> code it seems that if packets hit a local FDB entry, then they will be
>> "forwarded up". Instead, it seems that packets will not be flooded
>> towards the bridge. In which case, why not maintain the same granularity
>> we have for the rest of the ports and split this into unicast /
>> multicast / broadcast?
>>
> 
> Exactly my first thought - why not implement the same control for the bridge?
> Also try to minimize the fast-path hit, you can keep the needed changes 
> localized only to the cases where they are needed.
> I'll send a few more comments in a reply to the patch.
> 

Soo, if I understand you correctly, you want to have three different options?
local_receive_unicast
local_receive_multicast
local_receive_broadcast

>> BTW, while the patch honors local FDB entries, it overrides host MDB
>> entries which seems wrong / inconsistent.
>>
>>>  	if (dst) {
>>>  		unsigned long now = jiffies;
> 

