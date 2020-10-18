Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF5D2918B8
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 19:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgJRR6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 13:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgJRR6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 13:58:00 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279F6C061755;
        Sun, 18 Oct 2020 10:58:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h24so10735668ejg.9;
        Sun, 18 Oct 2020 10:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4hx47BWTJjsGsLu4Less5UE+DZo76CfuIy6uaI3gSUg=;
        b=qeoY68eob67z8DetLqAuvlcHgLMke3Cj5cdrmlbXl/nkMpAgrVpIRGKZQHHwJukmYO
         /l+/EwLn829CgCqaUsuZTcwHE85CEszBGMi3gVhy4GHIG22q4V8oL342K1KtwMkpYTTj
         ZdLQlK2mKKIgpqsX8GVJSY1DZ3B4nivbGHDRZ9qslP/dTwPEQID5JyEN6f/2NNE2gxwR
         c/qwlEMMOzPwkpKjJYm+VcLzaoArk6nGx00lhXSC2Jp8KVAv1ago8VCUzsP2KohMjTFW
         5QFk0ZGJGwJ3nsoFRolelAP7rubBqLqG4DArPB4LYNfj+BQPoMi3E2436CrFpk11bpJI
         6QEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4hx47BWTJjsGsLu4Less5UE+DZo76CfuIy6uaI3gSUg=;
        b=tLWeRuzn+rChDF+k2M6ZcUV1CHuuBz7DTaqTBjqM6dsryxX4J4Od2rEGA6FX4hqLoz
         afJy/WLiG7JYCytKlfn6ty/yjc1d7v064UBZ5+k8XLFQCowGypUWD5eCkHikpv8Mt1kD
         /XmTC3MqLlP95zA8wBk/qtGa6fvOgA+ztNvs8v5LQhIUKZL0AZZl3P0WZ66V4mnfTg9P
         uX0vf3YIv/GY7fi7ZnTf0mMaSKRVQv5Cz6YvlmpGR7opN99FNJMs0y+syk0p7tH0ANHu
         NM3BGRfBl7dtasP0LYqTywQRX7CwtUlCqlZ64AgE4WMp58G7kK1zMP0pVeLUJFpLF2Hn
         rw8w==
X-Gm-Message-State: AOAM5328Ysj3LUIWK5VSGTbqh6iUsyoLc7pnrlC7N3P7Aq9kTMZydku1
        Bug6+r8hrX/tqKXp3ZAV7XIiYk6Td+U=
X-Google-Smtp-Source: ABdhPJz6HUnzi8ts3hfbHYcMLIEzhFOcRh3jLCexC+2twjSiujz2tp5wMZ3SF8JodHbeAcIFWuAEXg==
X-Received: by 2002:a17:906:7f8c:: with SMTP id f12mr14352092ejr.8.1603043878606;
        Sun, 18 Oct 2020 10:57:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id k23sm8116468ejk.0.2020.10.18.10.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 10:57:58 -0700 (PDT)
Subject: Re: Remove __napi_schedule_irqoff?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
 <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
 <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
 <20201018101947.419802df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <92aed1ab-efa3-c667-7f20-8a2b8fc67469@gmail.com>
Date:   Sun, 18 Oct 2020 19:57:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201018101947.419802df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.10.2020 19:19, Jakub Kicinski wrote:
> On Sun, 18 Oct 2020 10:20:41 +0200 Heiner Kallweit wrote:
>>>> Otherwise a non-solution could be to make IRQ_FORCED_THREADING
>>>> configurable.  
>>>
>>> I have to say I do not understand why we want to defer to a thread the
>>> hard IRQ that we use in NAPI model.
>>>   
>> Seems like the current forced threading comes with the big hammer and
>> thread-ifies all hard irq's. To avoid this all NAPI network drivers
>> would have to request the interrupt with IRQF_NO_THREAD.
> 
> Right, it'd work for some drivers. Other drivers try to take spin locks
> in their IRQ handlers.
> 
> What gave me a pause was that we have a busy loop in napi_schedule_prep:
> 
> bool napi_schedule_prep(struct napi_struct *n)
> {
> 	unsigned long val, new;
> 
> 	do {
> 		val = READ_ONCE(n->state);
> 		if (unlikely(val & NAPIF_STATE_DISABLE))
> 			return false;
> 		new = val | NAPIF_STATE_SCHED;
> 
> 		/* Sets STATE_MISSED bit if STATE_SCHED was already set
> 		 * This was suggested by Alexander Duyck, as compiler
> 		 * emits better code than :
> 		 * if (val & NAPIF_STATE_SCHED)
> 		 *     new |= NAPIF_STATE_MISSED;
> 		 */
> 		new |= (val & NAPIF_STATE_SCHED) / NAPIF_STATE_SCHED *
> 						   NAPIF_STATE_MISSED;
> 	} while (cmpxchg(&n->state, val, new) != val);
> 
> 	return !(val & NAPIF_STATE_SCHED);
> }
> 
> 
> Dunno how acceptable this is to run in an IRQ handler on RT..
> 
If I understand this code right then it's not a loop that actually
waits for something. It just retries if the value of n->state has
changed in between. So I don't think we'll ever see the loop being
executed more than twice.
