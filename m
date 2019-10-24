Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29CFE2861
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406591AbfJXClz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:41:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41659 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390604AbfJXCly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 22:41:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so14127990pfh.8;
        Wed, 23 Oct 2019 19:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kNcAuHmP1uZOHAWGZ310Y3IkvQ7bkL7ip6NfO/PiRjg=;
        b=uaHMwVJjmWbmZeLBbmYP/ZVEUeekPIEOgcmfU2vAyuCPAJ2V7KbTyxcWZw3eeX+d1w
         93EaLavC4pBhD4u1D4xOKhQycaDBeirsYmUnpQYfIIj1H+vbvZ9t0FXtCwrfxqoinxd1
         6fToCOBUzMChwBAFYm+BSs7zNs0sC4qHjsYFqH2v2kxrMZB/8eUrsHNL0gLQKX7bypnu
         W8nd4uYyY2lmnXlIsfEJIvj8AODLoT3J9DHR8H5wvSf4aMriyUEtSegWioSqOo7cADjB
         uXt4jxtHnPJ41sKEn6VLnPQE3MszTgMrKDUC02iRvkUUb7dSFGTGvSiLYX7tuIFIbqLX
         73SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNcAuHmP1uZOHAWGZ310Y3IkvQ7bkL7ip6NfO/PiRjg=;
        b=NAsOx0pWpXQdorA9MznvS2E9StcK1zZj+flNC0lck+ZXIccDD8hL6n2ulpaS1McO8h
         d6C62nMujfW2IxgJtxwARBKBF2RulHsWndGbMKwaks6YCfB4xiqDqCUkpGcPKmXj1P2k
         e1YMy3ACABtHT0O+PKkKHb8h2tpmrSUeGqK9jjk1v1tjvTN/T2i/NwEnJS053kb5jcoJ
         lT879AyMGzOvBvh4q1ptbqHcZ3urktKFiYKNC58zmrjuzSB/WA+Vgnmm5nwx8j06c8YX
         B3coKQZC9v8/WI/hzX+reXKOZpDRShX1V8wTTLiLhJ9+BLI4XBUFOk4sOWLa5ipeH/Xr
         cGfA==
X-Gm-Message-State: APjAAAVkAwChUSwLs6E5eMBkVVX+gFjoko59hJC/22pfnpHGXaK8xEc9
        0LV90PMOsSEvwdGXV4FsMmzWBaVi
X-Google-Smtp-Source: APXvYqz2GLLplCk+NHM9FBe1H/OeU8HlwY5biDn5a5G480tG/2Tbo/ojOQDqYzwi8ew/tUlD5yTKPA==
X-Received: by 2002:a63:3c19:: with SMTP id j25mr14188366pga.12.1571884913798;
        Wed, 23 Oct 2019 19:41:53 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o5sm597274pfh.48.2019.10.23.19.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 19:41:53 -0700 (PDT)
Subject: Re: [PATCH] phy: ti: gmii-sel: fix mac tx internal delay for
 rgmii-rxid
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     netdev@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org
References: <20191023144744.1246-1-grygorii.strashko@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <45a6ffd4-c0bd-1845-cb71-9adbafde2dd8@gmail.com>
Date:   Wed, 23 Oct 2019 19:41:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191023144744.1246-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/23/2019 7:47 AM, Grygorii Strashko wrote:
> Now phy-gmii-sel will disable MAC TX internal delay for PHY interface mode
> "rgmii-rxid" which is incorrect.
> Hence, fix it by enabling MAC TX internal delay in the case of "rgmii-rxid"
> mode.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Should this have a:

Fixes: 92b58b34741f ("phy: ti: introduce phy-gmii-sel driver")
-- 
Florian
