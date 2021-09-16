Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB8C40E812
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244211AbhIPRnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355694AbhIPRmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 13:42:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE30DC08EC9C
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 09:23:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y17so6323409pfl.13
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 09:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hCAFbL5117FOd/52WkNZmJu5L2G8fNGwyGZ0orsJX00=;
        b=bPe6csxfuSlzoEhHfCLqi9CC3GRr5Y1Is1u71Mmy8tFVg7nCMMfhsqugcU2AAWUe9i
         hT63w7se49ualDv7BfY5dT7lOGUGrTMMljAOoGoIuBOzIsZwXQHJDZBBKuCAExa44xkc
         iyBK/6yiXqIjP7BzR+vB5oGNHRpVIg+1PR2C02A8DNBvB0/Lpn2kQPTfr5c3I/HuRz91
         hwX39NC9Ne8L+8Q83fRgeGVJRxCQ++P1TYneL52jQIOv1/pTUwP81TKxL0SDxr6p0xi9
         yOKA4vhPxp8FNc24bKWVLc6JPJc82wskm3k1DQs86RfZ3jit9cBklLloQY3tljZC9udG
         vRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hCAFbL5117FOd/52WkNZmJu5L2G8fNGwyGZ0orsJX00=;
        b=BXkoduYPg+5YCO5jBfscAkmAn5L7i+RKL7Ru3ZgMLQIo8bn0Oi+qJiLrUGVvO5H+1N
         BHG6Pv3WCVvKOpaVsdsyp/wuS3nFQimk+0jnjZJpl4nxfp5SBZOmdt2YWNtQRmHSCGEJ
         nZokdmQEmIDUJqA4K2+SF1CbahwA60kBYbffVwAvgIDz2fnVSuQmWefy9XHuaTeQnkLz
         qkzqhD9GTleoRMdvmQo8N5T5sPn9H/5Dn+aJU8nZj/rxkb92Z/ctM6fsNqHENZYEUlkY
         r42cFLsYsDWBohuO9fhQCBwtYHpGqt7IoSDD38kt2Q9UlkChZ0hdlNZYpZOuoN35EIb3
         fAFQ==
X-Gm-Message-State: AOAM5334yxKPjZqoL9BQ5FlE5nJSNUn0P10SruRFtT6hGKcwG/IUbUkE
        pvSiZ6RDTqt9mnAyxEMh9HU=
X-Google-Smtp-Source: ABdhPJx3mkhr+G9l+tX4p877uwjiA9YTzHsAs7XmmC+bsXrssoEzzKxmKxifTwO0sI2CU57mhxMDgw==
X-Received: by 2002:aa7:9117:0:b029:35c:4791:ff52 with SMTP id 23-20020aa791170000b029035c4791ff52mr5836873pfh.76.1631809433345;
        Thu, 16 Sep 2021 09:23:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c22sm13088pja.10.2021.09.16.09.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 09:23:52 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
Date:   Thu, 16 Sep 2021 09:23:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916120354.20338-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 5:03 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This has been tested on:
> 
> 1. Luxul XBR-4500 with used CPU port 5
> [    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 0
> 
> 2. Netgear R8000 with used CPU port 8
> [    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5  

These look good at first glance, let me give them a try on 7445 and 7278
at least before responding with Reviewed-by/Tested-by tags, thanks!
-- 
Florian
