Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76A048167A
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhL2Tzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhL2Tzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:55:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1C1C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 11:55:36 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v16so19368713pjn.1
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 11:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cYbSY+zKVPWTTr8FZuUesWL2YHwVKuWM7JAIhfHV4T4=;
        b=Z4etzUsmJUYeotx8k9ZsY5TTgYDG8/HFRWMzyroGMNtMlypTIagbfqR4sAYJrpN+El
         lFNHChpSSDvlXd5XCBMALlUi1R3svQpKpSDkDmBMClae/qXc9FqeIWsrHTDkkJvkWZXP
         vccyWL2Mp4X12xbHW3+6uRME7phQgcFiI1r2EV3H04puNAx2iw1OTPhBcLzCwyU60sOA
         E6VkRR07lU+63CpvGeX895klWMnhUXly92N1lGljsVtBioMKyT9hOU+4W+gXnverPZhx
         BzsiBp5lhBlDZrIF7xeB0Le4Cpfz3WWy3b/A1fVNhEoI1JAbcOFIGZuFpPfm7CbCX1n1
         9ENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cYbSY+zKVPWTTr8FZuUesWL2YHwVKuWM7JAIhfHV4T4=;
        b=jQm26if5AWLfSLqQhuozIfyJcL13i1q0l8SFzVupO0WU6X+AP2RCGAP2dDtuGn0i+x
         E/810YMmE90NcaRUbNv0yD5kALnUDwoeLd3f+mrZfpShMuwd7GuEUlJbjf4kV0AcDTN1
         OAQRTlaWVaB6AAwjOnt+on/SaTzRa2uyGItpXvmAZ7Hljaw+tRQpKh13zh+E3scQvBaU
         fBZ4TGocAfJiKvK7erYuEKK1aF/TxXn6Np6EX9EDrZW0PIKCH09q8/PYcYUicjFMaKEP
         ldCk1Avut7mE7qqp8l+7Hg26kMt7j+KPvnf1RJIxtBb8z9YlID1Dw2z07WmvhoksT7EZ
         BlVg==
X-Gm-Message-State: AOAM531Gp/P5kEDh6h1t99/VlGEIb41YnnBcQ7M9WpcUm1rHp30te0tU
        1ZlagJayBYyVNUmuejqmyEg=
X-Google-Smtp-Source: ABdhPJxY/+oMR1U4vrMH9q88wj6NqDhQhXVAl8Cq03vJXn7oDY0Jcbznby83670CZLx3DGJwidsa2w==
X-Received: by 2002:a17:90a:6a4c:: with SMTP id d12mr34058417pjm.9.1640807736022;
        Wed, 29 Dec 2021 11:55:36 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:580b:8916:6bbf:96c9? ([2600:8802:b00:4a48:580b:8916:6bbf:96c9])
        by smtp.gmail.com with ESMTPSA id q9sm22493243pjg.1.2021.12.29.11.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Dec 2021 11:55:35 -0800 (PST)
Message-ID: <310d5632-90a1-a87b-710e-b4d42ed0121e@gmail.com>
Date:   Wed, 29 Dec 2021 11:55:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH V2] net: dsa: bcm_sf2: refactor LED regs access
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211228220951.17751-1-zajec5@gmail.com>
 <20211229171642.22942-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211229171642.22942-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/29/2021 9:16 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 1. Define more regs. Some switches (e.g. BCM4908) have up to 6 regs.
> 2. Add helper for handling non-lineral port <-> reg mappings.
> 3. Add support for 12 B LED reg blocks on BCM4908 (different layout)
> 
> Complete support for LEDs setup will be implemented once Linux receives
> a proper design & implementation for "hardware" LEDs.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
