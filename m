Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD45929208F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 01:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgJRXLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 19:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgJRXLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 19:11:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC961C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 16:11:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l18so4931322pgg.0
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 16:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZC2XV0rDP18emYrvaZPnFix73dSXeyGVbU3UcjNBAJE=;
        b=hmamVEH1dkEzDAva9KAmEJG2A+E3d6BmAwv/z1P5G044cZkjxXib9Mr6u0tHcUcesS
         JNAZXSCTUzjKB6WCQl7WL1bp6DbzxQUH6fM4j36mcQ0v3lTPtucVSxzXsisGf7Ocobqg
         QsTkFr2a1kYMRJdk0HOQNRqF7TRKq2gFOt5ZaE4HTkx7YqhYgnfty8WT9t8vRGDqi6uV
         HnDoNpnxD58onuYiWED7AfmOYqGqg8vHGpCJ1LEobuMh2lPTCu5LWLwfsSm7GzO7mJoZ
         DEImxxgPP8Cou+HzRs1C6fGvU/7CNUhCn80myZ34FCGWPGJIc/ulMIKbUJcLMqJdy3uK
         jhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZC2XV0rDP18emYrvaZPnFix73dSXeyGVbU3UcjNBAJE=;
        b=I1lqObMNjWLxzTLqGJNpss1wE1GbbGXh8xMtEqwbF7dDaU5FAfEMp9J8r6dX42T5aB
         To0SKE57oI3PnHWeCBpRakAKJppcOPPEgPdmITS/2EVbXZdNw3aH1n1/8t1okFR9oAdZ
         lvyACuTkQLarSjw3ONCpeDaEy4D/s69sFZYUy1l+0QnWdJpLAXEJtqnO3DxPyxMgC0z5
         NiC4e7RDrqOBwoEmlt4vFgQWcnwiFh4SxZiTTATFXGvco+oKPyNJSLVq0ep+CCksA0FG
         hPMcoLRa/thvShk8QsTsHTpYjUSZENfswnKlMfKOHuR70S17wfpNNZtFy1pB8rqo2lJJ
         z2pw==
X-Gm-Message-State: AOAM5304wwn2SdpAjWPaDLki72c49Tnnq+bcxmV+TXoIBJLY1K8COfPQ
        lhk9EObyQ/+0YQ4sI62RvAA=
X-Google-Smtp-Source: ABdhPJxTI2I+NpC/N5TYVJR/VEmrDIoUQ8OjZMuSGY83wZtS7Mjn0YMTEjJ9F54QpLsN2AtNnMp1kg==
X-Received: by 2002:a63:9508:: with SMTP id p8mr11987436pgd.189.1603062682173;
        Sun, 18 Oct 2020 16:11:22 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t6sm9839548pfl.50.2020.10.18.16.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 16:11:21 -0700 (PDT)
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
 <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
 <20201018225820.b2vhgzyzwk7vy62j@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b43ad106-9459-0ce9-0999-a6e46af36782@gmail.com>
Date:   Sun, 18 Oct 2020 16:11:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201018225820.b2vhgzyzwk7vy62j@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2020 3:58 PM, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 04:13:28PM +0200, Heiner Kallweit wrote:
>> On a side note, because I'm also just dealing with it: this_cpu_ptr()
>> is safe only if preemption is disabled. Is this the case here? Else
>> there's get_cpu_ptr/put_cpu_ptr.
> 
> lockdep would shout about using smp_processor_id() in preemptible
> context? Because it doesn't do that, and never did, but I don't really
> understand why, coming to think of it.
> 
>> Also, if irq's aren't disabled there might be a need to use
>> u64_stats_update_begin_irqsave() et al. See: 2695578b896a ("net:
>> usbnet: fix potential deadlock on 32bit hosts") But I don't know dsa
>> good enough to say whether this is applicable here.
> 
> DSA xmit and receive path do not run from hardirq context, just softirq,
> so I believe the issue reported to Eric there does not apply here.

How about when used as a netconsole? We do support netconsole over DSA 
interfaces.
-- 
Florian
