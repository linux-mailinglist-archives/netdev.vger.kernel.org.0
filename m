Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C3237333C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhEEAg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhEEAg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:36:27 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED73C061574;
        Tue,  4 May 2021 17:35:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s6so1003367edu.10;
        Tue, 04 May 2021 17:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GQcBXhiG4WSKbf/NKH+KIteUYu6u/x6SNCEh0wAhXc4=;
        b=MIPpoTfg07W36wb7bopairhQEaQzQYki7Tpcwd8BU+s7fyNlDmnJpkewhI9gD3wVlo
         QkkfmJPdI7MeQBQnqt2zirp41ojwrtpuelnJT3Uwgk3UGLKwfBdDmJLfPIZtJqzifFSv
         rMoSIyTtVygXCpVHDJNBpvRXaFoqvvuL9JBjZjf/FD3tlLptBV6+dJ8RpSGFT5gWgKkn
         TdW1vEJgtdLk+DgqtAITpHO8gheN5qjVZiz0kxazHQkbTx28RTTFR7QdAnaRIQ3p1dCf
         D3LigiZZemA+zx6H1VwgfuBICIZnDpvH3T2YuIFBUeHk9Dh7uGLqSnXHrkMYax55wfMB
         9wSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQcBXhiG4WSKbf/NKH+KIteUYu6u/x6SNCEh0wAhXc4=;
        b=SLgiXPDNx1boVktndxvboGsvp92NhDxXvb77JvwJIYmCAZ3fQcRmJ9sP0LT4Zg7Qg4
         Go72iyYKBzGelUGIwUJQpqWShqE8NFJxZ+0KMtVOeG9JHEdVrX2i3xglPWgchwQb89bN
         IN+mc+3l67I/QLKkRr71L6Mma/oj/k2UakN0ir8mY3DHZtLJbBagDzla9EtQIdbHh2f+
         gJqulyUJb5th5PSALvd7JJX7p3AHo0J36WQP3QnTQQ6s3WtW2y2JiyWNkIla5sUmiSQK
         o+9AbDB16kP72BFNCGEFljoeZrqKJohYBrxxJC1YqBa/uzNwmUyCsRF61jSSmRmYGnFw
         mFbg==
X-Gm-Message-State: AOAM531Djo+57lAN3Ztpsz3n/HTooSMPhvsle/ayoIDTMLPFM4UZa8sI
        62KXWAH8W21OzNsOXpj065w=
X-Google-Smtp-Source: ABdhPJzJ28LwP1ruNR/6xg95ajBMTXpp2+a15spYOqcq7u3I/Ju4F8LD2joilelT7IoSnEVB/LmYpg==
X-Received: by 2002:a05:6402:36d:: with SMTP id s13mr29337677edw.103.1620174929306;
        Tue, 04 May 2021 17:35:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id ne17sm2103286ejc.56.2021.05.04.17.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:35:28 -0700 (PDT)
Date:   Wed, 5 May 2021 02:35:25 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH net-next v3 17/20] net: phy: phylink: permit to pass
 dev_flags to phylink_connect_phy
Message-ID: <YJHoTYfa03Yq5NwZ@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-17-ansuelsmth@gmail.com>
 <79cd97fe-02e8-4373-75a5-78ad0179c42b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79cd97fe-02e8-4373-75a5-78ad0179c42b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 03:33:36PM -0700, Florian Fainelli wrote:
> On 5/4/21 3:29 PM, Ansuel Smith wrote:
> > Add support for phylink_connect_phy to pass dev_flags to the PHY driver.
> > Change any user of phylink_connect_phy to pass 0 as dev_flags by
> > default.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> I do not think that this patch and the next one are necessary at all,
> because phylink_of_phy_connect() already supports passing a dev_flags.
> 
> That means that you should be representing the switch's internal MDIO
> bus in the Device Tree and then describe how each port of the switch
> connects to the internal PHY on that same bus. Once you do that the
> logic in net/dsa/slave.c will call phylink_of_phy_connect() and all you
> will have to do is implement dsa_switch_ops::get_phy_flags. Can you try
> that?

I did some testing. Just to make sure I'm correctly implementing this I'm
using the phy-handle binding and the phy-mode set to internal. It does
work with a quick test but I think with this implementation we would be
back to this problem [0].
(I'm declaring the phy_port to the top mdio driver like it was done
before [0])

I was thinking if a good solution would be to register a internal mdio driver
in the qca8k code so that it can use the MASTER reg.
(it's late here so I could be very confused about this)

I think that using this solution we would be able to better describe the phy
by declaring them INSIDE the switch node instead of declaring them
outside in the top mdio node. The internal mdio driver would register
with this new mdio node inside the switch node and use the custom mdio
read/write that use the MASTER reg.

[0] http://patchwork.ozlabs.org/project/netdev/patch/20190319195419.12746-3-chunkeey@gmail.com/

> -- 
> Florian
