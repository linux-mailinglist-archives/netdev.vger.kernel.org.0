Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4404727FD9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfEWOhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:37:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36510 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730710AbfEWOhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:37:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id v80so3366945pfa.3;
        Thu, 23 May 2019 07:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vXrYP6IVrcterAfOWxM/mFWw20K/yhkVE+r5OVSyxMg=;
        b=iOfxNUcSiGEyOpWuZ+9PmG/Kq9Br/tesgw1a6Y70Xm1PPKKPs/0ha61+OmdTTrETAi
         60UTX7PqF6BSSMhwyvAJjA5EzcNbnUd8rcoCt1oJlVKCJm4i3WXkWWJavRoMOp8h4K/8
         we83GMgk9i71cTl3cH4dqBTX9p73nVp8vbwg7G+AzhUcnRjs2kFbDoE0zghIq0Ee/7pB
         QNV0K3BZ/eSYvjEWqFpspGUm4s+Zk99w2x8U5Boy2qL13dtV0vGlE127dxgUkelJ4MZT
         /Lw68WhPOe0J5CHaocUQ0W61XWFM3dk4OoemAB1Rs+Uvrcx3irg7R40IYBYH0j5f5OT6
         9uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vXrYP6IVrcterAfOWxM/mFWw20K/yhkVE+r5OVSyxMg=;
        b=IN37ClfFttdkLz/IKzOk19ROQ3LiBYIAWOvgIja8uSgLmKZ7ZPPVmJuXl0W33KWqdl
         mg64r+wTiSnb3dsNr6AykMbck/fGRnoqBW3SKNGGDORMzy7q/QAq9vCNYfd/a88X8IGP
         yqF84m2QRej4OVlrNXA7ZPWKVicEagY1a4KYfhSK5fucJUWRP7WS14/CNPRpMEawHLsa
         WBfLHs6tlPQ/5Ms3ynJo/8HduN/gBSerjbRAwmxmYwvmL0Z5GeQwBc7OXjLYr0d9myvk
         4lHFN5weKlaj38gyZ58XN5hps03Mqd4qVl2re/2siGhQFoOzKPClPFWhXbq4erwQMam0
         fukg==
X-Gm-Message-State: APjAAAVHBQOAIUsynp9N6YUisjPHqu5CIsoFqVXFgiR97mWg6xGsgSas
        Uo/Bb0H2M9BqXjQoThNPoB/E6pGP
X-Google-Smtp-Source: APXvYqx+0UgZ3U8YG32buG7b66gR+glOP2cTRyJdh6HObzcpau5irLYVirnqpGWGgXGeoP85HDyGow==
X-Received: by 2002:a63:441c:: with SMTP id r28mr18615091pga.255.1558622228957;
        Thu, 23 May 2019 07:37:08 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id l7sm31306539pfl.9.2019.05.23.07.37.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:37:08 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: phy: lxt: Add suspend/resume support to
 LXT971 and LXT973.
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <eb206b659fcae041be38d583ff139ca73e9e03c3.1558601485.git.christophe.leroy@c-s.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <000627c4-985f-6d77-ad20-8884be755ac2@gmail.com>
Date:   Thu, 23 May 2019 07:37:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <eb206b659fcae041be38d583ff139ca73e9e03c3.1558601485.git.christophe.leroy@c-s.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/2019 1:55 AM, Christophe Leroy wrote:
> All LXT PHYs implement the standard "power down" bit 11 of
> BMCR, so this patch adds support using the generic
> genphy_{suspend,resume} functions added by
> commit 0f0ca340e57b ("phy: power management support").
> 
> LXT970 is left aside because all registers get cleared upon
> "power down" exit.
> 
> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
