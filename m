Return-Path: <netdev+bounces-934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B206FB6A4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C90B0281081
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F2A1118B;
	Mon,  8 May 2023 19:12:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E2CDDBF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:12:08 +0000 (UTC)
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81A14214;
	Mon,  8 May 2023 12:12:06 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-61b5da092dfso22716466d6.0;
        Mon, 08 May 2023 12:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683573126; x=1686165126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N0Ip4xtZ8Iz4BbYK8tVpj/OW9l2jagCQwdYtSFNU6LA=;
        b=LBveiBDqSSJeKRjxkHpTTM2O0CSF10nti3a5HIF1ZOgMxhWWMIWqRMRZQel/3vX4Kj
         6c7amUTHop/V96ADlryKYxOPgjDIl8lacEYR/H8pxvZ7KH1DISlcdWAXUfRiJ34jfG1R
         Rqcv5cNGU6bcEAl/hToLN0dB9+N5G3pt3pJOmIHmdYadWxGX+OG77u7DXmCU9upJd7tT
         d6ekcG4deQsD7vZXgTaP3P2uq394gtFdqsuUPTZvkGffgyhyMapR06bzDiVLVlcNT+EJ
         mVao1pL0GeGVxRB2JF8+RpeUfF1/4kIWBIQWKbWtoteVfCjUDt2xDbvrIDlQHvfb+XhF
         tejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683573126; x=1686165126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N0Ip4xtZ8Iz4BbYK8tVpj/OW9l2jagCQwdYtSFNU6LA=;
        b=exGd5dfQgVRIImiXzoyvX63aGJNKZNIp6ISVSKSGLA/E+tMrM1WyM+dsQAe7W+VB1F
         yuUXbk5k3fol1YmZXm8QptDEZsImRmyUBLZ2Pg/h0XASEI+By6QE46GzORdZ7z7HpLjF
         uN3BdJShKc9D04iUIYIasSAZuvYDjhaGzuKzvt0D4KmgSrGkhIsLppo6Pb+53hk4ZX1n
         NqSrLK2X6I2NnRZ5BpmD2Qvmz37XRG5u9bCuNO8fk+pnz5JS9CpgSZtQ1DrSG39FkDDS
         CPkOCsw7dLDAIYb7JPRB0RhOpVNsi4UwJi5f+B0Od5rOxMB7oGducObkiLQUN4hPI7mg
         aYFQ==
X-Gm-Message-State: AC+VfDywS96HuEaMY8K8i9sZ4ImKE/tA1q2Cq3ziQ+pS7lzA0liV72Ms
	pYLlxesh6DD9w1dwtLDYucY=
X-Google-Smtp-Source: ACHHUZ5MR/aHaIVsGiJFvR5m/CaW8643X2Y94A2fqamCUqMaI+BbsU5Wr2+KDmq/jxD8IDe9Amuclg==
X-Received: by 2002:ad4:5ca4:0:b0:61b:17bd:c603 with SMTP id q4-20020ad45ca4000000b0061b17bdc603mr19381886qvh.9.1683573125720;
        Mon, 08 May 2023 12:12:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c6-20020a05620a134600b00748613be2adsm2748176qkl.70.2023.05.08.12.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 12:12:05 -0700 (PDT)
Message-ID: <7de2bc6c-2c74-b1a1-e0a1-e76183b51c56@gmail.com>
Date: Mon, 8 May 2023 12:12:01 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
 Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
 <20230508184309.1628108-3-f.fainelli@gmail.com>
 <5711f834-8fc1-4144-bc12-e12388c2808a@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5711f834-8fc1-4144-bc12-e12388c2808a@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/8/23 12:09, Andrew Lunn wrote:
>> Because the Wake-on-LAN configuration can be set long before the system
>> is actually put to sleep, we cannot have an interrupt service routine to
>> clear on read the interrupt status register and ensure that new packet
>> matches will be detected.
> 
> Hi Florian
> 
> I assume the interrupt is active low, not an edge. And it will remain
> active until it is cleared? So on resume, don't you need to clear it?
> Otherwise it is already active when entering the next suspend/resume
> cycle.

The interrupt is indeed a level low driven interrupt. The interrupt is 
acknowledged by reading the WOL_INT_STATUS during bcm54xx_config_init() 
which executes during ->probe() and ->resume() and which is a clear on 
read register, this is also necessary to charge the device with the 
wake-up event.
-- 
Florian


