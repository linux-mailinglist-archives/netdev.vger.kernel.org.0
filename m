Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168372706A2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgIRUQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgIRUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:16:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67D9C0613CF;
        Fri, 18 Sep 2020 13:16:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q4so3750934pjh.5;
        Fri, 18 Sep 2020 13:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=41QoXfpKo7UzNUol4u8WuN/OTNWDMbCscm13jCI9UFU=;
        b=uaT1lnIbfxITlNVsGT7aCs2tujStzD2UVIhAs3c8p80CGgpnmqvBFX/7srzPgcS0O8
         iAMdYSXpL/8Wb8TAuzsit0MxktWDdebnyT4p1jzTDpUxp4auTIwmU5SWw0inVGZa9Y+m
         cE4TrSJl7ES3QLgxXLzhKQ3OMahua5ppcROE7AdyhX3Y/BkJUBzUyaY5winrWlLOENCw
         6xrcnfROQoRJgYlSzESGI9lXz/HuJfPC/CW04WBw9XITyt1tlFwtF1iFSDSSlfvNNOkm
         syXrlRi8MC45QeX0Jtc0ujzKBvLFFIWQai8cyijhtiGZYVmBieqPt0kfOy68dTRI/GAi
         jBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=41QoXfpKo7UzNUol4u8WuN/OTNWDMbCscm13jCI9UFU=;
        b=DNJ2dx8PVfp+U551ZYmgTzFlPJg3UqtYDaP0qcLQYQRKtdTFUtzTnyaI+LGauwO+n2
         aOeTyVcJ1Uuu3bcZlb8qpjsUpRliaA3SPW6wRs6EQmHwGH7XGn8n9V4nMeuolj01EwzC
         3dC1+gly3wEd+RisJAEoU+k9TBQSKH9EzTFNtALbRLfyVByz6kzL+dU3ulj3QRFz/bk4
         62dyikXFxma7a7r2M0c2TPiIFgBaY/muaav8VF0OHV78QL0UXI9wO9XC5DJ6uauCf42K
         s1UD3VOHjgvhW8JG+abkILrCyVnbtuQ1uYllOZh0kcqd3AAe6z7qLguG4WZLBX5TMPdJ
         v56g==
X-Gm-Message-State: AOAM530EX0QMEbwipf/KA1ImWZIL3py1sIHrEHLP6PmRCGytnA2I0351
        vb5cwLMXvP7NqQ2S7AFwQRe5vEE3bhfG0w==
X-Google-Smtp-Source: ABdhPJzYBeVeBHXjzWd4u/vHReDwP2+AryEvgQqTIMrz9JImklpPFxRZVsvBCaGo9032lCzeNUq9BA==
X-Received: by 2002:a17:90a:62c5:: with SMTP id k5mr14481426pjs.100.1600460172927;
        Fri, 18 Sep 2020 13:16:12 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y203sm4153438pfb.58.2020.09.18.13.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:16:11 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: dp83869: Add ability to advertise
 Fiber connection
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200918191453.13914-1-dmurphy@ti.com>
 <20200918191453.13914-3-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1607ec30-01ae-1c3a-c972-44ee0105b4cd@gmail.com>
Date:   Fri, 18 Sep 2020 13:16:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918191453.13914-3-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 12:14 PM, Dan Murphy wrote:
> Add the ability to advertise the Fiber connection if the strap or the
> op-mode is configured for 100Base-FX.
> 
> Auto negotiation is not supported on this PHY when in fiber mode.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
