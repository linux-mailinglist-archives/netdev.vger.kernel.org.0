Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F5218E1E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgGHRTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHRTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:19:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350F0C061A0B;
        Wed,  8 Jul 2020 10:19:04 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q7so41900656ljm.1;
        Wed, 08 Jul 2020 10:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=5JvxYDMxfu2QIiI4ijZRK8l91niq2hk2cYfpZHrXrrY=;
        b=sgiOjnyGEtnySkVWawBo0pWovsuKcHP9nmEwxy6aGc3wmaTlQ9j9h3CI+A2f7exiKf
         pwWVfHfPMOV+7FISikwrtg98Qmfj5ry4PmLr0GZ7DwUgZaqdMjHepmRKPlO4WaU27SM0
         XeRSEenW11wTPT9ayiVSdEXBIno6S9kl2tY4JrGkhGv1vV9jWu4vFuTvJPZx7S6+1spq
         1T4PKhwQqiiT4ORVN+PMBUtSS/elzq+6Z9W0dXMCX8CrDEmAUBJE6XOPtsefGjHZEMRp
         RGbOQM+q4YNbiIAhunn2/devSFm0+gOlPOGVzsbkEMmz8p9CHcY/Cfg6d9k4IYEt+Ghp
         6TKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=5JvxYDMxfu2QIiI4ijZRK8l91niq2hk2cYfpZHrXrrY=;
        b=SYj9/Nb8LYjg4d8gICCX2NFp/rBVi6iMIIs7E/ZJcpDKKLkthuUE94+dMTquA9z40b
         /fjbLBpM72QTM1JbMdhG/XjAZYdk+v+c8c1D52wsGNPs44QkPKRpFEGYXAPw/JpPmkkw
         BrXEQTu2hwj412cKOZySzdP6SIi302JUMt+kzJNgZ5l+G9CVZ5zusS3YgVOFuJgE/Qds
         PumtZ5TvZ33nMGmG+B/36dqCUmPyQmXOfuKnatjL512u8maU8CMhaZSzZqKblvgrEgYg
         6ioDPoWH9MoZC3mBgEwz8qejLVEQEEga4EYcnxFJq55SvZro2XzmthCmz/G8qEplvD8N
         73ZQ==
X-Gm-Message-State: AOAM531qIaX3wmKC8BCVlq+g6hYVJyS6W1s9PABRM4T7v7TuQmENZBMP
        CmF/gHnwrrwYOHurW542L7c=
X-Google-Smtp-Source: ABdhPJye8r7on70k5YrY8igIM2Hgo4v6aoGyNm09x6jPdMCI/7B30UA3v0jGzjru0Ny4nrz6PZ9BIA==
X-Received: by 2002:a2e:6f08:: with SMTP id k8mr33420757ljc.384.1594228742491;
        Wed, 08 Jul 2020 10:19:02 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id y13sm98686ljd.20.2020.07.08.10.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 10:19:01 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-4-sorganov@gmail.com>
        <20200706152721.3j54m73bm673zlnj@skbuf> <20200708110444.GD9080@hoboy>
        <87mu4a9o8m.fsf@osv.gnss.ru> <20200708144803.GB13374@hoboy>
Date:   Wed, 08 Jul 2020 20:18:49 +0300
In-Reply-To: <20200708144803.GB13374@hoboy> (Richard Cochran's message of
        "Wed, 8 Jul 2020 07:48:03 -0700")
Message-ID: <87k0ze7wna.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> On Wed, Jul 08, 2020 at 03:37:29PM +0300, Sergey Organov wrote:
>> Richard Cochran <richardcochran@gmail.com> writes:
>> 
>> > On Mon, Jul 06, 2020 at 06:27:21PM +0300, Vladimir Oltean wrote:
>> >> There's no correct answer, I'm afraid. Whatever the default value of the
>> >> clock may be, it's bound to be confusing for some reason, _if_ the
>> >> reason why you're investigating it in the first place is a driver bug.
>> >> Also, I don't really see how your change to use Jan 1st 1970 makes it
>> >> any less confusing.
>> >
>> > +1
>> >
>> > For a PHC, the user of the clock must check the PTP stack's
>> > synchronization flags via the management interface to know the status
>> > of the time signal.
>> 
>> Actually, as I just realized, the right solution for my original problem
>> would rather be adding PTP clock ID that time stamped Ethernet packet to
>> the Ethernet hardware time stamp (see my previous reply as well).
>
> I think you misunderstood my point.  I wasn't commenting on the
> "stacked" MAC/PHY/DSA time stamp issue in the kernel.

I think I did. It's rather that initialization value of PHP clock has
consequences in MAC/PHY/DSA, and there is no way to check any flags
/there/. And it's exactly the place where I needed the info, see
background explanation below.

I understand what your point is, but I try to explain that it's
irrelevant for my particular use-case.

>
> I am talking about the question of whether to initialize the PHC time
> to zero (decades off from TAI) or ktime (likely about 37 seconds off
> from TAI).  It does not really matter, because the user must not guess
> whether the time is valid based on the value.  Instead, the user
> should query the relevant PTP data sets in a "live" online manner.

I'm implementing PTP master clock, and there are no PTP data sets (yet)
in my case, as it's me who will eventually create them.

>
> For example, to tell whether a PHC is synchronized to anything at all,
> you need to check PORT_DATA_SET.portState and probably also
> CURRENT_DATA_SET.offsetFromMaster depending on your needs.

These are fields of PTP stack software that is not running in my case.

>
> In addition, if you care about global time, you need to check:
>
> TIME_PROPERTIES_DATA_SET
>   currentUtcOffset
>   currentUtcOffsetValid
>   ptpTimescale
>   timeTraceable
>   frequencyTraceable

I'm going to become PTP master clock, I already have very precise
estimations of PTP time, I know UTC offset, all this independently from
any PTP stack. Moreover, I've already synchronized PHY clock to this
time scale with +-5ns accuracy, and then I suddenly get somewhat wrong
hardware time stamps for Ethernet packets that I send/receive. You see?

Setting initial value of PTP clock to 0 would allow me to figure what
happens (time stamp coming from /different/ PTP clock) half a day
earlier. Not a big deal, I agree, yet I wanted to help a little bit
somebody who might happen to run into a similar trouble in the future.

Thanks,
-- Sergey
