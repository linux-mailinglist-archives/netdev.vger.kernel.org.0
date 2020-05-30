Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE41E93C0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgE3U6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbgE3U6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:58:35 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B865C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:58:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y17so7567974wrn.11
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f/1viGS2DpZmEXiCfbIS5OjKmkUZ08bSJPXBrGerNhk=;
        b=ewt6dXTVB73jcq/9s7Vs96J1WYDJahRSKfGlJVCnkIMQDKUUBsR7zoJyHH0VF+ZdDe
         XFsy9tsdMtS3rcg7fg2qKwSXUan+vC1BiUpcrwHhgi5RRNo/WFH7728BtVVYdVLFNj0g
         rZfqhmPVQqWCcoZBELMpDv9ZmyhAj42gbmNWmCDwmH+4NmWOYIIvlStHxLQ98YBmZuoS
         v4mRbclQk2LAoiYQDkdAWUPrWHvM16JcjVRssh747gdylPNslDTZ4yJSuCYvTpAJ93Qe
         y+rVXXG8kbpaTLpC/zFSv8DzT5mg0cHoPQ/iyfksj2BdkMT7AbfQy4XNsmEVSuVFX0Qy
         fVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f/1viGS2DpZmEXiCfbIS5OjKmkUZ08bSJPXBrGerNhk=;
        b=hFTXDx9QVdFLxyKioNRz9+BvkhpHU3DODDhb+G0Kqi/06710hFuhTQpAS2VTzPd1AB
         MjnduYRUaxAp/QfwIIhN2xdhh2Pa4xxsz81MC2cDdqShU9uQJX6R4UqM1g9Ny27Q1Fp8
         hLaMNkS/rvnlpWtJDRY+iDaaSC6XMSQySmIeEnNK3nokIofMahPDsQlG8kW1Cu5rXs9f
         6+LCuKfmYe7W8d/Y5F7r2vUvUvnvRlUKuFeb2ho80XPYz1OQBxbQdWDKN4SMUfrLF42g
         k8xJKMFitbkxKXQLwfcqlCObZYoiEPvC2/CdtgykdM/rec0HyyZ7Qs2B0ecBdluMShh1
         16bQ==
X-Gm-Message-State: AOAM533RUn7NQhuCT3cPdhuSCdtewT267n3zh4OS1yDHyrMonFSAQmze
        uTkoUcDeSpJH5Ko0Ij+8axk=
X-Google-Smtp-Source: ABdhPJxAyeha6vNIZV7oYo4oB5j5kyFscn4lFEc81xAoVZiL1v4vGBm74h+PAfrYO/rrdHuhJ5X1UA==
X-Received: by 2002:a5d:4948:: with SMTP id r8mr14306947wrs.290.1590872312942;
        Sat, 30 May 2020 13:58:32 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u10sm4451580wmc.31.2020.05.30.13.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:58:32 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 10/13] net: mscc: ocelot: extend watermark
 encoding function
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b7e0723e-d0a4-ae4d-26f2-f40ccef47196@gmail.com>
Date:   Sat, 30 May 2020 13:58:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-11-olteanv@gmail.com>
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
> The ocelot_wm_encode function deals with setting thresholds for pause
> frame start and stop. In Ocelot and Felix the register layout is the
> same, but for Seville, it isn't. The easiest way to accommodate Seville
> hardware configuration is to introduce a function pointer for setting
> this up.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
