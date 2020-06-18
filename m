Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C01FFB68
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgFRTAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgFRTAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:00:16 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43800C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:00:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v11so3323283pgb.6
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C9P/BhtRBQll7pLLswc1f7nY27mV2PUMATDg0y1bo44=;
        b=ncSguRIDLAxvbFTv7LpQ2sEdcwkaZzGlO6YQIbXR8Amk9R5PBytF28y89SKfnV7Vsy
         memM4+Lm1vaobEJ6tsnnIwetIbn5HosUVO2Lm0BuFmXgPbl3P3GkMvCNrAr4fER9iNpm
         5qKGYEUE3GZRtPJ6EyzU15qYOpcMZ2UIa1qh6B8XXK7LE5Z1OHunde5DvdIlrd35IJmd
         RCZa3O6VmXS0c5N14tAcni4bhZFBoIoz4EcADzOAHhD5Vk6XlkmMnlbP6qGi236e/MEI
         MDCTe+IRj1Kui/MUFSlHwA1hnqyRqKmE84GCLMsNyClR7aMJO1ENpx5M5fKUsWpKDCZy
         0OEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9P/BhtRBQll7pLLswc1f7nY27mV2PUMATDg0y1bo44=;
        b=pkxZyyVHh82hvrqKGsTvEs0j/BJOOtwyEznE/e0mDRrVbv3Nemf1lp7NCmyPfTT/Uy
         PBa45iYVA47wPETUi4hSu/8tEc4dB8sOqtmy20dD1achPYKGlQ6sEGSAZd05MyDe9LN7
         uu+m4bnFsd3it+/V9O1B1HBEV2mggIXTrA8/t1tOjh7xsvMmXaRuTPN2dw+OSFWjyPR6
         0aa0c4EzXvsQB3GWgp67DqmWjoAhcYGTBVRoscOwgKSFdbpa/mfNlN6U9Wl3r3i0c2OS
         rg9t40b97DiQmj8gdJzEGAlQQKt+ZEAGL15sMx5j8kSUNOA1AbINIbjqjdqfout00GTN
         k70Q==
X-Gm-Message-State: AOAM530GoM94dc8nwKV/y6Eyr4duwzSProP8w7vL1H1LgZf1EPhY0x57
        /YVInyGnucbpMDJ/ZplahwBcKK82
X-Google-Smtp-Source: ABdhPJyVr59PZX4Ep827T2c/OR/d+QeYPTrFuxzYDJhWrrSkCSBpqqWLW+LkmyTYy1ldALiHEpY0uQ==
X-Received: by 2002:a63:6343:: with SMTP id x64mr40572pgb.96.1592506815496;
        Thu, 18 Jun 2020 12:00:15 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s188sm3473865pfb.118.2020.06.18.12.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 12:00:14 -0700 (PDT)
Subject: Re: [RFC PATCH] net/sched: add indirect call wrapper hint.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <da175b76ca89e57876cf55d3d56aef126054d12c.1592501362.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0240746c-1dd1-4822-261c-03ff13854db2@gmail.com>
Date:   Thu, 18 Jun 2020 12:00:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <da175b76ca89e57876cf55d3d56aef126054d12c.1592501362.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 10:31 AM, Paolo Abeni wrote:
> The sched layer can use several indirect calls per
> packet, with not work-conservative qdisc being
> more affected due to the lack of the BYPASS path.
> 
> This change tries to improve the situation using
> the indirect call wrappers infrastructure for the
> qdisc enqueue end dequeue indirect calls.
> 
> To cope with non-trivial scenarios, a compile-time know is
> introduced, so that the qdisc used by ICW can be different
> from the default one.
> 
> Tested with pktgen over qdisc, with CONFIG_HINT_FQ_CODEL=y:
> 
> qdisc		threads vanilla	patched delta
> 		nr	Kpps	Kpps	%
> pfifo_fast	1	3300	3700	12
> pfifo_fast	2	3940	4070	3
> fq_codel	1	3840	4110	7
> fq_codel	2	1920	2260	17
> fq		1	2230	2210	-1
> fq		2	1530	1540	1

Hi Paolo

This test is a bit misleading, pktgen has a way to bypass the qdisc.

Real numbers for more typical workloads would be more appealing,
before we consider a quite invasive patch ?

What is the status of static_call infrastructure ?


>  
> +#ifndef CODEL_SCOPE
> +#define CODEL_SCOPE static
> +#endif

This looks additional burden, just remove the static attribute,
if a function might be called directly.

Eg, we have EXPORT_SYMBOL() all over the places, even if the modules needing
a symbol might not be compiled at all, or being part of vmlinux.

Thanks !




