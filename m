Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D85211BD5
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 08:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgGBGOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 02:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgGBGOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 02:14:39 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C6FC08C5DB
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 23:14:39 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g2so15260007lfb.0
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 23:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrounds-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/rMuyuvEyEfi/6FryOT8XNai0M0Cykvyrz5tU+jLoo=;
        b=Cis4kNAoB7Bzb9zXm4S1rMZfQDTsxKJCUW7enqkypgJkJiiaentFQ9x+VfJAUjA9F5
         pBpF6yLg7sKhk/mKJIPZdVnI+BAaykmLkjd7XirSvZsn5XnZYCCkOfBIgwWh8SMt7cJS
         TJ43WS5jMb7zmZH6OGsaZjHjgFqiYgN8DBZh8vM127eJ/kING+BWHao3CXyCN1AEGXHa
         JYLvJKHwkb4vVdIlq0HuwDG6pBgxuz5TwMP3vd3Y6xZAzCrraW0UCAt0W8DERReC3WJ9
         XQkB08hl789zTjELaaTwAiklcpOmeOU7cjV2tfdy2/oIIVi085TmagrF6I0jHtRjMzBA
         LwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/rMuyuvEyEfi/6FryOT8XNai0M0Cykvyrz5tU+jLoo=;
        b=BX+i0vMBLv5B5Y6rIhQqLLx5pMPsMeRUkdw9AhwqwtkYPhv7W6gA24B/Y2wg14IJcB
         Zi5soHY613Nitn9i2ED70uNI1kduTk9DPk7I8Dr1dFS25A18e/W/IxEfJY0O4eWdypt1
         gntnuTZldfmyT0Lf7vEKwGXy0+WwUD2a9I7fnyavOqJ2/2jFxMUKxJ3onmxOjEHmOR+F
         QecWNn0ifKMiuDvTYvo2hgrjF8cVxdg29KiaTcuHwZrridTcLU4lknw5YlDU2IodrV8k
         Bff2UcyEOd2X1DHraZMKiItr76O0zF2R/rNRn40iaTxlNey8bd42L/H4CmYP4AImxcMv
         JNiw==
X-Gm-Message-State: AOAM533/C4ldFfG2QqoDO+QcJ0qWNzA42AYercd/wO5LanubbkBLhhM8
        RMl80zOrXdkbAxhMgBqZnNmaortCNN34Sw==
X-Google-Smtp-Source: ABdhPJzqeXTumbtaMxqGyuknh6nk1NxCfny6HrJGFO+DKXdPGrlnzEn2wsPfFPuwQOirZ6ykNyG3FA==
X-Received: by 2002:ac2:5a50:: with SMTP id r16mr17945836lfn.170.1593670477459;
        Wed, 01 Jul 2020 23:14:37 -0700 (PDT)
Received: from [192.168.1.169] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id m2sm2574458ljc.58.2020.07.01.23.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 23:14:37 -0700 (PDT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>, Josh Hunt <johunt@akamai.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
From:   Jonas Bonn <jonas.bonn@netrounds.com>
Message-ID: <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
Date:   Thu, 2 Jul 2020 08:14:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On 01/07/2020 21:58, Cong Wang wrote:
> On Wed, Jul 1, 2020 at 9:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
>>> Do either of you know if there's been any development on a fix for this
>>> issue? If not we can propose something.
>>
>> If you have a reproducer, I can look into this.
> 
> Does the attached patch fix this bug completely?

It's easier to comment if you inline the patch, but after taking a quick 
look it seems too simplistic.

i)  Are you sure you haven't got the return values on qdisc_run reversed?
ii) There's a "bypass" path that skips the enqueue/dequeue operation if 
the queue is empty; that needs a similar treatment:  after releasing 
seqlock it needs to ensure that another packet hasn't been enqueued 
since it last checked.

/Jonas

> 
> Thanks.
> 
