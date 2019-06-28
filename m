Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37915916D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfF1Co2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:44:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45552 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1Co2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:44:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi6so2340429plb.12
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 19:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oktu9RU2wK5j5qoz0nZNuS7D6az7G/Q6JXEbPBq/FRU=;
        b=N+fZDiB60/H/Ujp8dXDtDPXOMzTYEK+a/lOwUH4hXSAS1Z/eHcruh+hPYM+NelBqTL
         96ObnBGLiMdfMTL1IzH57ZCxSj+CFG/cRI47PDFu0rxCMl245TKvagZCk0ZYBLmcn2kG
         udvu4UZkaPoNOQ72k30C+es1NXEv4a+1hb1iyZ0B6BWYJ701vzZ8DDfVDop3yGtJAYPt
         qRvctqanecqzgHToJR6SDPNUAXPuX4f3CEhfkxmQ1KYocOdw6Z5Nk1A2GMwkdQ81/nsP
         3BRo0wikkIO+LMFK412REblK+b0FneSaGM6Lmq+YOMadk8REPpTbwM3HhTTEV8D7m1h3
         VVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oktu9RU2wK5j5qoz0nZNuS7D6az7G/Q6JXEbPBq/FRU=;
        b=n6m40iTnQvNPqxKKyrG5qYAr5zz8uyH3kBAl4PoS1QYdfNc5i1qKFfqhRIX/kxQPAY
         nTjoWehdj2qJDWkMvd+pRjMG8QeO/W8KwUL1z8YXWeljbj2LSGaVrwtfWU8P573qlwWg
         zJFqtdvb8CYYp3dMAYExsRghPVljL6zzzKZ/t38gfO/2rJQlWmyJddQDGOjQOQZ/S9ol
         TboB5XkhWKeABVmL+cuV870gNCHEnENC24q+or3eZc4ulTZd0E5UZgjmbdgUNlKVt1dS
         gO+TKqQ+4Iu1+8plGRsLRhDVhST4+WQBjFXld6JE4uY+r6ZpCYIB3jncBIuOTEPtj/Bx
         p86Q==
X-Gm-Message-State: APjAAAWwmKxLGIkcYpMVjLBnGcCWMVZvUdYFM/XtXrSytb9ByVaLCLKE
        TEhPw224iN6/8XHukBHVnIQ=
X-Google-Smtp-Source: APXvYqzgvi0euM0ScBZElMp2lYeK+O+UGYpcJMjytMNjqfibQ5+xOPceFPAK4PgorJamR0dTkkkjxQ==
X-Received: by 2002:a17:902:2ae6:: with SMTP id j93mr8846024plb.130.1561689867797;
        Thu, 27 Jun 2019 19:44:27 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u20sm375872pgm.56.2019.06.27.19.44.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:44:27 -0700 (PDT)
Subject: Re: [PATCH 2/5] net: dsa: microchip: Replace
 ksz9477_wait_vlan_ctrl_ready polling with regmap
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
References: <20190627215556.23768-1-marex@denx.de>
 <20190627215556.23768-3-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <6b0c6d22-42df-fee5-fce6-ad5ccc67c64e@gmail.com>
Date:   Thu, 27 Jun 2019 19:44:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627215556.23768-3-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/27/2019 2:55 PM, Marek Vasut wrote:
> Regmap provides polling function to poll for bits in a register. This
> function is another reimplementation of polling for bit being clear in
> a register. Replace this with regmap polling function. Moreover, inline
> the function parameters, as the function is never called with any other
> parameter values than this one.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <Woojung.Huh@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
