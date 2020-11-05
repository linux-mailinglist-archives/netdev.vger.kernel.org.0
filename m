Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2832A739E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbgKEAI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgKEAI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:08:59 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D681BC0613CF;
        Wed,  4 Nov 2020 16:08:58 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id o21so35658ejb.3;
        Wed, 04 Nov 2020 16:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w1ZvfrtckudJvuBr1/s9M5Ia0PcGRhXRB5VEW+C/d0Q=;
        b=grdT4VNFkOqGR7jQ58kE0zB6VtnKfmRaaCphmGX5xXIt5HD/DPLjTs65nCie5kf7af
         8P0NFxDwj2NDwApnfuyuwYgYIQAM3lsqO2WrOy7pV9aKRuYqOpU9Jg4oiyo/Jr1ZX2Um
         c/s8FQgIO1P3hXBGN+js3yqa1CFRls/HEtwWNo1rYlyModA6HPxseJ5AKf8NszbHh4+3
         RN5vcPdSrDsGpHphucUypYtMi60/1Uudra6WiTSkn5yvxyXAqkgiN6X3KzJvc+Txgdn4
         PDnF4szoCcEzsbJLXdvOP4mbt2MxkBqVc9GI76IuD+NXdAFUwn5D4liI2/EZYPAw/qdF
         8Ymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w1ZvfrtckudJvuBr1/s9M5Ia0PcGRhXRB5VEW+C/d0Q=;
        b=cuowIYNMCJ00l1CAEKCnlkFBHnJWe7yFwsbQhQ/VP23atnx+UN5V30Q68y+jfJOpA4
         ZXJ4DEdsOG54MVWtohN8KCiJGozKpkALazAJPsuzXhU/uCTFTFZObFaqgTNdgEmSUxi6
         bmBFj00oXpiVf8/9qFsk7Nnhge4jeNlTYFJ+eu6xLnaWBpGKMQDki+jGKtjrJb8S1Kc4
         QYMd/rDVYCyWueZmv1ad4j/RDdFJZaPXDAbYBh1dy8O+UGTMoUJ9npcRcKu/CN7s1Ozf
         XwjddyCcWlCgAYS3mFEuSRmo6K/qqe72w5OraNHtSZgIW++x1DYOE10vi2rA9rscWLsV
         PIag==
X-Gm-Message-State: AOAM5323PW9eDlaMOg+wmX9EN1W2SAl3v0A5HUXqZEXkDrmo49K0VTm8
        EfYWKis7KZ0qs+6bA2o0TdY=
X-Google-Smtp-Source: ABdhPJwOsxlDuiZAVRLJ2AA//IDaFnNzrdaiCTGEnz3A6szI00b/PMJ3weOK/FZRE3m2sKjJD5gCRg==
X-Received: by 2002:a17:906:2e8e:: with SMTP id o14mr639705eji.324.1604534937632;
        Wed, 04 Nov 2020 16:08:57 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id a17sm1744180eda.45.2020.11.04.16.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 16:08:57 -0800 (PST)
Date:   Thu, 5 Nov 2020 02:08:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 07/19] net: phy: mscc: implement generic
 .handle_interrupt() callback
Message-ID: <20201105000856.ff46ng36ioqwcnlf@skbuf>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
 <20201101125114.1316879-8-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101125114.1316879-8-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:51:02PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> In an attempt to actually support shared IRQs in phylib, we now move the
> responsibility of triggering the phylib state machine or just returning
> IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
> 3 different IRQ handling callbacks (.handle_interrupt(),
> .did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
> driver implement directly an IRQ handler like any other device driver.
> Make this driver follow the new convention.
> 
> Also, remove the .did_interrupt() callback since it's not anymore used.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com> # VSC8514
