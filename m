Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A7A340FE9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhCRVdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhCRVdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 17:33:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFC6C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 14:33:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so3824056pjb.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 14:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q3p2+BioLVSYx89b/spAt5IJhVVi+584wb4MvxWvcQE=;
        b=iYKlDjk9IFMiNto54oRRR0cjgJZ8O87eMmdzheSe1fsTLUQQnLfabAjfdLtzGCOr0f
         4B6f6ETaykkG5+GpQ7+QD9m1y2jLfTwVgWJeoRw4YK2EqkK0e7IzeTcdtkwQZlpiJ6qz
         THaBGE1xu9/kALs8q3+yDc1PSJ5Ti8l9gEBojDwOJkLWt8MiBStw9P4n8vwWwRVNGHWZ
         iux7QNpgKcc/5fQvO66rbrcbGjsR3tuxavbGBzlRi07wPTIHDVqU/oxgA9M3s5J1Yvnk
         N3D8SHXxepYsJ3Bh+wyL2kOdn2XgBn/iIIakxVm81r7bjPigJCldWEoONk/oRLEivXct
         kz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q3p2+BioLVSYx89b/spAt5IJhVVi+584wb4MvxWvcQE=;
        b=dEG3aLRRfplaE4H7aMa3BKmY5JT8Y6E68PdIXuFi4Hury7wvRhRemnPG/HbbhkRkAp
         YsYJyljKnaMrSiwzhPfqC6br19ikC1lXRuykVU7vQBH4I2GrntXlDvPFnxc/we71ZWjM
         JnxSg6oLvTG1Cb8ZgYbfZlf9rvGliTYPWSnfg5AqwXcPDXxFKSDv5372c1BVyHLLBSUv
         /PUh2dFfewfZZxjcj/IhItFqrQ8B8xhy0QwIF9Yli3W9IXfykplMP9MHVjidsKJ860kc
         LmpvGF/50qT0Fcsd5c4JVeybejba0UksUQHeGREMy4cSZj7fGmeCDfRVZCxFVYflkD+Z
         vfqQ==
X-Gm-Message-State: AOAM533UG6DVVvPJwPC78zyq8UWtmg6kD0EL86oEE3wtAv1sDFaElHVf
        iFNWxPooZG6JmiZsB+saYmY=
X-Google-Smtp-Source: ABdhPJyZN66kDV7ncuFcJYzsGIlD9QED33mqUo53Xshqb1/H+aL/2i4k+m8wb99qe4h7ygvcvGWLGQ==
X-Received: by 2002:a17:90b:a01:: with SMTP id gg1mr6354594pjb.22.1616103221998;
        Thu, 18 Mar 2021 14:33:41 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 2sm3213917pfi.116.2021.03.18.14.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 14:33:41 -0700 (PDT)
Subject: Re: [PATCH net-next V2 2/2] net: dsa: bcm_sf2: fix BCM4908 RGMII
 reg(s)
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210318080143.32449-1-zajec5@gmail.com>
 <20210318080143.32449-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5a8ca739-8ea7-37fb-c311-8e9a0b4c073d@gmail.com>
Date:   Thu, 18 Mar 2021 14:33:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318080143.32449-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 1:01 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> BCM4908 has only 1 RGMII reg for controlling port 7.
> 
> Fixes: 73b7a6047971 ("net: dsa: bcm_sf2: support BCM4908's integrated switch")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
