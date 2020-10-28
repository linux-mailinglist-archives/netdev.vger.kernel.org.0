Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420F529D8B5
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388274AbgJ1Wf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388113AbgJ1Wf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:35:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF32C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:35:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e7so634231pfn.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1YWaAOM7bKOyTTSNX7O62cpg01osCkvajNZeIAxigFU=;
        b=oI5Q3cls5WaCkKlzdZ8RQRDGPGUnodU/g7JsduxqpqsociMdtKKs25OqIXvcT0q+vg
         uC6F4isu76n9IpTi0RRdv/Mhx1zWTSLXYNjF68K+sr+FWEiXeRMpOOMqy9wE7v2vdysW
         h9aTI9hYIywHXwGcBBkMIlczh0BqG+w+SGkqHNL/Q0Qt0YrO7fGPrB3rxVZ9ciVw3lZx
         MydfBfUJE2CNfT7Wxcv8h+ke4qkeDP1WtcHnmD3p6v87en1W5ahNIUJ38bmu3+SnFLQi
         h4HHtQR1s8O6HIL1QK6AvmhxTTA/ZyeP/BsfmPTALt4Ws3t52Arzo+VmUMviL6enNhcp
         E+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1YWaAOM7bKOyTTSNX7O62cpg01osCkvajNZeIAxigFU=;
        b=RqhL+jFuQ411uipTxl1kFRMFjgqR5k3eZ6GhHlI8AKD5okyTNPjl4TmU4JtuSYjoLG
         1GjePRDnmBZI99tZHC2ECzZo/ziM2Z+aeBfCSWlAtXV9uQ0fCUfTgmLzy8fO+vaDlFq9
         20TrQNNMHuwqWKf0NFYuQotNq97Knd2DWYtR0RVsoFkmbEmnKiRfhbEyYCZ7w3aSaWWU
         +B1UoIjtpGRHwAW8XOYt0sMZlW6OLx6S1vC2CtuCBHdupmP4rmsRQO35RJVAju0OUUF1
         dBr+NWAEwmKl3bFXf9LAOKayjvI2FojrMt6mgNY7oLbS+GH+qNmOXY9txvQ/yLYQ5Alr
         aPTw==
X-Gm-Message-State: AOAM533vS9V/eR0+zKavlmVCJlLIxcoBI408xB91C/Cy+DvON+yIleCJ
        jtCH6DmlLC+/j3jy60i2A0QIDY43qd0=
X-Google-Smtp-Source: ABdhPJwRQ4BeFnI7+kRmVnoM7byX1FTvxX1qQVqNGOp1t2VJ3HZSCeSL/BwNAcxsjNvIHmLJbQRsrw==
X-Received: by 2002:a17:902:b903:b029:d6:631e:c99e with SMTP id bf3-20020a170902b903b02900d6631ec99emr479793plb.14.1603910796465;
        Wed, 28 Oct 2020 11:46:36 -0700 (PDT)
Received: from [10.230.28.230] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ms10sm119537pjb.46.2020.10.28.11.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 11:46:35 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
To:     DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20201028181221.30419-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <68ddb156-3fbe-6e27-f021-738f3f181894@gmail.com>
Date:   Wed, 28 Oct 2020 11:46:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201028181221.30419-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 11:12 AM, DENG Qingfang wrote:
> MT7530/7531 has a global RX packet length register, which can be used
> to set MTU.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
