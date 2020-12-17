Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC2F2DCAE6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLQCMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQCMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:12:37 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3ADC0617A6
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:11:56 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c12so17993244pfo.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WhyRrxcPJ9kmguJL2FzGhR6S8ZXeB3rxpiv3O9HuXso=;
        b=AtB0wl/k0mGvvMt/5z/UHiSg/W9WsfSetr2t5YOc3oZElgJjqEN3RnhbdziRTP6lHm
         aMYkO+7ge99behMgVnKwXEkSdBL1ru5AHWji/heD9msGp9s1JkHRctGIBksvmaPDMxth
         WtFghr5M9H6pZs124gB1VwrNzWQ/QZBNL+qhOR7gPwv68HZM+5F1fYGMtnkbGdRHhlED
         5PK5ZB8/H68WoKu8F+x0EOszOFYOyisZD4xRp4pT+eXkh5+Vfy/msBs2+GMWL0398cSW
         /whsCXRpW4O8uAZNThky2/tVuc1y0pUfY6Lnus3xQjHm3NMGDFLRhaNsHktn/itZePqN
         4dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WhyRrxcPJ9kmguJL2FzGhR6S8ZXeB3rxpiv3O9HuXso=;
        b=UR2QTS/vVybjMWlChucxyHnYLlnmQindkelje/LOwSyBNqPd7S73TFk36lJRR8oAmC
         MXQ/6te/g3AiXfnukJr/rd7ue+BnR+3zqklc0WqR9fx5m1tscqW6Qr/ZCXLMeCt5EH1h
         BxNwsHa13ru1wBzXF099pP6fD1LPJpmsu9wvNzOntbH4HjXvvRNzdu/9t9cAdWVEu/X5
         ETSgKmfd3+QA74zcIkEqo6pSsFdl4PJqSLt52YPBneBX9g+xOOo+KvCpz9ZrjT88wDUw
         oxrB8jFEMcViNa38FL7nujUeUYfXTOYVZiocxsi94sogKpgxMKnCbU27kSVtnCD6Ym51
         a8Pw==
X-Gm-Message-State: AOAM533FG8GdcJHAmlL9kkR0UmNicOUKJjUbl48vnX3jpRlW5sriDVzI
        J2dqmaD8EDtx3DcrmgRmCU8=
X-Google-Smtp-Source: ABdhPJypYgOhzNQ9sMxb/4Rqv/qmKPOuwozOCvO0/50sIhhs60IXNY9Mn/MNNDiPE35LzOQ/LYwo1g==
X-Received: by 2002:a62:78ca:0:b029:19d:ce86:fc22 with SMTP id t193-20020a6278ca0000b029019dce86fc22mr34850653pfc.39.1608171116506;
        Wed, 16 Dec 2020 18:11:56 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y21sm4120294pfr.90.2020.12.16.18.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:11:55 -0800 (PST)
Subject: Re: [RFC PATCH net-next 9/9] net: switchdev: delete the transaction
 object
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2ce04751-a26b-ca6c-e304-f1e15c73229b@gmail.com>
Date:   Wed, 16 Dec 2020 18:11:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> Now that all users of struct switchdev_trans have been modified to do
> without it, we can remove this structure and the two helpers to determine
> the phase.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
