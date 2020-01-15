Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A4E13CB1C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAOReJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:34:09 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39919 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgAOReI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:34:08 -0500
Received: by mail-qt1-f195.google.com with SMTP id e5so16460796qtm.6
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 09:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LYTJhq+zMqhzXQNKD9hAmoKIzcdyO29a2KwPUz9WVhE=;
        b=uB5hqZgKBEXjQVNbvJT9Jp0hKWu2dzLJB2i9JaZ2c2HcnlqnlDSyPdGC27muyYM9df
         tKoP+WbiHFl3670aa/zSHLBUNHJ2ctv9agOazLs+aOVvRqA56k4c//9/Slek8eM2Ppwy
         03aadPtwz0BjIBLh4VR+hQuVw8BBlMg6TLntaRUZ30PzB4IgTz5R5dGpeJpWr+K8vS7l
         t/dDdJs0S9e8WSyN2DFNdGcNSAzOsQ+wtlg4VvrJRTTHCILBu0DpxgZnSVbDoPehgMA7
         noVdPwxH7LwSdss4KXa+hKhO+6TQ6+vexcqivWo0w5QIgZ/O4/n5y0W4bB/ptwCh29jA
         QWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LYTJhq+zMqhzXQNKD9hAmoKIzcdyO29a2KwPUz9WVhE=;
        b=bcrboKjUvdX9vQFjkLWp317pycoKU7x3rsRAxYgIs8bq+s+jcFCaKOJfQzj3bMzV5U
         uEm1slxESDMK/HFKVP+xIk584+pQMkIUv6Z99mavYbLC2BImffgPuPJXj7t76vbWzeRZ
         XetTHbk0PXixJUTgH/HOeZBiCp/IakjQzUNbWBrhP1fciZaIvXh2/sel06etVFWZUs3A
         SVsmQ6p12lWPG3Bv4evRU4pTRstLrzJP/nBe8lcfDKIm1CflJnz5MdXkbLOuqNNF/y+y
         q9vQJmrp21q5u7KuYo2uLRie5g0xyJmokTN9B/VjWn9JYjC0t+B+jt3olR4Ye9eMV/y5
         BskA==
X-Gm-Message-State: APjAAAUORWKqiTVxkTHkpBS4UhxY7TgQuGWBKuXBpq8lCU6hMXthaS6u
        8LxsqWWjLVX79THC2FGo5sOUNwif
X-Google-Smtp-Source: APXvYqzRAGQlFR15qV1kRoudsgesCr+8B/IMMjpOaCrBiWJ5aBUJxbZ+uFmzcZopmagFN+1fP/IcXA==
X-Received: by 2002:ac8:1a69:: with SMTP id q38mr4381250qtk.96.1579109647834;
        Wed, 15 Jan 2020 09:34:07 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id g18sm9963330qtc.83.2020.01.15.09.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 09:34:07 -0800 (PST)
Subject: Re: Expose bond_xmit_hash function
To:     Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho> <20200115143320.GA76932@unreal>
 <20200115164819.GX2131@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6ce5204-90ca-0095-a50b-a0306f61592d@gmail.com>
Date:   Wed, 15 Jan 2020 10:34:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115164819.GX2131@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 9:48 AM, Jiri Pirko wrote:
>>
>> Right now, we have one of two options:
>> 1. One-to-one copy/paste of that bond_xmit function to RDMA.
>> 2. Add EXPORT_SYMBOL and call from RDMA.
>>
>> Do you have another solution to our undesire to do copy/paste in mind?
> 
> I presented it in this thread.
> 

Something similar is needed for xdp and not necessarily tied to a
specific bond mode. Some time back I was using this as a prototype:

https://github.com/dsahern/linux/commit/2714abc1e629613e3485b7aa860fa3096e273cb2

It is incomplete, but shows the intent - exporting bond_egress_slave for
use by other code to take a bond device and return an egress leg.
