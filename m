Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7F1454E01
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbhKQTiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240658AbhKQThz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:37:55 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8C2C06120C;
        Wed, 17 Nov 2021 11:34:43 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso6573523otg.9;
        Wed, 17 Nov 2021 11:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fKgROiTnocpd07KSckUqHL0oP7FUhobr1NuqsBnlJ7k=;
        b=OckgS1Ml1G8zKBzp/7G1jNUmwj2Acasrksgsp4unQwH51Gw2x5A83pjHl9fjdiZPXW
         4Dp2C/u4g/HqQRYKw6Cst3RgTjzzSuGWRKCy8YUdnp5Wnj3qL+v/rfXN+iepPNRR9wnS
         UYL9oopPx+/CmkQDq6HO028yfmyETbcZdc+Q+ou3KYDAHDKanU3cx0etQLQfy0Z8J3/U
         Yx4Xkq2F/ItRrOZM9S0KTZLsJ8HYsV81CXPdlC6v+w89Txr+oQQ80NsIoFhfU30oUurY
         M8SOK8Zu8rHq/Onz8sCqxlFQZeKFjPDcEaQ7T/37zuUbGxRxC5EowWhsWwbwNLM0cuvj
         ssjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fKgROiTnocpd07KSckUqHL0oP7FUhobr1NuqsBnlJ7k=;
        b=4700ZPS58WTrYDLh9HnYpxZcBv6jM+SBx72VppkXCw+arrq8X8R+oHsU46lZMD7YrS
         idEmqW8wE5BXhfuFYysgQ5otOOcMaNl37xvy9vEFtWBtpC18p75FILKuS3PD2sfmja9t
         ZFWbIAhnw+54/F2BopNEgM+3efgHfHaXrgsDHq+wjLEG+1dKyLM1Hz5uQS0fRs2z62Ah
         og0s2q5PDK6lSXhe4sT/QG8sKCoFiSd6Zt178CXIYevhxkV1sZLcyv/lwM+lbvjQVj12
         i2xZ6eJclwsvKghWBCtUdWD2tJ6Fo47Vfx0SbOQCnx0fyQ3NnvrzH20XqHdMFDx/ctQT
         2v9A==
X-Gm-Message-State: AOAM5331IsQ47ghUNqIRy82pS6WpRRRIeoYb2xH6I1GlAZJuKKkpG1ko
        Q9M05qr5mydclQ9W2Izj+jk=
X-Google-Smtp-Source: ABdhPJwIv96O+pZ0HD0fwdLNgLNXaLHxOcX9zSHrlHezQG0C1fxasXeMFvqxNJctOw292EGvY48GuA==
X-Received: by 2002:a9d:6641:: with SMTP id q1mr15936411otm.323.1637177682815;
        Wed, 17 Nov 2021 11:34:42 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o2sm184062oiv.32.2021.11.17.11.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 11:34:42 -0800 (PST)
Message-ID: <a15db099-a83f-69bd-2cbb-420055087904@gmail.com>
Date:   Wed, 17 Nov 2021 12:34:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next] neigh: introduce __neigh_confirm() for __ipv{4,
 6}_confirm_neigh
Content-Language: en-US
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211117120215.30209-1-yajun.deng@linux.dev>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211117120215.30209-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/21 5:02 AM, Yajun Deng wrote:
> -		unsigned long now = jiffies;
> -
> -		/* avoid dirtying neighbour */
> -		if (READ_ONCE(n->confirmed) != now)
> -			WRITE_ONCE(n->confirmed, now);

Just move this part to neigh_confirm and leave the rest as it is. That
READ_ONCE, WRITE_ONCE pair exists in other places that could use the
neigh_confirm style helper.
