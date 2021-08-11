Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A251B3E8DFB
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 12:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhHKKBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 06:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbhHKKBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 06:01:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8FAC061765;
        Wed, 11 Aug 2021 03:01:27 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u3so3191265ejz.1;
        Wed, 11 Aug 2021 03:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t8sJsXG1L+yGCSNJaMEQAUetNo1GZzFfdSMSXPDTu2E=;
        b=PPudw5ZgG0aCGpmGeDrDKZ/ZHM3K/7UqkCEiBQFKDtRj4weR3ZrcL+WJhalo7r8kS6
         12GeBqpaX0H5Q3GTSOy5xAWrDn7pwuaYmJR3K34wzYAlcqIzMTCw6ImMcGBrtvCDS6L7
         dbzBnXspZjflJ+ovhtjtlCVA7VBSGMao1AKGnyC5xH11+CTqJTUzTOcwRVC9oMFHEHoN
         MmwWMVQrzYHBHGWIiBBgSmlVT/o1JbP7LD6KYRy03LF+KIKkBB4WbHqz7bnd6CXeXJJg
         rgW5ZO1YkNjgYO+Rj/q5/aaYbCGdiaSq/M+NrVGhkDHOhIHb+J2jipve7aFh0MezQ4CV
         xijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t8sJsXG1L+yGCSNJaMEQAUetNo1GZzFfdSMSXPDTu2E=;
        b=BUH247KXBI30dzOne/ov18M/scDJOHm5C4+ffNaOmQK7Xv5phpMGzy8DK9K0QeNWu+
         uXJZV7L+bJ4cV5h1VmMrMVxHIUMTi3ENvvzEE8ahCooFiffMy1M2S60doh1tdNXj3GjN
         NOoyO6QuH95oA3O/9Xm33zAGKKkDHAAI4WjmV+BXSa4HZ3r1qqkgNUBptMjoS6rJ1pIg
         vXgeLL6wkg+90eBZb6uutmAVV+WhwpRXno4+6OqMsln0QrOoWNZe6VktZP0PhbY9dt1h
         09DfEoOmsEuqDdr7oW+6HLkA3Tlx0A8g07Bfq1mNwqZz/cW7EhCl1ek+gDyn7SOhtKMp
         2rXQ==
X-Gm-Message-State: AOAM531vtb0gO01DGJT176RZVU1eOCmeZJ+VjqsXkjluvjaoBXcauNsi
        IUumjpowjlTxOUfqCwItLcw=
X-Google-Smtp-Source: ABdhPJz6CsfiRG/zGTl51wJCCX5mI5lhmvKxJB40wv/D8tnS2ztUadRA6z97LpY3pSMzT1Ms1cuP7A==
X-Received: by 2002:a17:907:1c01:: with SMTP id nc1mr2772945ejc.504.1628676086179;
        Wed, 11 Aug 2021 03:01:26 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id z10sm7889853ejg.3.2021.08.11.03.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 03:01:25 -0700 (PDT)
Date:   Wed, 11 Aug 2021 13:01:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix VLAN traffic leaks again
Message-ID: <20210811100122.hntia6od6qdc6dvd@skbuf>
References: <20210811095043.1700061-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811095043.1700061-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 05:50:43PM +0800, DENG Qingfang wrote:
> When a port leaves a VLAN-aware bridge, the current code does not clear
> other ports' matrix field bit. If the bridge is later set to VLAN-unaware
> mode, traffic in the bridge may leak to that port.
> 
> Remove the VLAN filtering check in mt7530_port_bridge_leave.
> 
> Fixes: 474a2ddaa192 ("net: dsa: mt7530: fix VLAN traffic leaks")
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

That hunk looked indeed very strange when I went over it with commit
'net: dsa: remove the "dsa_to_port in a loop" antipattern from drivers',
so I'm happy to see it go away.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
