Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7726CF04
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIPWm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgIPWm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:42:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26227C061354;
        Wed, 16 Sep 2020 14:23:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id m6so8388590wrn.0;
        Wed, 16 Sep 2020 14:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uaALsWfF1D9xfoXjRco36/wFZIs5nH3vP9iLlTuBzEI=;
        b=IVzVtSCo5zE8dA/LZXtqUtUi0zKuFNGC+mJ5LvdUJS7FqoV3PfJBEnOoCwc6voQD8d
         u4fJYBAdu2skJ4IDhuqAWWiS/qN7qCVr4BZUzeocVw/Yxip385UxSN74cMUb1ZsWEfcw
         BcLPVu1EInwBAHC9UaQvDV6umf5EGtZYFaga4SQVGJnJyvzoVtrXF65FxxEPNgcAG3s2
         mxBijNOHmlMQ/TNax2vaCnwxfwLLAvXhI+/50xajOlZ/mCaFGDEKkCoi5DBF+C4Xg+tX
         Klyu7DCO4cHfkmgHI2l40ia7tICoDXJ8QnOWeCdDgxQIKBjj/vq0MBMdBAEppvb9Z7aI
         5J/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uaALsWfF1D9xfoXjRco36/wFZIs5nH3vP9iLlTuBzEI=;
        b=t7OUTr5l7B4CiisFZdgnmsgnrQ5sF5I4/bOd1iaKeKgt0DJC4plqfTG733DFOotvYa
         x8Zn+4RfqjLLI0WhqZQYZ2T0pAdVWMoQiSld9zA95FWxXQc3Kj23sRmnJBkLhysbrnDm
         OwO9UBHhm32WNsLYfYjbMYOtAVPW8W1mm/vpO6qPmZvrjomjFNO7S54lCnWfbDijpHSm
         cSFssUeP6rulNdW6YO4WQyN3PbhMKtGj8tQrNhEPl3UvaUW+qcKk7Usc0nTmU2CKX67g
         oWIFMrDzOjjwKQff2P2oIlTKDlJAUHWZFgNs6u8Sa1giK0lpBZKVZzlfU5ErjS6yViLL
         SYlg==
X-Gm-Message-State: AOAM530Sza7oIGdMYHTJOHBlfpPIFbdlDVa3cEbbi5NoCVYY4rbn+IHR
        XzaWz4FJOo3EZUOugJTZbpk=
X-Google-Smtp-Source: ABdhPJwAp8siCWVhzUlSaubwjsROnTD/0x1q83znU0D1hEnn3QuMUTNSsnI1iypqQdsZxlO1bIgt3g==
X-Received: by 2002:a5d:6caf:: with SMTP id a15mr28884355wra.344.1600291395868;
        Wed, 16 Sep 2020 14:23:15 -0700 (PDT)
Received: from lenovo-laptop (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id n10sm7743823wmk.7.2020.09.16.14.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:23:15 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 16 Sep 2020 22:23:13 +0100
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: Add some return-value checks
Message-ID: <20200916212313.w727cxx5tzo2ttm7@lenovo-laptop>
References: <20200916195017.34057-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916195017.34057-1-alex.dewar90@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 08:50:17PM +0100, Alex Dewar wrote:
> In mt7531_cpu_port_config(), if the variable port is neither 5 nor 5,

This should read "neither 5 nor 6", obviously. I'll fix in v2.
 
