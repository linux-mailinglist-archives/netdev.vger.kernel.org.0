Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC214985EA
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244029AbiAXRJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244230AbiAXRJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:09:44 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB27FC06173B;
        Mon, 24 Jan 2022 09:09:44 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so439954pja.2;
        Mon, 24 Jan 2022 09:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QE8pJtTMoYdDHJAtBqji1V9DieZJck0kxv9CAHW5UMY=;
        b=crjmhB1Z+RS1q8ktQBw3YUhkzD7s7woazxvUAgl3Rrg1e0fOzcxmWRil91UdTZB7cs
         O5I7mhZVpzQAd6ZWPStIQVNkNP7AkoIJvyM+SWRtU2LdAWVI5FNctkqLgYMTz+QOrnXV
         1fH9p1vB7wXtDXz3vz4jRogELrTguBqjnG6ObubR+1/DJ+3S4Ejm8tlXcUvYuGAZT5Qg
         WQIdmnNsRzc2rdhl1T+kF+Jw0zb5sUrr1YUEtSAMU9LtxZ34eJ/s2Rt7pmp3fR5PqZzy
         oOuagTQP4oYb1rIEo6bIP8pYFs54esR4/FfC0a0bePIFrTx2RWCxtbSU+7idhPcXDop6
         35iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QE8pJtTMoYdDHJAtBqji1V9DieZJck0kxv9CAHW5UMY=;
        b=VS4/rbUDyly4WJOFzRLq+6g3e//NknsKzQBNbAAeJQl0jng19tZatlhKtbxeoF2CVU
         lEG03stEYc+Abgl20xmxHPnvwnxj/6380hSMrdjfGgQTotdxJxeNLo2SdLsRLxBq2Qbt
         0W6x3K+OCM0PUstBRWzHwz5nihcTrm67OjmfuypHH7BKpcLm6FN9OJvhwAkq7I8jOS53
         ghRxLRD7zIEwjpZeNbKp1PN090kRScZE9yEB00mYYPFpHZl5cIcrRiIEMSpVfgjO8XLN
         9Qiu5W4TaI5up+25hxTEGta4UFIjVqnwiVPcmTzhzlAr9RMPJDksbT9sJ3vBnADg2eet
         XJhg==
X-Gm-Message-State: AOAM533LfXF4KtmHw2aREqkZcROjZH7UXYG5Gy6p8OHlXoZH0gLY78sI
        nUP0uSm4EYZXLVuogl0hYYI=
X-Google-Smtp-Source: ABdhPJyCHG1ScNMOYjKnM4xN/inKbAncgw3P2Yy6QvhmPW7XJcuRbtEhsblpix6z34++DrJTm6TFAg==
X-Received: by 2002:a17:90b:4f49:: with SMTP id pj9mr2837537pjb.211.1643044183996;
        Mon, 24 Jan 2022 09:09:43 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g5sm13502751pjj.36.2022.01.24.09.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:09:43 -0800 (PST)
Message-ID: <562d9627-fe34-fbef-e908-d06a1cdd7cb4@gmail.com>
Date:   Mon, 24 Jan 2022 09:09:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: dsa|ethernet: use bool values to pass bool param of
 phy_init_eee
Content-Language: en-US
To:     Jisheng Zhang <jszhang@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
References: <20220123152241.1480-1-jszhang@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123152241.1480-1-jszhang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2022 7:22 AM, Jisheng Zhang wrote:
> The 2nd param of phy_init_eee(): clk_stop_enable is a bool param, use
> true or false instead of 1/0.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Nit: for future changes, if your patch spans multiple 
subsystems/directories, just go with the top-most subject prefix, for 
instance here "net: " would have been sufficient. Thanks!
-- 
Florian
