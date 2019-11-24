Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BB4108134
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfKXAPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:15:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39583 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfKXAPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 19:15:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so2945067pga.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 16:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MlWS2/07rbosC/qFv8QznfdONMvmj2+tW0igi1RVjQw=;
        b=ez1B5uRp4nlPeh7zDZUaqIVVmrQ4cZEVBD5bsp25+yTSzwX0wZswNSbOeXN8t70oOV
         FhG3p9KcCqjRhUWAOhf9cIb4WzBxbNKgGGFTdVHV7T7k9O0I4DmQNzsXLxBV/RYAfKAX
         gK/yPAbsjh2G5dH8n+2uSvTFKA62eoxD3IDcRAAqRD2Jyv6oss8RUpg1qf4z7CulEAma
         kOse1mK1qWQWI+p75R/WmpEQPeJAapr7LevBTLdqssAYGzqAkEZr18I/1jO1vXtTw9yR
         7DZisviaEICwTsNIeLinkfoWU6qMGJi4KwhUeUuXlvVe2D9lF0JNatKeHjQQjdS/U0kC
         tHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MlWS2/07rbosC/qFv8QznfdONMvmj2+tW0igi1RVjQw=;
        b=Qw7tyCuad7nvHBQD+sRTNeQSFCnlF8vkj24+59l8t7b9OOlLG0ehSsRVATMrH1A8jt
         yvw5mxiK+OmJrZePPj77UiceDQssDTB7/ssra5o4ghcMjlify3ieK3Dt2ddi6RfKaeJ/
         HA3DjeGXppcFHU6dPvSxZopi3dPXYHzrX/ijAIIQ1eBG/OP9baRQmSdH5IKpqq4ALWL8
         f/R89FL9bPaAFg47n1HS40gTndebNM7us2FcUOrGLZCp+63Om2IiNKnnXMTbmd+oSYk4
         AGvMwf4+lNo3y7noB/OArC2qr5aZSH6ZnVxDOrslyLHToGEJiLm8NqWpAI3dSrCXbL9q
         5CtA==
X-Gm-Message-State: APjAAAUIwgqUlZoOGN8sIbG3jyD08wg/OFjrfXuCMYwjJeJE4mZlqQ5D
        5yFqURvmO77iY7Du+0oP+d84NA==
X-Google-Smtp-Source: APXvYqw7Fx4pGQM8XweJFPGKswwjFyRrs7WCWKH+T4ZIjjDmS8RS/eqxt3iliLVPz19POH3ZRMTHyA==
X-Received: by 2002:aa7:954a:: with SMTP id w10mr3614854pfq.187.1574554544026;
        Sat, 23 Nov 2019 16:15:44 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i13sm2782483pfo.39.2019.11.23.16.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 16:15:43 -0800 (PST)
Date:   Sat, 23 Nov 2019 16:15:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [CFT PATCH net-next v2] net: phylink: rename mac_link_state()
 op to mac_pcs_get_state()
Message-ID: <20191123161538.482313ef@cakuba.netronome.com>
In-Reply-To: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
References: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 00:36:22 +0000, Russell King wrote:
> Rename the mac_link_state() method to mac_pcs_get_state() to make it
> clear that it should be returning the MACs PCS current state, which
> is used for inband negotiation rather than just reading back what the
> MAC has been configured for. Update the documentation to explicitly
> mention that this is for inband.
> 
> We drop the return value as well; most of phylink doesn't check the
> return value and it is not clear what it should do on error - instead
> arrange for state->link to be false.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied to net-next now, thank you!
