Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B5ED5F01
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 11:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfJNJeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 05:34:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46026 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbfJNJeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 05:34:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so18794569wrm.12
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 02:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=McKWTdHCX45PVDsiOqdh5g6L/nFu1efzBCi5chXMCvQ=;
        b=TTEzmf9rb7V7pvShyIQUg9xdQ0g3ogpjuXS2qRCMwz0YWvHvIvvVjAhSP2vHROX8Li
         x5nGsmI6ny/MDILcq4n85YeicECDjKxPbnVLLvxxs3waw+WT/YQlHat4HAG4dPsyccZl
         IC39qUaNtgXrs0hYVb4tqtWEvO9wbi2HXKyHbSkuPuptap2nY4YoCP+ZQ7p2T5wDJ0DG
         YPtZEUJLmY6C9YMzv+CIXHwEJWYxJqpth07OQGmHc+mfsTI0O5cDeB/RGhCiFY5K0cHm
         edc2jjMg2OE7n64KIOEy1XLtgYTEZg5Xk7k1cJ64lWi8dZdTXy97UxWdCW+NYE33LFRm
         A4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=McKWTdHCX45PVDsiOqdh5g6L/nFu1efzBCi5chXMCvQ=;
        b=kZqZ4v83PIYIb2JL8TkrZspOUTQxsWvHKA5yuDrHl8pwoyZrftvH3Q0k8qnQmgyIx/
         dlOqWo6gjp8hB+X8VByf1MJ/1AoT4VRe4pdnvsqHsejn6PUkecKCPJKZegBTMZBuA7/g
         A+v3uOvBeA9cXa4u+dhNskBS7DFj78PQ34eWNdOeHOkWhcq8X40JrhVOBoiYe5uSeqKS
         2TQCVNGKjbiP3dK+r5lZJ+IrnEY/jhM2Rmz1T4z4rQmhGRb7Y15+/JCVFNNPFw0zFDwQ
         SAyScQZF3+t05xL0S/HOZZXwzwlmjJTmUtayVWlbODo9ZRftl8SOlwm7sTRcG5RSYtZt
         I74A==
X-Gm-Message-State: APjAAAUUzyhqzlIgKeDyovyEaoxi2MLwNEpcc8N/re6cztptwi9PzVmq
        wT7S6XJLKCkNnnRfPWre7e441Q==
X-Google-Smtp-Source: APXvYqz0KGZFFgsOhdtUlZcPAR1EDRxLA1DA6zELOX/03HheKtKRRpJD+56dr3I6cKmqUnWl+QdCZQ==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr24900311wrr.167.1571045647033;
        Mon, 14 Oct 2019 02:34:07 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:6c26:3154:28c0:6a9f? ([2a01:e35:8b63:dc30:6c26:3154:28c0:6a9f])
        by smtp.gmail.com with ESMTPSA id z125sm20138795wme.37.2019.10.14.02.34.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 02:34:06 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2 0/2] ipv6: fix neighbour resolution with raw socket
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, ndesaulniers@google.com
References: <20190622.170816.1879839685931480272.davem@davemloft.net>
 <20190624140109.14775-1-nicolas.dichtel@6wind.com>
 <20190626.132634.1369555115978417142.davem@davemloft.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <61611bc6-fd77-e46e-55ee-e0d5cff37ae8@6wind.com>
Date:   Mon, 14 Oct 2019 11:34:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190626.132634.1369555115978417142.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/06/2019 à 22:26, David Miller a écrit :
> From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date: Mon, 24 Jun 2019 16:01:07 +0200
> 
>> The first patch prepares the fix, it constify rt6_nexthop().
>> The detail of the bug is explained in the second patch.
>>
>> v1 -> v2:
>>  - fix compilation warnings
>>  - split the initial patch
> 
> Series applied, thanks Nicolas.
> 
Is it possible to queue this for the stable trees?


Thank you,
Nicolas
