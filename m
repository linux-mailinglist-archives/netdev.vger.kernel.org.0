Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A561533448B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhCJRBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 12:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhCJRAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 12:00:44 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DECEC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 09:00:44 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q204so12375919pfq.10
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 09:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FJViD43l32C74nm5vHxzaYOz3BWbke3N1CnEs6xvNgE=;
        b=FGOhvj2/OjkIpo/hY50xTge8418FojgbjFoCJDBHM9Hh39CVpXYZSMyvZtEm7scOJu
         uji+ZvunnPhds59th0BI0XZP+9N8r8IEiX09FyvmthnLYLbCsxxZhbtkycV9XDeEPGc2
         Jg1HygVDCSPCoARgoS/B3uUy2Mv/Vr9kaUbtg7kKiRNNhy7D7OPi0ApVl1O/E5s6yYwU
         8en8n/gf82mIpsNvA0ZPlhnH90shOZX14R2cPr+f1WYPbfkss8cKMCtBbfibG+0+9dN9
         hzPEtmGRuTJ4GeUL5sEVduuTDJT1vKU1ifquQLx6kLbgityfGQft3BairpY0cLGkgeMY
         wzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJViD43l32C74nm5vHxzaYOz3BWbke3N1CnEs6xvNgE=;
        b=VzNriR7yVgDRD/f+othHaU0zhvnqOXrLFvfnmliLsX+YD5arkDHGgUfroGsrkOQR44
         C9cPjxi6nYdfD8tAlXSn5bhpDUhfX42DbSw8X5RbrQRba8LeU3r1f+sFFhOoPHnqDcYb
         280seAJKoD4BlMGk9yBrEvZakN29ejcABVOdcDc2yiTdsFCSvE3K3EhXXTpSP1s4+LP2
         GyRQAsTELDEbjnBJUXbjzv+iPdhJmCONQBVyvWpbvt2rdrGOUWKeELtgOHg3BNNadS2R
         tj80YOJEH51u00AEKOgyH7OpRV/0glrUBNxv2cyGZrmr9659T/wAPVLVmK+Ah1rMfRcY
         qKFA==
X-Gm-Message-State: AOAM531XYEe8gR7j5eYqpONH9NacLLM8iSWr7le8c06z1E+chhK70vDv
        QYX8H2sg4G210jRg0bKrRF0=
X-Google-Smtp-Source: ABdhPJxFdN9pz+aBy/sohTvhafM55/7/WjH01cJ5EiwdRgbnuPxAnISyIcGheWQKUh0CQFyM1j9IgQ==
X-Received: by 2002:a62:485:0:b029:1ef:2110:d91d with SMTP id 127-20020a6204850000b02901ef2110d91dmr3555423pfe.43.1615395643998;
        Wed, 10 Mar 2021 09:00:43 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h7sm91817pfo.45.2021.03.10.09.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 09:00:43 -0800 (PST)
Subject: Re: [PATCH] net: dsa: bcm_sf2: use 2 Gbps IMP port link on BCM4908
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210310125159.28533-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e4e0e910-ef57-70ef-c2e1-4b400ec35761@gmail.com>
Date:   Wed, 10 Mar 2021 09:00:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310125159.28533-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 4:51 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> BCM4908 uses 2 Gbps link between switch and the Ethernet interface.
> Without this BCM4908 devices were able to achieve only 2 x ~895 Mb/s.
> This allows handling e.g. NAT traffic with 940 Mb/s.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
