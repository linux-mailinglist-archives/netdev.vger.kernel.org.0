Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC923D3A49
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 14:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhGWLwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 07:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbhGWLwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 07:52:10 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609FFC061575;
        Fri, 23 Jul 2021 05:32:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id v21so3525708ejg.1;
        Fri, 23 Jul 2021 05:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4eXnfuScHfsV7rofEB9joSoTQrqRx34K2n6dw7298vg=;
        b=e5jn4llumeWQi+0sxNQhQMPzQookjYlzUdSMY23eLBbxPtVxanyaetk2ULm/lEgneI
         WfQexS9Hm0CeuApBRKuwwhRoTAsiFoGgsyPQqsJhVeZPmdlt4jZjcJPxfXAGZLuR+qNu
         5u8fJ+10Gw5SNaI3yK1Pw2FU1sHwf3RIOm5Yvb4/7/xNAmf04NYxRVcvAg2vrMovCufx
         TlWjUA//v7F+OCWreXPXX9b8q1+taJDih5/NV2uztSq49zcIf/FCtRiYqTt3GtBVDpmn
         ZWYKz+BQHeTpQ8kwt344ksbaHuLlacFg+g/FgSBcADwcHON4eS5h3u95RZ5OL/KX3OYi
         3ZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4eXnfuScHfsV7rofEB9joSoTQrqRx34K2n6dw7298vg=;
        b=Ju3JLOUOfG3XrjAuPYhqZSM7QBFPhfOFOxmW7m2gLLARNGdce5c/ksHekEpJOM8jNb
         QkjemvBaOOaJAjjH19LDwFbwJLiA1nze7rTLjOtEPWsbcXEt/rgK1Vjvox80s9rlNiwM
         GhgLumPyYcaAP7qX8yYVAI+UdDr8j4SGjL36CJJ4VF71EFhG1NE6wuzcO5RE8VRaAXdk
         w2Y9nd9sdU0jMVoc/sox4fBkpki3Xz21CNKX1sPM+Q80GFWtCmUKtw5NuaE7dHTX2jQH
         f5Vezw82GTv5vGbwXCzUF3MfUIf8vZbevdYOp+IpT2XBa1vfrTKCRMJLeTABmzXYGlpJ
         baTA==
X-Gm-Message-State: AOAM530mJKNHImPk14TnvWNnl1gym74fJDvEpM+YQqUQXwNhvIf9EsRK
        jmqwkcRcZaAivGvMC0Gq4sY=
X-Google-Smtp-Source: ABdhPJyWPoe5TH3pAz1ZGvHvUd02BxjjuD1Z/PSIA7ldLGL6crGhQ5jNGVrXCWM3gKqKRq1TcbPDZg==
X-Received: by 2002:a17:906:58c9:: with SMTP id e9mr4473180ejs.144.1627043561442;
        Fri, 23 Jul 2021 05:32:41 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id dg20sm51967edb.13.2021.07.23.05.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 05:32:40 -0700 (PDT)
Date:   Fri, 23 Jul 2021 15:32:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: remove redundant re-assignment
 of pointer table
Message-ID: <20210723123239.y2b3g3gea2ku2euq@skbuf>
References: <20210722191529.11013-1-colin.king@canonical.com>
 <20210722200544.qvl3sj57qph2whrw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722200544.qvl3sj57qph2whrw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 11:05:44PM +0300, Vladimir Oltean wrote:
> Could you please also send a patch for the "net" tree with this, and the
> explanation above?
> 
> -	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
> +	table = &priv->static_config.tables[BLK_IDX_RETAGGING];

I think it's best for me to just send that patch. I will send it towards
the "stable" trees directly, to avoid all sorts of conflicts with "net"
and "net-next" (as mentioned, the VLAN retagging code is going away).

For this patch towards net-next:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
