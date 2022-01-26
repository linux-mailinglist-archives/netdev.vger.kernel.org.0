Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B228349C271
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiAZEFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiAZEFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:05:41 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EBEC061747;
        Tue, 25 Jan 2022 20:05:40 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id k25so35508710ejp.5;
        Tue, 25 Jan 2022 20:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lMvaUNa0epuWNVjB66ksvUi4IFQlW9eBOcK2Yd36MmQ=;
        b=fwAoJX7uENLxSN7DTZ8PqBXvJvcMTediYsfnKAuesi62gHW5S0sMY3sRwYGYjOSSww
         WZHn9IqZwvqcHn7q3eGzmXnz4rw+32/rHlbgx+AEQkY1LRlWft4XVEOPCO11jc8fo2uL
         M4Qgz7ftiLcfTPFnTSO57whNdmKoZRInoRh9PQnrXAWPMiEj0ZppY0xSMK1qF6tp6x6o
         gNVCHQfoHgInaF7/90STsrZDPuI0EZ2iIfv2umu8mpsYYPA9voAz7dH7g3z+SVRvwX2K
         isdCFOGST6ABNIIupcYk5k6zsaukQ0pfsDMH54e0/06ZjwnBiagMrHGmXu2+rH7YmTkK
         YPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lMvaUNa0epuWNVjB66ksvUi4IFQlW9eBOcK2Yd36MmQ=;
        b=WALpaEdCwWlOAUeA8chZbT3n/au+9Ou0jBs58nsp0hCCKJr864V5pVzEuFORm0cvsk
         DtlDlVV7aKTJfPHwG2tT2P6VWj+C9hMmStNqnVT7WNW58hUGeU0/nVxRDaMnrBnvPWp3
         5eJklxXDleikZieQHlbJb3PlQgFC/HgCdBW0Adop0E9QPfxnJyVyHAtDUL6TByzO+Aw+
         zBmckxhJ2iSl3QhWnmQk4o+2Kbw22YkHSK9zXwQtdcq6VNeMPa+h0lhzMnhrqBSLHzUa
         TdwbARFzzJkKFfNsQtvc1BLMw0YrAlCss5XXMMLigkQ1ibIpzde7Cymw6h5FDsRLgr3k
         hUWg==
X-Gm-Message-State: AOAM5330Wt6waJGc1tWToOqNOCkucMy/cv148vTi8ERS751wESb0R/xf
        Q084MipEWwhhOKr86rCB+TQ=
X-Google-Smtp-Source: ABdhPJzpr/NO+jpBXEqcyNQbAaZSVw3yPjSTlvG+QrzbR1t7pVcEnQLFJHmx4ngn3zl+oovsJFmmQQ==
X-Received: by 2002:a17:906:9743:: with SMTP id o3mr18624064ejy.162.1643169939262;
        Tue, 25 Jan 2022 20:05:39 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id gu2sm6823228ejb.221.2022.01.25.20.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 20:05:38 -0800 (PST)
Date:   Wed, 26 Jan 2022 05:05:37 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
Message-ID: <YfDIkSpH7g+TPan0@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
 <70a44baa-4a1c-9c9e-6781-b1b563c787bd@gmail.com>
 <YfDHmpLxqUGWatQC@Ansuel-xps.localdomain>
 <ffd2326c-5b66-87d8-ad42-6dea37e290d6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffd2326c-5b66-87d8-ad42-6dea37e290d6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 08:02:53PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/25/2022 8:01 PM, Ansuel Smith wrote:
> > On Tue, Jan 25, 2022 at 07:54:15PM -0800, Florian Fainelli wrote:
> > > 
> > > 
> > > On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> > > > Add all the required define to prepare support for mgmt read/write in
> > > > Ethernet packet. Any packet of this type has to be dropped as the only
> > > > use of these special packet is receive ack for an mgmt write request or
> > > > receive data for an mgmt read request.
> > > > A struct is used that emulates the Ethernet header but is used for a
> > > > different purpose.
> > > > 
> > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > ---
> > > 
> > > [snip]
> > > 
> > > > +/* Special struct emulating a Ethernet header */
> > > > +struct mgmt_ethhdr {
> > > > +	u32 command;		/* command bit 31:0 */
> > > > +	u32 seq;		/* seq 63:32 */
> > > > +	u32 mdio_data;		/* first 4byte mdio */
> > > > +	__be16 hdr;		/* qca hdr */
> > > > +} __packed;
> > > 
> > > Might be worth adding a BUILD_BUG_ON(sizeof(struct mgmt_ethhdr) !=
> > > QCA_HDR_MGMT_PKG_LEN) when you start making use of that structure?
> > 
> > Where should I put this check? Right after the struct definition,
> > correct? (I just checked definition of the macro)
> 
> It would have to be in a call site where you use the structure, I have not
> checked whether putting it in a static inline function in .h file actually
> works if the inline function is not used at all.

Think I can test that by just putting a wrong value in
QCA_HDR_MGMT_PKG_LEN and check if the error is triggered.
Will check if the macro will actually work. 

> -- 
> Florian

-- 
	Ansuel
