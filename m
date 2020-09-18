Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB4226EF2A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgIRCdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgIRCdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:33:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CBAC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:33:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id e4so2172675pln.10
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wJZTNiDvTDOSM0lqwr/sdiy60NaPWfw4pg/O3DD/G2M=;
        b=jGw58WaqXexR2MnSOjpQp4cO7JLHLAx0c6oDBbj4q+9qnyv/HMWFvk09tfS3ARIO+z
         NZQO6+2WS5eymM0ZMGZFEn7HsKHGfPQa/bELTwJ+ZlwHiLeC1ZLo/mNXkYOafhU1EKja
         ppoaSiqWn5Umxqqh/xW08ifgN2bLDAnOlCAF3F3Zw1Z3LjT7jBYTyFqg906wuLe5dWvk
         qRV5aZZV7PRCAY0FtMgplM15YbDDE9CPnnkUmlul9crbgTHuEL47Lup4a8mSltulEi2a
         M3t43Bo1Cv8UlsA6bknFNpfWdmXjZSCVnKZU9OYcxw93NJ8H+FfH6bepIcZLZ+LSrhs3
         /gYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wJZTNiDvTDOSM0lqwr/sdiy60NaPWfw4pg/O3DD/G2M=;
        b=eGEdIRdyJSQYLxb+tGcBTD5HIisZeN4ixJQVv+V7YTqtYOZDKE+r8rjVc5rc/PdYXs
         iXvPPXXoyUnp9Rw/CSWVG4onCyrnSDW9C8cvlidTqlAeRpYGeyELop5zKM7rCN+MEiqh
         CQ93EjM4RpFiCTxJs7c5YKGhXM2/5Vyi/JuIm7ArsKqEOGhW85mz7yjfO79nKKchhX2Z
         K7KMfiUMsK7RBP5KZOKwbNzpgCSVxUtqUt3i4rpiJODTwLUJkR4M00mLd3hD2ZTtieq7
         EPN/6nwba6dl2/fssmQYO8nlnrUc1JxomXBXfmniIl5hgu47BCszftzR0mqU/+OECYcd
         jVbg==
X-Gm-Message-State: AOAM530FirlWqW1FtRjjF4oPB+qNIPFMp+SmN9E/z9iTEuwuBXI+wL4Y
        bfkz5w6pzRpB/VG+cvS2Sts=
X-Google-Smtp-Source: ABdhPJxLTsUdKTsacbJWQNhlj0N7cDBWOCr54eg4Fv0B4TYdGKzh+iCMlsFxEwD9sd/ysf2h9lwqYQ==
X-Received: by 2002:a17:90b:1046:: with SMTP id gq6mr10916916pjb.231.1600396400038;
        Thu, 17 Sep 2020 19:33:20 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm1018608pfp.64.2020.09.17.19.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:33:19 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 9/9] net: dsa: mv88e6xxx: Implement devlink
 info get callback
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-10-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <66c1a13d-c52b-d99e-5376-b879d4b56f27@gmail.com>
Date:   Thu, 17 Sep 2020 19:33:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-10-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> Return the driver name and the asic.id with the switch name.
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
