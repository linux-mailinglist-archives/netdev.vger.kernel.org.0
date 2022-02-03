Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6414A841F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244856AbiBCMxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiBCMxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:53:37 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC175C061714;
        Thu,  3 Feb 2022 04:53:36 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id h7so8587725ejf.1;
        Thu, 03 Feb 2022 04:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bDH9Nk0+/o9mu2Zgni8eu8F6PQOKs9CYbDD3SvAHg8A=;
        b=XEbXPW9KabqAF3OHMNpKhGUnfjAi6TBWYOnpFQS4Qc6f/uXr2FWlZjLROnjc/Vcw79
         Ox1N7aLBYBG9RzZLUGdpR4QJmvZxhVbWyxBV8kpq8plQMZaxykSKAkW+PkUqxE1pe5lb
         VZKP3L8r1/VFNrzX5w6yJzcAIumgTIf6WjboojHnG5AbVHSH93Cg4KfQiv5ujxME4fUB
         f4i/XVwkBhHB7PDcuBgWn7XjWCA3okBfBqQlbBrf/Hb9/5YjE4kEK/OaSTu55ViArPBv
         Dn3J3jqVxORlOSZinimMRQg2ff93TeTDw4AwIfto0ZFKHRLj7qwhaX3ECmo0prFXKiXu
         7UZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bDH9Nk0+/o9mu2Zgni8eu8F6PQOKs9CYbDD3SvAHg8A=;
        b=pBk3uY0BEcMWyRL3BdKxrOwFwRIFETH46AtVcRgCnao1lGzwhWReAgo9cZyhz/KY9K
         eFCmkmsrrEjhrAuB4o/JnKGKnIkNvGrFByupsES0cubQzf8FIWTiY+Gpfw5N5mXIfcoq
         7OpIkVimVCxTrMPJzI4K/bqarXvHsQtPotZChUKYebZHMgwIJzY8bpiu32c5fY8lgJEP
         CmcgyZJDkFldj1nxaRH8z9vTUwy4cNU+Lc83EkEIEDGLl8RiCw8uwTZZoZkJYjNNDVah
         vzRpHnUl9swWJKmpiOL/fQvlFnkTDfsP/u3TZAr7vDloyGtzUf0bw6tRJPmP0UJ5Tlma
         L4Uw==
X-Gm-Message-State: AOAM530s9EIREZ6YCVTRHp3WrnO40bdwzyKMozhJAP2UjY5KvXXBla0J
        2RPQq/QIj5sVTz8mQ9wtN8I=
X-Google-Smtp-Source: ABdhPJxMhYsIAPnM9xbeZ03tbimYEosXOSoqgAl1R/iWmgu5qN4zQVs87oCvzh/0WbouCUlAUPTQqA==
X-Received: by 2002:a17:907:6da1:: with SMTP id sb33mr28868085ejc.18.1643892815436;
        Thu, 03 Feb 2022 04:53:35 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id h19sm15752224edv.90.2022.02.03.04.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:53:34 -0800 (PST)
Date:   Thu, 3 Feb 2022 14:53:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/5] net: dsa: mv88e6xxx: Improve multichip
 isolation of standalone ports
Message-ID: <20220203125333.swap2es7rt4gt2yl@skbuf>
References: <20220203101657.990241-1-tobias@waldekranz.com>
 <20220203101657.990241-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203101657.990241-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 11:16:56AM +0100, Tobias Waldekranz wrote:
> Given that standalone ports are now configured to bypass the ATU and
> forward all frames towards the upstream port, extend the ATU bypass to
> multichip systems.
> 
> Load VID 0 (standalone) into the VTU with the policy bit set. Since
> VID 4095 (bridged) is already loaded, we now know that all VIDs in use
> are always available in all VTUs. Therefore, we can safely enable
> 802.1Q on DSA ports.
> 
> Setting the DSA ports' VTU policy to TRAP means that all incoming
> frames on VID 0 will be classified as MGMT - as a result, the ATU is
> bypassed on all subsequent switches.
> 
> With this isolation in place, we are able to support configurations
> that are simultaneously very quirky and very useful. Quirky because it
> involves looping cables between local switchports like in this
> example:
> 
>    CPU
>     |     .------.
> .---0---. | .----0----.
> |  sw0  | | |   sw1   |
> '-1-2-3-' | '-1-2-3-4-'
>   $ @ '---'   $ @ % %
> 
> We have three physically looped pairs ($, @, and %).
> 
> This is very useful because it allows us to run the kernel's
> kselftests for the bridge on mv88e6xxx hardware.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
