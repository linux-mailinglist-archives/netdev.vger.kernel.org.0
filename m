Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE42B14D4
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgKMDsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKMDsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:48:40 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B9C0613D1;
        Thu, 12 Nov 2020 19:48:39 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f18so6002983pgi.8;
        Thu, 12 Nov 2020 19:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EoRbFzV6X7AprKoq11ufi43W+QPmmk8a6r9UhGYP27c=;
        b=RrAje0HkkSSIURgOPnvgo+oLeJefBgqS4wrLK7uoMvltur6JC6h8y6GXjPOgo1ShKK
         YSVWgmbX13JtTvq7T0pPax40dMgypadBO4VPQ9mQhpRNsELJJcGgfwoQbGCXzYgIpy+e
         hnIKwCwBaayazPEspUCgqCHetdRi+G3iNTFlmjhPN+uXwdtnhMf2mrIR78qFWDtW2D2O
         PwA/LOEz0OM3u0C03Ma81S9RofE5x/y3BQZKJJo6FZiLPEuXOPDYZ14MQahJFDwwM24+
         TLKS+k2yOqaXFHNu1G+1P413WLtoiBUVZPJ33GAMaSeRBOVCrdDb0uHpf4TijqbGTN4S
         nYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EoRbFzV6X7AprKoq11ufi43W+QPmmk8a6r9UhGYP27c=;
        b=siCI3ugPZWove3js7V9yNRFnpnvynczYiyiiEzhXY9SwGVO0DnR7zAKyL0TSf3VaHl
         7WPO8b9jveOwxeEf/u/ROLFATyhsL7T+bJwN4d+8Gz2om6rudPvEZ3T3q162MUigw9Q/
         vDUSyeWJ7R45/Ijcdb/0g1Glyu3YMPnz8STsJe9nvd6viCiXQPLiwx5+riYhMZ/G7kQC
         MkMmJgpjnWSFixWi5L2uImFabtnzNkm+awLdLEGfPgEAGIViQdWZGgYFwSiZDcmvIbub
         5J6smaAVsHqzWWfZ+lbGgWU4603uR0A1yItSVtj3K6vrI0SDDGEd22/MtY8Q6geAb0PS
         0eMA==
X-Gm-Message-State: AOAM533jSgFPMHm0AlRYb5jU0RcbmNWkb6oKGNYhJdwpOqEnXoMUr2xF
        PCztNX9beo/BdeNy4bIIi23Sl37rA0Q=
X-Google-Smtp-Source: ABdhPJzOOvDiuGsB1/GP6PZlhh8g6EyQMDiwnMEpgyIXYGpmmYna0rvOqmi8pZHRcy+7lmw17Ycc4A==
X-Received: by 2002:a17:90a:2a83:: with SMTP id j3mr657350pjd.84.1605239319402;
        Thu, 12 Nov 2020 19:48:39 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a3sm8074452pfo.46.2020.11.12.19.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 19:48:38 -0800 (PST)
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
To:     Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf> <20201108235939.GC1417181@lunn.ch>
 <20201109003028.melbgstk4pilxksl@skbuf> <87y2jbt0hq.fsf@waldekranz.com>
 <20201109100300.dgwce4nvddhgvzti@skbuf> <87tutyu6xc.fsf@waldekranz.com>
 <20201109123111.ine2q244o5zyprvn@skbuf>
 <20201109123813.kjzvel7pszhcmcgw@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6a86a756-51c8-51a1-b782-5dee7baf9b77@gmail.com>
Date:   Thu, 12 Nov 2020 19:48:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201109123813.kjzvel7pszhcmcgw@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/2020 4:38 AM, Vladimir Oltean wrote:
> On Mon, Nov 09, 2020 at 02:31:11PM +0200, Vladimir Oltean wrote:
>> I need to sit on this for a while. How many DSA drivers do we have that
>> don't do SA learning in hardware for CPU-injected packets? ocelot/felix
>> and mv88e6xxx? Who else? Because if there aren't that many (or any at
>> all except for these two), then I could try to spend some time and see
>> how Felix behaves when I send FORWARD frames to it. Then we could go on
>> full blast with the other alternative, to force-enable address learning
>> from the CPU port, and declare this one as too complicated and not worth
>> the effort.
> 
> In fact I'm not sure that I should be expecting an answer to this
> question. We can evaluate the other alternative in parallel. Would you
> be so kind to send some sort of RFC for your TX-side offload_fwd_mark so
> that I could test with the hardware I have, and get a better understanding
> of the limitations there?

For Broadcom switches, ARL (Address Resolution Logic, where learning
happens) is bypassed when packets ingress the CPU port with opcode 1
which is what net/dsa/tag_brcm.c uses. When opcode 0 is used, address
learning occurs.

The reason why opcode 1 is used is because of the Advanced Congestion
Buffering (ACB) which requires us to steer packets towards a particular
switch port and egress queue number within that port. With opcode 0 we
would not be able to do that.

We could make the opcode dependent on the switch/DSA master since not
all combinations support ACB, but given we have 3 or 4 Ethernet switches
kind within DSA that do not do learning from the CPU port, I guess we
need a solution to that problem somehow.
-- 
Florian
