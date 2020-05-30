Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969C61E93BF
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgE3U5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3U5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:57:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2D0C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:57:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x6so7523856wrm.13
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DogXJC2nPystN6W/w8bon3CLhkt17ejumdmrOw24sJ0=;
        b=Z1BmlX9eVWAYs5XcHhKgC9DBt5lT+Jpi41NDO/3VBweNFf7zpV9cBz11Xs+6rQ2rqX
         VjCOTePygW3sDHNi+hEzw6Ei3eFQAug2WX4Czg7XD74d4i1FyIJmot6dgal+fYX2R9ij
         gUS+w/EavHYmlhWE6Bgl3809TUF2io7zKO09YivtcOBqEnfrod4Hszibp+gNuxC8xxy3
         o7FoyXpmoke7wb4eLHr6ADcFsYlIFqIqzrUOgFUQfR5E39/qMGpDtiaMdt7V5kZGpgny
         tZgYiOupRMWBxBK5E3U+xC65Mrj/V65f8osg4BsmBrXXWFvyUnQcwmOZ5ZXhrO3nBhBu
         JjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DogXJC2nPystN6W/w8bon3CLhkt17ejumdmrOw24sJ0=;
        b=dFXuA04ZL7UgGoah08c6AVRIpE/W/ZU+g0u4aWFGY4FeJKN9izeTThn4u23/DbajoU
         tjTbJB6pWY97QlHqUwVybOYMGQktbiqG3qNleplnnXdl2CBdey8ZQs5uGwkPzoklIS7H
         HQuf3+iGaABhn2qQgG/blKUx3+BykXuOHCGggtHskMHHLRUOQ3rCrR/xypvMTJyvfPTA
         7FkZfZOydfD1YnphikOH3FEjn4+3oCQj1wyM83zWmjn4qRo+YWPRjWv8DcC+m2XpIfcI
         s9dXbumWyWK7MkUPx3Q1BRQS/1T/CgegRKRIBwSToqszcwtLTmdZOncDJsOMxIBD6EH8
         9RNg==
X-Gm-Message-State: AOAM532+r0QDE42rEDbLKWxf4FBUnv3j62JNrOq+s8cN9gERlnhCsKuG
        ngxJ0pxmr6JdG8xESzr5x/M=
X-Google-Smtp-Source: ABdhPJzUmUbiLbWjlN6HgW4/iq5GhxK+D98w0GLjqsbQRzQsBYWJniQJaYJtzGvpBrge1VVcZBBm+A==
X-Received: by 2002:adf:e749:: with SMTP id c9mr15879604wrn.25.1590872265322;
        Sat, 30 May 2020 13:57:45 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h27sm16629956wrb.18.2020.05.30.13.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:57:44 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 09/13] net: mscc: ocelot: convert
 SYS_PAUSE_CFG register access to regfield
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f99347e7-165e-0634-f29f-dbd28fcc622a@gmail.com>
Date:   Sat, 30 May 2020 13:57:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Maxim Kochetkov <fido_max@inbox.ru>
> 
> Seville has a different bitwise layout than Ocelot and Felix.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
