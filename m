Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD5F775B1
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 03:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfG0BwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 21:52:11 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33441 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0BwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 21:52:11 -0400
Received: by mail-ot1-f65.google.com with SMTP id q20so57102303otl.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 18:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GkP9juew67RSsJdqIVfBOEIXrHlACP1JKEVuOlV1hIg=;
        b=IAKiU3nzbXTVOh+Xh4evLMwiGugjHz1C3Mu1mIHQIKXFIVghsWJUqEZRc8RFcMjydv
         unNaZ3WHntdmM69FK2uadVcVZ31L5MOuSNqXir5f4OSrGvNQoCoqG8b0Adzb6PRsp1YD
         arkPANS5tf/3hGHTlGoFjd4FclrmWDUnjxCHoKjTzIpBBgGJZEbttImO7FNXPmO57eyI
         SC20k/tisZszstZ6mSQzT4aoQjF0mPBp/g12YYuRXoE2V5HB4V3yrY7IR8gFVu0n3je1
         7UwJU0fXUYkqqw9XU1XkeWiIPAZJjZOzKdiaS6rhZfniEfSxGd80bfdEibMvstYWhWxY
         6U0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GkP9juew67RSsJdqIVfBOEIXrHlACP1JKEVuOlV1hIg=;
        b=YffIdK2lEDesCulOW7Qmft1cEMlJ6bTqwPc/hk8BcL2mK0PZXsBQti0UYV2mSWXyQ4
         RSJ+SllvUKqw6fL7GlqG/gUDhROZBGtVWoxpUq4ZAoo3ok8f/ofbLuzRiJgNaA81SERu
         XrkUpQIlx1RUi0+IdmOK/Fnzt8uyck4vxLGygIBdEl0EcJTq7eHWcopWr0JiHkubVvH2
         VvWKca2XJf2q2uTBrWnyGFG1m4GtA2IIKcVUozBhnkHzD1EDLY2Ac1i+/2qbT3NRG7YH
         2kxvQzj/IcFMhuWMIXceFLx0G8Hf921QYImSr5zHMMlm2ER4JeeupPugq99tnvAdF7Ly
         /JKA==
X-Gm-Message-State: APjAAAXi923Ejr7lrvNQO+3GGN+TsMzM7f20ykYxXDR1yl1/MHqtxvSw
        MRNpeYYrCBbBuHeBX6H4x3I=
X-Google-Smtp-Source: APXvYqySC86U82U5gbGK8XU35ayAJK2Qg1PX8S+ItWtjob+IFJA8X4SolIEOsI1dLHeEsDxjLbgmfQ==
X-Received: by 2002:a9d:5c0d:: with SMTP id o13mr8478218otk.310.1564192330662;
        Fri, 26 Jul 2019 18:52:10 -0700 (PDT)
Received: from [192.168.1.139] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x19sm18671489oto.42.2019.07.26.18.52.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 18:52:10 -0700 (PDT)
Subject: Re: [PATCH] b43legacy: Remove pointless cond_resched() wrapper
To:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org
Cc:     b43-dev@lists.infradead.org, Kalle Valo <kvalo@codeaurora.org>
References: <alpine.DEB.2.21.1907262157500.1791@nanos.tec.linutronix.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <46a1581f-6fd7-92b4-4eec-8196254e63cc@lwfinger.net>
Date:   Fri, 26 Jul 2019 20:52:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1907262157500.1791@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/19 3:00 PM, Thomas Gleixner wrote:
> cond_resched() can be used unconditionally. If CONFIG_PREEMPT is set, it
> becomes a NOP scheduler wise.
> 
> Also the B43_BUG_ON() in that wrapper is a homebrewn variant of
> __might_sleep() which is part of cond_resched() already.
> 
> Remove the wrapper and invoke cond_resched() directly.
> 
> Found while looking for CONFIG_PREEMPT dependent code treewide.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: netdev@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>

Reviewed- and Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks.

Larry
