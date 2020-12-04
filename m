Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C572CF661
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbgLDVnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLDVnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:43:39 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEDEC0613D1;
        Fri,  4 Dec 2020 13:42:59 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x4so3876277pln.8;
        Fri, 04 Dec 2020 13:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=egQR6QaXMtZfbTgW7dW4Wu9gDKf8ZS5ryi21LZjo7II=;
        b=U76qTFivbnXWIESRUnhq8BAXqW+XwRKmvxPbtBTDlrjau6apRlfbc/+0wgycBDG/rC
         +2wJ0l/lnD5uasB2mYhDS4hVTq4YrCW25tdAdcxyALjAC6vsPiLhdpV3E6wwB+m4MMOT
         WKzwzSPpNmrguFGyQXTgpKRgMvI82Yx1M5alyCkBmxIiTpW/ryaVd+H1vVM437Z7tnNa
         uFC1Ifcp5knsIG30FuDcuu0zsnviUKG6X3ZfcHcZs5IvYYoW6KpkBurSBqqT0OFne81+
         03Nt8KMA9zl4oV7zQ1+yh9o9B9BydnC1UzmcnJGj98oPTVaEA+/EEicDb1P4IPv100HL
         kw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=egQR6QaXMtZfbTgW7dW4Wu9gDKf8ZS5ryi21LZjo7II=;
        b=V2xhpdj0xUHBtFCAP13263PK7/PWsBjQjN5P0QM8CioWMrMKh5U8d2Gghk0veMiToO
         WbwbmsMU2bLgqW1d5DXWfTxpOnx/itnnR2dHLbtD7C5ONDtjKKdC7bKMZdA5jzaFI/4c
         4MhdWIJVTZ9xQWHcs1/8e5+4fkhC7x7d8o2aRgT2qm+pDSfX+29Gqkh0A39VG453Wdyz
         pTA9GMlptWke1+EAkHsiZG8k48Dpj8Ai8N2OJKGRJwERCiufgnM9q5xp0GadngiEyIXT
         0RmcOVdfgD1zcRac6rmcwbDASyBdZWrB/FYBIOt1hyzOoXBPCIWYUGOQa3XE3Fi/+VHx
         O7Vg==
X-Gm-Message-State: AOAM532LwOXXKogDMZ+lY6AIi3ONSIZLc8pN8mzSu9jDT0jEh9dkxrCq
        86xUOG4BX8HDJBMLjcjaNQLqZm9EmpQ=
X-Google-Smtp-Source: ABdhPJwlaaS9mUVou9WeZeuuFj9FyP49um6ZcHB+lxhemp644/wfuji7Ju863TMWq/ZdLELRDpFPPw==
X-Received: by 2002:a17:90a:d307:: with SMTP id p7mr5893117pju.214.1607118178711;
        Fri, 04 Dec 2020 13:42:58 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 10sm3075201pjt.35.2020.12.04.13.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 13:42:57 -0800 (PST)
Subject: Re: [PATCH v4 net-next 1/2] net: dsa: add optional stats64 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20201204145624.11713-1-o.rempel@pengutronix.de>
 <20201204145624.11713-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1b2f7cf9-deb8-a5b7-aa78-f910b9961443@gmail.com>
Date:   Fri, 4 Dec 2020 13:42:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204145624.11713-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2020 6:56 AM, Oleksij Rempel wrote:
> Allow DSA drivers to export stats64
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Andrew and myself ave you R-b-y for this change already can you carry it
forward?
-- 
Florian
