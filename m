Return-Path: <netdev+bounces-1978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 828DB6FFD3B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EC541C2109B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB0617745;
	Thu, 11 May 2023 23:21:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB0C3FDF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:21:55 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC8D5B93
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:21:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a50cb65c92so66649365ad.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1683847312; x=1686439312;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V72rh9iuZtqBpyTD3SqOoorUU8ceAGrVNNi4TO3xRlc=;
        b=1rWEhthZNCQAd9xHUFeC/njSq8VD27rmmjSO3izoAuGih2ZMOQWmh4F/MGfhBfOMob
         0WHU1XqdT4L3vDNCLyIMeRZSgWcTKMoUcCQlgfZtGtWVLX9zd07KzzrEIHmp3LUVlSc0
         0HvUM61Henw9d11pPPGHXeGikQ07axV3uFJwnqrBvekqBE0hNhTuz3tb1WWazZGbNwt1
         lCfO35Yzw0V12Oz/fV5kC+UF5kKZxAGA+1puaoeRWPzGRVC43FD/gYpCXRI1+Im0EZMm
         jPGqsB4zpdXa1zLrUyqisOuYO7ZYTw4T1KCPZW/NCvXOd8OcyJx5/6K/6bA+pz9ZxQAV
         OobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683847312; x=1686439312;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V72rh9iuZtqBpyTD3SqOoorUU8ceAGrVNNi4TO3xRlc=;
        b=kFe7xVG1HJcmbsE3yI39minEIoTiTtRpoBfdh0auyZQ43mzZZXTEsnz4Brh0YC4MMw
         4ZOYAx2xLnkR+fqNvRDXVM/adESuTYsxneLPhLD/IY6YTRmhinXdHEGg+LRsQRnd/aS+
         2Dp6UJZZwLIzFks5g/B/2q1Pw11sz6Y0oTSdKBSh3m+y1VDlU7pV8fXVKV2r8FwTXfiA
         9roiK/PDDr2CGLNihdm0cbTL62P+tNo0RwBpBT39no2Kza/Eiz5v7Jf+sY6BESe7ROdt
         ktqbkdg57ldq7yURkuEqLWpyZNddqd84QCXotZ1j7bKg04foGxImJ5pz7IS4xmetHA/T
         p/GQ==
X-Gm-Message-State: AC+VfDzsE8hDVbAcsWNVbZjcCCLrhFVJ1N8zpZmTrMzmaenBpIAI/vvz
	LWqvlWSHTpQz0Hu41PexEleFDBHVuvTN8CdCBpl+Yw==
X-Google-Smtp-Source: ACHHUZ5ZiL3iN5h9YeIXxWR9AoGrWnWCttLdP2hBvm4/joCz5MvNJTyk48BBmEt0QtiX0rCSWGY2MA==
X-Received: by 2002:a17:902:e846:b0:1ac:85e9:3cab with SMTP id t6-20020a170902e84600b001ac85e93cabmr16608867plg.56.1683847312234;
        Thu, 11 May 2023 16:21:52 -0700 (PDT)
Received: from [192.168.100.190] ([209.52.149.8])
        by smtp.gmail.com with ESMTPSA id c3-20020a170903234300b001ab1d23c44bsm4192668plh.181.2023.05.11.16.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 16:21:51 -0700 (PDT)
Message-ID: <759ac0e2-9d5e-17ea-83e2-573a762492c2@mistywest.com>
Date: Thu, 11 May 2023 16:21:51 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
From: Ron Eggler <ron.eggler@mistywest.com>
Subject: Re: PHY VSC8531 MDIO data not reflected in ethernet/ sub-module
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
References: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
 <69d0d5d9-5ed0-4254-adaf-cf3f85c103b9@lunn.ch>
Content-Language: en-US
In-Reply-To: <69d0d5d9-5ed0-4254-adaf-cf3f85c103b9@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

Thanks for your response:

On 2023-05-11 8:34 a.m., Andrew Lunn wrote:
>> ***[ 6.728165] DEBUG: in ravb_emac_init_gbeth(), calling
>> ravb_set_rate_gbeth(), priv->duplex: 0, priv->speed: 0*
>> ***[ 6.751973] DEBUG: in ravb_set_rate_gbeth() - priv->speed 0*
>> ***[ 6.831153] DEBUG: in ravb_adjust_link(), phydev->speed -1, priv->speed
>> 0*
>> ***[ 6.839952] DEBUG: in ravb_adjust_link(), priv->no_avb_link 0,
>> phydev->link 0*
> If there is no link, everything else is meaningless. You cannot have
> speed without link.
Makes sense!
>> While I also receive the following using the mii-tool utility:
>> # mii-tool -vv eth0
>> Using SIOCGMIIPHY=0x8947
>> eth0: negotiated 1000baseT-FD flow-control, link ok
>>    registers for MII PHY 0:
>>      1040 796d 0007 0572 01e1 cde1 000f 2001
>>      4006 0300 7800 0000 0000 4002 0000 3000
>>      0000 f000 0088 0000 0000 0001 3200 1000
>>      0000 0000 0000 0000 a035 0054 0400 0000
>>    product info: vendor 00:01:c1, model 23 rev 2
>>    basic mode:   autonegotiation enabled
>>    basic status: autonegotiation complete, link ok
>>    capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD
>>    advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>>    link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD flow-control
> Assuming you are not using interrupts, phylib will poll the PHY once a
> second, calling
> phy_check_link_status()->

I don't see it being invoked every Seconds but it gets invoked on boot, 
I added debug logs and see the following:

[    6.669425] DEBUG: in phy_check_link_status(), phy_read_status() ret 
err 0, phydev->loopback_enabled 0,
[    6.696237] DEBUG: in phy_check_link_status(), phydev->link 0, 
phydev->state UP

state = UP which means it's ready to start auto negotiation(in 
phy_state_machine())  but instead in phy_check_link_status(), 
phydev->state should be set to  PHY_RUNNING but it only can get set to 
PHY_RUNNING when phydev->link is 1 (in phy_check_link_status()):

>    phy_read_status()->
>      phydev->drv->read_status()
> or
>      genphy_read_status()
>
> Check what these are doing, why do they think the link is down.

Yes, so in phy_read_status, phydev->drv->read_status appears to be set 
but I cannot figure out where it gets set. (I obviously need to find the 
function to find why the link isn't read correctly).
I temporarily set phydev->drv->read_status to 0 to force invocation of 
genphy_read_status() function to see how that would work.

genphy_update_link(0 is called from genphy_read_status() and I get the 
below data:

[    6.795480] DEBUG: in genphy_update_link(), after phy_read() bmcr 4160
[    6.805225] DEBUG: in genphy_update_link(), bmcr 0x1040 & 0x200
[    6.815730] DEBUG: in genphy_read_status(), genphy_update_link() 0 
phydev->autoneg 1, phydev->link 0


Could it be that the link needs a second to come up when when the 
network drivers get started and hence I should make sure that the 
polling once a second works (which currently doesn't appear to be the 
case)? Am I missing a configuration option?

Thanks!

-- 
Ron

