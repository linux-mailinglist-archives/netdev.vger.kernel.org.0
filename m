Return-Path: <netdev+bounces-6504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C939716B97
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FE712811E3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBED28C1A;
	Tue, 30 May 2023 17:51:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5681EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:51:38 +0000 (UTC)
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14E7A3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:51:36 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f6b94062f3so25457971cf.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685469096; x=1688061096;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NPVf1j/ZGiBZeMQOaoQ1Ab6Us4s8dVEf4ZPJKxrMJL0=;
        b=kjM5K4c/y4ffBhVd4Bm6WpIzgx3rEDKkihuaiJTcZEpINWY0BmwRcHr7ARWE+EYosj
         uDU4Myk1jCy/ps/RKuiHPWGUVmvOVZH1s/gJ+97LFBlJdw0LH07maAWSlpJlySHnOyvB
         kZUKE7r/cScqlHqr/CBz8J82Srg7+04hShA03y3L4ABRa57d89YrwiussHklHNagHJUS
         2cdnAkDpaLb1bYktxVKqax8E9rONJsmPP/TCtLGf2TIdNjgYmQdGrvEgW9RbQl7q/3jK
         jSY91hTja43YTGmVl7AA2RmkmYmmZ3K2t4aPh/MIfmtnp1AygfHLxR199FYx5lZKzkpY
         yFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685469096; x=1688061096;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NPVf1j/ZGiBZeMQOaoQ1Ab6Us4s8dVEf4ZPJKxrMJL0=;
        b=hIRMyhrRMtgZAuelC667ThKwvPiCCZFYhMEkcdHKd57IyZP94n69BdE9ATXx3nmjcL
         Gd/+t4V0qjQsVVVkR3EDroqpJ/y/j5R4pSHLlKs6gj4EXhlyfvPC8ue0dVWXxYFtDtIK
         zg2oMj+BtDkaYUvXcXtE6254wfniHFZkAm8RQhrDiJyvn8RtO4KusJbNYS7rZMWHd4In
         eGwa4poATT9XtnYPAss+snW0N8YmEmT1GoTq+wbpwLutsN2uoamHvzSBsmOQZn2gShok
         Jb5Iw45j3cmTpmuPHDkfPYFhie/yoa4gpi/w+58r8DSBMbCDKPSnSpAKayau0aIMnCU7
         4rHw==
X-Gm-Message-State: AC+VfDzJECQamezBzp1gotIr1RYBJdpSvBtxl1C7ty33GgdkTd/war6T
	UaLF/uQcoaJIw9tBKe09b14=
X-Google-Smtp-Source: ACHHUZ7Mu99AQf+GelmKTh/FuX5ypDyaA2r8FXVD7Oh5tHD/QXbn1n4rXqBBGERV5mY7EWz8V17h+g==
X-Received: by 2002:a05:622a:49:b0:3f6:af78:de10 with SMTP id y9-20020a05622a004900b003f6af78de10mr3143589qtw.28.1685469095687;
        Tue, 30 May 2023 10:51:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x6-20020ac87ec6000000b003e64303bd2dsm4803401qtj.63.2023.05.30.10.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 10:51:35 -0700 (PDT)
Message-ID: <af880ce8-a7b8-138e-1ab9-8c89e662eecf@gmail.com>
Date: Tue, 30 May 2023 10:51:27 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 01/24] net: phy: Add phydev->eee_active to simplify
 adjust link callbacks
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-2-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-2-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:54, Andrew Lunn wrote:
> MAC drivers which support EEE need to know the results of the EEE
> auto-neg in order to program the hardware to perform EEE or not.  The
> oddly named phy_init_eee() can be used to determine this, it returns 0
> if EEE should be used, or a negative error code,
> e.g. -EOPPROTONOTSUPPORT if the PHY does not support EEE or negotiate
> resulted in it not being used.
> 
> However, many MAC drivers get this wrong. Add phydev->eee_active which
> indicates the result of the autoneg for EEE, including if EEE is
> administratively disabled with ethtool. The MAC driver can then access
> this in the same way as link speed and duplex in the adjust link
> callback.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


