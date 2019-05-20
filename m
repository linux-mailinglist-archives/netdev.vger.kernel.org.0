Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EFB23D3D
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392199AbfETQ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:29:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43387 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731671AbfETQ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 12:29:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id i26so16971416qtr.10
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S0oC7E4RoD1uXS5lIX0kIA5Ad5A3x431ws1WBdW9F5g=;
        b=z57hiMhaatlA2x7mU/NyCzgwOI2a/+klkf9SMzkfmhrvcnnanlLbAMcPxsqLtN1bL+
         iOZ679Bjvd9m9noH6qNEsnzocLiqxQjZbSf8RiohdE0XpZtU/4UX1G1HkYSV/zu7ro8d
         1JsxnjvoGXtYiYJtSmDxzGiRBcfCqHyycQ5xW88KvgnQheOQ1tDjQrGAp0DZ/8C+68lt
         8YNFrn2I8ea2CwaV9ajnIPE3r0Y9SnCoIF/SBqcASuSNTA5DWLf2Tb/4DYMa14SAe2ct
         gfDa5PeoarRjo+FgKelKjC9NP+1OSpCDJmVBbUL39r8bzAlPHNxDDGSdspyn9WSexSjX
         WrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S0oC7E4RoD1uXS5lIX0kIA5Ad5A3x431ws1WBdW9F5g=;
        b=LRVsczpVL5XLLc5MU3OBIBqHzd/V5KSebuysQzTumx2ZAX3Jh0wacsNHeoXxGLPaDN
         tSj9clkmNQX/J4D1x4NYaHDzJ2cxqst/xU5qL5ZY87NtGkNxg6s66jV1zmR7c7dijzz4
         PSJJV+xw2tebjSoTyfmDAuC6t98YuQyLaADxNtNUESxc17qPSVzNdIOuxP6pB2f5rkD6
         +48GwFyqfVfQJd67yvUewW7PM7O7IVK+vtokpcUviL8+R+1pgdfY9040j9GmIzYkVeUI
         RjQMfyhEgG86MQo5y8iNnWsc6EBYEMDoUGzc4s0vrOCJzX7PHFj9hKjdUZsDUBFjdWY3
         WpCg==
X-Gm-Message-State: APjAAAW75h30RnxPYgF+oIOoDOIUCibebdqs89iSWkRB//O0C+FO6zgG
        +BGOkvfbJmJclYOxVurEmjf9Ag==
X-Google-Smtp-Source: APXvYqw4h5asgwB5kjGsKoC8Iyj2EudyZDiB4J4iX13GbKcf4zyPYRE9qEBGtOUUZtvqWGlsm58ubw==
X-Received: by 2002:aed:3804:: with SMTP id j4mr29271703qte.361.1558369765925;
        Mon, 20 May 2019 09:29:25 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id m30sm1532825qtf.77.2019.05.20.09.29.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 09:29:24 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
Date:   Mon, 20 May 2019 12:29:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 12:10 p.m., Edward Cree wrote:
> On 20/05/2019 16:38, Jamal Hadi Salim wrote:
>> That is fine then if i could do:
>>
>> tc actions add action drop index 104
>> then
>> followed by for example the two filters you show below..
> That seems to work.

nice.


>> Is your hardware not using explicit indices into a stats table?
> No; we ask the HW to allocate a counter and it returns us a counter ID (which
>   bears no relation to the action index).  So I have an rhashtable keyed on
>   the cookie (or on the action-type & action_index, when using the other
>   version of my patches) which stores the HW counter ID; and the entry in that
>   hashtable is what I attach to the driver's action struct.
> 
>> Beauty.  Assuming the stats are being synced to the kernel?
>> Test 1:
>> What does "tc -s actions ls action drop index 104" show?
> It produces no output, but
>      `tc -s actions get action drop index 104`
> or
>      `tc -s actions list action gact index 104`

sorry meant that. Hopefully it shows accumulated stats from both
filter hits and correct ref counts and bind counts.

> shows the same stats as `tc -s filter show ...` did for that action.
>> Test 2:
>> Delete one of the filters above then dump actions again as above.
> Ok, that's weird: after I delete one, the other (in `tc -s filter show ...`)
>   no longer shows the shared action.
> 

Sounds weird.

> # tc filter del dev $vfrep parent ffff: pref 49151
> # tc -stats filter show dev $vfrep parent ffff:
> filter protocol arp pref 49152 flower chain 0
> filter protocol arp pref 49152 flower chain 0 handle 0x1
>    eth_type arp
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>           index 1 ref 1 bind 1 installed 180 sec used 180 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 2: mirred (Egress Mirror to device $pf) pipe
>          index 101 ref 1 bind 1 installed 180 sec used 169 sec
>          Action statistics:
>          Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 256 bytes 4 pkt
>          backlog 0b 0p requeues 0
> 
>          action order 3: vlan  pop pipe
>           index 2 ref 1 bind 1 installed 180 sec used 180 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
> #
> 

Hold on, did you intentionaly add that "protocol arp" there?
Or is that just a small development time quark?

> Yet `tc -s actions get` still shows it...
> 
> # tc -s actions get action drop index 104
> total acts 0
> 
>          action order 1: gact action drop
>           random type none pass val 0
>           index 104 ref 2 bind 1 installed 812 sec used 797 sec
>          Action statistics:
>          Sent 534 bytes 7 pkt (dropped 7, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 534 bytes 7 pkt
>          backlog 0b 0p requeues 0

Assuming you first created the action then bound it, the action
output looks correct. "ref 2" implies two refcounts, one by
the first action creation and the second by the filter binding.
Also "bind 1" implies only one filter is referencing it.
Before you deleted it should have been "ref 3" and "bind 2".

> # tc filter show dev $vfrep parent ffff:
> filter protocol arp pref 49152 flower chain 0
> filter protocol arp pref 49152 flower chain 0 handle 0x1
>    eth_type arp
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>           index 1 ref 1 bind 1
> 
>          action order 3: vlan  pop pipe
>           index 2 ref 1 bind 1

I see the arp listing again.
Maybe just a bug.

> # tc -s actions get action mirred index 101
> total acts 0
> 
>          action order 1: mirred (Egress Mirror to device $pf) pipe
>          index 101 ref 1 bind 1 installed 796 sec used 785 sec
>          Action statistics:
>          Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 256 bytes 4 pkt
>          backlog 0b 0p requeues 0
> #

Assuming in this case you added by value the actions? Bind and ref
are 1 each.
Maybe dump after each step and it will be easier to see what is
happening.

> Curiouser and curiouser... it seems that after I delete one of the rules,
>   TC starts to get very confused and actions start disappearing from rule
>   dumps.  Yet those actions still exist according to `tc actions list`.
> I don't *think* my changes can have caused this, but I'll try a test on a
>   vanilla kernel just to make sure the same thing happens there.
> 

Possible an offload bug that was already in existence. Can you try the
same steps but without offloading and see if you see the same behavior?

cheers,
jamal

