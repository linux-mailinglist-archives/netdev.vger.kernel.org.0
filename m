Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C42915A284
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgBLH7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:59:25 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43337 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgBLH7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:59:25 -0500
Received: by mail-pf1-f194.google.com with SMTP id s1so821252pfh.10
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 23:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A3ALousrxb41mAKhjOZbpboJDJp11dh0Ud3kWj2Z3Dk=;
        b=RmzypZsVZzGlLp9kLds3qg6JFi/4Lcr2E+goLhIJyh+FG0G3z3093yyvKdvOw9C3uo
         pb7lCWy3+mtaEJUWs30Jf8iIwX2FwjByCUQxuiejyo4K3YxdDx1Hz/eD6Hg//KjoJlV1
         Dn62GKIVutz9zOvX6HzxnthhWncKiEOvin5zDSJsmhFTLxNfnlNsActrlGOnd+I2pB6n
         8Cs6zl2MxPXl0D9/372r4Vnqa4wLM7cMKvikYXT4RQCF2o9+Iuk6hMesT4AKJb5jmqMX
         E1kxoaj6Ix4DbAowSX/1rgLPwSJx/5XbtLRAiBzmhuiIv5fBStrF7CcJmwew+hWSGomk
         oW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A3ALousrxb41mAKhjOZbpboJDJp11dh0Ud3kWj2Z3Dk=;
        b=Z2GacHNYpaQEkpAu0JCEQrOnklyp1rLuOqjbEp+yAxzr9OLG4rOJYw6yQTkpJrX1Tn
         Y71URbUt64gIvTAH9neHyFWKlZN7I85vRpNRg4ooqSG9vSfLiimy1gQx/w9GJUF5Hjxf
         cMwLq2GAOLpqnS4lFwEeumhURIuKtdBytl5yIkCdon09jJRbJRPscqsM1T7xovFeo2nB
         3t72LaN320JaV0H4wbCFvArhoXztCRy3pNf5DBjogHYAXLurWuu1FB1LSr9UxcHtBZ5t
         l7Mk+u0msARzuKeiBf6NSw0TJ2JMdj+2JvsoDr4R+p5vEINVlklvky64ib3nzrAie22Q
         vuQA==
X-Gm-Message-State: APjAAAXsjZ18Bn8axS09q2hUDVX47/6r21hLViLn8vCrn8SySqaiTXCs
        j21BhtM7J4uum2UB8TuDsp4=
X-Google-Smtp-Source: APXvYqxRXpY07ecyqh1ZNA6yJXZ8pZhmeP/cJgozW6b17aqLnI3HGMeMONBLKXNcX8lum3AQfRzQcg==
X-Received: by 2002:a63:dc4f:: with SMTP id f15mr10193816pgj.300.1581494364471;
        Tue, 11 Feb 2020 23:59:24 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a22sm7385768pfk.108.2020.02.11.23.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 23:59:23 -0800 (PST)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a9360348-c6a0-bb2f-6424-281e041153cd@gmail.com>
Date:   Tue, 11 Feb 2020 23:59:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 11:37 PM, Rafał Miłecki wrote:
> Hi, I need some help with my devices running out of memory. I've
> debugging skills but I don't know net subsystem.
> 
> I run Linux based OpenWrt distribution on home wireless devices (ARM
> routers and access points with brcmfmac wireless driver). I noticed
> that using wireless monitor mode interface results in my devices (128
> MiB RAM) running out of memory in about 2 days. This is NOT a memory
> leak as putting wireless down brings back all the memory.
> 
> Interestingly this memory drain requires at least one of:
> net.ipv6.conf.default.forwarding=1
> net.ipv6.conf.all.forwarding=1
> to be set. OpenWrt happens to use both by default.
> 
> This regression was introduced by the commit 1666d49e1d41 ("mld: do
> not remove mld souce list info when set link down") - first appeared
> in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
> Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.
> 
> Can you look at possible cause/fix of this problem, please? Is there
> anything I can test or is there more info I can provide?
> 
> I'm not sure why this issue appears only when using monitor mode.
> Using wireless __ap mode interface (with hostapd) won't expose this
> issue. I guess it may be a matter of monitor interfaces not being
> bridged?
> 

This commit had few fixes, are you sure they were applied to your kernel ?

9c8bb163ae784be4f79ae504e78c862806087c54 igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()
08d3ffcc0cfaba36f6b86fd568cc3bc773061fa6 multicast: do not restore deleted record source filter mode to new one
a84d016479896b5526a2cc54784e6ffc41c9d6f6 mld: fix memory leak in mld_del_delrec()

