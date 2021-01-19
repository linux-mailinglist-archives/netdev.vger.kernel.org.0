Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB242FC4A7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbhASXTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730593AbhASXSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:18:49 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F73C061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:18:08 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n25so13970439pgb.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e6G2MprNwF9r7GUQPrF6tArileQuM3+nGIN0yDq0N2E=;
        b=JblzFTP9OW2hovquyk2CjS1xq1noKLXTIPii4DgHfyGIno3ClytM2OObkfrzz1boyZ
         gVgsVn3QDxXd9Ofsco0SKFCcOKyJZhw3vGL0ANHgJzJ2udqd+yfPi2RthMBb6jgpBXZz
         1c14zXHkPAcNwd5DJSShbF1w81Q/1iCSPsmV5x67u/+beMbMAI+Ly1qdB4naNeZqGdC0
         YTWTSDB2IK0coG5Ms3NRdbWNf4v8s8+5KbduuCJLi5nI6JI4KlNhQ2Rlj00sbJMl/0Wh
         l/R9b70xwnzYJ/tndfbB6RoQOprdlLlHx54N8M1oaisGiRlBmw3TMYhL6n7fdP1uKNcg
         LrQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e6G2MprNwF9r7GUQPrF6tArileQuM3+nGIN0yDq0N2E=;
        b=qZuXDxiCEMSQ5jYIYKbXG4hv7cy4kfn2GunZaxqk+0k2l8517bBFMpKLCl3m9ZtK1A
         G99uPNGNq3+jsvcpOaVaf+tH8Z4GjZD9ZRNLxYr045HZebLEpq7JXpWsSv3vLv80X+Si
         ckbA35ARLPnxYykQTmz5dWvbwfVOfFiTTNND5c2Cl3oh3GJLOQtlFtVu1kVgHfCwy4Yl
         212zIXWC2pvQrZFjZmmLybgASLrOqICAygU+fqRIozChXFUqPsWrN+SSsNpjupug9Uou
         3HKs+P+neKtpQ2qi3LN48D0hlY41Cm5tT76aFyvHJ/vfzoXMBT1K3qYUxkRWASA4RK/L
         QPZA==
X-Gm-Message-State: AOAM530QH6M5WIYchadau50yms/s7d1YlhAsX03rawj6IQF4S7DcQ8+0
        ddpVwbzkdFt/m6Q3l6i2MYg=
X-Google-Smtp-Source: ABdhPJyK6kipBsMpgqHPfW75UcspSN4hShKAncurT4HeTIrRU4qsP66zSabQl1QaYm9kvqCNgAhlPw==
X-Received: by 2002:a63:e1b:: with SMTP id d27mr6611142pgl.441.1611098288257;
        Tue, 19 Jan 2021 15:18:08 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e21sm139085pgv.74.2021.01.19.15.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 15:18:07 -0800 (PST)
Subject: Re: [PATCH v4 net-next 11/16] net: mscc: ocelot: use DIV_ROUND_UP
 helper in ocelot_port_inject_frame
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
References: <20210119230749.1178874-1-olteanv@gmail.com>
 <20210119230749.1178874-12-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5208ef79-609a-5890-9c03-3c0249364004@gmail.com>
Date:   Tue, 19 Jan 2021 15:18:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119230749.1178874-12-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 3:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
