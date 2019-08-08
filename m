Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871DA86AFF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390286AbfHHUBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:01:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54773 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389883AbfHHUBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:01:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so3521854wme.4;
        Thu, 08 Aug 2019 13:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7jTaWodj+o7bQpJXVjN7WZTMa/civJyI2O4p/MCweUQ=;
        b=isZbmorMAwvajUYDEKUD4lUqS1Sw/IbC+rYSpXOdbKPAJ9D7VQ0n2A8Uz+1uPB69T8
         lohq1iDZbO0d7504KZ7SLh2p6Dz+eNsNo6mOx6YlNjzt3h2l4xLhCVLQjcYyEkEfndPn
         uoC0EwK1QmGDqb5ZOWzMaun68shdtWKmxxJR5GfdOPjmE94uI/JZcjxJnBa6rafEhRLd
         NGnuc6O2xOAaIX8a8J9bJp9IutUqTMjqkMCDOkg+KvOF+glR1FEEvT282rR1O/5/HabB
         VTzEN5RTbGIPrEK5RH+qnM38BpyeyiaVrveldh04w1tvqnw7jT20QotG1tzu3etVvMPZ
         u51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7jTaWodj+o7bQpJXVjN7WZTMa/civJyI2O4p/MCweUQ=;
        b=oPNIcxWjFr2O/WVG2Jiu5i3Lbg2zDCeeaslqfB1T9G0AlldrNnG68AOSDPVujBuH6Z
         5Bq8bwig0sBmQHqf+z9JOoPzWwZ5i9eDAwe0W2kTFtjMvwYVFEupRAOnlZKIdf2BND6X
         OGFxaxu5T0oasOa5W6B++Z1o+IAWklN0CCFkd4q6QNASLlXOqMzFh/Bks+ukVLVVGfrQ
         bJFHmfTyzfJ9r2AMQr3nN3RsW0OeDf3lj4vdcH9ZbNT+laVdzgLTDf0fIiRURBinY4uB
         wkfttqLEM0+THUdxUmXving/LgBN1LyEwM6GRHW0RcpINlgBhuTqf024gZqBusp2WCdJ
         NBWA==
X-Gm-Message-State: APjAAAW7wHEexLzQUAH9v+OpcpFrcWa5RQwYMje6hbyodsWstKGllCgX
        lMaHm+BuyU0uOZ97UYMWv4w=
X-Google-Smtp-Source: APXvYqxcK3YbLrWSBF0s2uNuRnPmqxW69hMr0lv92X0Mv1bqON6d0QQLRPBRW8BRfZEMu4MDY2EMuw==
X-Received: by 2002:a1c:751a:: with SMTP id o26mr6284679wmc.13.1565294505632;
        Thu, 08 Aug 2019 13:01:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id o20sm243207712wrh.8.2019.08.08.13.01.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 13:01:44 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Yonglong Liu <liuyonglong@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
 <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
 <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
 <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
 <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
 <b1140603-f05b-2373-445f-c1d7a43ff012@gmail.com>
 <20190808194049.GM27917@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <26e2c5c9-915c-858b-d091-e5bfa7ab6a5b@gmail.com>
Date:   Thu, 8 Aug 2019 22:01:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808194049.GM27917@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 21:40, Andrew Lunn wrote:
>> @@ -568,6 +568,11 @@ int phy_start_aneg(struct phy_device *phydev)
>>  	if (err < 0)
>>  		goto out_unlock;
>>  
>> +	/* The PHY may not yet have cleared aneg-completed and link-up bit
>> +	 * w/o this delay when the following read is done.
>> +	 */
>> +	usleep_range(1000, 2000);
>> +
> 
> Hi Heiner
> 
> Does 802.3 C22 say anything about this?
> 
C22 says:
"The Auto-Negotiation process shall be restarted by setting bit 0.9 to a logic one. This bit is self-
clearing, and a PHY shall return a value of one in bit 0.9 until the Auto-Negotiation process has been
initiated."

Maybe we should read bit 0.9 in genphy_update_link() after having read BMSR and report
aneg-complete and link-up as false (no matter of their current value) if 0.9 is set.

> If this PHY is broken with respect to the standard, i would prefer the
> workaround is in the PHY specific driver code, not generic core code.
> 
Based on the C22 statement above the PHY may not be broken and the typical time between
two MDIO accesses is sufficient for the PHY to clear the bits. I think of MDIO bus access
functions in network chips that have a 10us-20us delay after each MDIO access.
On HNS3 this may not be the case.

> 	   Andrew
> 
Heiner
