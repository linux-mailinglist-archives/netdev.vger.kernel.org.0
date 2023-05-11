Return-Path: <netdev+bounces-1942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D03386FFB28
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E927E1C21068
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14366A92C;
	Thu, 11 May 2023 20:17:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094AD206B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:17:25 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F692D68;
	Thu, 11 May 2023 13:17:24 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-966287b0f72so1222425766b.0;
        Thu, 11 May 2023 13:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683836243; x=1686428243;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o3yFd0Z3WkTu4ff6EQ3UVzmE4FT+cDY8nxJOS33vY3M=;
        b=b6NNutiXCUcgjnqS41dQCxSVX20rYGFiKJnBG1Q49NP9vu7P8kiGuCCRWQXXe0KcpI
         yWsOPq7ohgyb+ebyllHnUEc0KKFG9AVIuCMgDvTpNRQBz0mK5PlCbW4bqODkrYpTAdCV
         XJlOepYB1lXmFBbavUBxszPsEDn6XcKpmGB26aBmh7/HSR6AvU6nTonVZIwo2vyMdNr0
         1aR895mCqBZZLL01K26jyBmCev/VoF+xJ8/PKwGXta9BzJrvMg3tPLeeShdZzfiLXZOV
         rB/wecx7wOiZCaqh2ORsQfxK5wsnI8Q31NvBGQ1YP5yMFu6pC3TlNPLKNJL2tjYww7n1
         S98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683836243; x=1686428243;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o3yFd0Z3WkTu4ff6EQ3UVzmE4FT+cDY8nxJOS33vY3M=;
        b=F9rP3beOTkdBymZ7qSw5Ewa6yV8vkI9xbzxrIYeyNmeVT8ZEboUr237RSGzBTY1lAa
         Fe+mXUCBA8AHnHVeAqibJWXsn6C0aNytVfJdglIEIRyIt020RnH0lTzzOsNXYSSMZky1
         M1QyUjzEVSvZIoeoCXlmpY2U2q0MQxygcwzvy04omcSRlpr+lB0oWnKQTtbwd9Sq0Kna
         wMS8OHAA/UdjAXzEPs0272AE5gHjboiaX/vXukDVZj1ao1xONXj9DBIScneVaxuh4TXD
         I67w6vJTddb3VglBzSRXwr1gYmTfTm0kUBrBME1FENChU6HIiZgkMOfXIKd+cyFDCaVn
         O4pw==
X-Gm-Message-State: AC+VfDwflfLYKAuv9fymjlOexCDBRDtet4aSfciEuLrUS2LWE/Zwh9SD
	h8LN80/YXFtP7PUdic4QDI0=
X-Google-Smtp-Source: ACHHUZ60bvluRMfqGjeIfH67tu9UTIjdzm5Olcmw+CtDjzQtA9hK1sFgcrZ/qUrj6j1rQ/psI4+oYA==
X-Received: by 2002:a17:906:4fd6:b0:94e:56c4:59f2 with SMTP id i22-20020a1709064fd600b0094e56c459f2mr19981370ejw.26.1683836242905;
        Thu, 11 May 2023 13:17:22 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c58e:b900:c905:524d:7524:40e1? (dynamic-2a01-0c23-c58e-b900-c905-524d-7524-40e1.c23.pool.telefonica.de. [2a01:c23:c58e:b900:c905:524d:7524:40e1])
        by smtp.googlemail.com with ESMTPSA id hf15-20020a1709072c4f00b008f89953b761sm4466209ejc.3.2023.05.11.13.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 13:17:22 -0700 (PDT)
Message-ID: <7bb6e2c9-835c-c8d9-f8a5-baa3d3b03b12@gmail.com>
Date: Thu, 11 May 2023 22:17:18 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: Lukas Wunner <lukas@wunner.de>
Cc: =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
 Rob Herring <robh@kernel.org>, Lorenzo Pieralisi
 <lorenzo.pieralisi@arm.com>, Krzysztof Wilczy??ski <kw@linux.com>,
 nic_swsd@realtek.com, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230511131441.45704-1-ilpo.jarvinen@linux.intel.com>
 <20230511131441.45704-15-ilpo.jarvinen@linux.intel.com>
 <98b3b70a-86c0-78c0-b734-0764bb5a21fc@gmail.com>
 <20230511200244.GA31598@wunner.de>
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 14/17] r8169: Use pcie_lnkctl_clear_and_set() for changing
 LNKCTL
In-Reply-To: <20230511200244.GA31598@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11.05.2023 22:02, Lukas Wunner wrote:
> On Thu, May 11, 2023 at 09:49:52PM +0200, Heiner Kallweit wrote:
>> On 11.05.2023 15:14, Ilpo Järvinen wrote:
>>> Don't assume that only the driver would be accessing LNKCTL. ASPM
>>> policy changes can trigger write to LNKCTL outside of driver's control.
>>>
>>> Use pcie_lnkctl_clear_and_set() which does proper locking to avoid
>>> losing concurrent updates to the register value.
>>
>> Wouldn't it be more appropriate to add proper locking to the
>> underlying pcie_capability_clear_and_set_word()?
> 
> PCI config space accessors such as this one are also used in hot paths
> (e.g. interrupt handlers).  They should be kept lean (and lockless)

I *think* in case the system uses threaded interrupts you may need locking
also in interrupt handlers.

> by default.  We only need locking for specific PCIe Extended Capabilities
> which are concurrently accessed by PCI core code and drivers.
> 
> Thanks,
> 
> Lukas


