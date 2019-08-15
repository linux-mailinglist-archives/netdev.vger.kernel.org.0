Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA2B8EF85
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbfHOPir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:38:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43852 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOPiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:38:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id v12so1494019pfn.10
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LZZGq6oO/6tWiibCS2H62O05Nxbsw4PHFnvH14n/bec=;
        b=Z1IYVUJ+DOawg9RVrFZdtpHXKg8K37xDb5ZKAwLfC/gl72XL0Hb79udwgCbnEufICF
         osIVzmvEM7pybNGVb5asWBRY7M84FzEXlVNQg7ZbFfcGjut2FN82uWxUoe/Lp1MqLE4D
         R0cqlSED7+5/1aSKzBSXK3wAGyLs8LxkB/CV6ZutD9XndaAa6C/hglB9d3S5Rdge7WHr
         ekXCYqXK7taeAvthllZd8CbDdf7qg06d+Js5kH/DZmA1RSDl9t7/bp2EoCw9uDMBdNTP
         IcrZiKJbOtNwTBxnJtzSUt9B3rrcYfzp1UJ3LgodsPN1FHhBmFrzcD9FYN/eyd+E8iOO
         7W6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LZZGq6oO/6tWiibCS2H62O05Nxbsw4PHFnvH14n/bec=;
        b=s+Jc4TY62AoV9Qi1hRzbJf35Rh0auhGinl8UG2rCW7VJ09OOCjOuSeoYeMdmkgcLou
         mXr27NAqCXp9RtHG372Lu+4gxoAxnm8q6PV0jsHi3Puq3QiUpd3NMPO2o1LjNRQi1/BO
         ZZ7aF+/F7Oc/W98ug8BtmKyfaz4Bp5x6iwSWGzuW1qJlaM4jOEXx5D6nDUlS4ajf4AN3
         NH0hbhBdSPipjmQ5s2dDqzleBYM3ZEpXqTUzOBBUjONTYQKrm3pEeEEh+bRaM2FQhHTy
         guWgI/CUVDxJFbOpPtL0If/dIO9EFlWvgS+fobvxJhcW6yYDwoe1aEetSw0OCwsLVriG
         GcFw==
X-Gm-Message-State: APjAAAXQvvEYvYqx1XtA1xeXesuZb0Rg7kZ7IQo6o6LDmW1r85suAg+e
        b9H5Cmo1AwB4J5XLh5Bt62IUFeuN
X-Google-Smtp-Source: APXvYqyxot6v7Xc66MUhgnBFkUYKmrEocRtfXd8puE+moT50ww7WdaFI1L9/AeX+RCrBHv5tRRm4tQ==
X-Received: by 2002:aa7:93cf:: with SMTP id y15mr5964539pff.251.1565883525854;
        Thu, 15 Aug 2019 08:38:45 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g19sm4313288pfk.0.2019.08.15.08.38.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:38:45 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: read MII_CTRL1000 in
 genphy_read_status only if needed
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <c49b0e0c-0977-bd83-79b1-ac85c7284213@gmail.com>
Date:   Thu, 15 Aug 2019 08:38:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 4:15 AM, Heiner Kallweit wrote:
> Value of MII_CTRL1000 is needed only if LPA_1000MSFAIL is set.
> Therefore move reading this register.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
