Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1400A399B4
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfFGXZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:25:59 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:41022 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfFGXZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 19:25:59 -0400
Received: by mail-pl1-f177.google.com with SMTP id s24so1369685plr.8
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 16:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6OI14cer+A11/g3FA1yYsNtx5IpR8WtvKpN8sTBD3lg=;
        b=Iq39/cS9dxRNi5ZnEOqotEuvYcQRoe6pXD768d4XD/SL9Jr+LvRxHhP9AujR8XIlIz
         78d5lhm2zjMTT54WzbHnhcUuiMV8Ggmne1WJT18UNHQ+gY2DlTWQMIHGNOEtWbHeS5ov
         YrBxeocC/6uhEvEGyAFWh9xy6MwCmmtHj13g1/wB7f8/P+6qPhOI+a688r2ISWc2tR75
         oLmfoK3jMlRlerJnvUomGWxEgZiBowbT65INK5N9AMLdDU/UlpUS4w3hCbHAt8rpYbCI
         5FjGs9RVn3WWJ2TIXvrGxrpdVWe6vFN+ovg3uLYCv1Kf1XNl96ZIuddDwl2KfCLo2eWP
         EZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6OI14cer+A11/g3FA1yYsNtx5IpR8WtvKpN8sTBD3lg=;
        b=rTC9OYlt5rTf0+hnbMf4VKEeDHfOHPvtLoNLzm4PUG1uAeE+LR3PR+lThRIgr37uYV
         KJqMxEPaiSw5mYgrpWebcB858V3RTUu+/YYpTsp+gIQ9lqZiVF3Mf7j5BQ2Mpzu4xYLy
         844n+NT0N+E9AsloD7fQfLoMavtjD/P8qnCD+BppVv1JcJK7vC/zSG7ygb1dVdYPJQKP
         IybtI5noj+4Vxm89667R1Sde8eBUxsHSpJ2UCfGdK77RMt1t3MzcVdJN/wkYp9uqntvN
         NfO8QZ7BjjDvV2hJX44cFHm2vHjG9GsrYzB0iIJgyq7qRqCEblxChNu0AmoWjlmyZdxu
         jk2w==
X-Gm-Message-State: APjAAAVAfXmnwBAaFq6PehJfh0f+t3L8Agu6U/wWePV5mqXRoSxVNoVK
        jl+Qi+lMHVq0G9wvIK2OxnOgka2/
X-Google-Smtp-Source: APXvYqzn7hUp8bIWHhvHWCVb54ZYxzB+hUjp4G8LHqGSjHoeazPmoFmSGbijaKSLrdYmbQjGQVZ1rQ==
X-Received: by 2002:a17:902:bb8a:: with SMTP id m10mr26302210pls.337.1559949958042;
        Fri, 07 Jun 2019 16:25:58 -0700 (PDT)
Received: from [192.168.0.16] (97-115-113-19.ptld.qwest.net. [97.115.113.19])
        by smtp.gmail.com with ESMTPSA id d10sm5463663pgh.43.2019.06.07.16.25.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 16:25:57 -0700 (PDT)
Subject: Re: EoGRE sends undersized frames without padding
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
 <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
 <20190605072712.avp3svw27smrq2qx@sesse.net>
 <CAM_iQpXWM35ySoigS=TdsXr8+3Ws4ZMspJCBVdWngggCBi362g@mail.gmail.com>
 <20190606073611.7n2w5n52pfh3jzks@sesse.net>
 <CAM_iQpVFq8TdnHSOsC7+6tK3KEoeyF1SFOQ-DheLW7Y=g77xxg@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <76cc5356-e5f9-c46b-63b6-879ea9053f95@gmail.com>
Date:   Fri, 7 Jun 2019 16:25:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVFq8TdnHSOsC7+6tK3KEoeyF1SFOQ-DheLW7Y=g77xxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/7/2019 12:57 PM, Cong Wang wrote:
> On Thu, Jun 6, 2019 at 12:36 AM Steinar H. Gunderson
> <steinar+kernel@gunderson.no> wrote:
>> On Wed, Jun 05, 2019 at 06:17:51PM -0700, Cong Wang wrote:
>>> Hmm, sounds like openvswitch should pad the packets in this scenario,
>>> like hardware switches padding those on real wires.
>> Well, openvswitch say that they just throw packets around and assume they're
>> valid... :-)
> _If_ the hardware switch has to pad them (according to what you said),
> why software switch doesn't?

Well one thing I can think of is that there are things that can be done 
in HW that become very
expensive in SW.  CRC checking and packet padding are expensive in SW.

>
>> In any case, if you talk EoGRE to the vWLC directly, I doubt it accepts this,
>> given that it doesn't accept it on the virtual NICs.
>>
>>>> Yes, but that's just Linux accepting something invalid, no? It doesn't mean
>>>> it should be sending it out.
>>> Well, we can always craft our own ill-formatted packets, right? :) Does
>>> any standard say OS has to drop ethernet frames shorter than the
>>> minimum?
>> I believe you're fully allowed to accept them (although it might be
>> technically difficult on physical media). But that doesn't mean everybody
>> else has to accept them. :-)
> Sure, Linux is already different with other OS'es, this also means Linux
> doesn't have to reject them.
>
>>>>> Some hardware switches pad for ETH_ZLEN when it goes through a real wire.
>>>> All hardware switches should; it's a 802.1Q demand. (Some have traditionally
>>>> been buggy in that they haven't added extra padding back when they strip the
>>>> VLAN tag.)
>>> If so, so is the software switch, that is openvswitch?
>> What if the other end isn't a (virtual) switch, but a host?
> Rather than arguing about this, please check what ethernet standard
> says. It would be much easier to convince others with standard.
>
> Depends on what standard says, we may need to pad on xmit path or on
> forwarding path (switch), or rejecting shorter frames on receive path.
>
> Thanks.

I am used to Ethernet switches dropping undersized and bad CRC frames.  
Sure, if the incoming frame is
valid and then because of transformations in the packet due to 802.1q 
specs or any other reasons (NSH comes
mind) then the packet must be padded and the correct checksum computed 
by the switch.  That's fine.

But if the incoming packet to the switch is malformed (undersized and 
bad CRC in this case) then switches can
and probably will drop the packet.

It appears that openvswitch does not.  Steinar and I are discussing that 
situation on a different list.

Thanks,

- Greg
