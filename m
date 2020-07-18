Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB46224D4E
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 19:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgGRRUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 13:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgGRRUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 13:20:22 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F08C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 10:20:22 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so14072541eje.1
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 10:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ROTr/ATyyzCc5TOlI7PMbEuT18t12KrzUARZNjwnI78=;
        b=VNy9sAET+vkbI8XPun0v73GTk0xdbPRZWWDuhwegpAcF3gk+RsDgpuajXH4+wQ/1gZ
         GGa68FhpzbmH78azaYhOv2J8oOFR6+SgU6QFBC4jLe9l2IZsvmhn4o9zbeXBpjwJAssb
         xYYz3TSLDbY4NKWUxUWjQ44cyDkyukrsuRmGDQTx09HW1xoJ28XtWZeSfgGOVDi+jz1b
         sNQLLGgWZPDsnX/6jTh1IxmOAR644dBsfPqkIY3zOn1o2gQRfl7it9Z052yp0ikhD/Eb
         kOFQ5GpZKA6xh2WgAgLX9sZ1HkCqmZXk9h9+tve6rlQIrkMjpINszA55gxhGs8Tio6ZF
         Z1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ROTr/ATyyzCc5TOlI7PMbEuT18t12KrzUARZNjwnI78=;
        b=TqKVvvRKT0k/697tDmEba15GsYTVU72M3A9L2YEPEr1Tl8RgKaMynfCJ1YBsEU5qvy
         yP7AppmhUfDiU7L95YSKbsiQIEWtE3AuKXw33FJO6c9IxyvZoXwMKOPyM6Myn25LUjmz
         tm5OcIdjN3sTGlE14zR8C813fliBd6ONswyahSjSUINEr92MsLtp1E/2xFg0Ou0b05bw
         93lCZNAQ+opOgP7S93LOq1Z5sHORWOuIdiwQjofQjcl3P0RWAOuCNNxg0RbJ3Yi7Md0h
         grnYkINDTcofDm0mLK2p/fDRA0vyOra+QLB5RXGZU5CBrGmlFLXx04bpHV1gZYbSdsyX
         DbXg==
X-Gm-Message-State: AOAM530nwCSMsZOz0W5+YBFsYk/ZwxXjRn4D2+ItcT7j+62oYJNGVf9s
        WYRJEQ78QTFSTmyGhLWahQtsb54p
X-Google-Smtp-Source: ABdhPJzVt7JYrf9i3LpEX6lego1fOtp8o7ZiCBdDNn2/uYmZPbBxmuln1aoHAH4sz1dWkbe4RoWv5w==
X-Received: by 2002:a17:906:950c:: with SMTP id u12mr13386232ejx.37.1595092820579;
        Sat, 18 Jul 2020 10:20:20 -0700 (PDT)
Received: from [192.168.0.108] ([86.120.182.99])
        by smtp.gmail.com with ESMTPSA id z11sm11121967ejx.17.2020.07.18.10.20.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 10:20:19 -0700 (PDT)
Subject: Re: [PATCH net-next v2 6/6] enetc: Add adaptive interrupt coalescing
To:     Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
 <1595000224-6883-7-git-send-email-claudiu.manoil@nxp.com>
 <20200717123014.4a68dad4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <71e698b5-5e52-44fb-48e6-ed9ce94cd978@gmail.com>
Date:   Sat, 18 Jul 2020 20:20:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717123014.4a68dad4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17.07.2020 22:30, Jakub Kicinski wrote:
> On Fri, 17 Jul 2020 18:37:04 +0300 Claudiu Manoil wrote:
>> +	if (tx_ictt == ENETC_TXIC_TIMETHR)
>> +		ic_mode |= ENETC_IC_TX_OPTIMAL;
> 
> Doesn't seem you ever read/check the ENETC_IC_TX_OPTIMAL flag?
> 

It's used implicitly though ;), as it signals a state change when
the user changes the default value of the tx time threshold,
triggering the device recofiguration with the new value. True that
the said reconfiguration could be also performed in the 'MANUAL' state.
I added the extra state called 'OPTIMAL' to make the code more easier to 
follow actually. I mean, it's easy to follow that the tx coalescing 
state starts in the "OPTIMAL" mode, w/ the preconfigured "optimal" 
value. Then if the user changes the value, doing some manual tuning of 
tx-usecs, it moves into the 'MANUAL' mode, returning to the 'OPTIMAL' 
mode if the user goes back to the optimal value.
This handling could also be done in the 'MANUAL' mode alone, so if you 
want me to make this change pls let me know.

Thanks,
Claudiu
