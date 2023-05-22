Return-Path: <netdev+bounces-4409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F5B70C5AC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFE2D280F3F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF4B168D1;
	Mon, 22 May 2023 19:05:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFD0168BF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:05:29 +0000 (UTC)
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E830B0
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:05:26 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2555076e505so1713420a91.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684782326; x=1687374326;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNAUznHA/oogjiau89Ijal6Z0QbnsWrE/o0IGJe4RmI=;
        b=FN5vcgMoDO4hf2kMeQy38zrKV9BGM8EX+Ya+thyimOIyOPua94UcH3rzXcHHz1maeP
         IOCN2CVeSRRMwda2SPRaQtqAkN3/FZppnglVrkei/9FTw7uZmKyopuE5yvbj10QLlggt
         ugMrPTLojmL31PueenobiIP0SqGkMkUwjZYmPwYDKcr7AA2mu+YLn7zT50Gro12kdosM
         R1yvpe+xSRW5Teq7Bo3n3E+ESc5rVfCoJNuH8hptpo59BwjUt3zOixGtuLwKN1Z3b98y
         HMD1bpSdn7KXcU6FL0Xnv6s7Gthi09ROlap4WKoq1X/LYYmPydSgxX3IQJKL2R3N0IpZ
         rulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684782326; x=1687374326;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNAUznHA/oogjiau89Ijal6Z0QbnsWrE/o0IGJe4RmI=;
        b=UMiZI8R+DoDl+sDj5+TvgvK0aAcfydpbEnz/hVTBl3icLQpZXajZWkcNuVYlHIwUAi
         djm/1Xvgs5iWkKOOgjNuxdCnl6W9IO+q3H0uLHpT8MDrpr3nA3TwLpmXRYEU3BYGmwJ9
         hhdGZmqi41f4kQ/sSNAjdoiDOd5YgLptOSgF7L4IV7ggx01UeSQnlAKStm4FgK1GDK9Y
         EULFq0vHwCkeTGfQ97hvzvkmlP+fM8QJWmI9wpLP0FiHpUfvh7+nxLZeNeMMFQcF35aj
         7Z68Tdpsk2eMpq+XZhfVKky6jg73r7Mdpo4Mc3tblnpPpd63i8hFWoDbU6mrFtfFbyCK
         vE6A==
X-Gm-Message-State: AC+VfDx7A+NMyYKpdbOX41/mDRvt4ulr59OxPsg9A4Ywu6yPwYfUUsfR
	V3P4WuLQLiRE9uc/80mA1aQ=
X-Google-Smtp-Source: ACHHUZ7UeQUX0a+pk71jv+ib9pNgjjrWO5mZlFCyVYZyBuerkywUhxoTnv980qnPODkZdv8HWkpw/w==
X-Received: by 2002:a17:90a:ba8f:b0:24d:df69:5c67 with SMTP id t15-20020a17090aba8f00b0024ddf695c67mr10378359pjr.12.1684782326005;
        Mon, 22 May 2023 12:05:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d21-20020a17090ae29500b00246ba2b48f3sm15755368pjz.3.2023.05.22.12.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 12:05:25 -0700 (PDT)
Message-ID: <aed0bc3b-2d48-2fd9-9587-5910ad68c180@gmail.com>
Date: Mon, 22 May 2023 12:03:06 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] net: phy: avoid kernel warning dump when
 stopping an errored PHY
Content-Language: en-US
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/22/23 08:58, Russell King (Oracle) wrote:
> When taking a network interface down (or removing a SFP module) after
> the PHY has encountered an error, phy_stop() complains incorrectly
> that it was called from HALTED state.
> 
> The reason this is incorrect is that the network driver will have
> called phy_start() when the interface was brought up, and the fact
> that the PHY has a problem bears no relationship to the administrative
> state of the interface. Taking the interface administratively down
> (which calls phy_stop()) is always the right thing to do after a
> successful phy_start() call, whether or not the PHY has encountered
> an error.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

I would argue that the entire phy_error() needs a revamp, yes it's 
important to know if we have an error "talking" to the PHY, but there is 
no much that is being actionable in other situations than pluggable SFP 
modules.
-- 
Florian


