Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D82354534
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbhDEQd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238558AbhDEQdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:33:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC989C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 09:33:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s21so6353161pjq.1
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 09:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=692RzP2XNLkViuazF9VmOw2T8IJC35Rfwh4Hdr97wxg=;
        b=ldKGZKgOpHbJNrRKdSmhkZwzi9kaHyvfxWR4RfHYecHezkl7ablod9KUdGupj7XO7I
         K7/bwmCD/KnV7/mMszrSBUNY6bgdkLUwbOZAGwtccbJdLFW26hU75ikoLeIhSauDx+oK
         7ixOVsSnWxFkt7sfUFOHGY5yZah4b4b6TM7RZL4UBuY9UzmUzmNiC+FvpScbXgbxgw04
         xsp93mocL14K1PhwR7jOXqIcypWMcrsZWbOMvPDw5BnLWS0ytA9wMESb3cvcqM1JpbLO
         zuNqY00uhIoZfsN07bIMOTMszvYpGwziDOzaKpLIqOXdAzpX5Ss2Duh0uXVZfPCsZLnK
         n5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=692RzP2XNLkViuazF9VmOw2T8IJC35Rfwh4Hdr97wxg=;
        b=QVMlxPIYVTuEVduU+j9w2E9XQNvsOuXRwGOfIq7/OVXTxbNXecPtFcwQj3Cgk3T+4k
         gPgERN5olk6953w1DGqv9OKesAPFGA0vKta9uIhUjQxTWtYKSHZzlbw8jOaHaarZpf7A
         BtOIQirlBvHQEAPiQYbA4QANN2iW8yLklG6QgkTiTKigXXt88nEUNDcoYiZCBxvmZ8fi
         tigRDvFyG4qFQ+CDTR/xkROJrDM5ra6p7IUm6mBiDk/PqSCokB6swaQTdpRhFilbybYw
         fI2bw2dj4CKvSTJex1pFxIxHfUaR2NuY/BrXqaBfOcs7hHV8khKdSc5O3VwOo656LyUo
         6yRQ==
X-Gm-Message-State: AOAM531eNxRwF8SXOurngu20JDJJ3/bBuVxEO+WsPvWNcy1mfukloq4j
        iggmBOHhHS2VfM8NI0Rt2Yn07w==
X-Google-Smtp-Source: ABdhPJz9QbvDtbQNd6QQgV7DzSeVz51TgIirSXKhifx08iOX/0e9SOEtGmtcRkdf1+FHRJp3vbLxjg==
X-Received: by 2002:a17:902:9008:b029:e6:f37a:2183 with SMTP id a8-20020a1709029008b02900e6f37a2183mr24897405plp.49.1617640428322;
        Mon, 05 Apr 2021 09:33:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c25sm15849428pfo.101.2021.04.05.09.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:33:47 -0700 (PDT)
Subject: Re: [PATCH net-next 12/12] ionic: advertise support for hardware
 timestamps
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-13-snelson@pensando.io>
 <20210404234359.GE24720@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <58f57a07-ef4c-c408-652d-708647f44e3d@pensando.io>
Date:   Mon, 5 Apr 2021 09:33:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210404234359.GE24720@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/21 4:43 PM, Richard Cochran wrote:
> On Thu, Apr 01, 2021 at 10:56:10AM -0700, Shannon Nelson wrote:
>> Let the network stack know we've got support for timestamping
>> the packets.
> Actually, you already advertised the support to user space in Patch 10,
> so this present patch should go before that one (or together).
>
> Thanks,
> Richard

Yes, I supposed they could have gone together.  However, I believe that 
in a bisection this will only slightly confuse the user space tools, but 
won't cause any kernel pain.

sln

