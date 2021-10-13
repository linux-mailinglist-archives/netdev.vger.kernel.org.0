Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F142BC8D
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbhJMKPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbhJMKPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:15:53 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5FEC061570;
        Wed, 13 Oct 2021 03:13:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ls18so1812265pjb.3;
        Wed, 13 Oct 2021 03:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=1dUeTZLXCuNXDhj8msmYssPF3RGBm/4w14GViom8/z8=;
        b=E5P+abuumiIOCiu+ElUEX2ETeN6nH/SD0vtRth4wjleHKZv0MBERHK6yLO8UtObpBJ
         950msUkL69OFeoJpmdS6V2HkJiDagXtOYfN/mlirF7dfy++1MF6V6zewRitwv65inEJS
         nJvk/R4W6sUMDZODcvri7B5eVwLzxrq22iNnWlcAg0JWFFZYA54KudHI0vtoO+7UAM6v
         DPVjCJMdGXT4UgaObzScpHIMJhaNyB5+6daiPba5bDzHxSRNr9T2Tvwggv/OVXF51MJk
         RMRuto6NRST/UL3FsCxjpc00IZFqsRFD1xBnoodIpTDCIPZAS5yNMpCFygubXiYpbyzK
         5j2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=1dUeTZLXCuNXDhj8msmYssPF3RGBm/4w14GViom8/z8=;
        b=B5eNHjhBBtn0zL9ajqHSyloMOGXoosiccu3w7SOvvSWG22lL4RBZw0ulTl83Yj3DYC
         qfbFBkjfarCb7TdGEAWCcJ3BXWfcmlAWBaFx9ZjiAMNA4slm7d3vtg0rmw7FBFkiPMDx
         9aQNgVmnN4dRfWMnsduraUhii3aZ7tI4cVJyFnxh/TJImOV02u5a8TyE9xDBr6Q69GqJ
         SLEqzbcJdZljpogYTL0k5BwVuXG7BgXCGTEDi6aGENNpQI2DQMCJqtFJL+YZ2SC42Yuj
         EKLtVHhrnpx5bFewMP3FgoCCEkse7d11YIWEymcHq45kcr7xIXo0BxIPpwO+T/BmKNNs
         RCzA==
X-Gm-Message-State: AOAM531LEAH7D1KwlBmt6rrCqQ/Utlp+Lg8FKsUg3aVu71MNMZuMxVdc
        sg7by4g1dErdfOp5QlUU/UU=
X-Google-Smtp-Source: ABdhPJyf0XEpOl2mztCpYhNDU0671zzQu2YhtSz5vcY6u+YY2wKFQlYAaO6O+ITGmONzoFI2OC0c6A==
X-Received: by 2002:a17:90b:3749:: with SMTP id ne9mr12487858pjb.192.1634120030029;
        Wed, 13 Oct 2021 03:13:50 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id a11sm14018427pgj.75.2021.10.13.03.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:13:49 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
Date:   Wed, 13 Oct 2021 18:13:41 +0800
Message-Id: <20211013101341.56223-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <32ffccb4-ff8b-5e60-ad29-e32bcb22969f@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk> <20211012123557.3547280-6-alvin@pqrs.dk> <20211013095505.55966-1-dqfext@gmail.com> <32ffccb4-ff8b-5e60-ad29-e32bcb22969f@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 10:05:21AM +0000, Alvin Šipraga wrote:
> Andrew also suggested this, but the discontinuity in port IDs seems to 
> be an invitation for trouble. Here is an example of a series of 
> functions from dsa.h:
> 
> static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
> {
> 	struct dsa_switch_tree *dst = ds->dst;
> 	struct dsa_port *dp;
> 
> 	list_for_each_entry(dp, &dst->ports, list)
> 		if (dp->ds == ds && dp->index == p)
> 			return dp;
> 
> 	return NULL;
> }
> 
> static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
> {
> 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
> }
> 
> static inline u32 dsa_user_ports(struct dsa_switch *ds)
> {
> 	u32 mask = 0;
> 	int p;
> 
> 	for (p = 0; p < ds->num_ports; p++)
> 		if (dsa_is_user_port(ds, p))
> 			mask |= BIT(p);
> 
> 	return mask;
> }
> 
> My reading of dsa_user_ports() is that the port IDs run from 0 to 
> (ds->num_ports - 1). If num_ports is 5 (4 user ports and 1 CPU port, as 
> in my case), but the CPU is port 6, will we not dereference NULL when 
> calling dsa_is_user_port(ds, 4)?

So set num_ports to 7.

> 
> > 
> >> +
> >> +/* Chip-specific data and limits */
> 
