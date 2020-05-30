Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2CD1E93C1
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgE3U6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbgE3U6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:58:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62148C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:58:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q11so7659522wrp.3
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jf4mKxJ2mqrWLQn4UvZhMlF/dQKkgGDPEXs6+s+quas=;
        b=VdXKpM9vlNFVSYVY5em/gWeibfyD5/8enrr0lqm75GGTq8d6n5fv/Ld0hmzqKdMcrX
         TBHooktEFoS1tghtPW+8XKrk4y4H//DWwyaqfS4SxLnTUmVgnCdP/p9rpH1sPT67U94+
         frERNBykYl7WiI2l41HGlIXz5Acpb2WEhNyEbHh5qucdoCf7KExb0XFIrA/7/6aQ8CC8
         T9qw2EFORs5FfbRJQUzVd7ZJ+AkJUUNB0ALu8wbs9GZoGydqIRwUSXty5qct30266s/D
         ZazeOBEylWZsRVeofJFkaUvT3mQ4vMjSBE4M4A50r/jsiyd0DJgX94K4XII28T+XrSMX
         clbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jf4mKxJ2mqrWLQn4UvZhMlF/dQKkgGDPEXs6+s+quas=;
        b=FJF1ZZBqddyvdM6/4HbDe8NpN56Ze/B5CJzH8UPAsclm+ZOcicKrwG7iCRTg+/c/05
         A18Ck4nNm9v2iQBRYHELukKecbaeQjHvmqen5xdy5Zv78NvB6oAI8+rnxh+x2O1j49M3
         sFijkQIrCCqNim4RWYilSSK236LQznSKB7Hrp6prH85IB/AWU8icSIAgeHRTa3mVfXWR
         1qod0AjvdJ0J/VPSmDoikzPin06s8yVRvN0xry35FtQXbGysSLEFAaRwd6VD0PFMk+3i
         gpBdGrGgAVLLb88yeL7y9SOX9qhNa/wloxpcX+iYMfxpIloSzyHRAYsykMDFNiyJAMhz
         YzMg==
X-Gm-Message-State: AOAM531/GoTdEGT6x3m+psFrY0wdRIqkNoUOcsbNxWlgEKCwuJqiiVyZ
        KFR5X9B+2Kx71fum6QbGTtk=
X-Google-Smtp-Source: ABdhPJzxHvE+/xK7wAJ98yKcbcrACsBVrnw8i2XiY5p2tlT9+Qc/61Qy5ggFXACwEJbo9kAj6/dPLQ==
X-Received: by 2002:a5d:6a03:: with SMTP id m3mr14598683wru.293.1590872331124;
        Sat, 30 May 2020 13:58:51 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o10sm14867746wrq.40.2020.05.30.13.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:58:50 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 08/13] net: mscc: ocelot: disable flow control
 on NPI interface
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2a9246b8-6fd6-d42a-9705-93fc5863fbc8@gmail.com>
Date:   Sat, 30 May 2020 13:58:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-9-olteanv@gmail.com>
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
> The Ocelot switches do not support flow control on Ethernet interfaces
> where a DSA tag must be added. If pause frames are enabled, they will be
> encapsulated in the DSA tag just like regular frames, and the DSA master
> will not recognize them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
