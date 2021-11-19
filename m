Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E13457851
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 22:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhKSVtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 16:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhKSVtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 16:49:41 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DE8C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 13:46:39 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q12so9701870pgh.5
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 13:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xdwnn+R/CDRk0q2aJbhMbLAU4+VZ4/JzLhtmqssCNSE=;
        b=UC5Pa22BCPgFgrQRGBAmF3ifnIePk4hJZmSgaUye5j7oSqWX1dwmstYLEfPc34xPOR
         MWtr+LOuLU6SI+xFH1dADPLwBxwFwGaAlex+JLOqZalJRMgIiCJQvnePjoxl7058Vkcp
         BAVLTwMqVQVtYLHbnzITgUsBQjvZnr2NfvOCRHGTU+VWYRIjabAAzRmBdlQ8x5pUCFny
         MaOeutWWnpVvssuSiEqSANYpiFq54DL6fb22pFpL6ZarDXTZd0OEMekihTbYLs6B4ATr
         h7NZJxfOyTRsILvtlTeQU4HEarVY1AHj4wCa3K+yYxQx23Yv1ykpZQVV/eVRLD727JCq
         GDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdwnn+R/CDRk0q2aJbhMbLAU4+VZ4/JzLhtmqssCNSE=;
        b=wxsegFuctB4YUQ5xyTf6ZhEHUPzk+gZN2TAL82OPX0jVhsD2MC+aCO98A4PagBpbwI
         ol6XcleDx+1lBwZVtK1hMdBtBK9ELBeWqpfhCwqj7rS2nM5G7e1WZJW3GBZs9PEyBgTf
         2IkLyU99GZdE8wFXfvgOcunpVguT6gQVm/MJq2y0oITy/L+FojXPbHoazRsKdDErlqzV
         sJ64KZz0grf3NbnyL2TO79EdJP2ie9FcHId01SLPTgwIy578XWKUQECATYDURJv95lZK
         NHmkELgxxOlBMx+wxgdG6LTnaLGnFiJ7SgHErGGGODgOGcX6QW/oZbSiydZMS8ifq4Q7
         1Y3w==
X-Gm-Message-State: AOAM533deb2v0X+VRbfqMPMCXYRamNqM4KF7PVD/Ttwi2b1ueF/9ZXu2
        QeIrPzaHrd+2QgSwzMFd4MDLs1lcxCA=
X-Google-Smtp-Source: ABdhPJyl493EemN4/3yeslL951J9CLtG+eglhucVWoqp3DXxvYTRcFrTGNIUgDlM4a0sJQ+l9lgnsw==
X-Received: by 2002:a05:6a00:1a51:b0:4a3:4af3:fcc6 with SMTP id h17-20020a056a001a5100b004a34af3fcc6mr11362900pfv.85.1637358398378;
        Fri, 19 Nov 2021 13:46:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z30sm554995pfg.30.2021.11.19.13.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 13:46:37 -0800 (PST)
Subject: Re: [PATCH net-next] net: phylink: handle NA interface mode in
 phylink_fwnode_phy_connect()
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <E1mo6kA-008ZGa-Ut@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4f949948-770c-13dd-6f6c-ca6ac2226462@gmail.com>
Date:   Fri, 19 Nov 2021 13:46:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <E1mo6kA-008ZGa-Ut@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/21 8:28 AM, Russell King (Oracle) wrote:
> Commit 4904b6ea1f9db ("net: phy: phylink: Use PHY device interface if
> N/A") introduced handling for the phy interface mode where this is not
> known at phylink creation time. This was never added to the OF/fwnode
> paths, but is necessary when the phy is present in DT, but the phy-mode
> is not specified.
> 
> Add this handling.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
