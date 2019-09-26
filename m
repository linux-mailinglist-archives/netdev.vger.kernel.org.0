Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F5BBEAD5
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 05:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbfIZDSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 23:18:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38248 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733200AbfIZDSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 23:18:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so651621pgi.5;
        Wed, 25 Sep 2019 20:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/e01aipRWHPH7X0tss/E5RuVEwEXJJ206Sxj1NvR6mo=;
        b=i6us6Pmj3kI9zdy2DYLFPekTIdHNvPoZghPOTg64by8XXWLfR7xlZDZqYQGFNKsZMy
         GEKBUNpV+SDbJvEsBRgfTpQXgBeKmwf5qZVN8xFjAJrYwMrijzEKoXD26aesEpGQwzl1
         5EUaB6AAp2nVwRHi1+68b/dA81dsOCuo1fVSTBmvbEN6QQ7fwJKIFXXjUjvugxfQ3iDX
         +Yjxd6IieZZ+u5DeLPIu5oInzWK81hR/sErRtU4ZVhAtmw624IIfwS6gZWaBTbRh5KTh
         CFaghoGUIMDrmbYsje72y1J+aZuW1yXWSda/Pdurc3ZC2KgXqQpzHvV6bp3gZ5kmlskI
         C6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/e01aipRWHPH7X0tss/E5RuVEwEXJJ206Sxj1NvR6mo=;
        b=bp8Mcg8EIN5CR1L3bPe+x2mA1qeNxLJrIyGjrEMOTl08uyImsZ8cSN3/t+tSryos7z
         aILgn7jdzDZF6RAbt/SIipa/2FKbUPWZfZ3q61Hx5EuDls4yh3LtYaq21f68IXDUDCi0
         roTnRaZvC7lmtMsp5kfXCyU2Sum1oJrfGTNp/9ceDyvJNs0zPb1DeY9qUGn9PBT0kgz3
         pEauJNWvOCxuyyx+yU9deSE4Tnfwb37fudIM0/qjC8BZOec/wBrOAuAE6fALT/EZlh6y
         Nc+su5tdCMiD6FwM72P90SAkqSDoJvqKArsYB89F03t6P79Kfh5fnKULQogG+/+eiWBw
         bQTA==
X-Gm-Message-State: APjAAAVBWOpxAITN8H/LJqf3Hs5cqxSAbhSnmVf6dx5Buq9DNQEyvNYP
        qCIHRYvRRs8ta+8EEvMUZhNmfuRW
X-Google-Smtp-Source: APXvYqwIl1HA42M4pxILH2MueMe16Kg8BIZOkv+wNehRZAFzCMbM3304ZmeqwJEZCeq39jqryCcBIA==
X-Received: by 2002:aa7:870a:: with SMTP id b10mr1182400pfo.5.1569467887898;
        Wed, 25 Sep 2019 20:18:07 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b20sm488058pff.158.2019.09.25.20.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 20:18:07 -0700 (PDT)
Subject: Re: [PATCH net] net: broadcom/bcmsysport: Fix signedness in
 bcm_sysport_probe()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190925105604.GD3264@mwanda>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2424620c-7e8f-43ad-498f-966f26dc7e9f@gmail.com>
Date:   Wed, 25 Sep 2019 20:18:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190925105604.GD3264@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/2019 3:56 AM, Dan Carpenter wrote:
> The "priv->phy_interface" variable is an enum and in this context GCC
> will treat it as unsigned so the error handling will never be
> triggered.
> 
> Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
