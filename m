Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CC35916A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfF1Cn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:43:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44127 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1Cn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:43:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id t7so2342229plr.11
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 19:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tBKi+gIIyaMulylxguDxuW5JMIag9yYh7Pte2cI73X0=;
        b=MYw0Lm0iuTnJMbenLQBjFNqd6yVabh+M6lg2HsSZTzPNVFMI1IHdQ6+NDcKeSjsk1e
         HtV4RK73tBYAxqnc2P4bkm14EibZd04Z3MLycjgmcxknVO8f03gyDWYZlU+cH8BCULAy
         VREGJuu/PjMUqAtx92gnQr00DCenDj2Au29m/z5+UdoMADFBVLIRr7YtUnKQBwFyqV8A
         xMLjbhXspHeu5gL0HKt21ZfUxiAufnpKHyw5fMdLCzTS8bESH3NvIZDHxk2MUly+zsjl
         FmUzK2AXRdcV3IIVKQuKe8Q0vDhTXO+au9b+mOT4RWPVonkz25UOtlo36Y4SQ/3SjQA4
         /uvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tBKi+gIIyaMulylxguDxuW5JMIag9yYh7Pte2cI73X0=;
        b=gYxgUro42NI0nyzjofaZ70gVMjTAB9o4wk4+93I5A+Ch0sXLwOPS7PObDL1mbX9lEA
         hG0lKBwjLG62HqGlUVb58t0OcCp8t9oivuwcoI/putXVFoy2uMR73ZTiIjjLuesK/6FC
         1ujyOKSqs/T9QhIK7gCybQf/HMUCuxDgI18o4SK/q7N7Z8yvUaWupxDkmqQOdJv43IVp
         zBl6MYSIFOGUCJZNtSs+GLaxricTKFXFQ9e2GcHwD2Bla4bGAtGAwwOBryMy3UgfdrbA
         AS1gWg0g2hx1q0wF5QLZbnj9dKqkPSFDkLK4Mf4exAKtDqEbimsgbU4hKfdg1lWv07nN
         C85w==
X-Gm-Message-State: APjAAAVtQRYjJrpXmaPiRfI8CCBgb1XuKJ3sxnNR5zuP056lCuCAC4a6
        wC44daEwzx1uqKCanTbGLGsPvUfM
X-Google-Smtp-Source: APXvYqxpMTfg+raI9IE0gcxq9PW+ISKFPlF9S43FPh9uYR6xpmfnRz6Ho9RioTdYdXQxKc3msXjsyg==
X-Received: by 2002:a17:902:306:: with SMTP id 6mr8702424pld.148.1561689835341;
        Thu, 27 Jun 2019 19:43:55 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d12sm435184pfd.96.2019.06.27.19.43.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:43:54 -0700 (PDT)
Subject: Re: [PATCH 1/5] net: dsa: microchip: Replace ad-hoc polling with
 regmap
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
References: <20190627215556.23768-1-marex@denx.de>
 <20190627215556.23768-2-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ae4c90e5-a5f3-5d22-bd13-23881a8fa9b9@gmail.com>
Date:   Thu, 27 Jun 2019 19:43:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627215556.23768-2-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/27/2019 2:55 PM, Marek Vasut wrote:
> Regmap provides polling function to poll for bits in a register,
> use in instead of reimplementing it.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <Woojung.Huh@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
