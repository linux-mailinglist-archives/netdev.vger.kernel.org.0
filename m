Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F49D2B8A55
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgKSDIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgKSDIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:08:44 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3B6C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:08:44 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id i13so2904739pgm.9
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=akZ9lhu1uHx4hCP5TvxiDrXkXd8TTWSK14hpXmrC5eI=;
        b=XX8LU8HGHueEPrrNU13fhmbf6k4jYh0dqvptc2nAO3J9qsxJXDrb66jMDkECyRYS7Y
         9qbYuX5WdaTQMRMV4CuFV0nOyII33qLYHoBO0FMv99tdjj/xli2P81tKYYEk4QqNOTHU
         G/nwiOCxdGciHxXO3NwEMSqEwb+PVcIuDwpr53uGDe3ijXylHZVMDSTMzujM8caJDuyx
         ysJCXa3dPbR5Pr0q8lo+y3a9vMcFn9HeyMdqjipe/tIup0ME3W3bufk7Btw4NGk9z7oi
         intCEf9CbzRzbPj3kUxm5qMHPpULYg3JX/Bt46keJkMDUjSHx5VTWnXDbc8IHYqgN9Oe
         B2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akZ9lhu1uHx4hCP5TvxiDrXkXd8TTWSK14hpXmrC5eI=;
        b=noa2rijFhwWs+m8Atvvi9loH8mKbzB6aSAP3hErf7YeBN9VZLb6Fur5fgQS+K+wu2w
         Gy7R1U6YSXqsj7zuAmhPVNseib1lfjWOMvt2rt1rylJJHu6QnL3G+Cc92PsNel6X07B8
         /RWkrqkPwE5p+MNfE1u7IRLHzjAFIPCaJDTGeuDD3L91QQeAkR0SYVCPFkPwh7Iplc0J
         x1+bmvPEaeBC1JAE3QilXawKq139p2uhdgzDEAN5r6SBTGDX1rr/UImoUpI789BDEjhp
         WUoTp7ICr4+AJFvcDWtVqApUEThYgvbE0aBrQowiS1e1NrRu1L/TcBhH5w5ebKiEP7Rg
         AiZA==
X-Gm-Message-State: AOAM530PA/t/ScBF+FKyiaqqdWhw+oAGg3Qg2zkzPLckyi/I7r3yqbhb
        TIZ5B6wjECRSjrvSMlXI11I=
X-Google-Smtp-Source: ABdhPJy/fXfD8R0F0mwfydtwzAz5MdX73muxHT7LPC1gfUTMPZQPvp+vFK13tK3XVQxnLE5r2qdQxQ==
X-Received: by 2002:a17:90a:2e11:: with SMTP id q17mr2268492pjd.190.1605755324260;
        Wed, 18 Nov 2020 19:08:44 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z9sm4063968pji.48.2020.11.18.19.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:08:43 -0800 (PST)
Subject: Re: [PATCH 04/11] net: dsa: microchip: ksz8795: use reg_mib_cnt where
 possible
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-5-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <71ba22c3-139d-9617-0046-9ebd1bc88c8a@gmail.com>
Date:   Wed, 18 Nov 2020 19:08:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-5-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The extra define SWITCH_COUNTER_NUM is a copy of the KSZ8795_COUNTER_NUM
> define. This patch initializes reg_mib_cnt with KSZ8795_COUNTER_NUM,
> makes use of reg_mib_cnt everywhere instead and removes the extra
> define.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
