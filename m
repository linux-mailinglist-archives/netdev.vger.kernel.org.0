Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12050414E0A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbhIVQ0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 12:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 12:26:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8D8C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 09:24:46 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v10so7385627edj.10
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 09:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rYx9tpV+Ej9Q++kgzks0EzOx0Y+3Lur5m1197OCQNr0=;
        b=V0jnq054Eh/HYG+o4JOhMyRahZ/TSn/+TWlgT42s394CdPnZIok9PjNNMgMiUXJNe+
         D4WkURNzF8kDJExnpyuQ4Cl542D9o+ShIvlhe9pPSSuGnnlg7vGtCQkIHDflFQoLYtdh
         TV/VCn53wBornw2MK9dldfkHQTBMasDPQEFuL1+Efm4/LmGpRm23654oW/ZOJnntztFp
         OdHhhRBbXgZJ9yrDtEGw0hpPAd2U72AQHls7GA3Oi322o3jaS9ovw12d/wCWdUwpB+i/
         pwxYtD6d8mpdJxdFUk2IZ8fGph6P442ekMLlAbiHX6MQqG1PIudPWQQqNGEeiqdpKHBw
         waGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rYx9tpV+Ej9Q++kgzks0EzOx0Y+3Lur5m1197OCQNr0=;
        b=NiRK1TaG4poeWJ4/FXSwS1ZPZKHRD0bqyrDs8HHmFzzvy4guOtaWNm2Btl70Xgn79+
         H2SGk5GzXmUzMDnDm/eRZYYPm3MBZbs7cp9vXnmorK8Es7Fw6nCnmXcUJ3wxWHDeOhri
         AGL8LB/JTyUEI4nHXlqvt64/X8rvHG70U8DJAKdXrApfq0i6EJO0YSM5LX4ySRTzFu/n
         BTJUfLquHDjxzEh1CRq3+jnEhmdJ5lDeWRR6AabkV0RMHCF+PnFuWtzrCBK9A5rq3n4N
         EQ2jxvr/+yEOtBftB2qMZ9tKW9zid7ZAKUTKWl/zxj+24asYhrFLPVoAqtm2d/sC80OW
         vI0Q==
X-Gm-Message-State: AOAM531enMYl9LiRty7NwG6Ss5TjmEA0RgREoX4kB4AfALLM1iapk6qt
        HXeCCKnYJxUpCeUfDcvK626q3xXjoOQ=
X-Google-Smtp-Source: ABdhPJzOWWDrlEt6O7aTx7/suZsojTaaXIi9HFP5bV6Vt+A98CGmQ3Tpv6XAw1VMpOZXhlrrPZyVYQ==
X-Received: by 2002:a17:906:cc0e:: with SMTP id ml14mr417242ejb.395.1632327884893;
        Wed, 22 Sep 2021 09:24:44 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id t4sm1532665edc.2.2021.09.22.09.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:24:44 -0700 (PDT)
Date:   Wed, 22 Sep 2021 19:24:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dsa: sja1105: stop using priv->vlan_aware
Message-ID: <20210922162443.rdwyp4phk6cwpmm3@skbuf>
References: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 05:44:01PM +0300, Vladimir Oltean wrote:
> +	if (!dsa_port_is_vlan_filtering(ds, port) &&

omg, what did I just send....
I amended the commit a few times but forgot to format-patch it again.
The dsa_port_is_vlan_filtering prototype takes a "dp" argument, this
patch doesn't even build. Please toss it to the bin where it belongs.
