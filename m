Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753FE2B1954
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgKMKrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgKMKrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:47:16 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1429C0617A6;
        Fri, 13 Nov 2020 02:47:15 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id c17so9222809wrc.11;
        Fri, 13 Nov 2020 02:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=1N0C4P6z0mR8nfBhcsp3NFzEQ+eZuLAy5iskbuJ5PN8=;
        b=nd+KREmwfmDm6oDpet3+D2HPF1uBn1pf1MvllNC9Vgget4dIT6jEceAEsvnU2Xsq+D
         0inAv6tNaG7tQ3EjGCXB7O3QvqH2M6iQHrinXSBi1fsDnDxIxebAiu9xWd1TJmYHReMR
         br2q/ghKNijI/Ig9qf1/IWNV+RUvTCojsfNLZ2tsbeIE2z8C+2WhCIAzRrY3BvXf95L5
         NomH575GwbW9Pm/m3AloggCwyYzvH51plCw57pSFNlu3Z0nzhp9TJ2Qx7UxddAHXIfxz
         EZCVk7wX95smDiph1COHtNIAQoJgrCToCGfM2+n0S+S9owTz+RKfEWW+Fp32EstUT3Ly
         yJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=1N0C4P6z0mR8nfBhcsp3NFzEQ+eZuLAy5iskbuJ5PN8=;
        b=OuBakcajgGSMxiYo9GAKHlEO1S2oelq2zStjwHnfQrYCfzyndcmUmndA7Sb+eB6URg
         ouPfz8UgmW/y06oNwQ2qY1lEdMAh/uvTYaZpR9uN3gCp5Yi5xN39aukhLGTXITm1yDUZ
         Bxp0NFPfjWd0ziHcS6oLqDZC2K7XbLjXbIcGDC/q1V90r792+m/JpCl3xYRZfL7Bx/VY
         1VpMm3P2HMsztomO7GWjvV9pOfSdDMakxjeN4P9N21alIM9+z+bIAOgeB22xjowrIFuU
         s6RpyLSqUui0UYjH9SHs2+LAgNE4KkTJ+1c6mxulgDf/Xtfq9zzbz4Ra2LGudKPIwpvG
         sjkA==
X-Gm-Message-State: AOAM530wtNV/G0JKp+xEBRFvv2b144T4u386TC7XtK6EcCS7wkBGMrkB
        LagruRLG3Ehp8tMqGGTzIbE=
X-Google-Smtp-Source: ABdhPJxHlvPC/0B2r6cfrQV9VljLYDhpaufCSNT3pwxf5AjFLIpNhBJUsbtDFoEubDF4DPop47hnFQ==
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr2677576wrp.142.1605264434617;
        Fri, 13 Nov 2020 02:47:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id q5sm6405890wrf.41.2020.11.13.02.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 02:47:14 -0800 (PST)
Subject: Re: [PATCH v2 3/3] net: xfrm: use core API for updating/providing
 stats
To:     Lev Stipakov <lstipakov@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
References: <59b6c94d-e0de-e4f5-d02e-e799694f6dc8@gmail.com>
 <20201113090734.117349-1-lev@openvpn.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f1238670-7d0a-2311-7ee5-c254c8ef2a22@gmail.com>
Date:   Fri, 13 Nov 2020 11:46:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113090734.117349-1-lev@openvpn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13.11.2020 um 10:07 schrieb Lev Stipakov:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
> function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
> stats.
> 
> Use this function instead of own code.
> 
> While on it, remove xfrmi_get_stats64() and replace it with
> dev_get_tstats64().
> 
> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> ---
>  
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
