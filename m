Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FF71E93F3
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgE3VeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgE3VeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:34:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C34EC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:34:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r15so7579143wmh.5
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w8h+Icco6gS/ENgdxieuTVlhPES8T73c4AZyver1Sdw=;
        b=E+o0Jl/wCZHNvQSz2qhixFGoI98xeZ5SoXOBug4ml/ng9Hq9xTPDLSIDvDo+y9dMUN
         KTB3EVTn59PZISkY/rrzAreqdH+dTd5tCvwvH1y17u/BlBbVsuSEESgq2mWEAV6jkXSI
         7Wc8dVQPmrkfDeHpTA1VpNqz2+TEgY4twdjbaqO2SsEjAfCcugd5bpUYzNV4Wl6Wu6Iv
         +EyMqdBgJzKGLjkWNwjw4xLooRL2dzo28pMolm3YJmbPJ3Ii192rmvYegdEGyb+vzv9H
         JYN286FKp2VG+vKINp5QbpQnvMXvTmDyjKim/cPtOx/YvillAFG9ECupeN+1jUHMJsfp
         PV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w8h+Icco6gS/ENgdxieuTVlhPES8T73c4AZyver1Sdw=;
        b=SM1ONPCNe1mRY/sm+y1tVoL6o3VEVlmBoOh1/rclNSun4eI66TWZ3wqY5Qnu1VKUDh
         7ZZY8ynEc2L/dxqss5D+Xf+/p0FSdUTty/y7hIKqBj5b++MoXA4zjcRsFm1dsGmkvAs0
         caq+gAQuHZp4zkSJJWmDwaFBGgiPFOyg79ydutsEHX2SHDYpGpjC6b9Ml1x7YYduL1ix
         bmLEDueV2vevNtU5VgWkA+1k+8wVA1X2Huc00QrD4X427I79X0+i/KuwuZMLu9WBHHX8
         fEyohiqLsjIgl/qQG7Btu4XlBVuEAIr0wobgfB9N4ZatYcvjG5dgmAp5GIbCPHnPrqba
         bRMw==
X-Gm-Message-State: AOAM533N7omnFqgGZL5Tdc4y/u4TXmHdC0n6tSbHuRQ2/Ke5Qohqften
        +L9K4CJ7erFedUT6xSIRS8M=
X-Google-Smtp-Source: ABdhPJwrUEv0Taf2B+NavXpt7hgpqjhwo8HFU/NQOct9cPcixVqfAEB0n8B9SX+/xJxF+yKa/u6fmQ==
X-Received: by 2002:a1c:a505:: with SMTP id o5mr6314499wme.143.1590874453993;
        Sat, 30 May 2020 14:34:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y37sm18269716wrd.55.2020.05.30.14.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 14:34:13 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 12/13] net: dsa: felix: move probing to
 felix_vsc9959.c
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-13-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <41c190a5-34cd-30b9-1cc9-01a795943b1a@gmail.com>
Date:   Sat, 30 May 2020 14:34:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-13-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Felix is not actually meant to be a DSA driver only for the switch
> inside NXP LS1028A, but an umbrella for all Vitesse / Microsemi /
> Microchip switches that are register-compatible with Ocelot and that are
> using in DSA mode (with an NPI Ethernet port).
> 
> For the dsa_switch_ops exported by the felix driver to be generic enough
> to be used by other non-PCI switches, we need to move the PCI-specific
> probing to the low-level translation module felix_vsc9959.c. This way,
> other switches can have their own probing functions, as platform devices
> or otherwise.
> 
> This patch also removes the "Felix instance table", which did not stand
> the test of time and is unnecessary at this point.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
