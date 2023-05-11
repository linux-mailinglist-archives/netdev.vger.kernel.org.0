Return-Path: <netdev+bounces-1622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF52B6FE906
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 761361C20EA4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205E7627;
	Thu, 11 May 2023 01:05:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105DA620
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:05:52 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A57319AC
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:05:51 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1aaea43def7so55257005ad.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1683767150; x=1686359150;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uw1gvG7fEzjC/sDe4WpWIK/o6eV1suvAIBCVaqgmwBA=;
        b=r9o/KD4FLQvtcnn/UPU1dkJfrotWAxOyhHTXJHW8ptFTrQVpRX8A2Nfb+aZ5TXLjHs
         mKieaKt2ps061qKbXx/e4ELEHXYP4Wsg8Y+0yRGvwOjDHxRqbq42DNkL3+GxtaP1DBF3
         Y8JE/5BmbU7CcmIomQOrlBdx6brQyHhyAqLxCop0ppGs3ZJwNzY3l/4IUmgJTuu1Yes5
         NZjsxqPFyQg8qGEhpbvzc8TsIrRIzQqw+6X7jtyWrYoD73GP2hI2q54d0g8WlHBhvkY+
         Ti/NLiI4V96jBBjYFha3RuEseulpO2KnXxhbKZgRrOCN6mc4BcrPf+dOJ7S4kIQFHfzB
         Afbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767150; x=1686359150;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uw1gvG7fEzjC/sDe4WpWIK/o6eV1suvAIBCVaqgmwBA=;
        b=EcGXZLvKvZv0McELGFjVH3FCF/SscGo7LFWSx1pQOcvamlLnulEIIOKEmM0Zf8GJ0T
         W0dYvmwV+9btco3uYiDSEqEImvC+uYxQHjPUKf+u5d0tnoZvz/Ys3HMHMfaX6UyfkU6f
         vS3iXjZIfLX/BC8PT39acxnTCnSNalrGWHJM/vzFNp1R8fUzaMunFGRiJwQnW+3dFd3/
         iMJRLB4a9mMdLTsFNcrFc/kI6e+0OGZEsJ1NpdzmcGPgpLXPPjzYGV3NJyf9lT3RO6Me
         lcEaJTKy54qVSvMPRTkxtvA4TtIPfkbPMEp8Q1islS5q1qzAA3JTtsY/euQufUMa7kne
         MPMQ==
X-Gm-Message-State: AC+VfDwPRv0aDPxK0rUOWLbCM9Nyh8nt51OcZfWE2TIxQl0hcwvgco64
	xRlJp9l6Y1b84xYCQjgXiDJ01fPjORY7ILE89ju+Sg==
X-Google-Smtp-Source: ACHHUZ6C6UqBvASlM6Utr5e16vPVtqo/qZfFx04uxtOJYyOVN5kEq5y2eFFlPBx/Ga6sGm82d+xHWA==
X-Received: by 2002:a17:902:e852:b0:1a6:c595:d7c3 with SMTP id t18-20020a170902e85200b001a6c595d7c3mr23247196plg.22.1683767150589;
        Wed, 10 May 2023 18:05:50 -0700 (PDT)
Received: from [192.168.100.190] ([209.52.149.8])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902684c00b001ac69bdc9d1sm4483006pln.156.2023.05.10.18.05.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 18:05:50 -0700 (PDT)
Message-ID: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
Date: Wed, 10 May 2023 18:05:50 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
To: netdev@vger.kernel.org
Content-Language: en-US
From: Ron Eggler <ron.eggler@mistywest.com>
Subject: PHY VSC8531 MDIO data not reflected in ethernet/ sub-module
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi, Everybody,

I've posted here previously about the bring up of two network interfaces 
on an embedded platform that is using two the Microsemi VSC8531 PHYs. 
(two previous threads: "issues to bring up two VSC8531 PHYs" & "Unable 
to TX data on VSC8531". Thanks to Heiner Kallweit, Andrew Lunn, Horatiu 
Vultur & everybody else who might be following along)!

A quick summary of the previous threads is: No matter what speed the PHY 
negotiates to 10/100 or 1G, the RGMII TX_CLK always remains at 2.5MHz 
(which would be frequency for 10baseT). I'm starting yet another thread 
as I have realized that the MDIO information does not seem to propagate 
through to the drivers/net/ethernet/renesas/ravb_main.c which utilizes 
the function *ravb_set_rate_gbeth() to set the MPU's registers correctly 
(which is needed to get the correct frequency on the RGMII bus). **
I have not found a potential reason for this, the MDIO comms appear to 
work properly as I can retrieve information with the mdio and the 
mii-tool utility properly.
**I've added printk debug logs with to ravb_main.c and found out that 
the link state nor the speed do not appear to be propagated through 
properly (when compared with mii-tool).*
***The logs generated look like:*
***
# dmesg | grep DEBUG*
***[ 6.728165] DEBUG: in ravb_emac_init_gbeth(), calling 
ravb_set_rate_gbeth(), priv->duplex: 0, priv->speed: 0*
***[ 6.751973] DEBUG: in ravb_set_rate_gbeth() - priv->speed 0*
***[ 6.831153] DEBUG: in ravb_adjust_link(), phydev->speed -1, 
priv->speed 0*
***[ 6.839952] DEBUG: in ravb_adjust_link(), priv->no_avb_link 0, 
phydev->link 0*
***[ 6.847093] DEBUG: in ravb_adjust_link(), phydev->autoneg_complete: 0*
***[ 6.853514] DEBUG: in ravb_adjust_link(),phydev->link 0*
***[ 6.883683] DEBUG: in ravb_emac_init_gbeth(), calling 
ravb_set_rate_gbeth(), priv->duplex: 0, priv->speed: 0*
***[ 6.898551] DEBUG: in ravb_set_rate_gbeth() - priv->speed 0*
***[ 6.963742] DEBUG: in ravb_adjust_link(), phydev->speed -1, 
priv->speed 0*
***[ 6.973404] DEBUG: in ravb_adjust_link(), priv->no_avb_link 0, 
phydev->link 0*
***[ 6.981869] DEBUG: in ravb_adjust_link(), phydev->autoneg_complete: 0*
***[ 6.989645] DEBUG: in ravb_adjust_link(),phydev->link 0
*

**


Which has been generated by application of the following patch file: 
https://github.com/MistySOM/meta-mistysom/blob/phy-enable/recipes-kernel/linux/smarc-rzg2l/0002-add-phy_debug_logs.patch

While I also receive the following using the mii-tool utility:
# mii-tool -vv eth0
Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
   registers for MII PHY 0:
     1040 796d 0007 0572 01e1 cde1 000f 2001
     4006 0300 7800 0000 0000 4002 0000 3000
     0000 f000 0088 0000 0000 0001 3200 1000
     0000 0000 0000 0000 a035 0054 0400 0000
   product info: vendor 00:01:c1, model 23 rev 2
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 
10baseT-HD
   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD flow-control

# mii-tool -vv eth1
Using SIOCGMIIPHY=0x8947
eth1: no link
   registers for MII PHY 0:
     1040 7949 0007 0572 01e1 0000 0004 2001
     0000 0300 4000 0000 0000 4002 0000 3000
     0000 0000 0088 0000 0000 0000 3200 1000
     0000 0000 0000 0000 0404 0054 0400 0000
   product info: vendor 00:01:c1, model 23 rev 2
   basic mode:   autonegotiation enabled
   basic status: no link
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD

Also one oditty I just realize now is that eth1 only appears to 
advertise 100Mbits until I connect it to the 1G line, then it looks just 
like eth0 above but that's something for another day
Can sdomeone help me to find out why the MDIO info doesn't appear to 
pass through to the ravb driver properly?

Thanks,
-- 
Ron


