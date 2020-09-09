Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6732624AE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIIB7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIB7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:59:17 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8DFC061573;
        Tue,  8 Sep 2020 18:59:17 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z19so738843pfn.8;
        Tue, 08 Sep 2020 18:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W87sNv4xILWPdn00Tq0pHifiPkmqMRnkNNtPclWsYJ0=;
        b=kghl4ANRcsUeE9TBiumiSFjDbCwSd3F4ucAgvUQ8rdMJ5Gxfri9pe6HP3b3+Htu9Ls
         QtuNOBP+vAVvHbWJRrWFAbIf9qOMt8ykd63yHhf9iO5/wAdQYolL2CqfGp6netlxNKid
         S2XqHc5N5jij0HkMMCH+ss+psY9+iFjdPJYZ0Wp1ZbzwEBs8oBJRYhtHNl7k0su1f+Xn
         LF5r+V9mSYfnS3sqiBJsqea0mClmDA3D/K81x9ZkXu7Nb/1S5LB1ZlvPNN7NAAgU2q4Z
         apUYV/zAmZpM5qDzqj8IbwXjNaWVpw5u3GDIq6DlgaCCfX0kPaCfr2jhXSg9z24kFxT+
         CuZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W87sNv4xILWPdn00Tq0pHifiPkmqMRnkNNtPclWsYJ0=;
        b=eOq4T8ns4NzWk1Yu+kBfSrPPVVmAIxvPLLZWNOF8wN+uEhv/SH81JiFXvfJfypSyb5
         vm5c90bR7MS8hhecYskstVncdEXcGUXfIMq3RKIDe4O8PkCra8kFuj2RgZjXwn69IauV
         6sIAhigZfj1oa1+tIB6ZXSW+quhgqGing9DbSAEptqnHMjEArwH7AOwHQDAP0U4VUPBa
         n/1vOX2kOvXeOrP1xoXBRcMGx8x7oMZ4fjpUsjw+73NvM4IG8DzwbchzWlsfDZSO6aB9
         xvpkvi8H2gvvujstKDKNMlY0nF6Iyrd9X2vr/o29ZR0AuuSKuSaIwdysfpDHbCsHi/7B
         ekkA==
X-Gm-Message-State: AOAM5312eSDMZX0kaI5VrdJBzEneB8bzvBlH/Ombf7xewegShUhbdm4L
        hyJTEJBPd70v6Ysp7bk3SuAdSMkWeXE=
X-Google-Smtp-Source: ABdhPJx3YRq1WpLA+h4D0tLfkn8NVGmbeU7Acnqx1UWIrpGgoOnPPkeglSnbyvdWGA8S9ouz/42emA==
X-Received: by 2002:aa7:8b0c:: with SMTP id f12mr1534931pfd.58.1599616756017;
        Tue, 08 Sep 2020 18:59:16 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 137sm627670pfu.149.2020.09.08.18.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 18:59:14 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] net: phy: smsc: simplify config_init callback
To:     Marco Felsch <m.felsch@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
 <20200908112520.3439-3-m.felsch@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b9d1ee53-2747-c2c2-1c56-8781ef19d1d3@gmail.com>
Date:   Tue, 8 Sep 2020 18:59:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200908112520.3439-3-m.felsch@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2020 4:25 AM, Marco Felsch wrote:
> Exit the driver specific config_init hook early if energy detection is
> disabled. We can do this because we don't need to clear the interrupt
> status here. Clearing the status should be removed anyway since this is
> handled by the phy_enable_interrupts().
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
