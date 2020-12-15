Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52902DB2E4
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgLORb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:31:27 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41748 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbgLORbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:31:23 -0500
Received: by mail-oi1-f196.google.com with SMTP id 15so24190001oix.8;
        Tue, 15 Dec 2020 09:31:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f37RWrXwsiv+0EoW1Yj6ZpyoDuIYg2z238UxVLI0rTM=;
        b=L2sb5QVT7qC2Ot2R7CNRylyxMENgvde7K90D7lcRBuv0i5P7WWDZaPXW52dI7jgEj4
         G7gsrHo8fwK9dOz7FaJ3EsM4qkmJH0SxipO9BFyJ4S8RklHI+PxnK2w9jH5vjmqSkYGb
         7wHzML47NZkxXcwJp75Ieu6dcHeAo3LEIdl97ztiaX/6QDmlyw+hkNVxiwNnCuAMOgG7
         cHXf40/hbcLMDEv6iiUTMBQIKc498OlIYe7ypeXG42l8FuA8h+5J7Rl6Nv22eRyk84Xk
         mo0BrLMcPxk3TZwZy6PKP0/7P/33gxS5F5Cp1CKE7V/j2AMfXZ/TWRAeAkxX15BatdGi
         5q9g==
X-Gm-Message-State: AOAM532Ph7cpvh8FYgIUDywe28xdV9KZXicUlR+L3hJwepgXFYxk8g9c
        iXpwPRjskBjSLNAO/F/RXQ==
X-Google-Smtp-Source: ABdhPJy+h89dvJUr6gfADjtGId8WiKWymjBfz57RzC+lV7rbruhDVmEpT328hNNnZ8Hu5ffbr8zbtA==
X-Received: by 2002:aca:cd85:: with SMTP id d127mr21918090oig.59.1608053441932;
        Tue, 15 Dec 2020 09:30:41 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v17sm1517451oou.41.2020.12.15.09.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:30:41 -0800 (PST)
Received: (nullmailer pid 4072081 invoked by uid 1000);
        Tue, 15 Dec 2020 17:30:39 -0000
Date:   Tue, 15 Dec 2020 11:30:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Semin <fancer.lancer@gmail.com>,
        Lars Persson <larper@axis.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        devicetree@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 05/25] dt-bindings: net: dwmac: Elaborate stmmaceth/pclk
 description
Message-ID: <20201215173039.GA4072051@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-6-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-6-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 12:15:55 +0300, Serge Semin wrote:
> Current clocks description doesn't provide a comprehensive notion about
> what "stmmaceth" and "pclk" actually represent from the IP-core manual
> point of view. The bindings file states:
> stmmaceth - "GMAC main clock",
> apb - "Peripheral registers interface clock".
> It isn't that easy to understand what they actually mean especially seeing
> the DW *MAC manual operates with clock definitions like Application,
> System, Host, CSR, Transmit, Receive, etc clocks. Moreover the clocks
> usage in the driver doesn't shade a full light on their essence. What
> inferred from there is that the "stmmaceth" name has been assigned to the
> common clock, which feeds both system and CSR interfaces. But what about
> "apb"? The bindings defines it as the clock for "peripheral registers
> interface". So it's close to the CSR clock in the IP-core manual notation.
> If so then when "apb" clock is specified aside with the "stmmaceth", it
> represents a case when the DW *MAC is synthesized with CSR_SLV_CLK=y
> (separate system and CSR clocks). But even though the "apb" clock is
> requested in the MAC driver, the driver doesn't actually use it as a
> separate CSR clock where the IP-core manual requires. All of that makes me
> thinking that the case of separate system and CSR clocks isn't correctly
> implemented in the driver.
> 
> Let's start with elaborating the clocks description so anyone reading
> the DW *MAC bindings file would understand that "stmmaceth" is the
> system clock and "pclk" is actually the CSR clock. Indeed in accordance
> with sheets depicted in [1]:
> system/application clock can be either of: hclk_i, aclk_i, clk_app_i;
> CSR clock can be either of: hclk_i, aclk_i, clk_app_i, clk_csr_i.
> (Most likely the similar definitions present in the others IP-core
> manuals.) So the CSR clock can be tied to the application clock
> considering the later as the main clock, but not the other way around. In
> case if there is only "stmmaceth" clock specified in a DT node, then it
> will be considered as a source of clocks for both application and CSR. But
> if "pclk" is also specified in the list of the device clocks, then it will
> be perceived as the separate CSR clock.
> 
> [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
>     October 2013, p. 564.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml          | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
