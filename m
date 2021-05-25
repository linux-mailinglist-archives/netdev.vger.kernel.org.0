Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4438F804
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhEYCUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYCUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:20:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F31C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:19:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t9so7140618ply.6
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LyZvXdkJ1LGn6sfTVDxEr7XFvPPDsXy1W23lh8R1WLg=;
        b=d26Wb82FSjRsN9kkyjhhnSQC3FIMVBNgZoT5H+BVzkOCGSK1mhHBR0OO8M6vCQIXd0
         jXctnlTInqF01/SR7sMPokOu9A3Y28/Pmf8dsvWwsAJYK8GKyUnbZv6SPv86qsADDyLP
         wBh3D9oxQHbg7o99x8cXBAS4qFcizSN8wXLvInl2w8ETNncweKki7lojKmQd69CgZ979
         ykTzKnzYn26V4/CLapP/NCu9SeCS9kHpR5dNmrTxGM/jNkyPRXSFyRKC1AlhC3O5fjU/
         Ahfs9ncCxGZMC3sjCJf0s4rFPDts8B4I4eae4n9n8asy03q8dbkvg37GSmFw4YPmknLu
         4xFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LyZvXdkJ1LGn6sfTVDxEr7XFvPPDsXy1W23lh8R1WLg=;
        b=PD+UEhQxKWF4TfEHABBi3iGNvzopYpzecDMTR91eCX9QvUbGp2d76bgSBYjLGaZkbF
         RGftXHQCJSh0MuzsV2rHBSYV+g++W8WHyyRMVSxzhORBAYPPkT08v5vnfkC7OKOrYSQo
         6Yx0Ox144qWVuIHZP0CEH3JnwVA4oQfpWGuuax1pZXwOJTrbq4QLORrH8/lhMIttxnAl
         l2gP5RbPJuHi4mpDJrNPv0D59b+uacq4nVaaJG3pUz98P7YtRvnGdcvPt/ETA1Jf1FB8
         RH0y+7tlIqrqjyq2zQM22YQTUw3Jjl9Y58bKQSTciiJ2+67NhXQwB60vZt4h6lSLsWlV
         rhhQ==
X-Gm-Message-State: AOAM533trn4Ed72lE2NEyc+Md0VdivtHgzz7Gc8cokucf7Cek7W8Ewze
        RwXD198iUBAZFP+VURdC6fc=
X-Google-Smtp-Source: ABdhPJzNxglFRQVxh7h0yyLUv7jo5WkQ7OMsaig/yxhshsiidU1ItInc/hnBBmE3du36f51957DF6A==
X-Received: by 2002:a17:90a:aa94:: with SMTP id l20mr2298484pjq.125.1621909157749;
        Mon, 24 May 2021 19:19:17 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f9sm11517237pfc.42.2021.05.24.19.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:19:17 -0700 (PDT)
Subject: Re: [PATCH net-next 04/13] net: dsa: sja1105: cache the phy-mode port
 property
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e328757c-c59c-9594-3b5a-e26ed2ea479c@gmail.com>
Date:   Mon, 24 May 2021 19:19:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> So far we've succeeded in operating without keeping a copy of the
> phy-mode in the driver, since we already have the static config and we
> can look at the xMII Mode Parameters Table which already holds that
> information.
> 
> But with the SJA1110, we cannot make the distinction between sgmii and
> 2500base-x, because to the hardware's static config, it's all SGMII.
> So add a phy_mode property per port inside struct sja1105_private.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
