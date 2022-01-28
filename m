Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B4E49F58A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243341AbiA1Iov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiA1Iov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:44:51 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C40C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:44:50 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id h21so9427881wrb.8
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cIaNBMx7IdzP699KauIlrjluaHc1E9JkACiB9Gtq4Bs=;
        b=SX64XqQ5G6XVFLW17qHA87jx8sD/QYtO4xKej5z7I1qSar/bk0izQfqFV/DjTJJVql
         fOjl1nkz+snrIHhGJASANG/o7jvjEzDt/gtC1T8nW7dGCu/zkfwtcKaXcZ/KdGyeP13h
         M9eqilQZSBsEDBondyuqY1jlNO/EgJeerJiTRqtUeVR2mLasbQTh3nFsoTyrbZpLxnS9
         H1Lb7b4KECUAli/OQ8emLj52Hh39zOckXNWsCKnZNvLp/2RpqaYQsVKP9BAk99gdqJss
         L+3uJej78NvVNgKo3clZzaZD05ii8e37XK6wTf8o3Mb5BqZbI63C5K34Eij6RgTXOkfQ
         jHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cIaNBMx7IdzP699KauIlrjluaHc1E9JkACiB9Gtq4Bs=;
        b=iQ3ZCoQxHNE+Kn7IK9ZlMJKwPTwSCx5CM57+0FLJiDZ6N5ltuO5TkMz3w9q0qm9YEi
         jcWt2654L2ZQrOGScdCGsuac+6ompMKXEvcTHAikW/PnowNX3Hc/l2lJ73noM0noVBnJ
         gNpC1cIV6Mqq6ID/aupkdHarY8rsGgp3h6zyGyh1AaODTEsekDKoluKmdCL7xQeYoov6
         0E2NwwYu7TJMrck6sYpYEtpHMkNKOCBR7gteyaCFnSOH/Mn+DJVbW306iM8baa+oZHC+
         ItxR3Zy359UVN5vdx0EEPxd4V4CJOn6Rrz7F7cZ/EBYoh2GCO2l/20GogrVyVCHmeNyr
         z5+w==
X-Gm-Message-State: AOAM5311tdqZW5okzUDWQO+mZKyd1hIq+H1o/yuFpRKWlPS0BjU/RD1M
        +DNi9/FTvKhwjkKW3KeofoLOEw==
X-Google-Smtp-Source: ABdhPJzeYlGcAbO3qbM1+9qlvsWjeZd75PDVx1TVHtmLMx0EUtDp4Ri2asMbfOlDC9ori9jdCVbxSg==
X-Received: by 2002:a05:6000:168e:: with SMTP id y14mr411721wrd.51.1643359489380;
        Fri, 28 Jan 2022 00:44:49 -0800 (PST)
Received: from google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id 5sm5031758wrb.113.2022.01.28.00.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 00:44:49 -0800 (PST)
Date:   Fri, 28 Jan 2022 08:44:47 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] mfd: simple-mfd-i2c: add compatible string for
 LS1028A-QDS FPGA
Message-ID: <YfOs/wkylwMgsepj@google.com>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
 <20220127172105.4085950-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220127172105.4085950-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022, Vladimir Oltean wrote:

> As Michael mentions in the description of commit 3abee4579484 ("mfd: Add
> simple regmap based I2C driver"), "If a device wants to use this as its
> MFD core driver, it has to add an individual compatible string."
> 
> The QIXIS FPGA on the LS1028A-QDS boards has a similar purpose to the
> Kontron SL28 CPLD: it deals with board power-on reset timing, muxing,
> etc.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/mfd/simple-mfd-i2c.c | 1 +
>  1 file changed, 1 insertion(+)

For my own reference (apply this as-is to your sign-off block):

  Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
