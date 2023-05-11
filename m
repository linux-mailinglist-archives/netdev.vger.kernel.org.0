Return-Path: <netdev+bounces-1940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 928946FFB14
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 674861C20FEC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32254A928;
	Thu, 11 May 2023 20:11:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F103206B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:11:40 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD9310EC;
	Thu, 11 May 2023 13:11:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50b8d2eed3dso13816445a12.0;
        Thu, 11 May 2023 13:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683835897; x=1686427897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Gv59x7GRc5rw9NVZjRlpFcBsJGKMNlvZ+8b/lko974=;
        b=U9jwxYVWRvc7c3eyMw7CX12GG4sKAyEyzAA+PJAODX5/yYAfX1SZB6hQe0nKAaCeFT
         AyDl2k49B8BGm9h8XkL+n/41aza9gqD034iCxh/JMFGOWPLRO3pBKMYyzG0l9gzVoqyy
         a7RR/FOuXjKHjkYBCtoGnqCtwsGAPY61QqgQYEYvoKHaBzjM6JBeLGAvQGCuc9OjVhB9
         BlR33EQUKnNPcvMtAj9yBRE8D9cKZuqHHDz2Uax0Atza+WtlcnM6ZqQUq/bbFz60Ans0
         BFwaugWAg4Vl7GbCno+D3aSO8YmnZt2SKJcSPWNHi0DvG9r570qW6hSdBGkhp7SF00Rf
         Qejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683835897; x=1686427897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Gv59x7GRc5rw9NVZjRlpFcBsJGKMNlvZ+8b/lko974=;
        b=XgGjgwKM7U8W2s/TLMeZ4c5rHnn3JrAvwl+sxdqJl+/sVHk6OMFfiF14yQG013byod
         4S7BFZmx7j/IyhD23iAgfqta5vWcW/DGYyI9t+lof130Wf7Ijvg1PIp0z+uyTIpoivAc
         iOrIhyfuDEyxja1OJDECu8B0Ok0G6tHraLxBkuPph0UAxS94A9tpaN+Hy3j4N1ZiGGr4
         ZD5l97TsqsZZdAOSFV7vPDwOQ27urIs57KSAdqN0pVdkd0Mtes815jyfL1lqlYR7eSac
         Qvu8ag9CkI53T2bn7xZTjQSvX36SyWYRwTGHCNs1ezRa9IOw++WmWtvbcjYCKLx/TKp/
         yG2Q==
X-Gm-Message-State: AC+VfDwFHC+EC7zFwXy1ysFuwbNe/g0fJTNkSlXce1aWmUn8Yw4UHdfa
	aQ9znDY4gqS4uDbJveJD4PoPHwmlMg4=
X-Google-Smtp-Source: ACHHUZ61T6/jjmTvoOauQp2G3JqGNSx50QqwOuG6jWjusDoinNT7NX/OAG0HNY9C4xqkCVIME1Zw+g==
X-Received: by 2002:a17:906:7949:b0:969:ffcb:1eb4 with SMTP id l9-20020a170906794900b00969ffcb1eb4mr9552168ejo.2.1683835896960;
        Thu, 11 May 2023 13:11:36 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c58e:b900:c905:524d:7524:40e1? (dynamic-2a01-0c23-c58e-b900-c905-524d-7524-40e1.c23.pool.telefonica.de. [2a01:c23:c58e:b900:c905:524d:7524:40e1])
        by smtp.googlemail.com with ESMTPSA id jz10-20020a17090775ea00b00965ef79ae14sm4398958ejc.189.2023.05.11.13.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 13:11:36 -0700 (PDT)
Message-ID: <f96e4a8a-1b69-a783-d1ca-7d8e48100954@gmail.com>
Date: Thu, 11 May 2023 22:11:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 14/17] r8169: Use pcie_lnkctl_clear_and_set() for changing
 LNKCTL
Content-Language: en-US
To: Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
 Rob Herring <robh@kernel.org>, Lorenzo Pieralisi
 <lorenzo.pieralisi@arm.com>, Krzysztof Wilczy?ski <kw@linux.com>,
 nic_swsd@realtek.com, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20230511131441.45704-1-ilpo.jarvinen@linux.intel.com>
 <20230511131441.45704-15-ilpo.jarvinen@linux.intel.com>
 <98b3b70a-86c0-78c0-b734-0764bb5a21fc@gmail.com>
 <985b617-c5d7-dce3-318b-f2f8412beed3@linux.intel.com>
 <20230511201025.GC31598@wunner.de>
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230511201025.GC31598@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11.05.2023 22:10, Lukas Wunner wrote:
> On Thu, May 11, 2023 at 11:00:02PM +0300, Ilpo Järvinen wrote:
>> On Thu, 11 May 2023, Heiner Kallweit wrote:
>>> On 11.05.2023 15:14, Ilpo Järvinen wrote:
>>>> Don't assume that only the driver would be accessing LNKCTL. ASPM
>>>> policy changes can trigger write to LNKCTL outside of driver's control.
>>>>
>>>> Use pcie_lnkctl_clear_and_set() which does proper locking to avoid
>>>> losing concurrent updates to the register value.
>>>>
>>>
>>> Wouldn't it be more appropriate to add proper locking to the
>>> underlying pcie_capability_clear_and_set_word()?
>>
>> As per discussion for the other patch, that's where this series is now 
>> aiming to in v2.
> 
> That discussion wasn't cc'ed to Heiner.  For reference, this is the
> message Ilpo is referring to:
> 
> https://lore.kernel.org/linux-pci/ZF1AjOKDVlbNFJPK@bhelgaas/

Thanks for the link!

