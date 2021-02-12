Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA76319984
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 06:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhBLFX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 00:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhBLFXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 00:23:23 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4039EC061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 21:22:43 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o24so8014973wmh.5
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 21:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xD21291Ju4hiciJMXvou0U5l3OJazFXXjCPwhLAGanA=;
        b=nN1MgX70ED80GmQb7NLRk6ldnpgRdnPRWEShF8rEk++JBJhCQu3Ddt6h+JSaBklUrL
         jGMA4X4rtcbmjp+X5nAZ5WZtmVFOyfDnk51mxNUylWr2j+RDC6eRyCPrGW240zKzAOMs
         20C9Sj1tf3JnxhD1QW1DfLameVThqUnxP1yEHJ+kPvbxdPQulZyZFxUUzwcHrpXcWFcO
         SsEB2tzOoneU3SluaRcrgPnxeuEEwklcrNWkwMwaO3XA+IhHGfYj90gHBfvH4Mr4PLNQ
         Mwi/dwsBs3ZmUlbtHFbrpsEAyd/qBYZE153rFPKAh3hTgdI1vADdwciqmm9MRuJ1A5Ge
         9yrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xD21291Ju4hiciJMXvou0U5l3OJazFXXjCPwhLAGanA=;
        b=ugiCnmqvM1m6lAnbcBkyAl3O+lThDkp7bENPC7IJQyvQUZXJ7MQybmUkGPJtLvPNlI
         27Ucjd8UpgvQajOSIsChWNICDKoLMIx4Y8bMlZ5wBUwMEudM8N37HUoKXpv2CW0KTlK9
         k9t+7ghKJL9nT39H5NGvnFVJebueqU6pfhH4rzqVbR1rgAvbZ7y/6JVavYjrBJ4IwHSX
         z316LDJEnxS2EOYKk2/sitk8pABEpEi4lUtTbx9FhhvWFgbdfZGGkyEqJyodq0KNS6/h
         3c1S+Ngv1WTSuE3r4I5yncgv0l60yz3qZHW5/7c/TnRiHr3GEAqR2RI3yUu+5h2N+sHO
         gBKQ==
X-Gm-Message-State: AOAM532EwWGwj5l7o67kIwFzwA6nBpfzQlKFq8FF6FFapO1HUGYc47NR
        6C6jEiuU5pz3eecXIOCbAZw=
X-Google-Smtp-Source: ABdhPJzmS3WmsSn0SDPqFElzNO0a5be6z7mPm2tSA+NkLN5vqVWyPONfvqjFktwXAcx+M1u80grVjQ==
X-Received: by 2002:a05:600c:210f:: with SMTP id u15mr1007836wml.126.1613107362000;
        Thu, 11 Feb 2021 21:22:42 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id f5sm13364239wmf.15.2021.02.11.21.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 21:22:41 -0800 (PST)
Subject: Re: [PATCH v4 net-next 00/21] nvme-tcp receive offloads
To:     Randy Dunlap <rdunlap@infradead.org>,
        Boris Pismenny <borisp@mellanox.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20210211211044.32701-1-borisp@mellanox.com>
 <76c93e83-be63-f7ed-a096-1408e9525331@infradead.org>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <153bbd21-4704-b28c-d418-8c091cef7348@gmail.com>
Date:   Fri, 12 Feb 2021 07:22:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <76c93e83-be63-f7ed-a096-1408e9525331@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2021 23:32, Randy Dunlap wrote:
> 
> Hi,
> Did vger.kernel.org eat patch 21/21?
> 
> and does that patch contain the Documentation updates?
> 
> thanks.
> 

It seems the error was on my end, thanks for raising this, I've resent
that patch now.
