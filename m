Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0584CB2485
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 19:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbfIMRNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 13:13:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43738 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfIMRNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 13:13:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id u72so15554607pgb.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3hlM69+wm4691vW1og3mFFvHD8g8dvc4929aRkw9Xdw=;
        b=HnZr6CcGMO8TudnOrCHTDhhZIqyTBamwI1822Kp/8lwAx3WKPCT4jZ/752z+KCsiWy
         83iV5xCa9nBmUVSv3NAaIfbWCg9UGi4W8T2IdenyM1q5lx7LIxS2YjuHCVr1Kd36d1W2
         ivYMlgNyN8IbHsHzua3mysQHEZd4oQHS7bLF2NnLnFfIAtDBv/HP408BOQuqb6+Xkv70
         JhBhwReXthpYZE12j+JjLjvv1kGO1SB3bxtW6tSuqJjRwXeitcZmTpHEkP9iKcdON9m8
         rWc3tDrH9rnyAl3bL4XNP+zZ3f/aiAhiMhjwlzkxZuQ+z9yI2c8v49o+LtHOECIz87dc
         tohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3hlM69+wm4691vW1og3mFFvHD8g8dvc4929aRkw9Xdw=;
        b=WTZjFg61zmjIRmzxffg83stpCkBcVLPikEoZTG41e2BmnIJYGc3HwCiBvTpu8tOIYJ
         1jem5xRqz4TH4D+fYEZ+wz6ZENx3FNc5nF116ELWO4FuxmMXkqDeNJghVijImxdx/uon
         KqgOibhL1lEbZ/V39AHG7G+O/MyRq0wlIs3+nsK0oksv5nuyPrr/7+SLj0jF2QmJcf6G
         ImFujnORdMS0kwskOc8q2VQKzcB+/Oas3LL6iIROyUKc+8DvXixP8DDcdEE5r2PtITWl
         YFM+2yyGWk9n9ppEWha3jUx/hvm/b2FvYoo6sxSJU3/WnZNe8sv4LLvaf/Rr9xcaMjLf
         gnAg==
X-Gm-Message-State: APjAAAVOuwxup67Ljt5+aguXgWQQMb6iQp0QKzOdji7DkyJZ6l++MZfF
        cd0M7HDMQ0Pqgr9ef6Q6yGVJMrXD
X-Google-Smtp-Source: APXvYqwHSSpa4r/uwRznRu+O66yvvN+F0e5TdVb5nuZmBNxTklQtDPMVh7Qw2nevIfGp/fXbipyn6A==
X-Received: by 2002:a62:168e:: with SMTP id 136mr57467962pfw.144.1568394809835;
        Fri, 13 Sep 2019 10:13:29 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:f0f8:327c:ea9:5985])
        by smtp.googlemail.com with ESMTPSA id w69sm39381020pgd.91.2019.09.13.10.13.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 10:13:29 -0700 (PDT)
Subject: Re: big ICMP requests get disrupted on IPSec tunnel activation
To:     "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
References: <EB8510AA7A943D43916A72C9B8F4181F629D9741@cvk038.intra.cvk.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0c8ebbb-3ed3-296f-d84a-6f88e641b404@gmail.com>
Date:   Fri, 13 Sep 2019 11:13:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <EB8510AA7A943D43916A72C9B8F4181F629D9741@cvk038.intra.cvk.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/19 9:59 AM, Bartschies, Thomas wrote:
> Hello together,
> 
> since kenel 4.20 we're observing a strange behaviour when sending big ICMP packets. An example is a packet size of 3000 bytes.
> The packets should be forwarded by a linux gateway (firewall) having multiple interfaces also acting as a vpn gateway.
> 
> Test steps:
> 1. Disabled all iptables rules
> 2. Enabled the VPN IPSec Policies.
> 3. Start a ping with packet size (e.g. 3000 bytes) from a client in the DMZ passing the machine targeting another LAN machine
> 4. Ping works
> 5. Enable a VPN policy by sending pings from the gateway to a tunnel target. System tries to create the tunnel
> 6. Ping from 3. immediately stalls. No error messages. Just stops.
> 7. Stop Ping from 3. Start another without packet size parameter. Stalls also.
> 
> Result:
> Connections from the client to other services on the LAN machine still work. Tracepath works. Only ICMP requests do not pass
> the gateway anymore. tcpdump sees them on incoming interface, but not on the outgoing LAN interface. IMCP requests to any
> other target IP address in LAN still work. Until one uses a bigger packet size. Then these alternative connections stall also.
> 
> Flushing the policy table has no effect. Flushing the conntrack table has no effect. Setting rp_filter to loose (2) has no effect.
> Flush the route cache has no effect.
> 
> Only a reboot of the gateway restores normal behavior.
> 
> What can be the cause? Is this a networking bug?
> 

some of these most likely will fail due to other reasons, but can you
run 'tools/testing/selftests/net/pmtu.sh'[1] on 4.19 and then 4.20 and
compare results. Hopefully it will shed some light on the problem and
can be used to bisect to a commit that caused the regression.


[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/net/pmtu.sh

