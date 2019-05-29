Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0A42E659
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE2Ul1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:41:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54081 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfE2Ul1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:41:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id d17so2527036wmb.3;
        Wed, 29 May 2019 13:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Tz0UIzcufcpr4ojWSAEz0BFZ3UGJduWbz8lnUbkZVU=;
        b=WhMrQeiq7mQ0jLHtX70gCs13o4iNFOcAp42oU07/flu4B8w4YXaamkfijEmCOY0rwH
         qaNVqy6X8inEKI8ORD6whNNywqdKbZIctR8GnON5I1pamJi902YAuDWCKYxytoE1F4iR
         EXjItTYhvpODOz5mmln+08nfmPF2VHJRq5m7QyQn63bhnqFhbHH6PwJGjkvX17DiwJmZ
         Zb2O3WSpRZ+tLgfE+hI/I0UGbiqprxY836aDUWMDaPk25ulpRnmA/MPUMLGdqF/PIvt/
         62JcVAxWe0gHjizy0i+nO8kh75n3OL2BjxYQfIslus09LuAUo84Jn9Y/Bb/PrInzOjXd
         L5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Tz0UIzcufcpr4ojWSAEz0BFZ3UGJduWbz8lnUbkZVU=;
        b=Mj+0h1eKxoVwj9Ewpf8pam1CQrGXfYGWqvFCXPVazepvQsG+BQg04HRahT7TQg9bME
         vgG8sVA6PcQ/xAS2SuB1v09BQGk9ybaiy0CBAwpqhe28OUa2lW6SCuAc6xwZgOjPs0Hb
         47H6UJSPn5foO/FC0UCCftgJ2fuxh9C1ORui5/bF1NR7Xb185hGhyPpjsyBzELLtx54Q
         p1BEDF8u1H12XouYWTrugOX+oZ5U0vyFNgMS3uYKKzeIwp+H1Rj+5e8v08DEM3ipiJ5T
         tEyHpVo2+JRm7u2d1qugpsd5T7UJBWNKp7lOjaV+016+nC8M8LVs3j4HUDeb2jveiaWc
         25Yw==
X-Gm-Message-State: APjAAAUvlK7TjdIuoQ5l10udRasCLqeaYKO5sqzn8RDSkfzuNaumCYXu
        amTxVA6L6gC2dO0/ulaIb42D/wE80H4=
X-Google-Smtp-Source: APXvYqw/wsOiMDiZXdeIVgYS6OVEQNEqK/s0KQT2rLtryJYiwgP1BG72GC2iSHrdec4UDyAJE9p4KQ==
X-Received: by 2002:a1c:ca01:: with SMTP id a1mr26694wmg.30.1559162484282;
        Wed, 29 May 2019 13:41:24 -0700 (PDT)
Received: from [192.168.1.2] ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id l190sm701763wml.25.2019.05.29.13.41.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 13:41:23 -0700 (PDT)
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, john.stultz@linaro.org, tglx@linutronix.de,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190529045207.fzvhuu6d6jf5p65t@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
Date:   Wed, 29 May 2019 23:41:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190529045207.fzvhuu6d6jf5p65t@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 7:52 AM, Richard Cochran wrote:
> On Wed, May 29, 2019 at 02:56:22AM +0300, Vladimir Oltean wrote:
>> Not all is rosy, though.
> 
> You can sure say that again!
>   
>> PTP timestamping will only work when the ports are bridged. Otherwise,
>> the metadata follow-up frames holding RX timestamps won't be received
>> because they will be blocked by the master port's MAC filter. Linuxptp
>> tries to put the net device in ALLMULTI/PROMISC mode,
> 
> Untrue.
> 

I'm sorry, then what does this code from raw.c do?

> 	mreq.mr_ifindex = index;
> 	mreq.mr_type = PACKET_MR_ALLMULTI;
> 	mreq.mr_alen = 0;
> 	if (!setsockopt(fd, SOL_PACKET, option, &mreq, sizeof(mreq))) {
> 		return 0;
> 	}
> 	pr_warning("setsockopt PACKET_MR_ALLMULTI failed: %m");
> 
> 	mreq.mr_ifindex = index;
> 	mreq.mr_type = PACKET_MR_PROMISC;
> 	mreq.mr_alen = 0;
> 	if (!setsockopt(fd, SOL_PACKET, option, &mreq, sizeof(mreq))) {
> 		return 0;
> 	}
> 	pr_warning("setsockopt PACKET_MR_PROMISC failed: %m");


>> but DSA doesn't
>> pass this on to the master port, which does the actual reception.
>> The master port is put in promiscous mode when the slave ports are
>> enslaved to a bridge.
>>
>> Also, even with software-corrected timestamps, one can observe a
>> negative path delay reported by linuxptp:
>>
>> ptp4l[55.600]: master offset          8 s2 freq  +83677 path delay     -2390
>> ptp4l[56.600]: master offset         17 s2 freq  +83688 path delay     -2391
>> ptp4l[57.601]: master offset          6 s2 freq  +83682 path delay     -2391
>> ptp4l[58.601]: master offset         -1 s2 freq  +83677 path delay     -2391
>>
>> Without investigating too deeply, this appears to be introduced by the
>> correction applied by linuxptp to t4 (t4c: corrected master rxtstamp)
>> during the path delay estimation process (removing the correction makes
>> the path delay positive).
> 
> No.  The root cause is the time stamps delivered by the hardware or
> your driver.  That needs to be addressed before going forward.
> 

How can I check that the timestamps are valid?

Regards,
-Vladimir

> Thanks,
> Richard
> 

