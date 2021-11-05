Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76538446979
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 21:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhKEURW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 16:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhKEURS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 16:17:18 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B94DC061714;
        Fri,  5 Nov 2021 13:14:38 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id y186-20020a4a45c3000000b002bcf06b1c38so3410150ooa.6;
        Fri, 05 Nov 2021 13:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jsvXQTkPuXvEKsz2BDFEDOM0ZuSLuIw8escE4BaHrCw=;
        b=LXH08+q9S8j0k0XZ7MODQ5SnxZjdPgD0CTQ19Sd80canoPwqG6Z5nGwatbsBc8Svu2
         GfRJF8HaV/xdQ9lJMkAW5jCjwN9YCfDcvCug4yudBMpI+Fkhi/h6qUlBs4R9jWcenDNW
         tiQevnY0L4wgntxXL0bDi2jX+tiBMAZkg8GuuJ8snj31hQi4YGCom3ifqH2bq+8NjKX4
         UJVLg5BGlnxx1gaa3gdq61AIqh5oyMuNOBVGNwVPPhv0EDLpCbnBbdex6Kc8Fqnojvbx
         92pc4WkSgAyZ8jTAe5XrT9cilj6MD8r5DDqvunGEwZ3cF04gWp+FfsvuPRCJ9w8BW4gl
         edlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jsvXQTkPuXvEKsz2BDFEDOM0ZuSLuIw8escE4BaHrCw=;
        b=Gue4ErhckhwkaYFP1MzB8H+OG194mIgWxbCtObyY5avTSSeOnRUcUu8i1Fe6sZAyHd
         ULKyVE3FFti0JLeL6DdjmIdsnvycsY9gMapESzdyHIj2sGu2UjDTiiOEQNdYgImFgLUa
         2te3B4lUWoIXOERGg64qVsxWUva3kTx0N+MqVf3Z1K/UYlcXsrziy2400ihe6e8kwfrL
         MaGB9PBwW1fDhy5Bcg3s3Fjmm3/XNrA5upvRMwdcVpcnA+qzXIsOh3ZhcOBop15k2sAl
         HGfC0bhg+KVKhteFs7h8Ggx8gpdqQcAUuuso+CmHk/n+95siK6ATzVVNdxZETW9Qm3t5
         7LMg==
X-Gm-Message-State: AOAM531esmnLAmKEyqVv7rkf6hGXD3A9Qs/cj83StsVj5Mb08Q5ShooO
        V/AywuQLFATLLLIwSSwkQCEAc4NEsRY=
X-Google-Smtp-Source: ABdhPJyCdM2CaJb/tHdVHKaJNrsADTDryq24tQ/Mwz5zE4P9h14BMn+DGn09m0ugTpDJwjmFIC7JdA==
X-Received: by 2002:a4a:b2c2:: with SMTP id l2mr1355918ooo.93.1636143277191;
        Fri, 05 Nov 2021 13:14:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p133sm2886249oia.11.2021.11.05.13.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 13:14:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH net v4] net: marvell: prestera: fix hw structure laid out
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        linux-kernel@vger.kernel.org
References: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8a5d8e0c-730e-0426-37f1-180c78f7d402@roeck-us.net>
Date:   Fri, 5 Nov 2021 13:14:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 9:49 AM, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> The prestera FW v4.0 support commit has been merged
> accidentally w/o review comments addressed and waiting
> for the final patch set to be uploaded. So, fix the remaining
> comments related to structure laid out and build issues.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

The patch does not apply to the mainline kernel, so I can not test it there.
It does apply to linux-next, and m68k:allmodconfig builds there with the patch
applied. However, m68k:allmodconfig also builds in -next with this patch _not_
applied, so I can not really say if it does any good or bad.
In the meantime, the mainline kernel (as of v5.15-10643-gfe91c4725aee)
still fails to build.

Guenter
