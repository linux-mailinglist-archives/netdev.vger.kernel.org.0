Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB871F57B6
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgFJPYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbgFJPYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 11:24:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096C3C03E96B;
        Wed, 10 Jun 2020 08:24:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p21so1119300pgm.13;
        Wed, 10 Jun 2020 08:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5XQnO02H0fKrctspxTo+pKLyxRvYHKgJy5mnWAg2J8=;
        b=DnJQPEBGaSs22StiK/XmIEJixwrHcLpFw59LuvDPEuhTrZlIONMfkMnz4lAvBDtCF4
         wEzvpXzgnPaWsoQj5RPbhUEB2ixk1Kpyzy/3fGeiWiqw/x4NHfuFYEIDJefx/OkBsCvr
         7MZTF4mm9UfVcqPrylz8nO/3u5pf8QDDcYzDZvpxE981m/GBKFa+VC60p4H3xUbwyhxc
         upe69uaPxFjhkAhVe10O/6KIuOrw9R0xJJmyp+KUNH1uAuUW234e+8frFJFSMzvgGO8A
         kD4WMupFrDKSG7EhHr40wHf5mvx8MYCRjp4bFb90rxEz/GkyYy5ePH87jyEFxCPnGR50
         4mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5XQnO02H0fKrctspxTo+pKLyxRvYHKgJy5mnWAg2J8=;
        b=lGhIzzMVVliHE7anddM4EgVJmoneTOJl+E9m0KI5Rrelj5n+9oS1To1gLC+RlzY6Tg
         If54UlvCUmh/49EyTzcKB6+9YK/CdAsACLlmrobD/GyIUlYqNiJXml4Erd2eojVyMJdB
         cWi1nuOXOfFKYOG1BM4LkYCrFfFyYXYOCsRDLGZcf38bSgluC/N5F4ShHxBkduJlG6Qq
         8Mg1DqPg9Q9CsbaRPntINc4mMxobls3PszrCeBvNuzWqaJTlZadgjcMjEha1VYMgr0oh
         FsJlNy+VIgUkvLGMYaGOZbQGCOWZYd4l6sFYXXYb/GvfLG37iojNCsyqtQIhxLdGbCrF
         LTgg==
X-Gm-Message-State: AOAM533USYPZSyLC9UhMffijWqnRb2lf9lPiGFkKY3tHlo9rVUVNMd/u
        Nl5/GWnCLoesfwpvjxYo4+Y=
X-Google-Smtp-Source: ABdhPJw1fTlxizPaM70IutkwBiYtRCvKawKfiyPzN0ibNSUxNU8n5tvL+NWKirw4pGk+03aHkek4mA==
X-Received: by 2002:a62:8811:: with SMTP id l17mr3158370pfd.72.1591802653831;
        Wed, 10 Jun 2020 08:24:13 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q18sm196360pgt.74.2020.06.10.08.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 08:24:12 -0700 (PDT)
Subject: Re: [PATCH] net: mvneta: Fix Serdes configuration for 2.5Gbps modes
To:     Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
References: <20200609131152.22836-1-s.hauer@pengutronix.de>
 <20200609132848.GA1076317@lunn.ch> <20200610062606.GM11869@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9f85b076-dab8-63e4-5d2c-b48575979a02@gmail.com>
Date:   Wed, 10 Jun 2020 08:24:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610062606.GM11869@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/2020 11:26 PM, Sascha Hauer wrote:
> Hi Andrew,
> 
> +Cc Maxime Chevallier
> 
> On Tue, Jun 09, 2020 at 03:28:48PM +0200, Andrew Lunn wrote:
>> On Tue, Jun 09, 2020 at 03:11:52PM +0200, Sascha Hauer wrote:
>>> The Marvell MVNETA Ethernet controller supports a 2.5Gbps SGMII mode
>>> called DRSGMII. Depending on the Port MAC Control Register0 PortType
>>> setting this seems to be either an overclocked SGMII mode or 2500BaseX.
>>>
>>> This patch adds the necessary Serdes Configuration setting for the
>>> 2.5Gbps modes. There is no phy interface mode define for overclocked
>>> SGMII, so only 2500BaseX is handled for now.
>>>
>>> As phy_interface_mode_is_8023z() returns true for both
>>> PHY_INTERFACE_MODE_1000BASEX and PHY_INTERFACE_MODE_2500BASEX we
>>> explicitly test for 1000BaseX instead of using
>>> phy_interface_mode_is_8023z() to differentiate the different
>>> possibilities.
>>
>> Hi Sascha
>>
>> This seems like it should have a Fixes: tag, and be submitted to the
>> net tree. Please see the Networking FAQ.
> 
> This might be a candidate for a Fixes: tag:
> 
> | commit da58a931f248f423f917c3a0b3c94303aa30a738
> | Author: Maxime Chevallier <maxime.chevallier@bootlin.com>
> | Date:   Tue Sep 25 15:59:39 2018 +0200
> | 
> |     net: mvneta: Add support for 2500Mbps SGMII
> 
> What do you mean by "submitted to the net tree"? I usually send network
> driver related patches to netdev@vger.kernel.org and from there David
> applies them. Is there anything more to it I haven't respected?

Here are relevant bits from the netdev-FAQ:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n28

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n78

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n210
-- 
Florian
