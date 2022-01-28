Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0C49F1C7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345717AbiA1DYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345716AbiA1DYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:24:01 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44940C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 19:24:01 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id v74so4903056pfc.1
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 19:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F8qZzbLyMefXFLekS9EWzZDbHPpDVewfVnVbFGUE+gk=;
        b=WRNLE+oCF+WPh6+G5LO5bF/6MeS8Sa2bHoQphIG/qoCP4jm0SnIcLaHcQ3WjvB5r2m
         KPvBghTWZPgUwsCkL0N4n2svobEVpUwBUueUjpNKqjbPT3lZ3P8LgLqAwIwD3rQ+Q0DO
         QV+eI0IbTLuuuiyZfv72b/FRCXdhO7f3Q15B/eMofiIWxiFSFiPzNsH+8BbPb70XHZlZ
         0LGHhGWeQcMPiacOv1duR2AT4kFXB6BqdCxWj5oFHMtRk91dOEmEOCno0Q69mbpxfg23
         fRrHzW8+kUUxWRN5FnBozeDh0XiqxQwdQE3EqsvmhrpVJf5tIAspnvLxCZcl07O9q3S+
         QQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F8qZzbLyMefXFLekS9EWzZDbHPpDVewfVnVbFGUE+gk=;
        b=qaXiD9lMxb2qeHJ8aGxzWOJ6in8ueVW3ojdv0NH6lHE3NaeWcJ7hgGGFZZQolkL07I
         fOPakyk8qNW39ojDDEWZ+DM2y4uglXEH3FUBtjpBhxsZC2wn4wVJZWnVR7KgjwzhS8Uj
         j+ZuCOrp9KszJ6D5gU6B3mm/gtM/kVU6J3F3JVT4ZpGE4BML0/CDxN6TB/xWZG7WJd8E
         3EfQaStVE3n00k1uKHWFnrM/Q4g99gepgyZl6KbUnFXkBaJLmWIGh7auzyG9hW6Pe/GK
         P6OWHhtanUutW+bZUwgYAwMWxJr5ky97mxIg8togMmidPe0GdpFxOU9RVWOy5DGT4bba
         xbUw==
X-Gm-Message-State: AOAM533x1WXCiWooufeY/gDflxlgki5GZXXFaFsxbGigNnI8NL2PcG6V
        df941mBPoeFSEq7c0lFDE+SfqXdUZ74=
X-Google-Smtp-Source: ABdhPJynUjJbDQhnzL+dI0gb8S2WdXyvarAyesowE51lFS93X7JWPQJAnnha03dXbUM8Wxp6j3t4xg==
X-Received: by 2002:a63:84c7:: with SMTP id k190mr3547137pgd.354.1643340240823;
        Thu, 27 Jan 2022 19:24:00 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id mt14sm650869pjb.21.2022.01.27.19.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 19:24:00 -0800 (PST)
Message-ID: <76fb2bc3-9f9c-cf5c-02f5-3a5da2312ad1@gmail.com>
Date:   Thu, 27 Jan 2022 19:23:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [Question] memory leaks related to TCP internal pacing in old
 kernel
Content-Language: en-US
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>
References: <a691ee96-4be3-a0dc-fadf-a14e4c0aed2f@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <a691ee96-4be3-a0dc-fadf-a14e4c0aed2f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/27/22 19:22, Zhang Changzhong wrote:
> Hi Eric,
>
> We encountered a memory leak issue related to TCP internal pacing in linux-4.19.
>
> After some searching, we found the discussion about same question [1], the fix you suggested
> solved our problem, but this patch seems to have been forgotten.
>
> I wonder if there are any other issues with this patch? If not, would you mind submitting it

Thanks for the reminder.

I had this back on my plate two weeks ago but got distracted.

I will submit it.


> for stable branch?
>
> [1] https://lore.kernel.org/all/20200602080425.93712-1-kerneljasonxing@gmail.com/
>
> Thanks,
> Changzhong
