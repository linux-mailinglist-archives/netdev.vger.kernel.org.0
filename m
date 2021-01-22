Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A8D300F56
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbhAVVx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728411AbhAVVxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 16:53:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A4AC06174A;
        Fri, 22 Jan 2021 13:52:53 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e6so4749450pjj.1;
        Fri, 22 Jan 2021 13:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XOLrhjmC6rVAyRgBoStXhP1O5SrIITRCLdMBS4GnOjw=;
        b=HL9YDTTMTFQ1M79KDKrjqtQEQEk4Z+hl8oxK7gcqeCGHYVKlZI76Zt0YmjOu/fx5nT
         XTeFVUbuHVfRB4itSsezJkmDA4gPlrlQUo0vrRVY/H5Wro5DRCPcuZDsJS1wB9L5x0GQ
         sewnUeWQyuQyB01UBZk3zBb0Mu6X0/XvFNwj3iPNFzaQZ6MlWQ6KsBXlc5W/vPY24bYF
         TAs0vwtOEMQ5DybacbrM1To1pHHbvquGu7L5KVdJ1d3SHgI6CbN3vmUR7SPSxJMOhTMn
         R5e5snPTTWe3U02lYsdmpKwEBwGr/Fs/au6GgeNavLMmivY8eRIOWaZLY/Bnj+BvfPT9
         Alow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XOLrhjmC6rVAyRgBoStXhP1O5SrIITRCLdMBS4GnOjw=;
        b=Qj9WNcbkGfbadgeVS4SHddzmk0WFjda4mFu3uH7pAqngAxBDhL7+5kzc7+kTe/qnfL
         aZGYvL6Q40c1Dv3vH6mLwCrNqvxSgctl4//6R5KHab3kzM0FA+5bQ/BBoxLj+HLsacm1
         fe5EbOS68K4V40uac1kfh5IXq9QJjuENUKcoTpr2KKix3xPglw6Psnk+sx2AJ7BZLU7L
         OcEnyi4LMK3YF1DqMeiR1qTG0vtrnGUuaOQhH+8wpJiyuClvZgHeRHYnYbNumU8bDrEM
         glWCPdqX6gtvogtLUzUcdwU1s1NOsIWTeeJEm9iaf1yqYYLrY6yUInGGhhamlODb/BkV
         MhZQ==
X-Gm-Message-State: AOAM533QJUxrz+CH2/b9Bq1rE6hglEpQFvPV+LD9XIEsmVfmnSAnKujz
        3uWQ87xgbpXi9nIRcJt9L7lrpdTpfs0=
X-Google-Smtp-Source: ABdhPJxD11rUWI5xGSGGel5IJuEUgdIOdgJd7sPLvnblZgxE4Zh55ELJTfqxZrBzkoaZnv/Gmpkd8w==
X-Received: by 2002:a17:90a:a608:: with SMTP id c8mr7587846pjq.61.1611352372305;
        Fri, 22 Jan 2021 13:52:52 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 78sm5978550pfx.127.2021.01.22.13.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 13:52:51 -0800 (PST)
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
To:     Sergej Bauer <sbauer@blackbox.su>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20210122214247.6536-1-sbauer@blackbox.su>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ecc54ce2-cbda-d801-1127-e1c15aa22654@gmail.com>
Date:   Fri, 22 Jan 2021 13:52:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122214247.6536-1-sbauer@blackbox.su>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2021 1:42 PM, Sergej Bauer wrote:
> From: sbauer@blackbox.su
> 
> v1->v2:
> 	switch to using of fixed_phy as was suggested by Andrew and Florian
> 	also features-related parts are removed
> 
> Previous versions can be found at:
> v1:
> initial version
> 	https://lkml.org/lkml/2020/9/17/1272
> 
> Signed-off-by: Sergej Bauer <sbauer@blackbox.su>

You are not explaining why you need this and why you are second guessing
the fixed PHY MII emulation that already exists. You really need to do a
better job at describing your changes and why the emulation offered by
swphy.c is not enough for your use case.
-- 
Florian
