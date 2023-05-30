Return-Path: <netdev+bounces-6553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD9C716E48
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA58728121D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E20A31EED;
	Tue, 30 May 2023 20:03:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029E92D277
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:03:28 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F65F9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:03:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so3605979b3a.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685477005; x=1688069005;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m4rlo7aIVEaWBMdkNEVZWCGQ4dWTXzz41pJhNf1RyDE=;
        b=XTkPUN0dWm0crKV1UtHgEKLXTHf+QInxNrCGzM/cGyxkPqMYGM6o5oByPZQGpzfCuj
         lFQRZOKrc1Yo/LATW3qTCGmCdycBUeD4Xt2WGkE5m+oLZImNVc4iZbX30JJDBx2jRa+2
         +kxhTM8EC2wQWSWLq84HvdLTlFG01RJ7YhkAmKK+X1UH9BgKCiTZTGnX9vHYVUX2Ibmc
         D6qiyDTlFMHQSdczYtvz4sGntoyif0vI+rEzQLz0Rgf/YeD7SESAvRzGRHxxKg0MGSOq
         cwb4elqj4LcDMz01QkYeCE/MP8gCc2KmcWjAQbiy6hiOmqMRTHarkSVxJ6l9Zhtm7fL4
         sYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685477005; x=1688069005;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m4rlo7aIVEaWBMdkNEVZWCGQ4dWTXzz41pJhNf1RyDE=;
        b=Yw9EkZdmFgUka4d54WcdNGNySj95s+wRlfgoNtcVWARDLf+cohGWNVy856lFeuBElD
         ZSii57FLDLzkwElNHpbtWCtYDSrQbNrlLOH1UKc29q+eriY5nqnXIrGgh7tcHjiczjj7
         M9fLBRkaQGm5CcFMtFiPm1s201R8wV/MXeaS58WqMoNkYcBQwzZNjkYyBYjLbBfZRVRG
         yoi3cORMm/2BM0Z+BnkIzL2H3HdsUAjaUlxjYohEk1+OOlsVXJR3hBmv5oOfIDb5LkUh
         nutDi2ZKbr/5MjbwTCFLI6uOr3FWSIGrlQPP7kae5Rau/emUL+vpYImNKPlHpQ5NyA3b
         P2Ig==
X-Gm-Message-State: AC+VfDz066+LSMsQpX4Ehyc0b2mJnmqElpICd4+Z/2OBOxkQdGaIQnhu
	Z4CPcRGpChH62krtUK7wG6A=
X-Google-Smtp-Source: ACHHUZ4rJPPfW6t8iRwH7kzRPHOmhGUUnKYRhDI9AvauIgRAvaikj4bsd08/PW2YtZitCHj/pg8q1A==
X-Received: by 2002:a05:6a21:380f:b0:101:2f83:5fba with SMTP id yi15-20020a056a21380f00b001012f835fbamr2733550pzb.31.1685477004880;
        Tue, 30 May 2023 13:03:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t62-20020a632d41000000b0053fb37fb626sm1831189pgt.43.2023.05.30.13.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 13:03:24 -0700 (PDT)
Message-ID: <5b49919e-ff70-b17d-0b15-ea87c86bc703@gmail.com>
Date: Tue, 30 May 2023 13:03:15 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>, Russell King
 <rmk+kernel@armlinux.org.uk>, Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 12:48, Andrew Lunn wrote:
> On Tue, May 30, 2023 at 11:31:04AM -0700, Florian Fainelli wrote:
>> Hi Andrew, Russell,
>>
>> On 3/30/23 17:54, Andrew Lunn wrote:
>>> Most MAC drivers get EEE wrong. The API to the PHY is not very
>>> obvious, which is probably why. Rework the API, pushing most of the
>>> EEE handling into phylib core, leaving the MAC drivers to just
>>> enable/disable support for EEE in there change_link call back, or
>>> phylink mac_link_up callback.
>>>
>>> MAC drivers are now expect to indicate to phylib/phylink if they
>>> support EEE. If not, no EEE link modes are advertised. If the MAC does
>>> support EEE, on phy_start()/phylink_start() EEE advertisement is
>>> configured.
>>
>> Thanks for doing this work, because it really is a happy mess out there. A
>> few questions as I have been using mvneta as the reference for fixing GENET
>> and its shortcomings.
>>
>> In your new patches the decision to enable EEE is purely based upon the
>> eee_active boolean and not eee_enabled && tx_lpi_enabled unlike what mvneta
>> useed to do.
> 
> I don't really care much what we decide means 'enabled'. I just want
> it moved out of MAC drivers and into the core so it is consistent.

Understood this is slightly out of the scope of what you are doing which 
is to have an unified behavior, but we also have a shot at defining a 
correct behavior.

> 
> Russel, if you want to propose something which works for both Copper
> and Fibre, i'm happy to implement it. But as you pointed out, we need
> to decide where. Maybe phylib handles copper, and phylink is layered
> on top and handles fibre?
> 
> 	  Andrew

-- 
Florian


