Return-Path: <netdev+bounces-5753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4EC712A68
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 058791C20F90
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E21C27718;
	Fri, 26 May 2023 16:14:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308B6742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:14:06 +0000 (UTC)
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AA9BC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:14:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2535edae73cso1016869a91.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685117644; x=1687709644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JaJ2vbnARxGo51GuYCC+QnWlLxkxBOdIdH9HbCX6khU=;
        b=lQ8bTLT6ANRkc48ezNo0Sf6992OsWfGWeeYew/NXRB1C0sgpyudiiYuG4KDzv2/HtK
         zlQV/OgA0QJOx9fjmK16x1mBpfRNjbT+3gMNwssfklEFpEm0MSI4FTP1r5EBJPrMbXWa
         nBQu4qW2+W1gJNM5R1LMSbgOj6EKT4qspC10VrXxHCAFczmqThDK9bAvmSWmO4B8FQKn
         Bh6J2njMHOlTuslsSvxZMXXba0zOcFYre0r9nJPJ5tB2NSUKVhKsS/NDBLHlO5Pw8DML
         pDn3HWeDwfoOpYJGPnnQQYKTwMpCCei/UqI81NxWvGI8eAMY4SZfbFdOassLh/RWeHP2
         oc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117644; x=1687709644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JaJ2vbnARxGo51GuYCC+QnWlLxkxBOdIdH9HbCX6khU=;
        b=bh/TXuM6w+33QlAAHGKwaDyAoGtkjyYB7iIdhAW65cZ0RrgW5gb9zQ9Q/mftd0R18C
         0ZCLsKaklPo+K8crLfGltIr2N+xipISz5L4ymQzbEpodgQgDSvSGTymCgK3EbW9dkfgL
         M3pxF4b3KNkHjyXP9JZlweWXJKp3g+VgKY95llbTd/CQ+FcS0COYYHmXi4agapRZTqTm
         VK7dIQQ6WNzoNL6UYODO7N1xI/6lMeT2juRrHQiMEgg8bOA2z6ka9SESQ8jMco27fAZa
         mr9voq0vGNwHTHFFWaqGbDKhbaEPkcpRUZYxWNtlUiQ3zxQ2rY1hPTswPu2MRjNDHQWB
         2JUA==
X-Gm-Message-State: AC+VfDz0KHQQEz1VsExXGMjfq2cWDlfgi8kz8mMiwLj0OlYLSx25CX0o
	0OSxKB1GvqGWgFbgjvkRrXel+sIXzN7nfg==
X-Google-Smtp-Source: ACHHUZ6fsxVzglXIdO0y6C1TnMjKuz8DBdAzQelrF0PMY6FnkBRl9KK5Y4aSC+FBvr8FCeq8xu2mCw==
X-Received: by 2002:a17:90a:6e4e:b0:255:517a:41c9 with SMTP id s14-20020a17090a6e4e00b00255517a41c9mr3017867pjm.9.1685117644045;
        Fri, 26 May 2023 09:14:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lp7-20020a17090b4a8700b0024e026444b6sm7711544pjb.2.2023.05.26.09.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 09:14:03 -0700 (PDT)
Message-ID: <32662205-67f5-694d-b5cb-6e7fce40e3eb@gmail.com>
Date: Fri, 26 May 2023 09:13:55 -0700
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
To: Andrew Lunn <andrew@lunn.ch>, Oleksij Rempel <o.rempel@pengutronix.de>
Cc: netdev <netdev@vger.kernel.org>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230526085604.GA21891@pengutronix.de>
 <95412f7c-1f91-4939-bc7e-f0625d477f7d@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <95412f7c-1f91-4939-bc7e-f0625d477f7d@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/26/23 05:08, Andrew Lunn wrote:
> On Fri, May 26, 2023 at 10:56:04AM +0200, Oleksij Rempel wrote:
>> Hi Andrew,
>>
>> On Fri, Mar 31, 2023 at 02:54:54AM +0200, Andrew Lunn wrote:
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
>>>
>>> v3
>>> --
>>   
>> I was able to test some drivers and things seems to work ok so far. Do you
>> need more tests for a non RFC version?
> 
> No, i just need time to rebase and post them. Plus check if there are
> more drivers which added support for EEE and fix them up. There is a
> new Broadcom driver which i think will need work.

The Broadcom ASP driver should have EEE stripped off as we just found 
out that the MAC does not drive the PHY signals properly yet. This 
should allow your series to proceed through, without having to care 
about that particular driver.

Thanks for doing this work Andrew!
-- 
Florian


