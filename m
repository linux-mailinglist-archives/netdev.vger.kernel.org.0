Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9590B131DD4
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 04:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgAGDGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 22:06:01 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43105 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGDGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 22:06:01 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so27780369pga.10
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 19:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=cCcJTzFat8E3qy6mAyoS0Jvt5FkYWkUO+7kQE3vm+vs=;
        b=uDPqt9V5uCcPNiztTpnRVqkbYuXFYajFmILa8JoPkoqfdqcDY75UHBdNZPB600fY5j
         D6gBLF43U6Kvdlj4Fm5u6/HarhnuSFGamMGYuWR4HaIMlzE6U2DAnuuk2YulWENc0hZ7
         9HW77ZqOe+lxq2uHUk2NCWAZrqKw07ZVILy/pRv4SLgBNfua9qUt/tBnr3t8/3a8RYjN
         bxe1DIRV8zYfiiyWxboWS5W/kYZa6mWaBCR5tXZ7jE8nsl/1fr8lKuNOmawq1DDhb+ul
         fQEEzkj+11/weVK8es0RH5MfyRxQjKF50E9dAMgQV4EWokFjjwrbYaQb4naEePfdbF0K
         qrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cCcJTzFat8E3qy6mAyoS0Jvt5FkYWkUO+7kQE3vm+vs=;
        b=WUzp6O/qO1/z0wNDNeFBWlnQp1WTqasDB6hKabY361w4HyCVOddFFppCvHQfdVlSaH
         o/vVrZsNurYCJGxYebT8c5FGdpqpL9DKHPQx6O8hx7UMTRZnledRok3zJTMbfd+6jqoN
         n1kC3YGh0cMKlINxT7eyAbJA0kLLmLcecPZ7nKXyPlUbVCkRWn2wV7qqhkZvE/vt+Wuj
         e30A+xYbePxUbbTAwgUwottrVx4On2AkO8Cu2yCdXd5TiiA9kQomXnzzmK7nKHr+d2Db
         OustrcsbWoPlbQfn7pNibcQDACZklGNUD3fxSG2q+MEkSwC1E6NyKPS9VEKSBWc8Feo1
         urVg==
X-Gm-Message-State: APjAAAUBbyknKKWWmaM2X3TXl8UEBxhmHKXKcgMHRHJzG9a9d+LB2wks
        eKM0oarwqtlRU5WN0fIi1E5cJ2wrmk0=
X-Google-Smtp-Source: APXvYqyMxwY4zaLiUNSwDGQW1bFtCsZHd+L1+2qfVzTBXZ6G90Dd841ktFtvA2XvnpFy1j7TaUhQJg==
X-Received: by 2002:a65:56c9:: with SMTP id w9mr110023062pgs.296.1578366360444;
        Mon, 06 Jan 2020 19:06:00 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id v10sm67571479pgk.24.2020.01.06.19.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 19:06:00 -0800 (PST)
Subject: Re: [PATCH net-next 2/4] ionic: fix for ppc msix layout
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200106210512.34244-1-snelson@pensando.io>
 <20200106210512.34244-3-snelson@pensando.io>
 <20200106.184216.2300076228313231081.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <1f3ea5ee-da18-7695-a477-d65384a480bd@pensando.io>
Date:   Mon, 6 Jan 2020 19:05:59 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106.184216.2300076228313231081.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/20 6:42 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon,  6 Jan 2020 13:05:10 -0800
>
>> The IBM Power9 ppc64 seems to have a problem with not wanting
>> to limit the address space used by a PCI device.  The Naples
>> internal HW can only address up to 52 bits, but the ppc does
>> not play well with that limitation.  This patch tells the
>> system how to work with Naples successfully.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Then dma_set_mask_and_coherent() should fail, either that or the mask
> being passed in isn't correct.
>
> There is no reason this hack should be necessary in any driver.
>
> Our DMA abstractions are built to handle exactly this kind of
> situation.
>
> Please find out what is really going on and fix this properly.
>
> Thank you.

Unfortunately, we spent a bunch of time with some IBM support folks and 
this is the best they could do for us to get it to work on their 
particular (peculiar?) box.

I'll pull this out of the patchset and let them know its not going to go 
upstream.

Thanks,
sln


