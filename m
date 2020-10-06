Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8940E285041
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJFQ5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFQ5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:57:43 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECF5C061755;
        Tue,  6 Oct 2020 09:57:41 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id qp15so18670732ejb.3;
        Tue, 06 Oct 2020 09:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GJ3BhH33jimFHyih/N7AY4tXkM7p8UBTJJ+fLzw3IMg=;
        b=HjPnohUQPVltGOeuFvHs/G/eBQqv8qdw+ndMMAEIEhh0Da+fr/fbmlClQ5BfSacRjq
         Dbts7YKOE5ij2TxRyXkKgtZu+bBObqYMo7wHme+mYGzyBSe2RzPFadtePY+EWXvh30ZW
         edexQCRMxiG71yF2evJAaTjzYdw0jjbNaGcmbrfup++qSIqyv3cMaQhdPvnVakBfpLkH
         wylEueiMqojbwWYCTXMYzFwoIK7aSoY4Xuadz3IuFwH5rODZOzyiRLjnEdeTRFCSZo9l
         PxpTNSEw4ruvsNiIw4OWzAqrGpOVFSyAdigBr1gAAGUTL8+FEhne1qxEVVun8WW5IReD
         wZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GJ3BhH33jimFHyih/N7AY4tXkM7p8UBTJJ+fLzw3IMg=;
        b=KNs1JDJ1N5LYj4A+R4KD6WHSOZTVNxxWokWf8Tdxwc72MAYC7hy2UME4xU47p8t44m
         rCW7YAXe4AKoMZJ5GZRGnSy5WVOogQvKGGy5dN8223oam+L/2+eE/xaq26EfERl4ql4I
         nxAQUFDJW8d63bFzZbpZoWlY4X6w7JSlp+ev3I71yEMyL/T2+y2P4NQ+DnJtQr21nv5s
         y7qDp7q5roNRrkWd9mikWcnZiCe1Ldsfj8OiHCCrsLmPoBTMACZ2y4pxcf9QNf6Rct8y
         M5fRLC9QPNHUvU3D209guO9F7xm7VdmhEsAHsBqfVbxv9zOUmjhNjUkefl5cumU/IPPx
         ARfg==
X-Gm-Message-State: AOAM533FrRspJAtMqexn+aKI4HpWZKruSBFepGTG3695Ij5BmUXznbul
        i0PPju8HeAtlmw53rKahITE=
X-Google-Smtp-Source: ABdhPJys+u9QrGhclIfTpXuQY7ohw8Y+Df14qsRlJvuGAJLe+Py+Sfy4GQcFRjRi1uFFrbsen+sKMw==
X-Received: by 2002:a17:906:a00c:: with SMTP id p12mr513027ejy.10.1602003460186;
        Tue, 06 Oct 2020 09:57:40 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id p2sm2540371ejd.34.2020.10.06.09.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 09:57:39 -0700 (PDT)
Date:   Tue, 6 Oct 2020 19:57:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net v2] net: dsa: microchip: fix race condition
Message-ID: <20201006165738.lcvca2ujwqehmopp@skbuf>
References: <20201006155651.21473-1-ceggers@arri.de>
 <20201006162125.ulftqdiufdxjesn7@skbuf>
 <1774255.9Jiduhijpd@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1774255.9Jiduhijpd@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 06:30:57PM +0200, Christian Eggers wrote:
> If think that ksz_switch_remove() will not be called at all if there is an
> error in the probe path.

Indeed.

> In all other cases, the work should be queued.

In that case, it looks like the "if" condition can be removed in a
further patch, because it is now unnecessary. Please be sure to test
that though.
